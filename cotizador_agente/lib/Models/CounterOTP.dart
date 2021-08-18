import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:flutter/material.dart';

class CounterOTP extends ChangeNotifier {
  String minuts = '03';
  String seconds = "00";
  bool timerEnds = false;

  void doSomething() {

    if(BackgroundRemainingDate!="0") {
      DateTime nowInicio = DateTime.parse(BackgroundRemainingDate);
      DateTime backgroundTermino = new DateTime.now();
      DateTime stopInicio = nowInicio.add(Duration(minutes: 3));


      if (backgroundTermino.isAfter(stopInicio)) {
        timerEnd = true;

        minuts = "00";
        seconds = "00";

      }else{

        //cuanto tiempo paso afuera
        var BackgroundTime = backgroundTermino.difference(nowInicio);

        int minutesBackground = 0;
        int secondsBackground = 0;
        int minutesFinal = 0;
        int secondsFinal = 0;

        List<String> parts = "$BackgroundTime".split(':');

        minutesBackground = int.parse(parts[1]);
        if(parts[2].contains("."))
          secondsBackground = int.parse(parts[2].split('.')[0]);
        else
          secondsBackground = int.parse(parts[2]);



        DateTime DateInicio = nowInicio.add(Duration(minutes: minutesBackground, seconds: secondsBackground));

        var BackgroundTimeFinal = stopInicio.difference(DateInicio);


        List<String> partsFinal = "$BackgroundTimeFinal".split(':');

        minutesFinal = int.parse(partsFinal[1]);
        if(partsFinal[2].contains("."))
          secondsFinal = int.parse(partsFinal[2].split('.')[0]);
        else
          secondsFinal = int.parse(partsFinal[2]);

        minuts = twoDigits(minutesFinal);
        seconds = twoDigits(secondsFinal);

      }
    }
    //notifyListeners();
  }
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}