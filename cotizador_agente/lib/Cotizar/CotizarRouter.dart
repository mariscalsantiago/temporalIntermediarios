
import 'package:cotizador_agente/Cotizar/CotizarContract.dart';
import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:flutter/cupertino.dart';

class CotizarRouter implements CotizarWireFrame {
  CotizarControllerState view;

  CotizarRouter(CotizarControllerState view){
    this.view =view;
  }

  @override
  void showSegurosMasivos() {
    Navigator.pushNamed(view.context, "/cotizadorUnicoAP",);
  }
}