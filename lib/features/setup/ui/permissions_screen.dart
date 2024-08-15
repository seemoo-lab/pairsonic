import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/setup/services/permission_service.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen();

  @override
  State<StatefulWidget> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  final IdentityService _identityService = getIt<IdentityService>();
  final PermissionService _permissionService = PermissionService.instance;

  bool _isPermissionDeniedPermanently = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _PermissionsScreenState() {
    _permissionService.checkPermissions().then((value) {
      setState(() {
        this._isPermissionDeniedPermanently = value.isPermanentlyDenied;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _permissionService.getPermissionNamesAndDescriptions(context),
        builder: (context, snapshot) {
          final permissionDescriptions = snapshot.data;
          if (snapshot.hasData && permissionDescriptions != null) {
            return Scaffold(
              appBar: AppBar(title: Text(S.of(context).permissionScreenTitle)),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              S.of(context).permissionScreenIntroText,
                              textScaler: TextScaler.linear(1.25),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: permissionDescriptions
                                    .map((permissionDescription) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "•",
                                        textScaler: TextScaler.linear(2.0),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                    fontWeight: FontWeight.normal),
                                                children: [
                                                  TextSpan(
                                                      text: permissionDescription.$1,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold)),
                                                  TextSpan(
                                                      text: permissionDescription
                                                          .$2)
                                                ]
                                            ),
                                            textScaler: TextScaler.linear(1.1),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            Divider(),
                            Text(
                              S.of(context).permissionScreenFooterText,
                              textScaler: TextScaler.linear(1.1),
                              style: TextStyle(
                                  fontWeight: _isPermissionDeniedPermanently
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.arrow_back_rounded),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: Text("Back")),
                        ),
                        SizedBox(width: 10),
                        FilledButton(
                            onPressed: () async {
                              if (_isPermissionDeniedPermanently) {
                                await openAppSettings();
                              } else if (await _requestPermissions()) {
                                _navigateToNextScreen();
                              }
                            },
                            child: Row(
                              children: [
                                Text(_isPermissionDeniedPermanently
                                    ? S.of(context) .permissionScreenButtonTextOpenSettings
                                    : S.of(context).permissionScreenButtonTextRequestPermissions),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_rounded)
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  void _navigateToNextScreen() {
    if (_identityService.identitySet) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.homePage);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.profileCreation);
    }
  }

  Future<bool> _requestPermissions() async {
    final status = await _permissionService.requestPermissions();

    setState(() {
      _isPermissionDeniedPermanently = status.isPermanentlyDenied;
    });

    return status.isGranted;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      _permissionService.checkPermissions().then((value) {
        setState(() {
          this._isPermissionDeniedPermanently = value.isPermanentlyDenied;
          if (value.isGranted) {
            _navigateToNextScreen();
          }
        });
      });
    }
  }
}
