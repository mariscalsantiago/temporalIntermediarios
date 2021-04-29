import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';

import 'loginRestablecerContrasena.dart';

bool timerEnd = false;

class LoginCodigoVerificaion extends StatefulWidget {
  final isNumero;
  final Responsive responsive;
  const LoginCodigoVerificaion({Key key, this.responsive,this.isNumero}) : super(key: key);
  @override
  _LoginCodigoVerificaionState createState() => _LoginCodigoVerificaionState();
}

class _LoginCodigoVerificaionState extends State<LoginCodigoVerificaion> {

  bool _saving;
  bool _validCode=true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerCodigo;
  FocusNode focusCodigo;
  String codigoValidacion;

  @override
  void initState() {
    _saving = false;
    timerEnd = false;
    focusCodigo = new FocusNode();
    controllerCodigo = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor:Tema.Colors.backgroud,
          appBar: AppBar(
            backgroundColor: Tema.Colors.backgroud,
            elevation: 0,
            title: Text('Código de verificación', style: TextStyle(
              color: Tema.Colors.Azul_2,
              fontWeight: FontWeight.normal,
              fontSize: widget.responsive.ip(2.5)
            ),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close,
                color: Tema.Colors.GNP,),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
          ),
          body: Stack(
              children: builData(widget.responsive)
          )
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();
    Form form;

    data = SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(6)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: responsive.hp(2.5)),
                    child: Text(
                      "Código de verificación", style: TextStyle(
                      color: Tema.Colors.Encabezados,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.3)
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: responsive.hp(4)),
                    child: Text(  "Ingresa el código de verificación que enviamos a tu correo electrónico y por SMS tu número celular. " ,
                      style: TextStyle(
                        color: Tema.Colors.letragris,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal,
                        fontSize: responsive.ip(2.1)
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: responsive.hp(2.3)),
                    child: Text("${ "(+52)" + prefs.getString("medioContactoTelefono") }", style: TextStyle(
                      color: Tema.Colors.GNP,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.5)
                    ),),
                  ),
                  form = new Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: responsive.hp(7)),
                              child: inputTextCodigo(responsive)
                          ),
                          validacionCodigo(responsive),
                          reenviarCodigo(responsive),
                          validarCodigo(responsive),
                          widget.isNumero ?Container():noEsNumero(responsive),
                        ],
                      ),
                    ),
                  )
              ]
          ),
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

  Widget inputTextCodigo(Responsive responsive){
    return TextFormField(
      controller: controllerCodigo,
      focusNode: focusCodigo,
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(8)],
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          hintText: "Código de verificación",
          hintStyle: focusCodigo.hasFocus ? TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.backgroud
          ):  TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2
          ),
          labelText: "Código de verificación",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusCodigo.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          )
      ),
      validator: (value) {
        String p = "/^[0-9]/";
        RegExp regExp = new RegExp(p);
        if(_validCode){
          if (value.isEmpty) {
            return 'Este campo es requerido';
          }  else if (value.length<8 || value.length>8) {
            return "Tu código debe tener 8 dígitos";
          }
           else if (regExp.hasMatch(value)) {
            return null;
          }
        }else{
          return"El código no coincide";
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusCodigo.hasFocus;
          controllerCodigo.text;
        });
      },
    );
  }

  Widget validacionCodigo(Responsive responsive){
    return Container(
      width: responsive.width,
      color: ! timerEnd ? Tema.Colors.dialogoExpiro :Tema.Colors.dialogoExpiradoBG,
      margin: EdgeInsets.only(top: responsive.hp(6.5)),
      child: Container(
        margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(3)),
                //Todo cambiar icono y tamaño
                child:  ! timerEnd ?Image.asset("assets/login/alertVerificaNumero.png", height: 20,width: 20)
                    : Image.asset("assets/login/errorCodigo.png", height: 20,width: 20)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Código de verificación", style: TextStyle(
                    color:  ! timerEnd ? Tema.Colors.textoExpiro : Tema.Colors.validarCampo,
                    fontWeight: FontWeight.w500,
                    fontSize: responsive.ip(1.5),
                  ),
                  ),
                ),
                ! timerEnd ? new CountdownFormatted(
                  duration: Duration(minutes: 3),
                  onFinish: (){
                    setState(() {
                      timerEnd = true;
                      controllerCodigo.text="";
                    });
                  },
                  builder: (BuildContext ctx, String remaining) {
                    return Text(
                      "Válido por ${remaining} minutos",
                      style: TextStyle(
                        color: Tema.Colors.Azul_2,
                        fontWeight: FontWeight.normal,
                        fontSize: responsive.ip(2)
                    ),
                    ); // 01:00:00
                  },
                ) : Container(
                  child: Text("Expirado", style: TextStyle(
                    color: Tema.Colors.Azul_2,
                    fontWeight: FontWeight.normal,
                    fontSize: responsive.ip(2)
                  ),),
                )

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget reenviarCodigo(Responsive responsive){
    return Container(
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Container(
                child: Text("¿Tienes problemas?", style: TextStyle(
                  color: Tema.Colors.Azul_2,
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2)
                ),),
              ),
              Container(
                child: Text("   Reenviar código", style: TextStyle(
                    color:!timerEnd? Tema.Colors.botonletra : Tema.Colors.GNP,
                    fontWeight: FontWeight.normal,
                    fontSize: responsive.ip(2)
                ),),
              ),
            ],
          ),
          onPressed: () async {
            if(timerEnd){
              setState(() {
                timerEnd = false;
              });
            if(prefs.getBool('flujoOlvideContrasena')){
              setState(() {
                _saving = true;
              });
              OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoCambioContrasena"), "", prefs.getBool('flujoOlvideContrasena'));
              setState(() {
                _saving = false;
              });
              print("optRespuesta  ${optRespuesta}");
              if(optRespuesta != null){

                if(optRespuesta.error == "" && optRespuesta.idError == ""){
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  //prefs.setBool('flujoOlvideContrasena', true);
                  //Navigator.pop(context,true);
                  //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
                } else{

                }

              } else{
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);

              }

            } else{
              setState(() {
                _saving = true;
              });
              OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoUsuario"), prefs.getString("medioContactoTelefono"), false);
              setState(() {
                _saving = false;
              });
              if(optRespuesta != null){

                if(optRespuesta.error == "" && optRespuesta.idError == ""){
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                }

              }

            }}
          }

      ),
    );
  }

  void funcion(){

  }

  Widget validarCodigo(Responsive responsive){
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(12), bottom: responsive.hp(3)),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
          child: Container(
            color: controllerCodigo.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,

            width: responsive.width,
            child: Container(
              margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
              child: Text( "VALIDAR", style: TextStyle(
                color: controllerCodigo.text != "" ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            _validCode = true;
            if(_formKey.currentState.validate()){
              setState(() {
                _saving = true;

              });

              ValidarOTPModel validarOTP = await validaOrquestadorOTPServicio(context,prefs.getString("idOperacion"), controllerCodigo.text);

              setState(() {
                _saving = false;
              });

              print("validarOTP ${validarOTP.resultado}");

              if(validarOTP != null){
                if(validarOTP.resultado){
                  if( prefs.getBool('flujoOlvideContrasena') != null && prefs.getBool('flujoOlvideContrasena')){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginRestablecerContrasena(responsive: widget.responsive)));
                  } else {
                    print("Validar flujo");
                    prefs.setBool("flujoCompletoLogin", true);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage(responsive: responsive,)));
                  }
                } else{
                  setState(() {
                    _validCode = false;
                    codigoValidacion = "El código no coincide";
                    // todo limpiar codiggo
                    controllerCodigo.text="";
                    _formKey.currentState.validate();
                  });
                }

              } else{
                controllerCodigo.text="";
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcion);
              }
            }
            //Navigator.pop(context,true);
            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginRestablecerContrasena(responsive: responsive,)));
          }
      ),
    );
  }

  Widget noEsNumero(Responsive responsive){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text("NO ES MI NÚMERO ACTUAL", style: TextStyle(
        color: Tema.Colors.GNP,
        fontWeight: FontWeight.w500,
        fontSize: responsive.ip(2)
      ),),
      onPressed: (){
        prefs.setBool("actulizarNumeroDesdeCodigo", true);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarNumero(responsive: responsive)));
      },
    );
  }
}
