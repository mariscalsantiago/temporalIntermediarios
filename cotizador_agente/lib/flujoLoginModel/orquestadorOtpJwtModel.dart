class OrquetadorOtpJwtModel{
  int timestamp;
  int  status;
  String error;
  String message;
  String path;
  String uid;
  String idOperacion;
  String idError;

  OrquetadorOtpJwtModel({this.timestamp, this.status, this.error, this.message,  this.path, this.uid, this.idOperacion, this.idError});

  factory OrquetadorOtpJwtModel.fromJson(Map<dynamic, dynamic> data){
    return OrquetadorOtpJwtModel(
      timestamp: data.containsKey('timestamp') && data['timestamp'] != null ? data['timestamp'] : 0,
      status: data.containsKey('status') && data['status'] != null ? data['status'] : 0,
      error: data.containsKey('error') && data['error'] != null ? data['error'] : "",
      message: data.containsKey('message') && data['message'] != null ? data['message'] : "",
      path: data.containsKey('path') && data['path'] != null ? data['path'] : "",
      uid: data.containsKey('uid') && data['uid'] != null ? data['uid'] : "",
      idOperacion: data.containsKey('idOperacion') && data['idOperacion'] != null ? data['idOperacion'] : "",
      idError: data.containsKey('idError') && data['idError'] != null ? data['idError'] : "",

    );
  }

  toJson() {
    return{
      'timestamp': timestamp,
      'status':status,
      'error': error,
      'message': message,
      'path': path,
      'idError': idError
    };
  }

}