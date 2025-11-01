class ApiEndpoints {
  static const String baseUrl = 'http://project-auth-api.duckdns.org:9080/api';

  static const String register = '/register';
  static const String requests = '/requests';
  static const String respond = '/respond';
  static const String unregister = '/unregister';

  static String url(String path) => '$baseUrl$path';
}