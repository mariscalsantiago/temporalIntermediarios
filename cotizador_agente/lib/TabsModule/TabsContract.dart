
import 'package:cotizador_agente/TabsModule/Entity/Footer.dart';

abstract class TabsView {

}

abstract class TabsPresentation {
  void showCotizador();
  Future<Footer> getFooterConfiguration();
  void navigateToRoute(String route);
  void showAlertNoHabilitado(String title);
}

abstract class TabsUseCase {
  Future<Footer> getFooterConfiguration();
}

abstract class TabsInteractorOutput {

}

abstract class TabsWireFrame {
  void showCotizadores();
  void navigateToRoute(String route);
  void showAlertNoHabilitado(String title);
}