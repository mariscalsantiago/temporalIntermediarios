import 'dart:convert';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnBoardingApAutos.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnboardinPage.dart';
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
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_codigo_verificacion.dart';
import 'logoEncabezadoLogin.dart';
import 'package:intl/intl.dart';

double tamano;
String idParticipanteValidaPorCorre;
consultaMediosContactoAgentesModel mediosContacto;
DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Map<String, dynamic> deviceData = <String, dynamic>{};

class PrincipalFormLogin extends StatefulWidget {
  final Responsive responsive;
  const PrincipalFormLogin({Key key, this.responsive}) : super(key: key);
  @override
  _PrincipalFormLoginState createState() => _PrincipalFormLoginState();
}

class _PrincipalFormLoginState extends State<PrincipalFormLogin>  with WidgetsBindingObserver{

  bool _saving;
  bool _enable = true;
  bool _validEmail = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyOlvideContrasena = GlobalKey<FormState>();
  TextEditingController controllerContrasena;
  TextEditingController controllerCorreo;
  TextEditingController controllerCorreoCambioContrasena;
  FocusNode focusCorreo;
  FocusNode focusContrasena;
  FocusNode focusCorreoCambio;
  bool contrasena;
  bool _biometricos;
  //TODO 238
  bool _subSecuentaIngresoCorreo=false;
  bool existeUsuario;
  String correoUsuario;
  String contrasenaUsuario;
  bool aceptoTerminos;

  @override
  void initState() {
    correoUsuario = "";
    contrasenaUsuario = "";
    _saving = false;
    _enable = true;
    contrasena = true;
    focusCorreo = new FocusNode();
    focusContrasena = new FocusNode();
    focusCorreoCambio = new FocusNode();
    controllerContrasena = new TextEditingController();
    controllerCorreo = new TextEditingController();
    controllerCorreoCambioContrasena = new TextEditingController();

    WidgetsBinding.instance.addObserver(this);

    if(prefs.getBool("onBoardingVisible") != null && prefs.getBool("onBoardingVisible")){}
    else{
      showOnboarding();
      prefs.setBool("onBoardingVisible", true);
    }
    if(prefs != null && prefs.getBool("userRegister") != null){
      if(prefs.getBool("userRegister")){
        prefs.setBool("seHizoLogin", false);
        prefs.setBool("esPerfil", false);
        existeUsuario = true;
        _biometricos =  prefs.getBool("activarBiometricos");
        //TODO 238
        _subSecuentaIngresoCorreo =  prefs.getBool("subSecuentaIngresoCorreo");
        prefs.setBool("primeraVez", false);
      } else{
        prefs.setBool("seHizoLogin", false);
        _biometricos = false;
        existeUsuario = false;
        prefs.setBool("activarBiometricos", _biometricos);
        prefs.setString("contrasenaUsuario","");
        prefs.setString("correoUsuario", "");
        prefs.setBool("primeraVez", true);
        prefs.setString("nombreUsuario", "");
      }
    } else {
      prefs.setBool("seHizoLogin", false);
      _biometricos = false;
      aceptoTerminos = false;
      prefs.setBool("activarBiometricos", _biometricos);
      prefs.setBool("aceptoTerminos", aceptoTerminos);
      existeUsuario = false;
      prefs.setBool("primeraVez", true);
    }
    validateIntenetstatus(context, widget.responsive);
    initPlatformState(updateDeviceData);
    super.initState();
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            body: Stack(
                children: builData(widget.responsive)
            )
        ),
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();
    Form form;
    data = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            separacion(responsive, 8),
            LoginEncabezadoLogin(responsive: responsive),
            separacion(responsive, 4),
            subtitulo(responsive),
            form = new Form(
              key: _formKey,
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal:responsive.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            separacion(responsive, 6),
                            existeUsuario ? Container() : inputTextCorreo(responsive),
                            separacion(responsive, 2),
                            inputTextContrasena(responsive),
                            separacion(responsive, 2),
                            olvidasteContrasena(responsive),
                            existeUsuario ? separacion(responsive, 6) : separacion(responsive, 2),
                            botonInicioSesion(responsive),
                            separacion(responsive, 1),
                            is_available_finger|| is_available_face ? activarHuella(responsive) : Container(height: 10,width: 10,),
                            separacion(responsive, 1),
                            existeUsuario ? ingresarConOtroUsuario() : Container(),
                            separacion(responsive, 1),
                            version(responsive)
                          ]
                      )
                  )
              )
            )
        ]
       )
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          LoadingController(

          )
        ],
      );
      l.add(modal);
    }
    return l;
  }

  Widget subtitulo(Responsive responsive){
    return existeUsuario ?
      Text( prefs.getString("nombreUsuario") != null &&  prefs.getString("nombreUsuario")  != "" ?
      "¡Hola ${prefs.getString("nombreUsuario")}!"
          : "¡Hola !", style: TextStyle(
          color: Tema.Colors.Azul_gnp,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(3.4)
      ), textAlign: TextAlign.center,):
      Text( "Intermediario GNP\n ¡Te damos la bienvenida!", style: TextStyle(
          color: Tema.Colors.Azul_gnp,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(3.4)
      ), textAlign: TextAlign.center,)
    ;
  }

  Widget inputTextCorreo(Responsive responsive){
    return TextFormField(
      inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@.ñ]")),
      ],
      autofocus: true,
      controller: controllerCorreo,
      focusNode: focusCorreo,
      onFieldSubmitted: (S){FocusScope.of(context).requestFocus(focusContrasena);},
      obscureText: false,
      enabled: _enable,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Correo electrónico",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusCorreo.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          )
      ),
      validator: (value) {
        String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
        setState(() {});
        RegExp regExp = new RegExp(p);
        if (value.isEmpty) {
          _validEmail  = false;
          return 'Este campo es requerido';
        } else if (regExp.hasMatch(value)) {
          _validEmail  = true;
          return null;
        } else {
          _validEmail  = false;
          return 'Este campo es inválido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          //Todo 116
          prefs.setString("correoUsuario", controllerCorreo.text);
          String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
          RegExp regExp = new RegExp(p);
          if (value.isEmpty) {
            _validEmail  = false;
          } else if (regExp.hasMatch(value)) {
            _validEmail  = true;
            return null;
          } else {
            _validEmail  = false;
          }
          focusCorreo.hasFocus;
          controllerCorreo.text;
        });
      },
    );
  }

  Widget inputTextContrasena(Responsive responsive){
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
      ],
      controller: controllerContrasena,
      focusNode: focusContrasena,
      obscureText: contrasena,
      enabled: _enable,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Contraseña",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusContrasena.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          ),
          suffixIcon: IconButton(
            icon: contrasena == false || controllerContrasena.text == "" ? Image.asset("assets/login/vercontrasena.png") : Image.asset("assets/login/novercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                contrasena = !contrasena;
              });
            },
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusContrasena.hasFocus;
          controllerContrasena.text;
        });
      },
    );
  }

  Widget olvidasteContrasena(Responsive responsive){
    controllerCorreoCambioContrasena.text = prefs.getString("correoUsuario");
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text("¿Olvidaste tu contraseña?", style: TextStyle(
          color: Tema.Colors.GNP ,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2.3),
        )),
        onPressed: (){
          controllerCorreoCambioContrasena.text = "";
          focusContrasena.unfocus();
          focusCorreo.unfocus();
          focusCorreoCambio.requestFocus();
          dialogo(context, responsive);

        }
    );
  }

  Future<dynamic> dialogo(BuildContext context, Responsive responsive){
    Responsive _generalResponsive = Responsive.of(context);
    tamano = _generalResponsive.hp(57);

    return  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context)  {
        return WillPopScope(
          onWillPop: (){
            setState(() {
              //Navigator.pop(context);
              tamano = _generalResponsive.hp(57);
              focusCorreoCambio.unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
            });
          },
          child: Stack(children: [
            GestureDetector(
              onTap: (){
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
              margin: EdgeInsets.only(top: focusCorreoCambio.hasFocus ?
              MediaQuery.of(context).size.height / 2 - 250 // adjust values according to your need
                  : MediaQuery.of(context).size.height / 2 + 15 ),
              height: _generalResponsive.hp(44),
              width: _generalResponsive.width,
              child: Card(
                color: Tema.Colors.White,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                      EdgeInsets.only(top: _generalResponsive.height * 0.03),

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
                          top: _generalResponsive.height * 0.04,
                          bottom: _generalResponsive.height * 0.01,
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
                      margin: EdgeInsets.only(left: _generalResponsive.wp(4), right: _generalResponsive.wp(4)),
                      child: //inputTextCorreoCambio(responsive)
                      Form(
                        key: _formKeyOlvideContrasena,
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@. ñ]")),
                            ],
                            controller: controllerCorreoCambioContrasena,
                            focusNode: focusCorreoCambio,

                            onSaved: (vc){
                              setState(() {
                                tamano = _generalResponsive.hp(57);
                                focusCorreoCambio.unfocus();
                              });
                            },

                            onEditingComplete: (){
                              setState(() {
                                tamano = _generalResponsive.hp(57);
                                focusCorreoCambio.unfocus();
                              });
                            },
                            onFieldSubmitted: (S) {
                              setState(() {
                                tamano = _generalResponsive.hp(57);
                                focusCorreoCambio.unfocus();
                              });
                            },
                            obscureText: false,
                            enabled: _enable,

                            autofocus: true,
                            cursorColor: Tema.Colors.GNP,
                            decoration: new InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Tema.Colors.inputlinea),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Tema.Colors.inputlinea),
                                ),
                                labelText: "Correo electrónico",
                                labelStyle: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.normal,
                                    fontSize: _generalResponsive.ip(1.7),
                                    color: Tema.Colors.inputcorreo
                                )
                            ),
                            validator: (value) {
                              String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
                              RegExp regExp = new RegExp(p);
                              if (value.isEmpty) {
                                _validEmail  = false;
                                return 'Este campo es requerido';
                              } else if (regExp.hasMatch(value)) {
                                _validEmail  = true;
                                return null;
                              } else {
                                _validEmail  = false;
                                return 'Este campo es inválido';
                              }
                              return null;
                            },
                            onTap: (){
                              print("Focusssssssssssss");
                              print("Focusssssssssssss");
                              setState(() {
                                tamano = _generalResponsive.hp(30);
                              });
                              setState(() {
                                tamano;
                                print("tamano ${tamano}");
                              });
                            }
                        ),
                      )
                  ),
                  Container(
                    height: _generalResponsive.hp(6.25),
                    width: _generalResponsive.wp(90),
                    margin: EdgeInsets.only( top: _generalResponsive.height * 0.03,  left: _generalResponsive.wp(4.4),  right: _generalResponsive.wp(4.4), bottom: _generalResponsive.hp(4)),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: controllerCorreoCambioContrasena.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
                      onPressed: () async {
                        if(_formKeyOlvideContrasena.currentState.validate()){
                          Navigator.pop(context);
                          setState(() {
                            _saving = true;
                          });

                            validarCodigoVerificacion(_generalResponsive);

                          }

                        },
                        child: Text(
                          "ACEPTAR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: controllerCorreoCambioContrasena.text != "" ? Tema.Colors.White :  Tema.Colors.botonletra,
                            fontSize: _generalResponsive.ip(2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  validarCodigoVerificacion(Responsive responsive) async{
    prefs.setBool('flujoOlvideContrasena', true);
    prefs.setString("correoCambioContrasena", controllerCorreoCambioContrasena.text);
    UsuarioPorCorreo respuesta = await  consultaUsuarioPorCorreo(context, prefs.getString("correoCambioContrasena"));

    print("UsuarioPorCorreo ${respuesta}" );
    if(respuesta != null){
      if(respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.idParticipante != ""){
        idParticipanteValidaPorCorre = respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.uid;

        mediosContacto = await  consultaMediosContactoServicio(context, idParticipanteValidaPorCorre);

        if(mediosContacto != null){
          prefs.setString("codigoAfiliacion", mediosContacto.codigoFiliacion);
          List<telefonosModel> teledonosLista = [];
          teledonosLista = obtenerMedioContacto(mediosContacto);
          if(teledonosLista.length > 0){
            prefs.setString("medioContactoTelefono", teledonosLista[0].lada+teledonosLista[0].valor);
          } else {
            prefs.setString("medioContactoTelefono", "");
          }
        } else{
          prefs.setString("medioContactoTelefono", "");
          ConsultarPorIdParticipanteConsolidado consulta =  await ConsultarPorIdParticipanteServicio(context, datosUsuario.idparticipante);
          if(consulta != null){
            prefs.setString("codigoAfiliacion", consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.datosGenerales.idParticipanteConsolidado);
          } else{

          }
        }

        OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoCambioContrasena"), "", prefs.getBool('flujoOlvideContrasena'));

        setState(() {
          _saving = false;
        });

        print("optRespuesta  ${optRespuesta}");

        if(optRespuesta != null){
          if(optRespuesta.error == "" && optRespuesta.idError == ""){
            prefs.setString("idOperacion", optRespuesta.idOperacion);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,isNumero: false,)));
          } else{
            customAlert(AlertDialogType.errorServicio,context,"","", responsive, funcionAlerta);
          }
        } else{
          customAlert(AlertDialogType.errorServicio,context,"","", responsive, funcionAlerta);
        }
      } else {
        setState(() {
          _saving = false;
        });
        customAlert(AlertDialogType.Correo_no_registrado,context,"","", responsive, funcionAlerta);

      }
    } else {
      setState(() {
        _saving = false;
      });
      customAlert(AlertDialogType.Correo_no_registrado,context,"","", responsive, funcionAlerta);
    }

  }

  Widget inputTextCorreoCambio(Responsive responsive){

    return TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@. ñ]")),
        ],
        controller: controllerCorreoCambioContrasena,
        focusNode: focusCorreoCambio,
        onFieldSubmitted: (S) {
          tamano = responsive.hp(57);
          focusCorreoCambio.unfocus();
        },
        obscureText: false,
        enabled: _enable,
        cursorColor: Tema.Colors.GNP,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.inputlinea),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.inputlinea),
            ),
            labelText: "Correo electrónico",
            labelStyle: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.normal,
                fontSize: responsive.ip(1.7),
                color: Tema.Colors.inputcorreo
            )
        ),
        validator: (value) {
          String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
          RegExp regExp = new RegExp(p);
          if (value.isEmpty) {
            _validEmail  = false;
            return 'Este campo es requerido';
          } else if (regExp.hasMatch(value)) {
            _validEmail  = true;
            return null;
          } else {
            _validEmail  = false;
            return 'Este campo es inválido';
          }
          return null;
        },
        onTap: (){
          print("Focusssssssssssss");
          print("Focusssssssssssss");
          setState(() {
            tamano = responsive.hp(30);
          });
          setState(() {
              tamano;
              print("tamano ${tamano}");
          });


        }
    );
  }

  Widget botonInicioSesion(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: (controllerContrasena.text != "" && controllerCorreo.text != "") || (existeUsuario && controllerContrasena.text != "") ?
            Tema.Colors.GNP : Tema.Colors.botonlogin ,
          ),
          padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
          width: responsive.width,
          child: Text("INICIAR SESIÓN", style: TextStyle(
            color:  (controllerContrasena.text != "" && controllerCorreo.text != "")  || (existeUsuario && controllerContrasena.text != "")?
                Tema.Colors.backgroud : Tema.Colors.botonletra,
          ),
          textAlign: TextAlign.center),
        ),
        onPressed: () async {

          if(!_saving){
            if(_formKey.currentState.validate()){
             setState(() {
                _saving = true;
                _enable = false;
              });

              if(prefs.getString("correoUsuario") != null && prefs.getString("correoUsuario") != "" ){
                 correoUsuario = prefs.getString("correoUsuario");
                 if(controllerContrasena.text != prefs.getString("contrasenaUsuario")){
                   contrasenaUsuario = controllerContrasena.text;
                   prefs.setString("contrasenaUsuario", contrasenaUsuario);
                 } else{
                   contrasenaUsuario = prefs.getString("contrasenaUsuario");
                 }

              }
              else {
                prefs.setString("correoUsuario", controllerCorreo.text);
                correoUsuario = controllerCorreo.text;
                prefs.setString("contrasenaUsuario", controllerContrasena.text);
                contrasenaUsuario = controllerContrasena.text;
                print("ELSE correoUsuario ${correoUsuario}");
                print("contrasenaUsuario ${contrasenaUsuario}");
              }
              datosUsuario = await logInServices(context,correoUsuario, contrasenaUsuario, correoUsuario,responsive);
              UsuarioPorCorreo respuesta;
              if(datosUsuario != null){
                 respuesta = await  consultaUsuarioPorCorreo(context, correoUsuario);
                 print("respuesta  ${respuesta}");
              }

              if(datosUsuario != null && respuesta != null && respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.estatusUsuario == "ACTIVO"){

                mediosContacto = await  consultaMediosContactoServicio(context, datosUsuario.idparticipante);
                print("mediosContacto ${mediosContacto}");

                if(mediosContacto != null){
                  prefs.setString("codigoAfiliacion", mediosContacto.codigoFiliacion);
                  List<telefonosModel> teledonosLista = [];
                  teledonosLista = obtenerMedioContacto(mediosContacto);
                  if(teledonosLista.length > 0){
                    prefs.setString("medioContactoTelefono", teledonosLista[0].lada+teledonosLista[0].valor);
                  } else {
                    prefs.setString("medioContactoTelefono", "");
                  }

                }
                else{
                  prefs.setString("medioContactoTelefono", "");
                  ConsultarPorIdParticipanteConsolidado consulta =  await ConsultarPorIdParticipanteServicio(context, datosUsuario.idparticipante);
                  if(consulta != null){
                    print("afiliacion ${consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.datosGenerales.idParticipanteConsolidado} ");
                    prefs.setString("codigoAfiliacion", consulta.consultarPorIdParticipanteConsolidadoResponse.personaConsulta.persona.datosGenerales.idParticipanteConsolidado);
                  } else{

                  }

                }

                if(!existeUsuario){
                  consultaPreguntasSecretasModel preguntas = await consultarPreguntaSecretaServicio(context, datosUsuario.idparticipante);

                  print("preguntas ${preguntas.requestStatus}");

                  setState(() {
                    _saving = false;
                    _enable = true;
                  });

                  if(preguntas != null){
                    if(preguntas.requestStatus == "FAILED" && preguntas.error != ""){
                        prefs.setBool('primeraVezIntermediario', true);
                    } else{
                        prefs.setBool('primeraVezIntermediario', false);
                    }
                  } else{

                  }

                } else{
                  setState(() {
                    _saving = false;
                    _enable = true;
                  });

                }

                prefs.setBool("seHizoLogin", true);
                prefs.setBool("regitroDatosLoginExito", true);
                prefs.setString("nombreUsuario", datosPerfilador.agenteInteresadoList.elementAt(0).nombres);
                prefs.setString("currentDA", datosPerfilador.daList.elementAt(0).cveDa);
                prefs.setString("currentCUA",  datosPerfilador.daList.elementAt(0).codIntermediario[0]);

                redirect(responsive);
              }
              else {
                setState(() {
                  _saving = false;
                  _enable = true;
                });
                print("else datosUsuario ${datosUsuario}");
                if(prefs.getBool("regitroDatosLoginExito") != null && prefs.getBool("regitroDatosLoginExito")) {

                } else if(respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.estatusUsuario != "ACTIVO"){

                  customAlert(AlertDialogType.Cuenta_inactiva,context,"","", responsive, funcionAlertaHullaLogin);
                  prefs.setBool("regitroDatosLoginExito", false);
                  prefs.setString("nombreUsuario", "");
                  prefs.setString("correoUsuario", "");
                  prefs.setString("contrasenaUsuario", "");

                } else{
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

            } else{}
          }
        }
    );
  }

  List<telefonosModel> obtenerMedioContacto(consultaMediosContactoAgentesModel mediosContacto){

    List<telefonosModel> teledonosLista = [];
    telefonosModel telefono;

    if(mediosContacto != null && mediosContacto.mediosContacto != null && mediosContacto.mediosContacto.telefonos != null) {
      for (int i = 0; i < mediosContacto.mediosContacto.telefonos.length; i++) {
        telefono = mediosContacto.mediosContacto.telefonos[i];

        if (telefono.propositosContacto != null && telefono.tipoContacto.id == "TLCL") {
          //TODO validar nulos maria@bonos.com mexico.18
          for (int i = 0; i < telefono.propositosContacto.length; i++) {
            if (telefono.propositosContacto[i].id == "CAA") {
              teledonosLista.add(telefono);
            }
          }
        }
      }
    }

    if(teledonosLista.length>0){
        if(teledonosLista.length > 1){
          teledonosLista.sort((b, a){
            return a.idMedioContacto.compareTo(b.idMedioContacto);
          });
        }
    }

    return teledonosLista;

  }

  redirect( Responsive responsive) async {
    prefs.setBool('flujoOlvideContrasena', false);
    if (prefs != null) {
      if (existeUsuario) {
          controllerContrasena.clear();
          controllerCorreo.clear();
          //TODO 238
          if(_biometricos && !_subSecuentaIngresoCorreo ){
            if(is_available_finger != false && is_available_face != false){
              if (deviceType == ScreenType.phone) {
                customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlertaHullaLogin);
              }
              else{
                customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
              }
            } else{
              prefs.setBool("esFlujoBiometricos", true);
              is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", responsive, funcionAlertaHullaLogin)
              : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", responsive, funcionAlertaHullaLogin);
            }

          } else{
            if(prefs.getBool("flujoCompletoLogin") != null && prefs.getBool("flujoCompletoLogin")){
              Navigator.push(context, new MaterialPageRoute(builder: (_) => new HomePage(responsive: responsive,)));
            } else{
              if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){

                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));

              } else{
                if (deviceType == ScreenType.phone) {
                  prefs.setBool("esFlujoBiometricos", false);
                  customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlertaCodVerificacion);
                }
                else{
                  customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
                }
              }
            }
          }

      }
      else {
        prefs.setBool("userRegister", true);
        if(_biometricos) {
          if(is_available_finger != false && is_available_face != false){
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlertaHullaLogin);
            }
            else{
              customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
            }
          } else{
            prefs.setBool("esFlujoBiometricos", true);
            is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", responsive, funcionAlertaHullaLogin)
                : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", responsive, funcionAlertaHullaLogin);
          }

        } else{
          if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){

            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));

          } else{

            if (deviceType == ScreenType.phone) {
              prefs.setBool("esFlujoBiometricos", false);
              customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlertaCodVerificacion);
            }
            else{
              customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
            }

          }

        }
      }
    }
  }

  Widget ingresarConOtroUsuario(){

    return CupertinoButton(
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
    );

  }

  showOnboarding() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.getBool("userRegister") != null) {
        if (prefs.getBool("userRegister") == true) {}
        else{
          Navigator.push(context,new MaterialPageRoute(builder: (_) => OnBoardingAppAutos()));
        }
      } else {
          Navigator.push(context, new MaterialPageRoute(builder: (_) => OnBoardingAppAutos()));
      }
    }
  }

  Widget activarHuella(Responsive  responsive ){
    return  Container(
      margin: EdgeInsets.only(top: 28, bottom: 32),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Switch(
              onChanged:(val) {
                setState(() {
                  _biometricos = val;
                  prefs.setBool("activarBiometricos", _biometricos);
                });
              },
              value: _biometricos,
              activeColor: Tema.Colors.GNP,
              activeTrackColor: Tema.Colors.biometrico,
              inactiveThumbColor: Tema.Colors.Azul_gnp,
              inactiveTrackColor:Tema.Colors.botonletra,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: responsive.wp(2)),
                child: Text("Inicio de sesión con datos biométricos",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(1.9),
                      color: Tema.Colors.Azul_2
                  ),),
              ),
            ),
          ]
      ),
    );
  }

  Widget version(Responsive responsive){
    return Center(
      child: Container(
        //margin: EdgeInsets.only( top: responsive.hp(0.5), bottom: responsive.hp(0.5)),
        child: GestureDetector(
          onLongPress: (){
              initPlatformState(updateDeviceData);
            customAlert(AlertDialogType.versionTag, context, "",  "", responsive,funcion);
          },
          child: Text("Versión 2.0",
            style: TextStyle(
              color: Tema.Colors.Azul_2,
              fontSize: responsive.ip(1.5),
              fontWeight: FontWeight.normal
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  void funcionAlerta( bool abc){

  }
  void updateDeviceData(  Map<String, dynamic> deviceDato){
    setState(() {
      deviceData = deviceDato;
    });
  }

  void funcionAlertaCodVerificacion (Responsive responsive) async{

    setState(() {
      _saving=true;
    });
    OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoUsuario"), prefs.getString("medioContactoTelefono"), prefs.getBool('flujoOlvideContrasena'));

    setState(() {
      _saving = false;
    });

    if(optRespuesta != null){
      if(optRespuesta.error == "" && optRespuesta.idError == "") {
        prefs.setString("idOperacion", optRespuesta.idOperacion);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginCodigoVerificaion(
                      responsive: responsive,
                      isNumero: false,
                    )
            )
        );
      } else{
        customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
      }
    } else{
      customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
    }

  }

  void funcionAlertaHullaLogin(bool activarBiometricos, Responsive responsive) async{
    print("funcionAlertaHullaLogin");

    if(!activarBiometricos){
      setState(() {
        _biometricos = activarBiometricos;
      });
      prefs.setBool("activarBiometricos", _biometricos);
    } else{
      if(prefs.getBool("primeraVez") || prefs.getBool("flujoCompletoLogin") == null || !prefs.getBool("flujoCompletoLogin")){
        setState(() {
          _saving=true;
        });
        OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoUsuario"), prefs.getString("medioContactoTelefono"), prefs.getBool('flujoOlvideContrasena'));

        setState(() {
          _saving = false;
        });

        if(optRespuesta != null){
          if(optRespuesta.error == "" && optRespuesta.idError == "") {
            prefs.setString("idOperacion", optRespuesta.idOperacion);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LoginCodigoVerificaion(
                          responsive: responsive,
                          isNumero: false,
                        )
                )
            );
          } else{
            customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
          }
        } else{
          customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
        }

      }

    }
  }

  void funcionCanselBiometrics(){
    setState(() {
      prefs.setBool("activarBiometricos", false);
    });
//    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: widget.responsive)));
  }
}

void ultimoAcceso() async {
  print("== Firebase ==");
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
  await _dataBaseReference.child("accesoUsuarios").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
    var jsoonn = json.encode(_snapshot.value);
    Map response = json.decode(jsoonn);

    if(response!= null && response.isNotEmpty){
      String dateFirebase = response["ultimoAcceso"]!= null ? response["ultimoAcceso"]:"";
      print("if dateFirebase  ${dateFirebase}");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss').format(now);
      validacionAcceso(dateFirebase, formattedDate);
      print("formattedDate  ${formattedDate}");
      Map<String, dynamic> mapa = {
        '${datosUsuario.idparticipante}': {
          'ultimoAcceso' : formattedDate
        }
      };
      _dataBaseReference.child("accesoUsuarios").update(mapa);

    }else{
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy hh:mm:ss').format(now);
      print("else formattedDate  ${formattedDate}");
      prefs.setString("ultimoAcceso", formattedDate);
      prefs.setBool("primerAccesoFecha", true);
      Map<String, dynamic> mapa = {
        '${datosUsuario.idparticipante}': {
          'ultimoAcceso' : formattedDate
        }
      };

      _dataBaseReference.child("accesoUsuarios").update(mapa);

    }
  });
}

void validacionAcceso(String dataFirebase, String dateNow){

  prefs.setBool("primerAccesoFecha", false);

  String diaFirebase = dataFirebase.substring(0,2);
  String mesFirebase = dataFirebase.substring(3,5);
  String anioFirebase = dataFirebase.substring(6,10);

  String diaPrefs = dateNow.substring(0,2);
  String mesPrefs = dateNow.substring(3,5);
  String anioPrefs = dateNow.substring(6,10);

  if((diaFirebase == diaPrefs) && (mesFirebase == mesPrefs) && (anioFirebase == anioPrefs)) {
    print("Fechaa now");
    prefs.setBool("ultimoAccesoHoy", true);
    prefs.setBool("ultimoAccesoAyer", false);
  } else if((mesFirebase == mesPrefs) && (anioFirebase == anioPrefs) && (int.parse(diaPrefs) +1 == int.parse(diaFirebase))){
    print("Fehca ayer");
    prefs.setBool("ultimoAccesoHoy", false);
    prefs.setBool("ultimoAccesoAyer", true);
  } else{
    print("Fehca otro dia");
    prefs.setBool("ultimoAccesoHoy", false);
    prefs.setBool("ultimoAccesoAyer", false);
  }
  prefs.setString("ultimoAcceso", dataFirebase);

}

void funcion(){

}

