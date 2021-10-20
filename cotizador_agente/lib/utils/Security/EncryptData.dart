import 'dart:convert';
import 'dart:typed_data';
import 'package:cotizador_agente/utils/Security/SecurityKey.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptData {
  SecurityKey _saveKeys = SecurityKey();
  String _key;
  String _initVector;
  String _decrypted;
  var _keyBase64;
  var _initVectorBase64;

  String encryptInfo(String data, String keyName) {
    try {
      if ( data != null ) {
        List<int> bytesKey = utf8.encode("CL#AvEPrincIp4LvA#lMEXapgpsi2020");
        List<int> bytesIV = utf8.encode("v3cT*r1niTaPpS1+");
        final key = encrypt.Key(bytesKey);
        final iv = encrypt.IV(bytesIV);
        final encrypter = encrypt.Encrypter(
            encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
        final encrypted = encrypter.encrypt(data, iv: iv);
        Uint8List encryptedBytesWithSalt = Uint8List.fromList(encrypted.bytes);
        return base64.encode(encryptedBytesWithSalt);
      }
      return "";
    } catch (error) {
      print("error");
      print(error);
      throw error;
    }
  }

  String decryptData(String encrypted, String passphrase) {
    try {
      if ( encrypted != null) {

        Uint8List encryptedBytesWithSalt = base64.decode(encrypted);
        List<int> bytesKey = utf8.encode(passphrase);
        List<int> bytesIV = utf8.encode("v3cT*r1niTaPpS1+");
        final key = encrypt.Key(bytesKey);
        final iv = encrypt.IV(bytesIV);

        final encrypter = encrypt.Encrypter(
            encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
        final decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytesWithSalt), iv: iv);
        return decrypted;
      }
      print("objeto nulo $encrypted");
      return "";
    } catch (error) {
      throw error;
    }
  }
}
