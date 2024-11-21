/// {@category AudioChannel}
library;

import 'dart:typed_data';

import '../interfaces/audio_channel_interface.dart';

/// [AudioChannelService] that allows transmitting Strings over a byte audio
/// channel ([Uint8List]).
class StringAudioChannelService extends AudioChannelService<String> {
  final AudioChannelService<Uint8List> _innerChannel;

  StringAudioChannelService(AudioChannelService<Uint8List> byteAudioChannel)
      : _innerChannel = byteAudioChannel,
        super(profile: byteAudioChannel.profile);

  @override
  Future<bool> startTransmission(String data) async {
    final List<int> bytes = data.codeUnits;
    return await this._innerChannel.startTransmission(Uint8List.fromList(bytes));
  }

  @override
  Future<void> stopTransmission() async {
    // This implementation does nothing.
  }

  @override
  Future<String?> getReceivedData() async {
    var innerData = await this._innerChannel.getReceivedData();
    if (innerData != null) {
      return String.fromCharCodes(innerData);
    } else {
      return null;
    }
  }

  @override
  Future<List<String>> getAllReceivedData() {
    // TODO: implement getAllReceivedData
    throw UnimplementedError();
  }

  @override
  Future<void> startReceiving() async {
    await this._innerChannel.startReceiving();
  }

  @override
  Future<void> stopReceiving() async {
    await this._innerChannel.stopReceiving();
  }

  @override
  bool get isReceiving => this._innerChannel.isReceiving;

  @override
  Future<void> dispose() async {}
}
