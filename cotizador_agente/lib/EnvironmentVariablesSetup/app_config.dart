import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Ambient {
  uat,
  qa,
  prod
}

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.serviceEndPoint,
    @required this.serviceLogin,
    @required this.serviceBCA,
    @required this.apikeyBCABonos,
    @required this.apikeyBCA,
    @required this.apikeyAppAgentes,
    @required this.service_perfilador,
    @required this.serviceConteoPolizas,
    @required this.serviceConteoClientes,
    @required this.proyectId,
    @required this.ambient,
    @required Widget child,
    @required this.urlNotifierService,
    @required this.pagoEnLinea,
    @required this.privacyAdvertisement,
    @required this.urlNegociosOperables,
    @required this.urlBase,
    @required this.urlSendAnalytics,
    @required this.idContenedorAnalytics,

  }) : super(child: child);

  final String serviceEndPoint;
  final String serviceLogin;
  final String service_perfilador;
  final String serviceConteoPolizas;
  final String serviceConteoClientes;
  final String serviceBCA;
  final String apikeyBCABonos;
  final String proyectId;
  final Ambient ambient;
  final String apikeyBCA;
  final String apikeyAppAgentes;
  final String urlNotifierService;
  final String pagoEnLinea;
  final String privacyAdvertisement;
  final String urlNegociosOperables;
  final String urlBase;
  final String urlSendAnalytics;
  final String idContenedorAnalytics;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}