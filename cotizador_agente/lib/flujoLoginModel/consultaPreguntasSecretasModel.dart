class consultaPreguntasSecretasModel{

  String requestStatus;
  String uid;
  List<preguntaRespuestaModel> listaPreguntas;

  consultaPreguntasSecretasModel({this.requestStatus, this.uid ,this.listaPreguntas});

  factory consultaPreguntasSecretasModel.fromJson(Map<dynamic, dynamic> data){
    var list = data['preguntasRespuestas'] as List;
    return consultaPreguntasSecretasModel(
      requestStatus: data['requestStatus'],
      uid: data.containsKey('uid') && data['uid'] != null ? data['uid'] : "",
      listaPreguntas: list.map((value) => new preguntaRespuestaModel.fromJson(value)).toList()
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