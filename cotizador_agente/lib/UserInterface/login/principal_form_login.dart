import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnboardinPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_codigo_verificacion.dart';
import 'logoEncabezadoLogin.dart';

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
    contrasena = true;
    focusCorreo = new FocusNode();
    focusContrasena = new FocusNode();
    controllerContrasena = new TextEditingController();
    controllerCorreo = new TextEditingController();
    //showOnboarding();
    if(prefs != null && prefs.getBool("userRegister") != null){
      if(prefs.getBool("userRegister")){
        prefs.setBool("hacerLogin", false);
        prefs.setBool("esPerfil", false);
        existeUsuario = true;
        _biometricos =  prefs.getBool("activarBiometricos");
        prefs.setBool("primeraVez", false);
      } else{
        _biometricos = false;
        existeUsuario = false;
        prefs.setBool("activarBiometricos", _biometricos);
        prefs.setString("contrasenaUsuario","");
        prefs.setString("correoUsuario", controllerCorreo.text);
      }
    } else {
      _biometricos = false;
      aceptoTerminos = false;
      prefs.setBool("activarBiometricos", _biometricos);
      prefs.setBool("aceptoTerminos", aceptoTerminos);
      existeUsuario = false;
      prefs.setBool("primeraVez", true);
    }
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
    return existeUsuario ?
      Text( prefs.getString("nombreUsuario") != null &&  prefs.getString("nombreUsuario")  != "" ?
      "¡ Hola ${prefs.getString("nombreUsuario")}!"
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
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
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
          if(_formKey.currentState.validate()){
           setState(() {
              _saving = true;
            });

            if(prefs.getString("correoUsuario") != null && prefs.getString("correoUsuario") != ""){
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
             setState(() {
               _saving = false;
             });
            if(datosUsuario != null){
              print("if datosUsuario ${datosUsuario}");
              prefs.setBool("hacerLogin", true);
              prefs.setBool("regitroDatosLoginExito", true);
              prefs.setString("nombreUsuario", datosPerfilador.agenteInteresadoList.elementAt(0).nombres);
              ultimaSesion = fechaPrototipo(DateTime.now().toString());
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
            });

          } else{

          } 
        }
    );
  }

  redirect( Responsive responsive) async {
    if (prefs != null) {
      if (existeUsuario) {
          controllerContrasena.clear();
          controllerCorreo.clear();
          if(_biometricos){
            if(is_available_finger != false && is_available_face != false){
              if (deviceType == ScreenType.phone) {
                customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive);
              }
              else{
                customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
              }
            } else{
              is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", responsive)
              : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", responsive);
            }

          } else{
            Navigator.push(context, new MaterialPageRoute(builder: (_) => new HomePage()));
          }

      } else {
        prefs.setBool("userRegister", true);
        if(_biometricos){
          if(is_available_finger != false && is_available_face != false){
            if (deviceType == ScreenType.phone) {
              customAlert(AlertDialogType.opciones_de_inicio_de_sesion,context,"","", responsive);
            }
            else{
              customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", responsive);
            }
          } else{
            is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", responsive)
                : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", responsive);
          }

        } else{
          if (deviceType == ScreenType.phone) {
            customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive);
          }
          else{
            customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
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