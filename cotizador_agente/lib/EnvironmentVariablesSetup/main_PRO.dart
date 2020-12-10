import 'package:flutter/services.dart';
import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    ambient: Ambient.prod,
    serviceLogin: 'https://cuentas.gnp.com.mx/auth/login',
    //  serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCABonos:'5d245910-efbe-4a6f-9074-b5d1eb8a8309',
    apikeyBCA: '9a780a70-c5fc-4bee-86cf-5650cce16516',
    apikeyAppAgentes: 'l7xxed71b90a2ed941668463e3a01513d582',
    service_perfilador: "https://api.service.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api.service.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api.service.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    proyectId: 'gnp-accidentespersonales-pro',
    urlNotifierService:'https://api.service.gnp.com.mx',
    //urlProrrogadosService: 'https://api-dev.oscp.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    privacyAdvertisement :'https://contenidosappagentes.gnp.com.mx/aviso',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-pro.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlBaseAnalytics: 'https://gmm-cotizadores.gnp.com.mx/?esMobile=true&accion=',

    child: new MyApp(),

  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(configuredApp);
  });
  //runApp(configuredApp); 145436591
}