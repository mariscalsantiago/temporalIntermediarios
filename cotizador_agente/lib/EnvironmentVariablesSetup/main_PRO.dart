import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.prod,
    serviceLogin: 'https://cuentas.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xxed71b90a2ed941668463e3a01513d582',
    service_perfilador: "https://api.service.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    proyectId: 'gnp-accidentespersonales-pro',
    // urlNotifierService:'https://api.service.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-pro.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-29272127-16',

    serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',

    //Preguntas Secretas
    apiKey: 'l7xx2fea6d294a6641438cde5681449e16dc',
    consultaPreguntasSecretas: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    orquestadorOTPSinSesion:'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://api-qa.oscp.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://api-qa.oscp.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://api-qa.oscp.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://api-qa.oscp.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",

    child: new MyApp(),

  );
  runApp(configuredApp);
}