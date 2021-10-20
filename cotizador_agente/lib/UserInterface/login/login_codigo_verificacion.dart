import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/Crypto.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Models/CounterOTP.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/Security/EncryptData.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';
import 'package:otp_autofill/otp_interactor.dart';
import 'package:otp_autofill/otp_text_edit_controller.dart';
import 'package:provider/provider.dart';
//import 'package:sms/sms.dart';
import '../../main.dart';
import 'loginRestablecerContrasena.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//import 'package:sms_maintained/sms.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';



bool timerEnd = false;
Widget timer;
String BackgroundRemaining;
String BackgroundRemainingDate;
EncryptData _encryptData = EncryptData();

class LoginCodigoVerificaion extends StatefulWidget {
  final isNumero;
  final Responsive responsive;
  const LoginCodigoVerificaion({Key key, this.responsive, this.isNumero})
      : super(key: key);
  @override
  _LoginCodigoVerificaionState createState() => _LoginCodigoVerificaionState();
}

class _LoginCodigoVerificaionState extends State<LoginCodigoVerificaion> with WidgetsBindingObserver {
  bool _saving;
  bool _validCode = true;
  bool _validCodeForm = true;
  bool _showFinOtro = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerCodigo;
  FocusNode focusCodigo;
  String codigoValidacion;
  //SmsReceiver receiver = new SmsReceiver();



  Future<void> initSmsListener() async {

    if(mounted){
      AltSmsAutofill().unregisterListener();
    }

    try {
      await consultaBitacora();
    }catch(e){
      print("consultaBitacora codigoV");
      print(e);
    }

    print("Sms star");
    String commingSms;
    try {
      commingSms = await AltSmsAutofill().listenForSms;
      print("recive Sms ${commingSms}");
    } catch(e) {
      print("Sms Failed to get Sms. ${e}");
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;


    setState(() {
      if(controllerCodigo != null){
      controllerCodigo.text="";
      print("Sms codigoValidacion${commingSms.substring(0,8)}");
      controllerCodigo.text = commingSms.substring(0,8);
      print("Sms codigoValidacion${controllerCodigo.text}");
      }
    });

  }


  @override
  void initState() {

    BackgroundRemainingDate = "${DateTime.now()}";
    WidgetsBinding.instance.addObserver(this);
    if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
      Inactivity(context:context).initialInactivity(functionInactivity);
    }
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

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
        setState(() {
          focusCodigo.unfocus();
          focusContrasenaInactividad.unfocus();
        });
      }
    });

    if(Platform.isAndroid)
      initSmsListener();
    super.initState();

    // Validate unfocus TextField
    focusCodigo.addListener(() {
      setState(() {
        _validCodeForm = _formKey.currentState.validate();
      });
    });
  }

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    super.dispose();
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

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CounterOTP>(create: (context) => CounterOTP(),
          ),
        ],
        builder: (BuildContext context, Widget child) {
          Provider.of<CounterOTP>(context, listen: true).doSomething();
          return child;
        },
    child: GestureDetector(onTap: (){
      setState(() {
        focusCodigo.unfocus();
        focusContrasenaInactividad.unfocus();
      });
      if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
          Inactivity(context:context).initialInactivity(functionInactivity);
        }
      },
      child: SafeArea(
        bottom: false,
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
                        if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                          Inactivity(context:context).cancelInactivity();
                        }
                        if (_saving) {
                        } else {
                          String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefonoServicio"),
                              "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                          if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                            prefs.setString("medioContactoTelefono", encryptAESCryptoJS(decryptedNumber));
                            Navigator.pop(context, true);
                          } else {
                            prefs.setString("medioContactoTelefono", encryptAESCryptoJS(decryptedNumber));
                            Navigator.pop(context, true);
                          }
                        }
                      },
                    ),
                  ),
            body: Stack(children: builData(widget.responsive))),
      ),
    ));
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
                      "${"(+52)" + decryptAESCryptoJS(prefs.getString("medioContactoTelefono"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020")}",
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
      autofillHints: [AutofillHints.oneTimeCode],
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
          } catch (e) {
            print(e);
          }
        });
      },
    );
  }

  Widget validacionCodigo(Responsive responsive) {

    return Consumer<CounterOTP>( //                    <--- Consumer
        builder: (context, myModel, child) {
          return Container(
            width: responsive.width,
            color: !timerEnd || (myModel!=null&&myModel.minuts!=null&&myModel.minuts!="00" && myModel.seconds!=null&&myModel.seconds!="00") ? Tema.Colors.dialogoExpiro : Tema.Colors.dialogoExpiradoBG,
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
                      child: !timerEnd || (myModel.minuts!="00" && myModel.seconds!="00")
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
                            color: !timerEnd || (myModel.minuts!="00" && myModel.seconds!="00")
                                ? Tema.Colors.textoExpiro
                                : Tema.Colors.validarCampo,
                            fontWeight: FontWeight.w500,
                            fontSize: responsive.ip(1.2),
                          ),
                        ),
                      ),
                      !timerEnd || (myModel.minuts!="00" && myModel.seconds!="00")
                          ? CountdownFormatted(
                          duration: Duration(minutes: int.parse(context.watch<CounterOTP>().minuts), seconds: int.parse(context.watch<CounterOTP>().seconds)),
                          onFinish: () {
                            setState(() {
                              timerEnd = true;
                              controllerCodigo.text = "";
                            });
                            Provider.of<CounterOTP>(context, listen: false).doSomething();
                            Provider.of<CounterOTP>(context, listen: false).dispose();
                          },
                          builder: (BuildContext ctx, String remaining) {
                            Provider.of<CounterOTP>(context, listen: true).doSomething();

                            if(timerEnd || (myModel.minuts=="00" && myModel.seconds=="00")){
                              Future.delayed(Duration.zero, () async {
                                setState(() {
                                  timerEnd = true;
                                  controllerCodigo.text = "";
                                });
                                try{
                                  Provider.of<CounterOTP>(context, listen: false).dispose();
                                } catch (e){

                                }

                              });
                            }
                            return Text("Válido por ${myModel.minuts}:${myModel.seconds} minutos",
                                style: TextStyle(
                                    color: Tema.Colors.Azul_2,
                                    fontWeight: FontWeight.normal,
                                    fontSize: prefs.getBool("useMobileLayout")
                                        ? responsive.ip(2)
                                        : responsive.ip(1.5)));
                          }
                      )
                          : Container(child: Text("Expirado", style: TextStyle(
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
        });
  }


  Widget reenviarCodigo(Responsive responsive) {
    //AltSmsAutofill().unregisterListener();
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

              sendTag("appinter_otp_reenvio");

              BackgroundRemainingDate = "${DateTime.now()}";
              if(Platform.isAndroid){
                AltSmsAutofill().unregisterListener();
                initSmsListener();
              }

              focusCodigo.unfocus();
              setState(() {

                controllerCodigo.text = "";
                timerEnd = true;
                codigoValidacion = "";
                _formKey.currentState.reset();
              });
              if (prefs.getBool('flujoOlvideContrasena')) {
                setState(() {
                  _saving = true;
                });
                var decryptedEmail = _encryptData.decryptData(prefs.getString("correoCambioContrasena"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                print("Email decrypted 595 $decryptedEmail");
                OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
                    context,
                    decryptedEmail,
                    "",
                    prefs.getBool('flujoOlvideContrasena'));
                setState(() {
                  _saving = false;
                });

                if (optRespuesta != null) {
                  setState(() {
                    controllerCodigo.text = "";
                    timerEnd = false;
                  });

                  if (optRespuesta.error == "" && optRespuesta.idError == "") {
                    //TODO validar Dali
                    sendTag("appinter_otp_ok");
                    prefs.setString("idOperacion",_encryptData.encryptInfo(optRespuesta.idOperacion, "idOperacion"));
                    //prefs.setBool('flujoOlvideContrasena', true);
                    //Navigator.pop(context,true);
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginCodigoVerificaion(responsive: responsive,)));
                  } else if ( optRespuesta.idError == "015" ) {
                    customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
                        responsive, funcionAlerta);
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
                  String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefono"),
                      "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                  if (prefs.getBool("esActualizarNumero")) {
                    optRespuesta = await orquestadorOTPJwtServicio(context,
                        decryptedNumber, true);
                  } else if(prefs.getBool("seActualizarNumero")){
                    optRespuesta = await orquestadorOTPJwtServicio(context,
                        decryptedNumber, true);
                  } else {
                    optRespuesta = await orquestadorOTPJwtServicio(context,
                        decryptedNumber, false);
                  }

                  setState(() {
                    controllerCodigo.text = "";
                    _saving = false;
                  });
                  if (optRespuesta != null) {
                    setState(() {
                      timerEnd = false;
                    });

                    if (optRespuesta.error == "") {
                      //TODO validar Dali
                      sendTag("appinter_otp_ok");
                      prefs.setString("idOperacion",_encryptData.encryptInfo(optRespuesta.idOperacion, "idOperacion"));
                    } else {
                      //TODO validar Dali
                      sendTag("appinter_otp_error");
                      if(optRespuesta.idError == "015"){
                        customAlert(AlertDialogType.error_codigo_verificacion, context, "",
                            "", responsive, funcion);
                      } else {
                        customAlert(AlertDialogType.errorServicio, context, "", "",
                            responsive, funcion);
                      }
                    }
                  } else {
                    //TODO validar Dali
                    sendTag("appinter_otp_error");
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcion);
                  }
                } else {
                  setState(() {
                    controllerCodigo.text = "";
                    _saving = true;
                  });
                  var decryptedEmail = _encryptData.decryptData(prefs.getString("correoUsuario"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                  String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefono"),
                      "CL#AvEPrincIp4LvA#lMEXapgpsi2020");

                  OrquestadorOTPModel optRespuesta =
                      await orquestadorOTPServicio(
                          context,
                          decryptedEmail,
                          decryptedNumber,
                          false);
                  setState(() {
                    timerEnd = false;
                    _saving = false;
                  });
                  if (optRespuesta != null) {
                    if (optRespuesta.error == "" &&
                        optRespuesta.idError == "") {
                      prefs.setString("idOperacion",_encryptData.encryptInfo(optRespuesta.idOperacion, "idOperacion"));
                      //TODO validar Dali
                      sendTag("appinter_otp_ok");
                    }else if ( optRespuesta.idError == "015" ) {
                      customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
                          responsive, funcionAlerta);
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
                  ? responsive.hp(17)
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
                var decryptedId = _encryptData.decryptData(prefs.getString("idOperacion"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                print("ID decrypted $decryptedId");
                ValidarOTPModel validarOTP = await validaOrquestadorOTPServicio(
                    context,
                    decryptedId,
                    controllerCodigo.text);


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
                          String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefono"),
                              "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
                          customAlert(AlertDialogType.errorServicio, context,
                              "", "", responsive, funcionAlerta);
                          prefs.setString("medioContactoTelefono", encryptAESCryptoJS(decryptedNumber));
                        }
                      } else {
                        setState(() {
                          _saving = false;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginActualizarContrasena(
                                    responsive: widget.responsive))).then((value){

                        });
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
                                          responsive: widget.responsive))).then((value){
                             });
                        } else {
                          print("Flujoo completo");
                          prefs.setBool("flujoCompletoLogin", true);
                          if(_showFinOtro){
                            customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, "title", "message", responsive, callback);
                          }else{
                            sendTag("appinter_login_ok");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      responsive: responsive,
                                    ),settings: RouteSettings(name: "Home"))).then((value){
                              });
                          }
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
                            LoginActualizarNumero(responsive: responsive))).then((value){

                            });
              } else if (prefs.getBool("esPerfil") != null &&
                  prefs.getBool("esPerfil") &&
                  prefs.getBool("actualizarContrasenaPerfil")) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(responsive: responsive))).then((value){
                              });
              } else {
                if (prefs.getBool("esActualizarNumero")) {
                } else {}
                prefs.setBool("actulizarNumeroDesdeCodigo", true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginActualizarNumero(responsive: responsive))).then((value){
                               });
              }
            },
          )
        : Container();
  }

  void funcionAlerta() {}

  void consultaBitacora() async {
    print("consultaBitacora - loginCodigoV");
    DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);

      print("-- response -- ${response}");
      if(response!= null && response.isNotEmpty){
        if(deviceData["id"]==response["deviceID"]){
          setState(() {
            _showFinOtro = false;
          });
        }else{
          if(response["isActive"]!= null && response["isActive"]){
            setState(() {
              _showFinOtro = true;
            });
          }
          else{
            setState(() {
              _showFinOtro = false;
            });
          }
        }
      } else{
        setState(() {
          _showFinOtro = false;
      });
      };
    });
  }
/*
  backgroundTimierCounter(){
    //final codeState = _LoginCodigoVerificaionState();

    print("backgroundTimierCounter");
    print("BackgroundRemainingDate inicio: $BackgroundRemainingDate segundoOcupados:$BackgroundRemaining");

    if(BackgroundRemainingDate!="0") {
      DateTime nowInicio = DateTime.parse(BackgroundRemainingDate);
      DateTime backgroundTermino = new DateTime.now();
      DateTime stopInicio = nowInicio.add(Duration(minutes: 3));

      print("BackgroundRemainingDate:1 $nowInicio");
      print("BackgroundRemainingDate:2 $backgroundTermino");
      print("BackgroundRemainingDate:3 $stopInicio");

      if (backgroundTermino.isAfter(stopInicio)) {
        timerEnd = true;
        print("timerEnd:3 $timerEnd");
        print("minuts: ${CounterOTP().minuts}");
        print("seconds: ${CounterOTP().minuts}");
        //codeState.functionConnectivity();
        //BackgroundRemaining = nowInicio.subtract(Duration(minutes: backgroundTermino.second);
      }else{

        //cuanto tiempo paso afuera
        var BackgroundTime = backgroundTermino.difference(nowInicio);

        int minutesBackground = 0;
        int secondsBackground = 0;
        int minutesFinal = 0;
        int secondsFinal = 0;

        List<String> parts = "$BackgroundTime".split(':');
        print("parts: $BackgroundTime  $parts ${parts.length}");

        minutesBackground = int.parse(parts[1]);
        if(parts[2].contains("."))
          secondsBackground = int.parse(parts[2].split('.')[0]);
        else
          secondsBackground = int.parse(parts[2]);

        print("parts:next $minutesBackground - $secondsBackground");


        DateTime DateInicio = nowInicio.add(Duration(minutes: minutesBackground, seconds: secondsBackground));

        var BackgroundTimeFinal = stopInicio.difference(DateInicio);

        print("BackgroundRemaining:5 $DateInicio - $BackgroundTimeFinal");


        List<String> partsFinal = "$BackgroundTimeFinal".split(':');

        minutesFinal = int.parse(partsFinal[1]);
        if(partsFinal[2].contains("."))
          secondsFinal = int.parse(partsFinal[2].split('.')[0]);
        else
          secondsFinal = int.parse(partsFinal[2]);

        BackgroundRemaining = "$minutesFinal:$secondsFinal";
        //codeState.functionConnectivity();
        print("BackgroundRemaining:5 $BackgroundRemaining");
      }
    }

  }*/

  void CallbackInactividad(){
    setState(() {
      print("CallbackInactividad codigo de verificacion");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
