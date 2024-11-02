import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/setup/services/permission_service.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/location_service_helper.dart';
import 'package:pairsonic/helper/ui/button_row.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  final IdentityService _identityService = getIt<IdentityService>();
  final PermissionService _permissionService = PermissionService.instance;
  final LocationServiceHelper _locationService = LocationServiceHelper.instance;

  bool _isPermissionDeniedPermanently = false;
  bool _isLocationServiceEnabled = false;

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
    _locationService.isLocationServicesEnabled().then((value) {
      setState(() {
        this._isLocationServiceEnabled = value;
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
                            if (!_isLocationServiceEnabled)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    S.of(context).permissionScreenLocationServiceMessage,
                                    textScaler: const TextScaler.linear(1.1),
                                  ),
                                ],
                              ),
                            const Divider(),
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
                    child: ButtonRow(
                      primaryText: _isPermissionDeniedPermanently
                          ? S.of(context).permissionScreenButtonTextOpenSettings
                          : S.of(context).permissionScreenButtonTextRequestPermissions,
                      primaryIcon: Icons.arrow_forward_rounded,
                      primaryAction: (context) async {
                        if (_isPermissionDeniedPermanently) {
                          await openAppSettings();
                        } else if (await _requestPermissions()) {
                          debugPrint("navigating to next screen");
                          _navigateToNextScreen();
                        }
                      },
                      secondaryText: S.of(context).generalButtonBack,
                      secondaryIcon: Icons.arrow_back_rounded,
                      secondaryAction: (context) => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
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

    if (!(await _locationService.isLocationServicesEnabled())) {
      final context = this.context;
      if (context.mounted) {
        _locationService.showLocationServiceAlert(context);
      }
    }

    return status.isGranted && (await _locationService.isLocationServicesEnabled());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      _permissionService.checkPermissions().then((permissionStatus) {
        _locationService.isLocationServicesEnabled().then((locationEnabled) {
          setState(() {
            this._isPermissionDeniedPermanently = permissionStatus.isPermanentlyDenied;
            this._isLocationServiceEnabled = locationEnabled;
            if (permissionStatus.isGranted) {
              if (_isLocationServiceEnabled) {
                _navigateToNextScreen();
              } else {
                _locationService.showLocationServiceAlert(context);
              }
            }
          });
        });
      });
    }
  }
}
