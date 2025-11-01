import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtils {
  static String generateBase64Key([int length = 32]) {
    final key = encrypt.Key.fromSecureRandom(length);
    return base64.encode(key.bytes);
  }

  static String hmacSha256(String message, String key) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(message));
    return base64.encode(digest.bytes);
  }

  static Map<String, dynamic> decryptJson(
    String base64Cipher,
    String base64Key,
  ) {
    final decodedBytes = base64.decode(base64Cipher);
    final decodedStr = utf8.decode(decodedBytes);
    final jsonMap = jsonDecode(decodedStr);
    final ivBytes = base64.decode(jsonMap['iv']);
    final cipherBytes = base64.decode(jsonMap['ciphertext']);

    final keyBytes = base64.decode(base64Key);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(keyBytes), mode: encrypt.AESMode.gcm),
    );

    final decrypted = encrypter.decrypt(
      encrypt.Encrypted(cipherBytes),
      iv: encrypt.IV(ivBytes),
    );
    return jsonDecode(decrypted);
  }

  static encrypt.IV _generateIv(int length) {
    final iv = encrypt.IV.fromSecureRandom(length);
    return iv;
  }

  static String encryptJson(Map<String, dynamic> data, String base64Key) {
    final keyBytes = base64.decode(base64Key);
    final iv = _generateIv(12);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(keyBytes), mode: encrypt.AESMode.gcm),
    );

    final jsonPlain = jsonEncode(data);
    final encrypted = encrypter.encrypt(jsonPlain, iv: iv);

    final result = {
      'iv': base64.encode(iv.bytes),
      'ciphertext': base64.encode(encrypted.bytes),
    };

    return base64.encode(utf8.encode(jsonEncode(result)));
  }
}
