import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/Functions/UserModel.dart';
import 'package:cotizador_agente/Functions/Validate.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database.dart';

class FirebaseAuthenticationServices {
  final FirebaseAnalytics _analytics = new FirebaseAnalytics();
  String _token;
  String _mailApp;
  DeviceInformation _deviceInformation;
  UserModel _userModel;
  DatabaseReference _databaseReference;


  DeviceInformation _getDeviceInformation() {
    String _os;
    if (Platform.isAndroid) { _os = "Android";
    } else if (Platform.isIOS) { _os = "iOS";
    }
    return DeviceInformation( os: _os, deviceToken: _token,
    );
  }

  runProcess() async {
    print('Correo de logueo: ' + datosUsuario.emaillogin + '----------------------------');
   
      _deviceInformation = _getDeviceInformation();
      _mailApp = await _getMail();
        _userModel = UserModel(
            idParticipant: datosUsuario.idparticipante,
            name: datosUsuario.givenname,
            email: datosUsuario.mail,
            emailApp: _mailApp,
            cua: datosPerfilador.intermediarios[0],
            phone: datosFisicosContacto!=null&&datosFisicosContacto.telefonoMovil!=null?datosFisicosContacto.telefonoMovil:"",
            device: _deviceInformation,
            intentos:0
        );

      writeUserNode(datosUsuario.idparticipante, _userModel);

  }

  void getIntentosUser(String email) async{
    print("getIntentosUser");
    try {
      DatabaseReference _dataBaseReference = FirebaseDatabase.instance
          .reference();
      _dataBaseReference
          .child("emailSesion")
          .onValue
          .listen((Event event) async {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(email.toUpperCase()); // dXNlcm5hbWU6cGFzc3dvcmQ=
        // String decoded = stringToBase64.decode(encoded);

        intento = event.snapshot.value!=null&&event.snapshot.value["$encoded"]!=null&&["intentos"] != null ? event.snapshot.value["$encoded"]["intentos"]:0;
        //intento = int.parse(_intento);

      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
        intento = 0;
      });
    }catch (e){
      intento = 0;
    }
  }

  Future<String> _getMail() async {
    SharedPreferences _sharePreferencesInstance =   await SharedPreferences.getInstance();
    Map sessionStartData =   await json.decode(_sharePreferencesInstance.getString('datosHuella'));
    return validateNotEmptyToString(datosUsuario.emaillogin, sessionStartData["savedMailApp"]);
  }

  // Future<FirebaseUser> _authenticateUser() async {
  /*
  Future<User> _authenticateUser() async {
    try {
      var time = new DateTime.now().millisecondsSinceEpoch;
      UserId.session_id=time.toString() + datosUsuario.idparticipante;
      print('new_id: '+ UserId.session_id);
    } catch (e){
      print(e);
    }
    var _authF = FirebaseAuth.instance;
    print(_authF.currentUser);
    if (FirebaseAuth.instance.currentUser != null) {
      print('ya tiene una sesion previa');
      print(FirebaseAuth.instance.toString());
      await FirebaseAuth.instance.signOut();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      //FirebaseUser _user;
      User _user;
      try{
        _user = (await _auth.signInWithCustomToken(loginData.jwt)).user ;
      }catch(e){
        print(e);
      }
      return _user;
    } else {
      print('no tiene una sesion previa');
      final FirebaseAuth _auth = FirebaseAuth.instance;
      //FirebaseUser _user;
      User _user;
      try{
        _user = (await _auth.signInWithCustomToken(loginData.jwt)).user ;
      }catch(e){
        print(e);
      }
      return _user;
    }

  }*/

/*  Future<String> _getFirebaseMessagingToken() async {
    final FirebaseMessaging _messaging = FirebaseMessaging();
    String _token;
    try { _token = await _messaging.getToken();
    } catch (e) { print(e);
    }
    return _token;
  }
*/
}