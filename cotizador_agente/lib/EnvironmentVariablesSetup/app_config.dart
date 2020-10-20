import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Ambient {
  uat,
  qa,
  prod
}

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.apikeyPagoLinea,
    @required this.apikeyCampanias,
    @required this.serviceEndPoint,
    @required this.serviceEndPointCuentas,
    @required this.serviceLogin,
    @required this.serviceBCA,
    @required this.apikeyBCABonos,
    @required this.serviceBonosLogin,
    @required this.apikeyBCA,
    @required this.apikeyAppAgentes,
    @required this.serviceSolicitud,
    @required this.serviceHerramientasGM,
    @required this.serviceHerramientasRC,
    @required this.urlTipoDeCambio,
    @required this.servicePolizasClientesCards,
    @required this.serviceEventos,
    @required this.service_Consulta_Cartera_Poliza,
    @required this.service_Consulta_Cartera_Nombre,
    @required this.service_perfilador,
    @required this.serviceConteoPolizas,
    @required this.serviceConteoClientes,
    @required this.apiKeyTipoDeCambio,
    @required this.proyectId,
    @required this.ambient,
    @required Widget child,
    @required this.agentCod,
    @required this.apikeyBCABusqueda,
    @required this.serviceBCABase,
    @required this.apiKeyCampaniasService,
    @required this.urlCampaniasService,
    @required this.urlNotifierService,
    @required this.serviceConsolidar,
    @required this.apikeyCatalogo,
    @required this.urlVersatileHome,
    @required this.liferayUrl,
    @required this.liferayUrlBonos,
    @required this.liferayUrlEventos,
    @required this.repairFollow,
    @required this.pagoEnLinea,
    @required this.privacyAdvertisement,
    @required this.formatsService,
    @required this.formatsServiceKey,
    @required this.negocioProtegido,
    @required this.servicioDeEncriptado,
    @required this.urlNegociosOperables,
    @required this.urlCotizadores,
    @required this.urlGeneraCotizacion,
    @required this.urlBorraCotizacion,
    @required this.urlFormatoPDF,
    @required this.urlCotizacionesGuardadas,
    @required this.urlFormularioPaso1,
    @required this.urlFormularioPaso2,
    @required this.urlGuardaCotizacion,
    @required this.urlEnviaEmail,
    @required this.urlAnalytics,
    @required this.urlAccionEnviaCot,
    @required this.urlAccionDescarga,
    @required this.urlAccionEnviaMail,
    @required this.urlAccionComparativa,
    @required this.urlAccionIngreso,


  }) : super(child: child);

  final String apikeyPagoLinea;
  final String apikeyCampanias;
  final String liferayUrlEventos;
  final String serviceEndPoint;
  final String serviceEndPointCuentas;
  final String serviceLogin;
  final String serviceSolicitud;
  final String serviceHerramientasGM;
  final String serviceHerramientasRC;
  final String servicePolizasClientesCards;
  final String serviceEventos;
  final String service_Consulta_Cartera_Poliza;
  final String service_Consulta_Cartera_Nombre;
  final String service_perfilador;
  final String serviceConteoPolizas;
  final String serviceConteoClientes;
  final String apiKeyTipoDeCambio;
  final String urlTipoDeCambio;
  final String serviceBCA;
  final String apikeyBCABonos;
  final String serviceBonosLogin;
  final String proyectId;
  final Ambient ambient;
  final String agentCod;
  final String apikeyBCA;
  final String apikeyAppAgentes;
  final String serviceBCABase;
  final String apikeyBCABusqueda;
  final String apiKeyCampaniasService;
  final String urlCampaniasService;
  final String urlNotifierService;
  final String serviceConsolidar;
  final String apikeyCatalogo;
  final String urlVersatileHome;
  final String liferayUrl;
  final String liferayUrlBonos;
  final String repairFollow;
  final String pagoEnLinea;
  final String privacyAdvertisement;
  final String formatsService;
  final String formatsServiceKey;
  final String negocioProtegido;
  final String servicioDeEncriptado;
  final String urlNegociosOperables;
  final String urlCotizadores;
  final String urlGeneraCotizacion;
  final String urlBorraCotizacion;
  final String urlFormatoPDF;
  final String urlCotizacionesGuardadas;
  final String urlFormularioPaso1;
  final String urlFormularioPaso2;
  final String urlGuardaCotizacion;
  final String urlEnviaEmail;
  final String urlAnalytics;
  final String urlAccionEnviaCot;
  final String urlAccionDescarga;
  final String urlAccionEnviaMail;
  final String urlAccionComparativa;
  final String urlAccionIngreso;


  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}