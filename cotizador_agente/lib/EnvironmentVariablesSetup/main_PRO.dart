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
    urlNotifierService:'https://api.service.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-pro.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-29272127-16',

    child: new MyApp(),

  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(configuredApp);
  });
  //runApp(configuredApp); 145436591
}