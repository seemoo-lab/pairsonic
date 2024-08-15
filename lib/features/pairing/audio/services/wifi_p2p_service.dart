import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_constants.dart';

/// Dataclass containing the connection information of a Wi-Fi P2P connection.
class WifiP2pConnectionInfo {
  final bool isOwner;
  final String ownerAddress;

  WifiP2pConnectionInfo({required this.isOwner, required this.ownerAddress});

  @override
  String toString() {
    return 'WifiP2pConnectionInfo{isOwner: $isOwner, ownerAddress: $ownerAddress}';
  }
}

/// Dataclass containing the group information of a Wi-Fi P2P group.
class WifiP2pGroupInfo {
  final String ssid;
  final String passphrase;

  WifiP2pGroupInfo({required this.ssid, required this.passphrase});

  @override
  String toString() {
    return 'WifiP2pGroupInfo{ssid: $ssid, passphrase: $passphrase}';
  }
}

class WifiP2pService with WidgetsBindingObserver {
  static const _platform = MethodChannel("gp_wifip2p");

  bool _available = false;

  // The following values are automatically updating when
  // one creates the Wi-Fi P2P group or in general, when the
  // SDK version >= 29.
  WifiP2pGroupInfo? _groupInfo;
  WifiP2pConnectionInfo? _connectionInfo;
  WidgetsBinding? _boundTo;

  late _LifecycleObserver _lifecycleObserver;
  WifiP2pService() {
    _lifecycleObserver = _LifecycleObserver(this);
    _platform.setMethodCallHandler(_nativeCall);
  }
  bool get available => _available;

  WifiP2pConnectionInfo? get connectionInfo => _connectionInfo;
  WifiP2pGroupInfo? get groupInfo => _groupInfo;

  /// Function used to connect to a given [group].
  /// The function send a connection request to the Wi-Fi P2P framework.
  ///
  /// One must check that the connection has been established successfully by
  /// [groupInfo] and [connectionInfo].
  Future<bool> connect(WifiP2pGroupInfo group) async {
    bool res = await _platform.invokeMethod('connect', <String, dynamic>{
      'ssid': group.ssid,
      'passphrase': group.passphrase,
    });
    debugPrint("WifiP2pService - connect: Connected to Wifi Group ($res)");
    return res;
  }

  /// Creates a new Wi-Fi P2P group.
  Future<bool> createGroup() async {
    bool res = await _platform.invokeMethod('create_group');
    debugPrint("WifiP2pService - createGroup: Created Wifi Group ($res)");
    return res;
  }

  /// Initializes the Wi-Fi P2P service. This function is idempotent and can be
  /// called multiple times.
  Future<void> init() async {
    bool res = await _platform.invokeMethod('init');
    debugPrint(
        "WifiP2pService - asyncInit: Initialized Wifi P2P Backend ($res)");
    await _register();
    if (_boundTo == null) {
      _boundTo = WidgetsBinding.instance;
      _boundTo!.addObserver(_lifecycleObserver);
    }
  }

  /// Removes the current Wi-Fi P2P group.
  Future<void> removeGroup() async {
    bool res = await _platform.invokeMethod('remove_group');
    _groupInfo = null;
    _connectionInfo = null;
    debugPrint("WifiP2pService - removeGroup: Removed Wifi Group ($res)");
  }

  /// Disconnects from the current Wi-Fi P2P group.
  /// This is not needed if SDK version >= 29.
  ///
  /// On SDK version < 29, this restores the network the device
  /// was previously connected to.
  Future<void> disconnect() async {
    bool res = await _platform.invokeMethod('disconnect');
    _groupInfo = null;
    _connectionInfo = null;
    debugPrint("WifiP2pService - disconnect: Disconnected ($res)");
  }

  /// Requests the currently available [WifiP2pConnectionInfo].
  /// This function also updates [connectionInfo].
  ///
  /// In case the SDK version is < 29, this function
  /// returns the connection info after connecting to it using [connnect].
  Future<WifiP2pConnectionInfo?> requestConnectionInfo() async {
    Map<Object?, Object?>? connectionInfoData =
        await _platform.invokeMethod('req_connection_info');
    _connectionInfo = null;
    if (connectionInfoData != null) {
      _connectionInfo = WifiP2pConnectionInfo(
          isOwner: (connectionInfoData["isOwner"] as bool?)!,
          ownerAddress: (connectionInfoData["ownerAddress"] as String?)!);
    }
    debugPrint(
        "WifiP2pService - requestConnectionInfo: Got connection info ($_connectionInfo)");
    return _connectionInfo;
  }

  /// Requests the currently available [WifiP2pGroupInfo].
  /// This function also update [groupInfo].
  ///
  /// In case the SDK version is < 29, this function
  /// returns the group info after connecting to it using [connnect].
  Future<WifiP2pGroupInfo?> requestGroupInfo() async {
    Map<Object?, Object?>? groupInfoData =
        await _platform.invokeMethod('req_group_info');
    _groupInfo = null;
    if (groupInfoData != null) {
      _groupInfo = WifiP2pGroupInfo(
          ssid: (groupInfoData["ssid"] as String?)!,
          passphrase: (groupInfoData["passphrase"] as String?)!);
    }
    debugPrint(
        "WifiP2pService - requestGroupInfo: Got group info ($_groupInfo)");
    return _groupInfo;
  }

  /// Waits up to [timeout] until the Wi-Fi P2P service is available.
  Future<bool> waitForAvailable(
      {Duration timeout = const Duration(seconds: wifiP2pWaitForAvailableTimeoutSeconds)}) async {
    bool waitForAvailable = true;
    await Future.doWhile(() => Future.delayed(const Duration(milliseconds: wifiP2pBusyWaitingTimerPeriodMs))
            .then((_) => !available && waitForAvailable))
        .timeout(timeout, onTimeout: () {
      waitForAvailable = false;
    });
    return available;
  }

  /// Waits up to [timeout] for a connection to be established.
  Future<WifiP2pConnectionInfo?> waitForConnectionInfo(
      {Duration timeout = const Duration(seconds: wifiP2pWaitForConnectionInfoTimeoutSeconds)}) async {
    bool waitFor = true;
    await Future.doWhile(() => Future.delayed(const Duration(milliseconds: wifiP2pBusyWaitingTimerPeriodMs))
            .then((_) => (connectionInfo == null) && waitFor))
        .timeout(timeout, onTimeout: () {
      waitFor = false;
    });
    return connectionInfo;
  }

  /// Waits up to [timeout] for a group to be created.
  Future<WifiP2pGroupInfo?> waitForGroupInfo(
      {Duration timeout = const Duration(seconds: wifiP2pWaitForGroupInfoTimeoutSeconds)}) async {
    bool waitFor = true;
    await Future.doWhile(() => Future.delayed(const Duration(milliseconds: wifiP2pBusyWaitingTimerPeriodMs))
            .then((_) => (groupInfo == null) && waitFor))
        .timeout(timeout, onTimeout: () {
      waitFor = false;
    });
    return groupInfo;
  }

  /// This function is called by the native code on certain events.
  Future<dynamic> _nativeCall(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'wifi_p2p_available':
        _available = methodCall.arguments as bool;
        debugPrint(
            "WifiP2pService - _nativeCall: Wifi P2P available: $_available");
        return true;
      case 'wifi_p2p_group_info':
        _groupInfo = WifiP2pGroupInfo(
            ssid: methodCall.arguments["ssid"] as String,
            passphrase: methodCall.arguments["passphrase"] as String);
        debugPrint("WifiP2pService - _nativeCall: Got group info ($groupInfo)");
        return true;
      case 'wifi_p2p_connection_info':
        _connectionInfo = WifiP2pConnectionInfo(
            isOwner: methodCall.arguments["isOwner"] as bool,
            ownerAddress: methodCall.arguments["ownerAddress"] as String);
        debugPrint(
            "WifiP2pService - _nativeCall: Got connection info ($connectionInfo)");
        return true;
      default:
        throw MissingPluginException('notImplemented');
    }
  }

  /// Registers the native code to receive Wi-Fi P2P events.
  Future<void> _register() async {
    bool res = await _platform.invokeMethod('register');
    debugPrint(
        "WifiP2pService - register: Registered BroadcastReceiver ($res)");
  }

  /// Unregisters the native code from receiving Wi-Fi P2P events.
  Future<void> _unregister() async {
    bool res = await _platform.invokeMethod('unregister');
    debugPrint(
        "WifiP2pService - register: Unregistered BroadcastReceiver ($res)");
  }
}

/// [_LifecycleObserver] registers and unregisters a given [WifiP2pService] when
/// the app is paused or resumed.
/// This is to preserve battery life.
class _LifecycleObserver with WidgetsBindingObserver {
  final WifiP2pService _service;

  _LifecycleObserver(this._service);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _service._register();
        break;
      case AppLifecycleState.paused:
        _service._unregister();
        break;
      default:
    }
  }
}
