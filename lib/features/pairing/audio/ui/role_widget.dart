part of 'grouppairing_audio_widgets.dart';

class GPRoleSelectionWidget extends StatefulWidget {
  final GroupPairingUIState _uiState;

  const GPRoleSelectionWidget({super.key, required uiState})
      : _uiState = uiState;

  @override
  State<GPRoleSelectionWidget> createState() => _GPRoleSelectionWidgetState();
}

class _GPRoleSelectionWidgetState extends State<GPRoleSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
            10, 10, 10, MediaQuery.of(context).size.height * 0.05),
        child: Column(children: [
          Text(S.of(context).groupPairingSelectRole,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          RoleSelectionCardWidget(
              assetName: "assets/grouppairing/coordinator-abstract-people-color.svg",
              title: S.of(context).groupPairingCoordinator,
              description: S.of(context).groupPairingCoordinatorHelp,
              action: () => _navigateToNext(true)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          RoleSelectionCardWidget(
              assetName: "assets/grouppairing/participant-abstract-people-color.svg",
              title: S.of(context).groupPairingParticipant,
              description: S.of(context).groupPairingDeviceHelp,
              action: () => _navigateToNext(false)),
        ]),
      ),
    );
  }

  Future<void> _navigateToNext(bool isCoordinator) async {
    widget._uiState.isCoordinator = isCoordinator;


    if (!(await _checkPairingRequirements())) {
      final context = this.context;
      if (!context.mounted) {
        return;
      }
      await LocationServiceHelper.instance.showLocationServiceAlert(context);
      return;
    }

    final context = this.context;
    if (!context.mounted) {
      return;
    }
    if (isCoordinator) {
      Navigator.of(context).pushNamed(GroupPairingAudioRoutes.coordinatorSetup);
    } else {
      Navigator.of(context).pushNamed(GroupPairingAudioRoutes.running);
    }
  }

  Future<bool> _checkPairingRequirements() async {
    final locationServiceEnabled = await LocationServiceHelper.instance.isLocationServicesEnabled();
    debugPrint("Location Service enabled: $locationServiceEnabled");
    return locationServiceEnabled;
  }
}
