import 'package:cotizador_agente/HomeModule/HomeContract.dart';
import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:cotizador_agente/NavigationHandler/NavigationHandler.dart';
import 'package:flutter/services.dart';

class HomeRouter implements HomeWireFrame {
  HomeControllerState view;
  static const platform = const MethodChannel("native_interaction");

  HomeRouter(HomeControllerState view) {
    this.view = view;
  }

  @override
  void navigationToRoute(setRamoPoliza, bool isPoliza) {
    NavigationHandler.navigateToRoute(
        context: view.context, route: setRamoPoliza.accion);
  }
}