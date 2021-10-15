import 'dart:io';

import 'package:http/http.dart' as http;

class ConnectionManager {
  static Future<bool> isConnected() async {
    try {
      var res = await http.get("https://www.google.com");
      var code = res.statusCode;
      if (code != null) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      //SIN CONEXION
      return false;
    } catch (ex) {
      return false;
    }
  }
}
