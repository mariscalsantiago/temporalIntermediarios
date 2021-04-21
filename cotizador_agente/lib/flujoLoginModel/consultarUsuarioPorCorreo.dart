class UsuarioPorCorreo{
  Usuario consultaUsuarioPorCorreoResponse;

  UsuarioPorCorreo({this.consultaUsuarioPorCorreoResponse});

  factory UsuarioPorCorreo.fromJson(Map<dynamic, dynamic> data){
    return UsuarioPorCorreo(
      consultaUsuarioPorCorreoResponse: data["consultaUsuarioPorCorreoResponse"] != null ? Usuario.fromJson(data["consultaUsuarioPorCorreoResponse"]): Usuario(),
    );
  }

  toJson() {
    return{
      'consultaUsuarioPorCorreoResponse': consultaUsuarioPorCorreoResponse,
    };
  }
}

class Usuario {

  UsuarioUno USUARIOS;

  Usuario({this.USUARIOS});

  factory Usuario.fromJson(Map<dynamic, dynamic> data){
    return Usuario(
      USUARIOS: data["USUARIOS"] != null ? UsuarioUno.fromJson(data["USUARIOS"]): UsuarioUno(),
    );
  }

  toJson() {
    return{
      'USUARIOS': USUARIOS,
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
        contactos: data['contactos'],
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
  List<String> rol;

  RolesUsuarioModel({this.rol});

  factory RolesUsuarioModel.fromJson(Map<dynamic, dynamic> data){
    var list = data['rol'] as List;
    return RolesUsuarioModel(
      rol: list,
    );
  }

  toJson() {
    return{
      'rol': rol,
    };
  }
}