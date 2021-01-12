import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    serviceEndPoint: 'http://150.23.58.197/AppCobros/rest/',
    ambient: Ambient.uat,
    serviceLogin: 'https://cuentas-uat.gnp.com.mx/auth/login',
    serviceBCA: 'https://bca-ws-uat.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',
    apikeyBCABonos: '04985d13-d1d4-4032-9fe6-faa14c18d464',
    apikeyAppAgentes: 'l7xx526ec2d1bd9140a39ad15f72e1964bca',
    service_perfilador: "https://api-uat.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api-uat.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api-uat.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    proyectId: 'gnp-accidentespersonales-uat',
    urlNotifierService:'https://api-uat.oscpuat.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    privacyAdvertisement :'http://35.209.236.248/aviso',
    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-uat.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores-uat.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-1',

    child: new MyApp(),

  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(configuredApp);
  });
  //runApp(configuredApp); 145436591
}