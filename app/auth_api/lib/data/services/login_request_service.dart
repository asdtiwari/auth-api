import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/models/login_request_model.dart';
import 'package:auth_api/data/services/device_service.dart';

class LoginRequestService {
  
  static Future<List<LoginRequestModel>> decryptPendings(List<dynamic> list) async {
    final deviceSecret = await DeviceService().getOrCreateDeviceSecret();
    final pendingRequest = <LoginRequestModel>[];
    for(final items in list) {
      final json = EncryptionUtils.decryptJson(items, deviceSecret);
      pendingRequest.add(await LoginRequestModel.build(json));
    }

    return pendingRequest;
  }
}