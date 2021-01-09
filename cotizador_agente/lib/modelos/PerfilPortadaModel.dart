class PerfilPortadaModel {

  final String urlTapiz;
  final bool success;

  PerfilPortadaModel({this.urlTapiz, this.success});

  factory PerfilPortadaModel.fromJson(Map<String, dynamic> json) {
    return PerfilPortadaModel(
      success: json['success'],
      urlTapiz: json['urlTapiz'],

    );
  }
}