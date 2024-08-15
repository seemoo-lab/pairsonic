/// {@category AudioChannel}
library;

import 'second_channel_interface.dart';

/// Profiles that should be implemented by all AudioChannelServices
enum AudioChannelProfile { audible, ultrasonic }

/// Exception that is thrown when the receiver is not listening but it should.
class NotReceivingException implements Exception {
  final String msg;

  const NotReceivingException(this.msg);

  @override
  String toString() => 'NotReceivingException: $msg';
}

/// Exception that is thrown when the receiver is already listening but it
/// shouldn't.
class AlreadyReceivingException implements Exception {
  final String msg;

  const AlreadyReceivingException(this.msg);

  @override
  String toString() => 'AlreadyReceivingException: $msg';
}

/// Abstract class to define a service for transmitting and receiving data
/// via a audio channel.
///
/// {@category Interfaces}
abstract class AudioChannelService<T> extends SecondChannelService<T> {
  AudioChannelProfile profile;

  bool get isReceiving;

  AudioChannelService({this.profile = AudioChannelProfile.audible});
}
