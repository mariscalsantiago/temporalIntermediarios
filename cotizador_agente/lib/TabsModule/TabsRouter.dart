import 'package:cotizador_agente/NavigationHandler/NavigationHandler.dart';
import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:cotizador_agente/utils/AlertModule/MyDialog.dart';
import 'package:cotizador_agente/vistas/SeleccionaCotizadorAP.dart';
import 'package:flutter/material.dart';

class TabsRouter implements TabsWireFrame {
  TabsControllerState view;

  TabsRouter(TabsControllerState view) {
    this.view = view;
  }

  @override
  void showCotizador(){
    /*Navigator.of(view.context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return SeleccionaCotizadorAP();
        }));*/
    Navigator.pushNamed(view.context, "/cotizadorUnicoAP",);
  }

  @override
  void navigateToRoute(String route) {
    NavigationHandler.navigateToRoute(context: view.context, route: route);
  }

  @override
  void showAlertNoHabilitado(String title) async {
    await showCustomDialog(
        context: view?.context,
        builder: (context) => GNPDialog(
            title: "Servicio no disponible",
            description: "Por el momento este servicio no está disponible, inténtalo más tarde.",
            actions: null));
  }

}