import 'dart:convert';

class HomeRamos {
  int posicion;
  String titulo;
  String icono;
  bool habilitado;
  String accion;
  String tituloFirebase;
  String selectorViewDetailPoliza;
  String saludoUser;

  HomeRamos(
      {this.posicion, this.titulo, this.icono, this.habilitado, this.accion, this.tituloFirebase, this.selectorViewDetailPoliza, this.saludoUser});

  HomeRamos.fromJson(Map<String, dynamic> json) {
    posicion = json['posicion'];
    titulo = json['titulo'];
    icono = json['icono'];
    habilitado = json['habilitado'];
    accion = json['accion'];
    tituloFirebase = json['tituloFirebase'];
    selectorViewDetailPoliza = json['selectorViewDetailPoliza'];
    saludoUser = json['saludoUser'];
    if (posicion == null && titulo == null && icono == null && habilitado == null && accion == null && tituloFirebase == null && selectorViewDetailPoliza == null && saludoUser == null) throw json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posicion'] = this.posicion;
    data['titulo'] = this.titulo;
    data['icono'] = this.icono;
    data['habilitado'] = this.habilitado;
    data['accion'] = this.accion;
    data['tituloFirebase'] = this.tituloFirebase;
    data['selectorViewDetailPoliza'] = this.selectorViewDetailPoliza;
    data['saludoUser'] = this.saludoUser;
    return data;
  }

  String toString() {
    return JsonEncoder().convert(this);
  }

}