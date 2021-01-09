
import 'package:cotizador_agente/Cotizar/CotizarContract.dart';
import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:cotizador_agente/Cotizar/CotizarInteractor.dart';
import 'package:cotizador_agente/Cotizar/CotizarRouter.dart';

class CotizarPresenter implements CotizarPresentation, CotizarInteractorOutput {

  CotizarControllerState view;
  CotizarInteractor interactor;
  CotizarRouter router;

  CotizarPresenter(CotizarControllerState view) {
    this.view = view;
    this.interactor = new CotizarInteractor(this, view);
    this.router = new CotizarRouter(view);
  }

  @override
  void showSegurosMasivos() {
    router.showSegurosMasivos();
  }
}