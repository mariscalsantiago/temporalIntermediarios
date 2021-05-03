import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';

import '../../main.dart';

class LoginActualizarNumero extends StatefulWidget {
  final Responsive responsive;
  const LoginActualizarNumero({Key key, this.responsive}) : super(key: key);
  @override
  _LoginActualizarNumeroState createState() => _LoginActualizarNumeroState();
}

class _LoginActualizarNumeroState extends State<LoginActualizarNumero> {

  bool _saving;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNumero;
  FocusNode focusCodigo = FocusNode();

  @override
  void initState() {
    _saving = false;
    focusCodigo = new FocusNode();
    controllerNumero = new TextEditingController();
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
          title: Text('Actualizar número de celular', style: TextStyle(
              color: Tema.Colors.Azul_2,
              fontWeight: FontWeight.normal,
              fontSize: widget.responsive.ip(2.3)
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

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();
    Form form;

    data = SingleChildScrollView(
      child: deviceType == ScreenType.phone ? Container(
        height: responsive.hp(85),
        margin: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(6)),
        child: form = new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               // deviceType == ScreenType.phone? inputTextCodigo(responsive):inputTextCodigoTablet(responsive),
                inputTextCodigo(responsive),
                validarCodigo(responsive)
              ],
            )
        )
      ) : Center(
        child: Container(
            height: responsive.hp(45),
            width: responsive.wp(45),
            margin: EdgeInsets.only(top:responsive.hp(10),  left: responsive.wp(6), right: responsive.wp(6)),
            child: form = new Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // deviceType == ScreenType.phone? inputTextCodigo(responsive):inputTextCodigoTablet(responsive),
                    inputTextCodigo(responsive),
                    validarCodigo(responsive)
                  ],
                )
            )
        ),
      ),
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
    RegExp reConsecutive = RegExp('(.)\\1{9}'); // 111 aaa
    RegExp reConsecutive2 = RegExp('(123456789|987654321)');// 123 abcd;// 123 abcd

    return TextFormField(
      controller: controllerNumero,
      focusNode: focusCodigo,
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[ ]")),
        LengthLimitingTextInputFormatter(10)
      ],
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          hintText: "Número de celular",
          hintStyle: focusCodigo.hasFocus ? TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2) ,
              color: Tema.Colors.backgroud,
          ):  TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2
          ),
          labelText: "Número de celular",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusCodigo.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          )
      ),
      validator: (value) {
        String p = "[0-9]";
        RegExp regExp = new RegExp(p);
        if (value.isEmpty) {
          return 'Este campo es requerido';
        } else if (value.length<10) {
          print("Tu número de celular debe tener 10 dígitos");
          return "Tu número de celular debe tener 10 dígitos";
        }else if(reConsecutive2.hasMatch(value) ){
          return 'No debe contener más de dos caracteres consecutivos (123).';
        } else if(reConsecutive.hasMatch(value)){
          return 'No debe contener más de dos caracteres consecutivos iguales';
        }else if (regExp.hasMatch(value)) {
          print("value ${value}");
          return null;
        } else {
          return 'Tu número de celular debe tener 10 dígitos';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusCodigo.hasFocus;
          controllerNumero.text;
        });
      },
    );
  }

  Widget inputTextCodigoTablet(Responsive responsive){
    RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
    RegExp reConsecutive2 = RegExp('(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)');// 123 abcd;// 123 abcd

    return Container(
      height: responsive.hp(60),
      width: responsive.wp(60),
      child: Center(
        child: TextFormField(
          controller: controllerNumero,
          focusNode: focusCodigo,
          obscureText: false,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]")),LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.number,
          cursorColor: Tema.Colors.GNP,
          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.inputlinea),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.inputlinea),
              ),
              hintText: "Número de celular",
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
              labelText: "Número de celular",
              labelStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color: Tema.Colors.inputcorreo
              )
          ),
          validator: (value) {
            String p = "/^[0-9]/";
            RegExp regExp = new RegExp(p);
            if (value.isEmpty) {
              return 'Este campo es requerido';
            } else if(reConsecutive2.hasMatch(value) ){
              return 'No debe contener más de dos caracteres consecutivos (123).';
            } else if(reConsecutive.hasMatch(value)){
              return 'No debe contener más de dos caracteres consecutivos iguales (222)';
            }else if (regExp.hasMatch(value)) {
              return null;
            } else {
              return 'Introduzca un correo válido';
            }
          },
          onChanged: (value){
            setState(() {
              focusCodigo.hasFocus;
              controllerNumero.text;
            });
          },
        ),
      ),
    );
  }

  Widget validarCodigo(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          color: controllerNumero.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
          margin: EdgeInsets.only(bottom: responsive.hp(3)),
          width: responsive.width,
          child: Container(
            margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
            child: Text( "ACTUALIZAR", style: TextStyle(
                color: controllerNumero.text != "" ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async{
          if(_formKey.currentState.validate()){

            if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil") && prefs.getBool("esActualizarNumero")){

              print("esPerfil esActualizarNumero");

              String lada = controllerNumero.text.substring(0,2);
              String numero = controllerNumero.text.substring(2,10);

              prefs.setString("lada", lada);
              prefs.setString("numero", numero);
              prefs.setString("medioContactoTelefonoServicio", prefs.getString("medioContactoTelefono"));
              print("Telefono -- ${prefs.getString("medioContactoTelefono")}");
              prefs.setString("medioContactoTelefono", controllerNumero.text);
              setState(() {
                _saving = true;
              });

              OrquetadorOtpJwtModel optRespuesta = await  orquestadorOTPJwtServicio(context, prefs.getString("medioContactoTelefono"), true);

              setState(() {
                _saving = false;
              });

              if(optRespuesta != null){
                if(optRespuesta.error == "") {
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,isNumero: false)));
                } else{
                  customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
                  return;
                }
              } else{
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
                return;
              }
            }
            else if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil") && prefs.getBool("actualizarContrasenaPerfil")){

              print("esPerfil actualizarContrasenaPerfil");

              String lada = controllerNumero.text.substring(0,2);
              String numero = controllerNumero.text.substring(2,10);

              prefs.setString("lada", lada);
              prefs.setString("numero", numero);
              prefs.setString("medioContactoTelefono", controllerNumero.text);
              setState(() {
                _saving = true;
              });

              OrquetadorOtpJwtModel optRespuesta = await  orquestadorOTPJwtServicio(context, prefs.getString("medioContactoTelefono"), true);

              setState(() {
                _saving = false;
              });

              if(optRespuesta != null){
                if(optRespuesta.error == "") {
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive, isNumero: false,)));
                } else{
                  customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
                }
              } else{
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
              }
            }
            else {

              print("----- else Aceptar ------");
              setState(() {
                _saving = true;
              });

              String lada = controllerNumero.text.substring(0,2);
              String numero = controllerNumero.text.substring(2,10);

              print("lada   ${lada}");
              print("numero ${numero}");

              AltaMedisoContactoAgentes actualizarNumero = await  altaMediosContactoServicio(context, lada,  numero);

              if(actualizarNumero != null) {
                if(actualizarNumero.idMedioContacto != "" && actualizarNumero.secuencial != ""){
                  prefs.setString("medioContactoTelefono", controllerNumero.text);

                  setState(() {
                    _saving = false;
                  });
                  customAlert(AlertDialogType.Numero_de_celular_actualizado_correctamente, context, "",  "", responsive,funcionAceptar);


                } else{
                  setState(() {
                    _saving = false;
                  });
                  customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
                }

              } else{
                setState(() {
                  _saving = false;
                });
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);

              }
            }
          }
        }
    );
  }

  void funcionAlerta(){

  }

  void funcionAceptar(Responsive responsive) async{
    setState(() {
      _saving = true;
    });
    OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoUsuario"), prefs.getString("medioContactoTelefono"), prefs.getBool('flujoOlvideContrasena'));

    setState(() {
      _saving = false;
    });

    print("optRespuesta ${optRespuesta}");
    if(optRespuesta != null){
      if(optRespuesta.error == "" && optRespuesta.idError == "") {
        prefs.setString("idOperacion", optRespuesta.idOperacion);
        if(prefs.getBool("actulizarNumeroDesdeCodigo") != null && prefs.getBool("actulizarNumeroDesdeCodigo")){
          prefs.setBool("actulizarNumeroDesdeCodigo", false);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      LoginCodigoVerificaion(
                        responsive: responsive,
                        isNumero:false,
                      )
              )
          );
        } else{
          Navigator.pop(context);
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
        }

      } else{
        customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
      }
    } else{
      customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
    }
  }
}
