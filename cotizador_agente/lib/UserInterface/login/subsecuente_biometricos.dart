
import 'dart:ui';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
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

class _BiometricosPage extends State<BiometricosPage> {
  bool face = false;
  bool showBio = true;
  var localAuth = new LocalAuthentication();
  bool _saving;
  @override
  void initState() {
    _saving = false;
    // TODO: implement initState
    super.initState();
    if(is_available_finger != false  ){
      face = false;
      if(is_available_face != false){
        showBio = true;
      }
      else{
        showBio = false;
      }
    }else if(is_available_face != false){
      face = true;
      if(is_available_finger != false){
        showBio = true;
      }
      else{
        showBio = false;
      }
    }
    validateIntenetstatus(context, widget.responsive);
  }
  @override
  Widget build(BuildContext context) {
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
                "¡ Hola ${prefs.getString("nombreUsuario")} !",
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
                prefs.setBool("activarBiometricos", false);
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
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
              }
          ),
          Container(
            margin: EdgeInsets.only(left:widget.responsive.wp(0), top: widget.responsive.hp(9)),
            child: Text("Versión 2.0",
              style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontSize: widget.responsive.ip(1.5),
                fontWeight: FontWeight.normal,

              ),
              textAlign: TextAlign.center,
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
          Container(
            height: responsive.height,
            child: Opacity(
              opacity: 0.7,
              child: const ModalBarrier(dismissible: false, color: Tema.Colors.primary),
            ),
          ),
          new Center(
            child: Container(
                margin: EdgeInsets.only(top: responsive.hp(35)),
                height: responsive.height*0.1,
                width: responsive.width* 0.2,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Tema.Colors.tituloTextoDrop),
                  child:   new CircularProgressIndicator(),
                )
            ),
          ),
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
          localizedReason: 'Ingresa tu huella para Autenticarte',
          useErrorDialogs: false,
          stickyAuth: false,
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

  }

}
