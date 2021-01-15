
import 'dart:async';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/SplashModule/SplashController.dart';
import 'package:cotizador_agente/CotizadorUnico/Cotizacion.dart';
import 'package:cotizador_agente/CotizadorUnico/FormularioPaso1.dart';
import 'package:cotizador_agente/CotizadorUnico/SeleccionaCotizadorAP.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

int timerMinuts = 20;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode);
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async{
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError(errorDetails);
  };

  /*var configuredApp = new AppConfig(
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
  );*/
  var configuredApp = new AppConfig(
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    proyectId: 'gnp-accidentespersonales-qa',
    urlNotifierService:'https://api-qa.oscp.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores-qa.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-2',

    child: new MyApp(),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runZonedGuarded((){
      runApp(configuredApp);
    }, (error, stackTrace){
      print('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });

  });
  // runApp(configuredApp);
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        //Check for errors
        if(snapshot.hasError){
          //return SomethingWentWrong();
        }
        //Once complete, show your application
        if(snapshot.connectionState == ConnectionState.done){
          return new MaterialApp(
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
              '/login': (buildContext) => LoginController(),
              '/cotizadorUnicoAP': (buildContext) => SeleccionaCotizadorAP(),
              '/cotizadorUnicoAPPasoUno': (buildContext) => FormularioPaso1(),
              '/cotizadorUnicoAPPasoTres' : (buildContext) => CotizacionVista(),
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
        //Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

