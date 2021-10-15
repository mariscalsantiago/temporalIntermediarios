class UsuarioPorCorreo{
  Usuario consultaUsuarioPorCorreoResponse;

  UsuarioPorCorreo({this.consultaUsuarioPorCorreoResponse});

  factory UsuarioPorCorreo.fromJson(Map<dynamic, dynamic> data){
    return UsuarioPorCorreo(
      consultaUsuarioPorCorreoResponse: data["consultaUsuarioPorCorreoResponse"] != null? Usuario.fromJson(data["consultaUsuarioPorCorreoResponse"]): Usuario.fromJson(data["detail"]),
    );
  }

  toJson() {
    return{
      'consultaUsuarioPorCorreoResponse': consultaUsuarioPorCorreoResponse,
    };
  }
}

class UsuarioError {

  String mensajeLargo;
  String codigoError;
  String sistemaOrigen;
  String mensajeTecnico;
  String mensaje;


  UsuarioError({this.mensajeLargo,this.codigoError,this.sistemaOrigen,this.mensajeTecnico,this.mensaje});

  factory UsuarioError.fromJson(Map<dynamic, dynamic> data){
    //print("UsuarioError");
    //print("data ${data}");
    Map errorMap =  data["eotException"];
    //print("UsuarioError");
    //print("errorMap ${errorMap}");
    return UsuarioError(
      mensajeLargo: errorMap["mensajeLargo"],
      codigoError: errorMap["codigoError"],
      sistemaOrigen:errorMap["sistemaOrigen"],
      mensajeTecnico: errorMap["mensajeTecnico"],
      mensaje: errorMap["mensaje"],
    );
  }

  toJson() {
    return{
      'mensajeLargo': mensajeLargo,
      'codigoError': codigoError,
      'sistemaOrigen': sistemaOrigen,
      'mensajeTecnico': mensajeTecnico,
      'mensaje': mensaje,
    };
  }

}

class Usuario {

  UsuarioUno USUARIOS;
  UsuarioError ErrorData;

  Usuario({this.USUARIOS,this.ErrorData});

  factory Usuario.fromJson(Map<dynamic, dynamic> data){
    print("Usuario");
    print("data ${data}");

    return Usuario(
      USUARIOS: data["USUARIOS"] != null ? UsuarioUno.fromJson(data["USUARIOS"]): UsuarioUno(),
      ErrorData: data["eotException"]!=null ? UsuarioError.fromJson(data) : UsuarioError(),
    );
  }

  toJson() {
    return{
      'USUARIOS': USUARIOS,
      'ErrorData':ErrorData,
    };
  }

}

class UsuarioUno{

  UsuarioDos USUARIO;

  UsuarioUno({this.USUARIO});

  factory UsuarioUno.fromJson(Map<dynamic, dynamic> data){
    return UsuarioUno(
      USUARIO:   data["USUARIO"] != null ? UsuarioDos.fromJson(data["USUARIO"]): UsuarioDos(),
    );
  }

  toJson() {
    return{
      'USUARIO': USUARIO,
    };
  }


}

class UsuarioDos{
  String apellidoPaterno;
  String usuariosWrfl;
  String numeroEmpleado;
  CorreoUsuario correosElectronicos;
  RolesUsuarioModel roles;
  String codigosIntermediarios;
  String nombre;
  String rfc;
  String apellidoMaterno;
  String perfil;
  String uid;
  String telParticular;
  String gnpPermiso;
  String migrado;
  String estatusUsuario;
  String codigoAfiliacion;
  String contactos;
  String rolesOrganizativos;
  String idParticipante;
  String telefono;
  String telCelular;

  UsuarioDos({this.apellidoPaterno, this.usuariosWrfl, this.numeroEmpleado, this.correosElectronicos, this.roles, this.codigosIntermediarios, this.nombre, this.rfc,
              this.apellidoMaterno, this.perfil, this.uid, this.telParticular, this.gnpPermiso, this.migrado, this.estatusUsuario, this.codigoAfiliacion, this.contactos,
              this.rolesOrganizativos, this.idParticipante, this.telefono, this.telCelular});

  factory UsuarioDos.fromJson(Map<dynamic, dynamic> data){
    return UsuarioDos(
        uid: data['uid'],
        apellidoPaterno: data['apellidoPaterno'],
        numeroEmpleado: data['numeroEmpleado'],
        roles: data["roles"] != null ? RolesUsuarioModel.fromJson(data["roles"]): RolesUsuarioModel(),
        codigosIntermediarios: data['codigosIntermediarios'],
        nombre: data['nombre'],
        rfc: data['rfc'],
        apellidoMaterno: data['apellidoMaterno'],
        perfil: data['perfil'],
        telParticular: data['telParticular'],
        gnpPermiso: data['gnpPermiso'],
        migrado: data['migrado'],
        estatusUsuario: data['estatusUsuario'],
        codigoAfiliacion: data['codigoAfiliacion'],
        //contactos: data['contactos'],
        rolesOrganizativos: data['rolesOrganizativos'],
        idParticipante: data['idParticipante'],
        telefono: data['telefono'],
        telCelular: data['telCelular'],
    );
  }

  toJson() {
    return{
      'apellidoPaterno': apellidoPaterno,
      'usuariosWrfl': usuariosWrfl,
      'numeroEmpleado': numeroEmpleado,
      'correosElectronicos': correosElectronicos,
      'roles': roles,
      'codigosIntermediarios': codigosIntermediarios,
      'nombre': nombre,
      'rfc': rfc,
      'apellidoMaterno': apellidoMaterno,
      'perfil':perfil,
      'uid': uid,
      'telParticular': telParticular,
      'gnpPermiso': gnpPermiso,
      'migrado': migrado,
      'estatusUsuario':estatusUsuario,
      'codigoAfiliacion': codigoAfiliacion,
      'contactos': contactos,
      'rolesOrganizativos': rolesOrganizativos,
      'idParticipante': idParticipante,
      'telefono': telefono,
      'telCelular':telCelular
    };
  }
}

class CorreoUsuario{
  String correoElectronico;

  CorreoUsuario({this.correoElectronico});

  factory CorreoUsuario.fromJson(Map<dynamic, dynamic> data){
    return CorreoUsuario(
      correoElectronico:   data["correoElectronico"],
    );
  }

  toJson() {
    return{
      'correoElectronico': correoElectronico,
    };
  }
}

class RolesUsuarioModel{
  List<dynamic> rol;

  RolesUsuarioModel({this.rol});

  factory RolesUsuarioModel.fromJson(Map<dynamic, dynamic> data){
    var list = data['rol'] as List;
    return RolesUsuarioModel(
      rol: list.length > 0 ? list : [],
    );
  }

  toJson() {
    return{
      'rol': rol,
    };
  }
}

class consultaPorCorreoNuevoServicio{
  String idParticipante;
  List<dynamic> roles;
  String estatus;
  String nombre;
  String primerApellido;
  String segundoApellido;
  String uid;
  String requestId;
  String error;
  consultaPorCorreoNuevoServicio({this.idParticipante, this.roles, this.estatus, this.nombre, this.primerApellido, this.segundoApellido, this.uid, this.requestId, this.error});

  factory consultaPorCorreoNuevoServicio.fromJson(Map<dynamic, dynamic> data){
    var list = data.containsKey('roles') ? data['roles'] : [] as List;
    return consultaPorCorreoNuevoServicio(
      idParticipante: data.containsKey('idParticipante') ? data["idParticipante"]:"",
      roles:  list.length > 0 ? list : [],
      estatus: data.containsKey('estatus') ? data["estatus"]: "",
      nombre: data.containsKey('nombre') ? data["nombre"] : "",
      primerApellido: data.containsKey('primerApellido') ? data["primerApellido"] : "",
      segundoApellido: data.containsKey('segundoApellido') ? data["segundoApellido"] : "",
      uid: data.containsKey('uid') ? data["uid"] : "",
      requestId: data.containsKey('requestId') ? data["requestId"] : "",
      error: data.containsKey('error') ? data["error"] : ""
    );
  }

  toJson() {
    return{
      'idParticipante': idParticipante,
      'estatus': estatus,
      'nombre': nombre,
      'primerApellido': primerApellido,
      'segundoApellido': segundoApellido,
      'uid': uid
    };
  }
}


