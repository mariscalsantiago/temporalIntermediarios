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
    @required this.apikeyAppAgentes,
    @required this.service_perfilador,
    @required this.proyectId,
    @required this.ambient,
    @required Widget child,
    @required this.urlNotifierService,
    @required this.urlNegociosOperables,
    @required this.urlBase,
    @required this.urlSendAnalytics,
    @required this.idContenedorAnalytics,

  }) : super(child: child);

  final String serviceEndPoint;
  final String serviceLogin;
  final String service_perfilador;
  final String proyectId;
  final Ambient ambient;
  final String apikeyAppAgentes;
  final String urlNotifierService;
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