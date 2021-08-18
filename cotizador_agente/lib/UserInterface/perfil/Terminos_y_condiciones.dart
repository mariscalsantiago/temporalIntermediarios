
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/Constantes.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustumFuntions.dart';
import 'package:cotizador_agente/Custom/DinamicCustumWidget.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/UserInterface/perfil/condiciones_uso.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:system_settings/system_settings.dart';
import 'package:url_launcher/url_launcher.dart';import 'package:cotizador_agente/Functions/Analytics.dart';


bool checkedValue = false;
bool _showFinOtro = false;
var localAuth = new LocalAuthentication();

class TerminosYCondicionesPage extends StatefulWidget {
  Function callback;
  Responsive responsive;
  TerminosYCondicionesPage({Key key, this.callback, this.responsive}) : super(key: key);


  @override
  _TerminosYCondicionesPageState createState() => _TerminosYCondicionesPageState();
}

class _TerminosYCondicionesPageState extends State<TerminosYCondicionesPage> {


  @override
  void initState() {
    if (prefs.getBool("esPerfil") != null &&prefs.getBool("esPerfil")){
      Inactivity(context:context).initialInactivity(functionInactivity);
    }
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    checkedValue = false;
  }

  @override
  dispose() {
    super.dispose();
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }


  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {

    Responsive responsive = Responsive.of(context);
    return  SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon:Icon(Icons.close, color: Theme.Colors.GNP,),
              onPressed: () async {
                if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                  Inactivity(context:context).cancelInactivity();
                  prefs.setBool("activarBiometricos", false);
                  //widget.callback();
                  Navigator.pop(context,true);
                } else {
                  prefs.setBool("activarBiometricos", false);
                  widget.callback(false, responsive);
                  Navigator.pop(context,true);
                  if(prefs.getBool("flujoCompletoLogin") != null && prefs.getBool("flujoCompletoLogin")){
                    await consultaBitacora();
                    if(_showFinOtro){
                      customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, "title", "message", responsive, (){});
                    }else{
                      sendTag("appinter_login_ok");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                responsive: responsive,
                              ),settings: RouteSettings(name: "Home"))).then((value) {
                       // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                      });
                    }
                  } else if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){

                    print("-----IntermediarioPrimeraVez TerminosYCondiciones------");

                    if(prefs.getBool("aceptoCondicionesDeUso") == null ){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CondicionesPage(callback:FuncionAlerta ,))).then((value) {
                        // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                      });
                    } else if(prefs.getBool("aceptoCondicionesDeUso") != null && prefs.getBool("aceptoCondicionesDeUso")){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,))).then((value) {
                       // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                      });
                    } else if(prefs.getBool("aceptoCondicionesDeUso") != null && !prefs.getBool("aceptoCondicionesDeUso")){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CondicionesPage(callback:FuncionAlerta ,))).then((value) {
                       // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                      });
                    } else{
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,))).then((value) {
                       // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                      });
                    }

                  } else{
                    if(prefs.getString("medioContactoTelefono") != ""){
                      customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, widget.callback);
                    }else{
                      print("No tiene medios de contacto login sin biometricos usuario ya registrado");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginActualizarNumero(
                                    responsive: responsive,
                                  ))).then((value) {
                       // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);


                      });
                    }
                  }
                }
              },
            ),
            backgroundColor: Theme.Colors.White,
          ),
          body: Container(
            color: Theme.Colors.White,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: prefs.getBool("useMobileLayout") ? EdgeInsets.only(right: responsive.wp(14.5), left: responsive.wp(14.5)): EdgeInsets.only(right: responsive.wp(20), left: responsive.wp(20)),
                          width: (responsive.width - 100),

                          child: Text("Términos y condiciones de uso", textAlign: TextAlign.start,
                            style: TextStyle(fontSize: responsive.ip(2.2), color: Theme.Colors.Azul_2,),
                          ),
                        ),
                        Image.asset("assets/icon/splash/logo.png", fit:BoxFit.contain,height:responsive.ip(15), width: responsive.ip(15),),
                        Container(
                          height: responsive.hp(47),
                          margin: EdgeInsets.only(left: responsive.wp(2.5), right: responsive.wp(2.5)),
                          child: SingleChildScrollView(
                            child: Text.rich(
                                TextSpan(
                                    text: 'Consentimiento para el tratamiento de uso de datos biométricos \n \n',
                                    style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: 'Grupo Nacional Provincial, S.A.B., ',
                                        style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'con domicilio en Avenida Cerro de las Torres No. 395, Colonia Campestre Churubusco,'
                                            ' Código Postal 04200, Alcaldía Coyoacán, Ciudad de México, tratará sus datos personales'
                                            ' para que a través de su huella digital que previamente tenga configurada o disponible en el '
                                            'dispositivo electrónico que utilice, facilitar el acceso a determinadas aplicaciones o '
                                            'plataformas de GNP relacionadas con el desarrollo de sus actividades propias como agente,'
                                            ' sin que esto implique el resguardo o almacenamiento de este dato por parte de GNP. '
                                            'Puede consultar la versión integral del Aviso de Privacidad en ',
                                        style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("gnp");
                                          launch('https://www.gnp.com.mx');},
                                        text: 'www.gnp.com.mx ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),
                                      TextSpan(
                                        text: 'o en el teléfono ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("numero");
                                          launch('tel:5552279000');},
                                        text: '(55) 5227 9000 ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),
                                      TextSpan(
                                        text: 'a nivel nacional. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        text: 'Al activar el uso de datos biométricos, reconozco que se ha puesto a mi disposición el ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("gnp");
                                          launch('https://www.gnp.com.mx/aviso-de-privacidad-integral');},
                                        text: 'Aviso de Privacidad Integral de Grupo Nacional Provincial S. A. B. ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),
                                      TextSpan(
                                        text: '(en adelante GNP), mismo que contiene y detalla las finalidades del tratamiento de los datos personales y'
                                            ' aceptó su tratamiento por parte de GNP. Asimismo se me informó que puedo consultar dicho aviso y sus actualizaciones'
                                            ' en cualquier momento en la página ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("gnp");
                                          launch('https://www.gnp.com.mx');},
                                          text: 'www.gnp.com.mx ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),

                                      TextSpan(
                                        text: 'o en el teléfono ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("numero");
                                          launch('tel:5552279000');},
                                        text: '(55) 5227 9000 ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),

                                      TextSpan(
                                        text: 'a nivel nacional. En caso de haber proporcionado datos personales de otros titulares, reconozco haber cumplido con mi'
                                            ' obligación de informarles sobre su entrega, haber obtenido de forma previa el consentimiento de éstos para su tratamiento, '
                                            'así como haberles informado los lugares en los que se encuentra disponible el Aviso de Privacidad para su consulta. ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                    ]
                                )
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Container(
                          decoration: BoxDecoration(
                              border:  Border(
                                bottom: BorderSide( //                   <--- left side
                                  color: Theme.Colors.Azul_gnp,
                                  width: 0.2,
                                ),
                                top: BorderSide( //                    <--- top side
                                  color: Theme.Colors.Azul_gnp,
                                  width: 0.2,
                                ),
                              )
                          ),
                          //color: Theme.Colors.Azul_2,
                          padding: EdgeInsets.only(top: responsive.hp(1),bottom: responsive.hp(1)),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                checkedValue = !checkedValue;
                                prefs.setBool("aceptoTerminos", checkedValue);
                              });
                            },
                            child: Container(child: Row(children: [
                              Container(child:IconButton(
                                icon: checkedValue ? Image.asset("assets/terminosycondiciones/check_box_24px.png", width: 18, height: 18,) : Image.asset("assets/terminosycondiciones/check_box_outline_blank_24px.png", width: 18, height: 18),
                              )),
                              Expanded(child: Container(child: Text("ACEPTO LOS TÉRMINOS Y CONDICIONES DE USO",textAlign: TextAlign.start, style:TextStyle(color: Theme.Colors.Azul_2, fontSize: responsive.ip(1.8),)),))

                            ],),),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: responsive.hp(2), right: responsive.wp(2.5), left: responsive.wp(2.5)),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: (checkedValue) ?
                                  Theme.Colors.GNP : Theme.Colors.botonlogin ,
                                ),
                                padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
                                width: responsive.width,
                                child: Text("CONTINUAR", style: TextStyle(
                                  fontSize: responsive.ip(1.8),
                                  color:  (checkedValue) ?
                                  Theme.Colors.backgroud : Theme.Colors.botonletra,
                                ),
                                    textAlign: TextAlign.center),
                              ),
                              onPressed: () async {


                                //if(prefs.getInt("localAuthCount")<=4){
                                 if(checkedValue){
                                   _authenticateHuella(responsive);
                                 }

                                //}
                                /*else{
                                  Navigator.pop(context);
                                  customAlert(face?AlertDialogType.Rostro_no_reconocido:AlertDialogType.Huella_no_reconocida,context,"","", responsive, widget.callback);
                                }*/

                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
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

  Future<void> _authenticateHuella(Responsive responsive) async {

      validateBiometricstatus(funcion);

    if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
          widget.callback();
        } else {
          widget.callback(false, responsive);
        }

        bool didAuthenticate = false;


          if( prefs != null && prefs.getInt("localAuthCountIOS") != null && prefs.getInt("localAuthCountIOS")>0) {
            switch(prefs.getInt("localAuthCountIOS")){
              case 100:
                Navigator.pop(context, true);
                customAlert(is_available_face && is_available_finger
                    ? AlertDialogType.Rostro_huella_no_reconocido :
                is_available_face ? AlertDialogType.Rostro_no_reconocido
                    : AlertDialogType.Huella_no_reconocida, context, "", "",
                    responsive, widget.callback);
                break;
              case 101:
                Navigator.pop(context, true);
                customAlert(is_available_face && is_available_finger ?
                AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado :
                is_available_finger ?
                AlertDialogType.inicio_de_sesion_con_huella_bloqueado:
                AlertDialogType.inicio_de_sesion_con_facial_bloqueado, context, "", "", responsive, widget.callback);
                break;
              case 102:
              case 103:
              Navigator.pop(context, true);
              is_available_finger && is_available_face ? customAlert(
                    AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
                    responsive, widget.callback) :
                is_available_finger ? customAlert(
                    AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
                    responsive, widget.callback) :
                customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
                    responsive, widget.callback);

                break;
              default:
                break;
            }
          }else {
            try {

            if (Platform.isIOS) {
              didAuthenticate = await localAuth.authenticateWithBiometrics(
                  localizedReason:is_available_finger ?  'Coloca tu dedo para continuar.' : 'Mira fijamente a la cámara para continuar.',
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
              didAuthenticate = await localAuth.authenticateWithBiometrics(
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



        if (didAuthenticate) {
          print("didAuthenticate");
          prefs.setInt("localAuthCountIOS", 0);
          prefs.setInt("localAuthCount", 1);
          setState(() {
            checkedValue = true;
            prefs.setBool("aceptoTerminos", checkedValue);
            prefs.setBool("activarBiometricos", true);
          });

          is_available_finger && is_available_face ?
            customAlert(AlertDialogType.activacionExitosa_Huella_Face, context, "", "", responsive, widget.callback) :
          is_available_finger ?
            customAlert(AlertDialogType.activacionExitosa_Huella, context, "", "", responsive, widget.callback)
          :
          customAlert(AlertDialogType.activacionExitosa_Face, context, "", "", responsive, widget.callback);


        } else {
          setState(() {
            checkedValue = false;
            prefs.setBool("aceptoTerminos", false);
            prefs.setBool("activarBiometricos", false);
          });
          localAuth.stopAuthentication();
          bool localAuths = await localAuth.canCheckBiometrics;
          print("didAuthenticate not $localAuths ${prefs.getInt("localAuthCountIOS")}");


          if(!localAuths){
            if( prefs != null && prefs.getInt("localAuthCountIOS") != null && prefs.getInt("localAuthCountIOS")==102) {
              prefs.setInt("localAuthCountIOS", 102);
              localAuth.stopAuthentication();
              Navigator.pop(context, true);
              is_available_finger && is_available_face ? customAlert(
                  AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
                  responsive, widget.callback) :
              is_available_finger ? customAlert(
                  AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
                  responsive, widget.callback) :
              customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
                  responsive, widget.callback);
            }else{
              prefs.setInt("localAuthCountIOS", 100);
              Navigator.pop(context, true);
              customAlert(is_available_face && is_available_finger
                  ? AlertDialogType.Rostro_huella_no_reconocido :
              is_available_face ? AlertDialogType.Rostro_no_reconocido
                  : AlertDialogType.Huella_no_reconocida, context, "", "",
                  responsive, widget.callback);

            }
          }

        }
      } on PlatformException catch (e) {
        print("PlatformException ${e}");
        print("PlatformException: code ${e.code}");
        print("PlatformException: message ${e.message}");
        print("PlatformException: stacktrace ${e.stacktrace}");

        setState(() {
          checkedValue = false;
          prefs.setBool("aceptoTerminos", checkedValue);
          prefs.setBool("activarBiometricos", false);
        });

        if (e.code == auth_error.lockedOut) {
          print("auth_error.lockedOut");
          prefs.setInt("localAuthCountIOS", 100);
          prefs.setInt("localAuthCount", 5);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          customAlert(is_available_face && is_available_finger
              ? AlertDialogType.Rostro_huella_no_reconocido :
          is_available_face ? AlertDialogType.Rostro_no_reconocido
              : AlertDialogType.Huella_no_reconocida, context, "", "",
              responsive, widget.callback);
        } else if (e.code == auth_error.permanentlyLockedOut) {
          prefs.setInt("localAuthCountIOS", 101);
          print("auth_error.permanentlyLockedOut");
          prefs.setInt("localAuthCount", 6);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          customAlert(is_available_face && is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado :
          is_available_finger ?
          AlertDialogType.inicio_de_sesion_con_huella_bloqueado :
          AlertDialogType.inicio_de_sesion_con_facial_bloqueado, context, "",
              "", responsive, funcionAlerta);
        } else if (e.code == auth_error.notAvailable) {
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback);
        }else if (e.code == auth_error.otherOperatingSystem ){
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback);
          }else{
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          Navigator.pop(context, true);
          is_available_finger && is_available_face ? customAlert(
              AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          is_available_finger ? customAlert(
              AlertDialogType.HUELLA_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback) :
          customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "", "",
              responsive, widget.callback);

          }
        }
      }
  }

  void funcionAlerta(){
  }

  TextSpan getTextSpan(BuildContext context,Responsive responsive ,int type, String texto, String accion ){

    switch(type){

      case 0:
        //Texto en negritas
        return TextSpan(
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
        );
        break;
      case 1:
        // Texto normal
        return TextSpan(
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
        );
        break;
      case 2:
      // Texto URL web
        return TextSpan(
          recognizer: new TapGestureRecognizer()..onTap = () {
            print("gnp");
            launch(accion);},
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
        );
        break;
      case 3:
      // Texto numero
        return TextSpan(
          recognizer: new TapGestureRecognizer()..onTap = () {
            print("numero");
            launch(accion);},
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
        );
        break;
      case 4:
      // Texto correo
        return TextSpan(
          recognizer: new TapGestureRecognizer()..onTap = () {
            print("correo");
            launch(accion);},
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
        );
        break;
      case 5:
      // Texto accion
        return TextSpan(
          recognizer: new TapGestureRecognizer()..onTap = () {
            print("accion ${accion}");
            launch(accion);},
          text: texto,
          style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
        );
        break;
    }
  }
}
