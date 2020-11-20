class SplashData {
  String imagen;
  int duracion;

  SplashData({this.imagen, this.duracion});

  SplashData.fromJson(Map<String, dynamic> json) {
    imagen = json['imagen'];
    duracion = json['duracion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagen'] = this.imagen;
    data['duracion'] = this.duracion;
    return data;
  }
}