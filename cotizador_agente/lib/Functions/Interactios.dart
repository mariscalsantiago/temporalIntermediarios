import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Timer _timer;
SharedPreferences prefs;
BuildContext contextGlobal;
bool showWebView = false;
DateTime date3;
DateTime date1;
DateTime date2;
bool showInp = true;


void initializeTimer(BuildContext context) {
  contextGlobal=context;
  date3 = DateTime.now();
  _timer = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutUser(context));
}

void logOutUser(BuildContext context) {
  if(_timer.isActive){
    print("*Cerrando sesión timer activo: "+_timer.isActive.toString());
    _timer.cancel();
    print("*Cancelando timer es activo: "+_timer.isActive.toString());
    prefs.setBool("conexion", true);
    Navigator.popUntil(context, ModalRoute.withName(('/login')));
  }else{
    print("Timer no esta activo");
  }
}

void cancelTimer(BuildContext context) {
  _timer.cancel();
}

void internetStatus(BuildContext context) async {

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    showWebView = true;
  } else if (connectivityResult == ConnectivityResult.mobile) {
    showWebView = true;
  } else if (connectivityResult == ConnectivityResult.none) {
    showWebView = false;
    customAlert(AlertDialogType.errorConexion, context, "", "");
  } else {
    showWebView = false;
  }
}

void handleUserInteraction([_]) {
  print("*** Inicializando el timer en handle...");
  try{
    _timer.cancel();
  }catch(e){
    print("try del cancel timer");
    print(e.toString());
  }
  initializeTimer(contextGlobal);
  internetStatus (contextGlobal);
}

void canceltimer([_]) {
  print("*** Cancelando Timer para web view...");
  _timer.cancel();
  //internetStatus (contextGlobal);
}
