import 'package:flutter/material.dart';
import 'package:pairsonic/constants.dart';
import 'package:pairsonic/features/profile/ui/profile_screen.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/service_locator.dart';

import 'pairing_arguments.dart';
import 'pairing_screen.dart';

class PairingSuccessScreen extends StatefulWidget {
  const PairingSuccessScreen(this.userId, {this.pairingArguments, super.key});
  final String userId;
  final PairingArguments? pairingArguments;

  @override
  State<PairingSuccessScreen> createState() => _PairingSuccessScreenState();
}

class _PairingSuccessScreenState extends State<PairingSuccessScreen> {
  final _localDatabaseService = getIt<GuiUtilityInterface>();

  // late Timer timer;

  void navigate() {
    // timer.cancel();
    // Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: widget.userId,
          editable: false,
          showVerification: true,
        ),
      ),
      ModalRoute.withName(AppRoutes.homePage),
    );
  }

  @override
  void initState() {
    super.initState();
    // timer = Timer(const Duration(seconds: 4), () => navigate());
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: navigate,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  flex: 4,
                  child: Center(
                    child: Text(
                      "Pairing Successful",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      textScaler: TextScaler.linear(3.6),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        User user = snapshot.data as User;
                        return Column(
                          children: [
                            Text(
                              "Verified ${user.name}",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              textScaler: const TextScaler.linear(2.6),
                              maxLines: 2,
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: user.verified
                                        ? Colors.green
                                        : Colors.red,
                                    width: 12.0,
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 0.65,
                                  child: FittedBox(
                                    child: CircleAvatar(
                                      backgroundImage:
                                      ExactAssetImage(user.iconPath),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const CircleAvatar(radius: 80.0);
                      }
                    },
                    future: _localDatabaseService.getUserDetails(widget.userId),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: widget.pairingArguments != null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Has the other user verifed you too?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            textScaler: TextScaler.linear(2.3),
                          ),
                        ),
                      ),
                      Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: FittedBox(
                            child: FloatingActionButton.extended(
                              heroTag: "back",
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PairingScreen(
                                      pairingArgs:
                                      widget.pairingArguments,
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.lightBlueAccent,
                              icon: const Icon(Icons.arrow_back),
                              label: Text(
                                  "Back to ${widget.pairingArguments!.method.readableName(context)} Pairing"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  // : const SizedBox(),
                      : const FractionallySizedBox(
                    widthFactor: 0.6,
                    child: FittedBox(
                      child: Icon(Icons.check_circle_outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
