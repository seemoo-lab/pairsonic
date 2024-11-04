import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/setup/services/permission_service.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/location_service_helper.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final IdentityService _identityService = getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).welcomeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture(
                    const SvgAssetLoader("assets/logo-icon.svg"),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                                text: "PairSonic",
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                              text: S.of(context).welcomeTextFirst,
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (await PermissionService.instance.checkPermissions().isGranted && await LocationServiceHelper.instance.isLocationServicesEnabled()) {
                  if (_identityService.identitySet) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(AppRoutes.profileCreation);
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(AppRoutes.permissions);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).generalButtonNext),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}