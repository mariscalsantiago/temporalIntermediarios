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

  respuestaRestablecerContrasenaModel cambioContrasenaResponse;
  String faultcode;
  String faultstring;
  Detalle detail;

  ReestablecerContrasenaModel({this.cambioContrasenaResponse, this.faultcode, this.faultstring, this.detail});

  factory ReestablecerContrasenaModel.fromJson(Map<dynamic, dynamic> data){
    return ReestablecerContrasenaModel(
      cambioContrasenaResponse: data.containsKey('cambioContrasenaResponse') && data["cambioContrasenaResponse"] != null ? respuestaRestablecerContrasenaModel.fromJson(data["cambioContrasenaResponse"]): null,
      faultcode: data.containsKey('faultcode') && data["faultcode"] != null ? data['faultcode'] : "",
      faultstring: data.containsKey('faultstring') && data["faultstring"] != null ? data['faultstring'] : "",
      detail: data.containsKey('detail') && data["detail"] != null ? Detalle.fromJson(data["detail"]): Detalle(),
    );
  }

  toJson() {
    return{
      'cambioContrasenaResponse': cambioContrasenaResponse,
      'faultcode': faultcode,
      'faultstring': faultstring,
      'detail' : detail
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

class Detalle {

  detalleError eotException;

  Detalle({this.eotException});

  factory Detalle.fromJson(Map<dynamic, dynamic> data){

    return Detalle(
      eotException:  data['eotException'] != null ?  detalleError.fromJson(data["eotException"]): detalleError(),

    );
  }

  toJson() {
    return{
      'eotException': eotException,
    };
  }

}

class detalleError{
  String mensajeLargo;
  String codigoError;
  String sistemaOrigen;
  String mensajeTecnico;
  String mensaje;

  detalleError({this.mensajeLargo, this.codigoError, this.sistemaOrigen, this.mensajeTecnico, this.mensaje});

  factory detalleError.fromJson(Map<dynamic, dynamic> data){

    return detalleError(
      mensajeLargo:  data['mensajeLargo'],
      codigoError:  data['codigoError'],
      sistemaOrigen:  data['sistemaOrigen'],
      mensajeTecnico:  data['mensajeTecnico'],
      mensaje:  data['mensaje'],

    );
  }

  toJson() {
    return{
      'mensajeLargo': mensajeLargo,
      'codigoError': codigoError,
      'sistemaOrigen': sistemaOrigen,
      'mensajeTecnico': mensajeTecnico,
      'mensaje':mensaje
    };
  }
}