import 'package:flutter/material.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/ui/button_row.dart';

enum ErrorWidgetType { timeout, securityError, error }

/// Arguments provided to the [GPErrorWidget].
///
/// These arguments contain all the information necessary to
/// display the error and inform the user.
class ErrorWidgetArgs {
  final ErrorWidgetType errorType;
  final bool retry;
  final String title;
  final String description;
  final String? details;
  final bool showAppBar;
  final Function(BuildContext) cancelAction;
  final Function(BuildContext)? retryAction;

  const ErrorWidgetArgs(
      {required this.errorType,
      required this.retry,
      required this.title,
      required this.description,
      required this.cancelAction,
      required this.showAppBar,
      this.retryAction,
      this.details});

  // some prefefined errors:

  factory ErrorWidgetArgs.timeout(BuildContext context,
          {required Function(BuildContext) cancelAction,
          bool showAppBar = true,
          Function(BuildContext)? retryAction}) =>
      ErrorWidgetArgs(
          errorType: ErrorWidgetType.timeout,
          retry: true,
          title: S.of(context).groupPairingErrTimeoutName,
          description: S.of(context).groupPairingErrTimeoutDescription,
          showAppBar: showAppBar,
          cancelAction: cancelAction,
          retryAction: retryAction);

  factory ErrorWidgetArgs.security(BuildContext context,
          {bool showAppBar = true,
          required Function(BuildContext) cancelAction,
          Function(BuildContext)? retryAction}) =>
      ErrorWidgetArgs(
        errorType: ErrorWidgetType.securityError,
        retry: true,
        title: S.of(context).groupPairingErrSecurityName,
        description: S.of(context).groupPairingErrSecurityDescription,
        showAppBar: showAppBar,
        cancelAction: cancelAction,
        retryAction: retryAction,
      );

  factory ErrorWidgetArgs.unknown(
    BuildContext context, {
    required Function(BuildContext) cancelAction,
    bool showAppBar = true,
    Function(BuildContext)? retryAction,
    required String details,
  }) =>
      ErrorWidgetArgs(
        errorType: ErrorWidgetType.error,
        retry: true,
        title: S.of(context).groupPairingErrUnknownName,
        description: S.of(context).groupPairingErrUnknownDescription,
        showAppBar: showAppBar,
        details: details,
        cancelAction: cancelAction,
        retryAction: retryAction,
      );

  factory ErrorWidgetArgs.wifi(BuildContext context,
          {bool showAppBar = true,
          required Function(BuildContext) cancelAction,
          Function(BuildContext)? retryAction}) =>
      ErrorWidgetArgs(
        errorType: ErrorWidgetType.error,
        retry: true,
        title: S.of(context).groupPairingErrWifiName,
        description: S.of(context).groupPairingErrWifiDescription,
        showAppBar: showAppBar,
        cancelAction: cancelAction,
        retryAction: retryAction,
      );
}

class PairSonicErrorWidget extends StatelessWidget {
  final ErrorWidgetArgs? args;

  const PairSonicErrorWidget({super.key, this.args});

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
    final args = this.args ?? ModalRoute.of(context)!.settings.arguments as ErrorWidgetArgs;

    var colorText = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: _getTextColor(args.errorType));

    var textStyleDetails = Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: _getTextColor(args.errorType), fontFamily: "Monospace");

    return Scaffold(
        appBar: args.showAppBar ? AppBar(title: Text(args.title)) : null,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(_getIcon(args.errorType),
                        color: _getColor(args.errorType), size: 60),
                    const SizedBox(width: 10),
                    Text(args.title,
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
                args.retry
                    ? const SizedBox(height: 30)
                    : const SizedBox.shrink(),
                args.retry
                    ? Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(S.of(context).retryGroupPairing),
                          const Spacer(),
                          ButtonRow(
                            primaryText: S.of(context).groupPairingPromptRetry,
                            primaryIcon: Icons.replay,
                            primaryAction: (context) {
                              args.retryAction?.call(context);
                            },
                            secondaryText:
                                S.of(context).groupPairingPromptCancel,
                            secondaryIcon: Icons.close_rounded,
                            secondaryAction: (context) {
                              args.cancelAction.call(context);
                            },
                          ),
                        ],
                      ))
                    : const SizedBox.shrink()
              ],
            )));
  }
}
