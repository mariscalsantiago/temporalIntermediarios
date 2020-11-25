import 'package:cotizador_agente/HomeModule/Entity/HomeRamos.dart';

abstract class HomeView {
}

abstract class HomePresentation {

  void navigationToRoute(HomeRamos setRamoPoliza, bool isPoliza);
}

abstract class HomeUseCase {

}

abstract class HomeInteractorOutput {

}

abstract class HomeWireFrame {
  void navigationToRoute(HomeRamos setRamoPoliza, bool isPoliza);
}

abstract class HomePropertiesUseCase {
  void setUserProperties();
}