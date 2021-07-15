import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.prod,
    serviceLogin: 'https://cuentas.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    service_perfilador: "https://api.service.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: 'gnp-accidentespersonales-pro',
    // urlNotifierService:'https://api.service.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-pro.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-29272127-16',

    serviceBCA: 'https://bca-ws.gnp.com.mx',
    apikeyBCA: '9a780a70-c5fc-4bee-86cf-5650cce16516',

    //Preguntas Secretas
    apiKey: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    consultaPreguntasSecretas: 'https://api.service.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://api.service.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://api.service.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://api.service.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://api.service.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    orquestadorOTPSinSesion:'https://app-inter.gnp.com.mx/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://api.service.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://api.service.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://api.service.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://app-inter.gnp.com.mx/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://api.service.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-pro.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://api.service.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
    child: new MyApp(),

  );
  runApp(configuredApp);
}