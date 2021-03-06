import 'dart:convert';

import 'package:cotizador_agente/TabsModule/Entity/Footer.dart';
import 'package:cotizador_agente/TabsModule/Entity/Secciones.dart';
import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/utils/RemoteConfigHandler.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;

class TabsInteractor implements TabsUseCase {
  TabsInteractorOutput output;
  TabsControllerState view;

  TabsInteractor(TabsInteractorOutput output, TabsControllerState view) {
    this.output = output;
    this.view = view;
  }

  @override
  Future<Footer> getFooterConfiguration() async {
    try{
      RemoteConfig remoteConfig = await RemoteConfigHandler.setupConfiguration(view.context);
      String footerString = remoteConfig.getString(Constants.CONFIG_FOOTER);
      print("getfooter");
      print(footerString);
      var footerJson = jsonDecode(footerString);
      var footer = Footer.fromJson(footerJson);
      return defaultFooter();
    } catch(e){
      var footer = defaultFooter();
      return footer;
    }
  }

  Footer defaultFooter() {
    return Footer(visibleEnSegundoNivel: false, secciones: [
      Secciones(
          posicion: 1,
          titulo: "Cotizar",
          icono: "",
          localIcon: "assets/cotizar.png",
          habilitado: true,
          accion: "flutter_app/cotizar"),
      /*Secciones(
          posicion: 2,
          titulo: "Pagar",
          icono: "",
          localIcon: "assets/pagar.png",
          habilitado: false,
          accion: "flutter_app/pagar"),
      Secciones(
          posicion: 3,
          titulo: "Emitir",
          icono: "",
          localIcon: "assets/emitir.png",
          habilitado: false,
          accion: "flutter_app/emitir"),
      Secciones(
          posicion: 4,
          titulo: "Renovar",
          icono: "",
          localIcon: "assets/renovar.png",
          habilitado: false,
          accion: "flutter_app/renovar"),*/
      Secciones(
          posicion: 5,
          titulo: "Men??",
          icono: "",
          localIcon: "assets/menu.png",
          habilitado: true,
          accion: "flutter_app/menu"),

    ]
    );
  }


}