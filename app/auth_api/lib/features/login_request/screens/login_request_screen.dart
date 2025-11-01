import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/core/utils/network_utils.dart';
import 'package:auth_api/data/models/login_request_model.dart';
import 'package:auth_api/data/services/auth_service.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/services/login_request_service.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/login_request/widgets/request_card.dart';
import 'package:flutter/material.dart';

class LoginRequestScreen extends StatefulWidget {
  const LoginRequestScreen({super.key});

  @override
  State<LoginRequestScreen> createState() => _LoginRequestScreenState();
}

class _LoginRequestScreenState extends State<LoginRequestScreen> {
  final AuthService _authService = AuthService();
  final List<LoginRequestModel> _loginRequests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    final udid = await DeviceService().getOrCreateUdid();
    final ip = await NetworkUtils.getPublicIp();

    final data = {'udid': udid, 'ip': ip};
    final request = EncryptionUtils.encryptJson(
      data,
      SecureKeys.loginRequestKey,
    );
    final response = await _authService.getLoginRequest(request);

    if (response.contains("Exception")) {
      if (!mounted) return;
      await InfoDialog.show(context, title: 'Error', message: response);
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    String base64Key = await DeviceService().getOrCreateDeviceSecret();
    final recievedData = EncryptionUtils.decryptJson(response, base64Key);

    if (recievedData['ip'] == ip) {
      final listOfLogins = recievedData['data'];

      final finalpendingList = await LoginRequestService.decryptPendings(
        listOfLogins,
      );

      if (!mounted) return;
      setState(() {
        _loginRequests.clear();
        _loginRequests.addAll(finalpendingList);
        _loading = false;
      });
    } else {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Error',
        message: 'Try again with stable connection',
      );
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }
  }

  void _handleAction(LoginRequestModel req, bool approved) async {
    final udid = await DeviceService().getOrCreateUdid();
    final data = {
      'udid': udid,
      'requestId': req.requestId,
      'approved': approved ? 'true' : 'false',
    };
    final base64Key = SecureKeys.loginRequestKey;
    final request = EncryptionUtils.encryptJson(data, base64Key);
    final response = AuthService().respondToLogin(request);

    final message = await response;
    if (!mounted) return;

    if (!message.contains("Exception")) {
      await InfoDialog.show(
        context,
        title: message == 'success' ? 'Success' : 'Failed',
        message: message == 'success' ? 'Login Successfully.' : 'Request is safely closed.',
      );

      setState(() {
        _loginRequests.remove(req);
      });
    } else {
      await InfoDialog.show(context, title: 'Error', message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Requests')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loginRequests.isEmpty
          ? const Center(child: Text('No pending login requests'))
          : ListView.builder(
              itemCount: _loginRequests.length,
              itemBuilder: (context, i) {
                final req = _loginRequests[i];
                return RequestCard(
                  request: req,
                  onAction: (approved) => _handleAction(req, approved),
                );
              },
            ),
    );
  }
}
