import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';
import 'package:cotizador_agente/modelos/LoginModels.dart';
//import 'package:agentesgnp/PagoMovil/constants.dart';
//import 'MobilePayServiceDictionary.dart';
import 'Validate.dart';

DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
String nodePayRecipeToCoexistence;
String causeError;
/*
void writeMobilePaymentGeneric(dynamic data) async {
  try {
    if( data["response"].toString()!=""){
      print("Register Binacle");
      print(data);
      String stringBody=data["body"];
      String policyNumber=stringBody.substring(stringBody.indexOf("poliza: ")+"poliza: ".length,stringBody.indexOf(",",stringBody.indexOf("poliza: ")));
      String nodeName = "${DateTime.now().toString()} ${datosUsuario.idparticipante } $policyNumber";
      String yearMonthNode=DateTime.now().toString().substring(0,7);
      nodeName = nodeName.replaceAll(".", "-");
      nodeName = nodeName.replaceAll(":", "-");
      String endPoint = data["liquidateCoEndpoint"];
      String child;
      String stringResponse;
      String error = data["response"];
      String description;
      if(error.startsWith("{")&&error.endsWith("}")){
        stringResponse=json.decode(data["response"]).toString();
        error=stringResponse.substring(stringResponse.indexOf("codError: ")+"codError: ".length,stringResponse.indexOf(",",stringResponse.indexOf("codError: ")));
        causeError="user";
      }else{
        error=data["response"] ;
        stringResponse=error;
        causeError="service";
      }
      if(endPoint=="${config.serviceEndPoint}${Services_PagoMovil.gPay}"){
        print("Pay Service");
        print("$error");
        description = getErrorDescription(error);
        if(error=="0"||error=="-1") {
          child = "LogsApp/PagoMovil/Bitacora/Succes/$yearMonthNode/$nodeName";
          nodePayRecipeToCoexistence=("$child/Coexistence");
        }else{
          print("Not Succes");
          if(causeError=="user"){
            child = "LogsApp/PagoMovil/Bitacora/Failed/User/$yearMonthNode/$nodeName";
          }else{
            child = "LogsApp/PagoMovil/Bitacora/Failed/Service/$yearMonthNode/$nodeName";
          }
        }
      }else if(endPoint=="${config.serviceEndPoint}${Services_PagoMovil.payConvivencia}"){
        print("Pay Coexistence Service");
        child=nodePayRecipeToCoexistence;
      }
      _databaseReference.child("LogsApp/WriteLogs").once().then((DataSnapshot snapshot) async {
        bool _show = snapshot.value;
        if(_show){
          _databaseReference.child("LogsApp/PagoMovil/WriteLogs").once().then((DataSnapshot snapshot) async {
            bool _show = snapshot.value;
            if(_show){
              print("Witing on firebase binacle");
              await _databaseReference.reference().child("$child").update({'Service':'$endPoint'});
              await _databaseReference.reference().child("$child").update({'Response':'$stringResponse'});
              description!= null ? await _databaseReference.reference().child("$child").update({'Description':'$description'}):Future.value(false);
            }
          });
        }
      });
    }
    else{
      print("No conection");
    }
  }
  catch (e){
    print("Error Database: $e");
  }
}

void writeOnlinePaymentGeneric(dynamic data) async {
  try {
    if( data["response"].toString()!=""){
      print("Register Binacle");
      print(data);
      String stringBody=data["body"];
      String policyNumber=stringBody.substring(stringBody.indexOf("poliza: ")+"poliza: ".length,stringBody.indexOf(",",stringBody.indexOf("poliza: ")));
      String nodeName = "${DateTime.now().toString()} ${datosUsuario.idparticipante } $policyNumber";
      String yearMonthNode=DateTime.now().toString().substring(0,7);
      nodeName = nodeName.replaceAll(".", "-");
      nodeName = nodeName.replaceAll(":", "-");
      String endPoint = data["liquidateCoEndpoint"];
      String child;
      String stringResponse;
      String error = data["errorCode"];
      print("response_liquidateEndpoint: $error");
      String description;
      try{
        stringResponse=data["response"];
      }
      catch(ex){
        print("Error en response: $ex");
      }
        if(error.startsWith("{")&&error.endsWith("}")){
          error=stringResponse.substring(stringResponse.indexOf("codError: ")+"codError: ".length, stringResponse.indexOf(",",stringResponse.indexOf("codError: ")));
          causeError="user";
        }else{
          error=data["errorCode"] ;
          //stringResponse=error;
          causeError="service";
        }

      if(endPoint== "${config.serviceEndPoint}ejecutarPago"){ //"http://10.67.84.12:80/AppCobros/rest/ejecutarPago"){
        print("Pay Service");
        print("$error");
        description = getErrorDescription(error);
        if(error=="0"||error=="-1") {
          child = "LogsApp/PagoEnLinea/Bitacora/Succes/$yearMonthNode/$nodeName";
          nodePayRecipeToCoexistence=("$child/Coexistence");
        }else{
          print("Not Succes");
          if(causeError=="user"){
            child = "LogsApp/PagoEnLinea/Bitacora/Failed/User/$yearMonthNode/$nodeName";
          }else{
            child = "LogsApp/PagoEnLinea/Bitacora/Failed/Service/$yearMonthNode/$nodeName";
          }
        }
      }else if(endPoint=="${config.serviceEndPoint}ejecutarLiquidacionConvivencia/ejecutaPago"){
        print("Pay Coexistence Service");
        child=nodePayRecipeToCoexistence;
      }
      _databaseReference.child("LogsApp/WriteLogs").once().then((DataSnapshot snapshot) async {
        bool _show = snapshot.value;
        if(_show){
          _databaseReference.child("LogsApp/PagoEnLinea/WriteLogs").once().then((DataSnapshot snapshot) async {
            bool _show = snapshot.value;
            if(_show){
              print("Witing on firebase binacle");
              print("$child");
              await _databaseReference.reference().child("$child").update({'Service':'$endPoint'});
              await _databaseReference.reference().child("$child").update({'Response':'$stringResponse'});
              description!= null ? await _databaseReference.reference().child("$child").update({'Description':'$description'}):Future.value(false);
            }
          });
        }
      });
    }
    else{
      print("No conection");
    }
  }
  catch (e){
    print("Error Database: $e");
  }
}*/

void writeLoginBinnacle(String userData, String service, LogErrorType errorType, String details) async {
  const String _nodeLogs = "LogsApp";
  const String _nodeSectionLog = "Login";
  const String _service = "Service";
  const String _user = "User";
  String _errorType = errorType==LogErrorType.userError?_user:_service;
  const String _binnacle = "Bitacora";
  const String _failed = "Failed";
  const String _writeLogs = "WriteLogs";
  String _dateTime = DateTime.now().toString();
  String yearMonthNode=_dateTime.substring(0,7);
  String nodeName = "$_dateTime";
  nodeName = nodeName.replaceAll(".", "-");
  nodeName = nodeName.replaceAll(":", "-");
  String _child = "$_nodeLogs/$_nodeSectionLog/$_binnacle/$_failed/$_errorType/$yearMonthNode/$nodeName";
  _databaseReference.child("$_nodeLogs/$_writeLogs").once().then((DataSnapshot _snapshot) async {
    if(validateNotEmptyBoolWhitDefault(_snapshot.value,false)){
      _databaseReference.child("$_nodeLogs/$_nodeSectionLog/$_writeLogs").once().then((DataSnapshot _snapshot) async {
        if(validateNotEmptyBoolWhitDefault(_snapshot.value, false)){
          await _databaseReference.reference().child("$_child").update({
            'User':'$userData',
            'Service':'$service',
            'details':'$details'
          });
        }
      });
    }
  });
}

enum LogErrorType { serviceError, userError , appError}


void writeUserNode(String user,dynamic data) async {
  try {
    await _databaseReference.reference().child("users").update({'$user': data});
  }
  catch (e){
    print("Error Database: $e");
  }
}


