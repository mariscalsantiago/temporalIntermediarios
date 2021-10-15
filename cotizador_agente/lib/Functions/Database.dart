
import 'dart:convert';

import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

void writeUserNode(String user,dynamic data) async {
  try {
    await _databaseReference.reference().child("users").update({'$user': data});
  }
  catch (e){
    print("Error Database: $e");
  }
}
  
void writeUserIntentos(String email,int intentos) async {
  try {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(email.toUpperCase());

    await _databaseReference.reference().child("emailSesion/$encoded").update({'intentos': intentos});
  }
  catch (e){
    print("Error Database: $e");
  }
}

void saveSesionUsuario()async {
  print("== saveSesionUsuario ==");

  try{
    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(datosUsuario.emaillogin.toUpperCase());

    Map<String, dynamic> mapa = {
      '$encoded': {
        'intentos': intento,
      }
    };
    print("mapa $mapa");
    _dataBaseReference.child("emailSesion").update(mapa);
  }catch(e){
    print("== saveDiviceIDFirebase catch ==");
    print(e);
  }


  //});
}
