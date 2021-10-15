
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/perfil/Terminos_y_condiciones.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';

void procesoActiveBiometricosOTP(BuildContext context, Responsive responsive, Function callback) {
  print("-----------Exito----------------------");
  if (prefs.getBool("primeraVez") ||
      prefs.getBool("flujoCompletoLogin") == null ||
      !prefs.getBool("flujoCompletoLogin")) {
    if (prefs.getBool('primeraVezIntermediario') != null &&
        prefs.getBool('primeraVezIntermediario')) {
      Navigator.pop(context, true);
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) =>
              LoginActualizarContrasena(responsive: responsive,)));
    } else {
      if (deviceType == ScreenType.phone) {
        print("Verifica codigo celular");
        Navigator.pop(context, true);
        customAlert(AlertDialogType.verificaTuNumeroCelular, context, "", "", responsive, callback);
      }
      else {
        Navigator.pop(context, true);
        customAlert(AlertDialogType.verificaTuNumeroCelular, context, "", "", responsive, callback);
        //TODO TAbler
        //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "", "", responsive, callback);
      }
    }
  } else {
    if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
      callback();
      Navigator.pop(context, true);
    } else {
      print("Exito----------------------");
      Navigator.pop(context, true);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(responsive: responsive,)));
    }
  }
  prefs.setBool("aceptoTerminos", checkedValue);
}