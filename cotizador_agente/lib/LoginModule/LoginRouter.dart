import 'dart:developer';

import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:cotizador_agente/utils/AlertModule/MyDialog.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:local_auth/local_auth.dart';

class LoginRouter implements LoginWireFrame {
  LoginControllerState view;
 // final LocalAuthentication auth = LocalAuthentication();
  static const platform = const MethodChannel("native_interaction");
  var mUser;
  var email;

  LoginRouter(LoginControllerState view) {
    this.view = view;
  }

  @override
  void showHome() {
    var route = ModalRoute.of(view.context);
    if (route.isCurrent) {
      Navigator.of(view.context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return HomeController();
          }));
    }
  }

  @override
  void showLoader() {
    var route = ModalRoute.of(view.context);
    if (route.isCurrent) {
      Navigator.of(view.context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return LoadingController();
          }));
    }
  }

  @override
  void hideLoader() {
    try {
      var route = ModalRoute.of(view.context);
      if (route.isCurrent) {
        return;
      } else {
        Navigator.pop(view.context);
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  @override
  void showAlert(String title, String message, TipoDialogo tipo) {
    showCustomDialog(
        context: view.context,
        builder: (context) => GNPDialog(
            title: title, description: message, actions: null, tipo: tipo));
  }

  @override
  void openOlvideContrasenia() {
  }


}