import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/helper/ui/gui_constants.dart';
import 'package:pairsonic/service_locator.dart';

class SuccessListData {
  Map<int, User> receivedUsers;
  int ownUid;
  Set<int> selectedUids = {};

  final _localStorageService = getIt<GuiUtilityInterface>();

  SuccessListData(this.receivedUsers, this.ownUid);

  Future<bool> canPopNavigationFromCancel(BuildContext context) async {
    return await _reallyPopDialog(context);
  }

  Future<bool> canPopNavigation(BuildContext context) async {
    return selectedUids.isNotEmpty || await _reallyPopDialog(context);
  }

  Future<void> importSelected() async {
    for (final uid in selectedUids) {
      await _localStorageService.insertOrUpdateUser(receivedUsers[uid]!);
    }
  }

  Future<bool> _reallyPopDialog(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(selectedUids.isEmpty ? S.of(context).groupPairingSuccessNoSelectionAlertTitle : S.of(context).groupPairingSuccessCancelAlertTitle),
                content: Text(S
                    .of(context)
                    .groupPairingSuccessNoSelectionAlertText),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: GuiConstants.destructiveButtonStyle,
                      child: Text(S.of(context).groupPairingSuccessNoSelectionAlertButtonDestructive)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(S.of(context).groupPairingSuccessNoSelectionAlertButtonAction)),
                ],
              );
            }) ??
        false;
  }
}
