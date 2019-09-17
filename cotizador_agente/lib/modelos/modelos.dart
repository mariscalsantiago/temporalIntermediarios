
class Formulario {
  final String id;
  final List <Seccion> secciones;
  final String nombre;
  final String descripcion;
  final int cantidad_asegurados;
  final String estatus;

  Formulario({this.id, this.secciones, this.nombre, this.descripcion,
    this.cantidad_asegurados, this.estatus});


  factory Formulario.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['images'] as List;
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
  final String ID;
  final List<Campo> campos;
  final String seccion;

  Seccion({
    this.ID,
    this.campos,
    this.seccion,
  });


  factory Seccion.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson["campos"] as List;
    List<Campo> camp = list.map((i) => Campo.fromJson(i)).toList();


    return Seccion(
      ID: parsedJson["id_seccion"],
      campos: camp,
      seccion: parsedJson["seccion"],

    );
  }

}


class Campo {
  final String ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Valor>valores;

  Campo({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});

  factory Campo.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson["catalogo"]["valores"] as List;
    List<Valor> val = list.map((i) => Valor.fromJson(i)).toList();


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

class Valor {
  final int id;
  final String descripcion;

  Valor({this.id, this.descripcion});

  factory Valor.fromJson(Map<String, dynamic> parsedJson){


    return Valor(
      id: parsedJson["id_valor"],
      descripcion: parsedJson["descripcion"],

    );
  }


}