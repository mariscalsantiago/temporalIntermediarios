
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Perfil/PerfilPage.dart';
import 'package:cotizador_agente/vistas/FormularioPaso1.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
import 'package:cotizador_agente/vistas/Inicio/Bienvenida.dart';
import 'package:cotizador_agente/vistas/Inicio/LoginPage.dart';
import 'package:cotizador_agente/vistas/SeleccionaCotizadorAP.dart';
import 'package:cotizador_agente/vistas/SendEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
    apikeyPagoLinea: 'l7xxd3a72b3db531458493474a557c4ab23e',
    apikeyCampanias: 'l7xx3ecf012faeb4498995715f536c717be8',
    serviceEndPointCuentas: "",
    serviceEventos: "",
    serviceEndPoint: 'http://10.67.83.12/AppCobros/rest/',
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
  //  serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCABonos:'04985d13-d1d4-4032-9fe6-faa14c18d464',
    serviceBonosLogin:'https://api-qa.oscp.gnp.com.mx/bca-bonos/BCABonosSegundoPwd',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',
    apikeyBCABusqueda: '6d27171d-56ab-4bd2-8188-60f06741ac79',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    serviceSolicitud: 'https://solicituddigital-qa.gnp.com.mx',
    serviceHerramientasGM: 'https://test28022019-dot-gnp-pymesgmm-prod.appspot.com',
    serviceHerramientasRC: 'https://gnp-mirc-qa.appspot.com',
    servicePolizasClientesCards:"https://appagentes-qa.gnp.com.mx",
    service_Consulta_Cartera_Poliza:'https://api-qa.oscp.gnp.com.mx/crm-agente/consulta-cartera-poliza',
    service_Consulta_Cartera_Nombre:'https://api-qa.oscp.gnp.com.mx/crm-agente/consulta-cartera-nombre',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    agentCod: "EHERNA978487",
    proyectId: 'gnp-appagentes-qa',
    apiKeyTipoDeCambio:'l7xx63f313ab37be41ecacb2301c7bbcad92',
    urlTipoDeCambio:'http://api.service.gnp.com.mx/sce/cut/recuperarTipoCambio',
    urlCampaniasService:'http://bca-ws-qa.gnp.com.mx',
    apiKeyCampaniasService:"d41d8cd98f00b204e9800998ecf8427e",
    urlNotifierService:'https://api-qa.oscp.gnp.com.mx',
    //urlProrrogadosService: 'https://api-dev.oscp.gnp.com.mx',
    apikeyCatalogo: 'l7xx47335731a26d4c93bf3f4288f644553d',
    serviceConsolidar:'https://us-central1-gnp-baseunicaagentes-uat.cloudfunctions.net',
    urlVersatileHome: 'https://hogarversatil-qa.gnp.com.mx',
    liferayUrl:'http://35.209.236.248/menu-noticias',
    liferayUrlEventos:'http://35.239.6.76/web/eventosgnp',
    liferayUrlBonos:'http://35.209.236.248/',
    repairFollow :'https://seguimientosiniestrosautos-qa.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    privacyAdvertisement :'http://35.209.236.248/aviso',
    formatsService :'https://us-central1-gnp-appagentes-qa.cloudfunctions.net/formatos-consulta-contenido',
    formatsServiceKey :'5f2b7910efbb4167936b051fa0f35f82',
    negocioProtegido :'https://negocioprotegido-qa.gnp.com.mx/agentes/',
    servicioDeEncriptado :'https://negocioprotegido-qa.gnp.com.mx/service/validation/v1/encriptarDatosCotizador',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/COT_CF_ConsultaNegocioCanal',
    urlCotizadores: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/negocio',
    urlGeneraCotizacion: 'https://gmm-cotizadores-qa.gnp.com.mx/orquestador-cotizador/generar-cotizacion',
    urlBorraCotizacion: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/borrarCotizacion',
    urlFormatoPDF: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/formato',
    urlCotizacionesGuardadas: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/cotizaciones',
    urlFormularioPaso1: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/aplicacion?idAplicacion=',
    urlFormularioPaso2: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/aplicacion/',
    urlGuardaCotizacion: 'https://gmm-cotizadores-qa.gnp.com.mx/persisteCotizaciones/guardaCotizacion',
    urlEnviaEmail: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizacion/correo',
    urlAnalytics: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=vistaPreviaMovil&dataLayer=',
    urlAccionDescarga: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=descargarMovil&dataLayer=',
    urlAccionEnviaCot: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=cotizacionMovil&dataLayer=',
    urlAccionEnviaMail: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=envioMovil&dataLayer=',
    urlAccionComparativa: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=comparativaMovil&dataLayer=',
    urlAccionIngreso: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=ingresoMovil&dataLayer=',

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
        '/login': (buildContext) => LoginPage(),
        '/perfil': (buildContext) => PerfilPage(),
        '/cotizadorUnicoAP': (buildContext) => SeleccionaCotizadorAP(),
        '/cotizadorUnicoAPPasoUno': (buildContext) => FormularioPaso1(),
        '/cotizadorUnicoAPPasoDos': (buildContext) => FormularioPaso2(),
        '/cotizadorUnicoAPSendEmail': (buildContext) => SendEmail(),
      },
        debugShowCheckedModeBanner: false,
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.deepOrange,
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 18.0),
              body2: TextStyle(fontSize: 18.0))),
      home: LoginPage(),
    );
  }
}

