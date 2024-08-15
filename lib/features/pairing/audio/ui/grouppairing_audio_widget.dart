import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pairsonic/constants.dart';
import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_audio_routes.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_protocol.dart';
import 'package:pairsonic/features/pairing/audio/interfaces/audio_channel_interface.dart';
import 'package:pairsonic/features/pairing/audio/interfaces/grouppairing_communication_interface.dart';
import 'package:pairsonic/features/pairing/audio/services/audio_control_service.dart';
import 'package:pairsonic/features/pairing/audio/services/ggwave_audio_channel_service.dart';
import 'package:pairsonic/features/pairing/success_list_data.dart';
import 'package:pairsonic/features/pairing/success_widget.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/helper/ui/gui_constants.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pairsonic/generated/l10n.dart';

import 'grouppairing_audio_widgets.dart';

/// Ensure that the user has granted access to the permission [perm].
/// When the user denies, a dialog is shown asking the user to grant the permission.
Future<void> ensurePermission(BuildContext context, Permission perm,
    String description, String appSettings) async {
  if (!await perm.isGranted) {
    // This already shows the platform native dialog requesting access.
    // The user may choose to deny access. In this case, the app will
    // display a custom dialog and redirect the user to tha app settings.
    var status = await perm.request();
    if (!status.isGranted && context.mounted) {
      bool res = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text(S.of(context).permissionRequiredDialogTitle),
                  content: Text(description),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(S.of(context).dialogButtonCancel)),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                        },
                        child: Text(S.of(context).dialogButtonGrant))
                  ]));
      if (res) {
        var didAppSettingsOpen = await openAppSettings();
        if (!didAppSettingsOpen && context.mounted) {
          await showDialog(
              context: context,
              builder: (builder) => AlertDialog(
                    title: Text(S.of(context).permissionRequiredDialogTitle),
                    content: Text(appSettings),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(S.of(context).dialogButtonOK))
                    ],
                  ));
        }
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

/// The state of the group pairing process.
/// The state is kept by the [GroupPairingWidget] and is then
/// used by the various group pairing widgets.
///
/// The state stores information like the user data to be shared,
/// the instance of the [AudioChannelServer],
/// the [GroupPairingCommunicationInterface] implementation used, and the
/// settings made by the coordinator.
/// This allows, to be able to restart the group pairing process without
/// having to re-enter the coordinator settings.
class GroupPairingUIState {
  final String userData;
  bool? isCoordinator;
  GroupPairingCommunicationInterface? _comm;
  AudioChannelService<Uint8List> channel;
  GroupPairingProtocol<User>? _protocol;
  GPCoordinatorSettings? coordinatorSettings;
  int? _storedVolume;

  FailureMode fm = FailureMode.standard;

  /// Whether the users device can reach the centralized server
  final GroupPairingConnectivityStatus _connectivityStatus =
      GroupPairingConnectivityStatus.unknown;

  /// This function is called when the connectivity status changes
  Function()? onConnectivityStatusChanged;

  GroupPairingUIState({required this.channel, required this.userData});
  GroupPairingCommunicationInterface? get comm => _comm;

  set comm(GroupPairingCommunicationInterface? newComm) {
    assert(_comm == null);
    _comm = newComm;
  }

  /// The publically accesible [connectivityStatus] is read-only.
  GroupPairingConnectivityStatus get connectivityStatus => _connectivityStatus;

  GroupPairingProtocol<User>? get protocol => _protocol;

  /// When setting the protocol for the [GroupPairingUIState],
  /// the [GroupPairingUIState] will register itself as a listener
  /// for the onCommunicationChange event.
  /// This is, because when the user is not the coordinator, the protocol
  /// instantiates the [GroupPairingCommunicationInterface] itself, bypassing
  /// [GroupPairingUIState].
  set protocol(GroupPairingProtocol<User>? newProtocol) {
    if (newProtocol != null) {
      newProtocol.onCommunicationChange = (newComm) => _comm = newComm;
    }
    _protocol = newProtocol;
  }

  /// Configure the audio settings of the device, namely:
  /// - set the audio volume to XX% (and backup the current volume)
  /// - request audio focus
  ///
  /// The function returns whether the audio settings were successfully configured.
  Future<bool> configureAudio(bool setVolume) async {
    if (setVolume && _storedVolume == null) {
      _storedVolume = await AudioControlService.getCurrentVolume();
    }

    var res = setVolume
        ? await AudioControlService.setVolume(
            (0.75 * await AudioControlService.getMaxVolume()).toInt())
        : true;

    return await AudioControlService.requestFocus() && res;
  }

  /// Disposes all elements of this [GroupPairingUIState].
  Future<void> dispose() async {
    List<Future<void>> futures = [];
    if (_comm != null) {
      futures.add(_comm!.dispose());
    }
    if (channel.isReceiving) {
      futures.add(channel.stopReceiving());
    }
    futures.add(_restoreAudio());

    await Future.wait(futures);
  }

  /// Reset all elements of the [GroupPairingUIState].
  /// This is needed when the group pairing process is retried.
  Future<void> reset() async {
    List<Future<void>> futures = [];
    if (_comm != null) {
      futures.add(_comm!.dispose());
    }
    // Stop the audio channel from receiving, otherwise
    // the next call to startReceiving will fail.
    if (channel.isReceiving) {
      futures.add(channel.stopReceiving());
    }
    futures.add(_restoreAudio());
    await Future.wait(futures);
    _comm = null;
  }

  Future<bool> _restoreAudio() async {
    if (_storedVolume == null) {
      return true;
    }
    var res = await AudioControlService.setVolume(_storedVolume!) &&
        await AudioControlService.abandonFocus();
    _storedVolume = null;
    return res;
  }
}

/// An enum representing whether the user is connected to the Internet or not.
enum GroupPairingConnectivityStatus { unknown, internet, offline }

/// The main widget of group pairing. A sub-navigator is used to
/// display the different widget of the group pairing process.
///
/// {@category Widgets}
class GroupPairingAudioWidget extends StatefulWidget {
  final Sink<double> _pairingProgressSink;

  GroupPairingAudioWidget(this._pairingProgressSink, {super.key});

  @override
  State<GroupPairingAudioWidget> createState() =>
      _GroupPairingAudioWidgetState(_pairingProgressSink);
}

class _GroupPairingAudioWidgetState extends State<GroupPairingAudioWidget> {
  late GroupPairingUIState _uiState;
  final _subNavigatorKey = GlobalKey<NavigatorState>();
  final _subNavigatorRouteTracker = _RouteTracker();
  final Sink<double> _pairingProgressSink;

  _GroupPairingAudioWidgetState(this._pairingProgressSink);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (await _onWillPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _initUiState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Navigator(
                  key: _subNavigatorKey,
                  onGenerateRoute: _onGenerateRoute,
                  observers: [_subNavigatorRouteTracker]);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _uiState.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Callback used to check that the microphone and location permissions are granted.
    // If not, a prompt is shown.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ensurePermission(
          context,
          Permission.locationWhenInUse,
          S.of(context).locationPermissionRequiredDialogDescription,
          S.of(context).locationPermissionRequiredPromptOpenAppSettings);

      if (!context.mounted) {
        return;
      }

      await ensurePermission(
          context,
          Permission.microphone,
          S.of(context).microphonePermissionRequiredDialogDescription,
          S.of(context).microphonePermissionRequiredPromptOpenAppSettings);
    });
  }

  /// Initialize the [_uiState] object.
  ///
  /// [_uiState] is used to store the configured elements of group pairing
  /// and provides them to the different widgets. This is also used
  /// to persist the state when the user retries group pairing
  /// (because of an error).
  ///
  /// In this case, the user data is loaded from the local storage.
  Future<void> _initUiState() async {
    var identityService = getIt<IdentityService>();
    var localDatabaseService = getIt<GuiUtilityInterface>();
    var settingsService = getIt<SettingsService>();
    var id = await identityService.deviceId;
    User user = await localDatabaseService.getUserDetails(id);

    var profile = (settingsService.getBool("gpUseUltrasound") ?? false)
        ? AudioChannelProfile.ultrasonic
        : AudioChannelProfile.audible;
    GgwaveAudioChannelService audioChannelService;
    switch (settingsService.getString("gpAudioChannelBackend") ?? "") {
      default:
        audioChannelService = GgwaveAudioChannelService(profile: profile);
        break;
    }
    _uiState = GroupPairingUIState(
        channel: audioChannelService, userData: jsonEncode(user.toMap()));

    var fModeS = getIt<SettingsService>().getString("PairingFailureMode") ??
        FailureMode.standard.name;

    var fm = FailureMode.values.firstWhere((e) => e.name == fModeS);

    switch (fm) {
      case FailureMode.standard:
        _uiState.fm = FailureMode.standard;
        break;
      case FailureMode.failAlways:
        _uiState.fm = FailureMode.failAlways;
        break;
    }
  }

  SuccessListData? _successListData;

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case "/":
      case GroupPairingAudioRoutes.roleSelection:
        page = GPRoleSelectionWidget(uiState: _uiState);
        break;
      case GroupPairingAudioRoutes.coordinatorSetup:
        page = GPCoordinatorSetupWidget(uiState: _uiState, progressSink: _pairingProgressSink);
        break;
      case GroupPairingAudioRoutes.running:
        page = GPRunningWidget(uiState: _uiState, progressSink: _pairingProgressSink);
        break;
      case GroupPairingAudioRoutes.error:
        page = GPErrorWidget(uiState: _uiState);
        break;
      case GroupPairingAudioRoutes.success:
        final data = SuccessListData(_uiState._protocol!.receivedUserData, _uiState.protocol!.ownUid);
        _successListData = data;
        page = PairingSuccessWidget(data, () async => await _uiState.dispose());
        break;
      default:
        page = Text("Unknown page '${settings.name}'");
    }

    return MaterialPageRoute<dynamic>(
        builder: (context) => page, settings: settings);
  }

  /// Called whenever the user requests to leave the widget.
  Future<bool> _onWillPop() async {
    if (_subNavigatorRouteTracker.currentRoute == null) {
      return true;
    }

    // handle differently depending on the current rout:
    switch (_subNavigatorRouteTracker.currentRoute!.settings.name) {
      case GroupPairingAudioRoutes.running:
        return await _reallyPopDialog();

      case GroupPairingAudioRoutes.coordinatorSetup:
        _subNavigatorKey.currentState!.pop();
        _pairingProgressSink.add(0.05);
        return false;

      case  GroupPairingAudioRoutes.success:
        if (await _successListData?.canPopNavigation(context) ?? false) {
          await _successListData?.importSelected();
          return true;
        } else {
          return false;
        }

      case "/":
      case GroupPairingAudioRoutes.roleSelection:
      case GroupPairingAudioRoutes.error:
        return true;

      default:
        throw Exception("Unknown route when sub navigator popped.");
    }
  }

  /// Asks for user confirmation before leaving the current widget
  /// as this would cancel group pairing.
  ///
  /// Returns the users choice.
  Future<bool> _reallyPopDialog() async {
    return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(S.of(context).confirmationDialogTitle),
                content: Text(S
                    .of(context)
                    .leaveGroupPairingConfirmationDialogDescription),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: GuiConstants.destructiveButtonStyle,
                      child: Text(S.of(context).dialogButtonLeave)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(S.of(context).dialogButtonStay)),
                ],
              );
            }) ??
        false;
  }
}

/// A helper class that tracks all changes to a route
/// and stores the currently active route.
class _RouteTracker extends RouteObserver {
  /// The route currently active in the observed
  /// navigator.
  Route? currentRoute;

  @override
  void didPop(Route route, Route? previousRoute) {
    _newRoute(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _newRoute(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _newRoute(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _newRoute(newRoute);
  }

  void _newRoute(Route? route) {
    currentRoute = route;
  }
}
