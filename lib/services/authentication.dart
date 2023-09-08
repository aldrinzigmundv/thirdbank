import 'package:mobx/mobx.dart';

import 'package:local_auth/local_auth.dart';

part 'authentication.g.dart';

class AuthenticationProvider = _AuthenticationProvider
    with _$AuthenticationProvider;

abstract class _AuthenticationProvider with Store {
  late LocalAuthentication auth;

  late List<BiometricType> availableBiometrics;

  @action
  initialize() {
    auth = LocalAuthentication();
  }

  @action
  checkAuthenticationAvailability() async {
    LocalAuthentication auth = LocalAuthentication();
    final localAuthAvailable = await auth.isDeviceSupported();
    if (!localAuthAvailable) {
      return false;
    } else {
      return true;
    }
  }

  @action
  authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Authentication required to open this wallet.');
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
