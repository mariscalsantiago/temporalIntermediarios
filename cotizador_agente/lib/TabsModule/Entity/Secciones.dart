class Secciones {
  int posicion;
  String titulo;
  String icono;
  String localIcon;
  bool habilitado;
  String accion;

  Secciones(
      {this.posicion, this.titulo, this.icono, this.habilitado, this.accion, this.localIcon});

  Secciones.fromJson(Map<String, dynamic> json) {
    posicion = json['posicion'];
    titulo = json['titulo'];
    icono = json['icono'];
    localIcon = json['localIcon'];
    habilitado = json['habilitado'];
    accion = json['accion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posicion'] = this.posicion;
    data['titulo'] = this.titulo;
    data['icono'] = this.icono;
    data['localIcon'] = this.localIcon;
    data['habilitado'] = this.habilitado;
    data['accion'] = this.accion;
    return data;
  }
}