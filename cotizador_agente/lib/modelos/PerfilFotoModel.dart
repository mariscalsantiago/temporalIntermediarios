class PerfilFotoModel {

  final String url;
  final bool success;

  PerfilFotoModel({this.url, this.success});

  factory PerfilFotoModel.fromJson(Map<String, dynamic> json) {
    return PerfilFotoModel(
      success: json['success'],
      url: json['url'],

    );
  }
}