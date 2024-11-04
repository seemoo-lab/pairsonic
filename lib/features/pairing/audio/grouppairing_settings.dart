part of 'grouppairing_protocol.dart';

typedef CryptoServiceFactory = GroupPairingCryptoServiceInterface Function();

/// An immutable data class used to store the settings for
/// the group pairing protocol.
class GrouppairingProtocolSettings {
  static const GrouppairingProtocolSettings standard =
      GrouppairingProtocolSettings(
        initDataTimeoutMs: 60 * 60 * 1000,
        nonceLength: 32,
        connectionTimeoutMs: 120 * 1000,
        commitmentCollectTimeoutMs: 10 * 1000,
        mainRevealCollectTimeoutMs: 10 * 1000,
        verificationSentWaitMs: 3000,
        verificationCodeLength: 4,
        verificationTimeoutMs: 15 * 1000,
        matchRevealCollectTimeoutMs: 3 * 60 * 1000,
        audioRetransmissionTimeoutMs: 10 * 1000,
        secretSharingTimeoutMs: 10 * 1000,
        cryptoServiceFactory: GPCryptoServiceAES_GCM_ECDH.new,
      );

  final int initDataTimeoutMs;

  /// Length of the nonce in bytes.
  /// Since the nonce is also used as a symmetric key for encryption, it should be at least 16 bytes (= 128 bits) long.
  /// For AES, the only valid lengths are 16, 24 and 32 bytes (= 128, 192, 256 bits resp.)
  final int nonceLength;
  final int connectionTimeoutMs;
  final int commitmentCollectTimeoutMs;
  final int mainRevealCollectTimeoutMs;
  final int verificationSentWaitMs;
  final int verificationCodeLength;
  final int verificationTimeoutMs;
  final int matchRevealCollectTimeoutMs;
  final int audioRetransmissionTimeoutMs;
  final int secretSharingTimeoutMs;
  final CryptoServiceFactory cryptoServiceFactory;



  const GrouppairingProtocolSettings({
    required this.initDataTimeoutMs,
    required this.nonceLength,
    required this.connectionTimeoutMs,
    required this.commitmentCollectTimeoutMs,
    required this.mainRevealCollectTimeoutMs,
    required this.verificationSentWaitMs,
    required this.verificationCodeLength,
    required this.verificationTimeoutMs,
    required this.matchRevealCollectTimeoutMs,
    required this.audioRetransmissionTimeoutMs,
    required this.secretSharingTimeoutMs,
    required this.cryptoServiceFactory,
  });
}
