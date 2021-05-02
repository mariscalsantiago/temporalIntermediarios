import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../main.dart';
import 'CustomAlert.dart';
import 'package:device_info/device_info.dart';

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
  return <String, dynamic>{
    //'version.securityPatch': build.version.securityPatch,
    //'version.sdkInt': build.version.sdkInt,
    //'version.release': build.version.release,
    //'version.previewSdkInt': build.version.previewSdkInt,
    //'version.incremental': build.version.incremental,
    //'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    //'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
   // 'host': build.host,
    'id': build.id,
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
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

