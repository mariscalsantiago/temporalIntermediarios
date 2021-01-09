
class ProspectosModelos {

  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String telefono;
  final String correo;
  final String sueldo;
  final String domicilio;
  final String calificacion;


 const
 ProspectosModelos({this.nombre, this.apellidoPaterno, this.apellidoMaterno, this.correo, this.telefono, this.sueldo, this.domicilio, this.calificacion});

 /* ProspectosModelos.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    apellidoPaterno = json['apellidoPaterno'];
    apellidoMaterno = json['apellidoMaterno'];
    telefono = json['telefono'];
    correo = json['correo'];
    sueldo = json['sueldo'];
    domicilio = json['domicilio'];
    calificacion = json['calificacion'];

  }*/

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'apellidoPaterno' :apellidoPaterno,
    'apellidoMaterno': apellidoMaterno,
    'telefono': telefono,
    'correo': correo,
    'sueldo': sueldo,
    'domicilio': domicilio,
    'calificacion': calificacion
  };
  /*{

    this.nombre = nombre;
    this.apellidoPaterno = apellidoPaterno;
    this.correo = correo;
    this.apellidoMaterno = apellidoMaterno;
    this.telefono = telefono;
    this.sueldo = sueldo;
    this.domicilio = domicilio;
    this.calificacion = calificacion;
  }



   */
}