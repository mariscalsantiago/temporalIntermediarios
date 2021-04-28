import 'dart:async';
import 'dart:io';
import 'package:cotizador_agente/CotizadorUnico/Cotizacion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'CotizadorUnico/FormularioPaso1.dart';
import 'CotizadorUnico/SeleccionaCotizadorAP.dart';
import 'EnvironmentVariablesSetup/app_config.dart';
import 'UserInterface/login/Splash/Splash.dart';

import 'UserInterface/login/onboarding_APyAutos/ActualizaTuPerfil_Onboard.dart';
import 'UserInterface/login/onboarding_APyAutos/ComparteCotizaciones.dart';
import 'UserInterface/login/onboarding_APyAutos/ConoceHerramientas_ventas.dart';
import 'UserInterface/login/onboarding_APyAutos/CotizaTusNegocios.dart';
import 'UserInterface/login/onboarding_APyAutos/ap_autos.dart';
import 'UserInterface/login/principal_form_login.dart';


enum Vistas { login, home, perfil, biometricos }
enum ScreenType {phone,tabletLan, tabletPor}
bool is_available_face=false;
bool is_available_finger=false;
String ultimaSesion="";


ScreenType deviceType = ScreenType.phone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

    child: new MyApp(),
  );

  runApp(configuredApp);



  // runApp(configuredApp);
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool useMobileLayout;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Container();
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return  GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus.unfocus();
                }
              },
              child: MaterialApp(
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
                  '/cotizadorUnicoAP': (buildContext) => SeleccionaCotizadorAP(),
                  '/cotizadorUnicoAPPasoUno': (buildContext) => FormularioPaso1(),
                  '/cotizadorUnicoAPPasoTres' : (buildContext) => CotizacionVista(),
                  '/login': (context) => PrincipalFormLogin(),
                },
                title: 'App Contratacion',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.red,
                ),
                home: SplashMain(),
              ),
            );
          }
          return Container();
        }
    );

  }

}
/*
void setOrientation(Orientation sreen){
  print(""+sreen.toString());
  if(diviceType != ScreenType.phone && sreen == Orientation.landscape){
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,DeviceOrientation.portraitUp]);
  }else if(sreen == Orientation.portrait){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
*/