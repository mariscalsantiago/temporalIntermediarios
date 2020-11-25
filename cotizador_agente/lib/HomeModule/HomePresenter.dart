import 'package:cotizador_agente/HomeModule/HomeContract.dart';
import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:cotizador_agente/HomeModule/HomeInteractor.dart';
import 'package:cotizador_agente/HomeModule/HomeRouter.dart';

class HomePresenter implements HomePresentation, HomeInteractorOutput {
  HomeControllerState view;
  HomeInteractor interactor;
  HomeRouter router;

  HomePresenter(HomeControllerState view) {
    this.view = view;
    this.interactor = new HomeInteractor(this, view);
    this.router = new HomeRouter(view);
  }

  @override
  void navigationToRoute(setRamoPoliza, bool isPoliza) {
    router.navigationToRoute(setRamoPoliza, isPoliza);
  }
}