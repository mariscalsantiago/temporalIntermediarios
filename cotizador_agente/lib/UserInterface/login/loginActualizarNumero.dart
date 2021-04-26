import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
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
          title: Text('Actualizar número de celular', style: TextStyle(
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
    return TextFormField(
      controller: controllerCodigo,
      focusNode: focusCodigo,
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
        } else if (regExp.hasMatch(value)) {
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
          controllerCodigo.text;
        });
      },
    );
  }

  Widget inputTextCodigoTablet(Responsive responsive){
    return Container(
      height: responsive.hp(60),
      width: responsive.wp(60),
      child: Center(
        child: TextFormField(
          controller: controllerCodigo,
          focusNode: focusCodigo,
          obscureText: false,
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
            } else if (regExp.hasMatch(value)) {
              return null;
            } else {
              return 'Introduzca un correo válido';
            }
            return null;
          },
          onChanged: (value){
            setState(() {
              focusCodigo.hasFocus;
              controllerCodigo.text;
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
          color: controllerCodigo.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
          margin: EdgeInsets.only(bottom: responsive.hp(3)),
          width: responsive.width,
          child: Container(
            margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
            child: Text( "ACTUALIZAR", style: TextStyle(
                color: controllerCodigo.text != "" ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async{
          if(_formKey.currentState.validate()){

            setState(() {
              _saving = true;
            });

            AltaMedisoContactoAgentes actualizarNumero = await  altaMediosContactoServicio(context);

            if(actualizarNumero != null){
              setState(() {
                _saving = false;
              });

              if(actualizarNumero.codigoError == ""){
                customAlert(AlertDialogType.Numero_de_celular_actualizado_correctamente, context, "",  "", responsive,funcionAlerta);
              } else{

              }

            } else{
              setState(() {
                _saving = false;
              });

            }
          }
        }
    );
  }

  void funcionAlerta(){

  }
}
