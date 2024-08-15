part of 'grouppairing_audio_widgets.dart';

enum ErrorWidgetType { timeout, securityError, error }

/// Arguments provided to the [GPErrorWidget].
///
/// These arguments contain all the information necessary to
/// display the error and inform the user.
class ErrorWidgetArgs {
  final ErrorWidgetType errorType;
  final bool retry;
  final String name;
  final String description;
  final String? details;

  const ErrorWidgetArgs(
      {required this.errorType,
      required this.retry,
      required this.name,
      required this.description,
      this.details});

  // some predefined errors:

  factory ErrorWidgetArgs.timeout(BuildContext context) => ErrorWidgetArgs(
      errorType: ErrorWidgetType.timeout,
      retry: true,
      name: S.of(context).groupPairingErrTimeoutName,
      description: S.of(context).groupPairingErrTimeoutDescription);

  factory ErrorWidgetArgs.security(BuildContext context) => ErrorWidgetArgs(
      errorType: ErrorWidgetType.securityError,
      retry: true,
      name: S.of(context).groupPairingErrSecurityName,
      description: S.of(context).groupPairingErrSecurityDescription);

  factory ErrorWidgetArgs.unknown(BuildContext context, String details) =>
      ErrorWidgetArgs(
          errorType: ErrorWidgetType.error,
          retry: true,
          name: S.of(context).groupPairingErrUnknownName,
          description: S.of(context).groupPairingErrUnknownDescription,
          details: details);

  factory ErrorWidgetArgs.centralizedComm(BuildContext context) =>
      ErrorWidgetArgs(
          errorType: ErrorWidgetType.error,
          retry: true,
          name: S.of(context).groupPairingErrCentCommName,
          description: S.of(context).groupPairingErrCentCommDescription);

  factory ErrorWidgetArgs.wifi(BuildContext context) => ErrorWidgetArgs(
      errorType: ErrorWidgetType.error,
      retry: true,
      name: S.of(context).groupPairingErrWifiName,
      description: S.of(context).groupPairingErrWifiDescription);
}

/// Widget displayed on a group paring protocol error.
///
/// {@category Widgets}
class GPErrorWidget extends StatelessWidget {
  final GroupPairingUIState _uiState;

  const GPErrorWidget({super.key, required uiState}) : _uiState = uiState;

  IconData _getIcon(ErrorWidgetType errorType) {
    switch (errorType) {
      case ErrorWidgetType.error:
        return Icons.warning;
      case ErrorWidgetType.securityError:
        return Icons.error;
      case ErrorWidgetType.timeout:
        return Icons.timer;
    }
  }

  Color _getColor(ErrorWidgetType errorType) {
    switch (errorType) {
      case ErrorWidgetType.error:
        return const Color.fromARGB(255, 255, 141, 10);
      case ErrorWidgetType.timeout:
        return const Color.fromARGB(255, 10, 108, 255);
      case ErrorWidgetType.securityError:
        return const Color.fromARGB(255, 255, 0, 0);
    }
  }

  Color _getTextColor(ErrorWidgetType errorType) {
    switch (errorType) {
      case ErrorWidgetType.error:
      case ErrorWidgetType.timeout:
      case ErrorWidgetType.securityError:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ErrorWidgetArgs;

    var colorText = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: _getTextColor(args.errorType));

    var textStyleDetails = Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: _getTextColor(args.errorType), fontFamily: "Monospace");

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(_getIcon(args.errorType),
                        color: _getColor(args.errorType), size: 60),
                    const SizedBox(width: 10),
                    Text(args.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _getColor(args.errorType)),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: [
                          Text(args.description, style: colorText),
                          args.details != null
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),
                          args.details != null
                              ? Text(args.details!, style: textStyleDetails)
                              : const SizedBox.shrink()
                        ]))),
                args.retry ? const SizedBox(height: 30) : const SizedBox.shrink(),
                args.retry
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(S.of(context).retryGroupPairing),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      try {
                                        Navigator.of(context).popUntil(
                                            (route) =>
                                                route.settings.name ==
                                                GroupPairingAudioRoutes
                                                    .roleSelection);
                                        if (_uiState.isCoordinator!) {
                                          Navigator.of(context).pushNamed(
                                              GroupPairingAudioRoutes
                                                  .coordinatorSetup);
                                        } else {
                                          Navigator.of(context).pushNamed(
                                              GroupPairingAudioRoutes.running);
                                        }
                                      } catch (e) {
                                        debugPrint(
                                            "GPRunningWidget - _protocolInteractionWrapper: Error: $e");
                                      }
                                    },
                                    child: Text(
                                        S.of(context).groupPairingPromptRetry)),
                                const SizedBox(width: 30),
                                TextButton(
                                    onPressed: () {
                                      try {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .popUntil((route) =>
                                                route.settings.name ==
                                                AppRoutes.homePage);
                                      } catch (e) {
                                        debugPrint(
                                            "GPRunningWidget - _protocolInteractionWrapper: Error: $e");
                                      }
                                    },
                                    child: Text(S
                                        .of(context)
                                        .groupPairingPromptCancel)),
                              ])
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            )));
  }
}
