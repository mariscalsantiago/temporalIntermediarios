class consultaPreguntasSecretasModel{

  String requestStatus;
  String uid;
  String error;
  List<preguntaRespuestaModel> listaPreguntas;

  consultaPreguntasSecretasModel({this.requestStatus, this.uid , this.error,this.listaPreguntas});

  factory consultaPreguntasSecretasModel.fromJson(Map<dynamic, dynamic> data){
    var list = data.containsKey('preguntasRespuestas') && data['preguntasRespuestas'] != null ? data['preguntasRespuestas'] as List : [];
    return consultaPreguntasSecretasModel(
      requestStatus: data['requestStatus'],
      uid: data.containsKey('uid') && data['uid'] != null ? data['uid'] : "",
      error: data.containsKey('error') && data['error'] != null ? data['error'] : "",
      listaPreguntas: list.length > 0 ? list.map((value) => new preguntaRespuestaModel.fromJson(value)).toList() : null
    );
  }

  toJson() {
    return{
      'requestStatus': requestStatus,
      'uid':uid,
      'listaPreguntas': listaPreguntas,
    };
  }

}

class preguntaRespuestaModel {

  String pregunta;
  String respuesta;

  preguntaRespuestaModel({this.pregunta, this.respuesta});

  factory preguntaRespuestaModel.fromJson(Map<dynamic, dynamic> data){
    return preguntaRespuestaModel(
      pregunta: data['pregunta'],
      respuesta: data['respuesta'],
    );
  }

  toJson(){
    return{
      'pregunta': pregunta,
      'respuesta': respuesta,
    };
  }

}