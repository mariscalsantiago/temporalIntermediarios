import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';

import 'loginRestablecerContrasena.dart';

class LoginCodigoVerificaion extends StatefulWidget {
  final Responsive responsive;
  const LoginCodigoVerificaion({Key key, this.responsive}) : super(key: key);
  @override
  _LoginCodigoVerificaionState createState() => _LoginCodigoVerificaionState();
}

class _LoginCodigoVerificaionState extends State<LoginCodigoVerificaion> {

  bool _saving;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerCodigo;
  FocusNode focusCodigo;

  @override
  void initState() {
    _saving = false;
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
              icon: Icon(Icons.arrow_back_outlined,
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
                    child: Text( prefs.getBool('flujoOlvideContrasena') ? "Ingrese el código de verificación que enviamos a tu correo electrónico y por SMS a tu número celular."
                        : "Ingresa el código de verificación que te enviamos por SMS al número:  ${prefs.getString("medioContactoTelefono") != "" ? prefs.getString("medioContactoTelefono") : ""}" ,
                      style: TextStyle(
                        color: Tema.Colors.letragris,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal,
                        fontSize: responsive.ip(2.1)
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: responsive.hp(2.3)),
                    child: Text("(+52) 55 2465 8737", style: TextStyle(
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
                          noEsNumero(responsive),
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
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

        if (value.isEmpty) {
          return 'Este campo es requerido';
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
      color: Tema.Colors.dialogoExpiro,
      margin: EdgeInsets.only(top: responsive.hp(6.5)),
      child: Container(
        margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(3)),
                child: Image.asset("assets/login/alertVerificaNumero.png")
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Código de verificación", style: TextStyle(
                    color: Tema.Colors.textoExpiro,
                    fontWeight: FontWeight.w500,
                    fontSize: responsive.ip(1.5),
                  ),),
                ),
                Container(
                  child: Text("Válido por 3:00 minutos", style: TextStyle(
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
    return CupertinoButton(
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
                  color: Tema.Colors.GNP,
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2)
              ),),
            ),
          ],
        ),
        onPressed: () async {

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
                prefs.setBool('flujoOlvideContrasena', true);
                Navigator.pop(context,true);
                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
              } else{

              }

            } else{

            }

          }
        }

    );
  }

  Widget validarCodigo(Responsive responsive){
    return CupertinoButton(
      padding: EdgeInsets.zero,
        child: Container(
          color: controllerCodigo.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
          margin: EdgeInsets.only(top: responsive.hp(12), bottom: responsive.hp(3)),
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
        onPressed: (){
          if(_formKey.currentState.validate()){
            if( prefs.getBool('flujoOlvideContrasena') != null && prefs.getBool('flujoOlvideContrasena')){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginRestablecerContrasena(responsive: widget.responsive)));
            } else {
              print("Validar flujo");
              prefs.setBool("flujoCompletoLogin", true);
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomePage(responsive: responsive,)));
            }
          }
          //Navigator.pop(context,true);
          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginRestablecerContrasena(responsive: responsive,)));
        }

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
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarNumero(responsive: responsive)));
      },
    );
  }
}
