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
    @required this.serviceBCA,
    @required this.apikeyBCA,
    @required this.consultaPreguntasSecretas,
    @required this.actualizarEstablecerPreguntasSecretas,
    @required this.apiKey,
    @required this.cambioContrasenaPerfil,
    @required this.consultaUsuarioPorCorreo,
    @required this.reestablecerContrasena,
    @required this.orquestadorOTPSinSesion,
    @required this.validaOTP,
    @required this.consultarMedioContactosAgentes,
    @required this.altaMediosContactoAgentes,
    @required this.orquestadorOtpJwt,
    @required this.consultaPersonaIdParticipante,
    @required this.cotizadorAutos,
    @required this.servicioNuevoConsultaPorCorreo,
    @required this.servicioNuevoDatosPerfil

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
  final String serviceBCA;
  final String apikeyBCA;
  final String consultaPreguntasSecretas;
  final String actualizarEstablecerPreguntasSecretas;
  final String apiKey;
  final String cambioContrasenaPerfil;
  final String consultaUsuarioPorCorreo;
  final String reestablecerContrasena;
  final String orquestadorOTPSinSesion;
  final String validaOTP;
  final String consultarMedioContactosAgentes;
  final String altaMediosContactoAgentes;
  final String orquestadorOtpJwt;
  final String consultaPersonaIdParticipante;
  final String cotizadorAutos;
  final String servicioNuevoConsultaPorCorreo;
  final String servicioNuevoDatosPerfil;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}