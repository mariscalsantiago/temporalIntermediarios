
import 'package:cotizador_agente/modelos_widget/reglonTabla.dart';
import 'package:flutter/material.dart';

class Formulario {
  final int id;
  final List <Seccion> secciones;
  final String nombre;
  final String descripcion;
  final int cantidad_asegurados;
  final String estatus;

  Formulario({this.id, this.secciones, this.nombre, this.descripcion,
    this.cantidad_asegurados, this.estatus});


  factory Formulario.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['secciones'] as List;
    List<Seccion> secc = list.map((i) => Seccion.fromJson(i)).toList();


    return Formulario(
        id: parsedJson["id_aplicacion"],
        nombre: parsedJson["nombre"],
        descripcion: parsedJson ["descripcion"],
        cantidad_asegurados: parsedJson ["cantidad_asegurados"],
        estatus: parsedJson["estatus"],
        secciones: secc

    );
  }

}

class Seccion {
  final int ID;
  final List<Campo> campos;
  final String seccion;
   int multiplicador ;
  final List <Seccion> children_secc;

  Seccion({
    this.ID,
    this.campos,
    this.seccion,
    this.multiplicador,
    this.children_secc
  });


  factory Seccion.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson["campos"] as List;
    List<Campo> camp = list.map((i) => Campo.fromJson(i)).toList();

    return Seccion(
      ID: parsedJson["id_seccion"],
      campos: camp,
      seccion: parsedJson["seccion"],
      multiplicador: parsedJson["multiplicador"]!= null? parsedJson["multiplicador"]: 0, //Si es multiplicador
      children_secc: new List<Seccion>()

    );
  }

}


class Campo {
  static int view_cont_ID=0;
  final int view_ID;
  final int ID;
  String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Valor>valores;
  final Rango rango;
  final List <int>  dato_longitud;
  String valor;

  Campo({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores, this.rango, this.view_ID, this.dato_longitud, this.valor});

  bool validaLongitud (int val){

    if(dato_longitud.isEmpty){
      return true;
    }

    if(dato_longitud.length>=1){
      if(val>dato_longitud[0] && val<dato_longitud[1]){
        return true;
      }

    }else{
      if(val<dato_longitud[0]){
        return true;
      }
    }

    return false;

  }

  factory Campo.fromJson(Map<String, dynamic> parsedJson){
    view_cont_ID ++;

    List<Valor> val;

    try {

    var list = parsedJson["catalogo"]["valores"] as List;
    val = list.map((i) => Valor.fromJson(i)).toList();


    } on NoSuchMethodError{
      val = null;

    }


    Rango r;

    try {

    //var list = parsedJson["catalogo"]["rangos"] as List;
    //val = list.map((i) => Valor.fromJson(i)).toList();

      r = Rango.fromJson(parsedJson["catalogo"]["rangos"]);


    } on NoSuchMethodError{
      r = null;

    }

    List <int> longitud = new List <int>();


    try {

      var list = parsedJson['dato_longitud'];

      List<int> streetsList = new List<int>.from(list);
      longitud = streetsList;

    } on NoSuchMethodError{
      longitud = null;

    }









    return Campo(
      ID: parsedJson["id_campo"],
      etiqueta: parsedJson["etiqueta"],
      obligatorio: parsedJson["obligatorio"],
      nombre_campo: parsedJson["nombre_campo"],
      tipo_dato: parsedJson["tipo_dato"],
      tipo_componente: parsedJson["tipo_componente"],
      visible: parsedJson["visible"],
      regla: parsedJson["regla"],
      valores: val,
      rango: r,
      view_ID: view_cont_ID,
      dato_longitud: longitud,



    );
  }


}


class Catalogo {
  final List <Valor> valores;
  Catalogo({this.valores});


  factory Catalogo.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson["valores"] as List;

    List<Valor> val = list.map((i) => Valor.fromJson(i)).toList();

    return Catalogo(
      valores: parsedJson["id_valor"],
    );
  }


}

class Rango {
  final String rango_inicio;
  final String rango_fin;

  Rango({this.rango_inicio, this.rango_fin});

  factory Rango.fromJson(Map<String, dynamic> parsedJson){
    return Rango(
      rango_inicio: parsedJson["rango_inicio"],
      rango_fin: parsedJson["rango_fin"],

    );
  }




}


class Valor {
  final String id;
  final String descripcion;
  final Campo child;
  final bool subnivel;

  Valor({this.id, this.descripcion, this.subnivel, this.child});

  factory Valor.fromJson(Map<String, dynamic> parsedJson){
    Campo hijo = null;
    bool sub = false;

    try{
      sub = parsedJson["subnivel"];
      hijo = Campo.fromJson(parsedJson);
    }on NoSuchMethodError{
      hijo = null;
      sub = false;
    }

    return Valor(
      id: parsedJson["id_valor"],
      descripcion: parsedJson["descripcion"],
      subnivel: sub,
      child: hijo,

    );
  }

}


class Cotizacion2Campos{

  final String titulo;
  final String valor;

  Cotizacion2Campos({this.titulo, this.valor});
}

class Cotizacion {

  final String fecha;
  final String titular;
  final String id;

  Cotizacion({this.fecha, this.titular, this.id});



}