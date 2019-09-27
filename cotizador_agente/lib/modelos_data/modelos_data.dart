


class modelos_data{


  String nombre;
  String apellido;
  int cp;
  dynamic edad;


  Map<String,dynamic> get map {
    return {
      "nombre": nombre,
      "apellido": apellido,
      "cp":cp,
      "edad": edad,
    };
  }

  modelos_data({this.nombre,this.apellido,this.cp,this.edad,});

}