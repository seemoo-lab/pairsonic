import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/constants.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/service_locator.dart';

import 'audio/ui/grouppairing_audio_widget.dart';
import 'pairing_arguments.dart';
import 'pairing_success_screen.dart';

/// The Paring Screen to exchange / verify user profiles.
/// The screen can use different implementations of [Widget] similar to [pairingWidget] based on the settings in [SettingsService] which can be set in [SettingsScreen].
/// Currently only [QrPairingWidget] is used.
/// {@category Screens}
class PairingScreen extends StatefulWidget {
  final PairingArguments? pairingArgs;

  const PairingScreen({super.key, this.pairingArgs});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  var identityService = getIt<IdentityService>();
  var storageService = getIt<GuiUtilityInterface>();
  late PairingMethod _method;
  late PairingArguments? _args;

  final StreamController<double> _pairingProgressStream = StreamController();
  final StreamController<String> _appBarTitleStream = StreamController();

  @override
  void initState() {
    super.initState();
    _args = widget.pairingArgs;
    _method =
        _args != null ? _args!.method : PairingMethodHelper.fromSettings();
    _pairingProgressStream.sink.add(0.05);
    // _appBarTitleStream.sink.add(_method.readableName(context));
  }

  _PairingScreenState();

  Future<bool> receivedPairingData(String? pairingData,
      {PairingArguments? pairingArguments}) async {
    PairingData? receivedPairingData;
    try {
      if (pairingData != null) {
        debugPrint("Received Pairing data:$pairingData");
        var decoded = jsonDecode(pairingData);
        receivedPairingData = PairingData.fromJson(decoded!);
      }
    } catch (e) {
      debugPrint("Pairing import failed: $e");
    }
    if (receivedPairingData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).pairingImportFailed)));
      return false;
    }
    storageService.addOrVerifyUser(receivedPairingData);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       S.of(context).verifiedName(receivedPairingData.name),
    //     ),
    //   ),
    // );
    if (pairingArguments == null) {
      Navigator.pop(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PairingSuccessScreen(
          receivedPairingData!.deviceId,
          pairingArguments: pairingArguments,
        ),
      ),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget pairingWidget = getPairingWidget();
    return StreamBuilder<String>(
        stream: _appBarTitleStream.stream,
        builder: (context, appBarTitleSnapshot) {
          return StreamBuilder<double>(
              stream: _pairingProgressStream.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final progress = snapshot.data!;
                return Scaffold(
                  body: pairingWidget,
                  appBar: AppBar(
                    title: Text(appBarTitleSnapshot.data ?? _method.readableName(context)),
                    bottom: progress > 0.0 ? PreferredSize(
                      preferredSize: const Size.fromHeight(6.0),
                      child: LinearProgressIndicator(
                        value: progress,
                      ),
                    ) : const PreferredSize(
                        preferredSize: Size.zero, child: SizedBox.shrink()),
                  ),
                );
              }
          );
        }
    );
  }

  Widget getPairingWidget() {
    Widget pairingWidget;
    switch (_method) {
      case PairingMethod.groupAudio:
        pairingWidget = GroupPairingAudioWidget(_pairingProgressStream.sink, _appBarTitleStream.sink);
        break;
      default:
        throw Exception("PairingScreen_Default_Hit");
    }
    return pairingWidget;
  }
}
