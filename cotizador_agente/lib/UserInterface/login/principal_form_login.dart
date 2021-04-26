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
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultarUsuarioPorCorreo.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_codigo_verificacion.dart';
import 'logoEncabezadoLogin.dart';

double tamano;
String idParticipanteValidaPorCorre;
consultaMediosContactoAgentesModel mediosContacto;

class PrincipalFormLogin extends StatefulWidget {
  final Responsive responsive;
  const PrincipalFormLogin({Key key, this.responsive}) : super(key: key);
  @override
  _PrincipalFormLoginState createState() => _PrincipalFormLoginState();
}

class _PrincipalFormLoginState extends State<PrincipalFormLogin> {

  bool _saving;
  bool _enable = true;
  bool _validEmail = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerContrasena;
  TextEditingController controllerCorreo;
  TextEditingController controllerCorreoCambioContrasena;
  FocusNode focusCorreo;
  FocusNode focusContrasena;
  FocusNode focusCorreoCambio;
  bool contrasena;
  bool _biometricos;
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
    super.initState();
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
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@. ñ]")),
      ],
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
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text("¿Olvidaste tu contraseña?", style: TextStyle(
          color: Tema.Colors.GNP ,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2.3),
        )),
        onPressed: (){
          controllerCorreoCambioContrasena.text = "";
          dialogo(context, responsive);

        }
    );
  }

  Future<dynamic> dialogo(BuildContext context, Responsive responsive){
    tamano = responsive.hp(57);
    print( " tamano ------ ${tamano}");
    return  showDialog(
      context: context,
      builder: (context)  {
        return Stack(children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              height: responsive.height,
              width: responsive.width,
              color: Tema.Colors.Azul_gnp,
            ),
          ),
          Container(
            /*margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,

                top: responsive.hp(15)),
            top: responsive.hp(15)

            ),*/
            margin: EdgeInsets.only(top: focusCorreoCambio.hasFocus ?
            MediaQuery.of(context).size.height / 2 - 250 // adjust values according to your need
                : MediaQuery.of(context).size.height / 2 + 15 ),
            height: responsive.hp(44),
            width: responsive.width,
            child: Card(
              color: Tema.Colors.White,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                    EdgeInsets.only(top: responsive.height * 0.03),

                    child: Center(
                      child: Text(
                        "Olvide contraseña",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Tema.Colors.Encabezados,
                            fontSize: responsive.ip(2.3)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: responsive.height * 0.04,
                        bottom: responsive.height * 0.01,
                        right: responsive.wp(1),
                        left: responsive.wp(5)),
                    child: Text(
                      "Por tu seguridad es necesario que ingreses nuevamente tu correo electrónico.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Tema.Colors.Funcional_Textos_Body,
                          fontSize: responsive.ip(2.0)),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: responsive.wp(4), right: responsive.wp(4)),
                      child: //inputTextCorreoCambio(responsive)
                      TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@. ñ]")),
                          ],
                          controller: controllerCorreoCambioContrasena,
                          focusNode: focusCorreoCambio,
                          onEditingComplete: (){
                            setState(() {
                              tamano = responsive.hp(57);
                              focusCorreoCambio.unfocus();
                            });
                          },
                          onFieldSubmitted: (S) {
                            setState(() {
                              tamano = responsive.hp(57);
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
                      )


                  ),
                  Container(
                    height: responsive.hp(6.25),
                    width: responsive.wp(90),
                    margin: EdgeInsets.only( top: responsive.height * 0.03,  left: responsive.wp(4.4),  right: responsive.wp(4.4), bottom: responsive.hp(4)),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: controllerCorreoCambioContrasena.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
                      onPressed: () async {
                        if(controllerCorreoCambioContrasena.text != ""){
                          prefs.setString("correoCambioContrasena", controllerCorreoCambioContrasena.text);
                          UsuarioPorCorreo respuesta = await  consultaUsuarioPorCorreo(context, prefs.getString("correoCambioContrasena"));
                          print("respuesta correo ${respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.nombre}");
                          if(respuesta != null){
                            if(respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.idParticipante != ""){
                              idParticipanteValidaPorCorre = respuesta.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.uid;

                              prefs.setBool('flujoOlvideContrasena', true);
                              OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoCambioContrasena"), "", prefs.getBool('flujoOlvideContrasena'));

                              print("optRespuesta  ${optRespuesta}");
                              if(optRespuesta != null){

                                if(optRespuesta.error == "" && optRespuesta.idError == ""){
                                  Navigator.pop(context,true);
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
                                } else{

                                }

                              } else{

                              }
                            } else {
                              Navigator.pop(context,true);
                              customAlert(AlertDialogType.Correo_no_registrado,context,"","", responsive, funcionAlerta);

                            }
                          } else {
                            Navigator.pop(context,true);
                            customAlert(AlertDialogType.Correo_no_registrado,context,"","", responsive, funcionAlerta);
                          }
                        }

                      },
                      child: Text(
                        "ACEPTAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: controllerCorreoCambioContrasena.text != "" ? Tema.Colors.White :  Tema.Colors.botonletra,
                          fontSize: responsive.ip(2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
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
          print(_saving);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PreguntasSecretas(responsive: responsive,)),);
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

               print("correoUsuario ${correoUsuario}");
               print("contrasenaUsuario ${contrasenaUsuario}");

            } else {
              prefs.setString("correoUsuario", controllerCorreo.text);
              correoUsuario = controllerCorreo.text;
              prefs.setString("contrasenaUsuario", controllerContrasena.text);
              contrasenaUsuario = controllerContrasena.text;
              print("ELSE correoUsuario ${correoUsuario}");
              print("contrasenaUsuario ${contrasenaUsuario}");
            }
            datosUsuario = await logInServices(context,correoUsuario, contrasenaUsuario, correoUsuario,responsive);

            if(datosUsuario != null){

              mediosContacto = await  consultaMediosContactoServicio(context, datosUsuario.idparticipante);
              print("mediosContacto ${mediosContacto}");

              if(mediosContacto != null){
                List<telefonosModel> teledonosLista = [];
                teledonosLista = obtenerMedioContacto(mediosContacto);
                if(teledonosLista.length > 0){
                  prefs.setString("medioContactoTelefono", teledonosLista[0].lada+teledonosLista[0].valor);
                  print("telefono ${teledonosLista[0].lada+teledonosLista[0].valor}");
                } else {
                  prefs.setString("medioContactoTelefono", "");
                }

              } else{
                prefs.setString("medioContactoTelefono", "");

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
              print("if datosUsuario ${datosUsuario}");
              print("idparticipante--- ${datosUsuario.idparticipante}");
              prefs.setBool("seHizoLogin", true);
              prefs.setBool("regitroDatosLoginExito", true);
              prefs.setString("nombreUsuario", datosPerfilador.agenteInteresadoList.elementAt(0).nombres);
              prefs.setString("currentDA", datosPerfilador.daList.elementAt(0).cveDa);
              prefs.setString("currentCUA",  datosPerfilador.daList.elementAt(0).codIntermediario[0]);

              ultimaSesion = fechaPrototipo(DateTime.now().toString());
              //ultimoAcceso();
              redirect(responsive);
            } else {
              print("else datosUsuario ${datosUsuario}");
              if(prefs.getBool("regitroDatosLoginExito") != null && prefs.getBool("regitroDatosLoginExito")) {

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

          } else{} }
        }
    );
  }

  List<telefonosModel> obtenerMedioContacto(consultaMediosContactoAgentesModel mediosContacto){

    List<telefonosModel> teledonosLista = [];
    telefonosModel telefono;

    for(int i = 0 ; i < mediosContacto.mediosContacto.telefonos.length; i++){

      telefono = mediosContacto.mediosContacto.telefonos[i];

      if(telefono.tipoContacto.id=="TLCL"){

        for(int i =0 ; i < telefono.propositosContacto.length; i++){
            if(telefono.propositosContacto[i].id == "CAA"){
              teledonosLista.add(telefono);
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
          if(_biometricos){
            if(is_available_finger != false && is_available_face != false){
              if (deviceType == ScreenType.phone) {
                customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlerta);
              }
              else{
                customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
              }
            } else{
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
                  customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlerta);
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
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive, funcionAlerta);
            }
            else{
              customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
            }
          } else{
            is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", responsive, funcionAlertaHullaLogin)
                : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", responsive, funcionAlertaHullaLogin);
          }

        } else{
          if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){

            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));

          } else{

            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, funcionAlerta);
            }
            else{
              customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
            }

          }

        }
      }
    }
  }

  ingresarConOtroUsuario(){

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
        child: Text("Versión 2.0",
          style: TextStyle(
            color: Tema.Colors.Azul_2,
            fontSize: responsive.ip(1.5),
            fontWeight: FontWeight.normal
          ),
          textAlign: TextAlign.center,
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
    setState(() {});
  }

  void funcionAlertaHullaLogin(bool activar){
      setState(() {
        _biometricos = activar;
      });
      prefs.setBool("activarBiometricos", _biometricos);
  }
}



String fechaPrototipo(String fecha){
  String ano = fecha.substring(0, 4);
  String mes = fecha.substring(5,7);
  String dia = fecha.substring(8,10);
  String hora = fecha.substring(11,13);
  String minutos = fecha.substring(14,16);
  String anoDosDigitos = ano.substring(2,4);
  print("fecha: ${fecha}");
  print("ano: ${ano}");
  print("mes: ${mes}");
  print("dia: ${dia}");
  print("hora: ${hora}");
  print("minutos: ${minutos}");
  print("anoDosDigitos: ${anoDosDigitos}");

  String valorMes = "";
  String valorHora = "";
  switch(mes) {
    case "01":
      valorMes = "Ene";
      break;
    case "02":
      valorMes = "Feb";
      break;
    case "03":
      valorMes = "Mar";
      break;
    case "04":
      valorMes = "Abr";
      break;
    case "05":
      valorMes = "May";
      break;
    case "06":
      valorMes = "Jun";
      break;
    case "07":
      valorMes = "Jul";
      break;
    case "08":
      valorMes = "Ago";
      break;
    case "09":
      valorMes = "Sep";
      break;
    case "10":
      valorMes = "Oct";
      break;
    case "11":
      valorMes = "Nov";
      break;
    case "12":
      valorMes = "Dic";
      break;
  }
  switch(hora) {
    case "01": case "02": case "03": case "04": case "05": case "06":case "07": case "08": case "09": case "10": case "11": case "12":
    valorHora = "${hora}:${minutos}am";
    break;

    case "13":
      valorHora = "01:${minutos}pm";
      break;
    case "14":
      valorHora = "02:${minutos}pm";
      break;
    case "15":
      valorHora = "03:${minutos}pm";
      break;
    case "16":
      valorHora = "04:${minutos}pm";
      break;
    case "17":
      valorHora = "05:${minutos}pm";
      break;
    case "18":
      valorHora = "06:${minutos}pm";
      break;
    case "19":
      valorHora = "07:${minutos}pm";
      break;
    case "20":
      valorHora = "08:${minutos}pm";
      break;
    case "21":
      valorHora = "09:${minutos}pm";
      break;
    case "22":
      valorHora = "10:${minutos}pm";
      break;
    case "23":
      valorHora = "11:${minutos}pm";
      break;
    default :
      valorHora = "${hora}:${minutos}";
  }


  return "${dia}/${valorMes}/${ano} ${valorHora}";
}

void ultimoAcceso() async {
  print("== Firebase ==");
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
  await _dataBaseReference.child("accesoUsuarios").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
    var jsoonn = json.encode(_snapshot.value);
    Map response = json.decode(jsoonn);


    List<Map<String, String>> user = [];
    response.forEach((key, value) {
      //user.add(key: value['accesoUser']);
    });

    if(response!= null && response.isNotEmpty){
    String dateFirebase = response["ultimoAcceso"]!= null ? response["ultimoAcceso"]:"";
    }else{
      _dataBaseReference.child("accesoUsuarios").set("");
    }
    print("Data --- ${_snapshot.value}");
    //print("Environment: " + validateNotEmptyToString(_snapshot.value, ""));
  });

}

