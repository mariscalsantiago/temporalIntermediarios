import 'package:firebase_core/firebase_core.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

    child: new MyApp(),
  );

 // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(configuredApp);
 // });
  // runApp(configuredApp);
}