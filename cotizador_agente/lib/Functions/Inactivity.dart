import 'dart:async';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';

Timer _timerInactivity;
var nowInicio;
var nowTermino;

class Inactivity{BuildContext context;

Inactivity({this.context});

initialInactivity(Function callback) {
  print("initialInactivity");
  nowInicio = new DateTime.now();

  if (_timerInactivity != null && _timerInactivity.isActive) {
    print("initialInactivity inicializado $nowInicio");
    _timerInactivity.cancel();
    _timerInactivity = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutIntermediario(callback));
  } else {
    print("initialInactivity primera vez  $nowInicio");
    _timerInactivity = Timer.periodic(Duration(minutes: timerMinuts), (_) => logOutIntermediario(callback));
  }
}

cancelInactivity() {
  print("cancelInactivity");
  if (_timerInactivity != null && _timerInactivity.isActive)
    _timerInactivity.cancel();
}

logOutIntermediario(Function callback) {
  print("logOutIntermediario");
  nowTermino = new DateTime.now();
  print("logOutIntermediario : $nowTermino");
  if (_timerInactivity != null && _timerInactivity.isActive)
    _timerInactivity.cancel();
  customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, this.context, "$nowInicio",  "$nowTermino", Responsive.of(this.context),callback);
}

backgroundTimier(Function callback){
  print("backgroundTimier");
      if (_timerInactivity != null && _timerInactivity.isActive){
        DateTime backgroundTermino = new DateTime.now();
        DateTime stopInicio = nowInicio.add(Duration(minutes: timerMinuts));
        print("backgroundTimier: $backgroundTermino $stopInicio ");
         if(backgroundTermino.isAfter(stopInicio)){
           _timerInactivity.cancel();
           customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, this.context, "$nowInicio",  "$nowTermino", Responsive.of(this.context),callback);
         }
      }
  }
}