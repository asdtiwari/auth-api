class LoginRequestModel {
  final String requestId;
  final String platformUrl;
  final String username;
  final DateTime issuedAt;
  final DateTime expiry;

  const LoginRequestModel({
    required this.requestId,
    required this.platformUrl,
    required this.username,
    required this.issuedAt,
    required this.expiry,
  });

  // Async factory method to build the model with required async data
  static Future<LoginRequestModel> build(Map<String, dynamic> json) async {
    return LoginRequestModel(
      requestId: json['requestId'],
      platformUrl: json['platformUrl'],
      username: json['username'],
      issuedAt: DateTime.parse(json['issuedAt']),
      expiry: DateTime.parse(json['expiry']),
    );
  }

  // Convert to JSON (Map) for sending in requests
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'platformUrl': platformUrl,
      'username': username,
      'issuedAt': issuedAt,
      'expiry': expiry,
    };
  }
}
