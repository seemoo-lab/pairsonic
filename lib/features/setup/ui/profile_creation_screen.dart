import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/ui/profile_widget.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/helper/ui/button_row.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/service_locator.dart';

/// If the app is started the first time, users can create their profile here and read some introduction.
/// Can be shown later from [SettingsScreen] after first App start.
/// {@category Screens}
class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _localDatabaseService = getIt<GuiUtilityInterface>();
  final IdentityService _identityService = getIt<IdentityService>();
  final bool _isEditing = true;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = _identityService.self.name.isEmpty || _identityService.self.bio.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).profileCreationTitle), //Introduction Text
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                        Text(
                          S.of(context).profileCreationHintText,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ProfileWidget(
                        _identityService.self,
                        edit: _isEditing,
                        editMode: _isEditing,
                        onInput: (name, bio) {
                          setState(() {
                            if (name.isNotEmpty && bio.isNotEmpty) {
                              _isButtonDisabled = false;
                            } else {
                              _isButtonDisabled = true;
                            }
                          });
                        }),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ButtonRow(
                primaryText: S.of(context).generalButtonDone,
                primaryIcon: Icons.arrow_forward_rounded,
                primaryAction: _isButtonDisabled ? null : (context) async {
                  await _localDatabaseService.insertOrUpdateUser(_identityService.self, allowSelf: true);
                  _identityService.setOrUpdateProfile(_identityService.self);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
                  }
                },
                secondaryText: S.of(context).generalButtonBack,
                secondaryIcon: Icons.arrow_back_rounded,
                secondaryAction: (context) => Navigator.of(context).pop(),
              ),
            ),
          ],
        ));
  }
}
