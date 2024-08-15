// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(duration) =>
      "No Audio data received in ${duration} seconds. Please check the volume on the other device or move the devices closer.";

  static String m1(size) => "Compare screen on ${size} devices.";

  static String m2(size) => "Group of ${size} people";

  static String m3(size) =>
      "Your contact information was exchanged successfully. Do all ${size} participants have a blue lock icon on their screen?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AudioInactivityMessage": m0,
        "AudioProcessingErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Error during Processing.\\nTry to move the phones closer or try again in a quiter environment."),
        "addContact": MessageLookupByLibrary.simpleMessage("Add contact"),
        "adminSettings": MessageLookupByLibrary.simpleMessage("Admin settings"),
        "adminSettingsShow":
            MessageLookupByLibrary.simpleMessage("Show admin settings"),
        "advancedSettings":
            MessageLookupByLibrary.simpleMessage("Advanced Settings"),
        "advancedSettingsShow":
            MessageLookupByLibrary.simpleMessage("Show Advanced Settings"),
        "appName": MessageLookupByLibrary.simpleMessage("PairSonic"),
        "bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmationDialogTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
        "continueText": MessageLookupByLibrary.simpleMessage("Continue"),
        "createTestdata":
            MessageLookupByLibrary.simpleMessage("Add testdata on reset"),
        "dialogButtonCancel": MessageLookupByLibrary.simpleMessage("CANCEL"),
        "dialogButtonGrant": MessageLookupByLibrary.simpleMessage("GRANT"),
        "dialogButtonLeave": MessageLookupByLibrary.simpleMessage("LEAVE"),
        "dialogButtonNo": MessageLookupByLibrary.simpleMessage("No"),
        "dialogButtonOK": MessageLookupByLibrary.simpleMessage("OK"),
        "dialogButtonStay": MessageLookupByLibrary.simpleMessage("STAY"),
        "dialogButtonYes": MessageLookupByLibrary.simpleMessage("Yes"),
        "emptyId": MessageLookupByLibrary.simpleMessage("Bitte genter an ID"),
        "emptyName":
            MessageLookupByLibrary.simpleMessage("Please enter a name"),
        "enterBio": MessageLookupByLibrary.simpleMessage("Please enter a bio"),
        "enterName":
            MessageLookupByLibrary.simpleMessage("Please enter a name"),
        "failed": MessageLookupByLibrary.simpleMessage("Failed"),
        "finishedProfile": MessageLookupByLibrary.simpleMessage(
            "The profile is configured. You can now enter the start screen of the app"),
        "generalButtonBack": MessageLookupByLibrary.simpleMessage("Back"),
        "generalButtonDone": MessageLookupByLibrary.simpleMessage("Done"),
        "generalButtonNext": MessageLookupByLibrary.simpleMessage("Next"),
        "go": MessageLookupByLibrary.simpleMessage("Start!"),
        "groupPairing": MessageLookupByLibrary.simpleMessage("Group Pairing"),
        "groupPairingAudioChannelBackend":
            MessageLookupByLibrary.simpleMessage("Audio Channel Backend"),
        "groupPairingCloseToOther": MessageLookupByLibrary.simpleMessage(
            "Please keep your device close to the other devices."),
        "groupPairingCompareScreen": m1,
        "groupPairingConnectingWithParticipants":
            MessageLookupByLibrary.simpleMessage(
                "Connecting with participants..."),
        "groupPairingCoordinator":
            MessageLookupByLibrary.simpleMessage("Coordinator"),
        "groupPairingCoordinatorHelp": MessageLookupByLibrary.simpleMessage(
            "Only one participant selects this role"),
        "groupPairingDeviceHelp": MessageLookupByLibrary.simpleMessage(
            "All other participants select this role"),
        "groupPairingDone": MessageLookupByLibrary.simpleMessage("Done!"),
        "groupPairingErrCentCommDescription": MessageLookupByLibrary.simpleMessage(
            "We are having trouble reaching the server used for communication. Please check whether you have Internet access and retry. If you keep getting this error, please try another exchange mode."),
        "groupPairingErrCentCommName":
            MessageLookupByLibrary.simpleMessage("Communication Error"),
        "groupPairingErrSecurityDescription": MessageLookupByLibrary.simpleMessage(
            "A security error occured. This can indicate that someone tried to meddle with the group pairing process. Please ensure that no unintended participants are present and try the pairing process again over another network."),
        "groupPairingErrSecurityName":
            MessageLookupByLibrary.simpleMessage("Security Error"),
        "groupPairingErrTimeoutDescription": MessageLookupByLibrary.simpleMessage(
            "A timeout occured while waiting. This can happen when a participant looses connectivity or is too slow when confirming the user dialog."),
        "groupPairingErrTimeoutName":
            MessageLookupByLibrary.simpleMessage("Timeout"),
        "groupPairingErrUnknownDescription": MessageLookupByLibrary.simpleMessage(
            "An unknown error ocurred. Please retry the group pairing process. The description of the error is as follows:"),
        "groupPairingErrUnknownName":
            MessageLookupByLibrary.simpleMessage("Unknown Error"),
        "groupPairingErrWifiDescription": MessageLookupByLibrary.simpleMessage(
            "We are having problems setting up Wi-Fi and connecting to the other participants. Please ensure that you have enabled Wi-Fi on your device. If the error persists, please try another exchange mode."),
        "groupPairingErrWifiName":
            MessageLookupByLibrary.simpleMessage("Wi-Fi Error"),
        "groupPairingError": MessageLookupByLibrary.simpleMessage("Error!"),
        "groupPairingExchangingContactInformation":
            MessageLookupByLibrary.simpleMessage(
                "Exchanging contact information..."),
        "groupPairingNoInternet": MessageLookupByLibrary.simpleMessage(
            "Can\'t connect to the server. Please check your internet connection."),
        "groupPairingParticipant":
            MessageLookupByLibrary.simpleMessage("Participant"),
        "groupPairingPromptCancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "groupPairingPromptRetry":
            MessageLookupByLibrary.simpleMessage("Retry"),
        "groupPairingSelectRole":
            MessageLookupByLibrary.simpleMessage("Select your role"),
        "groupPairingSetupBack": MessageLookupByLibrary.simpleMessage("Back"),
        "groupPairingSetupCancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "groupPairingSetupConfirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "groupPairingSetupExchangeModeDescription":
            MessageLookupByLibrary.simpleMessage(
                "Select the mode you want to use for pairing."),
        "groupPairingSetupFinishDescription": MessageLookupByLibrary.simpleMessage(
            "Continue when all other participants are ready. Their screens need to indicate \"Waiting for others...\"."),
        "groupPairingSetupFinishTitle":
            MessageLookupByLibrary.simpleMessage("Ready?"),
        "groupPairingSetupGo": MessageLookupByLibrary.simpleMessage("Start"),
        "groupPairingSetupGroupSize":
            MessageLookupByLibrary.simpleMessage("Group size:"),
        "groupPairingSetupHintReady": MessageLookupByLibrary.simpleMessage(
            "Make sure all devices point towards each other. Continue when all other participants are ready."),
        "groupPairingSetupParticipantCountDescription":
            MessageLookupByLibrary.simpleMessage(
                "Select the number of participants (including you)."),
        "groupPairingSizeIndicator": m2,
        "groupPairingSlingerBeginExchange":
            MessageLookupByLibrary.simpleMessage("Begin Exchange"),
        "groupPairingSlingerHowManyUsers": MessageLookupByLibrary.simpleMessage(
            "How many users in the exchange?"),
        "groupPairingSlingerLowest":
            MessageLookupByLibrary.simpleMessage("Lowest"),
        "groupPairingSlingerLowest2": MessageLookupByLibrary.simpleMessage(
            "Please enter the lowest number among all users"),
        "groupPairingSlingerLowestNumber": MessageLookupByLibrary.simpleMessage(
            "This number is used to create a unique group of users. Compare, and then enter the lowest number among all users."),
        "groupPairingSlingerNext": MessageLookupByLibrary.simpleMessage("Next"),
        "groupPairingSlingerSelectPhrase": MessageLookupByLibrary.simpleMessage(
            "Please select one of the 3-word phrases."),
        "groupPairingSlingerVerificationError":
            MessageLookupByLibrary.simpleMessage(
                "You have reported a difference in phrases. Begin the exchange again."),
        "groupPairingSlingerVerificationInstructions":
            MessageLookupByLibrary.simpleMessage(
                "All phones must match one of the 3-word phrases. Compare, and then pick the matching phrase."),
        "groupPairingSlingerVerificationNoMatch":
            MessageLookupByLibrary.simpleMessage("No Match"),
        "groupPairingStatusDecrypting":
            MessageLookupByLibrary.simpleMessage("Decrypting..."),
        "groupPairingStatusRunning":
            MessageLookupByLibrary.simpleMessage("Running..."),
        "groupPairingStatus_COLLECT_MATCH_REVEALS":
            MessageLookupByLibrary.simpleMessage(
                "Waiting for other participants to confirm..."),
        "groupPairingStatus_DEVICE_INIT2":
            MessageLookupByLibrary.simpleMessage("Waiting for others..."),
        "groupPairingStatus_ESTABLISHING_CONNECTION":
            MessageLookupByLibrary.simpleMessage(
                "Connecting with participants..."),
        "groupPairingSuccess": MessageLookupByLibrary.simpleMessage("Success"),
        "groupPairingSuccessAddContacts":
            MessageLookupByLibrary.simpleMessage("Add contacts"),
        "groupPairingSuccessCancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "groupPairingSuccessCancelAlertTitle":
            MessageLookupByLibrary.simpleMessage("Contacts won\'t be added"),
        "groupPairingSuccessNoSelectionAlertButtonAction":
            MessageLookupByLibrary.simpleMessage("Select contacts"),
        "groupPairingSuccessNoSelectionAlertButtonDestructive":
            MessageLookupByLibrary.simpleMessage("Exit"),
        "groupPairingSuccessNoSelectionAlertText":
            MessageLookupByLibrary.simpleMessage(
                "If you exit, no contacts will be added."),
        "groupPairingSuccessNoSelectionAlertTitle":
            MessageLookupByLibrary.simpleMessage("No contacts selected"),
        "groupPairingSuccessSelectAll":
            MessageLookupByLibrary.simpleMessage("Select all"),
        "groupPairingSuccessText": MessageLookupByLibrary.simpleMessage(
            "Your data was verified successfully. Please select the contacts you would like to add."),
        "groupPairingSuccessUnselectAll":
            MessageLookupByLibrary.simpleMessage("Unselect all"),
        "groupPairingTimeout": MessageLookupByLibrary.simpleMessage("Timeout!"),
        "groupPairingUseUltrasound":
            MessageLookupByLibrary.simpleMessage("Use Ultrasound"),
        "groupPairingVerificationPrompt": MessageLookupByLibrary.simpleMessage(
            "Your contact information was exchanged successfully. Do all other participants also have a blue lock icon on their screen?"),
        "groupPairingVerificationPromptWithSize": m3,
        "groupPairingVerificationRetransmissionButton":
            MessageLookupByLibrary.simpleMessage("Play audio again"),
        "groupPairingVerifyingSecurity":
            MessageLookupByLibrary.simpleMessage("Verifying security..."),
        "idHint": MessageLookupByLibrary.simpleMessage("ID of the contact"),
        "initDatabase":
            MessageLookupByLibrary.simpleMessage("Reset database on startup"),
        "initDatabaseNow":
            MessageLookupByLibrary.simpleMessage("Reset Database now"),
        "labelId": MessageLookupByLibrary.simpleMessage("ID"),
        "labelName": MessageLookupByLibrary.simpleMessage("Name"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "leaveContactImportConfirmationDialogDescription":
            MessageLookupByLibrary.simpleMessage(
                "If you exit, no new contacts will be imported."),
        "leaveGroupPairingConfirmationDialogDescription":
            MessageLookupByLibrary.simpleMessage(
                "If you exit, the pairing process will be aborted and all progress will be lost."),
        "locationPermissionRequiredDialogDescription":
            MessageLookupByLibrary.simpleMessage(
                "For group pairing, PairSonic requires access to your location."),
        "locationPermissionRequiredPromptOpenAppSettings":
            MessageLookupByLibrary.simpleMessage(
                "Please open the app settings and grant PairSonic access to your location."),
        "microphonePermissionRequiredDialogDescription":
            MessageLookupByLibrary.simpleMessage(
                "For group pairing, PairSonic requires access to your microphone."),
        "microphonePermissionRequiredPromptOpenAppSettings":
            MessageLookupByLibrary.simpleMessage(
                "Please open the app settings and grant access to your microphone."),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "nameHint": MessageLookupByLibrary.simpleMessage("Name of the contact"),
        "noContacts": MessageLookupByLibrary.simpleMessage("No Contacts yet."),
        "pair": MessageLookupByLibrary.simpleMessage("Contact Exchange"),
        "pairingFailed":
            MessageLookupByLibrary.simpleMessage("No pairing data received"),
        "pairingFailureModeFailAlways":
            MessageLookupByLibrary.simpleMessage("Simulate failure"),
        "pairingFailureModeStandard":
            MessageLookupByLibrary.simpleMessage("Don\'t simulate"),
        "pairingImportFailed": MessageLookupByLibrary.simpleMessage(
            "Could not import pairing data"),
        "participantCount":
            MessageLookupByLibrary.simpleMessage("How many participants?"),
        "permissionRequiredDialogTitle":
            MessageLookupByLibrary.simpleMessage("Permission Required"),
        "permissionScreenButtonTextOpenSettings":
            MessageLookupByLibrary.simpleMessage("Open settings"),
        "permissionScreenButtonTextRequestPermissions":
            MessageLookupByLibrary.simpleMessage("Grant permissions"),
        "permissionScreenDescriptionLocation": MessageLookupByLibrary.simpleMessage(
            "By scanning WiFi networks around you, it is theoretically possible to determine the exact location of you and your device. However, this possibility is not needed and not used by the app. Still, Android requires you to grant this permission."),
        "permissionScreenDescriptionMicrophone":
            MessageLookupByLibrary.simpleMessage(
                "During the group pairing process, the app needs to listen for audio messages transmitted by the coordinator."),
        "permissionScreenDescriptionNearbyDevices":
            MessageLookupByLibrary.simpleMessage(
                "During the group pairing process, a temporary direct WiFi network is established with the other participants. In order to find the other devices, this permission is required."),
        "permissionScreenFooterText": MessageLookupByLibrary.simpleMessage(
            "If you have already granted these permissions, please check the System Settings again.\nThere, go to the \"Permissions\" menu and grant access to the three permissions described above.\n"),
        "permissionScreenIntroText": MessageLookupByLibrary.simpleMessage(
            "This app needs a few permissions while the app is in use in order for the group pairing process to work."),
        "permissionScreenNameLocation":
            MessageLookupByLibrary.simpleMessage("Precise Location: "),
        "permissionScreenNameMicrophone":
            MessageLookupByLibrary.simpleMessage("Microphone: "),
        "permissionScreenNameNearbyDevices":
            MessageLookupByLibrary.simpleMessage(
                "Relative position of nearby devices: "),
        "permissionScreenTitle":
            MessageLookupByLibrary.simpleMessage("Permissions required"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileCreationHintText": MessageLookupByLibrary.simpleMessage(
            "Before using PairSonic, set up a profile which will be used during the contact exchange. Choose a nice profile picture, a name, and a bio. This profile is currently only used to demonstrate the contact exchange, but you can imagine it being used, for example, in a messaging context."),
        "profileCreationTitle":
            MessageLookupByLibrary.simpleMessage("Create profile"),
        "profileEditButtonEdit":
            MessageLookupByLibrary.simpleMessage("Edit profile"),
        "retryGroupPairing": MessageLookupByLibrary.simpleMessage(
            "Do you want to retry the group pairing process? Everyone (including the coordinator) needs to restart the process."),
        "save": MessageLookupByLibrary.simpleMessage("save"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "settingsUltrasoundMicSupportFalse":
            MessageLookupByLibrary.simpleMessage(
                "Microphone doesn\'t support Ultrasound"),
        "settingsUltrasoundMicSupportTrue":
            MessageLookupByLibrary.simpleMessage(
                "Microphone supports Ultrasound"),
        "settingsUltrasoundSpeakerSupportFalse":
            MessageLookupByLibrary.simpleMessage(
                "Speaker doesn\'t support Ultrasound"),
        "settingsUltrasoundSpeakerSupportTrue":
            MessageLookupByLibrary.simpleMessage("Speaker supports Ultrasound"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "successful": MessageLookupByLibrary.simpleMessage("Successful"),
        "switchText": MessageLookupByLibrary.simpleMessage("Switch"),
        "volumeDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Please make sure your device volume is at least 75% and pause any other playback."),
        "volumeDialogTitle":
            MessageLookupByLibrary.simpleMessage("Audio Configuration"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "welcomeScreen":
            MessageLookupByLibrary.simpleMessage("Show welcome screen"),
        "welcomeText":
            MessageLookupByLibrary.simpleMessage("This is the PairSonic App."),
        "welcomeTextFirst": MessageLookupByLibrary.simpleMessage(
            " allows users meeting in person to exchange or verify contact information quickly and securely. The smartphones communicate directly with each other using sound waves, without relying on third parties or the Internet."),
        "welcomeTitle":
            MessageLookupByLibrary.simpleMessage("Welcome to PairSonic!"),
        "wifiEnableDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Unable to initialize the WiFi network for pairing. Please disable and enable Wi-Fi on your device and try again."),
        "wifiEnableDialogTitle":
            MessageLookupByLibrary.simpleMessage("WiFi Error"),
        "zCOMMENT": MessageLookupByLibrary.simpleMessage(
            "Run \'flutter gen-l10n\' after changes")
      };
}
