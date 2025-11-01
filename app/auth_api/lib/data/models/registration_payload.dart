import 'package:auth_api/data/services/device_service.dart';

class RegistrationPayload {
  final String udid;
  final String username;
  final String platformUrl;
  final String deviceFingerprint;

  RegistrationPayload({
    required this.udid,
    required this.username,
    required this.platformUrl,
    required this.deviceFingerprint,
  });

  // Async factory method to build the model with required async data
  static Future<RegistrationPayload> build({
    required String username,
    required String platformUrl,
  }) async {
    DeviceService deviceService = DeviceService();
    final udid = await deviceService.getOrCreateUdid();
    final fingerprint = await deviceService.getOrCreateDeviceFingerprint();

    return RegistrationPayload(
      udid: udid,
      username: username,
      platformUrl: platformUrl,
      deviceFingerprint: fingerprint,
    );
  }

  // Convert to JSON (Map) for sending in requests
  Map<String, dynamic> toJson() {
    return {
      'udid': udid,
      'username': username,
      'platformUrl': platformUrl,
      'deviceFingerprint': deviceFingerprint,
    };
  }
}
