import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void funcionAlerta(){

}

class NavigationHandler {
  BuildContext mContext;
  NavigationHandler();

  static Future<bool> navigateToRoute({BuildContext context, String route}) async {
    switch (route) {
      case "flutter_app/cotizar":
        showCotizar(context);
        break;
      case "flutter_app/pagar":
      // showEmitir(context);
        break;
      case "flutter_app/emitir":
      // showPagar(context);
        break;
      case "flutter_app/renovar":
      // showRenovar(context);
        break;
      case "flutter_app/menu":
        //showMenu(context);
        Responsive responsive = Responsive.of(context);
        customAlert(AlertDialogType.menu_home,context,"","", responsive, funcionAlerta);
        break;
      default:
        break;
    }
    return false;
  }

  static void showCotizar(BuildContext context) {
    switch(opcionElegida){
      case HomeSelection.Atuos:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage()), );
        break;

      case HomeSelection.AP:
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return CotizarController();
            }));
        break;

    }
  }

  static void showPagar(BuildContext context) {
    Navigator.pop(context,true);
  }
  static void showEmitir(BuildContext context) {
    Navigator.pop(context,true);
  }

  static void showRenovar(BuildContext context) {
    Navigator.pop(context,true);
  }

  /*static void showMenu(BuildContext context) {
    showMaterialModalBottomSheet(
        barrierColor: AppColors.color_titleAlert.withOpacity(0.7),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context, scrollController) => Container(
          height: 90,//326,
          padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
          decoration : new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
              )
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context,true);
                      //Navigator.pushNamed(context, "/cotizadorUnicoAP",);
                    },
                    child: Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:28.0, right: 38),
                        child: Image.asset("assets/cotizar.png", width: 12, height: 16,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, right: 56),
                        child: Text("Cotizar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                      )
                    ],),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  } */

}