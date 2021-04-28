class OrquetadorOtpJwtModel{
  String timestamp;
  int  status;
  String error;
  String message;
  String path;

  OrquetadorOtpJwtModel({this.timestamp, this.status, this.error, this.message,  this.path});

  factory OrquetadorOtpJwtModel.fromJson(Map<dynamic, dynamic> data){
    return OrquetadorOtpJwtModel(
      timestamp: data.containsKey('timestamp') && data['timestamp'] != null ? data['timestamp'] : "",
      status: data.containsKey('status') && data['status'] != null ? data['status'] : 0,
      error: data.containsKey('error') && data['error'] != null ? data['error'] : "",
      message: data.containsKey('message') && data['message'] != null ? data['message'] : "",
      path: data.containsKey('path') && data['path'] != null ? data['path'] : "",

    );
  }

  toJson() {
    return{
      'timestamp': timestamp,
      'status':status,
      'error': error,
      'message': message,
      'path': path
    };
  }

}