
import 'package:cotizador_agente/Cotizar/CotizarContract.dart';
import 'package:cotizador_agente/Cotizar/CotizarController.dart';

class CotizarInteractor implements CotizarUseCase {

  CotizarInteractorOutput output;
  CotizarControllerState view;

  CotizarInteractor(CotizarInteractorOutput output, CotizarControllerState view){
    this.output = output;
    this.view = view;
  }


}