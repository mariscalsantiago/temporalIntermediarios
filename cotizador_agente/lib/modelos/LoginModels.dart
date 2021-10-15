import 'dart:io';

import 'package:cotizador_agente/Functions/Validate.dart';

var config;
LoginModel loginData;
LoginDatosModel datosUsuario;
Map mapPerfilador;
PerfiladorModel datosPerfilador;
DatosFisicosModel datosFisicos;
DatosFisicosMediosContactoModel datosFisicosContacto;
DatosMoralesModel datosMorales;
ErrorLoginMessageModel mensajeStatus;
String idParticipanteMoral = "";
String currentCuaGNP;
String currentCuaLogros;
String currentCuaDesignaciones;
String rolCua;
String zonaBono;
String emailSession;

class DomicilioModel {
  List<DomicilioColoniaModel> colonias;
  DomicilioECModel ciudad;
  DomicilioECModel estado;


  DomicilioModel({this.colonias, this.ciudad, this.estado});

  factory DomicilioModel.fromJson(Map<String, dynamic> data) {
    print("DomicilioModel");
    print(data['colonias'].runtimeType);
    var list = data['colonias'] as List;

    return DomicilioModel(
        colonias: list.map((value) => new DomicilioColoniaModel.fromJson(value)).toList(),
        ciudad: DomicilioECModel.fromJson(data['ciudad']),
        estado: DomicilioECModel.fromJson(data["estado"])
    );
  }
  toJson() {
    return {
      'colonias': colonias,
      'ciudad': ciudad,
      'estado': estado
    };
  }
}

class DomicilioColoniaModel {
  String descripcion;
  String idDescripcion;



  DomicilioColoniaModel({this.descripcion, this.idDescripcion});

  factory DomicilioColoniaModel.fromJson(Map<String, dynamic> data) {

    return DomicilioColoniaModel(
        descripcion: data["descripcionValor"],
        idDescripcion: data['idValor']
    );
  }
  toJson() {
    return {
      'descripcion': descripcion,
      'idDescripcion': idDescripcion
    };
  }
}

class DomicilioECModel {
  String descripcionValor;
  String idValor;


  DomicilioECModel({this.descripcionValor, this.idValor});

  factory DomicilioECModel.fromJson(Map<String, dynamic> data) {

    return DomicilioECModel(
        descripcionValor: data['descripcionValor'],
        idValor: data["idValor"]
    );
  }
  toJson() {
    return {
      'descripcionValor': descripcionValor,
      'idValor': idValor,

    };
  }
}

class ErrorLoginMessageModel {
  String message;
  String title;
  bool success;

  ErrorLoginMessageModel({this.message, this.title, this.success});

  factory ErrorLoginMessageModel.fromJson(Map<String, dynamic> data) {
    return ErrorLoginMessageModel(
        message: data["mensaje"],
        title: data['titulo'],
        success: data["success"]
    );
  }

  toJson() {
    return {
      'mensaje': message,
      'titulo': title,
      'success': success
    };
  }

  final String statusErrorTextException = "Error: Response status" ;
  final String responseBodyErrorTextException = "Error: Body response null or empty" ;
  final String responseNullErrorTextException = "Error: Response null" ;
  final String passwordErrorTextAlert = "El campo es inválido." ;
  final String userErrorTextAlert = "El campo es inválido." ;

  userErrorAlert() {
    mensajeStatus= ErrorLoginMessageModel(
      success: false,
      title: "Usuario no encontrado",
      message: "Verifica tu usuario, si el error continúa por favor comunícate "
          "al 55 5227 3966.\n\nError: S1 - 404",
    );
  }

  passErrorAlert() {
    mensajeStatus= ErrorLoginMessageModel(
      success: false,
      title: "Datos incorrectos",
      message: "Verifica tu usuario y contraseña.",
    );
  }

  serviceErrorAlert(String error) {
    mensajeStatus= ErrorLoginMessageModel(
      success: false,
      title: "Detectamos un problema con tu usuario",
      message: "Por favor comunícate al 55 5227 3966.\n\n$error",

    );
  }

  connectionErrorAlert() {
    mensajeStatus= ErrorLoginMessageModel(
      success: false,
      title: "Error en la red",
      message: "Verifica tu conexión a internet e intenta nuevamente.",
    );
  }

}

class Huella {
  final String correo;
  final String contrasena;
  final String nombre;

  Huella({this.correo, this.contrasena, this.nombre});

  factory Huella.fromJson(Map<String, dynamic> json) {
    return Huella(
      correo: json['correo'],
      contrasena: json['contrasena'],
      nombre: json['nombre'],
    );
  }
}

class LoginModel {
  String jwt;
  String refreshtoken;
  String ip;
  String lastlogin;


  LoginModel({this.jwt, this.refreshtoken, this.ip, this.lastlogin});

  factory LoginModel.fromJson(Map<String, dynamic> data) {
    return LoginModel(
      jwt: data["jwt"],
      refreshtoken: data['refreshtoken'],
      ip: data["ip"],
      lastlogin: data['lastlogin'],
    );
  }
  toJson() {
    return {
      'jwt': jwt,
      'refreshtoken': refreshtoken,
      'ip': ip,
      'lastlogin': lastlogin,
    };
  }
}

class LoginDatosModel {
  String rol;
  String negociosOperables;
  String idparticipante;
  String mail;
  String emaillogin;
  String givenname;
  bool cuentabloqueada;
  String tipousuario;
  String cedula;
  bool iscurrentUser;
  List roles;


  LoginDatosModel({this.rol, this.negociosOperables, this.idparticipante, this.mail, this.emaillogin, this.givenname, this.cuentabloqueada, this.tipousuario, this.cedula, this.roles, this.iscurrentUser});

  factory LoginDatosModel.fromJson(Map<String, dynamic> data) {
    return LoginDatosModel(
      rol: data["rol"],
      negociosOperables: data["negociosOperables"],
      idparticipante: data["idparticipante"],
      mail: data["mail"],
      emaillogin: data["mail"],
      givenname: data["givenname"],
      cuentabloqueada: data["cuentabloqueada"],
      tipousuario: data["tipousuario"],
      cedula: data["cedula"],
      roles: data["roles"],
      iscurrentUser: false,
    );
  }
  toJson() {
    return {
      'rol': rol,
      'negociosOperables': negociosOperables,
      'idparticipante': idparticipante,
      'mail': mail,
      'emaillogin': emaillogin,
      'givenname': givenname,
      'cuentabloqueada': cuentabloqueada,
      'tipousuario': tipousuario,
      'cedula': cedula,
      'roles': roles,
      'iscurrentUser':iscurrentUser,
    };
  }
}

class PerfiladorModel {
  List<PerfiladorAgenteInteresadoModel> agenteInteresadoList;
  List<PerfiladorDaModel> daList;
  List intermediarios;


  PerfiladorModel({this.intermediarios, this.daList, this.agenteInteresadoList});

  factory PerfiladorModel.fromJson(Map<String, dynamic> data) {
    var list = data['agenteInteresado'] as List;
    var listD = data['da'] as List;
    return PerfiladorModel(
        agenteInteresadoList: list.map((value) => new PerfiladorAgenteInteresadoModel.fromJson(value)).toList(),
        daList: listD.map((value) => new PerfiladorDaModel.fromJson(value)).toList(),
        intermediarios: data["intermediarios"]
    );
  }
  toJson() {
    return {
      'agenteInteresadoList': agenteInteresadoList,
      'daList': daList,
      'intermediarios': intermediarios,

    };
  }
}

class PerfiladorAgenteInteresadoModel {
  String apellidoPaterno;
  String apellidoMaterno;
  String nombres;
  String idInteresado;
  String idAgente;
  String codIntermediario;
  String cveTipoInteres;
  String claveUnicaAgente;
  String cveEstatusAgente;
  String razonSocial;
  List unidadesNegocio;

  PerfiladorAgenteInteresadoModel({this.apellidoPaterno, this.apellidoMaterno, this.nombres,this.idInteresado, this.idAgente, this.codIntermediario, this.cveTipoInteres, this.claveUnicaAgente, this.cveEstatusAgente, this.razonSocial, this.unidadesNegocio});

  factory PerfiladorAgenteInteresadoModel.fromJson(Map<String, dynamic> data) {
    return PerfiladorAgenteInteresadoModel(
      apellidoPaterno: data["apellidoPaterno"],
      apellidoMaterno: data['apellidoMaterno'],
      nombres: data["nombres"],
      idInteresado: data["idInteresado"],
      idAgente: data['idAgente'],
      codIntermediario: data["codIntermediario"],
      cveTipoInteres:  data["cveTipoInteres"],
      claveUnicaAgente: data["claveUnicaAgente"],
      cveEstatusAgente: data['cveEstatusAgente'],
      razonSocial: data["razonSocial"],
      unidadesNegocio: data["unidadesNegocio"],

    );
  }
  toJson() {
    return {
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'nombres': nombres,
      'idInteresado': idInteresado,
      'idAgente': idAgente,
      'codIntermediario': codIntermediario,
      'cveTipoInteres': cveTipoInteres,
      'claveUnicaAgente': claveUnicaAgente,
      'cveEstatusAgente': cveEstatusAgente,
      'razonSocial': razonSocial,
      'unidadesNegocio': unidadesNegocio,

    };
  }
}

class PerfiladorDaModel {
  String cveDa;
  List codIntermediario;

  PerfiladorDaModel({this.codIntermediario,this.cveDa});

  factory PerfiladorDaModel.fromJson(Map<String, dynamic> data) {
    return PerfiladorDaModel(
      codIntermediario: data["codIntermediario"],
      cveDa: data['cveDa'],
    );
  }
  toJson() {
    return {
      'codIntermediario': codIntermediario,
      'cveDa': cveDa,
    };
  }
}

class DatosFisicosModel {
  DatosFisicosPersonalesModel personales;
  DatosFisicosContactoEmergenciaModel contactoEmergencia;
  DatosFisicosSaludModel salud;
  DatosFisicosEscolaridadModel escolaridad;
  List<DatosFisicosAcompaModel> compania;


  DatosFisicosModel({this.personales, this.contactoEmergencia, this.salud, this.escolaridad, this.compania});


  factory DatosFisicosModel.fromJson(Map<String, dynamic> data) {
    var list = data['acompaniante'] as List;
    print(list);
    print("DatosFisicosModel");
    return DatosFisicosModel(
      personales: DatosFisicosPersonalesModel.fromJson(data["personales"]),
      contactoEmergencia: DatosFisicosContactoEmergenciaModel.fromJson(data['contactoEmergencia']),
      salud: DatosFisicosSaludModel.fromJson(data["salud"]),
      escolaridad: DatosFisicosEscolaridadModel.fromJson(data['escolaridad']),
      compania: list.map((value) => new DatosFisicosAcompaModel.fromJson(value)).toList(),
    );
  }
  toJson() {
    return {
      'personales': personales,
      'contactoEmergencia': contactoEmergencia,
      'salud': salud,
      'escolaridad': escolaridad,
      'compania': compania,

    };
  }
}

class DatosFisicosPersonalesModel {
  String foto;
  File photoFile;
  String nombre;
  String aPaterno;
  String aMaterno;
  String nickname;
  String genero;
  String fechaNacimiento;
  int edad;
  String nacionalidad;
  String estadoCivil;
  String rfc;
  String curp;
  String talla;
  DatosFisicosPolizaModel polizaRC;
  DatosFisicosPersonalesVPModel pasaporte;
  DatosFisicosPersonalesVPModel visa;


  DatosFisicosPersonalesModel({this.foto, this.photoFile, this.nombre, this.aPaterno, this.aMaterno, this.nickname, this.genero, this.fechaNacimiento, this.edad, this.nacionalidad, this.estadoCivil, this.rfc, this.curp, this.pasaporte, this.visa, this.polizaRC, this.talla});

  factory DatosFisicosPersonalesModel.fromJson(Map<String, dynamic> data) {

    print("DatosFisicosPersonalesModel");
    print("${data["foto"]}");
    return DatosFisicosPersonalesModel(
      foto: data["foto"],
      photoFile: null,
      nombre: validateNotEmptyToString(data["nombre"],""),
      aPaterno: validateNotEmptyToString(data['aPaterno'],""),
      aMaterno: validateNotEmptyToString(data['aMaterno'],""),
      nickname:data["nickname"],
      genero:data['genero'],
      fechaNacimiento:data["fechaNacimiento"],
      edad: data['edad'],
      nacionalidad:data["nacionalidad"],
      estadoCivil: data['estadoCivil'],
      rfc: data['rfc'],
      curp:data["curp"],
      talla:data["talla"],
      polizaRC: data.containsKey('polizaRc') ? DatosFisicosPolizaModel.fromJson(data["polizaRc"]): DatosFisicosPolizaModel(),
      visa: data.containsKey('visa') ? DatosFisicosPersonalesVPModel.fromJson(data['visa']): DatosFisicosPersonalesVPModel(),
    );
  }
  toJson() {
    return {
      'foto': foto,
      'photoFile': photoFile,
      'nombre': nombre,
      'aPaterno': aPaterno,
      'aMaterno': aMaterno,
      'nickname': nickname,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento,
      'edad': edad,
      'nacionalidad': nacionalidad,
      'estadoCivil': estadoCivil,
      'rfc': rfc,
      'curp': curp,
      'pasaporte': pasaporte,
      'visa': visa,
      'polizaRC': polizaRC,
      'talla': talla,

    };
  }
}

class DatosFisicosPersonalesVPModel {

  String numero;
  String vigencia;


  DatosFisicosPersonalesVPModel({this.numero, this.vigencia});

  factory DatosFisicosPersonalesVPModel.fromJson(Map<String, dynamic> data) {
    print("DatosFisicosPersonalesVPModel");
    return DatosFisicosPersonalesVPModel(
      numero:data["numero"],
      vigencia: data['vigencia'],
    );
  }
  toJson() {
    return {
      'numero': numero,
      'vigencia': vigencia,

    };
  }
}

class DatosFisicosContactoEmergenciaModel {

  String nombre;
  String telefono;
  String parentesco;

  DatosFisicosContactoEmergenciaModel({this.nombre, this.telefono, this.parentesco});

  factory DatosFisicosContactoEmergenciaModel.fromJson(Map<String, dynamic> data) {
    print("DatosFisicosContactoEmergenciaModel");
    return DatosFisicosContactoEmergenciaModel(
      nombre: data["nombre"],
      telefono: data["telefono"],
      parentesco: data['parentesco'],
    );
  }
  toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'parentesco': parentesco,

    };
  }
}

class DatosFisicosSaludModel {

  String tipoSangre;
  bool tieneAlergias;
  List alergias;
  bool tieneEnfermedades;
  List enfermedades;
  bool tieneCondicionesEspeciales;
  List condicionesEspeciales; // espera de confirmacion
  bool tieneCondicionesAlimenticias;
  List condicionesAlimenticias;
  List deportes;
  bool fumador;


  DatosFisicosSaludModel({this.tipoSangre, this.tieneAlergias, this.alergias, this.tieneEnfermedades, this.enfermedades, this.tieneCondicionesEspeciales, this.condicionesEspeciales, this.deportes, this.fumador, this.condicionesAlimenticias,this.tieneCondicionesAlimenticias });

  factory DatosFisicosSaludModel.fromJson(Map<String, dynamic> data) {
    print("DatosFisicosSaludModel");
    return DatosFisicosSaludModel(
        tipoSangre: data["tipoSangre"],
        tieneAlergias: data["tieneAlergias"],
        alergias: data['alergias'],
        tieneEnfermedades: data["tieneEnfermedades"],
        enfermedades: data["enfermedades"],
        tieneCondicionesEspeciales: data['tieneCondicionesEspeciales'],
        condicionesEspeciales: data["condicionesEspeciales"],
        deportes: data["deportes"],
        fumador: data['fumador'],
        tieneCondicionesAlimenticias:data["tieneCondicionesAlimenticias"],
        condicionesAlimenticias: data ["condicionesAlimenticias"]
    );
  }
  toJson() {
    return {
      'tipoSangre': tipoSangre,
      'tieneAlergias': tieneAlergias,
      'alergias': alergias,
      'tieneEnfermedades': tieneEnfermedades,
      'enfermedades': enfermedades,
      'tieneCondicionesEspeciales': tieneCondicionesEspeciales,
      'condicionesEspeciales': condicionesEspeciales,
      'deportes': deportes,
      'fumador': fumador,
      'condicionesAlimenticias': condicionesAlimenticias,
      'tieneCondicionesAlimenticias':tieneCondicionesAlimenticias,

    };
  }
}

class DatosFisicosEscolaridadModel {

  String nivel;
  String area;
  String institucion;

  DatosFisicosEscolaridadModel({this.nivel, this.area, this.institucion});

  factory DatosFisicosEscolaridadModel.fromJson(Map<String, dynamic> data) {
    print("DatosFisicosEscolaridadModel");
    return DatosFisicosEscolaridadModel(
      nivel: data["nivel"],
      area: data["area"],
      institucion: data['institucion'],
    );
  }
  toJson() {
    return {
      'nivel': nivel,
      'area': area,
      'institucion': institucion,

    };
  }
}

class DatosFisicosPolizaModel {

  String numero;
  String vigenciaInicial;
  String vigenciaFin;

  DatosFisicosPolizaModel({this.numero, this.vigenciaInicial, this.vigenciaFin});

  factory DatosFisicosPolizaModel.fromJson(Map<String, dynamic> data) {
    print("DatosFisicosPolizaModel");
    return DatosFisicosPolizaModel(
      numero: data["numero"],
      vigenciaInicial: data["vigenciaInicial"],
      vigenciaFin: data['vigenciaFin'],
    );
  }
  toJson() {
    return {
      'numero': numero,
      'vigenciaInicial': vigenciaInicial,
      'vigenciaFin': vigenciaFin,

    };
  }
}

class DatosFisicosAcompaModel {

  String nombre;
  String parentesco;
  String telefono;

  DatosFisicosAcompaModel({this.nombre, this.parentesco, this.telefono});

  factory DatosFisicosAcompaModel.fromJson(Map<dynamic, dynamic> data) {
    print("DatosFisicosAcompaModel");
    return DatosFisicosAcompaModel(
      nombre: data["nombre"],
      parentesco: data["parentesco"],
      telefono: data['telefono'],
    );
  }
  toJson() {
    return {
      'nombre': nombre,
      'parentesco': parentesco,
      'telefono': telefono,

    };
  }
}

class DatosFisicosMediosContactoModel {
  String domicilioFiscal;
  DomicilioParticularModel domicilioParticular;
  String telefonoFijo;
  String telefonoMovil;
  String email;
  String codFiliacion;



  DatosFisicosMediosContactoModel({this.domicilioFiscal, this.domicilioParticular, this.telefonoFijo, this.telefonoMovil, this.email, this.codFiliacion});

  factory DatosFisicosMediosContactoModel.fromJson(Map<String, dynamic> data, DomicilioParticularModel domicilioParticular) {
    return DatosFisicosMediosContactoModel(
        domicilioFiscal: data["domicilioFiscal"],
        domicilioParticular: domicilioParticular,
        telefonoFijo: data["telefonoFijo"],
        telefonoMovil: data['telefonoMovil'],
        email: data["email"],
        codFiliacion: data["codFiliacion"]
    );
  }
  toJson() {
    return {
      'domicilioFiscal': domicilioFiscal,
      'domicilioParticular': domicilioParticular,
      'telefonoFijo': telefonoFijo,
      'telefonoMovil': telefonoMovil,
      'email': email,
      'codFiliacion': codFiliacion,
    };
  }
}

class DomicilioParticularModel {

  String calle;
  String codigoPostal;
  String colonia;
  String pais;
  String estado;
  String municipio;
  String direccionCompleta;
  String numeroEx;
  String numeroIn;
  DomicilioParticularModel({this.codigoPostal, this.calle, this.municipio, this.pais, this.direccionCompleta, this.numeroEx,this.numeroIn, this.estado, this.colonia});

}

class DatosMoralesModel {

  DatosMoralesIntermediarioModel datosIntermediario;
  List<DatosMoralesLogrosModel> logrosList;
  DatosMoralesDesignacionesModel designaciones;

  DatosMoralesModel({this.datosIntermediario, this.logrosList, this.designaciones});

  factory DatosMoralesModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesModel");
    var list = data['logros'] as List;
    print(list);
    return DatosMoralesModel(
      datosIntermediario: DatosMoralesIntermediarioModel.fromJson(data["datosIntermediario"]),
      designaciones: DatosMoralesDesignacionesModel.fromJson(data['designaciones']),
      logrosList: list.map((value) =>  new DatosMoralesLogrosModel.fromJson(value)).toList(),

    );
  }
  toJson() {
    return {
      'datosIntermediario': datosIntermediario,
      'logrosList': logrosList,
      'designaciones': designaciones,
    };
  }
}

class DatosMoralesIntermediarioModel {

  int claveIntermediario;
  int anioConexion;
  DatosMoralesIntermediarioFolioModel folio;
  int cua;
  int direccionAgencia; //cambio para int
  DatosMoralesIntermediarioFolioLiderModel folioLider;
  DatosMoralesIntermediarioCedulaModel cedula;
  String estatus;
  String fConexion;
  String generacion;
  String dirPlaza;
  int antiguedad;
  int lealtad;
  int oficinaAgente; // cambi para int
  String equipo;


  DatosMoralesIntermediarioModel({this.dirPlaza,this.claveIntermediario, this.anioConexion, this.folio, this.cua, this.direccionAgencia,this.folioLider, this.cedula, this.estatus, this.fConexion, this.generacion, this.antiguedad, this.lealtad, this.oficinaAgente,this.equipo});

  factory DatosMoralesIntermediarioModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesIntermediarioModel");
    return DatosMoralesIntermediarioModel(
      claveIntermediario: data['claveIntermediario'],
      anioConexion: data["anioConexion"],
      folio: DatosMoralesIntermediarioFolioModel.fromJson(data["folio"]),
      cua: data["cua"],
      equipo: data["equipo"],
      direccionAgencia: data["direccionAgencia"],
      folioLider: DatosMoralesIntermediarioFolioLiderModel.fromJson(data['folioLider']),
      cedula: DatosMoralesIntermediarioCedulaModel.fromJson(data['cedula']),
      estatus: data["estatus"],
      fConexion: data["fConexion"],
      generacion: data['generacion'],
      antiguedad: data["antigüedad"],
      lealtad: data['lealtad'],
      oficinaAgente: data['oficinaAgente'],
      dirPlaza: data['plaza']['dirPlaza'],
    );
  }
  toJson() {
    return {
      'claveIntermediario': claveIntermediario,
      'anioConexion': anioConexion,
      'folio': folio,
      'cua': cua,
      'equipo': equipo,
      'direccionAgencia': direccionAgencia,
      'folioLider': folioLider,
      'cedula': cedula,
      'estatus': estatus,
      'fConexion':fConexion,
      'generacion': generacion,
      'antiguedad': antiguedad,
      'lealtad': lealtad,
      'oficinaAgente': oficinaAgente,
    };
  }
}

class DatosMoralesIntermediarioFolioModel {
  int numero;
  String tipo;

  DatosMoralesIntermediarioFolioModel({this.numero, this.tipo});

  factory DatosMoralesIntermediarioFolioModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesIntermediarioFolioModel");
    return DatosMoralesIntermediarioFolioModel(
      numero: data["numero"],
      tipo: data["tipo"],
    );
  }
  toJson() {
    return {
      'numero': numero,
      'tipo': tipo,

    };
  }
}

class DatosMoralesIntermediarioFolioLiderModel {

  int numero;
  String direccionRegional;
  String directorRegional;
  String plaza;
  String responsablePlaza;

  DatosMoralesIntermediarioFolioLiderModel({this.numero, this.direccionRegional, this.directorRegional, this.plaza, this.responsablePlaza});

  factory DatosMoralesIntermediarioFolioLiderModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesIntermediarioFolioLiderModel");

    return DatosMoralesIntermediarioFolioLiderModel(
      numero: data["numero"],
      direccionRegional: data["direccionRegional"],
      directorRegional: data["directorRegional"],
      plaza: data["plaza"],
      responsablePlaza: data["responsablePlaza"],
    );
  }
  toJson() {
    return {
      'numero': numero,
      'direccionRegional': direccionRegional,
      'directorRegional': directorRegional,
      'plaza': plaza,
      'responsablePlaza': responsablePlaza,

    };
  }
}

class DatosMoralesIntermediarioCedulaModel {

  String numero;
  String tipo;
  String vencimiento;

  DatosMoralesIntermediarioCedulaModel({this.numero, this.tipo, this.vencimiento});

  factory DatosMoralesIntermediarioCedulaModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesIntermediarioCedulaModel");
    return DatosMoralesIntermediarioCedulaModel(
      numero: data["numero"],
      tipo: data["tipo"],
      vencimiento: data["vencimiento"],
    );
  }
  toJson() {
    return {
      'numero': numero,
      'tipo': tipo,
      'vencimiento': vencimiento,

    };
  }
}

class DatosMoralesLogrosModel {
  String congresoGanado;
  int anio;
  String ramo;
  String competencia;
  int lugar;

  DatosMoralesLogrosModel({this.congresoGanado, this.anio, this.ramo, this.competencia, this.lugar});

  factory DatosMoralesLogrosModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesLogrosModel");
    return DatosMoralesLogrosModel(
        congresoGanado: data["congresoGanado"],
        anio: data['anio'],
        ramo: data["ramo"],
        competencia: data['competencia'],
        lugar: data["lugar"]
    );

  }
  toJson() {
    return {
      'congresoGanado': congresoGanado,
      'anio': anio,
      'ramo': ramo,
      'competencia': competencia,
      'lugar': lugar,

    };
  }
}

class DatosMoralesDesignacionesModel {

  String mdtr;
  int anio;
  List<DatosMoralesDesignacionesListaModel> desginacinesList;

  DatosMoralesDesignacionesModel({this.mdtr, this.anio, this.desginacinesList});

  factory DatosMoralesDesignacionesModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesDesignacionesModel");
    var list = data['designaciones'] as List;
    return DatosMoralesDesignacionesModel(
      mdtr: data["mdtr"],
      anio: data["anio"],
      desginacinesList: list.map((value) =>  new DatosMoralesDesignacionesListaModel.fromJson(value)).toList(),
    );
  }
  toJson() {
    return {
      'mdtr': mdtr,
      'anio': anio,
      'Desginacineslista': desginacinesList,

    };
  }
}

class DatosMoralesDesignacionesListaModel {

  String tipo;
  String designacion;
  bool valor;

  DatosMoralesDesignacionesListaModel({this.tipo, this.designacion, this.valor});

  factory DatosMoralesDesignacionesListaModel.fromJson(Map<String, dynamic> data) {
    print("DatosMoralesDesignacionesListaModel");
    return DatosMoralesDesignacionesListaModel(
      tipo: data["tipo"],
      designacion: data["designacion"],
      valor: data['valor'],
    );
  }
  toJson() {
    return {
      'tipo': tipo,
      'designacion': designacion,
      'valor': valor,

    };
  }
}


















