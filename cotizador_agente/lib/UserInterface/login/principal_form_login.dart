import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/SeleccionarPreguntas.dart';
import 'package:cotizador_agente/UserInterface/login/loginPreguntasSecretas.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnboardinPage.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logoEncabezadoLogin.dart';
import 'package:custom_switch/custom_switch.dart';



class PrincipalFormLogin extends StatefulWidget {
  final Responsive responsive;
  const PrincipalFormLogin({Key key, this.responsive}) : super(key: key);
  @override
  _PrincipalFormLoginState createState() => _PrincipalFormLoginState();
}

class _PrincipalFormLoginState extends State<PrincipalFormLogin> {

  bool _saving;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerContrasena;
  TextEditingController controllerCorreo;
  FocusNode focusCorreo;
  FocusNode focusContrasena;
  bool contrasena;
  bool _huella;
  bool _validarCampo;

  @override
  void initState() {
    _saving = false;
    _huella = false;
    _validarCampo = false;
    contrasena = true;
    focusCorreo = new FocusNode();
    focusContrasena = new FocusNode();
    controllerContrasena = new TextEditingController();
    controllerCorreo = new TextEditingController();
    showOnboarding();
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
                            inputTextCorreo(responsive),
                            separacion(responsive, 2),
                            inputTextContrasena(responsive),
                            separacion(responsive, 2),
                            olvidasteContrasena(responsive),
                            separacion(responsive, 2),
                            botonInicioSesion(responsive),
                            separacion(responsive, 1),
                            activarHuella(responsive),
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
          Container(
            height: responsive.height,
            child: Opacity(
              opacity: 0.7,
              child: const ModalBarrier(dismissible: false, color: Tema.Colors.primary),
            ),
          ),
          new Center(
            child: Container(
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

  Widget subtitulo(Responsive responsive){
    return Text("Intermediario GNP\n ¡Te damos la bienvenida!", style: TextStyle(
        color: Tema.Colors.Azul_gnp,
        fontWeight: FontWeight.normal,
        fontSize: responsive.ip(3.4)
    ), textAlign: TextAlign.center,);
  }

  Widget inputTextCorreo(Responsive responsive){
    return TextFormField(
      inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9-_@.]")),
      ],
      controller: controllerCorreo,
      focusNode: focusCorreo,
      onFieldSubmitted: (S){FocusScope.of(context).requestFocus(focusContrasena);},
      obscureText: false,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          /*hintText: "Correo electrónico--",
          hintStyle: focusCorreo.hasFocus ? TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.backgroud
          ):  TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2
          ),*/
          labelText: "Correo electrónico",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: Tema.Colors.inputcorreo
          )
      ),
      validator: (value) {
        String p = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
        RegExp regExp = new RegExp(p);
        if (value.isEmpty) {
          return 'Este campo es requerido';
        } else if (regExp.hasMatch(value)) {
          return null;
        } else {
          return 'Este campo es inválido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
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
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          /*hintText: "Contraseña",
          hintStyle: focusContrasena.hasFocus ? TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.backgroud
          ):  TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2
          ),*/
          labelText: "Contraseña",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: Tema.Colors.inputcorreo
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
          color:  Tema.Colors.GNP,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2.3),
        )),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginRestablecerContrasena(responsive: widget.responsive,)));
        }
    );
  }

  Widget botonInicioSesion(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: (controllerContrasena.text != "" && controllerCorreo.text != "") ?
            Tema.Colors.GNP : Tema.Colors.botonlogin ,
          ),
          padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
          width: responsive.width,
          child: Text("INICIAR SESIÓN", style: TextStyle(
            color:  (controllerContrasena.text != "" && controllerCorreo.text != "") ?
                Tema.Colors.backgroud : Tema.Colors.botonletra,
          ),
          textAlign: TextAlign.center),
        ),
        onPressed: () async {
          print(_saving);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PreguntasSecretas(responsive: responsive,)),);
          if(_formKey.currentState.validate()){
           setState(() {
              _saving = true;
            });

            print(_saving);
            datosUsuario = await logInServices(context,controllerCorreo.text, controllerContrasena.text,controllerCorreo.text,responsive);
            print("datosUsuario ${datosUsuario.roles}");
            if(datosUsuario != null){
              redirect(responsive);
            } else {

            }
            //customAlert(AlertDialogType.verificaTuNumeroCelular, context, "", "", responsive);

            setState(() {
              _saving = false;
            });

          } else{

          } 
        }
    );
  }

  redirect( Responsive responsive) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.getBool("userRegister") != null) {
        if (prefs.getBool("userRegister") == true) {
          controllerContrasena.clear();
          controllerCorreo.clear();
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (_) => new HomePage()));
        } else{
        }
      } else {
        prefs.setBool("userRegister", true);
        if (deviceType == ScreenType.phone) {
          customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive);
        }
        else{
          customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
        }
      }
    }
  }

  showOnboarding() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.getBool("userRegister") != null) {
        if (prefs.getBool("userRegister") == true) {}
        else{
          Navigator.push(context,new MaterialPageRoute(builder: (_) => new OnboardingPage()));
        }
      } else {
          Navigator.push(context, new MaterialPageRoute(builder: (_) => new OnboardingPage()));
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
                  _huella = val;
                });
                if(_huella){
                  //TODO cambiar clasa home por prueba de biometricos
                  //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BiometricosPage(responsive: widget.responsive,)));
                  if (deviceType == ScreenType.phone) {
                    customAlert(AlertDialogType. opciones_de_inicio_de_sesion,context,"","", responsive);
                  }
                  else{
                    customAlertTablet(AlertDialogTypeTablet. opciones_de_inicio_de_sesion,context,"","", responsive);
                  }
                }
              },
              value: _huella,
              activeColor: Tema.Colors.GNP,
              activeTrackColor: Tema.Colors.biometrico,
              inactiveThumbColor: Tema.Colors.Azul_gnp,
              inactiveTrackColor:Tema.Colors.botonletra,
            ),
            /*FlutterSwitch(
              activeColor: Tema.Colors.biometrico,
              inactiveToggleColor: Tema.Colors.Azul_gnp,
              activeToggleColor: Tema.Colors.GNP,
              inactiveColor: Tema.Colors.botonletra,
              width: responsive.width * 0.12,
              height: responsive.height * 0.027,
              valueFontSize: 0.0,
              toggleSize: 18.0,
              value: _huella,
              padding: 2.0,
              showOnOff: false,
              onToggle: (val) {
                setState(() {
                  _huella = val;
                });
                if(_huella){
                  //TODO cambiar clasa home por prueba de biometricos
                 //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BiometricosPage(responsive: widget.responsive,)));
                 if (deviceType == ScreenType.phone) {
                   customAlert(AlertDialogType. opciones_de_inicio_de_sesion,context,"","", responsive);
                 }
                 else{
                  customAlertTablet(AlertDialogTypeTablet. opciones_de_inicio_de_sesion,context,"","", responsive);
                 }
                }
              },
            ),*/
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
    return Container(
      margin: EdgeInsets.only(left: responsive.wp(35), top: responsive.hp(9)),
      child: Text("Versión 2.0",
        style: TextStyle(
          color: Tema.Colors.Azul_2,
          fontSize: responsive.ip(1.5),
          fontWeight: FontWeight.normal
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }
}
