import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';

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

void validateIntenetstatus(BuildContext context, Responsive responsive){
  var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if(result == ConnectivityResult.none){
      customAlert(AlertDialogType.DatosMoviles_Activados_comprueba, context, "",
          "", responsive, funcionAlerta);
    }
  });
}

void funcionAlerta(){

}

