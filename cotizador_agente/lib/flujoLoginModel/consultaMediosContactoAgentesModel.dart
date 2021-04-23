class consultaMediosContactoAgentesModel{
  String codigoFiliacion;
  mediosContactoModel mediosContacto;

  consultaMediosContactoAgentesModel({this.codigoFiliacion, this.mediosContacto});

  factory consultaMediosContactoAgentesModel.fromJson(Map<dynamic, dynamic> data){
    return consultaMediosContactoAgentesModel(
        codigoFiliacion:data['codigoFiliacion'],
        mediosContacto :data.containsKey('mediosContacto') && data["mediosContacto"] != null ? mediosContactoModel.fromJson(data["mediosContacto"]): mediosContactoModel(),

    );
  }

  toJson() {
    return{
      'codigoFiliacion': codigoFiliacion,
      'mediosContacto':mediosContacto,
    };
  }

}


class mediosContactoModel{

  List<telefonosModel> telefonos;
  List<correosModel> correos;

  mediosContactoModel({this.telefonos, this.correos});

  factory mediosContactoModel.fromJson(Map<dynamic, dynamic> data){
    var list = data.containsKey('telefonos') && data['telefonos'] != null ? data['telefonos'] as List : [];
    var listDos = data.containsKey('correos') && data['correos'] != null ? data['correos'] as List : [];
    return mediosContactoModel(
        telefonos: list.length > 0 ? list.map((value) => new telefonosModel.fromJson(value)).toList() : null,
        correos: list.length > 0 ? listDos.map((value) => new correosModel.fromJson(value)).toList() : null
    );
  }

  toJson() {
    return{
      'telefonos': telefonos,
      'correos':correos,
    };
  }
}

class telefonosModel{

  int idMedioContacto;
  bool principal;
  tipoContactoModel tipoContacto;
  String valor;
  String lada;
  String extension;
  int posicion;
  String cveLadaInternacional;
  List<sistemaOrigenModel> sistemaOrigen;
  consolidacionModel consolidacion;
  bool banConexionAgente;

  telefonosModel({this.idMedioContacto, this.principal, this.tipoContacto, this.valor, this.lada, this.extension, this.posicion, this.cveLadaInternacional, this.sistemaOrigen,
                  this.consolidacion, this.banConexionAgente});

  factory telefonosModel.fromJson(Map<dynamic, dynamic> data){
    var listDos = data.containsKey('sistemaOrigen') && data['sistemaOrigen'] != null ? data['sistemaOrigen'] as List : [];
    return telefonosModel(
        idMedioContacto: data['idMedioContacto'],
        principal: data['principal'],
        tipoContacto: data.containsKey('tipoContacto') && data["tipoContacto"] != null ? tipoContactoModel.fromJson(data["tipoContacto"]): tipoContactoModel(),
        valor: data['valor'],
        lada: data['lada'],
        extension: data['extension'],
        posicion: data['posicion'],
        cveLadaInternacional: data['cveLadaInternacional'],
        sistemaOrigen: listDos.length > 0 ? listDos.map((value) => new sistemaOrigenModel.fromJson(value)).toList() : null,
        consolidacion: data['consolidacion'],
        banConexionAgente:data['banConexionAgente']
    );
  }

  toJson() {
    return{
      'idMedioContacto': idMedioContacto,
      'principal':principal,
      'tipoContacto': tipoContacto,
      'valor': valor,
      'lada': lada,
      'extension': extension,
      'posicion': posicion,
      'cveLadaInternacional': cveLadaInternacional,
      'sistemaOrigen': sistemaOrigen,
      'consolidacion': consolidacion,
      'banConexionAgente': banConexionAgente
    };
  }

}

class consolidacionModel{
  String idParticipanteConsolidadoHijo;
  String codigoFiliacion;

  consolidacionModel({this.idParticipanteConsolidadoHijo, this.codigoFiliacion});

  factory consolidacionModel.fromJson(Map<dynamic, dynamic> data){

    return consolidacionModel(
        idParticipanteConsolidadoHijo: data['idParticipanteConsolidadoHijo'],
        codigoFiliacion:  data['codigoFiliacion']
    );
  }

  toJson() {
    return{
      'idParticipanteConsolidadoHijo': idParticipanteConsolidadoHijo,
      'codigoFiliacion':codigoFiliacion,
    };
  }
}

class sistemaOrigenModel{

  String cveSistemaOrigen;
  List<valorModel> valor;

  sistemaOrigenModel({this.cveSistemaOrigen, this.valor});

  factory sistemaOrigenModel.fromJson(Map<dynamic, dynamic> data){
    var listDos = data.containsKey('valor') && data['valor'] != null ? data['valor'] as List : [];
    return sistemaOrigenModel(
        cveSistemaOrigen: data['cveSistemaOrigen'],
        valor: listDos.length > 0 ? listDos.map((value) => new valorModel.fromJson(value)).toList() : null,
    );
  }

  toJson() {
    return{
      'cveSistemaOrigen': cveSistemaOrigen,
      'valor':valor,
    };
  }
}

class valorModel{

  String valorClaveOrigen;

  valorModel({this.valorClaveOrigen});

  factory valorModel.fromJson(Map<dynamic, dynamic> data){

    return valorModel(
      valorClaveOrigen: data['valorClaveOrigen']
    );
  }

  toJson() {
    return{
      'valorClaveOrigen': valorClaveOrigen
    };
  }

}

class tipoContactoModel{

  String id;
  String descripcion;

  tipoContactoModel({this.id, this.descripcion});

  factory tipoContactoModel.fromJson(Map<dynamic, dynamic> data){

    return tipoContactoModel(
        id: data['id'],
        descripcion: data['descripcion']
    );
  }

  toJson() {
    return{
      'id': id,
      'descripcion': descripcion

    };
  }

}

class correosModel{

  int idMedioContacto;
  bool principal;
  tipoContactoCorreroModel tipoContacto;
  String valor;
  int posicion;
  List<propositosContactoModel>  propositosContacto;
  List<sistemaOrigenCorreoModel> sistemaOrigen;
  consolidacionCorreoModel consolidacion;
  bool banConexionAgente;

  correosModel({this.idMedioContacto, this.principal, this.tipoContacto, this.valor, this.posicion, this.propositosContacto, this.sistemaOrigen, this.consolidacion, this.banConexionAgente});

  factory correosModel.fromJson(Map<dynamic, dynamic> data){
    var listUno = data.containsKey('sistemaOrigen') && data['sistemaOrigen'] != null ? data['sistemaOrigen'] as List : [];
    var listDos = data.containsKey('propositosContacto') && data['propositosContacto'] != null ? data['propositosContacto'] as List : [];
    return correosModel(
        idMedioContacto: data['idMedioContacto'],
        principal: data['principal'],
        tipoContacto: data.containsKey('tipoContacto') && data["tipoContacto"] != null ? tipoContactoCorreroModel.fromJson(data["tipoContacto"]): tipoContactoCorreroModel(),
        valor: data['valor'],
        posicion: data['posicion'],
        propositosContacto: listDos.length > 0 ? listDos.map((value) => new propositosContactoModel.fromJson(value)).toList() : null,
        sistemaOrigen: listUno.length > 0 ? listUno.map((value) => new sistemaOrigenCorreoModel.fromJson(value)).toList() : null,
        consolidacion: data.containsKey('consolidacion') && data["consolidacion"] != null ? consolidacionCorreoModel.fromJson(data["consolidacion"]): consolidacionCorreoModel(),
        banConexionAgente: data['banConexionAgente']
    );
  }

  toJson() {
    return{
      'idMedioContacto': idMedioContacto,
      'principal': principal,
      'tipoContacto': tipoContacto,
      'valor': valor,
      'posicion': posicion,
      'propositosContacto': propositosContacto,
      'sistemaOrigen': sistemaOrigen,
      'consolidacion': consolidacion,
      'banConexionAgente': banConexionAgente
    };
  }

}

class tipoContactoCorreroModel{

  String id;
  String descripcion;

  tipoContactoCorreroModel({this.id, this.descripcion});

  factory tipoContactoCorreroModel.fromJson(Map<dynamic, dynamic> data){

    return tipoContactoCorreroModel(
        id: data['id'],
        descripcion: data['descripcion']
    );
  }

  toJson() {
    return{
      'id': id,
      'descripcion': descripcion

    };
  }

}

class propositosContactoModel{

  String id;
  String descripcion;

  propositosContactoModel({this.id, this.descripcion});

  factory propositosContactoModel.fromJson(Map<dynamic, dynamic> data){

    return propositosContactoModel(
        id: data['id'],
        descripcion: data['descripcion']
    );
  }

  toJson() {
    return{
      'id': id,
      'descripcion': descripcion

    };
  }

}

class sistemaOrigenCorreoModel{

  String cveSistemaOrigen;
  List<valorCorreoModel> valor;

  sistemaOrigenCorreoModel({this.cveSistemaOrigen, this.valor});

  factory sistemaOrigenCorreoModel.fromJson(Map<dynamic, dynamic> data){

    var listUno = data.containsKey('valor') && data['valor'] != null ? data['valor'] as List : [];

    return sistemaOrigenCorreoModel(
        cveSistemaOrigen: data['cveSistemaOrigen'],
        valor: listUno.length > 0 ? listUno.map((value) => new valorCorreoModel.fromJson(value)).toList() : null,

    );
  }

  toJson() {
    return{
      'cveSistemaOrigen': cveSistemaOrigen,

    };
  }

}

class valorCorreoModel{
  String valorClaveOrigen;


  valorCorreoModel({this.valorClaveOrigen});

  factory valorCorreoModel.fromJson(Map<dynamic, dynamic> data){

    return valorCorreoModel(
        valorClaveOrigen: data['valorClaveOrigen']
    );
  }

  toJson() {
    return{
      'valorClaveOrigen': valorClaveOrigen,

    };
  }

}

class consolidacionCorreoModel{

  String idParticipanteConsolidadoHijo;
  String codigoFiliacion;

  consolidacionCorreoModel({this.idParticipanteConsolidadoHijo, this.codigoFiliacion});

  factory consolidacionCorreoModel.fromJson(Map<dynamic, dynamic> data){

    return consolidacionCorreoModel(
        idParticipanteConsolidadoHijo: data['idParticipanteConsolidadoHijo'],
        codigoFiliacion: data['codigoFiliacion']
    );
  }

  toJson() {
    return{
      'idParticipanteConsolidadoHijo': idParticipanteConsolidadoHijo,
      'codigoFiliacion': codigoFiliacion

    };
  }


}
