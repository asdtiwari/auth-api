import 'dart:convert';
import 'dart:io';

import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceService {
  final _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return {
        'brand': info.brand,
        'device': info.device,
        'model': info.model,
        'hardware': info.hardware,
        'sdkInt': info.version.sdkInt,
      };
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return {
        'model': info.model,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
        'identifierForVendor': info.identifierForVendor,
      };
    } else {
      return {'platform': 'unknown'};
    }
  }

  Future<String> getOrCreateUdid() async {
    String? existing = await SecureStorage.read(SecureKeys.udid);
    if(existing != null) return existing;

    final udid = await FlutterUdid.consistentUdid;
    await SecureStorage.write(SecureKeys.udid, udid);
    return udid;
  }

  Future<String> getOrCreateDeviceFingerprint() async {
    String? existing = await SecureStorage.read(SecureKeys.deviceFingerprint);
    if(existing != null) return existing;

    final deviceInfo = await getDeviceInfo();
    final salt = EncryptionUtils.generateBase64Key(16);
    final rawJson = jsonEncode(deviceInfo);

    final fingerprint = EncryptionUtils.hmacSha256(rawJson, salt);
    await SecureStorage.write(SecureKeys.deviceFingerprint, fingerprint);

    return fingerprint;
  }

  Future<String> getOrCreateDeviceSecret() async {
    String? existing = await SecureStorage.read(SecureKeys.deviceSecret);
    if(existing != null) return existing;

    final udid = await getOrCreateUdid();
    final deviceFingerPrint = await getOrCreateDeviceFingerprint();
    final combinedUdidFingerprint = "$udid$deviceFingerPrint";

    final deviceSecret = EncryptionUtils.hmacSha256(combinedUdidFingerprint, udid);
    await SecureStorage.write(SecureKeys.deviceSecret, deviceSecret);

    return deviceSecret;
  }
}