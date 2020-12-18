import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/SplashModule/SplashContract.dart';
import 'package:cotizador_agente/SplashModule/SplashController.dart';
import 'package:flutter/material.dart';

class SplashRouter implements SplashWireFrame {

  SplashControllerState view;

  SplashRouter(SplashControllerState view) {
    this.view = view;
  }

  @override
  void showHome() {
    Navigator.of(view.context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeController()),
            (Route<dynamic> route) => false);
  }

  @override
  void showLogin() {
    Navigator.of(view.context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginController()),
            (Route<dynamic> route) => false);
  }

}