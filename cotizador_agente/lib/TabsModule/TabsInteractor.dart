import 'package:cotizador_agente/TabsModule/Entity/Footer.dart';
import 'package:cotizador_agente/TabsModule/Entity/Secciones.dart';
import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';

class TabsInteractor implements TabsUseCase {
  TabsInteractorOutput output;
  TabsControllerState view;

  TabsInteractor(TabsInteractorOutput output, TabsControllerState view) {
    this.output = output;
    this.view = view;
  }

  @override
  Future<Footer> getFooterConfiguration() async {
    try {
     /* RemoteConfig remoteConfig = await RemoteConfigHandler.setupConfiguration(view.context);
      String footerString = remoteConfig.getString(Constants.CONFIG_FOOTER);
      var footerJson = jsonDecode(footerString);
      var footer = Footer.fromJson(footerJson);
      for (var i = 0; i < footer.secciones.length; i++) {
        var titulo = footer.secciones[i].titulo ?? "";
        if (titulo == "Tarjeta GMM") {
          var enabled = await checkPolizasConexion();
          footer.secciones[i].habilitado = enabled;
        }
      }
      return footer;*/
    } catch (e) {
      var footer = defaultFooter();
      for (var i = 0; i < footer.secciones.length; i++) {
        var titulo = footer.secciones[i].titulo ?? "";

      }
      return footer;
    }
  }

  Footer defaultFooter() {
    return Footer(visibleEnSegundoNivel: false, secciones: [
      Secciones(
          posicion: 1,
          titulo: "Directorio",
          icono: "",
          localIcon: "assets/images/tab_directorio.png",
          habilitado: true,
          accion: "flutter_app/directorio"),
      Secciones(
          posicion: 2,
          titulo: "Mis Trámites",
          icono: "",
          localIcon: "assets/images/tab_tramites.png",
          habilitado: true,
          accion: "flutter_app/mis_tramites"),
      Secciones(
          posicion: 3,
          titulo: "Tarjeta GMM",
          icono: "",
          localIcon: "assets/images/tab_tarjeta.png",
          habilitado: true,
          accion: "flutter_app/tarjeta_gmm"),
      Secciones(
          posicion: 4,
          titulo: "Linea GNP",
          icono: "",
          localIcon: "assets/images/tab_linea.png",
          habilitado: true,
          accion: "flutter_app/linea_gnp"),
    ]);
  }


}