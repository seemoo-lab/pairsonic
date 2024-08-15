/// Represents the data model for user data.
///
/// Instead of a profile picture, avatars a choosen from a fixed list of local stored images.
/// {@category Models}
class User {
  final String id;
  late String name;
  late String bio;
  final bool verified;
  late int iconId;

  static const String localDbTableName = "tbl_user";
  //https://icons8.com/icon/set/culture/color--static
  //Add to fav
  //Download 100px
  //Python script:
  /*
    from PIL import Image
    import os

    path = R"C:\Users\Steffen\Downloads\Favorites"
    if not os.path.isdir(path + '/images'):
        os.mkdir(path + '/images')

    count = 4
    for file in os.listdir(path):
        if os.path.isdir(file):
            continue
        full_path = os.path.join(path, file)
        dirname, fname = os.path.split(file)
        image = Image.open(full_path)
        profile_image = Image.new('RGBA', (512, 512), (0, 0, 0, 0))
        resized = image.resize((300, 300))
        profile_image.paste(resized, (106, 106))
        filename = file.replace('icons8-','').replace('-100.png','-300-framed.png')
        profile_image.save(path + '/images/' + filename)
        print(str(count) + ": \"assets/profileImages/" + filename + "\",")
        count += 1
   */
  static const Map<int, String> iconIdPathMapping = {
    0: "assets/profileImages/rubber-duck-300-framed.png",
    1: "assets/profileImages/pig-300-framed.png",
    2: "assets/profileImages/settings-300-framed.png",
    3: "assets/profileImages/emergenCITY-300-framed.png",
    4: "assets/profileImages/albus-dumbledore-300-framed.png",
    5: "assets/profileImages/alien-300-framed.png",
    6: "assets/profileImages/all-terrain-armored-transport-300-framed.png",
    7: "assets/profileImages/ambulance-300-framed.png",
    8: "assets/profileImages/amelie-poulain-300-framed.png",
    9: "assets/profileImages/anonymous-mask-300-framed.png",
    10: "assets/profileImages/asteroid-300-framed.png",
    11: "assets/profileImages/astronaut-300-framed.png",
    12: "assets/profileImages/atom-300-framed.png",
    13: "assets/profileImages/baguette-300-framed.png",
    14: "assets/profileImages/batman-300-framed.png",
    15: "assets/profileImages/bee-300-framed.png",
    16: "assets/profileImages/beer-mug-300-framed.png",
    17: "assets/profileImages/biotech-300-framed.png",
    18: "assets/profileImages/black-cat-300-framed.png",
    19: "assets/profileImages/border-collie-300-framed.png",
    20: "assets/profileImages/bot-300-framed.png",
    21: "assets/profileImages/bowler-hat-300-framed.png",
    22: "assets/profileImages/brezel-300-framed.png",
    23: "assets/profileImages/budgie-300-framed.png",
    24: "assets/profileImages/bumper-car-300-framed.png",
    25: "assets/profileImages/c-3po-300-framed.png",
    26: "assets/profileImages/cat-head-300-framed.png",
    27: "assets/profileImages/chewbacca-300-framed.png",
    28: "assets/profileImages/chicken-300-framed.png",
    29: "assets/profileImages/circus-tent-300-framed.png",
    30: "assets/profileImages/clown-fish-300-framed.png",
    31: "assets/profileImages/comet-300-framed.png",
    32: "assets/profileImages/communicator-300-framed.png",
    33: "assets/profileImages/computer-300-framed.png",
    34: "assets/profileImages/cookie-monster-300-framed.png",
    35: "assets/profileImages/corgi-300-framed.png",
    36: "assets/profileImages/cow-300-framed.png",
    37: "assets/profileImages/crab-300-framed.png",
    38: "assets/profileImages/croissant-300-framed.png",
    39: "assets/profileImages/cute-hamster-300-framed.png",
    40: "assets/profileImages/cute-mouse-300-framed.png",
    41: "assets/profileImages/cyborg-300-framed.png",
    42: "assets/profileImages/darth-vader-300-framed.png",
    43: "assets/profileImages/day-of-the-dead-300-framed.png",
    44: "assets/profileImages/death-star-300-framed.png",
    45: "assets/profileImages/dinosaur-300-framed.png",
    46: "assets/profileImages/dinosaur-egg-300-framed.png",
    47: "assets/profileImages/dobby-300-framed.png",
    48: "assets/profileImages/dog-300-framed.png",
    49: "assets/profileImages/donkey-300-framed.png",
    50: "assets/profileImages/dove-300-framed.png",
    51: "assets/profileImages/draco-malfoy-300-framed.png",
    52: "assets/profileImages/enterprise-ncc-1701-300-framed.png",
    53: "assets/profileImages/experiment-300-framed.png",
    54: "assets/profileImages/fat-cat-300-framed.png",
    55: "assets/profileImages/fat-dog-300-framed.png",
    56: "assets/profileImages/fighter-300-framed.png",
    57: "assets/profileImages/fire-alarm-300-framed.png",
    58: "assets/profileImages/fire-hydrant-300-framed.png",
    59: "assets/profileImages/fire-station-300-framed.png",
    60: "assets/profileImages/flamingo-300-framed.png",
    61: "assets/profileImages/fly-300-framed.png",
    62: "assets/profileImages/fox-300-framed.png",
    63: "assets/profileImages/frodo-300-framed.png",
    64: "assets/profileImages/full-moon-300-framed.png",
    65: "assets/profileImages/futurama-amy-wong-300-framed.png",
    66: "assets/profileImages/futurama-bender-300-framed.png",
    67: "assets/profileImages/futurama-fry-300-framed.png",
    68: "assets/profileImages/futurama-hermes-conrad-300-framed.png",
    69: "assets/profileImages/futurama-mom-300-framed.png",
    70: "assets/profileImages/futurama-professor-farnsworth-300-framed.png",
    71: "assets/profileImages/futurama-zapp-brannigan-300-framed.png",
    72: "assets/profileImages/futurama-zoidberg-300-framed.png",
    73: "assets/profileImages/gandalf-300-framed.png",
    74: "assets/profileImages/genie-300-framed.png",
    75: "assets/profileImages/german-shepherd-300-framed.png",
    76: "assets/profileImages/goblin-300-framed.png",
    77: "assets/profileImages/graduation-cap-300-framed.png",
    78: "assets/profileImages/grey-300-framed.png",
    79: "assets/profileImages/hal-9000-300-framed.png",
    80: "assets/profileImages/happy-mac-300-framed.png",
    81: "assets/profileImages/harry-potter-300-framed.png",
    82: "assets/profileImages/herbie-300-framed.png",
    83: "assets/profileImages/hermione-300-framed.png",
    84: "assets/profileImages/hulk-300-framed.png",
    85: "assets/profileImages/iron-man-300-framed.png",
    86: "assets/profileImages/joker-dc-300-framed.png",
    87: "assets/profileImages/kitty-300-framed.png",
    88: "assets/profileImages/kiwi-bird-300-framed.png",
    89: "assets/profileImages/klingon-head-300-framed.png",
    90: "assets/profileImages/laboratory-300-framed.png",
    91: "assets/profileImages/ladybird-300-framed.png",
    92: "assets/profileImages/lamb-300-framed.png",
    93: "assets/profileImages/legolas-300-framed.png",
    94: "assets/profileImages/lifeboat-300-framed.png",
    95: "assets/profileImages/lion-300-framed.png",
    96: "assets/profileImages/lord-voldemort-300-framed.png",
    97: "assets/profileImages/lucifer-300-framed.png",
    98: "assets/profileImages/luke-skywalker-300-framed.png",
    99: "assets/profileImages/memory-slot-300-framed.png",
    100: "assets/profileImages/monarch-butterfly-300-framed.png",
    101: "assets/profileImages/money-heist-dali-300-framed.png",
    102: "assets/profileImages/neo-300-framed.png",
    103: "assets/profileImages/ninja-turtle-300-framed.png",
    104: "assets/profileImages/octopus-300-framed.png",
    105: "assets/profileImages/orc-300-framed.png",
    106: "assets/profileImages/party-balloon-300-framed.png",
    107: "assets/profileImages/pirate-300-framed.png",
    108: "assets/profileImages/planetarium-300-framed.png",
    109: "assets/profileImages/police-car-300-framed.png",
    110: "assets/profileImages/prawn-300-framed.png",
    111: "assets/profileImages/professor-x-300-framed.png",
    112: "assets/profileImages/puffin-bird-300-framed.png",
    113: "assets/profileImages/r2-d2-300-framed.png",
    114: "assets/profileImages/rebel-300-framed.png",
    115: "assets/profileImages/red-panda-300-framed.png",
    116: "assets/profileImages/ron-weasley-300-framed.png",
    117: "assets/profileImages/seahorse-300-framed.png",
    118: "assets/profileImages/seal-300-framed.png",
    119: "assets/profileImages/sheep-300-framed.png",
    120: "assets/profileImages/sherlock-holmes-300-framed.png",
    121: "assets/profileImages/siren-300-framed.png",
    122: "assets/profileImages/smurf-300-framed.png",
    123: "assets/profileImages/snail-300-framed.png",
    124: "assets/profileImages/squirrel-300-framed.png",
    125: "assets/profileImages/star-trek-300-framed.png",
    126: "assets/profileImages/star-trek-symbol-300-framed.png",
    127: "assets/profileImages/star-wars-millenium-falcon-300-framed.png",
    128: "assets/profileImages/starfish-300-framed.png",
    129: "assets/profileImages/steve-jobs-300-framed.png",
    130: "assets/profileImages/superman-dc-300-framed.png",
    131: "assets/profileImages/t-65b-x-wing-starfighter-300-framed.png",
    132: "assets/profileImages/tapir-300-framed.png",
    133: "assets/profileImages/telescope-300-framed.png",
    134: "assets/profileImages/tire-swing-300-framed.png",
    135: "assets/profileImages/trinity-300-framed.png",
    136: "assets/profileImages/turtle-300-framed.png",
    137: "assets/profileImages/unicorn-300-framed.png",
    138: "assets/profileImages/vomiting-unicorn-300-framed.png",
    139: "assets/profileImages/wonder-woman-300-framed.png",
    140: "assets/profileImages/woodpecker-300-framed.png",
    141: "assets/profileImages/woody-woodpecker-300-framed.png",
    142: "assets/profileImages/yoda-300-framed.png",
    143: "assets/profileImages/zebra-300-framed.png",
    666: "assets/profileImages/account-300-framed.png"
  };

  User({
    required this.id,
    required this.name,
    required this.bio,
    required this.verified,
    required this.iconId,
  });

  String get iconPath {
    return User.iconIdPathMapping[this.iconId] ?? User.iconIdPathMapping[1]!;
  }

  /// Generates an [User] object from JSON data
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["userId"],
      name: json["name"],
      bio: json["bio"],
      verified: json["verified"] == 1 ? true : false,
      iconId: json["iconId"],
    );
  }

  /// Generates JSON Data from [User] object
  Map<String, dynamic> toMap() => {
    "userId": id,
    "name": name,
    "bio": bio,
    "verified": verified ? 1 : 0,
    "iconId": iconId,
  };

  @override
  String toString() {
    return "User{userId: $id, name: $name, bio: $bio, verified: $verified, iconId: $iconId";
  }
}

/// Represents the data model for paring users with short identifiers in JSON messages.
///
/// The idea is to save space in pairing transmissions.
/// {@category Models}
class PairingData {
  final String name;
  final String deviceId;
  final int iconId;
  final String bio;

  PairingData({
    required this.name,
    required this.deviceId,
    required this.iconId,
    required this.bio,
  });

  /// Generates an [PairingData] object from JSON data
  factory PairingData.fromJson(Map<String, dynamic> json) {
    return PairingData(
      name: json['n'],
      deviceId: json['d'],
      iconId: json['i'],
      bio: json['b'],
    );
  }

  factory PairingData.fromUser(User user) {
    return PairingData(
      name: user.name,
      deviceId: user.id,
      iconId: user.iconId,
      bio: user.bio,
    );
  }

  /// Generates JSON Data from [PairingData] object
  Map<String, dynamic> toJson() =>
      {'n': name, 'd': deviceId, 'i': iconId, 'b': bio};

  @override
  String toString() {
    return "PairingData{d: $deviceId, n: $name, b: $bio, i: $iconId";
  }

  ShortPairingData toShortPairingData() {
    return ShortPairingData.fromPairingData(this);
  }
}

class ShortPairingData {
  final String name;
  final String deviceId;
  final int iconId;

  ShortPairingData({
    required this.name,
    required this.deviceId,
    required this.iconId,
  });

  factory ShortPairingData.fromPairingData(PairingData pairingData) {
    return ShortPairingData(
      name: pairingData.name,
      deviceId: pairingData.deviceId,
      iconId: pairingData.iconId,
    );
  }

  /// Generates an [ShortPairingData] object from JSON data
  factory ShortPairingData.fromJson(Map<String, dynamic> json) {
    return ShortPairingData(
      name: json['n'],
      deviceId: json['d'],
      iconId: json['i'],
    );
  }

  /// Generates JSON Data from [ShortPairingData] object
  Map<String, dynamic> toJson() => {'n': name, 'd': deviceId, 'i': iconId};

  PairingData toPairingData() => PairingData(
    name: name,
    deviceId: deviceId,
    iconId: iconId,
    bio: "",
  );

  @override
  String toString() {
    return "PairingData{d: $deviceId, n: $name, i: $iconId";
  }
}
