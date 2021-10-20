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
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: 'gnp-accidentespersonales-qa',
    //urlNotifierService:'https://api-qa.oscp.gnp.com.mx',

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
    consultaPersonaIdParticipante:"https://api-qa.oscp.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-qa.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://api-qa.oscp.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
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
                  const Locale('es'), // español
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