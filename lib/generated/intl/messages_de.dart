// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(duration) =>
      "No Audio data received in ${duration} seconds. Please check the volume on the other device or move the devices closer.";

  static String m1(size) => "Vergleiche auf ${size} Geräten.";

  static String m2(size) => "Gruppe mit ${size} Teilnehmern";

  static String m3(size) =>
      "Die Daten wurden erfolgreich verifiziert. Haben alle ${size} Teilnehmer ein blaues Schloss-Icon auf ihren Bildschirmen?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AudioInactivityMessage": m0,
    "AudioProcessingErrorMessage": MessageLookupByLibrary.simpleMessage(
      "Error during Processing.\\nTry to move the phones closer or try again in a quiter environment.",
    ),
    "addContact": MessageLookupByLibrary.simpleMessage("Kontakt hinzufügen"),
    "adminSettings": MessageLookupByLibrary.simpleMessage(
      "Admin Einstellungen",
    ),
    "adminSettingsShow": MessageLookupByLibrary.simpleMessage(
      "Zeige Admin Einstellungen",
    ),
    "advancedSettings": MessageLookupByLibrary.simpleMessage(
      "Erweiterte Einstellungen",
    ),
    "advancedSettingsShow": MessageLookupByLibrary.simpleMessage(
      "Zeige erweiterte Einstellungen",
    ),
    "alertLocationServiceButton": MessageLookupByLibrary.simpleMessage(
      "Einstellungen öffnen",
    ),
    "alertLocationServiceMessage": MessageLookupByLibrary.simpleMessage(
      "Bitte öffnen Sie die Einstellungen und aktivieren Sie die Standort-Dienste, damit der Kontaktaustausch funktionieren kann. Wir verwenden Ihren Standort nicht, aber aufgrund technischer Limitierungen müssen Standort-Dienste aktiviert sein.",
    ),
    "alertLocationServiceTitle": MessageLookupByLibrary.simpleMessage(
      "Standort deaktiviert",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("PairSonic"),
    "bio": MessageLookupByLibrary.simpleMessage("Bio"),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
    "confirmationDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Bist du sicher?",
    ),
    "contacts": MessageLookupByLibrary.simpleMessage("Kontakte"),
    "continueText": MessageLookupByLibrary.simpleMessage("Continue"),
    "createTestdata": MessageLookupByLibrary.simpleMessage(
      "Füge Testdaten beim Zurücksetzen hinzu",
    ),
    "dialogButtonCancel": MessageLookupByLibrary.simpleMessage("ABBRECHEN"),
    "dialogButtonGrant": MessageLookupByLibrary.simpleMessage("ERLAUBEN"),
    "dialogButtonLeave": MessageLookupByLibrary.simpleMessage("BEENDEN"),
    "dialogButtonNo": MessageLookupByLibrary.simpleMessage("Nein"),
    "dialogButtonOK": MessageLookupByLibrary.simpleMessage("OK"),
    "dialogButtonStay": MessageLookupByLibrary.simpleMessage("FORTSETZEN"),
    "dialogButtonYes": MessageLookupByLibrary.simpleMessage("Ja"),
    "emptyId": MessageLookupByLibrary.simpleMessage("Bitte gib eine Id an"),
    "emptyName": MessageLookupByLibrary.simpleMessage(
      "Bitte gib einen Namen an",
    ),
    "enterBio": MessageLookupByLibrary.simpleMessage(
      "Bitte gib eine kurze Bio an",
    ),
    "enterName": MessageLookupByLibrary.simpleMessage(
      "Bitte gib einen Namen an",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("Fehlgeschlagen"),
    "finishedProfile": MessageLookupByLibrary.simpleMessage(
      "Das Profil ist eingerichtet. Du kannst jetzt in den Startscreen der App",
    ),
    "generalButtonBack": MessageLookupByLibrary.simpleMessage("Zurück"),
    "generalButtonDone": MessageLookupByLibrary.simpleMessage("Fertig"),
    "generalButtonNext": MessageLookupByLibrary.simpleMessage("Weiter"),
    "go": MessageLookupByLibrary.simpleMessage("Los gehts!"),
    "groupPairing": MessageLookupByLibrary.simpleMessage("Gruppen-Pairing"),
    "groupPairingAudioChannelBackend": MessageLookupByLibrary.simpleMessage(
      "Audio Channel Backend",
    ),
    "groupPairingCloseToOther": MessageLookupByLibrary.simpleMessage(
      "Bitte halte dein Gerät in die Nähe der anderen Geräte.",
    ),
    "groupPairingCompareScreen": m1,
    "groupPairingConnectingWithParticipants":
        MessageLookupByLibrary.simpleMessage("Verbinden mit Teilnehmern..."),
    "groupPairingCoordinator": MessageLookupByLibrary.simpleMessage(
      "Koordinator",
    ),
    "groupPairingCoordinatorHelp": MessageLookupByLibrary.simpleMessage(
      "Genau ein Teilnehmer wählt diese Rolle",
    ),
    "groupPairingDeviceHelp": MessageLookupByLibrary.simpleMessage(
      "Alle anderen Teilnehmer wählen diese Rolle",
    ),
    "groupPairingDone": MessageLookupByLibrary.simpleMessage("Fertig!"),
    "groupPairingErrSecurityDescription": MessageLookupByLibrary.simpleMessage(
      "Ein mögliches Sicherheitsproblem wurde erkannt und verhindert. Das kann daran liegen, dass jemand anderes unerlaubterweise in den Gruppen-Pairing-Prozess eingegriffen hat. Bitte stelle sicher, dass keine unbeabsichtigten Teilnehmer in der Nähe sind und starte den Pairing-Vorgang erneut.",
    ),
    "groupPairingErrSecurityName": MessageLookupByLibrary.simpleMessage(
      "Sicherheits-Fehler",
    ),
    "groupPairingErrTimeoutDescription": MessageLookupByLibrary.simpleMessage(
      "Ein Timeout ist aufgetreten. Das kann daran liegen, dass ein Teilnehmer die Verbindung verloren hat oder den Dialog nicht innerhalb einer gewissen Zeit bestätigt hat.",
    ),
    "groupPairingErrTimeoutName": MessageLookupByLibrary.simpleMessage(
      "Timeout",
    ),
    "groupPairingErrUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "Ein unbekannter Fehler ist aufgetreten. Bitte starte den Pairing-Vorgang erneut. Fehlerbeschreibung:",
    ),
    "groupPairingErrUnknownName": MessageLookupByLibrary.simpleMessage(
      "Ubekannter Fehler",
    ),
    "groupPairingErrWifiDescription": MessageLookupByLibrary.simpleMessage(
      "Ein Fehler ist beim Erstellen des WiFi-Netzes und bei der Verbindung mit den anderen Teilnehmern aufgetreten. Bitte stelle sicher, dass Wi-Fi auf deinem Gerät aktiviert ist. Eine Internetverbindung ist allerdings nicht notwendig.",
    ),
    "groupPairingErrWifiName": MessageLookupByLibrary.simpleMessage(
      "Wi-Fi Fehler",
    ),
    "groupPairingError": MessageLookupByLibrary.simpleMessage("Fehler!"),
    "groupPairingExchangingContactInformation":
        MessageLookupByLibrary.simpleMessage(
          "Tausche Kontaktinformationen aus...",
        ),
    "groupPairingNoInternet": MessageLookupByLibrary.simpleMessage(
      "Can\'t connect to the server. Please check your internet connection.",
    ),
    "groupPairingParticipant": MessageLookupByLibrary.simpleMessage(
      "Teilnehmer",
    ),
    "groupPairingPromptCancel": MessageLookupByLibrary.simpleMessage(
      "Abbrechen",
    ),
    "groupPairingPromptRetry": MessageLookupByLibrary.simpleMessage(
      "Neustarten",
    ),
    "groupPairingSelectRole": MessageLookupByLibrary.simpleMessage(
      "Wähle deine Rolle",
    ),
    "groupPairingSetupBack": MessageLookupByLibrary.simpleMessage("Zurück"),
    "groupPairingSetupCancel": MessageLookupByLibrary.simpleMessage(
      "Abbrechen",
    ),
    "groupPairingSetupConfirm": MessageLookupByLibrary.simpleMessage(
      "Bestätigen",
    ),
    "groupPairingSetupExchangeModeDescription":
        MessageLookupByLibrary.simpleMessage(
          "Wähle den Modus, den du für das Pairing verwenden möchtest..",
        ),
    "groupPairingSetupFinishDescription": MessageLookupByLibrary.simpleMessage(
      "Warte bis alle anderen Teilnehmenden bereit sind. Auf den Bildschirmen der anderen Teilnehmer muss stehen: \"Warten auf andere...\".",
    ),
    "groupPairingSetupFinishTitle": MessageLookupByLibrary.simpleMessage(
      "Bereit?",
    ),
    "groupPairingSetupGo": MessageLookupByLibrary.simpleMessage("Start"),
    "groupPairingSetupGroupSize": MessageLookupByLibrary.simpleMessage(
      "Gruppengröße:",
    ),
    "groupPairingSetupHintReady": MessageLookupByLibrary.simpleMessage(
      "Stellen Sie sicher, dass alle Geräte zueinander zeigen. Fahren Sie fort, wenn alle anderen Teilnehmer bereit sind.",
    ),
    "groupPairingSetupParticipantCountDescription":
        MessageLookupByLibrary.simpleMessage(
          "Wieviele Teilnehmer gibt es (dich eingeschlossen)?",
        ),
    "groupPairingSizeIndicator": m2,
    "groupPairingSlingerBeginExchange": MessageLookupByLibrary.simpleMessage(
      "Starte Pairing",
    ),
    "groupPairingSlingerHowManyUsers": MessageLookupByLibrary.simpleMessage(
      "Wieviele Teilnehmer gibt es insgesamt?",
    ),
    "groupPairingSlingerLowest": MessageLookupByLibrary.simpleMessage(
      "Niedrigste",
    ),
    "groupPairingSlingerLowest2": MessageLookupByLibrary.simpleMessage(
      "Bitte gebe die niedrigste Zahl von allen Teilnehmern ein.",
    ),
    "groupPairingSlingerLowestNumber": MessageLookupByLibrary.simpleMessage(
      "Mit dieser Zahl wird eine eindeutige Pairing-Gruppe erstellt. Vergleiche die Zahl und gebe die niedrigste Zahl von allen Teilnehmern ein.",
    ),
    "groupPairingSlingerNext": MessageLookupByLibrary.simpleMessage("Weiter"),
    "groupPairingSlingerSelectPhrase": MessageLookupByLibrary.simpleMessage(
      "Bitte wähle eine der 3-Wort-Phrasen aus.",
    ),
    "groupPairingSlingerVerificationError": MessageLookupByLibrary.simpleMessage(
      "Du hast eine fehlende Übereinstimmung angegeben. Bitte starte den Pairing-Vorgang erneut.",
    ),
    "groupPairingSlingerVerificationInstructions":
        MessageLookupByLibrary.simpleMessage(
          "Alle Geräte müssen die gleiche 3-Wort-Phrase auswählen. Vergleiche mit den anderen und wähle dann die übereinstimmende Phrase.",
        ),
    "groupPairingSlingerVerificationNoMatch":
        MessageLookupByLibrary.simpleMessage("Keine Übereinstimmung"),
    "groupPairingStatusDecrypting": MessageLookupByLibrary.simpleMessage(
      "Entschlüsseln...",
    ),
    "groupPairingStatusRunning": MessageLookupByLibrary.simpleMessage(
      "Pairing läuft...",
    ),
    "groupPairingStatus_COLLECT_MATCH_REVEALS":
        MessageLookupByLibrary.simpleMessage(
          "Warten auf Bestätigung der anderen Teilnehmer...",
        ),
    "groupPairingStatus_DEVICE_INIT2": MessageLookupByLibrary.simpleMessage(
      "Warten auf andere...",
    ),
    "groupPairingStatus_ESTABLISHING_CONNECTION":
        MessageLookupByLibrary.simpleMessage(
          "Verbinden mit anderen Teilnehmern...",
        ),
    "groupPairingSuccess": MessageLookupByLibrary.simpleMessage("Fertig"),
    "groupPairingSuccessAddContacts": MessageLookupByLibrary.simpleMessage(
      "Kontakte hinzufügen",
    ),
    "groupPairingSuccessCancel": MessageLookupByLibrary.simpleMessage(
      "Abbrechen",
    ),
    "groupPairingSuccessCancelAlertTitle": MessageLookupByLibrary.simpleMessage(
      "Kontakte werden nicht hinzugefügt",
    ),
    "groupPairingSuccessNoSelectionAlertButtonAction":
        MessageLookupByLibrary.simpleMessage("Kontakte auswählen"),
    "groupPairingSuccessNoSelectionAlertButtonDestructive":
        MessageLookupByLibrary.simpleMessage("Verlassen"),
    "groupPairingSuccessNoSelectionAlertText":
        MessageLookupByLibrary.simpleMessage(
          "Wenn Sie verlassen werden keine Kontakte hinzugefügt.",
        ),
    "groupPairingSuccessNoSelectionAlertTitle":
        MessageLookupByLibrary.simpleMessage("Keine Kontakte ausgewählt"),
    "groupPairingSuccessSelectAll": MessageLookupByLibrary.simpleMessage(
      "Alle auswählen",
    ),
    "groupPairingSuccessText": MessageLookupByLibrary.simpleMessage(
      "Gruppen-Pairing erfolgreich abgeschlossen. Bitte wählen Sie die Kontakte, die Sie hinzufügen möchten.",
    ),
    "groupPairingSuccessUnselectAll": MessageLookupByLibrary.simpleMessage(
      "Nichts auswählen",
    ),
    "groupPairingTimeout": MessageLookupByLibrary.simpleMessage("Timeout!"),
    "groupPairingUseUltrasound": MessageLookupByLibrary.simpleMessage(
      "Use Ultrasound",
    ),
    "groupPairingVerificationPrompt": MessageLookupByLibrary.simpleMessage(
      "Die Daten wurden erfolgreich verifiziert. Haben alle anderen Teilnehmer auch ein blaues Schloss-Icon auf ihren Bildschirmen?",
    ),
    "groupPairingVerificationPromptWithSize": m3,
    "groupPairingVerificationRetransmissionButton":
        MessageLookupByLibrary.simpleMessage("Audio nochmal abspielen"),
    "groupPairingVerifyingSecurity": MessageLookupByLibrary.simpleMessage(
      "Verifiziere Sicherheit...",
    ),
    "idHint": MessageLookupByLibrary.simpleMessage("Id des Kontaktes"),
    "initDatabase": MessageLookupByLibrary.simpleMessage(
      "Setze Datenbank bei App Start zurück",
    ),
    "initDatabaseNow": MessageLookupByLibrary.simpleMessage(
      "Setze Datenbank jetzt zurück",
    ),
    "labelId": MessageLookupByLibrary.simpleMessage("ID"),
    "labelName": MessageLookupByLibrary.simpleMessage("Name"),
    "language": MessageLookupByLibrary.simpleMessage("Sprache"),
    "leaveContactImportConfirmationDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Wenn du zurück gehst, werden keine neuen Kontakte importiert.",
        ),
    "leaveGroupPairingConfirmationDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Wenn du zurück gehst, wird der Pairing-Vorgang abgebrochen und der Fortschritt geht verloren.",
        ),
    "locationPermissionRequiredDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Für Gruppen-Pairing benötigt die PairSonic-App Zugriff auf den Standort.",
        ),
    "locationPermissionRequiredPromptOpenAppSettings":
        MessageLookupByLibrary.simpleMessage(
          "Bitte öffne die Settings-App und erlaube Zugriff auf den Standort.",
        ),
    "microphonePermissionRequiredDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Für Gruppen-Pairing benötigt die PairSonic-App Zugriff auf das Mikrofon.",
        ),
    "microphonePermissionRequiredPromptOpenAppSettings":
        MessageLookupByLibrary.simpleMessage(
          "Bitte öffne die Settings-App und erlaube Zugriff auf das Mikrofon.",
        ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameHint": MessageLookupByLibrary.simpleMessage("Name des Kontaktes"),
    "noContacts": MessageLookupByLibrary.simpleMessage(
      "Bisher keine Kontakte.",
    ),
    "pair": MessageLookupByLibrary.simpleMessage("Kontaktdaten austauschen"),
    "pairingFailed": MessageLookupByLibrary.simpleMessage(
      "Keine Pairingdaten erhalten",
    ),
    "pairingFailureModeFailAlways": MessageLookupByLibrary.simpleMessage(
      "Fehler simulieren",
    ),
    "pairingFailureModeStandard": MessageLookupByLibrary.simpleMessage(
      "Nicht simulieren",
    ),
    "pairingImportFailed": MessageLookupByLibrary.simpleMessage(
      "Konnte Pairingdaten nicht importieren",
    ),
    "participantCount": MessageLookupByLibrary.simpleMessage(
      "Wie viele Teilnehmer?",
    ),
    "permissionRequiredDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Berechtigung benötigt",
    ),
    "permissionScreenButtonTextOpenSettings":
        MessageLookupByLibrary.simpleMessage("Einstellungen öffnen"),
    "permissionScreenButtonTextRequestPermissions":
        MessageLookupByLibrary.simpleMessage("Berechtigungen erteilen"),
    "permissionScreenDescriptionLocation": MessageLookupByLibrary.simpleMessage(
      "Durch das Scannen von WLAN-Netzwerken in der Nähe kann theoretisch die genaue Position des Gerätes herausgefunden werden. Diese Möglichkeit wird in der App allerdings nicht genutzt. Dennoch muss die Berechtigung dazu erteilt werden.",
    ),
    "permissionScreenDescriptionMicrophone": MessageLookupByLibrary.simpleMessage(
      "Während des Pairing-Prozesses muss die App auf Audio-Signale hören, die vom Koordinator gesendet werden.",
    ),
    "permissionScreenDescriptionNearbyDevices":
        MessageLookupByLibrary.simpleMessage(
          "Während des Pairings wird ein kurzzeitiges direktes WLAN-Netzwerk zu den anderen Teilnehmern aufgebaut. Um die Geräte finden zu können, wird diese Berechtigung benötigt.",
        ),
    "permissionScreenFooterText": MessageLookupByLibrary.simpleMessage(
      "Wenn Sie die Berechtigungen schon erteilt hatten, prüfen Sie bitte nochmal die Systemeinstellungen.\nGehen Sie dort in das \"Berechtigungen\"-Menü und erlauben Sie den Zugriff auf die drei oben beschriebenen Berechtigungen.\n",
    ),
    "permissionScreenIntroText": MessageLookupByLibrary.simpleMessage(
      "Diese App benötigt einige Berechtigungen während der Verwendung, damit der Pairing-Prozess funktionieren kann.",
    ),
    "permissionScreenLocationServiceMessage": MessageLookupByLibrary.simpleMessage(
      "Die Standort-Dienste müssen in den Systemeinstellungen aktiviert sein, damit der Kontaktaustausch funktioniert.",
    ),
    "permissionScreenNameLocation": MessageLookupByLibrary.simpleMessage(
      "Genauer Standort: ",
    ),
    "permissionScreenNameMicrophone": MessageLookupByLibrary.simpleMessage(
      "Mikrofon: ",
    ),
    "permissionScreenNameNearbyDevices": MessageLookupByLibrary.simpleMessage(
      "Relative Position von Geräten in der Nähe: ",
    ),
    "permissionScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Berechtigungen erforderlich",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "profileCreationHintText": MessageLookupByLibrary.simpleMessage(
      "Before using PairSonic, set up a profile which will be used during the contact exchange. Choose a nice profile picture, a name, and a bio. This profile is currently only used to demonstrate the contact exchange, but you can imagine it being used, for example, in a messaging context.",
    ),
    "profileCreationTitle": MessageLookupByLibrary.simpleMessage(
      "Profile erstellen",
    ),
    "profileEditButtonEdit": MessageLookupByLibrary.simpleMessage(
      "Profil bearbeiten",
    ),
    "retryGroupPairing": MessageLookupByLibrary.simpleMessage(
      "Möchtest du den Pairing-Vorgang neu starten? Jeder (auch der Koordinator) muss den Vorgang neu starten.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "settingsUltrasoundMicSupportFalse": MessageLookupByLibrary.simpleMessage(
      "Mikrofon unterstützt Ultraschall nicht",
    ),
    "settingsUltrasoundMicSupportTrue": MessageLookupByLibrary.simpleMessage(
      "Mikrofon unterstützt Ultraschall",
    ),
    "settingsUltrasoundSpeakerSupportFalse":
        MessageLookupByLibrary.simpleMessage(
          "Lautsprecher unterstützt Ultraschall nicht",
        ),
    "settingsUltrasoundSpeakerSupportTrue":
        MessageLookupByLibrary.simpleMessage(
          "Lautsprecher unterstützt Ultraschall",
        ),
    "submit": MessageLookupByLibrary.simpleMessage("Abschicken"),
    "successful": MessageLookupByLibrary.simpleMessage("Erfolgreich"),
    "switchText": MessageLookupByLibrary.simpleMessage("Switch"),
    "volumeDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Bitte stelle sicher, dass die Geräte-Lautstärke bei mindestens 75% liegt und pausiere ggf. aktuelle Musikwiedergabe.",
    ),
    "volumeDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Audio Einstellung",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("Willkommen"),
    "welcomeScreen": MessageLookupByLibrary.simpleMessage(
      "Zeige Willkommen Screen",
    ),
    "welcomeText": MessageLookupByLibrary.simpleMessage(
      "Das ist die PairSonic App.",
    ),
    "welcomeTextFirst": MessageLookupByLibrary.simpleMessage(
      " allows users meeting in person to exchange or verify contact information quickly and securely. The smartphones communicate directly with each other using sound waves, without relying on third parties or the Internet.",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "Willkommen bei PairSonic!",
    ),
    "wifiEnableDialogDescription": MessageLookupByLibrary.simpleMessage(
      "WiFI-Netzwerk konnte nicht für Pairing eingerichtet werden. Bitte deaktiviere Wi-Fi auf deinem Gerät und aktiviere es dann wieder.",
    ),
    "wifiEnableDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Wi-Fi Fehler",
    ),
    "zCOMMENT": MessageLookupByLibrary.simpleMessage(
      "Run \'flutter gen-l10n\' after changes",
    ),
  };
}
