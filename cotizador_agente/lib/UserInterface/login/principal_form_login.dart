import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Downloads.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Models/CounterOTP.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnBoardingApAutos.dart';
import 'package:cotizador_agente/UserInterface/perfil/Terminos_y_condiciones.dart';
import 'package:cotizador_agente/UserInterface/perfil/condiciones_uso.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPersonaIdParticipante.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultarUsuarioPorCorreo.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginActualizarNumero.dart';
import 'loginPreguntasSecretas.dart';
import 'login_codigo_verificacion.dart';
import 'logoEncabezadoLogin.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
/*
import 'package:keyboard_visibility/keyboard_visibility.dart';
*/
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cotizador_agente/Services/metricsPerformance.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';


double tamano;
String idParticipanteValidaPorCorre;
consultaMediosContactoAgentesModel mediosContacto;
DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Map<String, dynamic> deviceData = <String, dynamic>{};
Position userLocation;
double latitude;
double longitud;

bool _validolvide = false;
String _address = "";
consultaPorCorreoNuevoServicio respuestaServicioCorreo;
Responsive _generalResponsive;
StreamSubscription<ConnectivityResult> connectivitySubscription;


final _formKeyOlvideContrasena = GlobalKey<FormState>();

class PrincipalFormLogin extends StatefulWidget {
  final Responsive responsive;
  const PrincipalFormLogin({Key key, this.responsive}) : super(key: key);
  @override
  _PrincipalFormLoginState createState() => _PrincipalFormLoginState();
}

class _PrincipalFormLoginState extends State<PrincipalFormLogin>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  bool contrasena = true;
  bool _biometricos = false;
  bool isActiveBiometric = true ;
  //TODO 238
  bool _subSecuentaIngresoCorreo = false;
  bool existeUsuario = false;
  String correoUsuario = "";
  String contrasenaUsuario = "";
  bool aceptoTerminos;
  Color colorCorreo = Tema.Colors.inputcorreo;
  bool _validEmail = true;
  bool _validPass = true;
  bool _validEmailOlvide = true;
  bool _saving = false;
  bool _enable = true;
  bool _showFinOtro = false;
  bool _ShowgetLocation = true;

  FocusNode focusCorreo = new FocusNode();
  FocusNode focusContrasena = new FocusNode();
  FocusNode focusCorreoCambio = new FocusNode();
  TextEditingController controllerContrasena = new TextEditingController();
  TextEditingController controllerCorreo = new TextEditingController();
  TextEditingController controllerCorreoCambioContrasena =
      new TextEditingController();
  final Connectivity _connectivity = Connectivity();

  GlobalKey<ScaffoldState> _key;
  //KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  bool _firstSession = true;

  @override
  void initState() {
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);
    Inactivity(context: context).cancelInactivity();
    print("onConnectivityChanged: connectivitySubscription: login $connectivitySubscription");
    if(connectivitySubscription==null) {
      print("onConnectivityChanged: connectivitySubscription: login init");
      connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        print("onConnectivityChanged: login");
        validateIntenetstatus(navigatorKey.currentContext, widget.responsive, functionConnectivity, true);
      });
    }
    initPlatformState(updateDeviceData);

    Future.delayed(Duration.zero, () {
      arranque();
    });
    cancelTimers();
    super.initState();
  }
  @override
  dispose() {
    print("connectivitySubscription: principal");
    super.dispose();
  }
  void functionConnectivity() {
    setState(() {});
  }

  void functionBiometrics(){
    setState(() {});

  }
  void bloqueTemporal() {
    Navigator.pop(context);
  }

  void arranque() async {
    isActiveBiometric = await validSystemDevice();
    Platform.isIOS ? getVersionApp("24", "1") : getVersionApp("24", "2");
    controllerCorreoCambioContrasena.text = prefs.getString("correoUsuario");
    WidgetsBinding.instance.addObserver(this);
    prefs.setBool("esPerfil", false);
    prefs.setBool("actualizarContrasenaPerfil", false);
    prefs.setBool("esActualizarNumero", false);

    if (prefs != null && prefs.getBool("userRegister") != null) {
      if (prefs.getBool("userRegister")) {
        print("if userRegister");
        prefs.setBool("seHizoLogin", true);
        existeUsuario = true;
        if (prefs.getBool("bloqueoDespuesSubBio") != null &&
            prefs.getBool("bloqueoDespuesSubBio")) {
          print("1 activarBiometricos");
          prefs.setBool("activarBiometricos", false);
          _biometricos = false;
        } else if (prefs.getBool("subSecuentaIngresoCorreo") != null &&
            prefs.getBool("subSecuentaIngresoCorreo")) {
          print("2 activarBiometricos");
          prefs.setBool("activarBiometricos", true);
          _biometricos = true;
        } else {
          print("3 activarBiometricos");
          _biometricos = prefs.getBool("activarBiometricos");
        }
        //TODO 238
        _subSecuentaIngresoCorreo = prefs.getBool("subSecuentaIngresoCorreo");
        prefs.setBool("primeraVez", false);
      } else {
        print("else userRegister");
        prefs.setBool("seHizoLogin", false);
        _biometricos = false;
        existeUsuario = false;
        prefs.setBool("activarBiometricos", _biometricos);
        prefs.setString("contrasenaUsuario", "");
        prefs.setString("correoUsuario", "");
        prefs.setBool("primeraVez", true);
        prefs.setString("nombreUsuario", "");
      }
    } else {
      print("else - userRegister");
      prefs.setBool("seHizoLogin", false);
      _biometricos = false;
      aceptoTerminos = false;
      prefs.setBool("activarBiometricos", _biometricos);
      prefs.setBool("aceptoTerminos", aceptoTerminos);
      existeUsuario = false;
      prefs.setBool("primeraVez", true);
    }

    try {
      _ShowgetLocation = prefs.getBool("ShowgetLocation");
      if(_ShowgetLocation!=null){}else{_ShowgetLocation=true;}
    }catch(e){
      _ShowgetLocation = true;
      print(e);
    }
    //if(_ShowgetLocation){
     // _permissionRequest();
    _getLocation().then((position) {
      //TODO null
      try{
        userLocation = position;
        latitude = userLocation.latitude;
        longitud = userLocation.longitude;
        _getPlace();
      }catch(e){
        print("error en position Login");
        setState(() {});
        print(e);
      }



      });
  //}
    //canceltimer();

    focusCorreo.addListener(() {
      setState(() {
        if (controllerCorreo.text.contains(" ")) {
          String email = controllerCorreo.text.trimRight();
          String emailReplace = email.trimLeft();
          controllerCorreo.text =
              emailReplace.replaceAll(new RegExp(r"\s+"), "");
          _validEmail = _formKey.currentState.validate();
        }

        if (controllerCorreo.text.contains("á")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'á'), 'a');
        }
        if (controllerCorreo.text.contains("Á")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'Á'), 'A');
        }

        if (controllerCorreo.text.contains("é")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'é'), 'e');
        }

        if (controllerCorreo.text.contains("É")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'É'), 'E');
        }

        if (controllerCorreo.text.contains("í")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'í'), 'i');
        }

        if (controllerCorreo.text.contains("Í")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'Í'), 'I');
        }

        if (controllerCorreo.text.contains("ó")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'ó'), 'o');
        }

        if (controllerCorreo.text.contains("Ó")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'Ó'), 'O');
        }

        if (controllerCorreo.text.contains("ú")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'ú'), 'u');
        }

        if (controllerCorreo.text.contains("Ú")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'Ú'), 'U');
        }

        if (controllerCorreo.text.contains("ü")) {
          controllerCorreo.text =
              controllerCorreo.text.replaceAll(RegExp(r'ü'), 'u');
        }

        if (controllerCorreo.text.contains("Ü")) {
          controllerCorreo.text = controllerCorreo.text.replaceAll(RegExp(r'Ü'), 'U');
        }
      });
    });

    focusContrasena.addListener(() {
      if (controllerContrasena.text.contains(" ")) {
        String password = controllerContrasena.text.trimRight();
        String passwordReplace = password.trimLeft();
        controllerContrasena.text = passwordReplace.replaceAll(new RegExp(r"\s+"), "");
        _validPass = _formKeyPass.currentState.validate();
        setState(() {});
      }
    });

    focusCorreoCambio.addListener(() {
      setState(() {
        if (controllerCorreoCambioContrasena.text.contains(" ")) {
          String email = controllerCorreoCambioContrasena.text.trimRight();
          String emailReplace = email.trimLeft();
          controllerCorreoCambioContrasena.text =
              emailReplace.replaceAll(new RegExp(r"\s+"), "");
          _validEmailOlvide = _formKeyOlvideContrasena.currentState.validate();
        }

        if (controllerCorreoCambioContrasena.text.contains("á")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'á'), 'a');
        }
        if (controllerCorreoCambioContrasena.text.contains("Á")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'Á'), 'A');
        }

        if (controllerCorreoCambioContrasena.text.contains("é")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'é'), 'e');
        }

        if (controllerCorreoCambioContrasena.text.contains("É")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'É'), 'E');
        }

        if (controllerCorreoCambioContrasena.text.contains("í")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'í'), 'i');
        }

        if (controllerCorreoCambioContrasena.text.contains("Í")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'Í'), 'I');
        }

        if (controllerCorreoCambioContrasena.text.contains("ó")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'ó'), 'o');
        }

        if (controllerCorreoCambioContrasena.text.contains("Ó")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'Ó'), 'O');
        }

        if (controllerCorreoCambioContrasena.text.contains("ú")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'ú'), 'u');
        }

        if (controllerCorreoCambioContrasena.text.contains("Ú")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'Ú'), 'U');
        }

        if (controllerCorreoCambioContrasena.text.contains("ü")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'ü'), 'u');
        }

        if (controllerCorreoCambioContrasena.text.contains("Ü")) {
          controllerCorreoCambioContrasena.text =
              controllerCorreoCambioContrasena.text
                  .replaceAll(RegExp(r'Ü'), 'U');
        }
      });
    });
  }

  ReloadCounter(){
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState login $state");
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.inactive:
       // validateIntenetBackgroundClosestatus(context, widget.responsive,functionConnectivity);
        print("AppLifecycleState.inactive");
        break;
      case AppLifecycleState.resumed:
        print("AppLifecycleState.resumed");
        validateIntenetstatus(navigatorKey.currentContext, widget.responsive,functionConnectivity,false);
        if(screenName!=null) {
          print("settings:login ${screenName}");
          if (screenName == "Login" || screenName == "Biometricos") {
            print("settings: ${screenName}");
            Inactivity(context: context).cancelInactivity();
          } else {
            print("settings:else");
            Inactivity(context: context).backgroundTimier(functionInactivity);
          }
        }else{
          print("settings: null");
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


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
        key: _key,
    body:  Stack(children: builData(widget.responsive))),
      ),
    );
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();

    data = SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          separacion(responsive, 8),
          LoginEncabezadoLogin(responsive: responsive),
          separacion(responsive, 4),
          subtitulo(responsive),
          Form(
              key: _formKey,
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: responsive.width * 0.05),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            separacion(responsive, 6),
                            existeUsuario
                                ? Container()
                                : inputTextCorreo(responsive),
                            separacion(responsive, 2),
                          ])))),
          Form(
              key: _formKeyPass,
              child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: responsive.width * 0.05),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        inputTextContrasena(responsive),
                        separacion(responsive, 2),
                        olvidasteContrasena(responsive),
                      ]))),
          existeUsuario ? separacion(responsive, 6) : separacion(responsive, 2),
          Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.width * 0.05),
              child: botonInicioSesion(responsive)),
          separacion(responsive, 1),
          is_available_finger || is_available_face || (prefs != null && prefs.get("localAuthCount") == 100)
              ? activarHuella(responsive)
              : Container(
                  height: 10,
                  width: 10,
                ),
          separacion(responsive, 1),
          existeUsuario ? ingresarConOtroUsuario() : Container(),
          separacion(responsive, 1),
          version(responsive)
        ]));

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [LoadingController()],
      );
      l.add(modal);
    }
    return l;
  }

  Widget subtitulo(Responsive responsive) {
    return existeUsuario != null && existeUsuario
        ? Text(
            prefs.getString("nombreUsuario") != null &&
                    prefs.getString("nombreUsuario") != ""
                ? "¡Hola ${prefs.getString("nombreUsuario")}!"
                : "¡Hola !",
            style: TextStyle(
                color: Tema.Colors.Azul_gnp,
                fontWeight: FontWeight.normal,
                fontSize: responsive.ip(3.4)),
            textAlign: TextAlign.center,
          )
        : Text(
            "Intermediario GNP\n ¡Te damos la bienvenida!",
            style: TextStyle(
                color: Tema.Colors.Azul_gnp,
                fontWeight: FontWeight.normal,
                fontSize: responsive.ip(3.4)),
            textAlign: TextAlign.center,
          );
  }

  Widget inputTextCorreo(Responsive responsive) {
    return Focus(
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(
              RegExp("[A-Z a-z0-9-_@.ñÑáÁéÉíÍóÓúÚüÜ]")),
          // FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@.ñÑ]]")),
        ],
        keyboardType: TextInputType.emailAddress,
        controller: controllerCorreo,
        focusNode: focusCorreo,
        onFieldSubmitted: (s) {
          print("onFieldSubmitted $s $_validEmail $_validPass");
          FocusScope.of(context).requestFocus(focusContrasena);
          if (controllerCorreo.text.contains(" ")) {
            String email = controllerCorreo.text.trimRight();
            String emailReplace = email.trimLeft();
            controllerCorreo.text =
                emailReplace.replaceAll(new RegExp(r"\s+"), "");
          }

          if (controllerCorreo.text.contains("á")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'á'), 'a');
          }
          if (controllerCorreo.text.contains("Á")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'Á'), 'A');
          }

          if (controllerCorreo.text.contains("é")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'é'), 'e');
          }

          if (controllerCorreo.text.contains("É")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'É'), 'E');
          }

          if (controllerCorreo.text.contains("í")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'í'), 'i');
          }

          if (controllerCorreo.text.contains("Í")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'Í'), 'I');
          }

          if (controllerCorreo.text.contains("ó")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'ó'), 'o');
          }

          if (controllerCorreo.text.contains("Ó")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'Ó'), 'O');
          }

          if (controllerCorreo.text.contains("ú")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'ú'), 'u');
          }

          if (controllerCorreo.text.contains("Ú")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'Ú'), 'U');
          }

          if (controllerCorreo.text.contains("ü")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'ü'), 'u');
          }

          if (controllerCorreo.text.contains("Ü")) {
            controllerCorreo.text =
                controllerCorreo.text.replaceAll(RegExp(r'Ü'), 'U');
          }
        },
        obscureText: false,
        enabled: _enable,
        cursorColor: _validEmail ? Tema.Colors.GNP : Tema.Colors.validarCampo,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
            errorStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(1.2),
              color: _validEmail
                  ? Tema.Colors.inputcorreo
                  : Tema.Colors.validarCampo,
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.validarCampo, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.inputlinea),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      _validEmail ? Tema.Colors.GNP : Tema.Colors.validarCampo,
                  width: 2),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _validEmail
                      ? Tema.Colors.inputlinea
                      : Tema.Colors.validarCampo,
                  width: 2),
            ),
            labelText: "Correo electrónico",
            labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: _validEmail
                  ? focusCorreo.hasFocus
                      ? Tema.Colors.GNP
                      : Tema.Colors.inputcorreo
                  : Tema.Colors.validarCampo,
            )),
        validator: (value) {
          print("validator $value");
          String result = value.trim();
          String p =
              //"^[ñÑa-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
              //"^[a-zA-Z0-9.!#\$%&ñÑ'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = new RegExp(p);

          String message;

          if (result.isEmpty) {
            message = 'Este campo es requerido';
          } else if (regExp.hasMatch(result)) {
            if (value.contains(" ")) {
              return 'No debe tener espacios en blanco';
            } else {
              message = null;
            }
          } else if (value.contains(" ")) {
            message = 'No debe tener espacios en blanco';
          } else {
            message = 'Este campo es inválido';
          }

          return message;
        },
        onChanged: (value) {
          print("onChanged $value $_validEmail $_validPass");
          _validEmail = _formKey.currentState.validate();
          setState(() {});
        },
      ),
      onFocusChange: (hasFocus) {
        print("hasFocus $hasFocus $_validEmail $_validPass");
        _validEmail = _formKey.currentState.validate();
        focusCorreoCambio.unfocus();

        setState(() {});
      },
    );
  }

  Widget inputTextContrasena(Responsive responsive) {
    return Focus(
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
        ],
        onFieldSubmitted: (s) {
          print("onFieldSubmitted:contraseña $s $_validEmail $_validPass");
          if (controllerContrasena.text.contains(" ")) {
            String password = controllerContrasena.text.trimRight();
            String passwordReplace = password.trimLeft();
            controllerContrasena.text =
                passwordReplace.replaceAll(new RegExp(r"\s+"), "");
          }
        },
        controller: controllerContrasena,
        focusNode: focusContrasena,
        obscureText: contrasena,
        keyboardType: TextInputType.visiblePassword,
        enabled: true,
        cursorColor: _validPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: new InputDecoration(
            errorStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(1.2),
              color: Tema.Colors.validarCampo,
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.validarCampo, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _validPass
                      ? Tema.Colors.inputlinea
                      : Tema.Colors.validarCampo),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      _validPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
                  width: 2),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _validPass
                      ? Tema.Colors.inputlinea
                      : Tema.Colors.validarCampo,
                  width: 2),
            ),
            labelText: "Contraseña",
            labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: _validPass
                  ? focusContrasena.hasFocus
                      ? Tema.Colors.GNP
                      : Tema.Colors.inputcorreo
                  : Tema.Colors.validarCampo,
            ),
            suffixIcon: IconButton(
              icon: contrasena
                  ? _validPass
                      ? Image.asset("assets/login/novercontrasena.png")
                      : Image.asset("assets/login/_icon_error_contrasena.png")
                  : _validPass
                      ? Image.asset("assets/login/vercontrasena.png")
                      : Image.asset("assets/login/_icono-withmask.png"),
              color: Tema.Colors.validarCampo,
              onPressed: () {
                setState(() {
                  contrasena = !contrasena;
                });
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Este campo es requerido';
          } else if (value.contains(" ")) {
            return 'No debe tener espacios en blanco';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          _validPass = _formKeyPass.currentState.validate();
          setState(() {});
        },
      ),
      onFocusChange: (hasFocus) {
        print("hasFocus $hasFocus $_validEmail $_validPass");
        _validPass = _formKeyPass.currentState.validate();
        setState(() {});
      },
    );
  }

  Widget olvidasteContrasena(Responsive responsive) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text("¿Olvidaste tu contraseña?",
            style: TextStyle(
              color: Tema.Colors.GNP,
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2.3),
            )),
        onPressed: () {
          if (controllerCorreo.text != "") {
            correoUsuario = controllerCorreo.text;
            controllerCorreoCambioContrasena.text = correoUsuario;
          } else {
            controllerCorreoCambioContrasena.text =
                prefs.getString("correoUsuario");
          }

          focusContrasena.unfocus();
          focusCorreo.unfocus();
          focusCorreoCambio.requestFocus();
          dialogo(context, responsive).then((value) {
            _validEmailOlvide = true;
            setState(() {});
          });
        });
  }

  Future<dynamic> dialogo(BuildContext context, Responsive responsive) {
    _generalResponsive = Responsive.of(context);
    if (Platform.isIOS) {
      tamano = MediaQuery.of(context).viewInsets.bottom + 40;
    } else {
      tamano = MediaQuery.of(context).viewInsets.bottom + 20;
    }
    //tamano = _generalResponsive.hp(57);

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
                onWillPop: () {
                  setState(() {
                    //Navigator.pop(context);
                    if (Platform.isIOS) {
                      tamano = MediaQuery.of(context).viewInsets.bottom + 40;
                    } else {
                      tamano = MediaQuery.of(context).viewInsets.bottom + 20;
                    }
                    focusCorreoCambio.unfocus();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                child: Stack(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Opacity(
                      opacity: 0.6,
                      child: Container(
                        height: _generalResponsive.height,
                        width: _generalResponsive.width,
                        color: Tema.Colors.Azul_gnp,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: focusCorreoCambio.hasFocus
                            ? MediaQuery.of(context).size.height / 2 -
                                MediaQuery.of(context)
                                    .viewInsets
                                    .bottom // adjust values according to your need
                            : MediaQuery.of(context).size.height / 2),
                    height: _generalResponsive.hp(50),
                    width: _generalResponsive.width,
                    child: Card(
                      color: Tema.Colors.White,
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: _generalResponsive.height * 0.03),
                            child: Center(
                              child: Text(
                                "Olvidé contraseña",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Tema.Colors.Encabezados,
                                    fontSize: _generalResponsive.ip(2.3)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: _generalResponsive.height * 0.05,
                                bottom: _generalResponsive.height * 0.04,
                                right: _generalResponsive.wp(1),
                                left: _generalResponsive.wp(5)),
                            child: Text(
                              "Por tu seguridad es necesario que ingreses nuevamente tu correo electrónico.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Tema.Colors.Funcional_Textos_Body,
                                  fontSize: _generalResponsive.ip(2.0)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                left: _generalResponsive.wp(4),
                                right: _generalResponsive.wp(4),
                                bottom: _generalResponsive.hp(2),
                              ),
                              child: Form(
                                key: _formKeyOlvideContrasena,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        "[A-Z a-z0-9-_@.ñÑáÁéÉíÍóÓúÚüÜ]")),
                                    LengthLimitingTextInputFormatter(50),
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controllerCorreoCambioContrasena,
                                  focusNode: focusCorreoCambio,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onEditingComplete: () {
                                    setState(() {
                                      tamano = _generalResponsive.hp(57);
                                      focusCorreoCambio.unfocus();
                                    });
                                  },
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      if (controllerCorreoCambioContrasena.text
                                          .contains(" ")) {
                                        String email =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .trimRight();
                                        String emailReplace = email.trimLeft();
                                        controllerCorreoCambioContrasena.text =
                                            emailReplace.replaceAll(
                                                new RegExp(r"\s+"), "");
                                        _validEmailOlvide =
                                            _formKeyOlvideContrasena
                                                .currentState
                                                .validate();
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("á")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'á'), 'a');
                                      }
                                      if (controllerCorreoCambioContrasena.text
                                          .contains("Á")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'Á'), 'A');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("é")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'é'), 'e');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("É")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'É'), 'E');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("í")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'í'), 'i');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("Í")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'Í'), 'I');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("ó")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'ó'), 'o');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("Ó")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'Ó'), 'O');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("ú")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'ú'), 'u');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("Ú")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'Ú'), 'U');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("ü")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'ü'), 'u');
                                      }

                                      if (controllerCorreoCambioContrasena.text
                                          .contains("Ü")) {
                                        controllerCorreoCambioContrasena.text =
                                            controllerCorreoCambioContrasena
                                                .text
                                                .replaceAll(RegExp(r'Ü'), 'U');
                                      }
                                    });
                                  },
                                  obscureText: false,
                                  enabled: _enable,
                                  cursorColor: _validEmailOlvide
                                      ? Tema.Colors.GNP
                                      : Tema.Colors.validarCampo,
                                  decoration: new InputDecoration(
                                      errorStyle: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.normal,
                                        fontSize: responsive.ip(1.2),
                                        color: Tema.Colors.validarCampo,
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Tema.Colors.validarCampo,
                                            width: 2),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Tema.Colors.inputlinea),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _validEmailOlvide
                                                ? Tema.Colors.GNP
                                                : Tema.Colors.validarCampo,
                                            width: 2),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: _validEmailOlvide
                                                ? Tema.Colors.inputlinea
                                                : Tema.Colors.validarCampo,
                                            width: 2),
                                      ),
                                      labelText: "Correo electrónico",
                                      labelStyle: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.normal,
                                        fontSize: _generalResponsive.ip(1.7),
                                        color: _validEmailOlvide
                                            ? focusCorreoCambio.hasFocus
                                                ? Tema.Colors.GNP
                                                : Tema.Colors.inputcorreo
                                            : Tema.Colors.validarCampo,
                                      )),
                                  validator: (value) {
                                    String result = value.trim();
                                    String p =
                                        //"^[ñÑa-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
                                        //"^[a-zA-Z0-9.!#\$%&ñÑ'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regExp = new RegExp(p);

                                    String message = "";

                                    if (result.isEmpty) {
                                      message = 'Este campo es requerido';
                                    } else if (regExp.hasMatch(result)) {
                                      if (value.contains(" ")) {
                                        return 'No debe tener espacios en blanco';
                                      } else {
                                        message = null;
                                      }
                                    } else if (value.contains(" ")) {
                                      message =
                                          'No debe tener espacios en blanco';
                                    } else {
                                      message = 'Este campo es inválido';
                                    }

                                    return message;
                                  },
                                  onTap: () {
                                    _validEmailOlvide = _formKeyOlvideContrasena
                                        .currentState
                                        .validate();
                                    setState(() {
                                      //controllerCorreoCambioContrasena.text;
                                      //focusCorreo.unfocus();
                                      //focusCorreoCambio.requestFocus();
                                      // focusContrasena.unfocus();
                                      tamano = _generalResponsive.hp(30);
                                    });
                                    setState(() {
                                      tamano;
                                      print("tamano ${tamano}");
                                    });
                                  },
                                  onChanged: (s) {
                                    _validEmailOlvide = _formKeyOlvideContrasena
                                        .currentState
                                        .validate();
                                    setState(() {
                                      print(
                                          "correo ------------- > ${controllerCorreoCambioContrasena.text}");

                                      try {
                                        if (controllerCorreoCambioContrasena
                                                .text.isNotEmpty &&
                                            controllerCorreoCambioContrasena
                                                    .text.length >=
                                                50) {
                                          controllerCorreoCambioContrasena
                                                  .text =
                                              controllerCorreoCambioContrasena
                                                  .text
                                                  .substring(0, 49);
                                          focusCorreoCambio.unfocus();
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    });
                                  },
                                ),
                              )),
                          Container(
                            height: _generalResponsive.hp(6.25),
                            width: _generalResponsive.wp(90),
                            margin: EdgeInsets.only(
                                top: _generalResponsive.height * 0.05,
                                left: _generalResponsive.wp(4.4),
                                right: _generalResponsive.wp(4.4),
                                bottom: _generalResponsive.height * 0.01),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: controllerCorreoCambioContrasena.text != ""
                                  ? Tema.Colors.GNP
                                  : Tema.Colors.botonlogin,
                              onPressed: () async {
                                if (_formKeyOlvideContrasena.currentState
                                    .validate()) {
                                  Navigator.pop(context);

                                  prefs.setBool("seActualizarNumero", false);
                                  validarCodigoVerificacion(_generalResponsive);
                                }
                              },
                              child: Text(
                                "ACEPTAR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      controllerCorreoCambioContrasena.text !=
                                              ""
                                          ? Tema.Colors.White
                                          : Tema.Colors.botonletra,
                                  fontSize: _generalResponsive.ip(2.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ]));
          },
        );
      },
    );
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

      }
    }
  }

  validarCodigoVerificacion(Responsive responsive) async {
    setState(() {
      _saving = true;
    });
    prefs.setBool('flujoOlvideContrasena', true);
    prefs.setString(
        "correoCambioContrasena", controllerCorreoCambioContrasena.text);
    consultaPorCorreoNuevoServicio respuesta = await consultaUsuarioPorCorreo(
        context, prefs.getString("correoCambioContrasena"));

    print("UsuarioPorCorreo ${respuesta}");
    bool conecxion = false;
    try{
      conecxion = await validatePinig();
    } catch(e){
      sendTag("appinter_login_error");
      conecxion = false;
    }
    print("UsuarioPorCorreo ${conecxion}");
    if (conecxion) {
      try {
        if (respuesta != null) {
          if (respuesta != null && respuesta.idParticipante != null && respuesta.idParticipante != "") {
            //print("UsuarioPorCorreo if1");
            if (respuesta.idParticipante != "") {
              // print("UsuarioPorCorreo if2");
              idParticipanteValidaPorCorre = respuesta.uid;

              mediosContacto = await consultaMediosContactoServicio(
                  context, idParticipanteValidaPorCorre);

              if (mediosContacto != null) {
                // print("UsuarioPorCorreo if3");
                prefs.setString(
                    "codigoAfiliacion", mediosContacto.codigoFiliacion);
                List<telefonosModel> teledonosLista = [];
                teledonosLista = obtenerMedioContacto(mediosContacto);
                if (teledonosLista.length > 0) {
                  // print("UsuarioPorCorreo if4");
                  prefs.setString("medioContactoTelefono",
                      teledonosLista[0].lada + teledonosLista[0].valor);
                } else {
                  //print("UsuarioPorCorreo else1");
                  prefs.setString("medioContactoTelefono", "");
                }
              } else {
                //print("UsuarioPorCorreo else2");
                prefs.setString("medioContactoTelefono", "");
                ConsultarPorIdParticipanteConsolidado consulta =
                    await ConsultarPorIdParticipanteServicio(
                        context, idParticipanteValidaPorCorre);
                if (consulta != null) {
                  String codigoAfiliacion = consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.sistemasOrigen.sistemaOrigen.valorSistemaOrigen.valor;
                  if(codigoAfiliacion != null){
                    print("codigoAfiliacion if ${codigoAfiliacion}");
                    prefs.setString("codigoAfiliacion", codigoAfiliacion);
                  } else {
                    List<ValorSistemaOrigen> listCodigosAfiliacion = consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.sistemasOrigen.sistemaOrigen.valorSistemaOrigenList;
                    print("codigoAfiliacion else ${listCodigosAfiliacion.length}");
                    for(int i =0; i < listCodigosAfiliacion.length; i++){
                      if(listCodigosAfiliacion[i].banPadre){
                        prefs.setString("codigoAfiliacion", listCodigosAfiliacion[i].valor);
                        break;
                      }
                    }
                  }
                }
              }
              setState(() {
                _saving = true;
              });

              OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
                  context,
                  prefs.getString("correoCambioContrasena"),
                  prefs.getString("medioContactoTelefono") != null
                      ? prefs.getString("medioContactoTelefono")
                      : "",
                  prefs.getBool('flujoOlvideContrasena'));

              setState(() {
                _saving = false;
              });

              print("optRespuesta  ${optRespuesta}");

              if (optRespuesta != null) {
                //print("UsuarioPorCorreo if6");
                if (optRespuesta.error == "" && optRespuesta.idError == "") {
                  //print("UsuarioPorCorreo if7");
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginCodigoVerificaion(
                                responsive: responsive,
                                isNumero: false,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();

                  });
                } else {
                  if(optRespuesta.idError == "015"){
                    customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
                        responsive, funcionAlerta);
                  } else{
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcionAlerta);
                  }

                }
              } else {
                //print("UsuarioPorCorreo else5");
                customAlert(AlertDialogType.errorServicio, context, "", "",
                    responsive, funcionAlerta);
              }
            } else {
              // print("UsuarioPorCorreo else6");
              setState(() {
                _saving = false;
              });
              customAlert(AlertDialogType.Correo_no_registrado, context, "", "",
                  responsive, funcionAlerta);
            }
          }
          else {
            //TODO validar nuevo servicio
            setState(() {
              _saving = false;
            });
            if (respuesta.requestId != null) {
              //print("UsuarioPorCorreo if8");
              if (respuesta.requestId != "") {
                //print("UsuarioPorCorreo if9");
                customAlert(AlertDialogType.Correo_no_registrado, context, "", "", responsive, funcionAlerta);
              }
            }
          }
        } else {
          //print("UsuarioPorCorreo else8");
          setState(() {
            _saving = false;
          });
          customAlert(AlertDialogType.errorServicio, context, "", "",
              responsive, funcionAlerta);
        }
      } catch (e) {
        print("UsuarioPorCorreo catch");
        print(e);
        setState(() {
          _saving = false;
        });
        customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
            funcionAlerta);
      }
    } else {
      print("UsuarioPorCorreo sin coneccion");
      setState(() {
        _saving = false;
      });
      customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, funcionAlerta);
    }
  }

  Widget botonInicioSesion(Responsive responsive) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: (controllerContrasena.text != "" &&
                        controllerCorreo.text != "") ||
                    (existeUsuario && controllerContrasena.text != "")
                ? Tema.Colors.GNP
                : Tema.Colors.botonlogin,
          ),
          padding:
              EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
          width: responsive.width,
          child: Text("INICIAR SESIÓN",
              style: TextStyle(
                color: (controllerContrasena.text != "" &&
                            controllerCorreo.text != "") ||
                        (existeUsuario && controllerContrasena.text != "")
                    ? Tema.Colors.backgroud
                    : Tema.Colors.botonletra,
              ),
              textAlign: TextAlign.center),
        ),
        onPressed: () async {
          prefs.setBool("esPerfil", false);

          _validEmail = _formKey.currentState.validate();
          _validPass = _formKeyPass.currentState.validate();
          setState(() {});

          if (!_saving) {
            if (_formKey.currentState.validate() && _formKeyPass.currentState.validate()) {

              FocusScope.of(context).requestFocus(new FocusNode());

              setState(() {
                _saving = true;
                _enable = false;
              });

              if (prefs.getString("correoUsuario") != null && prefs.getString("correoUsuario") != "") {

                correoUsuario = prefs.getString("correoUsuario");
                print("controllerContrasena.text ${controllerContrasena.text} ${correoUsuario}");

                if (controllerContrasena.text != null && controllerContrasena.text.isNotEmpty && controllerContrasena.text != prefs.getString("contrasenaUsuario")) {
                  print("if ---");
                  contrasenaUsuario = controllerContrasena.text;
                  //prefs.setString("contrasenaUsuario", contrasenaUsuario);
                } else {
                  print("else -----");
                  contrasenaUsuario = prefs.getString("contrasenaUsuario");
                }

                if (controllerCorreo.text != null && controllerCorreo.text.isNotEmpty) {
                  print("if ---");
                  correoUsuario = controllerCorreo.text;
                  prefs.setString("correoUsuario", controllerCorreo.text);
                } else {
                  print("else -----");
                  correoUsuario = prefs.getString("correoUsuario");
                }

              } else {
                print("else correoUsuario");

                prefs.setString("correoUsuario", controllerCorreo.text);
                correoUsuario = controllerCorreo.text;

                prefs.setString("contrasenaUsuario", controllerContrasena.text);
                contrasenaUsuario = controllerContrasena.text;

              }

              datosUsuario = await logInServices(context, correoUsuario, contrasenaUsuario, correoUsuario, responsive);

              if (datosUsuario != null) {
                prefs.setString("contrasenaUsuario", contrasenaUsuario);
                respuestaServicioCorreo = await consultaUsuarioPorCorreo(context, correoUsuario);
                if(respuestaServicioCorreo == null){
                  customAlert(AlertDialogType.errorServicio, context, "", "", responsive, funcion);
                }

              }

              if (datosUsuario != null && respuestaServicioCorreo != null && respuestaServicioCorreo !=null && respuestaServicioCorreo.estatus !=null && respuestaServicioCorreo.estatus == "Activo") {
                //Roles
                validarRolesUsuario();
                //Medio de contacto
                mediosContacto = await consultaMediosContactoServicio(context, datosUsuario.idparticipante);


                if (mediosContacto != null) {
                  prefs.setString("codigoAfiliacion", mediosContacto.codigoFiliacion);
                  List<telefonosModel> teledonosLista = [];
                  teledonosLista = obtenerMedioContacto(mediosContacto);

                  if (teledonosLista.length > 0) {
                    prefs.setString("medioContactoTelefono", teledonosLista[0].lada + teledonosLista[0].valor);
                    print("Medios contacto ${prefs.getString("medioContactoTelefono")}");
                  } else {
                    prefs.setString("medioContactoTelefono", "");
                  }
                } else {
                  print("--> ConsultarPorIdParticipanteConsolidado");
                  prefs.setString("medioContactoTelefono", "");
                  ConsultarPorIdParticipanteConsolidado consulta = await ConsultarPorIdParticipanteServicio(context, datosUsuario.idparticipante);

                  if (consulta != null) {
                    String codigoAfiliacion = consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.sistemasOrigen.sistemaOrigen.valorSistemaOrigen.valor;
                    if(codigoAfiliacion != null){
                      print("codigoAfiliacion if ${codigoAfiliacion}");
                      prefs.setString("codigoAfiliacion", codigoAfiliacion);
                    } else {
                      List<ValorSistemaOrigen> listCodigosAfiliacion = consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.sistemasOrigen.sistemaOrigen.valorSistemaOrigenList;
                      print("codigoAfiliacion else ${listCodigosAfiliacion.length}");
                      for(int i =0; i < listCodigosAfiliacion.length; i++){
                        if(listCodigosAfiliacion[i].banPadre){
                          prefs.setString("codigoAfiliacion", listCodigosAfiliacion[i].valor);
                          break;
                        }
                      }
                    }
                  }
                }

                if (!existeUsuario) {
                  consultaPreguntasSecretasModel preguntas = await consultarPreguntaSecretaServicio(context, datosUsuario.idparticipante);

                  setState(() {
                    _saving = false;
                    _enable = true;
                  });

                  if (preguntas != null) {
                    if (preguntas.requestStatus == "FAILED" && preguntas.error != "") {
                      prefs.setBool('primeraVezIntermediario', true);
                    } else {
                      prefs.setBool('primeraVezIntermediario', false);
                    }
                  }
                } else {

                  consultaPreguntasSecretasModel preguntas = await consultarPreguntaSecretaServicio(context, datosUsuario.idparticipante);

                  setState(() {
                    _saving = false;
                    _enable = true;
                  });

                  if (preguntas != null) {
                    if (preguntas.requestStatus == "FAILED" && preguntas.error != "") {
                      prefs.setBool('primeraVezIntermediario', true);
                    } else {
                      prefs.setBool('primeraVezIntermediario', false);
                    }
                  }
                }

                prefs.setBool("seHizoLogin", true);
                prefs.setBool("regitroDatosLoginExito", true);
                prefs.setString("nombreUsuario", respuestaServicioCorreo.primerApellido != null && respuestaServicioCorreo.nombre != null ? respuestaServicioCorreo.nombre : "");
                prefs.setString("currentDA", datosPerfilador.daList.length > 0 ? datosPerfilador.daList.elementAt(0).cveDa : "");
                prefs.setString("currentCUA", datosPerfilador.daList.length > 0 ? datosPerfilador.daList.elementAt(0).codIntermediario[0] : "");

                redirect(responsive);
              } else {
                setState(() {
                  _saving = false;
                  _enable = true;
                });

                if (prefs.getBool("regitroDatosLoginExito") != null && prefs.getBool("regitroDatosLoginExito")) {

                } else if (respuestaServicioCorreo != null &&  respuestaServicioCorreo != null && respuestaServicioCorreo.estatus !=null && respuestaServicioCorreo.estatus != "Activo") {
                  if(datosUsuario!=null) {
                    customAlert(AlertDialogType.Cuenta_inactiva, context, "", "", responsive, funcionAlertaHullaLogin);
                  }
                  prefs.setBool("regitroDatosLoginExito", false);
                  prefs.setString("nombreUsuario", "");
                  prefs.setString("correoUsuario", "");
                  prefs.setString("contrasenaUsuario", "");
                } else {
                  //customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
                  prefs.setBool("regitroDatosLoginExito", false);
                  prefs.setString("nombreUsuario", "");
                  prefs.setString("correoUsuario", "");
                  prefs.setString("contrasenaUsuario", "");
                }
              }
              setState(() {
                _saving = false;
                _enable = true;
              });
            }
          }
        });
  }

  List<telefonosModel> obtenerMedioContacto(
      consultaMediosContactoAgentesModel mediosContacto) {
    List<telefonosModel> teledonosLista = [];
    telefonosModel telefono;

    if (mediosContacto != null &&
        mediosContacto.mediosContacto != null &&
        mediosContacto.mediosContacto.telefonos != null) {
      for (int i = 0; i < mediosContacto.mediosContacto.telefonos.length; i++) {
        telefono = mediosContacto.mediosContacto.telefonos[i];

        if (telefono.propositosContacto != null &&
            telefono.tipoContacto.id == "TLCL") {
          //TODO validar nulos maria@bonos.com mexico.18
          for (int i = 0; i < telefono.propositosContacto.length; i++) {
            if (telefono.propositosContacto[i].id == "CAA") {
              teledonosLista.add(telefono);
            }
          }
        }
      }
    }

    if (teledonosLista.length > 0) {
      if (teledonosLista.length > 1) {
        teledonosLista.sort((b, a) {
          return a.idMedioContacto.compareTo(b.idMedioContacto);
        });
      }
    }

    return teledonosLista;
  }

  // Redireccionamiento
  redirect(Responsive responsive) async {
    prefs.setBool('flujoOlvideContrasena', false);
    if (prefs != null) {
      if (existeUsuario) {
        controllerContrasena.clear();
        controllerCorreo.clear();
        _validEmail = _formKey.currentState.validate();
        _validPass = _formKeyPass.currentState.validate();
        setState(() {});
        //TODO 238

        if (_biometricos &&
            _subSecuentaIngresoCorreo != null &&
            !_subSecuentaIngresoCorreo) {
          prefs.setBool("esFlujoBiometricos", true);

          if (is_available_finger && is_available_face) {
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
            } else {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
              //TODO customAlertTablet
              //customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlertaHullaLogin);
            }
          } else {
            print("biometricos subsecuentes");
            is_available_finger
                ? customAlert(AlertDialogType.huella, context, "", "",
                    responsive, funcionAlertaHullaLogin)
                : customAlert(AlertDialogType.Reconocimiento_facial, context,
                    "", "", responsive, funcionAlertaHullaLogin);
          }
        } else if (_biometricos &&
            (prefs.getBool("flujoCompletoLogin") != null &&
                !prefs.getBool("flujoCompletoLogin"))) {
          print("flujo completo biometricos activos");

          prefs.setBool("esFlujoBiometricos", true);

          if (is_available_finger && is_available_face) {
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
            } else {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
              //TODO customAlertTablet
              //customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlertaHullaLogin);
            }
          } else {
            is_available_finger
                ? customAlert(AlertDialogType.huella, context, "", "",
                    responsive, funcionAlertaHullaLogin)
                : customAlert(AlertDialogType.Reconocimiento_facial, context,
                    "", "", responsive, funcionAlertaHullaLogin);
          }
        } else {
          if (prefs.getBool("flujoCompletoLogin") != null &&
              prefs.getBool("flujoCompletoLogin")) {
            await consultaBitacora();
            if(_showFinOtro){
              customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, "title", "message", responsive, callback);
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        responsive: responsive,
                      ))).then((value) {
                Inactivity(context: context).cancelInactivity();

              });
            }
          } else {
            primerAccesoUsuario();
            if (prefs.getBool('primeraVezIntermediario') != null &&
                prefs.getBool('primeraVezIntermediario')) {
              if (prefs.getBool("aceptoCondicionesDeUso") == null) {
                // validamos si el usuario ya inicio sesión por primera vez
                if (_firstSession) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                                callback: funcionAlerta,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();


                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginActualizarContrasena(
                                responsive: responsive,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();
                  });
                }
              } else if (prefs.getBool("aceptoCondicionesDeUso") != null &&
                  prefs.getBool("aceptoCondicionesDeUso")) {
                // validamos si el usuario ya inicio sesión por primera vez
                if (_firstSession) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                                callback: funcionAlerta,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();
                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginActualizarContrasena(
                                responsive: responsive,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();


                  });
                }
              } else if (prefs.getBool("aceptoCondicionesDeUso") != null &&
                  !prefs.getBool("aceptoCondicionesDeUso")) {
                // validamos si el usuario ya inicio sesión por primera vez
                if (_firstSession) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                                callback: funcionAlerta,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();


                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginActualizarContrasena(
                                responsive: responsive,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();


                  });
                }
              } else {
                // validamos si el usuario ya inicio sesión por primera vez
                if (_firstSession) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                                callback: funcionAlerta,
                              ))).then((value) {
                    Inactivity(context: context).cancelInactivity();
                    //(context, widget.responsive, functionConnectivity, false);

                  });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginActualizarContrasena(
                                responsive: responsive,
                              ))).then((value) {
                                Inactivity(context: context).cancelInactivity();


                  });
                }
              }
            } else {
              prefs.setBool("esFlujoBiometricos", false);
              if (prefs.getString("medioContactoTelefono") != "") {
                if (deviceType == ScreenType.phone) {
                  customAlert(AlertDialogType.verificaTuNumeroCelular, context,
                      "", "", responsive, funcionAlertaCodVerificacion);
                } else {
                  customAlert(AlertDialogType.verificaTuNumeroCelular, context,
                      "", "", responsive, funcionAlertaCodVerificacion);
                  //TODO customAlertTablet
                  //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlertaCodVerificacion);
                }
              } else {
                print(
                    "No tiene medios de contacto login sin biometricos usuario ya registrado");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(
                              responsive: responsive,
                            ))).then((value) {
                              Inactivity(context: context).cancelInactivity();

                });
              }
            }
          }
        }
      } else {
        prefs.setBool("userRegister", true);
        if (_biometricos) {
          prefs.setBool("esFlujoBiometricos", true);

          if (is_available_finger && is_available_face) {
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
            } else {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context,
                  "", "", responsive, funcionAlertaHullaLogin);
              //TODO customAlertTablet
              //customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlertaHullaLogin);
            }
          } else {
            is_available_finger
                ? customAlert(AlertDialogType.huella, context, "", "",
                    responsive, funcionAlertaHullaLogin)
                : customAlert(AlertDialogType.Reconocimiento_facial, context,
                    "", "", responsive, funcionAlertaHullaLogin);
          }
        } else {
          primerAccesoUsuario();

          if (prefs.getBool('primeraVezIntermediario') != null &&
              prefs.getBool('primeraVezIntermediario')) {
            if (prefs.getBool("aceptoCondicionesDeUso") == null) {
              // validamos si el usuario ya inicio sesión por primera vez
              if (_firstSession) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                              callback: funcionAlerta,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarContrasena(
                              responsive: responsive,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();

                });
              }
            } else if (prefs.getBool("aceptoCondicionesDeUso") != null &&
                prefs.getBool("aceptoCondicionesDeUso")) {
              // validamos si el usuario ya inicio sesión por primera vez
              if (_firstSession) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                              callback: funcionAlerta,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarContrasena(
                              responsive: responsive,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              }
            } else if (prefs.getBool("aceptoCondicionesDeUso") != null &&
                !prefs.getBool("aceptoCondicionesDeUso")) {
              // validamos si el usuario ya inicio sesión por primera vez
              if (_firstSession) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                              callback: funcionAlerta,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarContrasena(
                              responsive: responsive,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              }
            } else {
              // validamos si el usuario ya inicio sesión por primera vez
              if (_firstSession) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CondicionesPage(responsive: widget.responsive,
                              callback: funcionAlerta,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarContrasena(
                              responsive: responsive,
                            ))).then((value) {
                  Inactivity(context: context).cancelInactivity();


                });
              }
            }
          } else {
            prefs.setBool("esFlujoBiometricos", false);
            if (prefs.getString("medioContactoTelefono") != "") {
              if (deviceType == ScreenType.phone) {
                customAlert(AlertDialogType.verificaTuNumeroCelular, context,
                    "", "", responsive, funcionAlertaCodVerificacion);
              } else {
                customAlert(AlertDialogType.verificaTuNumeroCelular, context,
                    "", "", responsive, funcionAlertaCodVerificacion);
                //TODO customAlertTablet
                //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlertaCodVerificacion);
              }
            } else {
              print("No tiene medios de contacto login sin biometricos");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginActualizarNumero(
                            responsive: responsive,
                          ))).then((value) {
                Inactivity(context: context).cancelInactivity();

              });
            }
          }
        }
      }
    }
  }

  Widget ingresarConOtroUsuario() {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),
          padding: EdgeInsets.only(
              top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
          width: widget.responsive.width,
          child: Text("INGRESAR CON OTRO USUARIO",
              style: TextStyle(
                color: Tema.Colors.gnpOrange,
              ),
              textAlign: TextAlign.center),
        ),
        onPressed: () async {
          prefs.setBool("esPerfil", false);
          prefs.setBool("userRegister", false);
          prefs.setString("contrasenaUsuario", "");
          prefs.setString("correoUsuario", "");
          prefs.setBool("activarBiometricos", false);
          prefs.setBool("regitroDatosLoginExito", false);
          prefs.setBool("flujoCompletoLogin", false);
          cancelTimers();
          Inactivity(context: context).cancelInactivity();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      PrincipalFormLogin(responsive: widget.responsive),settings: RouteSettings(name: "Login"))).then((value) {
            Inactivity(context: context).cancelInactivity();

          });
        });
  }

  showOnboarding() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.getBool("userRegister") != null) {
        if (prefs.getBool("userRegister") == true) {
        } else {
          Navigator.push(context,
              new MaterialPageRoute(builder: (_) => OnBoardingAppAutos())).then((value) {
            Inactivity(context: context).cancelInactivity();


          });
        }
      } else {
        Navigator.push(context,
            new MaterialPageRoute(builder: (_) => OnBoardingAppAutos())).then((value) {
          Inactivity(context: context).cancelInactivity();

        });
      }
    }
  }

  Widget activarHuella(Responsive responsive) {
    return isActiveBiometric?Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.width * 0.02),
      padding: EdgeInsets.only(top: 28, bottom: 32),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Switch(
              onChanged: (val) {
                _biometricos = val;
                if (prefs.getBool("subSecuentaIngresoCorreo") != null &&
                    prefs.getBool("subSecuentaIngresoCorreo") &&
                    !_biometricos) {
                  is_available_finger
                      ? customAlert(AlertDialogType.Desactivar_huella_digital,
                          context, "", "", widget.responsive, funcionBiometrics)
                      : customAlert(
                          AlertDialogType.Desactivar_recoFacial,
                          context,
                          "",
                          "",
                          widget.responsive,
                          funcionBiometrics);
                } else {
                  prefs.setBool("activarBiometricos", _biometricos);
                }
                setState(() {});
              },
              value: _biometricos,
              activeColor: Tema.Colors.GNP,
              activeTrackColor: Tema.Colors.biometrico,
              inactiveThumbColor: Tema.Colors.Azul_gnp,
              inactiveTrackColor: Tema.Colors.botonletra,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: responsive.wp(2)),
                child: Text(
                  "Inicio de sesión con datos biométricos",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(1.9),
                      color: Tema.Colors.Azul_2),
                ),
              ),
            ),
          ]),
    ):Container();
  }

  Widget version(Responsive responsive) {
    return Center(
      child: Container(
        //margin: EdgeInsets.only( top: responsive.hp(0.5), bottom: responsive.hp(0.5)),
        child: GestureDetector(
          onTap: () {
            //initPlatformState(updateDeviceData);
            customAlert(AlertDialogType.versionTag, context, "", "", responsive,
                funcionAlertaCodVerificacion);
            //initPlatformState(updateDeviceData);
          },
          onLongPress: () {
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.versionTag, context, "", "", responsive,
                  funcionAlertaCodVerificacion);
              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TerminosYCondicionesPage(
                            callback: callback,

                          )));*/

              // customAlert(AlertDialogType.Sesionfinalizada_por_inactividad, context, "",  "", responsive, CallbackInactividad);
            } else {
              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PreguntasSecretas(
                            responsive: responsive,

                          )
                  )
              );
              */

              //TODO customAlertTablet
              //customAlertTablet(AlertDialogTypeTablet.huella, context, "",  "", responsive, funcionAlertaCodVerificacion);

            }
          },
          child: Text(
            "Versión ${Tema.StringsMX.appVersion}",
            style: TextStyle(
                color: Tema.Colors.Azul_2, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  void funcionAlerta(bool abc) {}

  void updateDeviceData(Map<String, dynamic> deviceDato) {
    setState(() {
      deviceData = deviceDato;
    });
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

  void setIsUpdateVersion() async {
    print("setIsUpdateVersion");
    Map setIsUpdateVersion;
    try {
      String devideID = await _getId();
      print("devideID ${devideID}");
      DatabaseReference _dataBaseReference =
          FirebaseDatabase.instance.reference();

      await _dataBaseReference
          .child("deviceUser")
          .child(devideID)
          .once()
          .then((DataSnapshot _snapshot) {
        var jsoonn = json.encode(_snapshot.value);
        setIsUpdateVersion = json.decode(jsoonn);
        print("setIsUpdateVersion ---> ${setIsUpdateVersion}");
        if (setIsUpdateVersion != null && setIsUpdateVersion.isNotEmpty) {
          Map<String, dynamic> mapa = {
            '${devideID}': {
              'version': Tema.StringsMX.appVersion,
              'requiredUpdate': false,
            }
          };
          _dataBaseReference.child("deviceUser").update(mapa);
        } else {
          Map<String, dynamic> mapa = {
            '${devideID}': {
              'version': Tema.StringsMX.appVersion,
              'requiredUpdate': true,
            }
          };
          _dataBaseReference.child("deviceUser").update(mapa);
        }
      });
    } catch (e) {
      print(" setIsUpdateVersion error ${e}");
    }
  }

  Future<String> _getId() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.androidId; // unique ID on Android
      }
    } catch (e) {
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
        url =
            "itms-services://?action=download-manifest&amp;url=https://app.gnp.com.mx/components/ios/Intermediariognp.plist";
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

  void CallbackInactividad() {
    //setState(() {
    //print("CallbackInactividad login");
    showInactividad;
    //contrasenaInactividad = !contrasenaInactividad;
    // });
  }

  void funcionAlertaCodVerificacion(Responsive responsive) async {
    setState(() {
      _saving = true;
    });
    OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
        context,
        prefs.getString("correoUsuario"),
        prefs.getString("medioContactoTelefono"),
        prefs.getBool('flujoOlvideContrasena'));

    setState(() {
      _saving = false;
    });

    if (optRespuesta != null) {
      if (optRespuesta.error == "" && optRespuesta.idError == "") {
        prefs.setString("idOperacion", optRespuesta.idOperacion);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginCodigoVerificaion(
                      responsive: responsive,
                      isNumero: false,
                    ))).then((value){
          Inactivity(context: context).cancelInactivity();

        });
      } else {
        if(optRespuesta.idError == "015"){
          customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
              responsive, funcionAlerta);
        } else{
          customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
              funcion);
        }

      }
    } else {
      print("Error Servicio OTP");
      customAlert(
          AlertDialogType.errorServicio, context, "", "", responsive, funcion);
    }
  }

  void funcionAlertaHullaLogin(
      bool activarBiometricos, Responsive responsive) async {
    print("funcionAlertaHullaLogin");

    if (!activarBiometricos) {
      setState(() {
        _biometricos = activarBiometricos;
      });
      prefs.setBool("activarBiometricos", _biometricos);
      validateBiometricstatus(funcion);
    } else {
      if (prefs.getBool("primeraVez") ||
          prefs.getBool("flujoCompletoLogin") == null ||
          !prefs.getBool("flujoCompletoLogin")) {
        if (prefs.getString("medioContactoTelefono") != "") {
          setState(() {
            _saving = true;
          });
          OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
              context,
              prefs.getString("correoUsuario"),
              prefs.getString("medioContactoTelefono"),
              prefs.getBool('flujoOlvideContrasena'));

          setState(() {
            _saving = false;
          });

          if (optRespuesta != null) {
            if (optRespuesta.error == "" && optRespuesta.idError == "") {
              prefs.setString("idOperacion", optRespuesta.idOperacion);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginCodigoVerificaion(
                            responsive: responsive,
                            isNumero: false,
                          ))).then((value) {
                Inactivity(context: context).cancelInactivity();


              });
            } else {
              if(optRespuesta.idError == "015"){
                customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
                    responsive, funcionAlerta);
              } else{
                customAlert(AlertDialogType.errorServicio, context, "", "",
                    responsive, funcion);
              }

            }
          } else {
            customAlert(AlertDialogType.errorServicio, context, "", "",
                responsive, funcion);
          }
        } else {
          print("Sin medio contacto Flujo con biometricos");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginActualizarNumero(
                        responsive: responsive,
                      ))).then((value) {
            Inactivity(context: context).cancelInactivity();


          });
        }
      }
    }
  }

  void funcionCanselBiometrics() {
    setState(() {
      prefs.setBool("activarBiometricos", false);
    });
//    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
  }

  void funcionBiometrics() {
    setState(() {
      _biometricos = prefs.getBool("activarBiometricos");
    });

    if (!_biometricos) {
      prefs.setBool("subSecuentaIngresoCorreo", false);
      prefs.setBool("bloqueoDespuesSubBio", false);
      setState(() {
        _subSecuentaIngresoCorreo = prefs.getBool("subSecuentaIngresoCorreo");
      });
    } else {}
//    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
  }

  Future<Position> _getLocation() async {
    prefs.setBool("ShowgetLocation", false);
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print("e _getLocation ${e}");
      currentLocation = null;
    }
    return currentLocation;
  }

  void _getPlace() async {
    if(userLocation!=null&&userLocation.latitude!=null&&userLocation.longitude!=null){
    List<Placemark> newPlace = await placemarkFromCoordinates(userLocation.latitude, userLocation.longitude);
    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    //String address = "${country}";

    setState(() {
      _address = address; // update _address
    });
    }
  }

  void primerAccesoUsuario() async {
    Map userInfo;
    DatabaseReference _dataBaseReference =
        FirebaseDatabase.instance.reference();

    String emailFirst;
    String email;

    if (controllerCorreo.text.isNotEmpty || controllerCorreo.text != "") {
      emailFirst = controllerCorreo.text.replaceAll('.', '-');
      email = emailFirst.replaceAll('@', '-');
    } else {
      correoUsuario = prefs.getString("correoUsuario");
      emailFirst = correoUsuario.replaceAll('.', '-');
      email = emailFirst.replaceAll('@', '-');
    }

    try {
      await _dataBaseReference
          .child("firstSessionUser")
          .child(email.toLowerCase())
          .once()
          .then((DataSnapshot _snapshot) {
        var jsoonn = json.encode(_snapshot.value);
        userInfo = json.decode(jsoonn);

        if (userInfo.isNotEmpty && userInfo != null) {
          if (userInfo["isFirstMobileSession"]) {
            _dataBaseReference
                .child("firstSessionUser")
                .child(email.toLowerCase())
                .set({'isFirstMobileSession': false});
          }
          setState(() {
            _firstSession = false;
          });
        } else {
          setState(() {
            _firstSession = true;
          });
        }
      });
    } catch (err) {
      setState(() {
        _firstSession = true;
      });
      _dataBaseReference
          .child("firstSessionUser")
          .child(email.toLowerCase())
          .set({'isFirstMobileSession': true});
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
          if(response["isActive"]!= null && response["isActive"]){
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
}

void ultimoAcceso() async {
  print("== Firebase ==");
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
  /*await _dataBaseReference
      .child("accesoUsuarios")
      .child(datosUsuario.idparticipante)
      .once()
      .then((DataSnapshot _snapshot) {
    var jsoonn = json.encode(_snapshot.value);
    Map response = json.decode(jsoonn);*/

  if (accesoFirebase != null && accesoFirebase.isNotEmpty) {
    String dateFirebase = accesoFirebase["ultimoAcceso"] != null
        ? accesoFirebase["ultimoAcceso"]
        : "";
    print("if dateFirebase  ${dateFirebase}");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss').format(now);
    validacionAcceso(dateFirebase, formattedDate);
    print("formattedDate  ${formattedDate}");

    Map<String, dynamic> mapa = {
      '${datosUsuario.idparticipante}': {
        'ultimoAcceso': formattedDate,
      }
    };
    _dataBaseReference.child("accesoUsuarios").update(mapa);
  } else {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss').format(now);
    print("else formattedDate  ${formattedDate}");
    prefs.setString("ultimoAcceso", formattedDate);
    prefs.setBool("primerAccesoFecha", true);
    Map<String, dynamic> mapa = {
      '${datosUsuario.idparticipante}': {
        'ultimoAcceso': formattedDate,
      }
    };

    _dataBaseReference.child("accesoUsuarios").update(mapa);
  }
  //});
}

void validacionAcceso(String dataFirebase, String dateNow) {
  prefs.setBool("primerAccesoFecha", false);

  String diaFirebase = dataFirebase.substring(0, 2);
  String mesFirebase = dataFirebase.substring(3, 5);
  String anioFirebase = dataFirebase.substring(6, 10);

  String diaPrefs = dateNow.substring(0, 2);
  String mesPrefs = dateNow.substring(3, 5);
  String anioPrefs = dateNow.substring(6, 10);

  if ((diaFirebase == diaPrefs) &&
      (mesFirebase == mesPrefs) &&
      (anioFirebase == anioPrefs)) {
    print("Fechaa now");
    prefs.setBool("ultimoAccesoHoy", true);
    prefs.setBool("ultimoAccesoAyer", false);
  } else if ((mesFirebase == mesPrefs) &&
      (anioFirebase == anioPrefs) &&
      (int.parse(diaFirebase) + 1 == int.parse(diaPrefs))) {
    print("Fehca ayer");
    print("");
    prefs.setBool("ultimoAccesoHoy", false);
    prefs.setBool("ultimoAccesoAyer", true);
  } else {
    print("Fehca otro dia");
    prefs.setBool("ultimoAccesoHoy", false);
    prefs.setBool("ultimoAccesoAyer", false);
  }
  prefs.setString("ultimoAcceso", dataFirebase);
}

void funcion() {}



void validarRolesUsuario() {
  prefs.setBool("rolAutoscotizarActivo", false);
  List<String> activoAutoCotizar = [];
  String campo = "";
  bool activoCotizarAutos = false;

  if (respuestaServicioCorreo.roles.length >
      0) {
    List<dynamic> rol = respuestaServicioCorreo.roles;
    for (int i = 0; i < rol.length; i++) {
      print("rooool --> ${rol[i].toString().split(",")}");
      List<String> listaRoles = rol[i].toString().split(",");
      print("listaRoles -->${listaRoles[0]}");
      String rolCadena = listaRoles[0].substring(3, listaRoles[0].length);
      //String rolAux = rol[i].toString().substring(3, rol[i].length);
      print("rolCadena ${rolCadena}");
      campo = cotizarAutos.where((element) => element.toString().toLowerCase() == rolCadena.toLowerCase()).toString();
      print("campo ${campo}");
      if (campo != "" && campo != "()") {
        activoAutoCotizar.add(campo);
      }
    }
    activoAutoCotizar.length > 0
        ? activoCotizarAutos = true
        : activoCotizarAutos = false;
    print("activoAutoCotizar ${activoCotizarAutos}");
    prefs.setBool("rolAutoscotizarActivo", activoCotizarAutos);
  }
}
