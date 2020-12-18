class SplashData {
  String imagen; //imagen_pie;
  int duracion;

  SplashData({this.imagen, this.duracion}); //SplashData({this.imagen, this.imagen_pie, this.duracion});

  SplashData.fromJson(Map<String, dynamic> json) {
    imagen = json['imagen'];
    //imagen_pie = json['imagen_pie'];
    duracion = json['duracion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagen'] = this.imagen;
    //data['imagen_pie'] = this.imagen_pie;
    data['duracion'] = this.duracion;
    return data;
  }
}