import 'package:cotizador_agente/HomeModule/HomeContract.dart';
import 'package:cotizador_agente/HomeModule/HomeController.dart';

class HomeInteractor implements HomeUseCase {
  HomeInteractorOutput output;
  HomeControllerState view;

  HomeInteractor(HomeInteractorOutput output, HomeControllerState view) {
    this.output = output;
    this.view = view;
  }

}