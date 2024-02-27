import 'package:local_auth/local_auth.dart';

class AuthenticationProvider {
  late LocalAuthentication auth;

  late List<BiometricType> availableBiometrics;

  initialize() {
    auth = LocalAuthentication();
  }

  checkAuthenticationAvailability() async {
    LocalAuthentication auth = LocalAuthentication();
    final localAuthAvailable = await auth.isDeviceSupported();
    if (!localAuthAvailable) {
      return false;
    } else {
      return true;
    }
  }

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
