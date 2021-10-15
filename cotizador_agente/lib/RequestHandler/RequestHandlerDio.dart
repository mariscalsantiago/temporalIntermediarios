import 'dart:convert';
import 'dart:io';

import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class RequestHandlerDio {
  static Future<MyResponse> httpRequest(MyRequest request) async {
    print("services url: ${request.baseUrl}${request.path}");
    print("services headers: ${request.headers}");
    print("services body: ${request.body}");
    var fullURL = request.baseUrl + request.path;
    var dio = Dio();
    //SOLO ANDROID, SOLO UAT Y SOLO PARA EL SERVICIO DE SEGUIMIENTO A LA REPARACION.
    //SE USA UN CERTIFICADO AUTO-GENERADO PARA BRINCAR EL ERROR QUE MANDA EL SERVICIO
    //SOLO EN ANDROID.
    try {
      if (Platform.isAndroid) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
      dio.options.headers = request.headers;
      dio.options.responseType = ResponseType.plain;
      var res = await dio.post(fullURL,
          data: request.body,
          options: Options(
              followRedirects: true,
              validateStatus: (status) {
                return status < 500;
              }));
      var code = res.statusCode;
      if (code >= 200 && code <= 299) {
        //SUCCESS
        return new MyResponse(success: true, response: jsonDecode(res.data));
      } else if (code >= 400 && code <= 499) {
        //CLIENT ERROR
        return new MyResponse(success: true, response: jsonDecode(res.data));
      } else if (code >= 500 && code <= 599) {
        //SERVER ERROR
        return new MyResponse(
            success: false,
            response:
            "Por el momento el servicio no está disponible. Inténtalo más tarde.");
      } else {
        //OTRO TIPO DE ERROR
        return new MyResponse(success: false, response: "Error");
      }
    } on SocketException catch (_) {
      //SIN CONEXION
     // AnalyticsHandler.logEvent(name: "aviso_sin_conexion");
      return new MyResponse(
          success: false,
          response: "Verifica tu conexión a internet e inténtalo nuevamente");
    } catch (ex) {
      print(ex.toString()); //OTRO ERROR
      return new MyResponse(success: false, response: "Error");
    }
  }
}
