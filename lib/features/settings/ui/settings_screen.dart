import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/audio/services/audio_control_service.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/features/setup/ui/welcome_screen.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/main.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/service_locator.dart';

/// Allows user to change the settings which are stored by an implementation of [SettingsService]
///
/// {@category Screens}
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.adminMode = false});
  final bool adminMode;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = getIt<SettingsService>();
  final IdentityService _identityService = getIt<IdentityService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          getBasicSettings(),
          getAdvancedSettings(),
          getAdminSettings(),
        ]),
      ),
    );
  }

  Widget getBasicSettings() {
    return Column(
      children: [
        listSetting(
          label: S.of(context).language,
          key: "language",
          values: {'de': 'Deutsch', 'en': 'English'},
          onSelected: (value) {
            PairSonicApp.setLanguage(context, value);
          },
        ),
        ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
            child: Text(S.of(context).welcomeScreen)),
      ],
    );
  }

  Widget getAdvancedSettings() {
    return Column(
      children: [
        switchSetting(
            label: S.of(context).groupPairingUseUltrasound,
            key: "gpUseUltrasound",
            def: false),
        FutureBuilder(future: AudioControlService.doesMicSupportNearUltrasound(), builder: (context, snapshot) {
          return buildUltrasoundCheckRow(snapshot, S.of(context).settingsUltrasoundMicSupportTrue, S.of(context).settingsUltrasoundMicSupportFalse);
        }),
        FutureBuilder(future: AudioControlService.doesSpeakerSupportNearUltrasound(), builder: (context, snapshot) {
          return buildUltrasoundCheckRow(snapshot, S.of(context).settingsUltrasoundSpeakerSupportTrue, S.of(context).settingsUltrasoundSpeakerSupportFalse);
        }),
        listSetting(
            label: S.of(context).groupPairingAudioChannelBackend,
            key: "gpAudioChannelBackend",
            values: {'ggwave': 'ggwave'},
            onSelected: (value) => null,
            fallback: 'ggwave'),
      ],
    );
  }

  Widget buildUltrasoundCheckRow(AsyncSnapshot<bool> snapshot, String successText, String failText) {
    if (snapshot.hasData) {
      bool supported = snapshot.data!;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Row(
            children: [
              Icon(
                supported ? Icons.check : Icons.close,
                color: supported ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8.0),
              Text(supported ? successText : failText),
            ]
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getAdminSettings() {
    return Column(
      children: [
        switchSetting(label: S.of(context).initDatabase, key: "deleteDatabase"),
        ElevatedButton(
            onPressed: () {
              getIt<GuiUtilityInterface>().resetDatabase();
              getIt<GuiUtilityInterface>()
                  .insertOrUpdateUser(_identityService.self);
            },
            child: Text(S.of(context).initDatabaseNow)),
      ],
    );
  }

  Widget divider(String label) {
    //return ListTile(subtitle: Text(label),);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Container(padding: const EdgeInsets.only(left: 5), child: Text(label))
      ],
    );
  }

  Widget switchSetting(
      {required String label, required String key, bool def = false}) {
    bool value = def;
    if (_settingsService.getBool(key) != null) {
      value = _settingsService.getBool(key)!;
    }
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: (value) {
        _settingsService.setBool(key, value);
        setState(() {});
      },
    );
  }

  Widget textSetting(
      {required String label,
      required String key,
      String def = "",
      TextInputType? textInputType}) {
    String value = def;
    TextInputType textInputType0 = TextInputType.text;
    if (textInputType != null) textInputType0 = textInputType;
    if (_settingsService.getString(key) != null) {
      value = _settingsService.getString(key)!;
    } else if (def != "") {
      // Init with default value if nothing set, but default value given
      _settingsService.setString(key, value);
    }
    return ListTile(
      subtitle: Text(label),
      title: TextFormField(
          initialValue: value,
          keyboardType: textInputType0,
          onFieldSubmitted: (newValue) {
            setState(() {
              _settingsService.setString(key, newValue);
            });
          }),
    );
  }

  Widget textInfo(
      {required String label, required String info, String def = ""}) {
    return ListTile(subtitle: Text(label), title: Text(info));
  }

  Widget sliderSetting(
      {required String label,
      required double min,
      required double max,
      required String key,
      int decimals = 0,
      double def = 0.0}) {
    double value = def;
    if (_settingsService.getDouble(key) != null) {
      value = _settingsService.getDouble(key)!;
    }
    return ListTile(
      subtitle: Text(label),
      title: Column(
        children: [
          Slider(
            value: value,
            min: min,
            max: max,
            label: value.toStringAsFixed(decimals),
            onChanged: (double value) {
              setState(() {
                _settingsService.setDouble(key, value);
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(min.toStringAsFixed(decimals)),
                Text(value.toStringAsFixed(decimals)),
                Text(max.toStringAsFixed(decimals))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listSetting(
      {required String label,
      Icon? icon,
      required String key,
      required Map<String, String> values,
      required Function(String value) onSelected,
      String? fallback}) {
    String? initial;
    if (_settingsService.getString(key) != null) {
      initial = _settingsService.getString(key)!;
    } else {
      initial = fallback;
    }
    String initialText;
    if (values.containsKey(initial)) {
      initialText = values[initial]!;
    } else {
      initialText = initial ?? "";
    }
    return ListTile(
      subtitle: Text(initialText),
      title: Text(label),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.arrow_drop_down),
        onSelected: (String selected) {
          _settingsService.setString(key, selected);
          setState(() {});
          onSelected(selected);
        },
        itemBuilder: (context) => values.entries
            .map(
              (item) => PopupMenuItem<String>(
                value: item.key,
                child: Text(
                  item.value,
                ),
              ),
            )
            .toList(),
        initialValue: initial,
      ),
    );
  }
}
