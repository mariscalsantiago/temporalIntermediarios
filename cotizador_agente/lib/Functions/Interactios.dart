import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/main_PRO.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Timer _timer;
Timer _timerOther;
Timer _timerWifi;
BuildContext contextGlobal;
bool showWebView = false;
DateTime date3;
DateTime date1;
DateTime date2;
bool showInp = true;


void initializeTimer(BuildContext context,  Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();
  if(_timer!=null && _timer.isActive){
    _timer.cancel();
    _timer = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutUser(context,callback));
  }else{
    _timer = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutUser(context,callback));
  }

}

void initializeTimerWifi(BuildContext context,  Responsive responsive, Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();
  _timerWifi = Timer.periodic(Duration(seconds: 6), (_) => validateIntenetstatus(context,responsive,callback));
}

void initializeTimerOtroUsuario(BuildContext context,  Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();
  if(_timerOther!= null && _timerOther.isActive){
    _timerOther.cancel();
    _timerOther = Timer.periodic(Duration(seconds: 10), (_) => logOutOtherUser(context,callback));
  }
  else{
    _timerOther = Timer.periodic(Duration(seconds: 10), (_) => logOutOtherUser(context,callback));
  }
}

Future<void> logOutOtherUser(BuildContext context, Function callback) async {
  if(_timerOther.isActive){
    bool isCurrentUser=true;
    _timer.cancel();
    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {

      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);

      print("-- response -- ${response}");
      if(response!= null && response.isNotEmpty){

      } else{
        print("id ${deviceData["id"]}");
        Map<String, dynamic> mapa = {
          '${datosUsuario.idparticipante}': {
            'deviceID' : deviceData["id"],
          }
        };

        _dataBaseReference.child("bitacora").update(mapa);

      }

    });
    if(!isCurrentUser){
      customAlert(AlertDialogType.Sesionfinalizada_por_dispositivo, context, "",  "", Responsive.of(context),callback);
    }
    else{
      print("logOutOtherUser reinicio timer");
      initializeTimerOtroUsuario( context,  callback);
    }
    //customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, context, "",  "", Responsive.of(context),callback);
  }else{
    print("Timer no esta activo");
  }
}

Future<void> ValidateWifi(BuildContext context,Responsive responsive,Function callback) async {
  if(_timerWifi.isActive){
    _timerWifi.cancel();
    validateIntenetstatus(context,responsive,callback);
    initializeTimerWifi(context,responsive,callback);
  }else{
    print("Timer no esta activo");
  }
}

void logOutUser(BuildContext context, Function callback) {
  if(_timer.isActive && !showInactividad){
    print("*Cerrando sesión timer activo: "+_timer.isActive.toString());
    _timer.cancel();
    print("*Cancelando timer es activo: "+_timer.isActive.toString());
    //prefs.setBool("conexion", true);
    //Navigator.popUntil(contextGlobal, ModalRoute.withName(('/login')));
    showInactividad = true;
    callback();
    customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, context, "",  "", Responsive.of(context),callback);
  }else{
    print("Timer no esta activo");
  }
}

void cancelTimer(BuildContext context) {
  _timer.cancel();
  showInactividad = false;
}

void cancelTimers() {
  showInactividad = false;
  if(_timer!=null && _timer.isActive){
  _timer.cancel();}
  if(_timerOther!=null && _timerOther.isActive){
    _timerOther.cancel();}
  if(_timerWifi!=null && _timerWifi.isActive){
    _timerWifi.cancel();}
}

void internetStatus(BuildContext context) async {

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    showWebView = true;
  } else if (connectivityResult == ConnectivityResult.mobile) {
    showWebView = true;
  } else if (connectivityResult == ConnectivityResult.none) {
    showWebView = false;
    //customAlert(AlertDialogType.errorConexion, context, "", "");
  } else {
    showWebView = false;
  }
}

void handleUserInteraction(BuildContext context,  callback ) {
  print("*** Inicializando el timer en handle...");
  try{
    _timer.cancel();
  }catch(e){
    print("try del cancel timer");
    print(e.toString());
  }
  initializeTimer(context,callback);
  internetStatus (contextGlobal);
}

void canceltimer([_]) {
  print("*** Cancelando Timer para web view...");
  _timer.cancel();
  //internetStatus (contextGlobal);
}

