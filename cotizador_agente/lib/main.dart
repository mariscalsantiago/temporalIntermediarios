import 'dart:async';
import 'dart:io';
import 'package:cotizador_agente/CotizadorUnico/Cotizacion.dart';
import 'package:cotizador_agente/Functions/ObserverRoute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'CotizadorUnico/FormularioPaso1.dart';
import 'CotizadorUnico/SeleccionaCotizadorAP.dart';
import 'EnvironmentVariablesSetup/app_config.dart';
import 'UserInterface/login/Splash/Splash.dart';
import 'UserInterface/login/principal_form_login.dart';
import 'UserInterface/login/subsecuente_biometricos.dart';
import 'utils/responsive.dart';

//int timerMinuts = 20;
int timerMinuts = 20;
enum Vistas { login, home, perfil, biometricos }
enum ScreenType {phone,tabletLan, tabletPor}
bool is_available_face=false;
bool is_available_finger=false;
bool showInactividad=false;
Responsive responsiveMain;
var screenName;
ScreenType deviceType = ScreenType.phone;
BuildContext dialogConnectivityContext;
BuildContext dialogMobileContext;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  var configuredApp = new AppConfig(
    ambient: Ambient.prod,
    serviceLogin: 'https://cuentas.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    service_perfilador: "https://app-inter.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: 'gnp-accidentespersonales-pro',
    // urlNotifierService:'https://api.service.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://app-inter.gnp.com.mx/COT_CF_ConsultaNegocioCanal',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-29272127-16',

    serviceBCA: 'https://bca-ws.gnp.com.mx',
    apikeyBCA: '9a780a70-c5fc-4bee-86cf-5650cce16516',

    //Preguntas Secretas
    apiKey: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    consultaPreguntasSecretas: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://app-inter.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=',
    orquestadorOTPSinSesion:'https://app-inter.gnp.com.mx/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://app-inter.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://app-inter.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://app-inter.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://gnp-accidentespersonales-uat.uc.r.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://app-inter.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-uat.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
    servicioNuevoDatosPerfil:"https://app-inter.gnp.com.mx/app/datos-perfil/",

    child: new MyApp(),

  );

  runApp(configuredApp);



  // runApp(configuredApp);
}
final navigatorKey = GlobalKey<NavigatorState>();

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
                navigatorKey: navigatorKey,
                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'), // English
                  const Locale('es'), // espa??ol
                ],
                initialRoute: '/',
                navigatorObservers: [ObserverRoute()],
                routes: {
                  '/cotizadorUnicoAP': (buildContext) => SeleccionaCotizadorAP(),
                  '/cotizadorUnicoAPPasoUno': (buildContext) => FormularioPaso1(),
                  '/cotizadorUnicoAPPasoTres' : (buildContext) => CotizacionVista(),
                  '/login': (context) => PrincipalFormLogin(),
                  '/loginBiometricos': (context) => BiometricosPage(),
                },
                title: 'Intermediario GNP',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  unselectedWidgetColor: Colors.indigo,
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