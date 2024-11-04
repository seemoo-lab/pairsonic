<p align="center">
    <img src="doc/img/icon.png" width="200px"/>
</p>

<h1 align="center"> PairSonic </h1>

**PairSonic** is an open-source smartphone app that enables two or more users meeting in person to spontaneously exchange or verify their contact information.
PairSonic supports the secure exchange of cryptographic public keys, which is crucial for protecting end-to-end encrypted communication, e.g., in messenger apps (so called *authentication ceremony*).

PairSonic simplifies the pairing process by automating the tedious verification tasks of previous methods through an *acoustic out-of-band* channel using smartphones' built-in hardware.
It does not rely on external key management infrastructure, prior associations, or shared secrets.

## Demo Video

Click on the gif below to open the [full demo](https://youtu.be/e1AMYDLWN0E) where you can hear what it sounds like:

<a href="https://youtu.be/e1AMYDLWN0E"><img width="500px" src="doc/img/demo-short.gif"></img></a>

## Using PairSonic

This repository contains a demo implementation of the PairSonic contact exchange protocol.
The app is written in Flutter and targets Android devices.
Try it out yourself by following the build instructions below and installing the app.

When you start the app, you can create a profile (name, avatar, bio) and exchange it with nearby users (see [live demo](https://youtu.be/e1AMYDLWN0E?t=29)). The app itself doesn't have any functionality besides implementing the contact exchange, so you cannot do much with your newly exchanged contacts – except appreciating that your smartphone just sounded like R2D2, of course. And that this sound helped exchange your contact information via local ad-hoc communication, without relying on the Internet.

In the future, PairSonic could be integrated into other apps as an option for in-person contact exchange/verification.



## Features
- **Verify end-to-end encryption.** Securely exchanges cryptographic public keys.
- **Decentralized.** Operates without needing external key management infrastructure, prior associations, or shared secrets. Does not require an Internet connection.
- **User-friendly.** Automates verification tasks, making the process simpler and more secure.
- **Group compatibility.** Designed to work efficiently with both individual users and larger groups.
- **Customizable profiles.** Developers can customize the type of contact informaiton exchanged.
- **Broad compatibility.** Supports most Android devices with WiFi Direct, as long as they run Android 6 or newer (~2015).

## Build & Develop

Requirements:
- Flutter 3.22 or later (with Dart 3.4 or later)
- Java 17
- Gradle 7.4

In order to build & run the app, make sure to have [Android Studio](https://developer.android.com/studio) as well as [adb](https://developer.android.com/tools/adb) installed and set up. For Android Studio, the [Flutter](https://plugins.jetbrains.com/plugin/9212-flutter) and [Dart](https://plugins.jetbrains.com/plugin/6351-dart) plugins are recommended. Then, either run `flutter run` or click the play button next to the main function in [lib/main.dart](lib/main.dart) in Android Studio and choose "Run main.dart".

**Project structure & documentation**

The [doc/](doc/) directory contains more documentation, such as a description of the [code structure](doc/Code-Structure.md) and an overview of the [state machine](doc/PairSonic-Protocol.md) used during the PairSonic exchange.

**Localization (l10n)**

Localization strings are placed inside the [l10n](lib/l10n/) directory in language-specific `.arb` files. The Android Studio plugin [Flutter Intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl) automatically compiles these files into Dart code and outputs it into the [generated/intl](lib/generated/intl/) directory.

To manually generate these Dart files, run `flutter pub global run intl_utils:generate` in the project root.

## Powered by
The PairSonic protocol is based on the secure foundation of the excellent [SafeSlinger](https://doi.org/10.1145/2500423.2500428) protocol. PairSonic internally uses the [ggwave](https://github.com/ggerganov/ggwave) library for acoustic communication.

## Authors
- **Florentin Putz** ([email](mailto:fputz@seemoo.de), [web](https://fputz.net))
- **Thomas Völkl**
- **Maximilian Gehring**

## References

- Florentin Putz, Steffen Haesler, and Matthias Hollick. **Sounds Good? Fast and Secure Contact Exchange in Groups**. *Proc. ACM Hum.-Comput. Interact. 8, CSCW2*, 2024. (accepted for publication; soon at https://doi.org/10.1145/3686964) [[PDF](https://fputz.net/cscw24sounds/pdf/)]
- Florentin Putz, Steffen Haesler, Thomas Völkl, Maximilian Gehring, Nils Rollshausen, and Matthias Hollick. **PairSonic: Helping Groups Securely Exchange Contact Information**. *Companion of the 2024 Computer-Supported Cooperative Work and Social Computing (CSCW Companion ’24)*, 2024. (accepted for publication; soon at https://doi.org/10.1145/3678884.3681818) [[PDF](https://fputz.net/cscw24pairsonic/pdf/)]


## License
PairSonic is released under the [Apache-2.0](LICENSE) license.
