import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/Crypto.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/SeleccionarPreguntas.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/Security/EncryptData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';
import '../../utils/responsive.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

enum tipoDePregunta { respuestaUno, respuestaDos }

class PreguntasSecretas extends StatefulWidget {
  final Responsive responsive;
  const PreguntasSecretas({Key key, this.responsive}) : super(key: key);
  @override
  _PreguntasSecretasState createState() => _PreguntasSecretasState();
}

TextEditingController controllerPreguntaUno;
TextEditingController controllerPreguntaDos;
TextEditingController controllerRespuestaUno;
TextEditingController controllerRespuestaDos;

class _PreguntasSecretasState extends State<PreguntasSecretas> {
  bool _saving;
  bool respuestaUno;
  bool respuestaDos;
  final _formKey = GlobalKey<FormState>();
  EncryptData _encryptData = EncryptData();

  FocusNode focusPreguntaUno;
  FocusNode focusRespuestaUno;
  FocusNode focusPreguntaDos;
  FocusNode focusRespuestaDos;

  // Validation
  final _formKeyQuestionOne = GlobalKey<FormState>();
  final _formKeyAnswerOne = GlobalKey<FormState>();
  final _formKeyQuestionTwo = GlobalKey<FormState>();
  final _formKeyAnswerTwo = GlobalKey<FormState>();
  bool _validQuestionOne = true;
  bool _validAnswerOne = true;
  bool _validQuestionTwo = true;
  bool _validAnswerTwo = true;


  @override
  void initState() {
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);


    _saving = false;
    respuestaUno = true;
    respuestaDos = true;
    controllerPreguntaUno = new TextEditingController();
    controllerRespuestaUno = new TextEditingController();
    controllerPreguntaDos = new TextEditingController();
    controllerRespuestaDos = new TextEditingController();
    focusPreguntaUno = new FocusNode();
    focusRespuestaUno = new FocusNode();
    focusPreguntaDos = new FocusNode();
    focusRespuestaDos = new FocusNode();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    //print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');

      if (!visible) {
        focusRespuestaUno.unfocus();
        focusRespuestaDos.unfocus();
        focusPreguntaUno.unfocus();
        focusPreguntaDos.unfocus();
        focusContrasenaInactividad.unfocus();
        setState(() {});
      }
    });
    // TODO: implement initState
    super.initState();

    // Validate unfocus TextField
    /*focusPreguntaUno.addListener(() {
      print("focusPreguntaUno focus ${focusPreguntaUno}");
      print("focusPreguntaUno ${controllerPreguntaUno.text}");
      setState(() {
        _validQuestionOne = _formKeyQuestionOne.currentState.validate();
      });
      setState(() {

      });
    });

    focusPreguntaDos.addListener(() {
      setState(() {
        _validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
      });
    });*/

    focusRespuestaUno.addListener(() {
      String respuestaDosTrim = controllerRespuestaUno.text.trimRight();
      controllerRespuestaUno.text = respuestaDosTrim.trimLeft();

      setState(() {
        _validAnswerOne = _formKeyAnswerOne.currentState.validate();
      });
    });

    focusRespuestaDos.addListener(() {
      String respuestaDosTrim = controllerRespuestaDos.text.trimRight();
      controllerRespuestaDos.text = respuestaDosTrim.trimLeft();

      setState(() {
        _validAnswerTwo = _formKeyAnswerTwo.currentState.validate();
      });
    });
  }

  void functionConnectivity() {
    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusPreguntaUno.dispose();
    focusRespuestaUno.dispose();
    focusPreguntaDos.dispose();
    focusRespuestaDos.dispose();
    super.dispose();
  }

  removeAccent(String str) {

    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    print("strNoAccent ${str}");
    return str;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar: _saving
              ? null
              : AppBar(
                  backgroundColor: Tema.Colors.backgroud,
                  elevation: 0,
                  title: Text(
                    'Actualizar preguntas',
                    style: TextStyle(
                        color: Tema.Colors.Azul_2,
                        fontWeight: FontWeight.normal,
                        fontSize: widget.responsive.ip(2.5)),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Tema.Colors.GNP,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
          body: Stack(children: builData(widget.responsive))),
    );
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();

    data = Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Container(
        margin:
            EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              separacion(responsive, 5),
              Form(
                  key: _formKeyQuestionOne,
                  child: PreguntaSeguridadUno(responsive)),
              separacion(responsive, 5),
              Form(
                  key: _formKeyAnswerOne,
                  child: RespuestaSeguridadUno(responsive)),
              separacion(responsive, 5),
              Form(
                  key: _formKeyQuestionTwo,
                  child: PreguntaSeguridadDos(responsive)),
              separacion(responsive, 5),
              Form(
                  key: _formKeyAnswerTwo,
                  child: RespuestaSeguridadDos(responsive)),
              separacion(responsive, 5),
              enviar(responsive)
            ]),
      )),
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

  Widget PreguntaSeguridadUno(Responsive responsive) {
    return TextFormField(
      onEditingComplete: () {
        print("onEditingComplete");
        setState(() {
          //_validQuestionOne = _formKeyQuestionOne.currentState.validate();
          focusPreguntaUno.unfocus();
        });
      },
      onFieldSubmitted: (s) {
        print("onFieldSubmitted");
        setState(() {
          //_validQuestionOne = _formKeyQuestionOne.currentState.validate();
        });
      },
      controller: controllerPreguntaUno,
      focusNode: focusPreguntaUno,
      obscureText: false,
      readOnly: true,
      cursorColor: Tema.Colors.GNP,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
        labelText: "Pregunta de seguridad",
        labelStyle: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2),
          color: _validQuestionOne
              ? focusPreguntaUno.hasFocus
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
              color: _validQuestionOne
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _validQuestionOne
                  ? Tema.Colors.GNP
                  : Tema.Colors.validarCampo,
              width: 2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _validQuestionOne
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo,
              width: 2),
        ),
        suffixIcon: IconButton(
          icon: focusPreguntaUno.hasFocus
              ? Image.asset(
                  "assets/login/preguntasIconoFlecha.png",
                  color: Tema.Colors.Rectangle_PA,
                )
              : Image.asset("assets/login/preguntasIconoFlecha.png"),
          color: Tema.Colors.VLMX_Navy_40,
        ),
      ),
      validator: (value) {
        print("PreguntaSeguridadUno ${value}");
        if (value.isEmpty || controllerPreguntaUno.text == "") {
          _validQuestionOne = false;
          return 'Este campo es requerido';
        } else if (controllerPreguntaUno.text == controllerPreguntaDos.text) {
          _validQuestionOne = false;
          return 'Tus preguntas secretas deben ser diferentes';
        } else {
          _validQuestionOne = true;
          return null;
        }
      },
      onChanged: (value) {
        setState(() {
          //focusPreguntaUno.requestFocus();
          //controllerPreguntaUno.text;
          //_validQuestionOne = _formKeyQuestionOne.currentState.validate();

          print("_validQuestionOne ${_validQuestionOne}");
        });
      },
      onTap: () {
        setState(() {
          focusPreguntaUno.requestFocus();
          focusRespuestaDos.unfocus();
          focusRespuestaUno.unfocus();
          focusPreguntaDos.unfocus();
          //_validQuestionOne = _formKeyQuestionOne.currentState.validate();

          /*if (controllerPreguntaUno.text == "") {

            _validQuestionOne = false;
          } else if (controllerPreguntaUno.text == controllerPreguntaDos.text) {

            _validQuestionOne = false;
          } else {
            _validQuestionOne = true;
          }*/
          print("controllerPreguntaUno.text ${controllerPreguntaUno.text}");
          print("_validQuestionOne ontap ${_validQuestionOne}");
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SeleccionarPreguntas(
                    responsive: widget.responsive,
                    typeResponse: tipoDePregunta.respuestaUno,
                    callback: funcionUnfocus,
                  )),
        ).then((value) {

        });
      },
    );
  }

  Widget RespuestaSeguridadUno(Responsive responsive) {
    return TextFormField(
      onTap: () {
        setState(() {
          setState(() {
            // _validQuestionOne = _formKeyQuestionOne.currentState.validate();
          });
        });
      },
      onEditingComplete: () {
        setState(() {
          focusRespuestaUno.unfocus();
        });
      },
      onFieldSubmitted: (s) {
        setState(() {
          String respuestaUnoTrim = controllerRespuestaUno.text.trimRight();
          controllerRespuestaUno.text = respuestaUnoTrim.trimLeft();
          _validAnswerOne = _formKeyAnswerOne.currentState.validate();
        });
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      controller: controllerRespuestaUno,
      focusNode: focusRespuestaUno,
      obscureText: respuestaUno,
      cursorColor: _validAnswerOne ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
          labelText: "Respuesta",
          labelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.normal,
            fontSize: responsive.ip(2),
            color: _validAnswerOne
                ? focusRespuestaUno.hasFocus
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
                color: _validAnswerOne
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validAnswerOne
                    ? Tema.Colors.GNP
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validAnswerOne
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          suffixIcon: IconButton(
            icon: respuestaUno
                ? _validAnswerOne
                    ? Image.asset("assets/login/novercontrasena.png")
                    : Image.asset("assets/login/_icon_error_contrasena.png")
                : _validAnswerOne
                    ? Image.asset("assets/login/vercontrasena.png")
                    : Image.asset("assets/login/_icono-withmask.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: () {
              setState(() {
                respuestaUno = !respuestaUno;
              });
            },
          )),
      validator: (value) {
        //String p = "^[ñÑa-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
        //RegExp regExp = new RegExp(p);

        print("RespuestaSeguridadUno ${value}");
        if (value.isEmpty && controllerPreguntaUno.text != "") {
          return 'Para continuar, debes responder a la pregunta';
        } else if (value.isEmpty) {
          return 'Este campo es requerido';
        } else if ((removeAccent(controllerRespuestaUno.text.toLowerCase().trim()) ==  removeAccent(controllerRespuestaDos.text.toLowerCase().trim())) && (controllerRespuestaUno.text.toLowerCase() != "" && controllerRespuestaDos.text.toLowerCase() != "")) {
          return 'Tus respuestas deben ser diferentes';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        setState(() {
          _validAnswerOne = _formKeyAnswerOne.currentState.validate();
          _validAnswerTwo = _formKeyAnswerTwo.currentState.validate();
          print("onChanged _validAnswerOne ${_validAnswerOne}");
          try {
            if (controllerRespuestaUno.text.isNotEmpty &&
                controllerRespuestaUno.text.length >= 25) {
              String tem = controllerRespuestaUno.text;
              controllerRespuestaUno.text = tem.substring(0, 24);
              focusRespuestaUno.unfocus();
            }
          } catch (e) {
            print(e);
          }
        });
        print("_validAnswerOne----> ${_validAnswerOne}");
        /*setState(() {
          focusRespuestaUno.hasFocus;
          controllerRespuestaUno.text.trim();

        });*/
      },
    );
  }

  Widget PreguntaSeguridadDos(Responsive responsive) {
    return TextFormField(
      onEditingComplete: () {
        setState(() {
          //_validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
          focusPreguntaDos.unfocus();
        });
      },
      onFieldSubmitted: (s) {
        setState(() {
          //_validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
        });
      },
      enableInteractiveSelection: false,
      controller: controllerPreguntaDos,
      focusNode: focusPreguntaDos,
      obscureText: false,
      readOnly: true,
      cursorColor: Tema.Colors.GNP,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
        labelText: "Pregunta de seguridad",
        labelStyle: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2),
          color: _validQuestionTwo
              ? focusPreguntaDos.hasFocus
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
              color: _validQuestionTwo
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _validQuestionTwo
                  ? Tema.Colors.GNP
                  : Tema.Colors.validarCampo,
              width: 2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _validQuestionTwo
                  ? Tema.Colors.inputlinea
                  : Tema.Colors.validarCampo,
              width: 2),
        ),
        suffixIcon: IconButton(
          icon: focusPreguntaDos.hasFocus
              ? Image.asset(
                  "assets/login/preguntasIconoFlecha.png",
                  color: Tema.Colors.Rectangle_PA,
                )
              : Image.asset("assets/login/preguntasIconoFlecha.png"),
          color: Tema.Colors.VLMX_Navy_40,
        ),
      ),
      validator: (value) {
        print("PreguntaSeguridadDos ${value}");
        if (value.isEmpty || controllerPreguntaDos.text == "") {
          return 'Este campo es requerido';
        } else if (controllerPreguntaUno.text == controllerPreguntaDos.text) {
          return 'Tus preguntas secretas deben ser diferentes';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        setState(() {
          //focusPreguntaDos.requestFocus();
          //controllerPreguntaDos.text;
          //_validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
        });
      },
      onTap: () {
        setState(() {
          setState(() {
            focusPreguntaDos.requestFocus();
            focusRespuestaDos.unfocus();
            focusRespuestaUno.unfocus();
            focusPreguntaUno.unfocus();
            setState(() {
              //_validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
            });
          });
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SeleccionarPreguntas(
                    responsive: widget.responsive,
                    typeResponse: tipoDePregunta.respuestaDos,
                    callback: funcionUnfocus,
                  )),
        ).then((value) {

        });
      },
    );
  }

  Widget RespuestaSeguridadDos(Responsive responsive) {
    return TextFormField(
      onTap: () {
        setState(() {});
      },
      onEditingComplete: () {
        setState(() {
          focusRespuestaDos.unfocus();
        });
      },
      onFieldSubmitted: (s) {
        setState(() {
          String respuestaDosTrim = controllerRespuestaDos.text.trimRight();
          controllerRespuestaDos.text = respuestaDosTrim.trimLeft();
          _validAnswerTwo = _formKeyAnswerTwo.currentState.validate();
        });
      },
      inputFormatters: [LengthLimitingTextInputFormatter(25)],
      controller: controllerRespuestaDos,
      focusNode: focusRespuestaDos,
      obscureText: respuestaDos,
      cursorColor: _validAnswerTwo ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
          labelText: "Respuesta",
          labelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.normal,
            fontSize: responsive.ip(2),
            color: _validAnswerTwo
                ? focusRespuestaDos.hasFocus
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
                color: _validAnswerTwo
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validAnswerTwo
                    ? Tema.Colors.GNP
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validAnswerTwo
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          suffixIcon: IconButton(
            icon: respuestaDos
                ? _validAnswerTwo
                    ? Image.asset("assets/login/novercontrasena.png")
                    : Image.asset("assets/login/_icon_error_contrasena.png")
                : _validAnswerTwo
                    ? Image.asset("assets/login/vercontrasena.png")
                    : Image.asset("assets/login/_icono-withmask.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: () {
              setState(() {
                respuestaDos = !respuestaDos;
              });
            },
          )),
      validator: (value) {
        //String p = "^[ñÑa-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$";
        //RegExp regExp = new RegExp(p);
        if (value.isEmpty && controllerPreguntaDos.text != "") {
          return 'Para continuar, debes responder a la pregunta';
        } else if (value.isEmpty) {
          return 'Este campo es requerido';
        } else if ((removeAccent(controllerRespuestaUno.text.toLowerCase().trim()) == removeAccent(controllerRespuestaDos.text.toLowerCase().trim())) &&
            (controllerRespuestaUno.text.toLowerCase() != "" && controllerRespuestaDos.text.toLowerCase() != "")) {
          return 'Tus respuestas deben ser diferentes';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        setState(() {
          _validAnswerOne = _formKeyAnswerOne.currentState.validate();
          _validAnswerTwo = _formKeyAnswerTwo.currentState.validate();
          print("onChanged _validAnswerTwo ${_validAnswerTwo}");
          try {
            if (controllerRespuestaDos.text.isNotEmpty &&
                controllerRespuestaDos.text.length >= 25) {
              String tem = controllerRespuestaDos.text;
              controllerRespuestaDos.text = tem.substring(0, 24);
              focusRespuestaDos.unfocus();
            }
          } catch (e) {
            print(e);
          }
        });
        /*setState(() {
          focusRespuestaDos.hasFocus;
          controllerRespuestaDos.text.trim();
          try {
            if (controllerRespuestaDos.text.isNotEmpty &&
                controllerRespuestaDos.text.length >= 25) {
              String tem = controllerRespuestaDos.text;
              controllerRespuestaDos.text = tem.substring(0, 24);
              focusRespuestaDos.unfocus();
            }
          } catch (e) {
            print(e);
          }
        });*/
      },
    );
  }

  Widget enviar(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(23), bottom: responsive.hp(1)),
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color:  controllerPreguntaUno.text != "" &&
                      controllerPreguntaDos.text != "" &&
                      controllerRespuestaUno.text.trim() != "" &&
                      controllerRespuestaDos.text.trim() != "" &&
                      controllerPreguntaUno.text != controllerPreguntaDos.text && _validAnswerOne && _validAnswerTwo && _validQuestionOne && _validAnswerTwo
                  ? Tema.Colors.GNP
                  : Tema.Colors.botonlogin,
            ),
            width: responsive.width,
            child: Container(
              margin: EdgeInsets.only(
                  top: responsive.hp(2), bottom: responsive.hp(2)),
              child: Text(
                "ACTUALIZAR",
                style: TextStyle(
                    color:  controllerPreguntaUno.text != "" &&
                            controllerPreguntaDos.text != "" &&
                            controllerRespuestaUno.text != "" &&
                            controllerRespuestaDos.text != "" &&
                            controllerPreguntaUno.text != controllerPreguntaDos.text
                        ? Tema.Colors.backgroud
                        : Tema.Colors.botonletra,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            focusPreguntaUno.unfocus();
            focusRespuestaUno.unfocus();
            focusPreguntaDos.unfocus();
            focusRespuestaDos.unfocus();
            if (_formKeyQuestionOne.currentState.validate() &&
                _formKeyAnswerOne.currentState.validate() &&
                _formKeyQuestionTwo.currentState.validate() &&
                _formKeyAnswerTwo.currentState.validate()) {
              setState(() {
                _saving = true;
              });
              var decrypted = _encryptData.decryptData(prefs.getString("contraenaActualizada"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
              consultaPreguntasSecretasModel actualizarPreguntas =
                  await actualizarPreguntaSecretaServicio(
                      context,
                      datosUsuario.idparticipante,
                      decrypted,
                      controllerPreguntaUno.text,
                      controllerRespuestaUno.text.trim(),
                      controllerPreguntaDos.text,
                      controllerRespuestaDos.text.trim(),responsive);

              if (actualizarPreguntas != null) {
                setState(() {
                  _saving = false;
                });
                if (actualizarPreguntas.requestStatus == "SUCCEEDED") {
                  customAlert(
                      AlertDialogType.preguntasSecretasActualizadas,
                      context,
                      "",
                      "",
                      responsive,
                      funcionAlertaCodVerificacion);
                } else {
                  customAlert(AlertDialogType.errorServicio, context, "", "",
                      responsive, funcionAlerta);
                }
              } else {
                setState(() {
                  _saving = false;
                });
              }
            }
          }),
    );
  }

  void funcionUnfocus() {
    setState(() {
      focusRespuestaUno.requestFocus();
      focusRespuestaDos.unfocus();
      focusRespuestaUno.unfocus();
      focusPreguntaDos.unfocus();
      focusPreguntaUno.unfocus();
      setState(() {
        _validQuestionOne = _formKeyQuestionOne.currentState.validate();
        _validQuestionTwo = _formKeyQuestionTwo.currentState.validate();
      });
    });
  }

  void funcionAlerta() {}

  void funcionAlertaCodVerificacion(Responsive responsive) async {
      setState(() {
        _saving = true;
      });
      var decrypted = _encryptData.decryptData(prefs.getString("correoUsuario"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
      print("decrypted 842 : ${decrypted}");
      String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefono"),
          "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
      OrquestadorOTPModel optRespuesta = await orquestadorOTPServicio(
          context,
          decrypted,
          decryptedNumber,
          false,responsive);

      setState(() {
        _saving = false;
      });

      if (optRespuesta != null) {
        if (optRespuesta.error == "" && optRespuesta.idError == "") {
          prefs.setString("idOperacion",_encryptData.encryptInfo(optRespuesta.idOperacion, "idOperacion"));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginCodigoVerificaion(
                        responsive: responsive,
                        isNumero: false,
                      ))).then((value) {

          });
        } else {
          if(optRespuesta.idError == "015"){
            customAlert(AlertDialogType.error_codigo_verificacion, context, "", "",
                responsive, funcionAlerta);
          } else {
            customAlert(AlertDialogType.errorServicio, context, "", "",
                responsive, funcionAlerta);
          }
        }
      } else {
        customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
            funcionAlerta);
      }
    }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }
}
