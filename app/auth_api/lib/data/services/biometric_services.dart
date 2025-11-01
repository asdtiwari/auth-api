import 'package:local_auth/local_auth.dart';

class BiometricServices {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch(_) {
      return false;
    }
  }

  Future<bool> authenticate({
    String reason = 'Authenticate to Proceed',
    bool useErrorDialogs = true,
  }) async {
    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } catch(_) {
      return false;
    }
  }
}