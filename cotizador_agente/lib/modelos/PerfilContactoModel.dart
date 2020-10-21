class PerfilContactoModel {
  final String telefonoEvento;
  final String correoEvento;
  final String nombreContatoEmergencia;
  final String parentescoContactoEmergencia;
  final String telefononContactoEmergencia;
  final String callback;

  PerfilContactoModel({this.telefonoEvento, this.correoEvento, this.nombreContatoEmergencia,this.telefononContactoEmergencia, this.parentescoContactoEmergencia, this.callback});

  factory PerfilContactoModel.fromJson(Map<String, dynamic> json) {
    return PerfilContactoModel(
      telefonoEvento: json['telefonoEvento'],
      correoEvento: json['correoEvento'],
      nombreContatoEmergencia: json['nombreContatoEmergencia'],
      parentescoContactoEmergencia: json['parentescoContactoEmergencia'],
      telefononContactoEmergencia: json['telefononContactoEmergencia'],
      callback: json['callback'],
    );
  }
}