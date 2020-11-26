
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Perfil/PerfilPage.dart';
import 'package:cotizador_agente/SplashModule/SplashController.dart';
import 'package:cotizador_agente/vistas/Cotizacion.dart';
import 'package:cotizador_agente/vistas/FormularioPaso1.dart';
import 'package:cotizador_agente/vistas/Inicio/LoginPage.dart';
import 'package:cotizador_agente/vistas/SeleccionaCotizadorAP.dart';
import 'package:cotizador_agente/vistas/SendEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

int timerMinuts = 20;
int timerSec = 1200;
DateTime sessionStartDate;
var inWebView = false;
var isLogActive = true;

void printLog(String where, String what) {
  if (isLogActive) {
    print("_" + where + ": " + what);
  } else {}
}

enum editType {
  salud,
  estudios,
  familiar,
  texto,
  correo,
  telefono,
  direccion,
  poliza,
  contatoEmergencia,
  nickname,
  visa,
  pasaporte,
  playera,
  condiciones,
  deportes,
  acompaniante
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    serviceEndPoint: 'http://10.67.83.12/AppCobros/rest/',
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
  //  serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
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
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/COT_CF_ConsultaNegocioCanal',
    urlBase: 'https://gmm-cotizadores-qa.gnp.com.mx/',
    urlBaseAnalytics: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=',

    child: new MyApp(),
  );

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
  runApp(configuredApp);
  // });
  // runApp(configuredApp);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // español
      ],
      initialRoute: '/',
      routes: {
        '/splash': (buildContext) => SplashController(),
        '/login': (buildContext) => LoginPage(),
        '/perfil': (buildContext) => PerfilPage(),
        '/cotizadorUnicoAP': (buildContext) => SeleccionaCotizadorAP(),
        '/cotizadorUnicoAPPasoUno': (buildContext) => FormularioPaso1(),
        '/cotizadorUnicoAPPasoTres' : (buildContext) => CotizacionVista(),
        '/cotizadorUnicoAPSendEmail': (buildContext) => SendEmail(),
      },
      debugShowCheckedModeBanner: false,
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.deepOrange,
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 18.0),
              body2: TextStyle(fontSize: 18.0))),
      home: SplashController(),
    );
  }
}

