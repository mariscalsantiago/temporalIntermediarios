
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';

class MyRequest {
  String baseUrl;
  String path;
  Method method;
  String body;
  Map<String, String> headers;

  MyRequest({this.baseUrl, this.path, this.method, this.body, this.headers});
}
