import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    serviceEndPoint: 'http://10.67.83.12/AppCobros/rest/',
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
    serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCABonos:'04985d13-d1d4-4032-9fe6-faa14c18d464',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    proyectId: 'gnp-accidentespersonales-qa',
    urlNotifierService:'https://api-qa.oscp.gnp.com.mx',
    //urlProrrogadosService: 'https://api-dev.oscp.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    privacyAdvertisement :'http://35.209.236.248/aviso',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores-qa.gnp.com.mx/',
    urlBaseAnalytics: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=',

    child: new MyApp(),
  );

 // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(configuredApp);
 // });
  // runApp(configuredApp);
}