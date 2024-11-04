import 'package:flutter/material.dart';
import 'package:pairsonic/constants.dart';
import 'package:pairsonic/features/pairing/pairing_arguments.dart';
import 'package:pairsonic/features/pairing/pairing_screen.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/service_locator.dart';
import 'bottom_info_widget.dart';
import 'profile_widget.dart';

/// This screen shows any profile (own or other) and can be configured by state variables [editable], [showVerification], [userId] (User to be shown).
///
/// {@category Screens}
class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key,
        this.editable = true,
        this.showVerification = false,
        this.userId = "",
        this.pairingArguments});
  final bool editable;
  final bool showVerification;
  final String userId;
  final PairingArguments? pairingArguments;

  @override
  State<ProfileScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<ProfileScreen> {
  final _identityService = getIt<IdentityService>();
  final _localDatabaseService = getIt<GuiUtilityInterface>();
  final _settingsService = getIt<SettingsService>();
  late User _user;
  late bool _editable = false;
  late bool _showVerification;
  late ProfileWidget profileWidget;

  late String _id = widget.userId;

  @override
  void initState() {
    super.initState();
    _editable = widget.editable;
    _showVerification = widget.showVerification;
  }

  @override
  Widget build(BuildContext context) {
    var profilePairingMethod = PairingMethodHelper.fromShortString(
        _settingsService.getString("profilePairingMethod")) ??
        PairingMethod.groupAudio;
    FutureBuilder fb;
    if (_id.isNotEmpty) {
      fb = profileWidgetBuilder();
    } else {
      fb = FutureBuilder<String>(
        future: _identityService.deviceId,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _id = snapshot.data!;
            return profileWidgetBuilder();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    if (_editable) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).profile),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PairingScreen(
                      pairingArgs: PairingArguments(
                        method: profilePairingMethod,
                        args: {"allowScan": false, "user": null},
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(profilePairingMethod.getIcon()),
            ),
          ],
        ),
        body: fb,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).profile),
        ),
        body: fb,
        bottomNavigationBar: const BottomInfoWidget(),
      );
    }
  }

  FutureBuilder<User> profileWidgetBuilder() {
    return FutureBuilder<User>(
      future: _localDatabaseService.getUserDetails(_id),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          _user = snapshot.data!;
          return profileWidget = ProfileWidget(
            _user,
            edit: _editable,
            showVerification: _showVerification,
            pairingArguments: widget.pairingArguments,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
