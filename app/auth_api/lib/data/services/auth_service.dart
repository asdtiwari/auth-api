import 'dart:async';
import 'dart:convert';

import 'package:auth_api/core/constants/api_endpoints.dart';
import 'package:auth_api/core/constants/app_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _client = http.Client();

  // either return "success", reponse.body or e.toString()
  Future<String> sendRequest(String request, String endpoint) async {
    final uri = Uri.parse(ApiEndpoints.url(endpoint));

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request),
          )
          .timeout(
            Duration(milliseconds: AppConfig.defaultTimeout),
            onTimeout: () {
              throw TimeoutException('Server is not responding.');
            },
          );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> registerPlatform(String request) async {
    try {
      return await sendRequest(request, ApiEndpoints.register);
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> unregisterDevice(String request) async {
    try {
      return await sendRequest(request, ApiEndpoints.unregister);
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getLoginRequest(String request) async {
    try {
      return await sendRequest(request, ApiEndpoints.requests);
    }  
    catch (e) {
      return e.toString();
    }
  }

  Future<String> respondToLogin(String request) async {
    try {
      return sendRequest(request, ApiEndpoints.respond);
    } catch (e) {
      return e.toString();
    }
  }
}
