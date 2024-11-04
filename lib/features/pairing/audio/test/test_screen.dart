import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/audio/services/string_audio_channel_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pairsonic/features/pairing/audio/interfaces/audio_channel_interface.dart';
import 'package:pairsonic/features/pairing/audio/services/ggwave_audio_channel_service.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/helper_functions.dart';
import 'package:pairsonic/service_locator.dart';

/// A screen that can be used to test the audio channel services.
/// This screen is only used for testing purposes.
/// It uses the [AudioChannelService] configured in the app's settings.
/// {@category Screens}
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final SettingsService _settingsService = getIt<SettingsService>();
  bool ultrasonic = false;
  final messageTextFieldController = TextEditingController();
  late AudioChannelService<String> audioChannelService;
  List<String> log = [];

  _TestScreenState() {
    log.add("${getTimestampFormatted(DateTime.now())} -- init");
    _updateAudioChannelService();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      () async {
        if (!await Permission.microphone.isGranted) {
          dynamic res = await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                      title: const Text("Permission Required"),
                      content: const Text(
                          "For group pairing, lokalfunk requires access to your microphone."),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context, "Cancel"),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              await Permission.microphone.request();
                              Navigator.pop(context, "Grant");
                            },
                            child: const Text("Grant"))
                      ]));
          if (res == "Grant") {
            if (!await Permission.microphone.isGranted) {
              Navigator.pop(context);
            }
          } else if (res == "Cancel") {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        }
      }.call();
    });
  }

  @override
  void dispose() {
    messageTextFieldController.dispose();
    super.dispose();
  }

  void _logEvent(String msg) {
    setState(() {
      log.add("${getTimestampFormatted(DateTime.now())} -- $msg");
    });
  }

  void _updateAudioChannelService() {
    var profile = _getAudioProfile();
    GgwaveAudioChannelService innerAudioChannelService;
    switch (_settingsService.getString("gpAudioChannelBackend") ?? "") {
      default:
        innerAudioChannelService = GgwaveAudioChannelService(profile: profile);
        break;
    }

    this.audioChannelService =
        StringAudioChannelService(innerAudioChannelService);
  }

  AudioChannelProfile _getAudioProfile() {
    if (this.ultrasonic) {
      return AudioChannelProfile.ultrasonic;
    } else {
      return AudioChannelProfile.audible;
    }
  }

  Future<void> _tx() async {
    if (messageTextFieldController.text.isEmpty) {
      _logEvent("Cannot TX empty message");
      return;
    }
    var sw = Stopwatch();
    sw.start();
    final bool result =
        await audioChannelService.startTransmission(messageTextFieldController.text);
    await audioChannelService.stopTransmission();
    _logEvent('TX (${sw.elapsedMilliseconds}ms): $result');
  }

  Future<void> _startRx() async {
    var sw = Stopwatch();
    sw.start();
    await audioChannelService.startReceiving();
    _logEvent('Start RX (${sw.elapsedMilliseconds}ms)');
  }

  Future<void> _stopRx() async {
    var sw = Stopwatch();
    sw.start();
    await audioChannelService.stopReceiving();
    _logEvent('Stop RX (${sw.elapsedMilliseconds}ms)');
  }

  Future<void> _getRx() async {
    var sw = Stopwatch();
    sw.start();
    final String? result = await audioChannelService.getReceivedData();
    _logEvent('RX\'ed (${sw.elapsedMilliseconds}ms): $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
              child: const Text('Back'),
              onPressed: () => Navigator.pop(context)),
          Text("Audio Channel Backend: ${_settingsService.getString("gpAudioChannelBackend") ?? ""}"),
          TextField(
            controller: messageTextFieldController,
            maxLength: 64,
            decoration: const InputDecoration(labelText: "Message"),
          ),
          ListTile(
              title: const Text("Ultrasonic"),
              leading: Switch(
                value: ultrasonic,
                onChanged: (bool val) {
                  setState(() {
                    ultrasonic = val;
                    _updateAudioChannelService();
                  });
                },
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
            onPressed: _tx,
            child: const Text('TX Audio'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
            child: const Text('TX Audio (10 times)'),
            onPressed: () async {
              for (var i = 0; i < 10; i++) {
                await _tx();
                await Future.delayed(const Duration(milliseconds: 500));
              }
              _logEvent("TX Audio (10 times) done");
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
            onPressed: _startRx,
            child: const Text('Start RX'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
            onPressed: _stopRx,
            child: const Text('Stop RX'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
            onPressed: _getRx,
            child: const Text('Get RX'),
          ),
          Expanded(
              child:
                  ListView(children: <Widget>[for (var msg in log) Text(msg)]))
        ]),
      ),
      appBar: AppBar(
        title: const Text('Test'),
        actions: const <Widget>[],
      ),
    );
  }
}
