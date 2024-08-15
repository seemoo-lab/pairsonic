# Code Structure

In general, the code in the `lib/features` directory is organized by feature, i.e., the main items that users see on the app's home screen, each in their own respective subdirectory. Those are:
- Contacts
- Home Screen (initial screen)
- Pairing (= Contact Exchange)
- Profile
- Settings
- Setup (after first startup)

Next to `features`, the top level in the `lib` directory contains subdirectories related to app structure, such as route definitions, localization/internationalization files and storage interfaces.

---

- features/
    - contacts/
    - home/
    - pairing/
    - profile/
    - settings/
    - setup/
- generated/
- helper/
- l10n/
- router/
- storage/
- main.dart


## Group Pairing Structure

The primary feature demonstrated by PairSonic is the audio channel based contact exchange.

When a user taps *Contact Exchange* on the home screen, they are taken to the screen defined in [pairing_screen.dart](../lib/features/pairing/pairing_screen.dart), which shows the widget explained in the following.

All code related to the PairSonic contact exchange is found in [lib/features/pairing/audio](../lib/features/pairing/audio/).
- The main widget is defined in [ui/grouppairing_audio_widget.dart](../lib/features/pairing/audio/ui/grouppairing_audio_widget.dart). It changes based on the current state in the pairing process, i.e. role selection, setup, running, error, timeout and success. Widgets for each of these states are also located in the [ui/](../lib/features/pairing/audio/ui/) directory.
- The protocol execution is performed in [grouppairing_protocol.dart](). It has many internal states that all trigger different actions and UI changes. The most important part here is the `step()` function which is called periodically by the [running_widget.dart](../lib/features/pairing/audio/ui/running_widget.dart). More on the internals of the protocol can be found in [PairSonic-Protocol.md](PairSonic-Protocol.md).



## Platform Specific Code

At the moment, we only support Android devices. For some features to work, we needed to write some platform specific code that is called via Method Channels as described in the [Flutter docs](https://docs.flutter.dev/platform-integration/platform-channels). The Kotlin code for that can be found in the [android/app/src](../android/app/src/main/kotlin/de/seemoo/pairsonic/) directory. The following services are implemented there:
- `AudioControlChannel`: used among others to set the audio volume and get information about the device's audio capabilities
- `WifiP2pChannel`: used to enable WiFi P2P (WiFi-Direct) functionalities on the device as well as establish connections with the other participants during the PairSonic Contact Exchange.
