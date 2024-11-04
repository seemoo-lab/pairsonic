/// {@category AudioChannel}
library;

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ggwave_flutter/ggwave_flutter.dart' as ggwave;
import 'package:logger/logger.dart';
import 'package:pairsonic/features/pairing/audio/interfaces/audio_channel_interface.dart';

/// Audio channel that utilizes the [ggwave](https://github.com/ggerganov/ggwave)
/// library for transmitting and receiving.
/// This service is a singleton.
class GgwaveAudioChannelService extends AudioChannelService<Uint8List> {
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer(logLevel: Level.info);
  final FlutterSoundRecorder _mRecorder =
      FlutterSoundRecorder(logLevel: Level.info);
  final _controller = StreamController<FoodData>();
  Timer? _processingTimer;
  final Duration _processingInterval = const Duration(milliseconds: 500);
  StreamSubscription? _streamSubscription;
  final BytesBuilder _receivedAudioData = BytesBuilder(copy: false);
  List<Uint8List> _receivedData = [];
  static const int processLastNSeconds = 7;
  bool _processing = false;

  static final GgwaveAudioChannelService _instance =
      GgwaveAudioChannelService._internal();
  var _isReceiving = false;

  factory GgwaveAudioChannelService({AudioChannelProfile? profile}) {
    _instance.profile = profile ?? _instance.profile;
    return _instance;
  }

  GgwaveAudioChannelService._internal()
      : super(profile: AudioChannelProfile.audible) {
    _streamSubscription = _controller.stream.listen((foodData) {
      if (foodData.data != null) {
        _receivedAudioData.add(foodData.data!);
      }
    });
    ggwave.init();
  }

  @override
  bool get isReceiving => _isReceiving;

  ggwave.GGWaveTxProtocolId get _ggWaveTxProtocolId =>
      this.profile == AudioChannelProfile.audible
          ? ggwave.GGWaveTxProtocolId.GGWAVE_TX_PROTOCOL_AUDIBLE_FAST
          : ggwave.GGWaveTxProtocolId.GGWAVE_TX_PROTOCOL_ULTRASOUND_FAST;

  @override
  Future<bool> startTransmission(Uint8List data) async {
    var bb = BytesBuilder(copy: false);
    bb.addByte(77);
    bb.add(data);
    final Completer<bool> completer = Completer();
    var audioData = ggwave.convertBytesToAudio(bb.takeBytes(),
        protocol: _ggWaveTxProtocolId);
    if (audioData == null) {
      return false;
    }
    await _mPlayer.openPlayer();
    await _mPlayer.startPlayer(
        fromDataBuffer: audioData,
        codec: Codec.pcm16,
        sampleRate: 48000,
        numChannels: 1,
        whenFinished: () async {
          await _mPlayer.closePlayer();
          completer.complete(true);
        });
    return completer.future;
  }

  @override
  Future<void> stopTransmission() async{
    // This implementation does nothing, since transmission is not continuous.
  }

  @override
  Future<void> startReceiving() async {
    debugPrint("ggwave - startReceiving");
    if (this._isReceiving) {
      throw const AlreadyReceivingException(
          "Ggwave is already receiving. Cannot start receiving.");
    }
    this._isReceiving = true;
    _mRecorder.openRecorder().then(
          (value) => _mRecorder.startRecorder(
              codec: Codec.pcm16,
              sampleRate: 48000,
              bitRate: 48000,
              toStream: _controller.sink),
        );
    _processingTimer = Timer.periodic(_processingInterval, _processAudio);
  }

  void _processAudio(Timer timer) async {
    debugPrint("ggwave - _processAudio (_processing=$_processing)");
    if (_processing) return;
    _processing = true;
    _streamSubscription?.pause();
    var currentAudioData = _receivedAudioData.takeBytes();
    _receivedAudioData.add(currentAudioData.sublist(
        max(0, currentAudioData.length - (currentAudioData.length % 2048)),
        currentAudioData.length));
    debugPrint("ggwave - got ${currentAudioData.length / 2} samples");
    _streamSubscription?.resume();
    // ggwave internally processes 1024 samples at a time
    // we need to give ggwave a multiple of 1024 samples to make
    // the continous processing work
    // (beacuse 2 bytes per sample => 2048 bytes)
    var toBeProcessedAudioData = currentAudioData.sublist(
        0, currentAudioData.length - (currentAudioData.length % 2048));
    debugPrint(
        "ggwave - processing ${toBeProcessedAudioData.length / 2} samples");
    Uint8List? res =
        await compute(ggwave.convertAudioToBytes, toBeProcessedAudioData);
    if (res != null) {
      debugPrint("ggwave - received ${res.length.toString()} bytes");
      if (res.isNotEmpty && res[0] == 77) {
        _receivedData.add(res.sublist(1, res.length));
      }
    }
    _processing = false;
  }

  @override
  Future<void> stopReceiving() async {
    if (!this._isReceiving) {
      throw const NotReceivingException(
          "Ggwave is not receiving cannot stop receiving.");
    }
    _processingTimer!.cancel();
    _mRecorder.stopRecorder().then(((value) => _mRecorder.closeRecorder()));
    _receivedData = [];
    _receivedAudioData.takeBytes();
    this._isReceiving = false;
  }

  @override
  Future<Uint8List?> getReceivedData() async {
    if (!this._isReceiving) {
      throw const NotReceivingException(
          "Ggwave is not receiving cannot get received frames.");
    }

    if (_receivedData.isEmpty) {
      return null;
    } else {
      return _receivedData.removeAt(0);
    }
  }

  @override
  Future<List<Uint8List>> getAllReceivedData() async {
    return _receivedData;
  }

  @override
  Future<void> dispose() async {
    await stopReceiving();
    await stopTransmission();
    // TODO: do more?
  }
}
