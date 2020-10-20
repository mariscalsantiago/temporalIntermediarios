
class PerfilModelos {

  final String idParticipante;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String rfc;
  final String curp;
  final String fechaNacimiento;
  final String telefono;
  final String correo;
  final String domicilio;


  const PerfilModelos({this.idParticipante, this.nombre, this.apellidoPaterno, this.apellidoMaterno, this.rfc, this.curp, this.fechaNacimiento, this.correo, this.telefono, this.domicilio});


  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'apellidoPaterno' :apellidoPaterno,
    'apellidoMaterno': apellidoMaterno,
    'telefono': telefono,
    'correo': correo,
    'rfc': rfc,
    'curp': curp,
    'fechaNacimiento': fechaNacimiento,
    'idParticipante': idParticipante,
    'domicilio': domicilio

  };
  factory PerfilModelos.fromJson(Map<String, dynamic> json) {
    return PerfilModelos(

        idParticipante: json['correo'],
        nombre: json['correo'],
        apellidoPaterno: json['correo'],
        apellidoMaterno: json['correo'],
        rfc: json['correo'],
        curp: json['correo'],
        fechaNacimiento: json['correo'],
        telefono: json['correo'],
        correo: json['correo'],
        domicilio: json['correo'],
    );
  }

}