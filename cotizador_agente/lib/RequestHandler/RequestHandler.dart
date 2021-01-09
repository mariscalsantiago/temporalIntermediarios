import 'dart:convert';
import 'dart:io';

import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:http/http.dart' as http;

class RequestHandler {
  static Future<MyResponse> httpRequest(MyRequest request) async {
    print("services url: ${request.baseUrl}${request.path}");
    print("services headers: ${request.headers}");
    print("services body: ${request.body}");
    var fullURL = request.baseUrl + request.path;
    switch (request.method) {
      case Method.GET:
        try {
          var res = await http.get(fullURL, headers: request.headers);
          var code = res.statusCode;
          // if (res.body != null) {
          //   print("services payload: ${jsonDecode(res.body).toString()}");
          // }
          if (code >= 200 && code <= 299) {
            //SUCCESS
            return new MyResponse(
                success: true,
                response: jsonDecode(utf8.decode(res.bodyBytes)));
          } else if (code >= 400 && code <= 499) {
            //CLIENT ERROR
            return new MyResponse(
                success: true,
                response: jsonDecode(utf8.decode(res.bodyBytes)));
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
          return new MyResponse(
              success: false,
              response:
              "Verifica tu conexión a internet e inténtalo nuevamente");
        } catch (ex) {
          print(ex.toString()); //OTRO ERROR
          return new MyResponse(success: false, response: "Error");
        }
        break;
      case Method.POST:
        try {
          var res = await http.post(fullURL,
              headers: request.headers, body: request.body);
          var code = res.statusCode;
          /*if (res.body != null) {
            print("services payload: ${jsonDecode(res.body).toString()}");
          }*/
          if (code >= 200 && code <= 299) {
            //SUCCESS
            return new MyResponse(
                success: true,
                response: jsonDecode(utf8.decode(res.bodyBytes)));
          } else if (code >= 300 && code <= 399) {
            var redirectURL = res.headers["location"] ?? "";
            return await redirectedRequest(redirectURL, request);
          } else if (code >= 400 && code <= 499) {
            //CLIENT ERROR
            return new MyResponse(
                success: true,
                response: jsonDecode(utf8.decode(res.bodyBytes)));
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
        //  AnalyticsHandler.logEvent(name: "aviso_sin_conexion");
          return new MyResponse(
              success: false,
              response:
              "Verifica tu conexión a internet e inténtalo nuevamente");
        } catch (ex) {
          print(ex.toString()); //OTRO ERROR
          return new MyResponse(success: false, response: "Error");
        }
        break;
    }
    return new MyResponse(success: false, response: "Error");
  }

  static Future<MyResponse> redirectedRequest(String redirectURL, MyRequest request) async {
    var redirectReq = MyRequest(
        baseUrl: redirectURL,
        path: "",
        method: Method.POST,
        body: request.body,
        headers: request.headers);
    return await httpRequest(redirectReq);
  }
}

enum Method {
  GET,
  POST,
}
