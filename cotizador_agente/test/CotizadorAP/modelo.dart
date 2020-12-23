//Modelo para obtener resultados cuando se guarda una cotización
class GuardaFormato {
  final String mensaje;
  final int folio;

  GuardaFormato({this.mensaje, this.folio});

  factory GuardaFormato.fromJson(Map<String, dynamic> parsedJson){
    return GuardaFormato(
      mensaje: parsedJson["mensaje"],
      folio: parsedJson["folio"],
    );
  }
}

class ResponseEnviaC {
  final String message;
  final int correlationId;

  ResponseEnviaC({this.message, this.correlationId});

  factory ResponseEnviaC.fromJson(Map<String,dynamic> parsedJson){
    return ResponseEnviaC(
      message: parsedJson['message'],
      correlationId: parsedJson['correlationId']
    );
  }
}