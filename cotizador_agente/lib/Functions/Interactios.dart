import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/main_PRO.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../main.dart';
import 'Conectivity.dart';

Timer _timer;
Timer _timerLoger;
Timer _timerOther;
Timer _timerWifi;
BuildContext contextGlobal;
DateTime date3;
DateTime date1;
DateTime date2;
bool showInp = true;
bool doTimerOther = true;


/*void initializeTimer(BuildContext context,  Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();

  if(_timer!=null && _timer.isActive){
    _timer.cancel();
    _timer = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutUser(context,callback));
  }else{
    _timer = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutUser(context,callback));
  }

}*/
/*
void initializeTimerWifi(BuildContext context,  Responsive responsive, Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();
  _timerWifi = Timer.periodic(Duration(seconds: 6), (_) => validateIntenetstatus(context,responsive,callback));
}*/

void initializeTimerOtroUsuario(BuildContext context,  Function callback) {
  contextGlobal=context;
  date3 = DateTime.now();

  if(_timerOther!= null && _timerOther.isActive){

    _timerOther.cancel();
    _timerOther = Timer.periodic(Duration(seconds: 6), (_) => logOutOtherUser(context,callback));
  }
  else{
    _timerOther = Timer.periodic(Duration(seconds: 6), (_) => logOutOtherUser(context,callback));
  }
}

Future<void> logOutOtherUser(BuildContext context, Function callback) async {
  try{
  if(_timerOther.isActive){
    bool isCurrentUser=true;
    _timerOther.cancel();
    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime nowH = DateTime.now();
    //String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    String formattedDate = DateFormat('kk:mm:ss').format(now);
    String formatted = formatter.format(now);
    List<Placemark> newPlace;
    String locality="";
    String address;
    LocationPermission permission = await Geolocator.checkPermission();
    String deviceName= prefs.getString("deviceName");
    try{
      if (permission  != LocationPermission.denied && permission  != LocationPermission.deniedForever) {
        userLocation= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        newPlace = await placemarkFromCoordinates(userLocation.latitude, userLocation.longitude);
        Placemark placeMark  = newPlace[0];
        String name = placeMark.name;
        String subLocality = placeMark.subLocality;
        String locality = placeMark.locality;
        String administrativeArea = placeMark.administrativeArea;
        String postalCode = placeMark.postalCode;
        String country = placeMark.country;
        String address = "${locality}";

        // this is all you need
        //String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
      }else{
        address=" ";
      }
    }catch(e){

      initializeTimerOtroUsuario(context,  callback);
      address=" ";
      print("interactions Places interaction");
      print(e);
      switch ("$e"){
        case 'PlatformException(IO_ERROR, Error Domain=kCLErrorDomain Code=2 "(null)", null, null)':
          print("PlatformException:hasInternetFirebase");
          hasInternetFirebase = false;
          break;
        default:
          print("PlatformException:hasInternetFirebase:true");
          hasInternetFirebase = true;
         break;
      }
    }

    print("deviceID: ${deviceData["id"]}");
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {

      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);

      print("-- response -- ${response}");
      if(response!= null && response.isNotEmpty){
        if(deviceData["id"]==response["deviceID"]){
          isCurrentUser=true;
        }else{
          isCurrentUser=false;
        }
      } else{
        print("id ${deviceData["id"]}");
        Map<String, dynamic> mapa = {
          '${datosUsuario.idparticipante}': {
            'deviceID' : deviceData["id"],
            'hora':"${formattedDate}",
            'ciudad':address,
            'dispositivo':Platform.isAndroid?"Android" + " ${deviceName}":"IOS" + " ${deviceName}",
            'isActive':true,
          }
        };

        _dataBaseReference.child("bitacora").update(mapa);

      }

    });
    if(!isCurrentUser){
      _timerOther.cancel();
      customAlert(AlertDialogType.Sesionfinalizada_por_dispositivo, context, "",  "", Responsive.of(context),callback);
    }
    else{
      if(doTimerOther){
      print("logOutOtherUser reinicio timer");
      hasInternetFirebase = true;
      initializeTimerOtroUsuario(context,  callback);
      }
    }
    //customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, context, "",  "", Responsive.of(context),callback);
  }else{

    print("Timer no esta activo");
    initializeTimerOtroUsuario(context,  callback);
  }
  }catch(e){
    print("catch logout other");
    print(e);
    initializeTimerOtroUsuario(context,  callback);
  }
}


/*Future<void> ValidateWifi(BuildContext context,Responsive responsive,Function callback) async {
  if(_timerWifi.isActive){
    _timerWifi.cancel();
    validateIntenetstatus(context,responsive,callback);
    initializeTimerWifi(context,responsive,callback);
  }else{
    print("Timer no esta activo");
  }
}*/

/*
void cancelTimer(BuildContext context) {
  _timer.cancel();
  showInactividad = false;
}*/

void cancelTimers() {
  showInactividad = false;
  if(_timer!=null && _timer.isActive){
  _timer.cancel();}
  if(_timerOther!=null && _timerOther.isActive){
    //_timerOther.cancel();
  }
  if(_timerWifi!=null && _timerWifi.isActive){
    _timerWifi.cancel();}
}



/*void handleUserInteraction(BuildContext context,  callback ) {
  print("*** Inicializando el timer en handle...");
  try{
    _timer.cancel();
  }catch(e){
    print("try del cancel timer");
    print(e.toString());
  }
  //initializeTimer(context,callback);
  internetStatus (contextGlobal);
}*/
/*
void canceltimer([_]) {
  print("*** Cancelando Timer para web view...");
  _timer.cancel();
  //internetStatus (contextGlobal);
}*/



void initializeTimerBloqueo(BuildContext context,  Function callback) {
  print("*** Inizializar Timer para bloqueo ..");
  if(_timerLoger!=null && _timerLoger.isActive){
    _timerLoger.cancel();
    _timerLoger = Timer.periodic(Duration(seconds: 15), (_) => cancelTimerBloque(context, callback));
  }else{
    _timerLoger = Timer.periodic(Duration(seconds: 15), (_) => cancelTimerBloque(context, callback));
  }

}
void cancelTimerBloque(BuildContext context, Function regreso) {
  print("*** Cancelando Timer para bloqueo...");
  _timerLoger.cancel();
  Navigator.pop(context);
  callback();
}

void cancelTimerDosApps() {
  doTimerOther=false;
  print("*** Cancelando Timer para login en dos apps");
  if(_timerLoger!=null)
    _timerOther.cancel();
}