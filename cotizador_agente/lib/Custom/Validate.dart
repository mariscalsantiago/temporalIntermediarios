
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

bool isNone = false;
bool isMobile = false;
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

void funcionAlerta(){
  isMobile = false;
}

void funcionAlertaNone(BuildContext context, ConnectivityResult result){
if(result== ConnectivityResult.wifi || result== ConnectivityResult.mobile){
  Navigator.pop(context);
}
}

