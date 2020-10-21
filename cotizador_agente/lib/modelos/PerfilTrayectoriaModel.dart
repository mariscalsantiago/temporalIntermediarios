class PerfilTrayectoriaModel {
  final String preparatoria;
  final String licenciatura;
  final String licenciaturaTipo;
  final String posgrado;
  final String posgradoTipo;
  final List idiomas;
  final List<DatosCursos> cursos;



  PerfilTrayectoriaModel({this.preparatoria, this.licenciatura ,this.licenciaturaTipo, this.posgrado,this.posgradoTipo, this.idiomas, this.cursos});

  factory PerfilTrayectoriaModel.fromJson(Map<String, dynamic> json) {
    return PerfilTrayectoriaModel(
      preparatoria: json['preparatoria'],
      licenciatura: json['licenciatura'],
      licenciaturaTipo: json['licenciaturaTipo'],
      posgrado: json['posgrado'],
      posgradoTipo: json['posgradoTipo'],
      idiomas: json['idiomas'],
      cursos: json['cursos'].map((value) => new DatosCursos.fromJson(value)).toList(),

    );
  }

}

class DatosCursos {
  DatosCursos({
    this.curso,
    this.idCapacitacion,
    this.nombre,
  });
  String idCapacitacion;
  Map curso;
  String nombre;

  factory DatosCursos.fromJson(Map<String, dynamic> parsedJson){
    return DatosCursos(
      curso: parsedJson['curso'],
      idCapacitacion:parsedJson['idCapacitacion'],
      nombre:parsedJson['nombre'],
    );
  }
  toJson() {
    return {
      'curso':curso,
      'idCapacitacion': idCapacitacion,
      'nombre':nombre
    };
  }

}

class CatalogoCursos {
  CatalogoCursos({
    this.cveTipoCapacitacion,
    this.idCapacitacion,
    this.nombre,
  });
  String cveTipoCapacitacion;
  String idCapacitacion;
  String nombre;

  factory CatalogoCursos.fromJson(Map<String, dynamic> parsedJson){
    return CatalogoCursos(
      cveTipoCapacitacion:parsedJson['cveTipoCapacitacion'],
      idCapacitacion:parsedJson['idCapacitacion'],
      nombre:parsedJson['nombre'],
    );
  }
  toJson() {
    return {
      'cveTipoCapacitacion':cveTipoCapacitacion,
      'idCapacitacion': idCapacitacion,
      'nombre':nombre
    };
  }
}