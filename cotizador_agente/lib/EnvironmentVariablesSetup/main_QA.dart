import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    proyectId: 'gnp-accidentespersonales-qa',
    //urlNotifierService:'https://api-qa.oscp.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores-qa.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-2',

    serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',

    //Preguntas Secretas
    apiKey: 'l7xx2fea6d294a6641438cde5681449e16dc',
    consultaPreguntasSecretas: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    generarOTP:'',
    validarOTP:'',
    cambioContrasenaPerfil: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://api-qa.oscp.gnp.com.mx/aprAprovisionamiento/admonUsuarios',

    child: new MyApp(),
  );

  runApp(configuredApp);

}