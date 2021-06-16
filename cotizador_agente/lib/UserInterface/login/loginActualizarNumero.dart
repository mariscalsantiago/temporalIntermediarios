import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginActualizarNumero extends StatefulWidget {
  final Responsive responsive;
  const LoginActualizarNumero({Key key, this.responsive}) : super(key: key);
  @override
  _LoginActualizarNumeroState createState() => _LoginActualizarNumeroState();
}

class _LoginActualizarNumeroState extends State<LoginActualizarNumero> {
  bool _saving;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool _validNumber = true;
  TextEditingController controllerNumero;
  FocusNode focusCodigo = FocusNode();

  @override
  void initState() {
    if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
      Inactivity(context:context).initialInactivity(functionInactivity);
    }
    validateIntenetstatus(context, widget.responsive,functionConnectivity);
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    //print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (!visible) {
        setState(() {
          focusCodigo.unfocus();
          focusContrasenaInactividad.unfocus();
        });
      }
    });
    _saving = false;
    focusCodigo = new FocusNode();
    controllerNumero = new TextEditingController();

    // Validate unfocus TextField
    focusCodigo.addListener(() {
      setState(() {
        _validNumber = formKey.currentState.validate();
      });
    });

  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(onTap: (){
        if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
          Inactivity(context:context).initialInactivity(functionInactivity);
        }
      },child:WillPopScope(
        onWillPop: () async => false,
    child: SafeArea(
      child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar: _saving
              ? null
              : AppBar(
                  backgroundColor: Tema.Colors.backgroud,
                  elevation: 0,
                  title: Text(
                    'Actualizar número de celular',
                    style: TextStyle(
                        color: Tema.Colors.Azul_2,
                        fontWeight: FontWeight.normal,
                        fontSize: widget.responsive.ip(2.3)),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Tema.Colors.GNP,
                    ),
                    onPressed: () {

                      if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                        Inactivity(context:context).cancelInactivity();
                      }

                      if (_saving) {
                      } else {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ),
          body: Stack(children: builData(widget.responsive))),
    )));
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();
    Form form;

    data = SingleChildScrollView(
      child: deviceType == ScreenType.phone
          ? Container(
              height: responsive.hp(89),
              margin: EdgeInsets.only(
                  left: responsive.wp(6), right: responsive.wp(6)),
              child: form = new Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // deviceType == ScreenType.phone? inputTextCodigo(responsive):inputTextCodigoTablet(responsive),
                      inputTextCodigo(responsive),
                      validarCodigo(responsive)
                    ],
                  )))
          : Center(
              child: Container(
                  height: responsive.hp(45),
                  width: responsive.wp(45),
                  margin: EdgeInsets.only(
                      top: responsive.hp(10),
                      left: responsive.wp(6),
                      right: responsive.wp(6)),
                  child: form = new Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // deviceType == ScreenType.phone? inputTextCodigo(responsive):inputTextCodigoTablet(responsive),
                          inputTextCodigo(responsive),
                          validarCodigo(responsive)
                        ],
                      ))),
            ),
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [LoadingController()],
      );
      l.add(modal);
    }
    return l;
  }

  Widget textoMediosDeContacto(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.hp(3), top: responsive.hp(3)),
      child: Text(
          "No tienes un número celular registrado, agrega uno para que podamos ayudarte a restablecer tu contraseña si la olvidas.",
          style: TextStyle(
            color: Tema.Colors.Subtitle_1_PA,
            fontSize: responsive.ip(2),
            fontWeight: FontWeight.normal,
          )),
    );
  }

  Widget inputTextCodigo(Responsive responsive) {
    RegExp reConsecutive = RegExp('(.)\\1{9}'); // 111 aaa
    RegExp reConsecutive2 =
        RegExp('(123456789|987654321)'); // 123 abcd;// 123 abcd

    return Column(
      children: [
        prefs.getString("medioContactoTelefono") != ""
            ? Container()
            : textoMediosDeContacto(responsive),
        TextFormField(
          controller: controllerNumero,
          focusNode: focusCodigo,
          obscureText: false,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            LengthLimitingTextInputFormatter(10)
          ],
          cursorColor:
              _validNumber ? Tema.Colors.GNP : Tema.Colors.validarCampo,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: new InputDecoration(
            labelText: "Número de celular",
            labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: _validNumber
                  ? focusCodigo.hasFocus
                    ? Tema.Colors.GNP
                    : Tema.Colors.inputcorreo
                  : Tema.Colors.validarCampo,
            ),
            errorStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(1.2),
              color: Tema.Colors.validarCampo,
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Tema.Colors.validarCampo, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _validNumber
                      ? Tema.Colors.inputlinea
                      : Tema.Colors.validarCampo),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      _validNumber ? Tema.Colors.GNP : Tema.Colors.validarCampo,
                  width: 2),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _validNumber
                      ? Tema.Colors.inputlinea
                      : Tema.Colors.validarCampo,
                  width: 2),
            ),
          ),
          validator: (value) {
            String p = "[0-9]";
            RegExp regExp = new RegExp(p);
            if (value.isEmpty) {
              return 'Este campo es requerido';
            } else if (value.length < 10) {
              return "Tu número de celular debe tener 10 dígitos.";
            } else if (reConsecutive2.hasMatch(value)) {
              return 'El número que ingresaste, ¿es correcto? Verifícalo e\ninténtalo nuevamente.';
            } else if (reConsecutive.hasMatch(value)) {
              return 'El número que ingresaste, ¿es correcto? Verifícalo e\ninténtalo nuevamente.';
            } else if (regExp.hasMatch(value)) {
              print("value ${value}");
              return null;
            } else {
              return 'Tu número de celular debe tener 10 dígitos.';
            }
            return null;
          },
          onChanged: (value) {
            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil")){
             // handleUserInteraction(context,CallbackInactividad);
            }
            setState(() {
              focusCodigo.hasFocus;
              controllerNumero.text;
              _validNumber = formKey.currentState.validate();
              try {
                if (controllerNumero.text.isNotEmpty &&
                    controllerNumero.text.length >= 10) {
                  String tem = controllerNumero.text;
                  controllerNumero.text = tem.substring(0, 9);
                  focusCodigo.unfocus();
                }
              } catch (e) {
                print(e);
              }
            });
          },
          onEditingComplete: () {
            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil")){
              //handleUserInteraction(context,CallbackInactividad);
            }
            setState(() {
              focusCodigo.unfocus();
            });
          },
          onFieldSubmitted: (s) {
            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil")){
             // handleUserInteraction(context,CallbackInactividad);
            }
            setState(() {
              focusCodigo.unfocus();
            });
          },
          onTap: () {
            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil")){
             // handleUserInteraction(context,CallbackInactividad);
            }
            setState(() {
              focusCodigo.requestFocus();
            });
          },
        )
      ],
    );
  }

  Widget inputTextCodigoTablet(Responsive responsive) {
    RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
    RegExp reConsecutive2 = RegExp(
        '(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)'); // 123 abcd;// 123 abcd

    return Container(
      height: responsive.hp(60),
      width: responsive.wp(60),
      child: Center(
        child: TextFormField(
          controller: controllerNumero,
          focusNode: focusCodigo,
          obscureText: false,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp("[ ]")),
            LengthLimitingTextInputFormatter(10)
          ],
          maxLength: 10,
          keyboardType: TextInputType.number,
          cursorColor: Tema.Colors.GNP,
          decoration: new InputDecoration(
              focusColor: Tema.Colors.gnpOrange,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.gnpOrange),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.inputlinea),
              ),
              labelText: "Número de celular",
              labelStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color: _validNumber
                      ? focusCodigo.hasFocus
                      ? Tema.Colors.GNP
                      : Tema.Colors.inputcorreo
                      : Tema.Colors.validarCampo,)),
          validator: (value) {
            String p = "/^[0-9]/";
            RegExp regExp = new RegExp(p);
            if (value.isEmpty) {
              return 'Este campo es requerido     dkjfaklsd';
            } else if (reConsecutive2.hasMatch(value)) {
              return 'No debe contener más de dos caracteres consecutivos (123).';
            } else if (reConsecutive.hasMatch(value)) {
              return 'No debe contener más de dos caracteres consecutivos iguales (222)';
            } else if (regExp.hasMatch(value)) {
              return null;
            } else {
              return 'Introduzca un correo válido';
            }
          },
          onChanged: (value) {
            setState(() {
              focusCodigo.hasFocus;
              controllerNumero.text;
            });
          },
        ),
      ),
    );
  }

  Widget validarCodigo(Responsive responsive) {
    return CupertinoButton(
        child: Container(
          width: responsive.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: controllerNumero.text != ""
                ? Tema.Colors.GNP
                : Tema.Colors.botonlogin,
          ),
          child: Container(
            margin: EdgeInsets.only(
                top: responsive.hp(2), bottom: responsive.hp(2)),
            child: Text(
              "ACTUALIZAR",
              style: TextStyle(
                  color: controllerNumero.text != ""
                      ? Tema.Colors.backgroud
                      : Tema.Colors.botonletra,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async {
          _validNumber = formKey.currentState.validate();
          setState(() {});
          if (prefs.getBool("esPerfil") != null &&
              prefs.getBool("esPerfil")){
           // handleUserInteraction(context,CallbackInactividad);
          }
          if (formKey.currentState.validate()) {
            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil") &&
                prefs.getBool("esActualizarNumero")) {
              print("esPerfil esActualizarNumero");

              String lada = controllerNumero.text.substring(0, 2);
              String numero = controllerNumero.text.substring(2, 10);

              prefs.setString("lada", lada);
              prefs.setString("numero", numero);
              prefs.setString("medioContactoTelefonoServicio",
                  prefs.getString("medioContactoTelefono"));
              print("Telefono -- ${prefs.getString("medioContactoTelefono")}");
              prefs.setString("medioContactoTelefono", controllerNumero.text);
              setState(() {
                _saving = true;
              });

              OrquetadorOtpJwtModel optRespuesta =
                  await orquestadorOTPJwtServicio(
                      context, prefs.getString("medioContactoTelefono"), true);

              setState(() {
                _saving = false;
              });

              if (optRespuesta != null) {
                if (optRespuesta.error == "") {
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  prefs.setBool("seActualizarNumero", true);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginCodigoVerificaion(
                                  responsive: responsive, isNumero: false)));
                } else {
                  customAlert(AlertDialogType.errorServicio, context, "", "",
                      responsive, funcionAlerta);
                  return;
                }
              } else {
                customAlert(AlertDialogType.errorServicio, context, "", "",
                    responsive, funcionAlerta);
                return;
              }
            } else if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil") &&
                prefs.getBool("actualizarContrasenaPerfil")) {
              print("esPerfil actualizarContrasenaPerfil");

              String lada = controllerNumero.text.substring(0, 2);
              String numero = controllerNumero.text.substring(2, 10);

              prefs.setString("lada", lada);
              prefs.setString("numero", numero);
              prefs.setString("medioContactoTelefonoServicio",
                  prefs.getString("medioContactoTelefono"));
              prefs.setString("medioContactoTelefono", controllerNumero.text);

              setState(() {
                _saving = true;
              });

              OrquetadorOtpJwtModel optRespuesta =
                  await orquestadorOTPJwtServicio(
                      context, prefs.getString("medioContactoTelefono"), true);

              setState(() {
                _saving = false;
              });

              if (optRespuesta != null) {
                if (optRespuesta.error == "") {
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  prefs.setBool("seActualizarNumero", true);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginCodigoVerificaion(
                                responsive: responsive,
                                isNumero: false,
                              )));
                } else {
                  customAlert(AlertDialogType.errorServicio, context, "", "",
                      responsive, funcionAlerta);
                }
              } else {
                customAlert(AlertDialogType.errorServicio, context, "", "",
                    responsive, funcionAlerta);
              }
            } else {
              print("----- else Aceptar ------");
              setState(() {
                _saving = true;
              });

              String lada = controllerNumero.text.substring(0, 2);
              String numero = controllerNumero.text.substring(2, 10);
              prefs.setString("lada", lada);
              prefs.setString("numero", numero);
              prefs.setString("medioContactoTelefonoServicio",
                  prefs.getString("medioContactoTelefono"));


              print("lada   ${lada}");
              print("numero ${numero}");

              setState(() {
                _saving = true;
              });
              OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
                  context,
                  prefs.getString("correoUsuario"),
                  controllerNumero.text,
                  prefs.getBool('flujoOlvideContrasena'));

              setState(() {
                _saving = false;
              });

              print("optRespuesta ${optRespuesta}");
              if (optRespuesta != null) {
                if (optRespuesta.error == "" && optRespuesta.idError == "") {
                  prefs.setBool("seActualizarNumero", true);
                  prefs.setString("idOperacion", optRespuesta.idOperacion);
                  prefs.setString("medioContactoTelefono", controllerNumero.text);
                  if (prefs.getBool("actulizarNumeroDesdeCodigo") != null &&
                      prefs.getBool("actulizarNumeroDesdeCodigo")) {
                    prefs.setBool("actulizarNumeroDesdeCodigo", false);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginCodigoVerificaion(
                                  responsive: responsive,
                                  isNumero: false,
                                )));
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginCodigoVerificaion(
                                  responsive: responsive,
                                  isNumero: false,
                                )));
                  }
                } else {
                  customAlert(AlertDialogType.errorServicio, context, "", "",
                      responsive, funcionAlerta);
                }
              } else {
                customAlert(AlertDialogType.errorServicio, context, "", "",
                    responsive, funcionAlerta);
              }
            }
          } else {}
        });
  }

  void funcionAlerta() {}

  void funcionAceptar(Responsive responsive) async {
    setState(() {
      _saving = true;
    });
    OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
        context,
        prefs.getString("correoUsuario"),
        prefs.getString("medioContactoTelefono"),
        prefs.getBool('flujoOlvideContrasena'));

    setState(() {
      _saving = false;
    });

    print("optRespuesta ${optRespuesta}");
    if (optRespuesta != null) {
      if (optRespuesta.error == "" && optRespuesta.idError == "") {
        prefs.setString("idOperacion", optRespuesta.idOperacion);
        if (prefs.getBool("actulizarNumeroDesdeCodigo") != null &&
            prefs.getBool("actulizarNumeroDesdeCodigo")) {
          prefs.setBool("actulizarNumeroDesdeCodigo", false);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginCodigoVerificaion(
                        responsive: responsive,
                        isNumero: false,
                      )));
        } else {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginCodigoVerificaion(
                        responsive: responsive,
                        isNumero: false,
                      )));
        }
      } else {
        customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
            funcionAlerta);
      }
    } else {
      customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
          funcionAlerta);
    }
  }
  void CallbackInactividad(){
    setState(() {
      print("CallbackInactividad Actualizar numero");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
     // handleUserInteraction(context,CallbackInactividad);
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
