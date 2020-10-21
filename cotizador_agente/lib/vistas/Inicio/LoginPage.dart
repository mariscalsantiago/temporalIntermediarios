import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/vistas/Inicio/AvisoPrivacidad.dart';
import 'package:cotizador_agente/vistas/Inicio/LoginServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:device_info/device_info.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Styles/Strings.dart' as AppStrings;

bool canCheckBiometrics;
bool canShowBiometrics = true;
List<BiometricType> availableBiometrics;
SharedPreferences prefs;
final flutterWebviewPlugin = new FlutterWebviewPlugin();


Future<SharedPreferences> getPrefer() async {
  return prefs = await SharedPreferences.getInstance();
}

class LoginPage extends StatefulWidget {

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  Future<bool> getConexion() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.getBool("conexion") != null) {

        if (prefs.getBool("conexion") == true) {

          WidgetsBinding.instance.addPostFrameCallback((_) =>
              customAlert(AlertDialogType.inactividad, context, "", ""));

          prefs.setBool("conexion", false);
        } else {

        }
      }
    }
    return true;
  }

  Future<Null> _sendDeviceInfo() async {
    String device;
    String version;
    String manufacturer;
    String os;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');
      device = androidInfo.model;
      manufacturer = androidInfo.manufacturer;
      os = "Android";
      switch (androidInfo.version.sdkInt) {
        case 19:
        case 20:
          version = "KitKat";
          break;
        case 21:
        case 22:
          version = "Lollipop";
          break;
        case 23:
          version = "Marshmallow";
          break;
        case 24:
        case 25:
          version = "Nougat";
          break;
        case 26:
        case 27:
          version = "Oreo";
          break;
        case 28:
          version = "Pie";
          break;
        case 29:
          version = "Q";
          break;
        default:
          version =
              "No registrado, Sdk: " + androidInfo.version.sdkInt.toString();
          break;
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      device = iosInfo.model;
      version = iosInfo.systemVersion;
      manufacturer = "Iphone";
      os = "IOs";
    }
    sendTagInteractionWithANamedParam("DeviceInfo","Details", "$manufacturer-$device-$os-$version" );
  }

  @override
  void initState() {
    sendTag("Login_Page");
    WidgetsBinding.instance.addObserver(this);
    getPrefer();
    _sendDeviceInfo();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  }

  @override
  Widget build(BuildContext context) {
    getConexion();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: LogInBody(),
        ),
      ),
    );
  }

}

class LogInBody extends StatefulWidget {
  @override
  LogInBodyState createState() {
    return LogInBodyState();
  }
}

class LogInBodyState extends State<LogInBody> {
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  bool _saving = false;
  bool validHuella = false;
  Map datosHuellaMap;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  bool _obscureTextLogin = true;
  bool canCheckBiometrics;
  bool isInternet = true;

  redirect() async {
    prefs.setBool("availableSesion", true);
    loginPasswordController.clear();
    loginEmailController.clear();
    setState(() {});
    if(await getAviso(datosUsuario.idparticipante)) {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            PrivacyAdvertisement(email:loginEmailController.text))
      );
    }else {
      Navigator.pushNamed(context, '/cotizadorUnicoAP').then((val){
        getHuella();
      });
    }
    _saving = false;
    setState(() {});
          
  }



  Future<bool> getHuellaShared() async {
    var localAuth = new LocalAuthentication();
    prefs = await SharedPreferences.getInstance();
    availableBiometrics = await localAuth.getAvailableBiometrics();
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    setState(() {});
    if (prefs != null && prefs.getString('datosHuella') != null) {
      setState(() {
        datosHuellaMap = json.decode(prefs.getString('datosHuella'));
      });
      validHuella = true;

      return validHuella;
    } else {
      validHuella = false;
      return validHuella;
    }
  }

  Future<Null> getHuella() async {
    return getHuellaShared().then((_activo) {
      setState(() => validHuella = _activo,);
    });
  }

  onHuella() async {
    if (validHuella == false && datosHuellaMap == null) {
      customAlert(AlertDialogType.infoBiometrico, context, "", "");
    } else {
      try {
        var localAuth = new LocalAuthentication();
        availableBiometrics = await localAuth.getAvailableBiometrics();
        canCheckBiometrics = await localAuth.canCheckBiometrics;
        setState(() {});

        if (Platform.isIOS) {
          const iosStrings = const IOSAuthMessages(
              cancelButton: 'cancel',
              goToSettingsButton: 'Configuración',
              goToSettingsDescription: 'Configure su Touch ID.',
              lockOut: 'Por favor habilite su Touch ID.');
          bool didAuthenticate = await localAuth.authenticateWithBiometrics(
              localizedReason: 'Ingresar con huella',
              useErrorDialogs: false,
              iOSAuthStrings: iosStrings);

          if (didAuthenticate) {
            setState(() {
              _saving = true;
            });
            datosUsuario = await logInServices(
                context, datosHuellaMap["email"], datosHuellaMap["contraseña"],datosHuellaMap["savedMailApp"]);
            if(datosUsuario!=null){
              redirect();
            }else{
              setState(() {
                _saving = false;
                customAlert(AlertDialogType.errorBonos, context, "${mensajeStatus.title}",  "${mensajeStatus.message}");
              });
            }
          }
        } else {
          bool didAuthenticate = await localAuth.authenticateWithBiometrics(
              localizedReason: 'Ingresar con huella');
          if (didAuthenticate) {
            _saving = true;
            setState(() {});
            datosUsuario = await logInServices(
                context, datosHuellaMap["email"], datosHuellaMap["contraseña"],datosHuellaMap["savedMailApp"]);

            if(datosUsuario!=null){
              redirect();
            }else{
              setState(() {
                _saving = false;
                customAlert(AlertDialogType.errorBonos, context, "${mensajeStatus.title}",  "${mensajeStatus.message}");
              });
            }
          }
        }
      } catch (e) {
      }
    }
  }


  void internetStatusBool(BuildContext context) async {
    //String titulo = "", mensaje = "";
    var connectivityResult = await (Connectivity().checkConnectivity());
    //  printLog("login_page","Conectividad Status: "+connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isInternet = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isInternet = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      isInternet = false;
    }

    if (!isInternet) {
      customAlert(AlertDialogType.errorConexion, context, "", "");
    } else {
      customAlert(
          AlertDialogType.errorCerrarDialog,
          context,
          "Error de conexión.",
          "Se produjo un error al conectarse, intente  más tarde.");
    }
  }

  @override
  void dispose() {
    getHuella();
    myFocusNodePasswordLogin.dispose();
    myFocusNodeEmailLogin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: _buildForm(context),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    Form form = new Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: new Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(shrinkWrap: true, children: [
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 16),
                  width: 186,
                  height: 88,
                  child: Image.asset('assets/img/logotype.png')),
              Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Text(AppStrings.StringsMX.loginHeaderTitle,
                            textAlign: TextAlign.left,
                            style: Theme.TextStyles.DarkMedium18px),
                      )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                      child: TextFormField(
                        cursorColor: Theme.Colors.Orange,
                        focusNode: myFocusNodeEmailLogin,
                        onFieldSubmitted: (S){FocusScope.of(context).requestFocus(myFocusNodePasswordLogin);},
                        controller: loginEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          color: Theme.Colors.Light,
                        ),
                        decoration: InputDecoration(

                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Light, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Orange, width: 1.0),
                          ),
                          labelText: AppStrings.StringsMX.loginEmail,
                          labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                        ),
                        validator: (value) {
                          String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
                          RegExp regExp = new RegExp(p);
                          if (value.isEmpty) {
                            return 'Introduzca un correo electrónico';
                          } else if (regExp.hasMatch(value)) {
                            return null;
                          } else {
                            return 'Introduzca un correo válido';
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      //width: 200.0,
                      margin:
                      const EdgeInsets.only(top: 16, left: 24.0, right: 24),
                      child: TextFormField(
                        cursorColor: Theme.Colors.Orange,
                        focusNode: myFocusNodePasswordLogin,
                        onFieldSubmitted: (S) async {
                          if (_formKey.currentState.validate()) {
                              setState(() {
                                _saving = true;
                              });
                              FocusScope.of(context).unfocus();
                              datosUsuario = await logInServices(context, loginEmailController.text,
                                  loginPasswordController.text,loginEmailController.text);
                              if(datosUsuario!=null){
                                redirect();
                              }else{
                                setState(() {
                                  _saving = false;
                                  customAlert(AlertDialogType.errorBonos, context, "${mensajeStatus.title}",  "${mensajeStatus.message}");
                                });
                              }
                          }
                        },
                        controller: loginPasswordController,
                        obscureText: _obscureTextLogin,

                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 16.0,
                            color: Theme.Colors.gnpBlue),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: _obscureTextLogin
                                  ? Theme.Colors.Shadow70
                                  : Theme.Colors.gnpOrange,
                              onPressed: () {
                                setState(() {
                                  _obscureTextLogin = !_obscureTextLogin;
                                });
                              }),
                          //suffixIcon: Icon(Theme.Icons.lock),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Light, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Orange, width: 1.0),
                          ),
                          labelText: AppStrings.StringsMX.loginPassword,
                          labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Introduzca una contraseña';
                          } else if (value.length < 8) {
                            return 'Ingresa mínimo 8 caracteres';
                          } else return null;
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      //width: 200.0,
                      margin: const EdgeInsets.only(top: 24, right: 32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          FloatingActionButton(
                            child: Icon(Icons.arrow_forward),
                            backgroundColor: Theme.Colors.Orange,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _saving = true;
                                  });
                                  FocusScope.of(context).unfocus();
                                  datosUsuario = await logInServices(context, loginEmailController.text,
                                      loginPasswordController.text,loginEmailController.text);
                                  if(datosUsuario!=null){
                                    if(datosUsuario.iscurrentUser){
                                      List<String> temList = [];
                                      prefs.setStringList("busquedasRecientes", temList);
                                    }
                                    redirect();
                                  }else{
                                    setState(() {
                                      _saving = false;
                                      customAlert(AlertDialogType.errorBonos, context, "${mensajeStatus.title}",  "${mensajeStatus.message}");
                                    });
                                  }

                              }
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Text(AppStrings.StringsMX.loginButtonLabel,
                                style:
                                Theme.TextStyles.DarkGrayRegular14px),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ])),
      ),
    );

    var l = new List<Widget>();
    l.add(form);
    if (_saving) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.7,
            child: const ModalBarrier(dismissible: false, color: Colors.black),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }

    return l;
  }
}