
ConexionModel conexionModel;

class ConexionModel {
  bool status;
  String message;



  ConexionModel({this.status, this.message});

  factory ConexionModel.fromJson(Map<String, dynamic> data) {

    return ConexionModel(
        status: data["status"],
        message: data['message']
    );
  }
  toJson() {
    return {
      'status': status,
      'message': message
    };
  }
}