class PerfilPersonalesModel {
  final String nickname;
  final List carrera;
  final List idiomas;
  final Map pasaporte;
  final Map visa;


  PerfilPersonalesModel({this.nickname, this.carrera ,this.idiomas, this.pasaporte,this.visa});

  factory PerfilPersonalesModel.fromJson(Map<String, dynamic> json) {
    return PerfilPersonalesModel(
      nickname: json['nickname'],
      carrera: json['carrera'],
      idiomas: json['idiomas'],
      pasaporte: json['pasaporte'],
      visa: json['visa'],
    );
  }
}
