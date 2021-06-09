import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';
import '../../main.dart';
import 'loginRestablecerContrasena.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

bool timerEnd = false;
Widget timer;

class LoginCodigoVerificaion extends StatefulWidget {
  final isNumero;
  final Responsive responsive;
  const LoginCodigoVerificaion({Key key, this.responsive, this.isNumero})
      : super(key: key);
  @override
  _LoginCodigoVerificaionState createState() => _LoginCodigoVerificaionState();
}

class _LoginCodigoVerificaionState extends State<LoginCodigoVerificaion> {
  bool _saving;
  bool _validCode = true;
  bool _validCodeForm = true;
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
    timerWidget();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    //print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (!visible) {
        focusCodigo.unfocus();
        focusContrasenaInactividad.unfocus();
      }
    });
    super.initState();

    // Validate unfocus TextField
    focusCodigo.addListener(() {
      setState(() {
        _validCodeForm = _formKey.currentState.validate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                      'Código de verificación',
                      style: TextStyle(
                          color: Tema.Colors.Azul_2,
                          fontWeight: FontWeight.normal,
                          fontSize: prefs.getBool("useMobileLayout")
                              ? widget.responsive.ip(2.5)
                              : widget.responsive.ip(1.8)),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Tema.Colors.GNP,
                      ),
                      onPressed: () {
                        if (_saving) {
                        } else {
                          if (prefs.getBool("esPerfil") != null &&
                              prefs.getBool("esPerfil")) {
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString(
                                    "medioContactoTelefonoServicio"));
                            Navigator.pop(context, true);
                          } else {
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString(
                                    "medioContactoTelefonoServicio"));
                            Navigator.pop(context, true);
                          }
                        }
                      },
                    ),
                  ),
            body: Stack(children: builData(widget.responsive))),
      ),
    );
  }

  List<Widget> builData(Responsive responsive) {
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
                "Código de verificación",
                style: TextStyle(
                    color: Tema.Colors.Encabezados,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.normal,
                    fontSize: prefs.getBool("useMobileLayout")
                        ? responsive.ip(2.3)
                        : responsive.ip(1.5)),
              ),
            ),
            (prefs.getBool('flujoOlvideContrasena') != null &&
                        prefs.getBool('flujoOlvideContrasena')) ||
                    (prefs.getBool("esPerfil") != null &&
                        prefs.getBool("esPerfil") &&
                        prefs.getBool("actualizarContrasenaPerfil"))
                ? Container(
                    margin: EdgeInsets.only(top: responsive.hp(4)),
                    child: Text(
                        "Ingresa el código de verificación que enviamos a tu correo electrónico y por SMS tu número celular.",
                        style: TextStyle(
                            color: Tema.Colors.letragris,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(2.1)
                                : responsive.ip(1.4))),
                  )
                : Container(
                    margin: EdgeInsets.only(top: responsive.hp(4)),
                    child: Text(
                        "Ingresa el código de verificación que te enviamos por SMS al número:",
                        style: TextStyle(
                            color: Tema.Colors.letragris,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(2.1)
                                : responsive.ip(1.4))),
                  ),
            (prefs.getBool('flujoOlvideContrasena') != null &&
                        prefs.getBool('flujoOlvideContrasena')) ||
                    (prefs.getBool("esPerfil") != null &&
                        prefs.getBool("esPerfil") &&
                        prefs.getBool("actualizarContrasenaPerfil"))
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: responsive.hp(2.3)),
                    child: Text(
                      "${"(+52)" + prefs.getString("medioContactoTelefono")}",
                      style: TextStyle(
                          color: Tema.Colors.GNP,
                          fontWeight: FontWeight.normal,
                          fontSize: prefs.getBool("useMobileLayout")
                              ? responsive.ip(2.5)
                              : responsive.ip(1.8)),
                    ),
                  ),
            form = Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: responsive.hp(7)),
                        child: inputTextCodigo(responsive)),
                    validacionCodigo(responsive),
                    reenviarCodigo(responsive),
                    prefs.getBool("useMobileLayout")
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: responsive.hp(3)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: validarCodigo(responsive)),
                                widget.isNumero
                                    ? Container()
                                    : Expanded(child: noEsNumero(responsive)),
                              ],
                            ),
                          ),
                    prefs.getBool("useMobileLayout")
                        ? validarCodigo(responsive)
                        : Container(),
                    prefs.getBool("useMobileLayout")
                        ? widget.isNumero
                            ? Container()
                            : noEsNumero(responsive)
                        : Container(),
                  ],
                ),
              ),
            )
          ]),
    ));

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

  Widget inputTextCodigo(Responsive responsive) {
    return TextFormField(
      controller: controllerCodigo,
      focusNode: focusCodigo,
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      onFieldSubmitted: (val) {
        setState(() {
          _validCodeForm = _formKey.currentState.validate();
        });
      },
      cursorColor: _validCodeForm ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
        labelText: "Código de verificación",
        labelStyle: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2),
          color: _validCodeForm
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
              color: _validCodeForm
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color:
                  _validCodeForm ? Tema.Colors.GNP : Tema.Colors.validarCampo,
              width: 2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _validCodeForm
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo,
              width: 2),
        ),
      ),
      onTap: () {
        setState(() {
          if (prefs.getBool("esPerfil") != null &&
              prefs.getBool("esPerfil")){
            handleUserInteraction(context,CallbackInactividad);
          }
          focusCodigo.requestFocus();
        });
      },
      validator: (value) {
        String p = "/^[0-9]/";
        RegExp regExp = new RegExp(p);
        if (_validCode) {
          if (value.isEmpty) {
            return 'Este campo es requerido';
          } else if (value.length < 8 || value.length > 8) {
            return "Tu código debe tener 8 dígitos";
          } else if (regExp.hasMatch(value)) {
            return null;
          }
        } else {
          return "El código no coincide";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _validCode = true;
          _validCodeForm = _formKey.currentState.validate();
          focusCodigo.hasFocus;
          controllerCodigo.text;
          try {
            if (controllerCodigo.text.isNotEmpty &&
                controllerCodigo.text.length >= 8) {
              String tem = controllerCodigo.text;
              controllerCodigo.text = tem.substring(0, 7);
              focusCodigo.unfocus();
            }

            if (prefs.getBool("esPerfil") != null &&
                prefs.getBool("esPerfil")){
              handleUserInteraction(context,CallbackInactividad);
            }
          } catch (e) {
            print(e);
          }
        });
      },
    );
  }

  Widget validacionCodigo(Responsive responsive) {
    return Container(
      width: responsive.width,
      color:
          !timerEnd ? Tema.Colors.dialogoExpiro : Tema.Colors.dialogoExpiradoBG,
      margin: EdgeInsets.only(top: responsive.hp(6.5)),
      child: Container(
        margin:
            EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: responsive.wp(6), right: responsive.wp(3)),
                //Todo cambiar icono y tamaño
                child: !timerEnd
                    ? Image.asset("assets/login/alertVerificaNumero.png",
                        height: 20, width: 20)
                    : Image.asset("assets/login/errorCodigo.png",
                        height: 20, width: 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "Código de verificación",
                    style: TextStyle(
                      color: !timerEnd
                          ? Tema.Colors.textoExpiro
                          : Tema.Colors.validarCampo,
                      fontWeight: FontWeight.w500,
                      fontSize: responsive.ip(1.2),
                    ),
                  ),
                ),
                !timerEnd
                    ? new CountdownFormatted(
                        duration: Duration(minutes: 3),
                        onFinish: () {
                          setState(() {
                            timerEnd = true;
                            controllerCodigo.text = "";
                          });
                        },
                        builder: (BuildContext ctx, String remaining) {
                          return Text(
                            "Válido por ${remaining} minutos",
                            style: TextStyle(
                                color: Tema.Colors.Azul_2,
                                fontWeight: FontWeight.normal,
                                fontSize: prefs.getBool("useMobileLayout")
                                    ? responsive.ip(2)
                                    : responsive.ip(1.5)),
                          ); // 01:00:00
                        },
                      )
                    : Container(
                        child: Text(
                          "Expirado",
                          style: TextStyle(
                              color: Tema.Colors.Azul_2,
                              fontWeight: FontWeight.normal,
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(2)
                                  : responsive.ip(1.2)),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget reenviarCodigo(Responsive responsive) {
    return Container(
      margin: prefs.getBool('flujoOlvideContrasena') != null &&
              !prefs.getBool('flujoOlvideContrasena')
          ? EdgeInsets.only(top: responsive.wp(4), bottom: responsive.wp(0))
          : EdgeInsets.only(top: responsive.wp(4), bottom: responsive.wp(5)),
      child: Row(
        children: [
          Container(
            child: Text(
              "¿Tienes problemas?",
              style: TextStyle(
                  color: Tema.Colors.Azul_2,
                  fontWeight: FontWeight.normal,
                  fontSize: prefs.getBool("useMobileLayout")
                      ? responsive.ip(2)
                      : responsive.ip(1.3)),
            ),
          ),
          GestureDetector(
            onTap: () async {

              if (prefs.getBool("esPerfil") != null &&
                  prefs.getBool("esPerfil")){
                handleUserInteraction(context,CallbackInactividad);
              }

              sendTag("appinter_otp_reenvio");
              controllerCodigo.text = "";
              focusCodigo.unfocus();
              setState(() {
                timerEnd = true;
                codigoValidacion = "";
                _formKey.currentState.reset();
              });
              if (prefs.getBool('flujoOlvideContrasena')) {
                setState(() {
                  _saving = true;
                });
                OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
                    context,
                    prefs.getString("correoCambioContrasena"),
                    "",
                    prefs.getBool('flujoOlvideContrasena'));
                setState(() {
                  _saving = false;
                });
                print("optRespuesta  ${optRespuesta}");
                if (optRespuesta != null) {
                  setState(() {
                    timerEnd = false;
                  });

                  if (optRespuesta.error == "" && optRespuesta.idError == "") {
                    //TODO validar Dali
                    sendTag("appinter_otp_ok");
                    prefs.setString("idOperacion", optRespuesta.idOperacion);
                    //prefs.setBool('flujoOlvideContrasena', true);
                    //Navigator.pop(context,true);
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
                  } else {
                    //TODO validar Dali
                    sendTag("appinter_otp_error");
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcion);
                  }
                } else {
                  //TODO validar Dali
                  sendTag("appinter_otp_error");
                  customAlert(AlertDialogType.errorServicio, context, "", "",
                      responsive, funcion);
                }
              } else {
                if (prefs.getBool("esPerfil") != null &&
                    prefs.getBool("esPerfil")) {
                  setState(() {
                    _saving = true;
                  });
                  OrquetadorOtpJwtModel optRespuesta;
                  if (prefs.getBool("esActualizarNumero")) {
                    optRespuesta = await orquestadorOTPJwtServicio(context,
                        prefs.getString("medioContactoTelefono"), true);
                  } else {
                    optRespuesta = await orquestadorOTPJwtServicio(context,
                        prefs.getString("medioContactoTelefono"), false);
                  }

                  setState(() {
                    _saving = false;
                  });
                  if (optRespuesta != null) {
                    setState(() {
                      timerEnd = false;
                    });

                    if (optRespuesta.error == "") {
                      //TODO validar Dali
                      sendTag("appinter_otp_ok");
                      prefs.setString("idOperacion", optRespuesta.idOperacion);
                    } else {
                      //TODO validar Dali
                      sendTag("appinter_otp_error");
                      customAlert(AlertDialogType.errorServicio, context, "",
                          "", responsive, funcion);
                    }
                  } else {
                    //TODO validar Dali
                    sendTag("appinter_otp_error");
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcion);
                  }
                } else {
                  setState(() {
                    _saving = true;
                  });
                  OrquestadorOTPModel optRespuesta =
                      await orquestadorOTPServicio(
                          context,
                          prefs.getString("correoUsuario"),
                          prefs.getString("medioContactoTelefono"),
                          false);
                  setState(() {
                    timerEnd = false;
                    _saving = false;
                  });
                  if (optRespuesta != null) {
                    if (optRespuesta.error == "" &&
                        optRespuesta.idError == "") {
                      prefs.setString("idOperacion", optRespuesta.idOperacion);
                      //TODO validar Dali
                      sendTag("appinter_otp_ok");
                    } else {
                      //TODO validar Dali
                      sendTag("appinter_otp_error");
                      customAlert(AlertDialogType.errorServicio, context, "",
                          "", responsive, funcion);
                    }
                  } else {
                    //TODO validar Dali
                    sendTag("appinter_otp_error");
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcion);
                  }
                }
              }
            },
            child: Container(
              child: Text(
                "   Reenviar código",
                style: TextStyle(
                    color: Tema.Colors.GNP,
                    fontWeight: FontWeight.normal,
                    fontSize: prefs.getBool("useMobileLayout")
                        ? responsive.ip(2)
                        : responsive.ip(1.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void timerWidget() {
    setState(() {
      timer = new Container(
        child: Text(
          "Código de verificación",
          style: TextStyle(
            color:
                !timerEnd ? Tema.Colors.textoExpiro : Tema.Colors.validarCampo,
            fontWeight: FontWeight.w500,
            fontSize: widget.responsive.ip(1.5),
          ),
        ),
      );
    });
  }

  void funcion() {}

  Widget validarCodigo(Responsive responsive) {
    return Container(
      margin: prefs.getBool("useMobileLayout")
          ? EdgeInsets.only(
              top: prefs.getBool('flujoOlvideContrasena') != null &&
                      !prefs.getBool('flujoOlvideContrasena')
                  ? responsive.hp(20)
                  : responsive.hp(25),
              bottom: prefs.getBool('flujoOlvideContrasena') != null &&
                      !prefs.getBool('flujoOlvideContrasena')
                  ? responsive.hp(0)
                  : responsive.hp(0))
          : EdgeInsets.only(top: responsive.hp(0), bottom: responsive.hp(2)),
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: !timerEnd && controllerCodigo.text != ""
                  ? Tema.Colors.GNP
                  : Tema.Colors.botonlogin,
            ),
            width: responsive.width,
            child: Container(
              margin: EdgeInsets.only(
                  top: responsive.hp(2), bottom: responsive.hp(2)),
              child: Text(
                "VALIDAR",
                style: TextStyle(
                    color: !timerEnd && controllerCodigo.text != ""
                        ? Tema.Colors.backgroud
                        : Tema.Colors.botonletra,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            focusCodigo.unfocus();
            _validCode = true;
            _validCodeForm = _formKey.currentState.validate();
            setState(() {});
            if (!timerEnd) {

              print("timer valido en valida codigo");
              if (_formKey.currentState.validate()) {

                print("campo valido en valida codigo");
                setState(() {
                  _saving = true;
                });

                ValidarOTPModel validarOTP = await validaOrquestadorOTPServicio(
                    context,
                    prefs.getString("idOperacion"),
                    controllerCodigo.text);

                print("validarOTP ${validarOTP}");

                if (validarOTP != null) {
                  if (validarOTP.resultado) {
                    if (prefs.getBool("esPerfil") != null &&
                        prefs.getBool("esPerfil") &&
                        prefs.getBool("esActualizarNumero")) {
                      AltaMedisoContactoAgentes actualizarNumero =
                          await altaMediosContactoServicio(
                              context,
                              prefs.getString("lada"),
                              prefs.getString("numero"));

                      setState(() {
                        _saving = false;
                      });

                      if (actualizarNumero != null) {
                        if (actualizarNumero.idMedioContacto != "" &&
                            actualizarNumero.secuencial != "") {
                          prefs.setString(
                              "medioContactoTelefono",
                              prefs.getString("lada") +
                                  prefs.getString("numero"));
                          customAlert(
                              AlertDialogType
                                  .Numero_de_celular_actualizado_correctamente,
                              context,
                              "",
                              "",
                              responsive,
                              funcionAlerta);
                        } else {
                          customAlert(AlertDialogType.errorServicio, context,
                              "", "", responsive, funcionAlerta);
                        }
                      } else {
                        customAlert(AlertDialogType.errorServicio, context, "",
                            "", responsive, funcionAlerta);
                      }
                    } else if (prefs.getBool("esPerfil") != null &&
                        prefs.getBool("esPerfil") &&
                        prefs.getBool("actualizarContrasenaPerfil")) {
                      if (prefs.getBool("seActualizarNumero") != null &&
                          prefs.getBool("seActualizarNumero")) {
                        AltaMedisoContactoAgentes actualizarNumero =
                            await altaMediosContactoServicio(
                                context,
                                prefs.getString("lada"),
                                prefs.getString("numero"));

                        setState(() {
                          _saving = false;
                        });

                        if (actualizarNumero != null) {
                          if (actualizarNumero.idMedioContacto != "" &&
                              actualizarNumero.secuencial != "") {
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString("lada") +
                                    prefs.getString("numero"));
                            customAlert(
                                AlertDialogType
                                    .Numero_de_celular_actualizado_correctamente,
                                context,
                                "",
                                "",
                                responsive,
                                funcionAlerta);
                          } else {
                            customAlert(AlertDialogType.errorServicio, context,
                                "", "", responsive, funcionAlerta);
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString(
                                    "medioContactoTelefonoServicio"));
                          }
                        } else {
                          customAlert(AlertDialogType.errorServicio, context,
                              "", "", responsive, funcionAlerta);
                          prefs.setString("medioContactoTelefono",
                              prefs.getString("medioContactoTelefonoServicio"));
                        }
                      } else {
                        setState(() {
                          _saving = false;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginActualizarContrasena(
                                    responsive: widget.responsive)));
                      }
                    } else {
                      if (prefs.getBool("seActualizarNumero") != null &&
                          prefs.getBool("seActualizarNumero")) {
                        AltaMedisoContactoAgentes actualizarNumero =
                            await altaMediosContactoServicio(
                                context,
                                prefs.getString("lada"),
                                prefs.getString("numero"));

                        setState(() {
                          _saving = false;
                        });

                        if (actualizarNumero != null) {
                          print("actualizarNumero if ");
                          if (actualizarNumero.idMedioContacto != "" &&
                              actualizarNumero.secuencial != "") {
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString("lada") +
                                    prefs.getString("numero"));
                            customAlert(
                                AlertDialogType
                                    .Numero_de_celular_actualizado_correctamente,
                                context,
                                "",
                                "",
                                responsive,
                                funcionAlerta);
                          } else {
                            customAlert(AlertDialogType.errorServicio, context,
                                "", "", responsive, funcionAlerta);
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString(
                                    "medioContactoTelefonoServicio"));
                          }
                        } else {
                          print("actualizarNumero else ");
                          customAlert(AlertDialogType.errorServicio, context,
                              "", "", responsive, funcionAlerta);
                          if (prefs
                                  .getString("medioContactoTelefonoServicio") ==
                              "") {
                          } else {
                            prefs.setString(
                                "medioContactoTelefono",
                                prefs.getString(
                                    "medioContactoTelefonoServicio"));
                          }
                        }
                      } else {
                        if (prefs.getBool('flujoOlvideContrasena') != null &&
                            prefs.getBool('flujoOlvideContrasena')) {
                          setState(() {
                            _saving= false;
                          });
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginRestablecerContrasena(
                                          responsive: widget.responsive)));
                        } else {
                          print("Flujoo completo");
                          prefs.setBool("flujoCompletoLogin", true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => HomePage(
                                        responsive: responsive,
                                      )));
                        }
                      }
                    }
                  } else {
                    setState(() {
                      _saving = false;
                      _validCode = false;
                      controllerCodigo.text = "";
                      codigoValidacion = "El código no coincide";
                      _validCodeForm = _formKey.currentState.validate();
                    });
                  }
                } else {
                  setState(() {
                    _validCode = false;
                    codigoValidacion = "El código no coincide";
                    // todo limpiar codiggo
                    controllerCodigo.text = "";
                    _validCodeForm = _formKey.currentState.validate();
                  });
                }
              } else {}
            }
          }),
    );
  }

  Widget noEsNumero(Responsive responsive) {
    return prefs.getBool('flujoOlvideContrasena') != null &&
            !prefs.getBool('flujoOlvideContrasena')
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              "NO ES MI NÚMERO ACTUAL",
              style: TextStyle(
                  color: Tema.Colors.GNP,
                  fontWeight: FontWeight.w500,
                  fontSize: prefs.getBool("useMobileLayout")
                      ? responsive.ip(2)
                      : responsive.ip(1.4)),
            ),
            onPressed: () {
              if (prefs.getBool("esPerfil") != null &&
                  prefs.getBool("esPerfil") &&
                  prefs.getBool("esActualizarNumero")) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(responsive: responsive)));
              } else if (prefs.getBool("esPerfil") != null &&
                  prefs.getBool("esPerfil") &&
                  prefs.getBool("actualizarContrasenaPerfil")) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(responsive: responsive)));
              } else {
                if (prefs.getBool("esActualizarNumero")) {
                } else {}
                prefs.setBool("actulizarNumeroDesdeCodigo", true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(responsive: responsive)));
              }
            },
          )
        : Container();
  }

  void funcionAlerta() {}

  void CallbackInactividad(){
    setState(() {
      print("CallbackInactividad codigo de verificacion");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      handleUserInteraction(context,CallbackInactividad);
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
