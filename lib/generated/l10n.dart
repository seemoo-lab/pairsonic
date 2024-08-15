// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Run 'flutter gen-l10n' after changes`
  String get zCOMMENT {
    return Intl.message(
      'Run \'flutter gen-l10n\' after changes',
      name: 'zCOMMENT',
      desc: '',
      args: [],
    );
  }

  /// `PairSonic`
  String get appName {
    return Intl.message(
      'PairSonic',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Contact Exchange`
  String get pair {
    return Intl.message(
      'Contact Exchange',
      name: 'pair',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `No pairing data received`
  String get pairingFailed {
    return Intl.message(
      'No pairing data received',
      name: 'pairingFailed',
      desc: '',
      args: [],
    );
  }

  /// `Could not import pairing data`
  String get pairingImportFailed {
    return Intl.message(
      'Could not import pairing data',
      name: 'pairingImportFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `No Contacts yet.`
  String get noContacts {
    return Intl.message(
      'No Contacts yet.',
      name: 'noContacts',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Settings`
  String get advancedSettings {
    return Intl.message(
      'Advanced Settings',
      name: 'advancedSettings',
      desc: '',
      args: [],
    );
  }

  /// `Show Advanced Settings`
  String get advancedSettingsShow {
    return Intl.message(
      'Show Advanced Settings',
      name: 'advancedSettingsShow',
      desc: '',
      args: [],
    );
  }

  /// `Reset database on startup`
  String get initDatabase {
    return Intl.message(
      'Reset database on startup',
      name: 'initDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Add testdata on reset`
  String get createTestdata {
    return Intl.message(
      'Add testdata on reset',
      name: 'createTestdata',
      desc: '',
      args: [],
    );
  }

  /// `Reset Database now`
  String get initDatabaseNow {
    return Intl.message(
      'Reset Database now',
      name: 'initDatabaseNow',
      desc: '',
      args: [],
    );
  }

  /// `Admin settings`
  String get adminSettings {
    return Intl.message(
      'Admin settings',
      name: 'adminSettings',
      desc: '',
      args: [],
    );
  }

  /// `Show admin settings`
  String get adminSettingsShow {
    return Intl.message(
      'Show admin settings',
      name: 'adminSettingsShow',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Successful`
  String get successful {
    return Intl.message(
      'Successful',
      name: 'successful',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Show welcome screen`
  String get welcomeScreen {
    return Intl.message(
      'Show welcome screen',
      name: 'welcomeScreen',
      desc: '',
      args: [],
    );
  }

  /// `This is the PairSonic App.`
  String get welcomeText {
    return Intl.message(
      'This is the PairSonic App.',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `The profile is configured. You can now enter the start screen of the app`
  String get finishedProfile {
    return Intl.message(
      'The profile is configured. You can now enter the start screen of the app',
      name: 'finishedProfile',
      desc: '',
      args: [],
    );
  }

  /// `Start!`
  String get go {
    return Intl.message(
      'Start!',
      name: 'go',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get enterName {
    return Intl.message(
      'Please enter a name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a bio`
  String get enterBio {
    return Intl.message(
      'Please enter a bio',
      name: 'enterBio',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get emptyName {
    return Intl.message(
      'Please enter a name',
      name: 'emptyName',
      desc: '',
      args: [],
    );
  }

  /// `Name of the contact`
  String get nameHint {
    return Intl.message(
      'Name of the contact',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get labelName {
    return Intl.message(
      'Name',
      name: 'labelName',
      desc: '',
      args: [],
    );
  }

  /// `Bitte genter an ID`
  String get emptyId {
    return Intl.message(
      'Bitte genter an ID',
      name: 'emptyId',
      desc: '',
      args: [],
    );
  }

  /// `ID of the contact`
  String get idHint {
    return Intl.message(
      'ID of the contact',
      name: 'idHint',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get labelId {
    return Intl.message(
      'ID',
      name: 'labelId',
      desc: '',
      args: [],
    );
  }

  /// `Add contact`
  String get addContact {
    return Intl.message(
      'Add contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message(
      'Continue',
      name: 'continueText',
      desc: '',
      args: [],
    );
  }

  /// `Switch`
  String get switchText {
    return Intl.message(
      'Switch',
      name: 'switchText',
      desc: '',
      args: [],
    );
  }

  /// `Error during Processing.\nTry to move the phones closer or try again in a quiter environment.`
  String get AudioProcessingErrorMessage {
    return Intl.message(
      'Error during Processing.\\nTry to move the phones closer or try again in a quiter environment.',
      name: 'AudioProcessingErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `No Audio data received in {duration} seconds. Please check the volume on the other device or move the devices closer.`
  String AudioInactivityMessage(Object duration) {
    return Intl.message(
      'No Audio data received in $duration seconds. Please check the volume on the other device or move the devices closer.',
      name: 'AudioInactivityMessage',
      desc: 'Distance',
      args: [duration],
    );
  }

  /// `Group Pairing`
  String get groupPairing {
    return Intl.message(
      'Group Pairing',
      name: 'groupPairing',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get confirmationDialogTitle {
    return Intl.message(
      'Are you sure?',
      name: 'confirmationDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `If you exit, the pairing process will be aborted and all progress will be lost.`
  String get leaveGroupPairingConfirmationDialogDescription {
    return Intl.message(
      'If you exit, the pairing process will be aborted and all progress will be lost.',
      name: 'leaveGroupPairingConfirmationDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `If you exit, no new contacts will be imported.`
  String get leaveContactImportConfirmationDialogDescription {
    return Intl.message(
      'If you exit, no new contacts will be imported.',
      name: 'leaveContactImportConfirmationDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permissionRequiredDialogTitle {
    return Intl.message(
      'Permission Required',
      name: 'permissionRequiredDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `For group pairing, PairSonic requires access to your microphone.`
  String get microphonePermissionRequiredDialogDescription {
    return Intl.message(
      'For group pairing, PairSonic requires access to your microphone.',
      name: 'microphonePermissionRequiredDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please open the app settings and grant access to your microphone.`
  String get microphonePermissionRequiredPromptOpenAppSettings {
    return Intl.message(
      'Please open the app settings and grant access to your microphone.',
      name: 'microphonePermissionRequiredPromptOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `For group pairing, PairSonic requires access to your location.`
  String get locationPermissionRequiredDialogDescription {
    return Intl.message(
      'For group pairing, PairSonic requires access to your location.',
      name: 'locationPermissionRequiredDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please open the app settings and grant PairSonic access to your location.`
  String get locationPermissionRequiredPromptOpenAppSettings {
    return Intl.message(
      'Please open the app settings and grant PairSonic access to your location.',
      name: 'locationPermissionRequiredPromptOpenAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Audio Configuration`
  String get volumeDialogTitle {
    return Intl.message(
      'Audio Configuration',
      name: 'volumeDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please make sure your device volume is at least 75% and pause any other playback.`
  String get volumeDialogDescription {
    return Intl.message(
      'Please make sure your device volume is at least 75% and pause any other playback.',
      name: 'volumeDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get dialogButtonOK {
    return Intl.message(
      'OK',
      name: 'dialogButtonOK',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get dialogButtonCancel {
    return Intl.message(
      'CANCEL',
      name: 'dialogButtonCancel',
      desc: '',
      args: [],
    );
  }

  /// `GRANT`
  String get dialogButtonGrant {
    return Intl.message(
      'GRANT',
      name: 'dialogButtonGrant',
      desc: '',
      args: [],
    );
  }

  /// `LEAVE`
  String get dialogButtonLeave {
    return Intl.message(
      'LEAVE',
      name: 'dialogButtonLeave',
      desc: '',
      args: [],
    );
  }

  /// `STAY`
  String get dialogButtonStay {
    return Intl.message(
      'STAY',
      name: 'dialogButtonStay',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get dialogButtonYes {
    return Intl.message(
      'Yes',
      name: 'dialogButtonYes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get dialogButtonNo {
    return Intl.message(
      'No',
      name: 'dialogButtonNo',
      desc: '',
      args: [],
    );
  }

  /// `Participant`
  String get groupPairingParticipant {
    return Intl.message(
      'Participant',
      name: 'groupPairingParticipant',
      desc: '',
      args: [],
    );
  }

  /// `Coordinator`
  String get groupPairingCoordinator {
    return Intl.message(
      'Coordinator',
      name: 'groupPairingCoordinator',
      desc: '',
      args: [],
    );
  }

  /// `How many participants?`
  String get participantCount {
    return Intl.message(
      'How many participants?',
      name: 'participantCount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get groupPairingSetupConfirm {
    return Intl.message(
      'Confirm',
      name: 'groupPairingSetupConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get groupPairingSetupBack {
    return Intl.message(
      'Back',
      name: 'groupPairingSetupBack',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get groupPairingSetupCancel {
    return Intl.message(
      'Cancel',
      name: 'groupPairingSetupCancel',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get groupPairingSetupGo {
    return Intl.message(
      'Start',
      name: 'groupPairingSetupGo',
      desc: '',
      args: [],
    );
  }

  /// `Make sure all devices point towards each other. Continue when all other participants are ready.`
  String get groupPairingSetupHintReady {
    return Intl.message(
      'Make sure all devices point towards each other. Continue when all other participants are ready.',
      name: 'groupPairingSetupHintReady',
      desc: '',
      args: [],
    );
  }

  /// `Group size:`
  String get groupPairingSetupGroupSize {
    return Intl.message(
      'Group size:',
      name: 'groupPairingSetupGroupSize',
      desc: '',
      args: [],
    );
  }

  /// `Select the number of participants (including you).`
  String get groupPairingSetupParticipantCountDescription {
    return Intl.message(
      'Select the number of participants (including you).',
      name: 'groupPairingSetupParticipantCountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select the mode you want to use for pairing.`
  String get groupPairingSetupExchangeModeDescription {
    return Intl.message(
      'Select the mode you want to use for pairing.',
      name: 'groupPairingSetupExchangeModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Ready?`
  String get groupPairingSetupFinishTitle {
    return Intl.message(
      'Ready?',
      name: 'groupPairingSetupFinishTitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue when all other participants are ready. Their screens need to indicate "Waiting for others...".`
  String get groupPairingSetupFinishDescription {
    return Intl.message(
      'Continue when all other participants are ready. Their screens need to indicate "Waiting for others...".',
      name: 'groupPairingSetupFinishDescription',
      desc: '',
      args: [],
    );
  }

  /// `Running...`
  String get groupPairingStatusRunning {
    return Intl.message(
      'Running...',
      name: 'groupPairingStatusRunning',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for others...`
  String get groupPairingStatus_DEVICE_INIT2 {
    return Intl.message(
      'Waiting for others...',
      name: 'groupPairingStatus_DEVICE_INIT2',
      desc: '',
      args: [],
    );
  }

  /// `Please keep your device close to the other devices.`
  String get groupPairingCloseToOther {
    return Intl.message(
      'Please keep your device close to the other devices.',
      name: 'groupPairingCloseToOther',
      desc: '',
      args: [],
    );
  }

  /// `Connecting with participants...`
  String get groupPairingStatus_ESTABLISHING_CONNECTION {
    return Intl.message(
      'Connecting with participants...',
      name: 'groupPairingStatus_ESTABLISHING_CONNECTION',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for other participants to confirm...`
  String get groupPairingStatus_COLLECT_MATCH_REVEALS {
    return Intl.message(
      'Waiting for other participants to confirm...',
      name: 'groupPairingStatus_COLLECT_MATCH_REVEALS',
      desc: '',
      args: [],
    );
  }

  /// `Decrypting...`
  String get groupPairingStatusDecrypting {
    return Intl.message(
      'Decrypting...',
      name: 'groupPairingStatusDecrypting',
      desc: '',
      args: [],
    );
  }

  /// `Your contact information was exchanged successfully. Do all other participants also have a blue lock icon on their screen?`
  String get groupPairingVerificationPrompt {
    return Intl.message(
      'Your contact information was exchanged successfully. Do all other participants also have a blue lock icon on their screen?',
      name: 'groupPairingVerificationPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Your contact information was exchanged successfully. Do all {size} participants have a blue lock icon on their screen?`
  String groupPairingVerificationPromptWithSize(Object size) {
    return Intl.message(
      'Your contact information was exchanged successfully. Do all $size participants have a blue lock icon on their screen?',
      name: 'groupPairingVerificationPromptWithSize',
      desc: '',
      args: [size],
    );
  }

  /// `Play audio again`
  String get groupPairingVerificationRetransmissionButton {
    return Intl.message(
      'Play audio again',
      name: 'groupPairingVerificationRetransmissionButton',
      desc: '',
      args: [],
    );
  }

  /// `Your data was verified successfully. Please select the contacts you would like to add.`
  String get groupPairingSuccessText {
    return Intl.message(
      'Your data was verified successfully. Please select the contacts you would like to add.',
      name: 'groupPairingSuccessText',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get groupPairingSuccessSelectAll {
    return Intl.message(
      'Select all',
      name: 'groupPairingSuccessSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `Unselect all`
  String get groupPairingSuccessUnselectAll {
    return Intl.message(
      'Unselect all',
      name: 'groupPairingSuccessUnselectAll',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get groupPairingSuccessCancel {
    return Intl.message(
      'Cancel',
      name: 'groupPairingSuccessCancel',
      desc: '',
      args: [],
    );
  }

  /// `Add contacts`
  String get groupPairingSuccessAddContacts {
    return Intl.message(
      'Add contacts',
      name: 'groupPairingSuccessAddContacts',
      desc: '',
      args: [],
    );
  }

  /// `No contacts selected`
  String get groupPairingSuccessNoSelectionAlertTitle {
    return Intl.message(
      'No contacts selected',
      name: 'groupPairingSuccessNoSelectionAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Contacts won't be added`
  String get groupPairingSuccessCancelAlertTitle {
    return Intl.message(
      'Contacts won\'t be added',
      name: 'groupPairingSuccessCancelAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `If you exit, no contacts will be added.`
  String get groupPairingSuccessNoSelectionAlertText {
    return Intl.message(
      'If you exit, no contacts will be added.',
      name: 'groupPairingSuccessNoSelectionAlertText',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get groupPairingSuccessNoSelectionAlertButtonDestructive {
    return Intl.message(
      'Exit',
      name: 'groupPairingSuccessNoSelectionAlertButtonDestructive',
      desc: '',
      args: [],
    );
  }

  /// `Select contacts`
  String get groupPairingSuccessNoSelectionAlertButtonAction {
    return Intl.message(
      'Select contacts',
      name: 'groupPairingSuccessNoSelectionAlertButtonAction',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get groupPairingErrTimeoutName {
    return Intl.message(
      'Timeout',
      name: 'groupPairingErrTimeoutName',
      desc: '',
      args: [],
    );
  }

  /// `A timeout occured while waiting. This can happen when a participant looses connectivity or is too slow when confirming the user dialog.`
  String get groupPairingErrTimeoutDescription {
    return Intl.message(
      'A timeout occured while waiting. This can happen when a participant looses connectivity or is too slow when confirming the user dialog.',
      name: 'groupPairingErrTimeoutDescription',
      desc: '',
      args: [],
    );
  }

  /// `Security Error`
  String get groupPairingErrSecurityName {
    return Intl.message(
      'Security Error',
      name: 'groupPairingErrSecurityName',
      desc: '',
      args: [],
    );
  }

  /// `A security error occured. This can indicate that someone tried to meddle with the group pairing process. Please ensure that no unintended participants are present and try the pairing process again over another network.`
  String get groupPairingErrSecurityDescription {
    return Intl.message(
      'A security error occured. This can indicate that someone tried to meddle with the group pairing process. Please ensure that no unintended participants are present and try the pairing process again over another network.',
      name: 'groupPairingErrSecurityDescription',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Error`
  String get groupPairingErrUnknownName {
    return Intl.message(
      'Unknown Error',
      name: 'groupPairingErrUnknownName',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error ocurred. Please retry the group pairing process. The description of the error is as follows:`
  String get groupPairingErrUnknownDescription {
    return Intl.message(
      'An unknown error ocurred. Please retry the group pairing process. The description of the error is as follows:',
      name: 'groupPairingErrUnknownDescription',
      desc: '',
      args: [],
    );
  }

  /// `Communication Error`
  String get groupPairingErrCentCommName {
    return Intl.message(
      'Communication Error',
      name: 'groupPairingErrCentCommName',
      desc: '',
      args: [],
    );
  }

  /// `We are having trouble reaching the server used for communication. Please check whether you have Internet access and retry. If you keep getting this error, please try another exchange mode.`
  String get groupPairingErrCentCommDescription {
    return Intl.message(
      'We are having trouble reaching the server used for communication. Please check whether you have Internet access and retry. If you keep getting this error, please try another exchange mode.',
      name: 'groupPairingErrCentCommDescription',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi Error`
  String get groupPairingErrWifiName {
    return Intl.message(
      'Wi-Fi Error',
      name: 'groupPairingErrWifiName',
      desc: '',
      args: [],
    );
  }

  /// `We are having problems setting up Wi-Fi and connecting to the other participants. Please ensure that you have enabled Wi-Fi on your device. If the error persists, please try another exchange mode.`
  String get groupPairingErrWifiDescription {
    return Intl.message(
      'We are having problems setting up Wi-Fi and connecting to the other participants. Please ensure that you have enabled Wi-Fi on your device. If the error persists, please try another exchange mode.',
      name: 'groupPairingErrWifiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select your role`
  String get groupPairingSelectRole {
    return Intl.message(
      'Select your role',
      name: 'groupPairingSelectRole',
      desc: '',
      args: [],
    );
  }

  /// `Only one participant selects this role`
  String get groupPairingCoordinatorHelp {
    return Intl.message(
      'Only one participant selects this role',
      name: 'groupPairingCoordinatorHelp',
      desc: '',
      args: [],
    );
  }

  /// `All other participants select this role`
  String get groupPairingDeviceHelp {
    return Intl.message(
      'All other participants select this role',
      name: 'groupPairingDeviceHelp',
      desc: '',
      args: [],
    );
  }

  /// `WiFi Error`
  String get wifiEnableDialogTitle {
    return Intl.message(
      'WiFi Error',
      name: 'wifiEnableDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unable to initialize the WiFi network for pairing. Please disable and enable Wi-Fi on your device and try again.`
  String get wifiEnableDialogDescription {
    return Intl.message(
      'Unable to initialize the WiFi network for pairing. Please disable and enable Wi-Fi on your device and try again.',
      name: 'wifiEnableDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to retry the group pairing process? Everyone (including the coordinator) needs to restart the process.`
  String get retryGroupPairing {
    return Intl.message(
      'Do you want to retry the group pairing process? Everyone (including the coordinator) needs to restart the process.',
      name: 'retryGroupPairing',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get groupPairingPromptRetry {
    return Intl.message(
      'Retry',
      name: 'groupPairingPromptRetry',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get groupPairingPromptCancel {
    return Intl.message(
      'Cancel',
      name: 'groupPairingPromptCancel',
      desc: '',
      args: [],
    );
  }

  /// `Use Ultrasound`
  String get groupPairingUseUltrasound {
    return Intl.message(
      'Use Ultrasound',
      name: 'groupPairingUseUltrasound',
      desc: '',
      args: [],
    );
  }

  /// `Audio Channel Backend`
  String get groupPairingAudioChannelBackend {
    return Intl.message(
      'Audio Channel Backend',
      name: 'groupPairingAudioChannelBackend',
      desc: '',
      args: [],
    );
  }

  /// `Connecting with participants...`
  String get groupPairingConnectingWithParticipants {
    return Intl.message(
      'Connecting with participants...',
      name: 'groupPairingConnectingWithParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Exchanging contact information...`
  String get groupPairingExchangingContactInformation {
    return Intl.message(
      'Exchanging contact information...',
      name: 'groupPairingExchangingContactInformation',
      desc: '',
      args: [],
    );
  }

  /// `Verifying security...`
  String get groupPairingVerifyingSecurity {
    return Intl.message(
      'Verifying security...',
      name: 'groupPairingVerifyingSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Timeout!`
  String get groupPairingTimeout {
    return Intl.message(
      'Timeout!',
      name: 'groupPairingTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Error!`
  String get groupPairingError {
    return Intl.message(
      'Error!',
      name: 'groupPairingError',
      desc: '',
      args: [],
    );
  }

  /// `Done!`
  String get groupPairingDone {
    return Intl.message(
      'Done!',
      name: 'groupPairingDone',
      desc: '',
      args: [],
    );
  }

  /// `Group of {size} people`
  String groupPairingSizeIndicator(Object size) {
    return Intl.message(
      'Group of $size people',
      name: 'groupPairingSizeIndicator',
      desc: '',
      args: [size],
    );
  }

  /// `Success`
  String get groupPairingSuccess {
    return Intl.message(
      'Success',
      name: 'groupPairingSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Can't connect to the server. Please check your internet connection.`
  String get groupPairingNoInternet {
    return Intl.message(
      'Can\'t connect to the server. Please check your internet connection.',
      name: 'groupPairingNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `Begin Exchange`
  String get groupPairingSlingerBeginExchange {
    return Intl.message(
      'Begin Exchange',
      name: 'groupPairingSlingerBeginExchange',
      desc: '',
      args: [],
    );
  }

  /// `How many users in the exchange?`
  String get groupPairingSlingerHowManyUsers {
    return Intl.message(
      'How many users in the exchange?',
      name: 'groupPairingSlingerHowManyUsers',
      desc: '',
      args: [],
    );
  }

  /// `Compare screen on {size} devices.`
  String groupPairingCompareScreen(Object size) {
    return Intl.message(
      'Compare screen on $size devices.',
      name: 'groupPairingCompareScreen',
      desc: '',
      args: [size],
    );
  }

  /// `This number is used to create a unique group of users. Compare, and then enter the lowest number among all users.`
  String get groupPairingSlingerLowestNumber {
    return Intl.message(
      'This number is used to create a unique group of users. Compare, and then enter the lowest number among all users.',
      name: 'groupPairingSlingerLowestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the lowest number among all users`
  String get groupPairingSlingerLowest2 {
    return Intl.message(
      'Please enter the lowest number among all users',
      name: 'groupPairingSlingerLowest2',
      desc: '',
      args: [],
    );
  }

  /// `You have reported a difference in phrases. Begin the exchange again.`
  String get groupPairingSlingerVerificationError {
    return Intl.message(
      'You have reported a difference in phrases. Begin the exchange again.',
      name: 'groupPairingSlingerVerificationError',
      desc: '',
      args: [],
    );
  }

  /// `Please select one of the 3-word phrases.`
  String get groupPairingSlingerSelectPhrase {
    return Intl.message(
      'Please select one of the 3-word phrases.',
      name: 'groupPairingSlingerSelectPhrase',
      desc: '',
      args: [],
    );
  }

  /// `All phones must match one of the 3-word phrases. Compare, and then pick the matching phrase.`
  String get groupPairingSlingerVerificationInstructions {
    return Intl.message(
      'All phones must match one of the 3-word phrases. Compare, and then pick the matching phrase.',
      name: 'groupPairingSlingerVerificationInstructions',
      desc: '',
      args: [],
    );
  }

  /// `No Match`
  String get groupPairingSlingerVerificationNoMatch {
    return Intl.message(
      'No Match',
      name: 'groupPairingSlingerVerificationNoMatch',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get groupPairingSlingerNext {
    return Intl.message(
      'Next',
      name: 'groupPairingSlingerNext',
      desc: '',
      args: [],
    );
  }

  /// `Lowest`
  String get groupPairingSlingerLowest {
    return Intl.message(
      'Lowest',
      name: 'groupPairingSlingerLowest',
      desc: '',
      args: [],
    );
  }

  /// `Don't simulate`
  String get pairingFailureModeStandard {
    return Intl.message(
      'Don\'t simulate',
      name: 'pairingFailureModeStandard',
      desc: '',
      args: [],
    );
  }

  /// `Simulate failure`
  String get pairingFailureModeFailAlways {
    return Intl.message(
      'Simulate failure',
      name: 'pairingFailureModeFailAlways',
      desc: '',
      args: [],
    );
  }

  /// `Permissions required`
  String get permissionScreenTitle {
    return Intl.message(
      'Permissions required',
      name: 'permissionScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `This app needs a few permissions while the app is in use in order for the group pairing process to work.`
  String get permissionScreenIntroText {
    return Intl.message(
      'This app needs a few permissions while the app is in use in order for the group pairing process to work.',
      name: 'permissionScreenIntroText',
      desc: '',
      args: [],
    );
  }

  /// `Microphone: `
  String get permissionScreenNameMicrophone {
    return Intl.message(
      'Microphone: ',
      name: 'permissionScreenNameMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `During the group pairing process, the app needs to listen for audio messages transmitted by the coordinator.`
  String get permissionScreenDescriptionMicrophone {
    return Intl.message(
      'During the group pairing process, the app needs to listen for audio messages transmitted by the coordinator.',
      name: 'permissionScreenDescriptionMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Relative position of nearby devices: `
  String get permissionScreenNameNearbyDevices {
    return Intl.message(
      'Relative position of nearby devices: ',
      name: 'permissionScreenNameNearbyDevices',
      desc: '',
      args: [],
    );
  }

  /// `During the group pairing process, a temporary direct WiFi network is established with the other participants. In order to find the other devices, this permission is required.`
  String get permissionScreenDescriptionNearbyDevices {
    return Intl.message(
      'During the group pairing process, a temporary direct WiFi network is established with the other participants. In order to find the other devices, this permission is required.',
      name: 'permissionScreenDescriptionNearbyDevices',
      desc: '',
      args: [],
    );
  }

  /// `Precise Location: `
  String get permissionScreenNameLocation {
    return Intl.message(
      'Precise Location: ',
      name: 'permissionScreenNameLocation',
      desc: '',
      args: [],
    );
  }

  /// `By scanning WiFi networks around you, it is theoretically possible to determine the exact location of you and your device. However, this possibility is not needed and not used by the app. Still, Android requires you to grant this permission.`
  String get permissionScreenDescriptionLocation {
    return Intl.message(
      'By scanning WiFi networks around you, it is theoretically possible to determine the exact location of you and your device. However, this possibility is not needed and not used by the app. Still, Android requires you to grant this permission.',
      name: 'permissionScreenDescriptionLocation',
      desc: '',
      args: [],
    );
  }

  /// `If you have already granted these permissions, please check the System Settings again.\nThere, go to the "Permissions" menu and grant access to the three permissions described above.\n`
  String get permissionScreenFooterText {
    return Intl.message(
      'If you have already granted these permissions, please check the System Settings again.\nThere, go to the "Permissions" menu and grant access to the three permissions described above.\n',
      name: 'permissionScreenFooterText',
      desc: '',
      args: [],
    );
  }

  /// `Grant permissions`
  String get permissionScreenButtonTextRequestPermissions {
    return Intl.message(
      'Grant permissions',
      name: 'permissionScreenButtonTextRequestPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Open settings`
  String get permissionScreenButtonTextOpenSettings {
    return Intl.message(
      'Open settings',
      name: 'permissionScreenButtonTextOpenSettings',
      desc: '',
      args: [],
    );
  }

  /// `Microphone supports Ultrasound`
  String get settingsUltrasoundMicSupportTrue {
    return Intl.message(
      'Microphone supports Ultrasound',
      name: 'settingsUltrasoundMicSupportTrue',
      desc: '',
      args: [],
    );
  }

  /// `Microphone doesn't support Ultrasound`
  String get settingsUltrasoundMicSupportFalse {
    return Intl.message(
      'Microphone doesn\'t support Ultrasound',
      name: 'settingsUltrasoundMicSupportFalse',
      desc: '',
      args: [],
    );
  }

  /// `Speaker supports Ultrasound`
  String get settingsUltrasoundSpeakerSupportTrue {
    return Intl.message(
      'Speaker supports Ultrasound',
      name: 'settingsUltrasoundSpeakerSupportTrue',
      desc: '',
      args: [],
    );
  }

  /// `Speaker doesn't support Ultrasound`
  String get settingsUltrasoundSpeakerSupportFalse {
    return Intl.message(
      'Speaker doesn\'t support Ultrasound',
      name: 'settingsUltrasoundSpeakerSupportFalse',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to PairSonic!`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to PairSonic!',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// ` allows users meeting in person to exchange or verify contact information quickly and securely. The smartphones communicate directly with each other using sound waves, without relying on third parties or the Internet.`
  String get welcomeTextFirst {
    return Intl.message(
      ' allows users meeting in person to exchange or verify contact information quickly and securely. The smartphones communicate directly with each other using sound waves, without relying on third parties or the Internet.',
      name: 'welcomeTextFirst',
      desc: '',
      args: [],
    );
  }

  /// `Create profile`
  String get profileCreationTitle {
    return Intl.message(
      'Create profile',
      name: 'profileCreationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Before using PairSonic, set up a profile which will be used during the contact exchange. Choose a nice profile picture, a name, and a bio. This profile is currently only used to demonstrate the contact exchange, but you can imagine it being used, for example, in a messaging context.`
  String get profileCreationHintText {
    return Intl.message(
      'Before using PairSonic, set up a profile which will be used during the contact exchange. Choose a nice profile picture, a name, and a bio. This profile is currently only used to demonstrate the contact exchange, but you can imagine it being used, for example, in a messaging context.',
      name: 'profileCreationHintText',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get profileEditButtonEdit {
    return Intl.message(
      'Edit profile',
      name: 'profileEditButtonEdit',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get generalButtonNext {
    return Intl.message(
      'Next',
      name: 'generalButtonNext',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get generalButtonDone {
    return Intl.message(
      'Done',
      name: 'generalButtonDone',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get generalButtonBack {
    return Intl.message(
      'Back',
      name: 'generalButtonBack',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
