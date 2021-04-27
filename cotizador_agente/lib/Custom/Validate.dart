import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../main.dart';
import 'CustomAlert.dart';

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

bool isNone = false;
bool isMobile = false;
List<BiometricType> _availableBiometrics;
final LocalAuthentication auth = LocalAuthentication();

void validateIntenetstatus(BuildContext context, Responsive responsive){

  var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    print(result);

    if (result == ConnectivityResult.mobile){
      if(isNone){
      Navigator.pop(context);
      isNone = false;
      }
      if(!isMobile){
      customAlert(AlertDialogType.DatosMoviles_Activados, context, "",
          "", responsive, funcionAlerta);
      isMobile=true;
      }
    }else if(result == ConnectivityResult.none){
      if(!isNone){
      customAlert(AlertDialogType.DatosMoviles_Activados_comprueba, context, "",
          "", responsive, funcionAlertaNone);}
      isNone = true;
    }else if(result == ConnectivityResult.wifi){
      if(isNone){
        Navigator.pop(context);
        isNone = false;
      }
    }
  });
}

void validateBiometricstatus( Function callback) {
  _getAvailableBiometrics(callback);
}

Future<void> _getAvailableBiometrics(Function callback ) async {
  bool canCheckBiometrics;
  try {
    canCheckBiometrics = await auth.canCheckBiometrics;
  } on PlatformException catch (e) {
    print(e);
    callback();
  }
  List<BiometricType> availableBiometrics;
  try {
    availableBiometrics = await auth.getAvailableBiometrics();
  } on PlatformException catch (e) {
    print(e);
    callback();
  }
  if (Platform.isIOS) {
    if(availableBiometrics.contains(BiometricType.fingerprint)){
      is_available_finger = true;
    } else if(availableBiometrics.contains(BiometricType.face)){
      is_available_face = true;
    }
  } else {
    if(availableBiometrics.contains(BiometricType.fingerprint)){
      is_available_finger = true;
    }else{
      callback();
    }
  }
  print("ValidateBiometrics");
  print(is_available_finger);
  print(is_available_face);
  _availableBiometrics = availableBiometrics;
}
void funcionAlerta(){
  isMobile = false;
}

void funcionAlertaNone(BuildContext context, ConnectivityResult result){
if(result== ConnectivityResult.wifi || result== ConnectivityResult.mobile){
  Navigator.pop(context);
}
}

