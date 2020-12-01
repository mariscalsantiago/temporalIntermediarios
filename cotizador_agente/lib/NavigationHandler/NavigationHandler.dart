import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    Navigator.pushNamed(context, "/cotizadorUnicoAP",);
  }

  static void showPagar(BuildContext context) {

  }
  static void showEmitir(BuildContext context) {

  }
  static void showMenu(BuildContext context) {
   showMaterialModalBottomSheet(
     barrierColor: AppColors.color_titleAlert.withOpacity(0.7),
     backgroundColor: Colors.transparent,
     context: context,
     builder: (context, scrollController) => Container(
       height: 326,
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
                   Navigator.pop(context);
                   Navigator.pushNamed(context, "/cotizadorUnicoAP",);
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
               GestureDetector(
                 onTap: (){
                   Utilidades.mostrarAlertaCallBackCustom(Mensajes.servicioNoDisp, Mensajes.errorConexion, context,"Aceptar",(){
                     Navigator.pop(context);
                   });
                 },
                 child: Row(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top:28.0, right: 38),
                     child: Image.asset("assets/emitir.png", width: 12, height: 16,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 28.0, right: 56),
                     child: Text("Emitir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                   )
                 ],),
               ),
               GestureDetector(
                 onTap: (){
                   Utilidades.mostrarAlertaCallBackCustom(Mensajes.servicioNoDisp, Mensajes.errorConexion, context,"Aceptar",(){
                     Navigator.pop(context);
                   });
                 },
                 child: Row(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top:28.0, right: 38),
                     child: Image.asset("assets/pagar.png", width: 12, height: 16,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 28.0, right: 56),
                     child: Text("Pagar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                   )
                 ],),
               ),
               GestureDetector(
                 onTap: (){
                   Utilidades.mostrarAlertaCallBackCustom(Mensajes.servicioNoDisp, Mensajes.errorConexion, context,"Aceptar",(){
                     Navigator.pop(context);
                   });
                 },
                 child: Row(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top:28.0, right: 38),
                     child: Image.asset("assets/renovar.png", width: 12, height: 16,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 28.0, right: 56),
                     child: Text("Renovar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                   )
                 ],),
               ),
               GestureDetector(
                 onTap: (){
                   Utilidades.mostrarAlertaCallBackCustom(Mensajes.servicioNoDisp, Mensajes.errorConexion, context,"Aceptar",(){
                     Navigator.pop(context);
                   });
                 },
                 child: Row(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top:28.0, right: 38),
                     child: Image.asset("assets/endosar.png", width: 12, height: 16,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 28.0, right: 56),
                     child: Text("Endosar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                   )
                 ],),
               ),
               GestureDetector(
                 onTap: (){
                   Utilidades.mostrarAlertaCallBackCustom(Mensajes.servicioNoDisp, Mensajes.errorConexion, context,"Aceptar",(){
                     Navigator.pop(context);
                   });
                 },
                 child: Row(children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(top:28.0, right: 38),
                     child: Image.asset("assets/buscar.png", width: 12, height: 16,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 28.0, right: 56),
                     child: Text("Buscar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar), textAlign: TextAlign.left,),
                   )
                 ],),
               ),
             ],
           ),
         ),
       ),
     )
    );
  }

}