class OrquestadorOTPModel{

  String uid;
  int timestamp;
  String idOperacion;
  String idError;
  String error;

  OrquestadorOTPModel({this.uid, this.timestamp, this.idOperacion, this.idError, this.error});

  factory OrquestadorOTPModel.fromJson(Map<dynamic, dynamic> data){
    return OrquestadorOTPModel(
      uid: data.containsKey('uid') && data['uid'] != null ? data['uid'] : "",
      timestamp: data.containsKey('timestamp') && data['timestamp'] != null ? data['timestamp'] : "",
      idOperacion: data.containsKey('idOperacion') && data['idOperacion'] != null ? data['idOperacion'] : "",
      idError: data.containsKey('idError') && data['idError'] != null ? data['idError'] : "",
      error: data.containsKey('error') && data['error'] != null ? data['error'] : "",

    );
  }

  toJson() {
    return{
      'uid': uid,
      'timestamp':timestamp,
      'idOperacion': idOperacion,
      'idError': idError,
      'error': error
    };
  }
}

class ValidarOTPModel{
    int timestamp;
    bool resultado;
    String idOperacion;
    String mensaje;
    String codOtp;
    String numCel;

    ValidarOTPModel({this.timestamp, this.resultado, this.idOperacion, this.mensaje, this.codOtp, this.numCel});

    factory ValidarOTPModel.fromJson(Map<dynamic, dynamic> data){
      return ValidarOTPModel(
        timestamp: data.containsKey('timestamp') && data['timestamp'] != null ? data['timestamp'] : "",
        resultado: data.containsKey('resultado') && data['resultado'] != null ? data['resultado'] : "",
        idOperacion: data.containsKey('idOperacion') && data['idOperacion'] != null ? data['idOperacion'] : "",
        mensaje: data.containsKey('mensaje') && data['mensaje'] != null ? data['mensaje'] : "",
        codOtp: data.containsKey('codOtp') && data['codOtp'] != null ? data['codOtp'] : "",
        numCel: data.containsKey('numCel') && data['numCel'] != null ? data['numCel'] : "",
      );
    }

    toJson() {
      return{
        'timestamp': timestamp,
        'resultado':resultado,
        'idOperacion': idOperacion,
        'mensaje': mensaje,
        'codOtp': codOtp,
        'numCel': numCel
      };
    }

}
