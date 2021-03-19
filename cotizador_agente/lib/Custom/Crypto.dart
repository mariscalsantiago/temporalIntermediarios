import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;


Map encryptAESCryptoJS(String plainText) {
  try {
    List<int> bytesKey = utf8.encode("CL#AvEPrincIp4LvA#lMEXapgpsi2020");
    List<int> bytesIV = utf8.encode("v3cT*r1niTaPpS1+");
    final key = encrypt.Key(bytesKey);
    final iv = encrypt.IV(bytesIV);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    Uint8List encryptedBytesWithSalt = Uint8List.fromList(encrypted.bytes);
    Map mapaEncryptado = {
      "DatosEncriptados": base64.encode(encryptedBytesWithSalt)
    };
    print("mapaEncryptado");
    print(mapaEncryptado);
    return mapaEncryptado;
  } catch (error) {
  print("error");
  print(error);
    throw error;
  }
}

String decryptAESCryptoJS(String encrypted, String passphrase) {
  try {
    Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

    Uint8List encryptedBytes =
    encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
    List<int> bytesKey = utf8.encode(passphrase);
    List<int> bytesIV = utf8.encode("v3cT*r1niTaPpS1+");
    final key = encrypt.Key(bytesKey);
    final iv = encrypt.IV(bytesIV);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
    final decrypted =
    encrypter.decrypt64(base64.encode(encryptedBytesWithSalt), iv: iv);
    return decrypted;
  } catch (error) {
    throw error;
  }
}
