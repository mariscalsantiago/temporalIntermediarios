import 'dart:io';
import 'dart:math';
import 'package:cotizador_agente/Functions/Conectivity.dart';
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
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
List<BiometricType> _availableBiometrics;
final LocalAuthentication auth = LocalAuthentication();


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

Future<void> validateIntenetstatus(BuildContext context, Responsive responsive,Function callback) async {
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
        customAlert(AlertDialogType.DatosMoviles_Activados_comprueba, context, "", "", responsive, funcionAlertaNone);
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
          customAlert(
              AlertDialogType.DatosMoviles_Activados_comprueba, context, "", "",
              responsive, funcionAlertaNone);
        }

        print("validateIntenetstatus:none: $isNone $isMobile ");
        callback();
      }
    });

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

      if(canCheckBiometrics){
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt("localAuthCountIOS", 0);

        List<BiometricType> availableBiometrics;
        try {
          availableBiometrics = await auth.getAvailableBiometrics();
          print("availableBiometrics: $availableBiometrics");

          if(availableBiometrics != null){
            if (Platform.isIOS) {
              if(availableBiometrics.contains(BiometricType.fingerprint)){
                is_available_finger = true;
              } else if(availableBiometrics.contains(BiometricType.face)){
                is_available_face = true;
              }
            } else {
              if(availableBiometrics.contains(BiometricType.fingerprint)){
                  is_available_finger = true;
              }
              // bloque o e alertas
             /* if(availableBiometrics.contains(BiometricType.face)){
                  is_available_face = true;
              }*/
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

