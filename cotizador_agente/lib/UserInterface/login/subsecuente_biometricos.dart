
import 'dart:ui';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController_2.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import '../../main.dart';
import 'logoEncabezadoLogin.dart';

String _authorized = 'Not Authorized';
bool _isAuthenticating = false;

class BiometricosPage extends StatefulWidget {
  BiometricosPage({Key key, this.responsive}) : super(key: key);
  final Responsive responsive;

  @override
  _BiometricosPage createState() => _BiometricosPage();
}

class _BiometricosPage extends State<BiometricosPage> with WidgetsBindingObserver  {
  bool finger = false;
  bool face = false;
  bool showBio = true;
  var localAuth = new LocalAuthentication();
  bool _saving;
  @override
  void initState() {
    _saving = false;
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    validateIntenetstatus(context, widget.responsive);
    validateBiometricstatus(funcionCanselBiometrics);
    face = is_available_face;
    finger = is_available_finger;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState");
    if(state == AppLifecycleState.resumed){
      print(state);
      validateBiometricstatus(funcionCanselBiometrics);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!face && !finger){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
    }else{
      if(face){
        showBio = finger;
      }else{
        showBio=face;
      }
    }
    return WillPopScope(
      onWillPop: () async => false,
      child:Scaffold(
        body: SingleChildScrollView(
            child:  Stack(
                children: builData(widget.responsive)
            )
        ),
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();

    data = SingleChildScrollView(
      child: Column(
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
                    //if(face){}else{
                    _authenticateHuella(widget.responsive);
                    // }
                  },
                  child: Icon(face != false ? Tema.Icons.facial : Icons.fingerprint, size: widget.responsive.ip(9), color: Tema.Colors.GNP,))),
          Container(
            margin: EdgeInsets.only(top: widget.responsive.hp(3), bottom: widget.responsive.hp(4), left: widget.responsive.wp(30), right: widget.responsive.wp(30)),
            child:
            Text(face != false ?"Mira fijamente a la cámara de tu dispositivo": "Coloca tu huella en el lector de tu dispositivo",
              textAlign: TextAlign.center,
              style: TextStyle(color: Tema.Colors.Funcional_Textos_Body, fontSize: widget.responsive.ip(1.5)),
            ),
          ),
          showBio != false ? CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
                width: widget.responsive.width,
                child: Text(face != false ?"INGRESAR CON LECTOR DE HUELLA": "INGRESAR CON RECONOCIMIENTO FACIAL", style: TextStyle(
                  color: Tema.Colors.gnpOrange,
                ),
                    textAlign: TextAlign.center),
              ),
              onPressed: () {
                setState(() {
                  if (face) {
                    face=false;
                  }
                  else {
                    face=true;
                  }
                });

              }
          ):Container(),
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
                prefs.setBool("subSecuentaIngresoCorreo", true);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
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
                prefs.setBool("userRegister", false);
                prefs.setString("contrasenaUsuario","");
                prefs.setString("correoUsuario", "");
                prefs.setBool("activarBiometricos", false);
                prefs.setBool("regitroDatosLoginExito", false);
                prefs.setBool("flujoCompletoLogin", false);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
              }
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: responsive.hp(3.5), bottom: responsive.hp(3.5)),
              child: Text("Versión 2.0",
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
      ),
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              height: responsive.height,
              width: responsive.width,
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
      );
      l.add(modal);
    }
    return l;
  }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  Future<void> _authenticateHuella(Responsive responsive) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });


      authenticated = await localAuth.authenticateWithBiometrics(
        androidAuthStrings:new AndroidAuthMessages(signInTitle: "Inicio de sesión", fingerprintHint: "Coloca tu dedo para continuar", cancelButton: "CANCELAR",fingerprintRequiredTitle:"Solicitud de huella digital",goToSettingsDescription:"Tu huella digital no está configurada en el dispositivo, ve a configuraciones para añadirla.",goToSettingsButton:"Ir a configuraciones"),
        iOSAuthStrings: new IOSAuthMessages (cancelButton: "CANCELAR"),
        localizedReason: ' ',
        useErrorDialogs: true,
        stickyAuth: true,

      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });

      if(authenticated){
        setState(() {
          _saving = true;
        });
        datosUsuario = await logInServices(context,prefs.getString("correoUsuario"), prefs.getString("contrasenaUsuario"), prefs.getString("correoUsuario"),responsive);
        setState(() {
          _saving = false;
        });
        if(datosUsuario!= null){
          //ultimoAcceso();
          Navigator.push(context, new MaterialPageRoute(builder: (_) => new HomePage(responsive: responsive,)));
        }else{
          setState(() {
            //prefs.setBool("activarBiometricos", false);
          });
          customAlert(face?AlertDialogType.Rostro_no_reconocido:
          AlertDialogType.Huella_no_reconocida,
              context,
              "",
              "",
              responsive,
              funcionAlerta);
        }
      } else {

      }
    } on PlatformException catch (e) {
      print("eeeeeee ${e}");
      setState(() {
        //prefs.setBool("activarBiometricos", false);
      });

      face != false ?  customAlert(AlertDialogType.Rostro_no_reconocido,context,"","", responsive, funcionAlerta):
      customAlert(AlertDialogType.Huella_no_reconocida,context,"","", responsive, funcionAlerta);


    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void funcionAlerta(){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
  }
  void funcionCanselBiometrics(){
    setState(() {
      prefs.setBool("activarBiometricos", false);
    });
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
  }

}
