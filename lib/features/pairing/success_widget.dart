import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/success_list_data.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/ui/animated_icon.dart';
import 'package:pairsonic/helper/ui/hint_text_card.dart';
import 'package:pairsonic/router/app_routes.dart';

import 'user_list_card.dart';

/// Widget displayed when the group pairing was sucessfull.
///
/// Also displays the newly added users/contacts.
///
/// {@category Widgets}
class PairingSuccessWidget extends StatefulWidget {
  final SuccessListData _data;
  final Function disposeState;

  const PairingSuccessWidget(this._data, this.disposeState, {super.key});

  @override
  State<PairingSuccessWidget> createState() =>
      _PairingSuccessWidgetState(_data, disposeState);
}

class _PairingSuccessWidgetState extends State<PairingSuccessWidget> {
  final SuccessListData _data;
  final Function _disposeState;

  _PairingSuccessWidgetState(this._data, this._disposeState);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _disposeState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var receivedUids = _data.receivedUsers.keys.toList()..remove(_data.ownUid);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (!await _data.canPopNavigation(context)) {
          return;
        }
        await _data.importSelected();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizeAnimatedIcon(
                      beginSize: 0,
                      endSize: 80,
                      duration: Duration(milliseconds: 700),
                      iconData: Icons.check_circle,
                      iconColor: Colors.green,
                      autostart: true),
                  const SizedBox(width: 10),
                  Text(S.of(context).groupPairingSuccess,
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_data.selectedUids.isEmpty) {
                          _data.selectedUids.addAll(receivedUids);
                        } else {
                          _data.selectedUids.clear();
                        }
                      });
                    },
                    child: Text(_data.selectedUids.isEmpty
                        ? S.of(context).groupPairingSuccessSelectAll
                        : S.of(context).groupPairingSuccessUnselectAll)),
              ),
              const SizedBox(height: 12),
              Expanded(
                  child: ListView.builder(
                      itemCount: receivedUids.length,
                      itemBuilder: (context, index) {
                        final uid = receivedUids[index];
                        var u = _data.receivedUsers[uid]!;

                        return UserListCard(
                            u: u,
                            isSelected: _data.selectedUids.contains(uid),
                            onTap: () {
                              setState(() {
                                if (_data.selectedUids.contains(uid)) {
                                  _data.selectedUids.remove(uid);
                                } else {
                                  _data.selectedUids.add(uid);
                                }
                              });
                            });
                      })),
              const SizedBox(height: 12),
              HintTextCard(S.of(context).groupPairingSuccessText),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.close_rounded),
                          onPressed: () async {
                            if (!await _data.canPopNavigationFromCancel(context)) {
                              return;
                            }
                            Navigator.of(context, rootNavigator: true).popUntil(
                                    (route) =>
                                route.settings.name == AppRoutes.homePage);
                          },
                          label:
                              Text(S.of(context).groupPairingSuccessCancel))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: FilledButton.icon(
                        icon: Icon(Icons.check_rounded),
                          onPressed: () async {
                            if (!await _data.canPopNavigation(context)) {
                              return;
                            }
                            await _data.importSelected();
                            Navigator.of(context, rootNavigator: true).popAndPushNamed(AppRoutes.contacts);
                          },
                          label:
                              Text(S.of(context).groupPairingSuccessAddContacts))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
