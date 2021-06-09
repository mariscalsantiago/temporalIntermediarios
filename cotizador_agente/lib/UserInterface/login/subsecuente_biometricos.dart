
import 'dart:io';
import 'dart:ui';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
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
import 'package:local_auth/error_codes.dart' as auth_error;


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
  var localAuth = new LocalAuthentication();
  bool _saving;
  @override
  void initState() {
    cancelTimers();
    showBio_available = is_available_finger;
    _saving = false;
    // TODO: implement initState
    super.initState();
    prefs.setBool("esPerfil", false);
    prefs.setBool("bloqueoDespuesSubBio", false);
    WidgetsBinding.instance.addObserver(this);
    validateIntenetstatus(context, widget.responsive,CallbackInactividad);
    validateBiometricstatus(funcionCanselBiometrics);

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
    if(!is_available_face && !is_available_finger){
      print("face y finger");
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
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
                child: Icon(showBio_available ? Icons.fingerprint : Tema.Icons.facial, size: widget.responsive.ip(9), color: Tema.Colors.GNP,))),
        Container(
          margin: EdgeInsets.only(top: widget.responsive.hp(3), bottom: widget.responsive.hp(4), left: widget.responsive.wp(30), right: widget.responsive.wp(30)),
          child:
          Text(showBio_available?"Coloca tu huella en el lector de tu dispositivo": "Mira fijamente a la cámara de tu dispositivo",
            textAlign: TextAlign.center,
            style: TextStyle(color: Tema.Colors.Funcional_Textos_Body, fontSize: widget.responsive.ip(1.5)),
          ),
        ),
        showBio? CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
              width: widget.responsive.width,
              child: Text(showBio_available ?"INGRESAR CON RECONOCIMIENTO FACIAL":"INGRESAR CON LECTOR DE HUELLA", style: TextStyle(
                color: Tema.Colors.gnpOrange,
              ),
                  textAlign: TextAlign.center),
            ),
            onPressed: () {
              showBio_available = !showBio_available;
              setState(() {});
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
              prefs.setBool("bloqueoDespuesSubBio", false);
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
              prefs.setBool("bloqueoDespuesSubBio", false);
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

  Future<void> _authenticateHuella(Responsive responsive) async {

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
                  goToSettingsDescription: 'hola',
                  cancelButton: "Cancelar", goToSettingsButton: "Aceptar"),
              useErrorDialogs: false,
              stickyAuth: false);
        } else {
          authenticated = await localAuth.authenticateWithBiometrics(
              androidAuthStrings: new AndroidAuthMessages(
                  signInTitle: "Inicio de sesión",
                  fingerprintHint: is_available_finger && is_available_face
                      ? "Coloca tu dedo o mira fijamente a la cámara para continuar."
                      : is_available_finger
                      ? "Coloca tu dedo para continuar"
                      : "Mira fijamente a la cámara para continuar.",
                  cancelButton: "CANCELAR",
                  fingerprintRequiredTitle: is_available_finger && is_available_face
                      ? "Coloca tu dedo o mira fijamente a la cámara para continuar."
                      :is_available_finger
                      ? "Coloca tu dedo para continuar"
                      : is_available_face
                      ? "Mira fijamente a la cámara para continuar."
                      : "",
                  goToSettingsDescription: "Tu huella digital no está configurada en el dispositivo, ve a configuraciones para añadirla.",
                  goToSettingsButton: "Ir a configuraciones"),
              iOSAuthStrings: new IOSAuthMessages (
                  lockOut: 'Has superado los intentos permitidos para usar biométricos, deberás bloquear y desbloquear tu dispositivo.',
                  cancelButton: "Cancelar", goToSettingsButton: "Cancelar"),
              localizedReason: ' ',
              useErrorDialogs: false,
              stickyAuth: false);
        }

      if(authenticated){
        setState(() {
          _saving = true;
        });
        datosUsuario = await logInServices(context,prefs.getString("correoUsuario"), prefs.getString("contrasenaUsuario"), prefs.getString("correoUsuario"),responsive);
        if(datosUsuario != null){
          respuestaServicioCorreo = await  consultaUsuarioPorCorreo(context, prefs.getString("correoUsuario"));
          //Validacion Roles
          validarRolesUsuario();

          print("roles ${respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.roles.rol.length}" );
          print("respuesta  ${respuestaServicioCorreo}");
          setState(() {
            _saving = false;
          });
          Navigator.push(context, new MaterialPageRoute(builder: (_) => new HomePage(responsive: responsive,)));
        } else{


          setState(() {
            _saving = false;
          });
          //customAlert(AlertDialogType.errorServicio,context,"","", responsive, ErrorServicio);
          print("else sub Biometrios");

        }
      } else{

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
          }
        }

    }

  }

  void ErrorServicio(){

  }

  void CallbackInactividad() {
    setState(() {});
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
  void funcionDenegadoBiometric(){

  }
}
