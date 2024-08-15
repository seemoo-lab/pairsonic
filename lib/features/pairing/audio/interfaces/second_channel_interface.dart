abstract class SecondChannelService<T> {
  /// Starts a transmission of the [data].
  /// Depending on the implementation and the type of channel used, this may
  /// start a continuous transmission or just a single one.
  Future<bool> startTransmission(T data);

  /// Stops the transmission that was started with [startTransmission].
  Future<void> stopTransmission();

  /// Makes the receiver start listening for incoming transmissions.
  Future<void> startReceiving();

  /// Stops the receiver from listening for incoming transmissions.
  Future<void> stopReceiving();

  /// Fetches data received by the receiver. Depending on the implementation
  /// this could block until data is received. When not blocking, null
  /// is returned to indicate that no data was received.
  Future<T?> getReceivedData();

  Future<List<T>> getAllReceivedData();
}