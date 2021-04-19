class cambioContrasenaModel{

  String requestId;
  String requestStatus;
  String uid;
  String error;

  cambioContrasenaModel({this.requestId, this.requestStatus, this.uid, this.error});

  factory cambioContrasenaModel.fromJson(Map<dynamic, dynamic> data){

    return cambioContrasenaModel(
        requestId: data.containsKey('requestId') && data['requestId'] != null ? data['requestId'] : "",
        requestStatus: data['requestStatus'],
        uid: data['uid'],
        error: data.containsKey('error') && data['error'] != null ? data['error'] : "",

    );
  }

  toJson() {
    return{
      'requestId': requestId,
      'requestStatus':requestStatus,
      'uid': uid,
      'error': error,
    };
  }

}

class ReestablecerContrasenaModel{
  String cambioContrasenaResponse;
  respuestaRestablecerContrasenaModel respueta;

  ReestablecerContrasenaModel({this.cambioContrasenaResponse, this.respueta});

  factory ReestablecerContrasenaModel.fromJson(Map<dynamic, dynamic> data){
    return ReestablecerContrasenaModel(
      cambioContrasenaResponse:  data['cambioContrasenaResponse'] ,
      respueta: data["return"] != null ? respuestaRestablecerContrasenaModel.fromJson(data["return"]): respuestaRestablecerContrasenaModel(),
    );
  }

  toJson() {
    return{
      'cambioContrasenaResponse': cambioContrasenaResponse,
    };
  }
}

class respuestaRestablecerContrasenaModel{
  String retorno;

  respuestaRestablecerContrasenaModel({this.retorno});

  factory respuestaRestablecerContrasenaModel.fromJson(Map<dynamic, dynamic> data){

    return respuestaRestablecerContrasenaModel(
      retorno:  data['return'] ,

    );
  }

  toJson() {
    return{
      'retorno': retorno,
    };
  }

}