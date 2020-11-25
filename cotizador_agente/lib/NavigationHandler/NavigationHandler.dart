import 'package:cotizador_agente/vistas/SeleccionaCotizadorAP.dart';
import 'package:flutter/material.dart';

class NavigationHandler {
  BuildContext mContext;

  NavigationHandler();

  static Future<bool> navigateToRoute({BuildContext context, String route}) async {
    switch (route) {
      case "flutter_app/home":
        break;
      case "flutter_app/cotizar":
        showCotizar(context);
        break;
      case "flutter_app/pagar":
        showPagar(context);
        break;
      case "flutter_app/emitir":
        showEmitir(context);
        break;
      case "flutter_app/menu":
        showMenu(context);
        break;
      default:
        break;
    }
    return false;
  }

  static void showCotizar(BuildContext context) {

    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return SeleccionaCotizadorAP();
        }));
  }

  static void showPagar(BuildContext context) {

  }
  static void showEmitir(BuildContext context) {

  }
  static void showMenu(BuildContext context) {

  }

}