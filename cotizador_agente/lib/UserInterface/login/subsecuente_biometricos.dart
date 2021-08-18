
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Downloads.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController_2.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import 'logoEncabezadoLogin.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/Services/metricsPerformance.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';


String _authorized = 'Not Authorized';
bool _isAuthenticating = false;

class BiometricosPage extends StatefulWidget {
  BiometricosPage({Key key, this.responsive}) : super(key: key);
  final Responsive responsive;


  @override
  _BiometricosPage createState() => _BiometricosPage();
}

class _BiometricosPage extends State<BiometricosPage> with WidgetsBindingObserver  {
  bool showBio = false;
  bool showBio_available = false;
  bool _showFinOtro = false;
  var localAuth = new LocalAuthentication();
  bool _saving;


  @override
  void initState() {
    cancelTimerDosApps();
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);
    print("onConnectivityChanged: connectivitySubscription: biometricos $connectivitySubscription");
    if(connectivitySubscription==null) {
      print("onConnectivityChanged: biometriometricos init");
      connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        print("onConnectivityChanged:Biometricos");
        validateIntenetstatus(navigatorKey.currentContext, widget.responsive, functionConnectivity, true);
      });
    }
    showBio_available = is_available_finger;
    _saving = false;
    // TODO: implement initState
    super.initState();
    prefs.setBool("esPerfil", false);
    prefs.setBool("bloqueoDespuesSubBio", false);
    WidgetsBinding.instance.addObserver(this);
    Platform.isIOS ? getVersionApp("24", "1") : getVersionApp("24", "2");
    validateBiometricstatus(funcionCanselBiometrics);

  }
  @override
  dispose() {
    super.dispose();
  }
  void functionConnectivity() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    if(!is_available_face && !is_available_finger){
      print("face y finger");
      Inactivity(context: context).cancelInactivity();
      if(connectivitySubscription!=null) {
        connectivitySubscription.cancel();
        connectivitySubscription = null;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "Login"))).then((value) {
      });
    }else{
      if(is_available_face && is_available_finger){
        showBio = true;
      }
    }
    return WillPopScope(
      onWillPop: () async => false,
      child:Scaffold(
        body: Container(
          child: Stack(
              children: builData(widget.responsive)
          ),
        ),
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();

    data = Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        separacion(widget.responsive, 8),
        LoginEncabezadoLogin(responsive: widget.responsive),
        separacion(widget.responsive, 8),
        Center(
            child: Text(
              "¡Hola ${prefs.getString("nombreUsuario")}!",
              style: TextStyle(color: Tema.Colors.Encabezados, fontSize: widget.responsive.ip(3)),
            )),
        separacion(widget.responsive, 8),

        Container(
            margin: EdgeInsets.only(
                left: widget.responsive.wp(2),
                right: widget.responsive.wp(2)),
            child: GestureDetector(
                onTap: (){

                  _authenticateHuella(widget.responsive);

                  //if(face){}else{
                  /*if(prefs.getInt("localAuthCount")<=4){
                  _authenticateHuella(widget.responsive);
                  }else{
                    prefs.setBool("subSecuentaIngresoCorreo", true);
                    customAlert(face?AlertDialogType.inicio_de_sesion_con_facial_bloqueado:AlertDialogType.inicio_de_sesion_con_huella_bloqueado,context,"","", responsive, funcionAlerta);
                  }*/
                  // }
                },
                child:is_available_finger && is_available_face ? Image.asset("assets/login/face&figer.png", width: widget.responsive.ip(9), color: Tema.Colors.GNP,)  : is_available_finger ?  Icon(Icons.fingerprint, size: widget.responsive.ip(9), color: Tema.Colors.GNP,) :  Icon(Tema.Icons.facial, size: widget.responsive.ip(9), color: Tema.Colors.GNP,))),
        Container(
          margin: EdgeInsets.only(top: widget.responsive.hp(3), bottom: widget.responsive.hp(4), left: widget.responsive.wp(25), right: widget.responsive.wp(25)),
          child:
          Text(is_available_finger && is_available_face ? "Toca para activar el inicio de sesión con biométricos"  : is_available_finger ? "Coloca tu huella en el lector de tu dispositivo": "Mira fijamente a la cámara de tu dispositivo",
            textAlign: TextAlign.center,
            style: TextStyle(color: Tema.Colors.Funcional_Textos_Body, fontSize: widget.responsive.ip(1.5)),
          ),
        ),

        CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
              width: widget.responsive.width,
              child: Text("INGRESAR CON CONTRASEÑA", style: TextStyle(
                color: Tema.Colors.gnpOrange,
              ),
                  textAlign: TextAlign.center),
            ),
            onPressed: () async {
              //TODO 238
              prefs.setBool("bloqueoDespuesSubBio", false);
              prefs.setBool("subSecuentaIngresoCorreo", true);
              Inactivity(context: context).cancelInactivity();
              if(connectivitySubscription!=null) {
                connectivitySubscription.cancel();
                connectivitySubscription = null;
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "Login"))).then((value) {
                validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

              });
            }
        ),
        CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
              width: widget.responsive.width,
              child: Text("INGRESAR CON OTRO USUARIO", style: TextStyle(
                color: Tema.Colors.gnpOrange,
              ),
                  textAlign: TextAlign.center),
            ),
            onPressed: () async {
              prefs.setBool("esPerfil", false);
              prefs.setBool("bloqueoDespuesSubBio", false);
              prefs.setBool("userRegister", false);
              prefs.setString("contrasenaUsuario","");
              prefs.setString("correoUsuario", "");
              prefs.setBool("activarBiometricos", false);
              prefs.setBool("regitroDatosLoginExito", false);
              prefs.setBool("flujoCompletoLogin", false);
              cancelTimers();
              Inactivity(context: context).cancelInactivity();
              if(connectivitySubscription!=null) {
                connectivitySubscription.cancel();
                connectivitySubscription = null;
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "Login"))).then((value) {

              });
            }
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: responsive.hp(3.5), bottom: responsive.hp(3.5)),
            child: Text("Versión ${Tema.StringsMX.appVersion}",
              style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontSize: widget.responsive.ip(1.5),
                fontWeight: FontWeight.normal,

              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      /* var modal = Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              color: Tema.Colors.Azul_gnp,
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only( top: responsive.hp(78)),
                child: LoadingController_2(),
              ),
            ],
          )
        ],
      );*/
      var modal = LoadingController_2();
      l.add(modal);
    }
    return l;
  }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  void functionBiometrics(){
    setState(() {});

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState login $state");
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.inactive:
        print("AppLifecycleState.inactive");
        //validateIntenetBackgroundClosestatus(context, widget.responsive,functionConnectivity);
        validateBiometricstatus(functionBiometrics);
        break;
      case AppLifecycleState.resumed:
        print("AppLifecycleState.resumed");
       // validateIntenetBackgroundstatus(context, widget.responsive,functionConnectivity);
        validateIntenetstatus(navigatorKey.currentContext, widget.responsive,functionConnectivity,false);

        if(screenName!=null) {
          print("settings:biometricos ${screenName}");
          if (screenName == "Login" || screenName == "Biometricos") {
            print("settings: ${screenName}");
            Inactivity(context: context).cancelInactivity();
          } else {
            print("settings:else");
            Inactivity(context: context).backgroundTimier(functionInactivity);
          }
        }else{
          Inactivity(context: context).backgroundTimier(functionInactivity);
        }
        break;
      case AppLifecycleState.paused:
        print("AppLifecycleState.paused");
        AltSmsAutofill().unregisterListener();
        break;
      case AppLifecycleState.detached:
        print("AppLifecycleState.detached");
        break;
    }

  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }

  Future<http.Response> getVersionApp(String idApp, String idOs) async {
    print("getVersionApp");
    AppConfig _appEnvironmentConfig = AppConfig.of(context);
    bool conecxion = false;
    try{
      conecxion = await validatePinig();
    } catch(e){
      sendTag("appinter_login_error");
      conecxion = false;
    }
    print("getVersionApp ${conecxion}");
    Responsive responsive = Responsive.of(context);

    if (conecxion) {
      try {
        final response = await http
            .get('http://app.gnp.com.mx/versionapp/' + idApp + "/" + idOs);

        //TODO: Metrics
        final MetricsPerformance metricsPerformance = MetricsPerformance(
            http.Client(),
            'http://app.gnp.com.mx/versionapp/' + idApp + "/" + idOs,
            HttpMethod.Get);
        final http.Request request = http.Request(
            "VersionApp",
            Uri.parse(
                'http://app.gnp.com.mx/versionapp/' + idApp + "/" + idOs));
        metricsPerformance.send(request);

        try {
          Map mapVersion = json.decode(response.body.toString());
          String version = mapVersion["version"];
          version = version.replaceAll("_", ".");
          bool validacion =
          validateExpiration(mapVersion["fecha_publicacion"]); //
          print("validacion: $validacion");

          if (compareVersion(version, Tema.StringsMX.appVersion) &&
              validacion &&
              _appEnvironmentConfig.ambient == Ambient.prod) {
            if (!mapVersion['requerida']) {
              _showDialogoUpdateApplication(context);
            } else {
              _showDialogoUpdateApplicationRequried(context);
            }
          }
        } catch (e) {
          print("Error Version: $e");
        }
        return response;
      } catch (e) {
        print("getVersionApp catch");
        print(e);
        customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
            funcionAlerta);
      }
    } else {
     // customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlerta);
    }
  }

  void _showDialogoUpdateApplicationRequried(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: new Text("Actualización disponible.",
                  style: TextStyle(
                      color: Tema.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Existe una actualización importante para tu App Intermediario GNP.",
                  style: TextStyle(
                      color: Tema.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Descargar"),
                  onPressed: () {
                    setIsUpdateVersion();
                    _onLoading(context);
                    _launchURL(context, true);
                  },
                ),
              ],
            ));
      },
    );
  }

  void _showDialogoUpdateApplication(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: new Text("Actualización disponible.",
                  style: TextStyle(
                      color: Tema.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Te recomendamos tener instalada la versión más reciente de tu App Intermediario GNP. \n\n¡Descárgala ahora!",
                  style: TextStyle(
                      color: Tema.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Después"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                new FlatButton(
                  child: new Text("Descargar"),
                  onPressed: () {
                    setIsUpdateVersion();
                    _onLoading(context);
                    _launchURL(context, false);
                  },
                ),
              ],
            ));
      },
    );
  }

  void setIsUpdateVersion() async{
    print("setIsUpdateVersion");
    Map setIsUpdateVersion;
    try{
      String devideID = await _getId();
      print("devideID ${devideID}");
      DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();

      await _dataBaseReference.child("deviceUser").child(devideID).once().then((DataSnapshot _snapshot) {
        var jsoonn = json.encode(_snapshot.value);
        setIsUpdateVersion = json.decode(jsoonn);
        print("setIsUpdateVersion ---> ${setIsUpdateVersion}");
        if (setIsUpdateVersion != null && setIsUpdateVersion.isNotEmpty){
          Map<String, dynamic> mapa = {
            '${devideID}': {
              'version': Tema.StringsMX.appVersion,
              'requiredUpdate': false,
            }
          };
          _dataBaseReference.child("deviceUser").update(mapa);
        }else{
          Map<String, dynamic> mapa = {
            '${devideID}': {
              'version': Tema.StringsMX.appVersion,
              'requiredUpdate': true,
            }
          };
          _dataBaseReference.child("deviceUser").update(mapa);
        }
      });
    }catch(e){
      print(" setIsUpdateVersion error ${e}");
    }
  }

  Future<String> _getId() async {
    try{
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) { // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.androidId; // unique ID on Android
      }
    }catch(e){
      print(" deviceID error ${e}");
    }

  }

  void _onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _launchURL(BuildContext context, bool close) async {
    String url;
    try {
      if (Platform.isIOS) {
        url = "itms-services://?action=download-manifest&amp;url=https://app.gnp.com.mx/components/ios/Intermediariognp.plist";
        _redirectEmp(url);
      } else if (Platform.isAndroid) {
        url = "https://app.gnp.com.mx/components/android/Intermediariognp.apk";
        if (await downloadTiendaEmpresarialApk(
            url, "gnpintermediario", "apk")) {
          SystemNavigator.pop();
        } else {
          Navigator.pop(context);
        }
      } else {
        url = 'https://app.gnp.com.mx/';
        _redirectEmp(url);
      }
    } catch (e) {
      url = 'https://app.gnp.com.mx/';
      _redirectEmp(url);
    }
  }

  _redirectEmp(String url) async {
    if (await canLaunch(url)) {
      if (Platform.isIOS) {
        Future.delayed(const Duration(seconds: 5), () async {
          await launch(url);
          exit(0);
        });
      } else {
        SystemNavigator.pop();
        await launch(url);
      }
    } else {
      throw 'Could not launch $url';
    }
  }




  Future<void> _authenticateHuella(Responsive responsive) async {
    validateBiometricstatus(funcion);

    if( prefs != null && prefs.getInt("localAuthCountIOS") != null && prefs.getInt("localAuthCountIOS")>0) {
      switch(prefs.getInt("localAuthCountIOS")){
        case 100:
          customAlert(is_available_face && is_available_finger
              ? AlertDialogType.Rostro_huella_no_reconocido :
          is_available_face ? AlertDialogType.Rostro_no_reconocido
              : AlertDialogType.Huella_no_reconocida, context, "", "",
              responsive, funcionDenegadoBiometric);
          break;
        case 101:
          customAlert(is_available_face && is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado :
          is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_bloqueado:
          AlertDialogType.inicio_de_sesion_con_facial_bloqueado, context, "", "", responsive, funcionDenegadoBiometric);
          break;
        case 102:
        case 103:
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric);

          break;
        default:
          break;
      }
    }else {
      try {
        bool authenticated = false;
        if (Platform.isIOS) {
          authenticated = await localAuth.authenticateWithBiometrics(
              localizedReason: is_available_finger && is_available_face
                  ? 'Coloca tu dedo o mira fijamente a la cámara para continuar'
                  : is_available_finger
                  ? 'Coloca tu dedo para continuar'
                  : 'Mira fijamente a la cámara para continuar ',
              iOSAuthStrings: new IOSAuthMessages (
                  lockOut: 'Has superado los intentos permitidos para usar biométricos, deberás bloquear y desbloquear tu dispositivo.',
                  goToSettingsDescription:  is_available_finger
                      ? "Tu huella no está configurada en el dispositivo, ve a configuraciones para añadirla."
                      : "Tu reconocimiento facial no está configurado en el dispositivo, ve a configuraciones para añadirla.",
                  goToSettingsButton: "Ir a configuraciones",
                  cancelButton: "Cancelar"),
              useErrorDialogs: true,
              stickyAuth: false);
        } else {
          authenticated = await localAuth.authenticateWithBiometrics(
              localizedReason: is_available_finger && is_available_face
                  ? "Coloca tu dedo o mira a la cámara para continuar."
                  : is_available_finger
                  ? "Coloca tu dedo para continuar"
                  : "Mira fijamente a la cámara",
              androidAuthStrings: new AndroidAuthMessages(
                  fingerprintNotRecognized: 'Has superado los intentos permitidos para usar biométricos, deberás bloquear y desbloquear tu dispositivo.',
                  signInTitle: "Inicio de sesión",
                  fingerprintHint: '',
                  cancelButton: "Cancelar",
                  fingerprintRequiredTitle: is_available_finger && is_available_face ?
                  "Solicitud de huella digital o reconocimiento facial"
                      : is_available_finger
                      ? "Solicitud de huella digital"
                      : "Mira fijamente a la cámara",
                  goToSettingsDescription: is_available_finger && is_available_face ?
                  "Tu reconocimiento facial o tu huella no está configurada en el dispositivo, ve a configuraciones para añadirla."
                      : is_available_finger
                      ? "Tu huella no está configurada en el dispositivo, ve a configuraciones para añadirla."
                      : "Tu reconocimiento facial no está configurado en el dispositivo, ve a configuraciones para añadirla.",
                  goToSettingsButton: "Ir a configuraciones"),
              useErrorDialogs: true,
              stickyAuth: false);
        }

        if(authenticated){
          if(is_available_finger || is_available_face){
            if(is_available_face){
              sendTag("appinter_login_facial");
            }else{
              sendTag("appinter_login_huella");
            }
          }
          setState(() {
            _saving = true;
          });
          datosUsuario = await logInServices(context,prefs.getString("correoUsuario"), prefs.getString("contrasenaUsuario"), prefs.getString("correoUsuario"),responsive);
          if(datosUsuario != null){
            respuestaServicioCorreo = await  consultaUsuarioPorCorreo(context, prefs.getString("correoUsuario"));
            //Validacion Roles
            validarRolesUsuario();
            setState(() {
              _saving = false;
            });
            await consultaBitacora();
            if(_showFinOtro){
              customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, "title", "message", responsive, callback);
            }else{
              sendTag("appinter_login_ok");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        responsive: responsive,
                      ),settings: RouteSettings(name: "Home"))).then((value) {


              });
            }
          } else{


            setState(() {
              _saving = false;
            });
            //customAlert(AlertDialogType.errorServicio,context,"","", responsive, ErrorServicio);
            print("else sub Biometrios");

          }
        } else{
          sendTag("appinter_login_error");
          localAuth.stopAuthentication();
          bool localAuths = await localAuth.canCheckBiometrics;
          print("didAuthenticate not $localAuths ${prefs.getInt("localAuthCountIOS")}");

          if (!localAuths) {
            if (prefs != null && prefs.getInt("localAuthCountIOS") != null &&
                prefs.getInt("localAuthCountIOS") == 102) {
              prefs.setInt("localAuthCountIOS", 102);
              localAuth.stopAuthentication();
              is_available_finger && is_available_face ? customAlert(
                  AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "",
                  "",
                  responsive, funcionDenegadoBiometric) :
              is_available_finger ? customAlert(
                  AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
                  responsive, funcionDenegadoBiometric) :
              customAlert(
                  AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
                  responsive, funcionDenegadoBiometric);
            } else {
              prefs.setInt("localAuthCountIOS", 100);
              customAlert(is_available_face && is_available_finger
                  ? AlertDialogType.Rostro_huella_no_reconocido :
              is_available_face ? AlertDialogType.Rostro_no_reconocido
                  : AlertDialogType.Huella_no_reconocida, context, "", "",
                  responsive, funcionDenegadoBiometric);
            }
          }
        }

      } on PlatformException catch (e) {
        print("PlatformException ${e}");
        print("PlatformException: code ${e.code}");
        print("PlatformException: message ${e.message}");
        print("PlatformException: stacktrace ${e.stacktrace}");

        setState(() {
          prefs.setBool("subSecuentaIngresoCorreo", true);
        });

        if (e.code == auth_error.lockedOut) {
          print("auth_error.lockedOut");
          prefs.setInt("localAuthCountIOS", 100);
          prefs.setInt("localAuthCount", 5);
          localAuth.stopAuthentication();
          customAlert(is_available_face && is_available_finger
              ? AlertDialogType.Rostro_huella_no_reconocido :
          is_available_face ? AlertDialogType.Rostro_no_reconocido
              : AlertDialogType.Huella_no_reconocida, context, "", "",
              responsive, funcionDenegadoBiometric);
        } else if (e.code == auth_error.permanentlyLockedOut) {
          prefs.setInt("localAuthCountIOS", 101);
          print("auth_error.permanentlyLockedOut");
          prefs.setInt("localAuthCount", 6);
          localAuth.stopAuthentication();
          customAlert(is_available_face && is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado :
          is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_bloqueado :
          AlertDialogType.inicio_de_sesion_con_facial_bloqueado, context, "",
              "",
              responsive, funcionAlerta);
        } else if (e.code == auth_error.notAvailable) {
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric);
        }else if (e.code == auth_error.otherOperatingSystem ){
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "otherOperatingSystem",
              responsive, funcionDenegadoBiometric) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, funcionDenegadoBiometric);
        }
      }

    }

  }


  void consultaBitacora() async {

    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);

      print("-- response -- ${response}");
      if(response!= null && response.isNotEmpty){
        if(deviceData["id"]==response["deviceID"]){
          setState(() {
            _showFinOtro = false;
          });
        }else{
          if(response["isActive"]!= null && response["isActive"] ){
            setState(() {
              _showFinOtro = true;
            });
          }
          else{
            setState(() {
              _showFinOtro = false;
            });
          }
        }
      } else{
        setState(() {
          _showFinOtro = false;
        });
      };

    });
  }

  void ErrorServicio(){

  }

  void CallbackInactividad() {
    setState(() {});
  }

  void funcionAlerta(){
    Inactivity(context: context).cancelInactivity();
    if(connectivitySubscription!=null) {
      connectivitySubscription.cancel();
      connectivitySubscription = null;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "Login"))).then((value) {
      validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    });
  }
  void funcionCanselBiometrics(){
    setState(() {
      prefs.setBool("activarBiometricos", false);
    });
    Inactivity(context: context).cancelInactivity();
    if(connectivitySubscription!=null) {
      connectivitySubscription.cancel();
      connectivitySubscription = null;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "login"))).then((value) {

    });
  }
  void funcionDenegadoBiometric(){

  }
}
