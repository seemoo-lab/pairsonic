part of 'grouppairing_audio_widgets.dart';

/// Widget displayed when the group pairing is running.
///
/// {@category Widgets}
class GPRunningWidget extends StatefulWidget {
  final GroupPairingUIState _uiState;
  final Sink<double> _pairingProgressSink;

  const GPRunningWidget({super.key, required uiState, required progressSink}) : _uiState = uiState, _pairingProgressSink = progressSink;

  @override
  State<GPRunningWidget> createState() => _GPRunningWidgetState(_pairingProgressSink);
}

class _GPRunningWidgetState extends State<GPRunningWidget> {
  late final Timer _timer;
  late String _statusMessage;
  var _statusMessage2 = "";
  final _animatedIconKey = GlobalKey<SizeAnimatedIconState>();
  final Sink<double> _pairingProgressSink;

  _GPRunningWidgetState(this._pairingProgressSink);

  @override
  void initState() {
    super.initState();
    _statusMessage = _getStatusMessage(GroupPairingState.init);

    // initialize the GroupPairingProtocol according
    // to the elements in GroupPairingUIState
    if (widget._uiState.isCoordinator!) {
      widget._uiState.protocol = GroupPairingProtocol.coordinator(
          widget._uiState.channel,
          widget._uiState.comm!,
          widget._uiState.userData,
          userJsonParserFunction);
    } else {
      widget._uiState.protocol = GroupPairingProtocol.device(
          widget._uiState.channel,
          widget._uiState.userData,
          userJsonParserFunction);
    }
    widget._uiState.protocol!.onStateChange = _onProtocolStateChange;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _asyncInitState();
    });

    if (widget._uiState.isCoordinator == true) {
      _pairingProgressSink.add(0.2);
    } else {
      _pairingProgressSink.add(0.1);
    }
  }

  Future<void> _asyncInitState() async {
    if (!widget._uiState.isCoordinator!) {
      await widget._uiState.reset();
    }

    var isAudioConfigured =
        await widget._uiState.configureAudio(widget._uiState.isCoordinator!);
    if (!isAudioConfigured) {
      await _promptAudioConfig();
    }

    // periodically call the step function
    _timer = Timer.periodic(const Duration(milliseconds: protocolStepTimerPeriodMs), (timer) async {
      await _protocolInteractionWrapper(widget._uiState.protocol!.step);
    });
  }

  /// Wrapper for any interaction with the [_protocol].
  ///
  /// Any public [_protocol] functions might throw a [GroupPairingException].
  /// This function catches these exceptions and updates the UI accordingly.
  Future<void> _protocolInteractionWrapper(Future<void> Function() func) async {
    try {
      await func();
    } on TimeoutException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
            arguments: ErrorWidgetArgs.timeout(context));
      }
      _timer.cancel();
      debugPrint("GPRunningWidget - _protocolInteractionWrapper: Error: $e");
    } on CommunicationFailedException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
            arguments: ErrorWidgetArgs.centralizedComm(context));
      }
      _timer.cancel();
      debugPrint("GPRunningWidget - _protocolInteractionWrapper: Error: $e");
    } on GroupPairingException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
            arguments: ErrorWidgetArgs.security(context));
      }
      _timer.cancel();
      debugPrint("GPRunningWidget - _protocolInteractionWrapper: Error: $e");
    } on WifiP2pException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
            arguments: ErrorWidgetArgs.wifi(context));
      }
      _timer.cancel();
      debugPrint("GPRunningWidget - _protocolInteractionWrapper: Error: $e");
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
            arguments: ErrorWidgetArgs.unknown(context, e.toString()));
      }
      _timer.cancel();
      debugPrint("GPRunningWidget - _protocolInteractionWrapper: Error: $e");
      rethrow;
    }
  }

  String _getStatusMessage(GroupPairingState state) {
    switch (state) {
      case GroupPairingState.deviceInit2:
        return S.of(context).groupPairingStatus_DEVICE_INIT2;
      case GroupPairingState.establishingConnection:
        return S.of(context).groupPairingConnectingWithParticipants;
      case GroupPairingState.sendCommitment:
      case GroupPairingState.collectCommitments:
      case GroupPairingState.sendMainReveal:
      case GroupPairingState.collectMainReveals:
        return S.of(context).groupPairingExchangingContactInformation;
      case GroupPairingState.deviceVerification1:
      case GroupPairingState.deviceVerification2:
      case GroupPairingState.coordinatorVerification:
        return S.of(context).groupPairingVerifyingSecurity;
      case GroupPairingState.collectMatchReveals:
        return S.of(context).groupPairingStatus_COLLECT_MATCH_REVEALS;
      case GroupPairingState.secretSharing:
      case GroupPairingState.decrypting:
        return S.of(context).groupPairingStatusDecrypting;
      case GroupPairingState.timeout:
        return S.of(context).groupPairingTimeout;
      case GroupPairingState.error:
        return S.of(context).groupPairingError;
      case GroupPairingState.done:
        return S.of(context).groupPairingDone;
      default:
        //return S.of(context).groupPairingStatusRunning;
        return "Running...";
    }
  }

  /// Prompts the user to increase the volume above 50%.
  Future<void> _promptAudioConfig() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(S.of(context).volumeDialogTitle),
              content: Text(S.of(context).volumeDialogDescription),
              actions: [
                ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(S.of(context).dialogButtonOK))
              ],
            ));
  }

  void _onProtocolStateChange(
      GroupPairingState oldState, GroupPairingState newState) {
    if (newState == GroupPairingState.done) {
      Navigator.of(context).pushNamed(GroupPairingAudioRoutes.success);
    } else {
      if (newState == GroupPairingState.userConfirm) {
        switch (widget._uiState.fm) {
          case FailureMode.standard:
            _animatedIconKey.currentState!.controller.reset();
            _animatedIconKey.currentState!.controller.forward();
            break;
          case FailureMode.failAlways:
            Navigator.of(context).pushNamed(GroupPairingAudioRoutes.error,
                arguments: ErrorWidgetArgs.security(context));
            _timer.cancel();
            break;
        }
      }
      setState(() {
        _statusMessage = _getStatusMessage(newState);
        if (widget._uiState.comm == null) {
          _statusMessage2 == "";
        } else {
          _statusMessage2 = S.of(context).groupPairingSizeIndicator(widget._uiState.comm?.participantCount.toString() ?? "");
        }
      });
    }
    switch (newState) {
      case GroupPairingState.init:
        _pairingProgressSink.add(0.2);
        break;
      case GroupPairingState.coordinatorInit:
        _pairingProgressSink.add(0.2);
        break;
      case GroupPairingState.deviceInit1:
        _pairingProgressSink.add(0.1);
        break;
      case GroupPairingState.deviceInit2:
        _pairingProgressSink.add(0.1);
        break;
      case GroupPairingState.establishingConnection:
        _pairingProgressSink.add(0.25);
        break;
      case GroupPairingState.sendCommitment:
        _pairingProgressSink.add(0.3);
        break;
      case GroupPairingState.collectCommitments:
        _pairingProgressSink.add(0.35);
        break;
      case GroupPairingState.sendMainReveal:
        _pairingProgressSink.add(0.4);
        break;
      case GroupPairingState.collectMainReveals:
        _pairingProgressSink.add(0.45);
        break;
      case GroupPairingState.coordinatorVerification:
        _pairingProgressSink.add(0.5);
        break;
      case GroupPairingState.deviceVerification1:
        _pairingProgressSink.add(0.5);
        break;
      case GroupPairingState.deviceVerification2:
        _pairingProgressSink.add(0.5);
        break;
      case GroupPairingState.userConfirm:
        _pairingProgressSink.add(0.75);
        break;
      case GroupPairingState.sendMatchReveal:
        _pairingProgressSink.add(0.8);
        break;
      case GroupPairingState.collectMatchReveals:
        _pairingProgressSink.add(0.8);
        break;
      case GroupPairingState.secretSharing:
      case GroupPairingState.decrypting:
        _pairingProgressSink.add(0.9);
        break;
      case GroupPairingState.done:
        // we don't want a colored bar at the end, so "done" has value 0.0
      case GroupPairingState.timeout:
      case GroupPairingState.error:
        _pairingProgressSink.add(0.0);
        break;
    }
  }

  @override
  void dispose() {
    // widget._uiState.protocol!.onStateChange = null;
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: IndexedStack(
          index:
              widget._uiState.protocol!.state == GroupPairingState.userConfirm
                  ? 1
                  : 0,
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_upward_rounded,
                      size: MediaQuery.of(context).size.height * 0.25),
                  Text(_statusMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                  if (_statusMessage2.isNotEmpty) const SizedBox(height: 20),
                  Text(_statusMessage2,
                      style: const TextStyle(fontSize: 16)),
                  widget._uiState.protocol!.state == GroupPairingState.deviceInit2
                      ? Spacer()
                      : SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  widget._uiState.protocol!.state == GroupPairingState.deviceInit2
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 5),
                          child: GuiConstants.svgAssetExchange(
                              context,
                              height: MediaQuery.of(context).size.height * 0.25
                          )
                        )
                      : const SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(strokeWidth: 6)),
                  const Spacer(),
                  HintTextCard(S.of(context).groupPairingCloseToOther),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  SizeAnimatedIcon(
                      key: _animatedIconKey,
                      beginSize: 0,
                      endSize: (MediaQuery.of(context).size.height * 0.33).round(),
                      duration: const Duration(milliseconds: 700),
                      iconData: Icons.lock,
                      iconColor: Colors.blue),
                  widget._uiState.isCoordinator == true ? Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.multitrack_audio_rounded),
                      onPressed: () => widget._uiState.protocol!.retransmitVerificationAudio(),
                      label: Text(S
                          .of(context)
                          .groupPairingVerificationRetransmissionButton),
                    ),
                  ) : SizedBox.shrink(),
                  Spacer(),
                  HintTextCard(S.of(context).groupPairingVerificationPromptWithSize(widget._uiState.comm?.participantCount.toString() ?? "")),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.close_rounded),
                            label: Text(S.of(context).dialogButtonNo),
                            onPressed: () {
                              _protocolInteractionWrapper(() async =>
                                  await widget._uiState.protocol!
                                      .userInputApprove(false));
                            },
                          ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: FilledButton.icon(
                            icon: Icon(Icons.check_rounded),
                            label: Text(S.of(context).dialogButtonYes),
                            onPressed: () {
                              _protocolInteractionWrapper(() async =>
                                  await widget._uiState.protocol!
                                      .userInputApprove(true));
                            },
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ));
  }
}
