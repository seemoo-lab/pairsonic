import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/settings/settings_interface.dart';
import 'service_locator.dart';

enum Database {
  sembast,
  sqlite
}

enum FailureMode {
  /// Default mode. Only fails if the protocol fails
  standard,

  /// Always fail. Can be used to simulate protocol failure
  failAlways,
}

enum PairingMethod {
  groupAudio,
}

extension PairingMethodHelper on PairingMethod {
  static SettingsService _getSettings() => getIt<SettingsService>();
  static const String _defaultKey = "PairingMethod";
  static final Map<String, PairingMethod> shortNamesMap =
      Map<String, PairingMethod>.fromIterable(
    PairingMethod.values,
    key: (pm) => (pm as PairingMethod).name,
  );

  String getIndexString() {
    return this.index.toRadixString(36).characters.last;
  }

  String _getFavouriteKey() => "${this.name}fav";
  String _getVisibilityKey() => "${this.name}vis";

  bool isFavourite() =>
      _getSettings().getBool(this._getFavouriteKey()) ?? false;
  bool isVisible() => _getSettings().getBool(this._getVisibilityKey()) ?? true;
  bool isDefault() => this == fromSettings();

  void setFavourite(bool value) =>
      _getSettings().setBool(this._getFavouriteKey(), value);
  void setVisible(bool value) =>
      _getSettings().setBool(this._getVisibilityKey(), value);
  void makeDefault() => _getSettings().setString(_defaultKey, this.name);

  String readableName(BuildContext context) {
    switch (this) {
      case PairingMethod.groupAudio:
        return "PairSonic";
    }
  }

  static PairingMethod? fromShortString(String? name) => shortNamesMap[name];

  static PairingMethod fromSettings() =>
      fromShortString(_getSettings().getString(_defaultKey)) ??
      PairingMethod.groupAudio;

  IconData getIcon() {
    switch (this) {
      case PairingMethod.groupAudio:
        return Icons.volume_up;
    }
  }
}

extension StringPadder on String {
  centerPadding(int targetLetterCount, [String padding = ' ']) {
    int length = this.length;
    int dif = targetLetterCount - length;
    if (dif <= 0) {
      return this;
    }
    if (dif % 2 == 1) {
      targetLetterCount++;
      dif++;
    }
    int halfDif = dif ~/ 2;
    return this
        .padLeft(
          length + halfDif,
          padding,
        )
        .padRight(targetLetterCount, padding);
  }

  centerPaddingWidth(double targetWidth, {bool preferPadLeft = false}) {
    final double u200aHairSpaceWidthTwice = (TextPainter(
            text: const TextSpan(text: "  "),
            maxLines: 1,
            textDirection: TextDirection.ltr)
          ..layout())
        .width;
    double width = (TextPainter(
            text: TextSpan(text: this),
            maxLines: 1,
            textDirection: TextDirection.ltr)
          ..layout())
        .width;
    double dif = targetWidth - width;
    double spaces = dif / u200aHairSpaceWidthTwice;

    return this
        .padLeft(
          this.length + (preferPadLeft ? spaces.ceil() : spaces.floor()),
          " ",
        )
        .padRight(
          this.length + spaces.ceil() + spaces.floor(),
          " ",
        );
  }
}

class StringEqualizer {
  final Map<String, String> equalizedStrings = {};

  StringEqualizer(List<String> strings, {bool preferPadLeft = false}) {
    double maxLen = 0;
    for (String string in strings) {
      Size size = (TextPainter(
              text: TextSpan(text: string),
              maxLines: 1,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;
      // debugPrint(size.toString());
      // debugPrint(size.width.toString());
      maxLen = max(maxLen, size.width);
    }
    // debugPrint(maxLen.toString());

    for (String string in strings) {
      equalizedStrings.putIfAbsent(
        string,
        () => string.centerPaddingWidth(
          maxLen,
          preferPadLeft: preferPadLeft,
        ),
      );
    }
  }
  String? get(String string) => equalizedStrings[string];
}

Iterable<IconData> base64tToIcons(Uint8List input) {
  assert(iconNames.length >= 256);
  // var newList = [];

  // for (int i = 2; i < input.length; i += 3) {
  //   print(input[i - 2].toRadixString(2).padLeft(6, "0"));
  //   print(input[i - 1].toRadixString(2).padLeft(6, "0"));
  //   print(input[i].toRadixString(2).padLeft(6, "0"));
  //   newList.add(int.parse(
  //       input[i - 2].toRadixString(2).padLeft(6, "0") +
  //           input[i - 1].toRadixString(2).padLeft(3, "0").substring(0, 3),
  //       radix: 2));
  //   newList.add(int.parse(
  //       input[i - 1].toRadixString(2).padLeft(6, "0").substring(3, 6) +
  //           input[i].toRadixString(2).padLeft(6, "0"),
  //       radix: 2));
  // }
  // var remainder = input.length.remainder(3);
  // if (remainder != 0) {
  //   if (remainder == 1) {
  //     newList.add(int.parse(
  //         input.last.toRadixString(2).padLeft(6, "0") +
  //             "".padLeft(3, "0").substring(0, 3),
  //         radix: 2));
  //   } else {
  //     newList.add(int.parse(
  //         input[input.length - 2].toRadixString(2).padLeft(6, "0") +
  //             input.last.toRadixString(2).padLeft(3, "0").substring(0, 3),
  //         radix: 2));
  //     newList.add(int.parse(
  //         input.last.toRadixString(2).padLeft(6, "0").substring(3, 6) +
  //             "".padLeft(3, "0"),
  //         radix: 2));
  //   }
  // }
  // newList.forEach((element) {
  //   print(element);
  // });
  return input.map((e) => iconNames[e]());
}

List<IconData Function()> iconNames = [
  () => Icons.onetwothree,
  () => Icons.threesixty,
  () => Icons.abc,
  () => Icons.accessibility,
  () => Icons.accessible,
  () => Icons.adb,
  () => Icons.add,
  () => Icons.addchart,
  () => Icons.adjust,
  () => Icons.adobe,
  () => Icons.agriculture,
  () => Icons.air,
  () => Icons.airlines,
  () => Icons.airplay,
  () => Icons.alarm,
  () => Icons.album,
  () => Icons.analytics,
  () => Icons.anchor,
  () => Icons.android,
  () => Icons.animation,
  () => Icons.announcement,
  () => Icons.aod,
  () => Icons.apartment,
  () => Icons.api,
  () => Icons.apple,
  () => Icons.approval,
  () => Icons.apps,
  () => Icons.architecture,
  () => Icons.archive,
  () => Icons.article,
  () => Icons.assessment,
  () => Icons.assignment,
  () => Icons.assistant,
  () => Icons.atm,
  () => Icons.attachment,
  () => Icons.attractions,
  () => Icons.attribution,
  () => Icons.audiotrack,
  () => Icons.autorenew,
  () => Icons.backpack,
  () => Icons.backspace,
  () => Icons.backup,
  () => Icons.badge,
  () => Icons.balance,
  () => Icons.balcony,
  () => Icons.ballot,
  () => Icons.bathroom,
  () => Icons.bathtub,
  () => Icons.bed,
  () => Icons.bedtime,
  () => Icons.beenhere,
  () => Icons.bento,
  () => Icons.biotech,
  () => Icons.blender,
  () => Icons.block,
  () => Icons.bloodtype,
  () => Icons.bluetooth,
  () => Icons.bolt,
  () => Icons.book,
  () => Icons.bookmark,
  () => Icons.bookmarks,
  () => Icons.boy,
  () => Icons.brush,
  () => Icons.build,
  () => Icons.bungalow,
  () => Icons.business,
  () => Icons.cabin,
  () => Icons.cable,
  () => Icons.cached,
  () => Icons.cake,
  () => Icons.calculate,
  () => Icons.call,
  () => Icons.camera,
  () => Icons.cameraswitch,
  () => Icons.campaign,
  () => Icons.cancel,
  () => Icons.carpenter,
  () => Icons.cases,
  () => Icons.casino,
  () => Icons.cast,
  () => Icons.castle,
  () => Icons.category,
  () => Icons.celebration,
  () => Icons.chair,
  () => Icons.chalet,
  () => Icons.chat,
  () => Icons.check,
  () => Icons.checklist,
  () => Icons.checkroom,
  () => Icons.church,
  () => Icons.circle,
  () => Icons.clear,
  () => Icons.close,
  () => Icons.cloud,
  () => Icons.co2,
  () => Icons.code,
  () => Icons.coffee,
  () => Icons.collections,
  () => Icons.colorize,
  () => Icons.comment,
  () => Icons.commit,
  () => Icons.commute,
  () => Icons.compare,
  () => Icons.compost,
  () => Icons.compress,
  () => Icons.computer,
  () => Icons.construction,
  () => Icons.contactless,
  () => Icons.contacts,
  () => Icons.contrast,
  () => Icons.cookie,
  () => Icons.copy,
  () => Icons.copyright,
  () => Icons.coronavirus,
  () => Icons.cottage,
  () => Icons.countertops,
  () => Icons.create,
  () => Icons.crib,
  () => Icons.crop,
  () => Icons.css,
  () => Icons.cut,
  () => Icons.dangerous,
  () => Icons.dashboard,
  () => Icons.deblur,
  () => Icons.deck,
  () => Icons.dehaze,
  () => Icons.delete,
  () => Icons.description,
  () => Icons.deselect,
  () => Icons.details,
  () => Icons.devices,
  () => Icons.dialpad,
  () => Icons.diamond,
  () => Icons.difference,
  () => Icons.dining,
  () => Icons.directions,
  () => Icons.discord,
  () => Icons.discount,
  () => Icons.dns,
  () => Icons.dock,
  () => Icons.domain,
  () => Icons.done,
  () => Icons.doorbell,
  () => Icons.download,
  () => Icons.downloading,
  () => Icons.drafts,
  () => Icons.draw,
  () => Icons.dry,
  () => Icons.duo,
  () => Icons.dvr,
  () => Icons.earbuds,
  () => Icons.east,
  () => Icons.eco,
  () => Icons.edit,
  () => Icons.egg,
  () => Icons.eject,
  () => Icons.elderly,
  () => Icons.elevator,
  () => Icons.email,
  () => Icons.emergency,
  () => Icons.engineering,
  () => Icons.equalizer,
  () => Icons.error,
  () => Icons.escalator,
  () => Icons.euro,
  () => Icons.event,
  () => Icons.expand,
  () => Icons.explicit,
  () => Icons.explore,
  () => Icons.exposure,
  () => Icons.extension,
  () => Icons.face,
  () => Icons.facebook,
  () => Icons.factory,
  () => Icons.fastfood,
  () => Icons.favorite,
  () => Icons.fax,
  () => Icons.feed,
  () => Icons.feedback,
  () => Icons.female,
  () => Icons.fence,
  () => Icons.festival,
  () => Icons.filter,
  () => Icons.fingerprint,
  () => Icons.fireplace,
  () => Icons.fitbit,
  () => Icons.flag,
  () => Icons.flaky,
  () => Icons.flare,
  () => Icons.flatware,
  () => Icons.flight,
  () => Icons.flip,
  () => Icons.flourescent,
  () => Icons.foggy,
  () => Icons.folder,
  () => Icons.forest,
  () => Icons.fort,
  () => Icons.forum,
  () => Icons.forward,
  () => Icons.foundation,
  () => Icons.fullscreen,
  () => Icons.functions,
  () => Icons.gamepad,
  () => Icons.games,
  () => Icons.garage,
  () => Icons.gavel,
  () => Icons.gesture,
  () => Icons.gif,
  () => Icons.girl,
  () => Icons.gite,
  () => Icons.grade,
  () => Icons.gradient,
  () => Icons.grading,
  () => Icons.grain,
  () => Icons.grass,
  () => Icons.group,
  () => Icons.groups,
  () => Icons.hail,
  () => Icons.handshake,
  () => Icons.handyman,
  () => Icons.hardware,
  () => Icons.hd,
  () => Icons.headphones,
  () => Icons.headset,
  () => Icons.healing,
  () => Icons.hearing,
  () => Icons.height,
  () => Icons.help,
  () => Icons.hevc,
  () => Icons.hexagon,
  () => Icons.highlight,
  () => Icons.hiking,
  () => Icons.history,
  () => Icons.hive,
  () => Icons.hls,
  () => Icons.home,
  () => Icons.hotel,
  () => Icons.house,
  () => Icons.houseboat,
  () => Icons.html,
  () => Icons.http,
  () => Icons.https,
  () => Icons.hub,
  () => Icons.hvac,
  () => Icons.icecream,
  () => Icons.image,
  () => Icons.inbox,
  () => Icons.info,
  () => Icons.input,
  () => Icons.insights,
  () => Icons.interests,
  () => Icons.inventory,
  () => Icons.iron,
  () => Icons.iso,
  () => Icons.javascript,
  () => Icons.kayaking,
  () => Icons.key,
  () => Icons.keyboard,
  () => Icons.kitchen,
  () => Icons.kitesurfing,
  () => Icons.label,
  () => Icons.lan,
  () => Icons.landscape,
  () => Icons.language,
  () => Icons.laptop,
  () => Icons.launch,
  () => Icons.layers,
  () => Icons.leaderboard,
  () => Icons.lens,
  () => Icons.light,
  () => Icons.lightbulb,
  () => Icons.link,
  () => Icons.liquor,
  () => Icons.list,
  () => Icons.living,
  () => Icons.lock,
  () => Icons.login,
  () => Icons.logout,
  () => Icons.looks,
  () => Icons.loop,
  () => Icons.loupe,
  () => Icons.loyalty,
  () => Icons.luggage,
  () => Icons.mail,
  () => Icons.male,
  () => Icons.man,
  () => Icons.map,
  () => Icons.margin,
  () => Icons.markunread,
  () => Icons.masks,
  () => Icons.maximize,
  () => Icons.mediation,
  () => Icons.medication,
  () => Icons.memory,
  () => Icons.menu,
  () => Icons.merge,
  () => Icons.message,
  () => Icons.messenger,
  () => Icons.mic,
  () => Icons.microwave,
  () => Icons.minimize,
  () => Icons.mms,
  () => Icons.mode,
  () => Icons.money,
  () => Icons.monitor,
  () => Icons.mood,
  () => Icons.moped,
  () => Icons.more,
  () => Icons.mosque,
  () => Icons.motorcycle,
  () => Icons.mouse,
  () => Icons.movie,
  () => Icons.moving,
  () => Icons.mp,
  () => Icons.museum,
  () => Icons.nat,
  () => Icons.nature,
  () => Icons.navigation,
  () => Icons.newspaper,
  () => Icons.nfc,
  () => Icons.nightlife,
  () => Icons.nightlight,
  () => Icons.north,
  () => Icons.note,
  () => Icons.notes,
  () => Icons.notifications,
  () => Icons.numbers,
  () => Icons.opacity,
  () => Icons.outbond,
  () => Icons.outbound,
  () => Icons.outbox,
  () => Icons.outlet,
  () => Icons.output,
  () => Icons.padding,
  () => Icons.pages,
  () => Icons.pageview,
  () => Icons.paid,
  () => Icons.palette,
  () => Icons.panorama,
  () => Icons.paragliding,
  () => Icons.park,
  () => Icons.password,
  () => Icons.paste,
  () => Icons.pattern,
  () => Icons.pause,
  () => Icons.payment,
  () => Icons.payments,
  () => Icons.paypal,
  () => Icons.pending,
  () => Icons.pentagon,
  () => Icons.people,
  () => Icons.percent,
  () => Icons.person,
  () => Icons.pets,
  () => Icons.phishing,
  () => Icons.phone,
  () => Icons.phonelink,
  () => Icons.photo,
  () => Icons.php,
  () => Icons.piano,
  () => Icons.pin,
  () => Icons.pinch,
  () => Icons.pix,
  () => Icons.place,
  () => Icons.plagiarism,
  () => Icons.plumbing,
  () => Icons.podcasts,
  () => Icons.policy,
  () => Icons.poll,
  () => Icons.polyline,
  () => Icons.polymer,
  () => Icons.pool,
  () => Icons.portrait,
  () => Icons.power,
  () => Icons.preview,
  () => Icons.print,
  () => Icons.psychology,
  () => Icons.public,
  () => Icons.publish,
  () => Icons.queue,
  () => Icons.quickreply,
  () => Icons.quiz,
  () => Icons.quora,
  () => Icons.radar,
  () => Icons.radio,
  () => Icons.receipt,
  () => Icons.recommend,
  () => Icons.rectangle,
  () => Icons.recycling,
  () => Icons.reddit,
  () => Icons.redeem,
  () => Icons.redo,
  () => Icons.refresh,
  () => Icons.remove,
  () => Icons.reorder,
  () => Icons.repeat,
  () => Icons.replay,
  () => Icons.reply,
  () => Icons.report,
  () => Icons.restaurant,
  () => Icons.restore,
  () => Icons.reviews,
  () => Icons.rocket,
  () => Icons.roofing,
  () => Icons.room,
  () => Icons.route,
  () => Icons.router,
  () => Icons.rowing,
  () => Icons.rsvp,
  () => Icons.rtt,
  () => Icons.rule,
  () => Icons.sailing,
  () => Icons.sanitizer,
  () => Icons.satellite,
  () => Icons.save,
  () => Icons.savings,
  () => Icons.scale,
  () => Icons.scanner,
  () => Icons.schedule,
  () => Icons.schema,
  () => Icons.school,
  () => Icons.science,
  () => Icons.score,
  () => Icons.scoreboard,
  () => Icons.screenshot,
  () => Icons.sd,
  () => Icons.search,
  () => Icons.security,
  () => Icons.segment,
  () => Icons.sell,
  () => Icons.send,
  () => Icons.sensors,
  () => Icons.settings,
  () => Icons.share,
  () => Icons.shield,
  () => Icons.shop,
  () => Icons.shopify,
  () => Icons.shortcut,
  () => Icons.shower,
  () => Icons.shuffle,
  () => Icons.sick,
  () => Icons.signpost,
  () => Icons.sip,
  () => Icons.skateboarding,
  () => Icons.sledding,
  () => Icons.slideshow,
  () => Icons.smartphone,
  () => Icons.sms,
  () => Icons.snapchat,
  () => Icons.snooze,
  () => Icons.snowboarding,
  () => Icons.snowing,
  () => Icons.snowmobile,
  () => Icons.snowshoeing,
  () => Icons.soap,
  () => Icons.sort,
  () => Icons.source,
  () => Icons.south,
  () => Icons.spa,
  () => Icons.speaker,
  () => Icons.speed,
  () => Icons.spellcheck,
  () => Icons.splitscreen,
  () => Icons.spoke,
  () => Icons.sports,
  () => Icons.square,
  () => Icons.stadium,
  () => Icons.stairs,
  () => Icons.star,
  () => Icons.stars,
  () => Icons.start,
  () => Icons.stop,
  () => Icons.storage,
  () => Icons.store,
  () => Icons.storefront,
  () => Icons.storm,
  () => Icons.straight,
  () => Icons.straighten,
  () => Icons.stream,
  () => Icons.streetview,
  () => Icons.stroller,
  () => Icons.style,
  () => Icons.subject,
  () => Icons.subscript,
  () => Icons.subscriptions,
  () => Icons.subtitles,
  () => Icons.subway,
  () => Icons.summarize,
  () => Icons.sunny,
  () => Icons.superscript,
  () => Icons.support,
  () => Icons.surfing,
  () => Icons.swipe,
  () => Icons.synagogue,
  () => Icons.sync,
  () => Icons.tab,
  () => Icons.tablet,
  () => Icons.tag,
  () => Icons.tapas,
  () => Icons.task,
  () => Icons.telegram,
  () => Icons.terminal,
  () => Icons.terrain,
  () => Icons.textsms,
  () => Icons.texture,
  () => Icons.theaters,
  () => Icons.thermostat,
  () => Icons.tiktok,
  () => Icons.timelapse,
  () => Icons.timeline,
  () => Icons.timer,
  () => Icons.title,
  () => Icons.toc,
  () => Icons.today,
  () => Icons.token,
  () => Icons.toll,
  () => Icons.tonality,
  () => Icons.topic,
  () => Icons.tour,
  () => Icons.toys,
  () => Icons.traffic,
  () => Icons.train,
  () => Icons.tram,
  () => Icons.transform,
  () => Icons.transgender,
  () => Icons.translate,
  () => Icons.tty,
  () => Icons.tune,
  () => Icons.tungsten,
  () => Icons.tv,
  () => Icons.umbrella,
  () => Icons.unarchive,
  () => Icons.undo,
  () => Icons.unpublished,
  () => Icons.unsubscribe,
  () => Icons.upcoming,
  () => Icons.update,
  () => Icons.upgrade,
  () => Icons.upload,
  () => Icons.usb,
  () => Icons.vaccines,
  () => Icons.verified,
  () => Icons.vibration,
  () => Icons.videocam,
  () => Icons.vignette,
  () => Icons.villa,
  () => Icons.visibility,
  () => Icons.voicemail,
  () => Icons.vrpano,
  () => Icons.wallpaper,
  () => Icons.warehouse,
  () => Icons.warning,
  () => Icons.wash,
  () => Icons.watch,
  () => Icons.water,
  () => Icons.waves,
  () => Icons.wc,
  () => Icons.web,
  () => Icons.webhook,
  () => Icons.wechat,
  () => Icons.weekend,
  () => Icons.west,
  // () => Icons.whatsapp,
  () => Icons.whatshot,
  () => Icons.widgets,
  () => Icons.wifi,
  () => Icons.window,
  () => Icons.woman,
  () => Icons.wordpress,
  () => Icons.work,
  () => Icons.workspaces,
  () => Icons.wysiwyg,
  () => Icons.yard
];
