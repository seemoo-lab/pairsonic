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

  void _navigateToNext(bool isCoordinator) {
    widget._uiState.isCoordinator = isCoordinator;
    if (isCoordinator) {
      Navigator.of(context).pushNamed(GroupPairingAudioRoutes.coordinatorSetup);
    } else {
      Navigator.of(context).pushNamed(GroupPairingAudioRoutes.running);
    }
  }
}

class RoleSelectionCardWidget extends StatelessWidget {
  final String assetName;
  final String title;
  final String description;
  final Function() action;

  RoleSelectionCardWidget(
      {required this.assetName,
      required this.title,
      required this.description,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: action,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Spacer(),
                  SvgPicture(
                    SvgAssetLoader(
                      assetName,
                      colorMapper: SvgColorReplacer({
                        Colors.black: Theme.of(context).colorScheme.onSurface,
                      })
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
