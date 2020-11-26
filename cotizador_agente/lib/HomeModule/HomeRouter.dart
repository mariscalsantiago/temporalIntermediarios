import 'package:cotizador_agente/HomeModule/HomeContract.dart';
import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:cotizador_agente/NavigationHandler/NavigationHandler.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:cotizador_agente/utils/AlertModule/MyDialog.dart';
import 'package:flutter/services.dart';

class HomeRouter implements HomeWireFrame {
  HomeControllerState view;
  static const platform = const MethodChannel("native_interaction");

  HomeRouter(HomeControllerState view) {
    this.view = view;
  }

  @override
  void showAlert(String title, String message) {
    showCustomDialog(
        context: view.context,
        builder: (context) =>
            GNPDialog(title: title, description: message, actions: null));
  }

  @override
  void navigationToRoute(setRamoPoliza, bool isPoliza) {
    NavigationHandler.navigateToRoute(
        context: view.context, route: setRamoPoliza.accion);
  }
}