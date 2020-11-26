import 'package:cotizador_agente/TabsModule/Entity/Footer.dart';
import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/TabsModule/TabsInteractor.dart';
import 'package:cotizador_agente/TabsModule/TabsRouter.dart';

class TabsPresenter implements TabsPresentation, TabsInteractorOutput {

  TabsControllerState view;
  TabsInteractor interactor;
  TabsRouter router;

  TabsPresenter(TabsControllerState view) {
    this.view = view;
    this.interactor = new TabsInteractor(this, view);
    this.router = new TabsRouter(view);
  }

  @override
  void showCotizador() {
    router.showCotizador();
  }

  @override
  Future<Footer> getFooterConfiguration() {
    return interactor?.getFooterConfiguration();
  }

  @override
  void navigateToRoute(String route) {
    router?.navigateToRoute(route);
  }

  @override
  void showAlertNoHabilitado(String title) {
    router?.showAlertNoHabilitado(title);
  }
}