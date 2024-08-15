/// {@category GroupPairing}
/// Routes used by the sub-navigator on the
/// Group Pairing Screen.
///
/// {@category Router}
class GroupPairingAudioRoutes {
  GroupPairingAudioRoutes._();

  static const String _baseRoute = '/';
  static const String roleSelection = '${_baseRoute}RoleSelection';
  static const String coordinatorSetup = '${_baseRoute}CoordinatorSetup';
  static const String running = '${_baseRoute}Running';
  static const String error = '${_baseRoute}Error';
  static const String success = '${_baseRoute}Success';
}
