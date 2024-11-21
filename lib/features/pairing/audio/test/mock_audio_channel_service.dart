/// {@category AudioChannel}
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/audio/interfaces/audio_channel_interface.dart';

/// Mock implementation of [AudioChannelInterface].
/// This implementation "receives" the values given in the constructor.
/// Transmitting does nothing.
class MockAudioChannel extends AudioChannelService<Uint8List> {
  int _i = 0;
  List<Uint8List>? rx;
  bool _isReceiving = false;

  MockAudioChannel(this.rx);

  @override
  Future<Uint8List?> getReceivedData() async {
    assert(isReceiving);
    debugPrint("Receiving $_i (${rx![_i]}");
    _i++;
    return rx![_i - 1];
  }

  @override
  bool get isReceiving => _isReceiving;

  @override
  Future<void> startReceiving() async {
    debugPrint("MockAudioChannel - startReceiving");
    assert(!isReceiving);
    _isReceiving = true;
  }

  @override
  Future<void> stopReceiving() async {
    debugPrint("MockAudioChannel - stopReceiving");
    assert(isReceiving);
    _isReceiving = false;
  }

  @override
  Future<bool> startTransmission(Uint8List data) async {
    debugPrint("MockAudioChannel - transmit: $data");
    return true;
  }

  @override
  Future<void> stopTransmission() async {
    // This implementation does nothing.
  }

  @override
  Future<List<Uint8List>> getAllReceivedData() {
    // TODO: implement getAllReceivedData
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() async {}
}
