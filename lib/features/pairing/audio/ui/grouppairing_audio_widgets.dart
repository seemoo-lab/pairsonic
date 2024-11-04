/// {@category GroupPairing}
library grouppairing_audio_widgets;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pairsonic/constants.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pairsonic/features/pairing/ui-shared/error_widget.dart';
import 'package:pairsonic/features/pairing/ui-shared/role_selection_card_widget.dart';
import 'package:pairsonic/helper/location_service_helper.dart';
import 'package:pairsonic/helper/ui/button_row.dart';
import 'package:pairsonic/helper/ui/gui_constants.dart';
import 'package:pairsonic/helper/ui/hint_text_card.dart';
import 'package:pairsonic/helper/ui/tappable_number_card.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_audio_routes.dart';
import 'package:pairsonic/features/pairing/audio/models/grouppairing_errors.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_protocol.dart';
import 'package:pairsonic/features/pairing/grouppairing_user_parser.dart';
import 'package:pairsonic/features/pairing/audio/wifip2p_communication.dart';
import 'package:pairsonic/helper/ui/animated_icon.dart';
import 'package:pairsonic/generated/l10n.dart';

import 'grouppairing_audio_widget.dart';

part 'coordinator_setup_widget.dart';
part 'role_widget.dart';
part 'running_widget.dart';
