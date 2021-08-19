import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'CustomAlert.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Timer _timerMessageWife;


String validateNotEmptyToString(dynamic data, String defaultData){
  data=data!=null?data.toString():defaultData;
  return data;
}

bool validateNotEmptyBool(bool variable){
  if(variable==null){
    variable=false;
  }
  return variable;
}

bool validateNotEmptyBoolFromDynamic(dynamic variable){
  if(variable==null){
    variable=false;
  }
  return variable;
}

bool validateNotEmptyBoolWhitDefault(dynamic _data, bool _default ){
  if(_data==null||_data.runtimeType!=bool){
    _data=false;
  }
  return _data;
}

Future<bool> validatePinig() async {
  print("validatePinig");
  try {
    final _result = await http.get("https://google.com").timeout(Duration(seconds: 5));
    //final result = await InternetAddress.lookup('google.com');
    print(_result.bodyBytes);
    print(_result.statusCode);
    if (_result != null && _result.statusCode == 200) {
      print('connected');
      return true;
    }
    else{
      print('not connected');
      return false;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}



Future<bool> validateProxyFirebase() async {
  print("validatePinig");
  try {
    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    await _dataBaseReference.child("timer").once().then((DataSnapshot _snapshot) {
      print("validatePinig: ${_snapshot.value}");
      print('connected');
    });
    return true;
    } on SocketException catch (_) {
    print('not connected validateProxyFirebase');
    return false;
  }
}
Future<bool> validateProxy() async {
  print("validatePinig");
  try {
    final _result = await http.get("https://gnp.com.mx").timeout(Duration(seconds: 5));
    //final result = await InternetAddress.lookup('google.com');
    print(_result.body);
    print(_result.statusCode);
    if (_result != null && _result.statusCode == 200) {
      print('connected');
      return true;
    }
    else{
      print('not connected');
      return false;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}

bool isNone = false;
bool isMobile = false;
bool isWifi = false;
bool isMessageMobile = false;
bool isMessageWifi = false;
bool isMessageMobileClose = true;


List<BiometricType> _availableBiometrics;
final LocalAuthentication auth = LocalAuthentication();

/*
void countdown(){
  int _start = widget.timerTastoPremuto.inMilliseconds;

  const oneDecimal = const Duration(milliseconds: 100);
  Timer _timer = new Timer.periodic(
      oneDecimal,
          (Timer timer) =>
          setState(() {
            if (_start < 100) {
              _timer.cancel();
            } else {
              _start = _start - 100;
            }
          }));

}*/

Future<File> urlToFile(String imageUrl) async {
  File file;
  print("urlToFile:  $imageUrl");

  if(imageUrl!=null&&imageUrl!="") {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(imageUrl);
    print("urlToFile: response");
    file.writeAsBytes(response.bodyBytes);
  }
  return file;
}

Future<void> validateIntenetstatus(BuildContext context, Responsive responsive,Function callback, bool origen) async {
  print("msjCx: validateIntenetstatus $origen ");

  ConnectivityStatus connectivityInitial = await ConnectivityServices().isInternet();
  isWifi = connectivityInitial.type.toString() == "ConnectionType.wifi"? true:false;
  isMobile = connectivityInitial.type.toString() == "ConnectionType.mobile"? true:false;

  if(origen){
    hasInternetFirebase = connectivityInitial.available;
  }

  print("msjCx: connectivityInitial: ${connectivityInitial.type} ${connectivityInitial.available} hasConnection $hasInternetFirebase");
  print("msjCx: connectivityInitial: $isWifi $isMobile $isMessageMobile $isMessageWifi");

  if(isWifi) {
    print("msjCx: con wifi");

      print("msjCx: con wifi con tranferencia");
    if (connectivityInitial.available || hasInternetFirebase) {
      if(isMessageWifi) {
        if(dialogConnectivityContext!=null) {
          isMessageWifi = false;
          Navigator.pop(navigatorKey.currentState.overlay.context);
        }
      }
      if(isMessageMobile){
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(navigatorKey.currentState.overlay.context);
        }
      }
      if(screenName!=null) {
        if ("$screenName" == "CotizadorAutos") {
          callback();
        }
      }
    }else{
      print("msjCx: con wifi sin tranferencia");
      if(!isMobile){
        if (!isMessageWifi) {
          isMessageWifi = true;
          customAlert(AlertDialogType.Sin_acceso_wifi, navigatorKey.currentState.overlay.context, "", "", responsive, funcionAlertaWifi);
        }
      }

    }

  }else if(!isWifi&&isMobile) {
    print("msjCx: con mobile");

    if (connectivityInitial.available || hasInternetFirebase) {
      print("msjCx: con mobile con transferencia");
      if(isMessageWifi) {
        if(dialogConnectivityContext!=null) {
          isMessageWifi = false;
          Navigator.pop(navigatorKey.currentState.overlay.context);
        }
      }
      if(!isMessageMobile){
        if(isMessageMobileClose||origen){
          isMessageMobile = true;
          customAlert(AlertDialogType.DatosMoviles_Activados, navigatorKey.currentState.overlay.context, "", "", responsive, funcionAlertaMobile);
        }
      }
    }else{
      print("msjCx: con mobile sin transferencia");

      if(isMessageMobile){
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(dialogMobileContext);
        }
      }
      if (!isMessageWifi) {
        isMessageWifi = true;
        customAlert(AlertDialogType.Sin_acceso_wifi, navigatorKey.currentState.overlay.context, "", "", responsive, funcionAlertaWifi);
      }
    }
  }else if(!isWifi&&!isMobile&&!connectivityInitial.available) {
    print("msjCx: con none");

      if (isMessageMobile) {
        if (dialogMobileContext != null) {
          isMessageMobile = false;
          Navigator.pop(navigatorKey.currentState.overlay.context);
        }
      }
      if (!isMessageWifi) {
        isMessageWifi = true;
        customAlert(AlertDialogType.Sin_acceso_wifi, navigatorKey.currentState.overlay.context, "", "", responsive, funcionAlertaWifi);
      }
  }


}











/*
     if(!isWifi&&!isMobile&&!connectivityInitial.available) {
       print("msjCx: sin moviles, sin wifi, sin transferencia");
       if (!isMessageWifi) {//No existe el mesaje desplegado
         isMessageWifi = true;
         customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
       }

     }else if(isWifi&&connectivityInitial.available){
       print("msjCx: con wifi, con tranferencia");
       //con wifi, con tranferencia
       if(isMessageWifi) { //existe el mesaje sin conexion
         if(dialogConnectivityContext!=null) {
           isMessageWifi = false;
           Navigator.pop(dialogConnectivityContext);
           dialogConnectivityContext = null;
         }
       }
     }else if(isWifi&&!connectivityInitial.available){
       print("msjCx: con wifi, sin tranferencia");
       //con wifi, sin tranferencia
       if(!isMobile) {
         if (!isMessageWifi) {
           isMessageWifi = true;
           customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
         }
       }
     }else if(!isWifi&&isMobile&&connectivityInitial.available){
       if(!isMobile) {
         if (!isMessageWifi) {
           isMessageWifi = true;
           customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
         }
       }

     }else if(!isWifi&&isMobile&&!connectivityInitial.available){

       if(!isMobile) {
         if (!isMessageWifi) {
           isMessageWifi = true;
           customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
         }
       }
     }

  print("msjCx: validateIntenetstatus:previo Listener  $isWifi $isMobile $isMessageMobile $isMessageWifi");


  connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    print("msjCx: validateIntenetstatus:connectivitySubscription");

    ConnectivityStatus connectivityListener = await ConnectivityServices().getConnectivityStatus(false);
    isWifi = connectivityListener.type.toString() == "ConnectionType.wifi"? true:false;
    isMobile = connectivityListener.type.toString() == "ConnectionType.mobile"? true:false;

    print("msjCx: connectivityListener: ${connectivityListener.type} ${connectivityListener.available}");
    print("msjCx: onConnectivityChanged:  $isWifi $isMobile $isMessageMobile $isMessageWifi  $result");

    if(isWifi && connectivityListener.available){
      print("msjCx: wifi con transferencia");
      //wifi con transferencia
      print("msjCx: onConnectivityChanged:wifi  $isWifi $isMobile $isMessageMobile $isMessageWifi $result");

      if(isMessageMobile){
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(dialogMobileContext);
          dialogMobileContext = null;
        }
      }
      if(isMessageWifi){
        if(dialogConnectivityContext!=null){
          isMessageWifi = false;
          Navigator.pop(dialogConnectivityContext);
          dialogConnectivityContext = null;
        }
      }
      print("msjCx: onConnectivityChanged:wifi:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");
    }else if(isWifi && !connectivityListener.available){
      //wifi sin transferencia
      print("msjCx: wifi sin transferencia");
      print("msjCx: onConnectivityChanged:wifi  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if(isMobile){
        if(!isMessageMobile){
          isMessageMobile = true;
          customAlert(AlertDialogType.DatosMoviles_Activados, context, "", "", responsive, funcionAlertaMobile);

        }
      }else{
        if (!isMessageWifi) {
          isMessageWifi = true;
          customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
        }
      }
      print("msjCx: onConnectivityChanged:wifi:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    }else if(!isWifi&&isMobile && connectivityListener.available){
      //sin wifi con datos y transferencia
      print("msjCx: sin wifi con datos y transferencia");
      print("msjCx: onConnectivityChanged:mobile:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if(isMessageWifi){
        if(dialogConnectivityContext!=null){
          isMessageWifi = false;
          Navigator.pop(dialogConnectivityContext);
          dialogConnectivityContext = null;
        }
      }
      if(!isMessageMobile){
        isMessageMobile = true;
        customAlert(AlertDialogType.DatosMoviles_Activados, context, "", "", responsive, funcionAlertaMobile);
      }
      print("msjCx: onConnectivityChanged:mobile:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");
    }else if(!isWifi&&isMobile && !connectivityListener.available){
      //sin wifi con datos y sin transferencia
      print("msjCx: sin wifi con datos y sin transferencia");
      print("onConnectivityChanged:mobile:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if (isMessageMobile) {
        print("isMessageMobile:");
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(dialogMobileContext);
          dialogMobileContext = null;
        }
      }

      if (!isMessageWifi) {
        print("isMessageWifi:");
        isMessageWifi = true;
        customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
      }


    }else if(!isWifi && !isMobile && !connectivityListener.available){
      print("msjCx: sin wifi, sin datos y sin transferencia");
      print("msjCx: onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

        if (isMessageMobile) {
          if(dialogMobileContext!=null){
            isMessageMobile = false;
            Navigator.pop(dialogMobileContext);
            dialogMobileContext = null;
          }
        }
        if (!isMessageWifi) {
          isMessageWifi = true;
          customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
        }

      //initialMessageWife(context, responsive, callback);
      print("onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");
    }
  });*/



Future<void> validateIntenetBackgroundClosestatus(BuildContext context, Responsive responsive,Function callback) async {

  print("validateIntenetBackgroundClosestatus: $isWifi $isMobile $isMessageMobile $isMessageWifi");
  //connectivitySubscription.cancel();

    if(isMessageWifi) {
      if(dialogConnectivityContext!=null) {
        isMessageWifi = false;
        Navigator.pop(dialogConnectivityContext);
      }
    }
    if(isMessageMobile){
      if(dialogMobileContext!=null) {
        isMessageMobile = false;
        Navigator.pop(dialogMobileContext);
      }
    }

}

Future<void> validateIntenetBackgroundstatus(BuildContext context, Responsive responsive,Function callback) async {
  print("validateIntenetBackgroundstatus:Initial");
  ConnectivityStatus connectivityBackground = await ConnectivityServices().getConnectivityStatus(false);
  isWifi = connectivityBackground.type.toString() == "ConnectionType.wifi"? true:false;
  isMobile = connectivityBackground.type.toString() == "ConnectionType.mobile"? true:false;

  print("msjCx: connectivityBackground: ${connectivityBackground.type} ${connectivityBackground.available}");

  if(isWifi && connectivityBackground.available){
    print("msjCx: wifi con transferencia");
    //wifi con transferencia
    print("msjCx: connectivityBackground:wifi  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    if(isMessageMobile){
      if(dialogMobileContext!=null){
        isMessageMobile = false;
        Navigator.pop(dialogMobileContext);
        // dialogMobileContext = null;
      }
    }
    if(isMessageWifi){
      if(dialogConnectivityContext!=null){
        isMessageWifi = false;
        Navigator.pop(dialogConnectivityContext);
      }
    }
    print("msjCx: connectivityBackground:wifi:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");
  }else if(isWifi && !connectivityBackground.available){
    //wifi sin transferencia
    print("msjCx: wifi sin transferencia");
    print("msjCx: connectivityBackground:wifi  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    if(isMobile){
      if(!isMessageMobile){
        isMessageMobile = true;
        customAlert(AlertDialogType.DatosMoviles_Activados, context, "", "", responsive, funcionAlertaMobile);
      }
    }else{
      if (!isMessageWifi) {
        isMessageWifi = true;
        customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
      }
    }
    print("msjCx: connectivityBackground:wifi:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");

  }else if(!isWifi&&isMobile && connectivityBackground.available){
    //sin wifi con datos y transferencia
    print("msjCx: sin wifi con datos y transferencia");
    print("msjCx: onConnectivityChanged:mobile:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    if(isMessageWifi){
      if(dialogConnectivityContext!=null){
        isMessageWifi = false;
        Navigator.pop(dialogConnectivityContext);
        //dialogConnectivityContext = null;
      }
    }
    if(!isMessageMobile){
      isMessageMobile = true;
      customAlert(AlertDialogType.DatosMoviles_Activados, context, "", "", responsive, funcionAlertaMobile);
    }
    print("msjCx: onConnectivityChanged:mobile:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");
  }else if(!isWifi&&isMobile && !connectivityBackground.available){
    //sin wifi con datos y sin transferencia
    print("msjCx: sin wifi con datos y sin transferencia");
    print("onConnectivityChanged:mobile:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    if (isMessageMobile) {
      print("isMessageMobile:");
      if(dialogMobileContext!=null){
        isMessageMobile = false;
        Navigator.pop(dialogMobileContext);
        //dialogMobileContext = null;
      }
    }

    if (!isMessageWifi) {
      print("isMessageWifi:");
      isMessageWifi = true;
      customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaWifi);
    }


  }else if(!isWifi && !isMobile && !connectivityBackground.available) {
    print("msjCx: sin wifi, sin datos y sin transferencia");
    print(
        "msjCx: onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    if (isMessageMobile) {
      if (dialogMobileContext != null) {
        isMessageMobile = false;
        Navigator.pop(dialogMobileContext);

        //dialogMobileContext = null;
      }
    }
    if (!isMessageWifi) {
      isMessageWifi = true;
      customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive,
          funcionAlertaWifi);
    }

    //initialMessageWife(context, responsive, callback);
    print("onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");
  }

  //validateIntenetstatus(context, responsive,callback);
  print("validateIntenetBackgroundstatus:end $isWifi $isMobile $isMessageMobile $isMessageWifi");
}


initialMessageWife(BuildContext context, Responsive responsive,Function callback) {
  print("_timerMessageWife");
  if (_timerMessageWife != null && _timerMessageWife.isActive) {
    _timerMessageWife.cancel();
    _timerMessageWife = Timer.periodic(Duration(seconds: 3), (_) => MessageWifeClose(context,responsive,callback));
  } else {
    _timerMessageWife = Timer.periodic(Duration(seconds: 3), (_) => MessageWifeClose(context,responsive, callback));
  }
}

cancelMessageWife() {
  print("_timerMessageWife:Cancel");
  if (_timerMessageWife != null && _timerMessageWife.isActive)
    _timerMessageWife.cancel();
}

MessageWifeClose(BuildContext context,Responsive responsive, Function callback) async {
  print("MessageWifeClose");
  if (_timerMessageWife != null && _timerMessageWife.isActive){
    _timerMessageWife.cancel();
    ConnectivityStatus connectivity = await ConnectivityServices().getConnectivityStatus(false);
    print("MessageWifeClose:connectivity: $connectivity");
    isWifi = connectivity.type.toString() == "ConnectionType.wifi" ? true : false;
    isMobile = connectivity.type.toString() == "ConnectionType.mobile" ? true : false;

    if(isWifi){
      print("onConnectivityChanged:wifi  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if(isMessageMobile){
        print("isMessageMobile");
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(dialogMobileContext);
          //dialogMobileContext = null;
        }

      }
      if(isMessageWifi){
        print("isMessageWifi:");
        if(dialogConnectivityContext!=null){
          isMessageWifi = false;
          Navigator.pop(dialogConnectivityContext);
          //dialogConnectivityContext = null;
        }
      }
      print("onConnectivityChanged:wifi:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");
    }else if(!isWifi&&isMobile){
      print("onConnectivityChanged:mobile:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if(isMessageWifi){
        print("isMessageWifi:");
        if(dialogConnectivityContext!=null){
          isMessageWifi = false;
          Navigator.pop(dialogConnectivityContext);

          //dialogConnectivityContext = null;

        }
      }

     // initialMessageWife(context, responsive,callback);

      print("onConnectivityChanged:mobile:next  $isWifi $isMobile $isMessageMobile $isMessageWifi");

    }else if(!isWifi&&!isMobile){
      print("onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");

      if (isMessageMobile) {
        print("isMessageMobile:");
        if(dialogMobileContext!=null){
          isMessageMobile = false;
          Navigator.pop(dialogMobileContext);

         // dialogMobileContext = null;
        }
      }

      
     // initialMessageWife(context, responsive,callback);
      print("onConnectivityChanged:none:  $isWifi $isMobile $isMessageMobile $isMessageWifi");
    }
  }
}

Future<void> validateIntenetstatuss(BuildContext context, Responsive responsive,Function callback) async {
 print("init:validateIntenetstatus");
  isNone = false;
  isMobile = false;
  callback();
  if((await ConnectivityServices().getConnectivityStatus(false)).available) {
    print("available");
      if(isMobile) {
        print("available:mobil");
        isMobile = false;
        Navigator.pop(context);
      }
    } else {
    print("available:else");
    if(!isNone) {
      print("available:isNone");
        sendTag("appinter_msg_wifi");
        showInactividad = true;
        isNone = true;
        customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaNone);
      }
    }
 print("init:validateIntenetstatus $isNone $isMobile");


 Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi) {
        print("validateIntenetstatus:wifi");
        if (isNone) {
          Navigator.pop(context);
          isNone = false;
          showInactividad = false;
        }
        if (isMobile) {
          Navigator.pop(context);
          isMobile = false;
        }

        callback();
        print("validateIntenetstatus:wifi:next: $isNone $isMobile ");
      } else if (result == ConnectivityResult.mobile) {
        print("validateIntenetstatus:mobile");

        if(isNone) {
          Navigator.pop(context);
          isNone = false;
        }
        if (!isMobile) {
          customAlert(AlertDialogType.DatosMoviles_Activados, context, "", "", responsive, funcionAlerta);
          isMobile = true;
        }
        print("validateIntenetstatus:mobile:next: $isNone $isMobile ");

        callback();
      } else if (result == ConnectivityResult.none) {
        print("validateIntenetstatus:none");

        if (!isNone) {
          //TODO validar Dali
          if (isMobile) {
            isMobile = false;
            Navigator.pop(context);
          }
          sendTag("appinter_msg_wifi");
          showInactividad = true;
          isNone = true;
          customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlertaNone);
        }

        print("validateIntenetstatus:none: $isNone $isMobile ");
        callback();
      }
    });

}

Future<bool> validSystemDevice()async{
  bool _isactiveBiometric = true;
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    print("release $release");
    if(release=="8")
      _isactiveBiometric = false;
  }
  return _isactiveBiometric;
}

void validateBiometricstatus( Function callback) {
  _getAvailableBiometrics(callback);
}

Future<void> _getAvailableBiometrics(Function callback) async {
  bool canCheckBiometrics;
  final LocalAuthentication auth = LocalAuthentication();
  print("_getAvailableBiometrics");


    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print("canCheckBiometrics: $canCheckBiometrics");
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt("localAuthCountIOS", 0);

      if(canCheckBiometrics){



        try {
          _availableBiometrics = await auth.getAvailableBiometrics();
          print("availableBiometrics: $_availableBiometrics");

          if(_availableBiometrics != null){
            if (Platform.isIOS) {
              if(_availableBiometrics.contains(BiometricType.fingerprint)){
                is_available_finger = true;
              } else if(_availableBiometrics.contains(BiometricType.face)){
                is_available_face = true;
              }
            } else {
              if(_availableBiometrics.contains(BiometricType.fingerprint)){
                  is_available_finger = true;
              }
              // bloque o e alertas
             if(_availableBiometrics.contains(BiometricType.face)){
                  is_available_face = true;
              }
            }
          }else{
            is_available_finger = false;
            is_available_face = false;
          }
        } on PlatformException catch (e) {
          is_available_finger = false;
          is_available_face = false;

          print(e);
          callback();
        }
      } else{

        is_available_finger = is_available_finger;
        is_available_face = is_available_face;

      }
    } on PlatformException catch (e) {
      is_available_finger = false;
      is_available_face = false;

      print(e);
      callback();
    }


  print("---ValidateBiometrics--");
  print(is_available_finger);
  print(is_available_face);
}

void callback(){

}

void funcionAlerta(){
 // isMobile = false;
}

funcionAlertaMobile(){
  isMessageMobile = false;
}
funcionAlertaWifi(){

}

void funcionAlertaNone(BuildContext context, ConnectivityResult result){
if(result== ConnectivityResult.wifi || result== ConnectivityResult.mobile){
  Navigator.pop(context);
}
}

Future<void> initPlatformState(Function callback) async {
  Map<String, dynamic> deviceDato;

  try {
    if (Platform.isAndroid) {
      deviceDato = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceDato = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } on PlatformException {
    deviceDato = <String, dynamic>{
      'Error:': 'Failed to get platform version.'
    };
  }
  deviceData = deviceDato;
  callback(deviceDato);
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  prefs.setString("deviceName",build.device);
  return <String, dynamic>{
    //'version.securityPatch': build.version.securityPatch,
    //'version.sdkInt': build.version.sdkInt,
    //'version.release': build.version.release,
    //'version.previewSdkInt': build.version.previewSdkInt,
    //'version.incremental': build.version.incremental,
    //'version.codename': build.version.codename,
    'version.biometrics': _availableBiometrics,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    //'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
   // 'host': build.host,
    'id': build.androidId,
    //'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    //'supported32BitAbis': build.supported32BitAbis,
    //'supported64BitAbis': build.supported64BitAbis,
    //'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  prefs.setString("deviceName",data.model);
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'id': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

