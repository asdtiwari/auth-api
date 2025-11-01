import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';

class NetworkUtils {
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  static Future<String> getPublicIp() async {
    return (IpAddress(type: RequestType.json)).getIpAddress().toString();
  }
}