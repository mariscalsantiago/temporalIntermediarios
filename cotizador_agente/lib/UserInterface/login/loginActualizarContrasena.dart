import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../main.dart';

bool isPortrait = false;
Responsive responsiveMainTablet;

class LoginActualizarContrasena extends StatefulWidget {
  final Responsive responsive;
  const LoginActualizarContrasena({Key key, this.responsive}) : super(key: key);
  @override
  _LoginActualizarContrasenaState createState() =>
      _LoginActualizarContrasenaState();
}

class _LoginActualizarContrasenaState extends State<LoginActualizarContrasena> {
  bool lentPass = false;
  bool hasMayusPass = false;
  bool hasNumPass = false;
  bool hasGNPPass = true;
  bool hasEspacePass = true;
  bool hasConsecutiveIgualesPass = false;
  bool hasConsecutivosPass = false;
  bool hasCuatroLetras = false;
  bool hasMinusculasPass = false;
  bool hasTieneEne = false;
  bool hasCaracteresEspeciales = false;
  String valorIncorrectoCaracter = "";

  //Confirmar contraseña
  bool lentPassCC = false;
  bool hasMayusPassCC = false;
  bool hasNumPassCC = false;
  bool hasGNPPassCC = true;
  bool hasEspacePassCC = true;
  bool hasConsecutiveIgualesPassCC = false;
  bool hasConsecutivosPassCC = false;
  bool hasCuatroLetrasCC = false;
  bool hasMinusculasPassCC = false;
  bool hasTieneEneCC = false;
  bool hasCaracteresEspecialesCC = false;
  String valorIncorrectoCaracterCC = "";

  TextEditingController controllerNuevaContrasena;
  FocusNode focusNuevaContrasena;
  TextEditingController controllerConfirmarContrasena;
  FocusNode focusConfirmarContrasena;
  TextEditingController controllerActualContrasena;
  FocusNode focusActualContrasena;

  RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
  RegExp cuatroLetras = RegExp('([A-Z a-z]){1,4}.*');
  RegExp reConsecutive2 = RegExp(
      '(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)'); // 123 abcd;// 123 abcd
  final _formKey = GlobalKey<FormState>();
  bool _saving;
  bool actualContrasena;
  bool nuevaContrasena;
  bool confirmarnuevaContrasena;

  String errorMessageNewPass;

  // Validation
  final _formKeyPass = GlobalKey<FormState>();
  final _formKeyNewPass = GlobalKey<FormState>();
  final _formKeyConfirmPass = GlobalKey<FormState>();
  bool _validActualPass = true;
  bool _validNewPass = true;
  bool _validConfirmPass = true;

  @override
  void initState() {

    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    _saving = false;
    actualContrasena = true;
    nuevaContrasena = true;
    confirmarnuevaContrasena = true;
    controllerNuevaContrasena = new TextEditingController();
    controllerConfirmarContrasena = new TextEditingController();
    controllerActualContrasena = new TextEditingController();
    focusActualContrasena = new FocusNode();
    focusNuevaContrasena = new FocusNode();
    focusConfirmarContrasena = new FocusNode();
    if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
      Inactivity(context:context).initialInactivity(functionInactivity);
    } else {
      controllerActualContrasena.text = prefs.getString("contrasenaUsuario");
    }

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    //print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
   keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (!visible) {
        setState(() {
        focusActualContrasena.unfocus();
        focusNuevaContrasena.unfocus();
        focusConfirmarContrasena.unfocus();
        focusContrasenaInactividad.unfocus();
       });
      }
    });

    super.initState();

    focusActualContrasena.addListener(() {
      String password = controllerActualContrasena.text.trimRight();
      String passwordReplace = password.trimLeft();
      controllerActualContrasena.text =
          passwordReplace.replaceAll(new RegExp(r"\s+"), "");

      _validActualPass = _formKeyPass.currentState.validate();
      setState(() {});
    });

    focusNuevaContrasena.addListener(() {
      String password = controllerNuevaContrasena.text.trimRight();
      String passwordReplace = password.trimLeft();
      controllerNuevaContrasena.text =
          passwordReplace.replaceAll(new RegExp(r"\s+"), "");

      setState(() {
        hasEspacePass = false;
        _validNewPass = _formKeyNewPass.currentState.validate();

        // aaaa 1111
        /*if (reConsecutive.hasMatch(controllerNuevaContrasena.text)) {
          hasConsecutiveIgualesPass = true;
        } else {
          hasConsecutiveIgualesPass = false;
        } //123 abc
        if (reConsecutive2.hasMatch(controllerNuevaContrasena.text)) {
          hasConsecutivosPass = true;
        } else {
          hasConsecutivosPass = false;
        }*/

        if (controllerNuevaContrasena.text.length < 8) {
          lentPass = false;
        } else {
          lentPass = true;
        }
      });
    });

    focusConfirmarContrasena.addListener(() {
      String password = controllerConfirmarContrasena.text.trimRight();
      String passwordReplace = password.trimLeft();
      controllerConfirmarContrasena.text =
          passwordReplace.replaceAll(new RegExp(r"\s+"), "");

      setState(() {
        hasEspacePassCC = false;
        _validConfirmPass = _formKeyConfirmPass.currentState.validate();

        if (reConsecutive.hasMatch(controllerConfirmarContrasena.text)) {
          hasConsecutiveIgualesPassCC = true;
        } else {
          hasConsecutiveIgualesPassCC = false;
        } //123 abc
        if (reConsecutive2.hasMatch(controllerConfirmarContrasena.text)) {
          hasConsecutivosPassCC = true;
        } else {
          hasConsecutivosPassCC = false;
        }

        if (controllerConfirmarContrasena.text.length < 8) {
          lentPassCC = false;
        } else {
          lentPassCC = true;
        }
      });
    });
  }

  @override
  dispose() {
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

    return  GestureDetector(onTap: (){
          setState(() {
            focusActualContrasena.unfocus();
            focusNuevaContrasena.unfocus();
            focusConfirmarContrasena.unfocus();
            focusContrasenaInactividad.unfocus();
          });
          if (prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
            Inactivity(context:context).initialInactivity(functionInactivity);
          }
      },child:SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar: _saving
              ? null
              : AppBar(
                  backgroundColor: Tema.Colors.backgroud,
                  elevation: 0,
                  title: Text(
                    'Actualizar contraseña',
                    style: TextStyle(
                        color: Tema.Colors.Azul_2,
                        fontWeight: FontWeight.normal,
                        fontSize: prefs.getBool("useMobileLayout")
                            ? widget.responsive.ip(2.5)
                            : widget.responsive.ip(2)),
                  ),
                  centerTitle: prefs.getBool("useMobileLayout") ? true : false,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: prefs.getBool("useMobileLayout")
                          ? widget.responsive.ip(2.5)
                          : widget.responsive.ip(2),
                      color: Tema.Colors.GNP,
                    ),
                    onPressed: () {
                      if (prefs.getBool("esPerfil") != null &&
                          prefs.getBool("esPerfil") &&
                          prefs.getBool("actualizarContrasenaPerfil")) {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                        Inactivity(context:context).cancelInactivity();

                      } else {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ),
          body: prefs.getBool("useMobileLayout")
              ? Stack(children: builData(widget.responsive))
              : OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    responsiveMainTablet = Responsive.of(context);
                    isPortrait = true;
                  } else {
                    responsiveMainTablet = Responsive.of(context);
                    isPortrait = false;
                  }
                  return Stack(children: builData(responsiveMainTablet));
                }),
        ),
      ),
    );
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();

    data = SingleChildScrollView(
        child: Container(
            margin: prefs.getBool("useMobileLayout")
                ? EdgeInsets.only(
                    left: responsive.wp(6), right: responsive.wp(6))
                : EdgeInsets.only(
                    left: responsive.wp(1.8), right: responsive.wp(1.8)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  separacion(responsive, 3),
                  Form(
                    key: _formKeyPass,
                    child: inputTextActualContrasena(responsive),
                  ),
                  separacion(responsive, 3),
                  cuadroDialogo(responsive),
                  separacion(responsive, 3),
                  prefs.getBool("useMobileLayout")
                      ? Container()
                      : Container(
                          height: responsive.hp(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: responsive.wp(5),
                                      left: responsive.wp(5)),
                                  child: Column(
                                    children: [
                                      inputTextNuevaContrasena(responsive),
                                      focusNuevaContrasena.hasFocus
                                          ? validacionesContrasena(responsive)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),

                              //separacion(responsive, 1),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: responsive.wp(5),
                                      left: responsive.wp(5)),
                                  child: Column(
                                    children: [
                                      inputTextConfirmarContrasena(responsive),
                                      //focusNuevaContrasena.hasFocus == true || focusConfirmarContrasena.hasFocus ? Container(): separacion(responsive, 25),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Form(
                      key: _formKeyNewPass,
                      child: Column(
                        children: <Widget>[
                          prefs.getBool("useMobileLayout")
                              ? inputTextNuevaContrasena(responsive)
                              : Container(),
                          prefs.getBool("useMobileLayout") &&
                                  focusNuevaContrasena.hasFocus
                              ? validacionesContrasena(responsive)
                              : Container(),
                          separacion(responsive, 3),
                        ],
                      )),
                  Form(
                      key: _formKeyConfirmPass,
                      child: Column(
                        children: <Widget>[
                          prefs.getBool("useMobileLayout")
                              ? inputTextConfirmarContrasena(responsive)
                              : Container(),
                          prefs.getBool("useMobileLayout") &&
                                      focusNuevaContrasena.hasFocus == true ||
                                  focusConfirmarContrasena.hasFocus
                              ? Container()
                              : separacion(responsive, 25)
                        ],
                      )),
                  enviar(responsive)
                ],
              ),
            )));

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

  Widget inputTextActualContrasena(Responsive responsive) {
    return Container(
        margin: prefs.getBool("useMobileLayout")
            ? EdgeInsets.only()
            : isPortrait
                ? EdgeInsets.only(
                    right: responsive.wp(53.2), left: responsive.wp(5))
                : EdgeInsets.only(
                    right: responsive.wp(53.2), left: responsive.wp(5)),
        child: Focus(
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(24),
            ],
            controller: controllerActualContrasena,
            focusNode: focusActualContrasena,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.visiblePassword,
            onFieldSubmitted: (S) {
              setState(() {
                focusActualContrasena.unfocus();
                focusConfirmarContrasena.unfocus();
                FocusScope.of(context).requestFocus(focusNuevaContrasena);
              });
              String password = controllerActualContrasena.text.trimRight();
              String passwordReplace = password.trimLeft();
              controllerActualContrasena.text =
                  passwordReplace.replaceAll(new RegExp(r"\s+"), "");
            },
            onTap: () {
              setState(() {
                focusNuevaContrasena.unfocus();
                focusActualContrasena.requestFocus();
                focusConfirmarContrasena.unfocus();
              });
            },
            obscureText: actualContrasena,
            cursorColor:
                _validActualPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
            decoration: new InputDecoration(
                errorStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(1.2),
                  color: Tema.Colors.validarCampo,
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Tema.Colors.validarCampo, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _validActualPass
                          ? Tema.Colors.inputlinea
                          : Tema.Colors.validarCampo),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _validActualPass
                          ? Tema.Colors.GNP
                          : Tema.Colors.validarCampo,
                      width: 2),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _validActualPass
                          ? Tema.Colors.inputlinea
                          : Tema.Colors.validarCampo,
                      width: 2),
                ),
                labelText: "Contraseña actual",
                labelStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color: _validActualPass
                      ? focusActualContrasena.hasFocus
                          ? Tema.Colors.GNP
                          : Tema.Colors.inputcorreo
                      : Tema.Colors.validarCampo,
                ),
                suffixIcon: IconButton(
                  icon: !actualContrasena
                      ? _validActualPass
                          ? Image.asset("assets/login/novercontrasena.png")
                          : Image.asset(
                              "assets/login/_icon_error_contrasena.png")
                      : _validActualPass
                          ? Image.asset("assets/login/vercontrasena.png")
                          : Image.asset("assets/login/_icono-withmask.png"),
                  color: Tema.Colors.VLMX_Navy_40,
                  onPressed: () {
                    setState(() {
                      actualContrasena = !actualContrasena;
                    });
                  },
                )),
            validator: (value) {
              print("value ${prefs.getString("contrasenaUsuario")}");

              if (value.isEmpty && !value.contains(" ")) {
                return 'Este campo es requerido';
              } else if (value != prefs.getString("contrasenaUsuario") &&
                  !value.contains(" ")) {
                return 'La contraseña actual no coincide';
              } else if (value.contains(" ")) {
                return 'No debe contener espacion en blanco';
              }
              return null;
            },
            onChanged: (value) {
              _validActualPass = _formKeyPass.currentState.validate();
              setState(() {
                try {
                  if (controllerActualContrasena.text.isNotEmpty &&
                      controllerActualContrasena.text.length >= 24) {
                    controllerActualContrasena.text =
                        controllerActualContrasena.text.substring(0, 23);
                    FocusScope.of(context).requestFocus(focusNuevaContrasena);
                  }
                } catch (e) {
                  print(e);
                }
              });
            },
          ),
          onFocusChange: (hasFocus) {},
        ));
  }

  Widget inputTextNuevaContrasena(Responsive responsive) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(24),
      ],
      controller: controllerNuevaContrasena,
      focusNode: focusNuevaContrasena,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: () {
        setState(() {
          focusNuevaContrasena.requestFocus();
          focusActualContrasena.unfocus();
          focusConfirmarContrasena.unfocus();
        });
      },
      cursorColor: _validNewPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      obscureText: nuevaContrasena,
      textInputAction: TextInputAction.none,
      onEditingComplete: () {
        setState(() {
          focusNuevaContrasena.unfocus();
        });
      },
      onFieldSubmitted: (S) {
        focusNuevaContrasena.unfocus();
        String password = controllerNuevaContrasena.text.trimRight();
        String passwordReplace = password.trimLeft();
        controllerNuevaContrasena.text =
            passwordReplace.replaceAll(new RegExp(r"\s+"), "");
        setState(() {
          hasEspacePass = false;

          // aaaa 1111
          if (reConsecutive.hasMatch(controllerNuevaContrasena.text)) {
            hasConsecutiveIgualesPass = true;
          } else {
            hasConsecutiveIgualesPass = false;
          } //123 abc
          if (reConsecutive2.hasMatch(controllerNuevaContrasena.text)) {
            hasConsecutivosPass = true;
          } else {
            hasConsecutivosPass = false;
          }

          if (controllerNuevaContrasena.text.length < 8) {
            lentPass = false;
          } else {
            lentPass = true;
          }
        });
      },
      decoration: new InputDecoration(
          labelText: "Nueva contraseña",
          labelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.normal,
            fontSize: responsive.ip(2),
            color: _validNewPass
                ? focusNuevaContrasena.hasFocus
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
                color: _validNewPass
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color:
                    _validNewPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
                width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validNewPass
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          suffixIcon: IconButton(
            icon: !nuevaContrasena
                ? _validNewPass
                    ? Image.asset("assets/login/novercontrasena.png")
                    : Image.asset("assets/login/_icon_error_contrasena.png")
                : _validNewPass
                    ? Image.asset("assets/login/vercontrasena.png")
                    : Image.asset("assets/login/_icono-withmask.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: () {
              setState(() {
                nuevaContrasena = !nuevaContrasena;
                confirmarnuevaContrasena = !confirmarnuevaContrasena;
              });
            },
          )),
      validator: (value) {
        if (value.isEmpty && !focusNuevaContrasena.hasFocus) {
          return 'Este campo es requerido';
        }
        if (hasEspacePass && !focusNuevaContrasena.hasFocus) {
          return 'No debe tener espacios en blanco';
        }
        if (!hasCuatroLetras && !focusNuevaContrasena.hasFocus) {
          return 'Debe tener 4 letras y al menos 8 caracteres';
        }
        if (!lentPass && !focusNuevaContrasena.hasFocus) {
          return 'Debe ser de al menos 8 caracteres';
        }
        if ((!hasMayusPass || !hasMinusculasPass) &&
            !focusNuevaContrasena.hasFocus) {
          return 'Debe tener al menos una minúscula y una mayúscula';
        }
        if (!hasNumPass && !focusNuevaContrasena.hasFocus) {
          return 'Debe contener al menos un número';
        }
        if (hasTieneEne && !focusNuevaContrasena.hasFocus) {
          return 'No debe de contener la letra "Ñ" o "ñ"';
        }
        if (hasGNPPass && !focusNuevaContrasena.hasFocus) {
          return 'No debe contener la palabra GNP';
        }
        if (hasConsecutiveIgualesPass &&
            !focusNuevaContrasena.hasFocus &&
            !hasEspacePass) {
          return 'No debe contener más de dos caracteres consecutivos\n iguales (p.e. 222, eee)';
        }
        if (hasConsecutivosPass && !focusNuevaContrasena.hasFocus) {
          return 'No debe contener más de dos caracteres consecutivos\n (p.e. 123, abc)';
        }
        if (!hasCaracteresEspeciales && !focusNuevaContrasena.hasFocus) {
          return 'El caracter ${valorIncorrectoCaracter} no está permitido';
        }
        return null;
      },
      onChanged: (value) {

        setState(() {
          controllerNuevaContrasena.text;
          _validNewPass = _formKeyNewPass.currentState.validate();
          if (controllerNuevaContrasena.text ==
              controllerConfirmarContrasena.text) {
            _validConfirmPass = true;
          }
          if (value.length < 8) {
            lentPass = false;
          } else {
            lentPass = true;
          }
          if (value.contains("A") ||
              value.contains("B") ||
              value.contains("C") ||
              value.contains("D") ||
              value.contains("E") ||
              value.contains("F") ||
              value.contains("G") ||
              value.contains("H") ||
              value.contains("I") ||
              value.contains("J") ||
              value.contains("K") ||
              value.contains("L") ||
              value.contains("M") ||
              value.contains("N") ||
              value.contains("O") ||
              value.contains("P") ||
              value.contains("Q") ||
              value.contains("R") ||
              value.contains("S") ||
              value.contains("T") ||
              value.contains("U") ||
              value.contains("V") ||
              value.contains("W") ||
              value.contains("X") ||
              value.contains("Y") ||
              value.contains("Z")) {
            hasMayusPass = true;
          } else {
            hasMayusPass = false;
          }
          if (value.contains("a") ||
              value.contains("b") ||
              value.contains("c") ||
              value.contains("d") ||
              value.contains("e") ||
              value.contains("f") ||
              value.contains("g") ||
              value.contains("h") ||
              value.contains("i") ||
              value.contains("j") ||
              value.contains("k") ||
              value.contains("l") ||
              value.contains("m") ||
              value.contains("n") ||
              value.contains("o") ||
              value.contains("p") ||
              value.contains("q") ||
              value.contains("r") ||
              value.contains("s") ||
              value.contains("t") ||
              value.contains("u") ||
              value.contains("v") ||
              value.contains("w") ||
              value.contains("x") ||
              value.contains("y") ||
              value.contains("z")) {
            hasMinusculasPass = true;
          } else {
            hasMinusculasPass = false;
          }
          if (value.contains("1") ||
              value.contains("2") ||
              value.contains("3") ||
              value.contains("4") ||
              value.contains("5") ||
              value.contains("6") ||
              value.contains("7") ||
              value.contains("8") ||
              value.contains("9") ||
              value.contains("0")) {
            hasNumPass = true;
          } else {
            hasNumPass = false;
          }
          if (value.contains("GNP") ||
              value.contains("Gnp") ||
              value.contains("gnp") ||
              value.contains("GNp") ||
              value.contains("gNp") ||
              value.contains("gnP") ||
              value.contains("GnP") ||
              value.contains("gNP")) {
            hasGNPPass = true;
          } else {
            hasGNPPass = false;
          }
          if (value.contains(" ")) {
            hasEspacePass = true;
          } else {
            hasEspacePass = false;
          }
          // aaaa 1111
          if (reConsecutive.hasMatch(value.toLowerCase())) {
            print("reConsecutive3");
            Iterable<RegExpMatch> machList = reConsecutive
                .allMatches(controllerNuevaContrasena.text.toLowerCase());
            print("machList ${machList.first.input}");
            print("machList ${machList.length}");
            for (int i = 0; i < machList.length; i++) {
              print("match3 ${machList.elementAt(i).group(i)}");
              if (!machList.elementAt(i).group(i).contains(" ")) {
                hasConsecutiveIgualesPass = true;
              }
            }
          } else {
            hasConsecutiveIgualesPass = false;
          }
          //123 abc
          if (reConsecutive2.hasMatch(value.toLowerCase())) {
            hasConsecutivosPass = true;
          } else {
            hasConsecutivosPass = false;
          }

          int contador = 0;

          for (int i = 0; i < value.length; i++) {
            if (value[i].contains("a") ||
                value[i].contains("b") ||
                value[i].contains("c") ||
                value[i].contains("d") ||
                value[i].contains("e") ||
                value[i].contains("f") ||
                value[i].contains("g") ||
                value[i].contains("h") ||
                value[i].contains("i") ||
                value[i].contains("j") ||
                value[i].contains("k") ||
                value[i].contains("l") ||
                value[i].contains("m") ||
                value[i].contains("n") ||
                value[i].contains("o") ||
                value[i].contains("p") ||
                value[i].contains("q") ||
                value[i].contains("r") ||
                value[i].contains("s") ||
                value[i].contains("t") ||
                value[i].contains("u") ||
                value[i].contains("v") ||
                value[i].contains("w") ||
                value[i].contains("x") ||
                value[i].contains("y") ||
                value[i].contains("z")) {
              contador = contador + 1;
            } else if (value[i].contains("A") ||
                value[i].contains("B") ||
                value[i].contains("C") ||
                value[i].contains("D") ||
                value[i].contains("E") ||
                value[i].contains("F") ||
                value[i].contains("G") ||
                value[i].contains("H") ||
                value[i].contains("I") ||
                value[i].contains("J") ||
                value[i].contains("K") ||
                value[i].contains("L") ||
                value[i].contains("M") ||
                value[i].contains("N") ||
                value[i].contains("O") ||
                value[i].contains("P") ||
                value[i].contains("Q") ||
                value[i].contains("R") ||
                value[i].contains("S") ||
                value[i].contains("T") ||
                value[i].contains("U") ||
                value[i].contains("V") ||
                value[i].contains("W") ||
                value[i].contains("X") ||
                value[i].contains("Y") ||
                value[i].contains("Z")) {
              contador = contador + 1;
            }
          }

          if (contador >= 4) {
            hasCuatroLetras = true;
          } else {
            hasCuatroLetras = false;
          }

          if (value.contains("Ñ") || value.contains("ñ")) {
            hasTieneEne = true;
          } else {
            hasTieneEne = false;
          }

          print("Nc Contiene caracter ${value}");
          valorIncorrectoCaracter = "";
          for (int i = 0; i < value.length; i++) {
            if (!value[i].contains("@") &&
                !value[i].contains("_") &&
                !value[i].contains("-") &&
                !value[i].contains(":") &&
                !value[i].contains(".") &&
                !value[i].contains(";") &&
                !value[i].contains(",") &&
                !value[i].contains("<") &&
                !value[i].contains(">") &&
                !value[i].contains("{") &&
                !value[i].contains("}") &&
                !value[i].contains("*") &&
                !value[i].contains("+") &&
                !value[i].contains('?') &&
                !value[i].contains("=") &&
                !value[i].contains("(") &&
                !value[i].contains(")") &&
                !value[i].contains("/") &&
                !value[i].contains("&") &&
                !value[i].contains("%") &&
                !value[i].contains("\$") &&
                !value[i].contains("#") &&
                !value[i].contains("\\") &&
                !value[i].contains("!") &&
                !value[i].contains("|") &&
                !value[i].contains("a") &&
                !value[i].contains("b") &&
                !value[i].contains("c") &&
                !value[i].contains("d") &&
                !value[i].contains("e") &&
                !value[i].contains("f") &&
                !value[i].contains("g") &&
                !value[i].contains("h") &&
                !value[i].contains("i") &&
                !value[i].contains("j") &&
                !value[i].contains("k") &&
                !value[i].contains("l") &&
                !value[i].contains("m") &&
                !value[i].contains("n") &&
                !value[i].contains("o") &&
                !value[i].contains("p") &&
                !value[i].contains("q") &&
                !value[i].contains("r") &&
                !value[i].contains("s") &&
                !value[i].contains("t") &&
                !value[i].contains("u") &&
                !value[i].contains("v") &&
                !value[i].contains("w") &&
                !value[i].contains("x") &&
                !value[i].contains("y") &&
                !value[i].contains("z") &&
                !value[i].contains("1") &&
                !value[i].contains("2") &&
                !value[i].contains("3") &&
                !value[i].contains("4") &&
                !value[i].contains("5") &&
                !value[i].contains("6") &&
                !value[i].contains("7") &&
                !value[i].contains("8") &&
                !value[i].contains("9") &&
                !value[i].contains("0") &&
                !value[i].contains("A") &&
                !value[i].contains("B") &&
                !value[i].contains("C") &&
                !value[i].contains("D") &&
                !value[i].contains("E") &&
                !value[i].contains("F") &&
                !value[i].contains("G") &&
                !value[i].contains("H") &&
                !value[i].contains("I") &&
                !value[i].contains("J") &&
                !value[i].contains("K") &&
                !value[i].contains("L") &&
                !value[i].contains("M") &&
                !value[i].contains("N") &&
                !value[i].contains("O") &&
                !value[i].contains("P") &&
                !value[i].contains("Q") &&
                !value[i].contains("R") &&
                !value[i].contains("S") &&
                !value[i].contains("T") &&
                !value[i].contains("U") &&
                !value[i].contains("V") &&
                !value[i].contains("W") &&
                !value[i].contains("X") &&
                !value[i].contains("Y") &&
                !value[i].contains("Z") &&
                !value[i].contains("Ñ") &&
                !value[i].contains("ñ") &&
                !value[i].contains(" ")) {
              valorIncorrectoCaracter = value[i];
              print("valorIncorrectoCaracter ${valorIncorrectoCaracter}");
            }
          }
          if (valorIncorrectoCaracter != "") {
            hasCaracteresEspeciales = false;
          } else {
            hasCaracteresEspeciales = true;
          }

          try {
            if (controllerNuevaContrasena.text.isNotEmpty &&
                controllerNuevaContrasena.text.length >= 24) {
              controllerNuevaContrasena.text =
                  controllerNuevaContrasena.text.substring(0, 23);
              FocusScope.of(context).requestFocus(focusConfirmarContrasena);
            }
          } catch (e) {
            print(e);
          }
        });
      },
    );
  }

  Widget inputTextConfirmarContrasena(Responsive responsive) {
    return TextFormField(
      initialValue: null, //Se agregó valor inicial nulo
      enableSuggestions: false, //Se agregó esta línea
      inputFormatters: [
        LengthLimitingTextInputFormatter(24),
      ],
      controller: controllerConfirmarContrasena,
      keyboardType: TextInputType.visiblePassword,
      focusNode: focusConfirmarContrasena,
      onTap: () {
        setState(() {
          focusNuevaContrasena.unfocus();
          focusActualContrasena.unfocus();
          focusConfirmarContrasena.requestFocus();
        });
      },
      onFieldSubmitted: (s) {
        String password = controllerConfirmarContrasena.text.trimRight();
        String passwordReplace = password.trimLeft();
        controllerConfirmarContrasena.text =
            passwordReplace.replaceAll(new RegExp(r"\s+"), "");
        setState(() {
          hasEspacePassCC = false;
          if (reConsecutive.hasMatch(controllerConfirmarContrasena.text)) {
            hasConsecutiveIgualesPassCC = true;
          } else {
            hasConsecutiveIgualesPassCC = false;
          } //123 abc
          if (reConsecutive2.hasMatch(controllerConfirmarContrasena.text)) {
            hasConsecutivosPassCC = true;
          } else {
            hasConsecutivosPassCC = false;
          }

          if (controllerConfirmarContrasena.text.length < 8) {
            lentPassCC = false;
          } else {
            lentPassCC = true;
          }
        });
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: confirmarnuevaContrasena,

      cursorColor:
          _validConfirmPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      decoration: new InputDecoration(
          labelText: "Confirmar nueva contraseña",
          labelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.normal,
            fontSize: responsive.ip(2),
            color: _validConfirmPass
                ? focusConfirmarContrasena.hasFocus
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
                color: _validConfirmPass
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validConfirmPass
                    ? Tema.Colors.GNP
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _validConfirmPass
                    ? Tema.Colors.inputlinea
                    : Tema.Colors.validarCampo,
                width: 2),
          ),
          suffixIcon: IconButton(
            icon: !confirmarnuevaContrasena
                ? _validConfirmPass
                    ? Image.asset("assets/login/novercontrasena.png")
                    : Image.asset("assets/login/_icon_error_contrasena.png")
                : _validConfirmPass
                    ? Image.asset("assets/login/vercontrasena.png")
                    : Image.asset("assets/login/_icono-withmask.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: () {
              setState(() {
                nuevaContrasena = !nuevaContrasena;
                confirmarnuevaContrasena = !confirmarnuevaContrasena;
              });
            },
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        /*if (hasEspacePassCC) {
          return 'No debe tener espacios en blanco';
        }
        if (!hasCuatroLetrasCC) {
          return 'Debe tener 4 letras y al menos 8 caracteres';
        }
        if (!lentPassCC) {
          return 'Debe ser de al menos 8 caracteres';
        }

        if (!hasMayusPassCC || !hasMinusculasPassCC) {
          print("hasMinusculasPassCC ${hasMinusculasPassCC}");
          return 'Debe tener al menos una minúscula y una mayúscula';
        }
        if (!hasNumPassCC) {
          return 'Debe contener al menos un número';
        }
        if (hasTieneEneCC) {
          return 'No debe de contener la letra "Ñ" o "ñ"';
        }
        if (hasGNPPassCC) {
          return 'No debe contener la palabra GNP';
        }
        if (hasConsecutiveIgualesPassCC) {
          return 'No debe contener más de dos caracteres consecutivos iguales (p.e. 222, eee)';
        }
        if (hasConsecutivosPassCC) {
          return 'No debe contener más de dos caracteres consecutivos (p.e. 123, abc)';
        }
        if (!hasCaracteresEspecialesCC) {
          return 'El caracter ${valorIncorrectoCaracterCC} no está permitido';
        }*/
        if (value != controllerNuevaContrasena.text) {
          return 'La contraseña no coincide';
        }

        return null;
      },
      onChanged: (value) {
        setState(() {
          _validConfirmPass = _formKeyConfirmPass.currentState.validate();
          print(value);
          controllerConfirmarContrasena.text;
          if (value.length < 8) {
            lentPassCC = false;
          } else {
            lentPassCC = true;
          }
          if (value.contains("A") ||
              value.contains("B") ||
              value.contains("C") ||
              value.contains("D") ||
              value.contains("E") ||
              value.contains("F") ||
              value.contains("G") ||
              value.contains("H") ||
              value.contains("I") ||
              value.contains("J") ||
              value.contains("K") ||
              value.contains("L") ||
              value.contains("M") ||
              value.contains("N") ||
              value.contains("O") ||
              value.contains("P") ||
              value.contains("Q") ||
              value.contains("R") ||
              value.contains("S") ||
              value.contains("T") ||
              value.contains("U") ||
              value.contains("V") ||
              value.contains("W") ||
              value.contains("X") ||
              value.contains("Y") ||
              value.contains("Z")) {
            hasMayusPassCC = true;
          } else {
            hasMayusPassCC = false;
          }
          if (value.contains("a") ||
              value.contains("b") ||
              value.contains("c") ||
              value.contains("d") ||
              value.contains("e") ||
              value.contains("f") ||
              value.contains("g") ||
              value.contains("h") ||
              value.contains("i") ||
              value.contains("j") ||
              value.contains("k") ||
              value.contains("l") ||
              value.contains("m") ||
              value.contains("n") ||
              value.contains("o") ||
              value.contains("p") ||
              value.contains("q") ||
              value.contains("r") ||
              value.contains("s") ||
              value.contains("t") ||
              value.contains("u") ||
              value.contains("v") ||
              value.contains("w") ||
              value.contains("x") ||
              value.contains("y") ||
              value.contains("z")) {
            hasMinusculasPassCC = true;
          } else {
            hasMinusculasPassCC = false;
          }
          if (value.contains("1") ||
              value.contains("2") ||
              value.contains("3") ||
              value.contains("4") ||
              value.contains("5") ||
              value.contains("6") ||
              value.contains("7") ||
              value.contains("8") ||
              value.contains("9") ||
              value.contains("0")) {
            hasNumPassCC = true;
          } else {
            hasNumPassCC = false;
          }
          if (value.contains("GNP") ||
              value.contains("Gnp") ||
              value.contains("gnp") ||
              value.contains("GNp") ||
              value.contains("gNp") ||
              value.contains("gnP") ||
              value.contains("GnP") ||
              value.contains("gNP")) {
            hasGNPPassCC = true;
          } else {
            hasGNPPassCC = false;
          }
          if (value.contains(" ")) {
            hasEspacePassCC = true;
          } else {
            hasEspacePassCC = false;
          }
          // aaaa 1111
          if (reConsecutive.hasMatch(value)) {
            hasConsecutiveIgualesPassCC = true;
          } else {
            hasConsecutiveIgualesPassCC = false;
          } //123 abc
          if (reConsecutive2.hasMatch(value)) {
            hasConsecutivosPassCC = true;
          } else {
            hasConsecutivosPassCC = false;
          }

          int contador = 0;
          for (int i = 0; i < value.length; i++) {
            if (value[i].contains("a") ||
                value[i].contains("b") ||
                value[i].contains("c") ||
                value[i].contains("d") ||
                value[i].contains("e") ||
                value[i].contains("f") ||
                value[i].contains("g") ||
                value[i].contains("h") ||
                value[i].contains("i") ||
                value[i].contains("j") ||
                value[i].contains("k") ||
                value[i].contains("l") ||
                value[i].contains("m") ||
                value[i].contains("n") ||
                value[i].contains("o") ||
                value[i].contains("p") ||
                value[i].contains("q") ||
                value[i].contains("r") ||
                value[i].contains("s") ||
                value[i].contains("t") ||
                value[i].contains("u") ||
                value[i].contains("v") ||
                value[i].contains("w") ||
                value[i].contains("x") ||
                value[i].contains("y") ||
                value[i].contains("z")) {
              contador = contador + 1;
            } else if (value[i].contains("A") ||
                value[i].contains("B") ||
                value[i].contains("C") ||
                value[i].contains("D") ||
                value[i].contains("E") ||
                value[i].contains("F") ||
                value[i].contains("G") ||
                value[i].contains("H") ||
                value[i].contains("I") ||
                value[i].contains("J") ||
                value[i].contains("K") ||
                value[i].contains("L") ||
                value[i].contains("M") ||
                value[i].contains("N") ||
                value[i].contains("O") ||
                value[i].contains("P") ||
                value[i].contains("Q") ||
                value[i].contains("R") ||
                value[i].contains("S") ||
                value[i].contains("T") ||
                value[i].contains("U") ||
                value[i].contains("V") ||
                value[i].contains("W") ||
                value[i].contains("X") ||
                value[i].contains("Y") ||
                value[i].contains("Z")) {
              contador = contador + 1;
            }
          }

          if (contador >= 4) {
            hasCuatroLetrasCC = true;
          } else {
            hasCuatroLetrasCC = false;
          }

          if (value.contains("Ñ") || value.contains("ñ")) {
            hasTieneEneCC = true;
          } else {
            hasTieneEneCC = false;
          }

          print("Nc Contiene caracter ${value}");
          valorIncorrectoCaracterCC = "";
          for (int i = 0; i < value.length; i++) {
            if (!value[i].contains("@") &&
                !value[i].contains("_") &&
                !value[i].contains("-") &&
                !value[i].contains(":") &&
                !value[i].contains(".") &&
                !value[i].contains(";") &&
                !value[i].contains(",") &&
                !value[i].contains("<") &&
                !value[i].contains(">") &&
                !value[i].contains("{") &&
                !value[i].contains("}") &&
                !value[i].contains("*") &&
                !value[i].contains("+") &&
                !value[i].contains('?') &&
                !value[i].contains("=") &&
                !value[i].contains("(") &&
                !value[i].contains(")") &&
                !value[i].contains("/") &&
                !value[i].contains("&") &&
                !value[i].contains("%") &&
                !value[i].contains("\$") &&
                !value[i].contains("#") &&
                !value[i].contains("\\") &&
                !value[i].contains("!") &&
                !value[i].contains("|") &&
                !value[i].contains("a") &&
                !value[i].contains("b") &&
                !value[i].contains("c") &&
                !value[i].contains("d") &&
                !value[i].contains("e") &&
                !value[i].contains("f") &&
                !value[i].contains("g") &&
                !value[i].contains("h") &&
                !value[i].contains("i") &&
                !value[i].contains("j") &&
                !value[i].contains("k") &&
                !value[i].contains("l") &&
                !value[i].contains("m") &&
                !value[i].contains("n") &&
                !value[i].contains("o") &&
                !value[i].contains("p") &&
                !value[i].contains("q") &&
                !value[i].contains("r") &&
                !value[i].contains("s") &&
                !value[i].contains("t") &&
                !value[i].contains("u") &&
                !value[i].contains("v") &&
                !value[i].contains("w") &&
                !value[i].contains("x") &&
                !value[i].contains("y") &&
                !value[i].contains("z") &&
                !value[i].contains("1") &&
                !value[i].contains("2") &&
                !value[i].contains("3") &&
                !value[i].contains("4") &&
                !value[i].contains("5") &&
                !value[i].contains("6") &&
                !value[i].contains("7") &&
                !value[i].contains("8") &&
                !value[i].contains("9") &&
                !value[i].contains("0") &&
                !value[i].contains("A") &&
                !value[i].contains("B") &&
                !value[i].contains("C") &&
                !value[i].contains("D") &&
                !value[i].contains("E") &&
                !value[i].contains("F") &&
                !value[i].contains("G") &&
                !value[i].contains("H") &&
                !value[i].contains("I") &&
                !value[i].contains("J") &&
                !value[i].contains("K") &&
                !value[i].contains("L") &&
                !value[i].contains("M") &&
                !value[i].contains("N") &&
                !value[i].contains("O") &&
                !value[i].contains("P") &&
                !value[i].contains("Q") &&
                !value[i].contains("R") &&
                !value[i].contains("S") &&
                !value[i].contains("T") &&
                !value[i].contains("U") &&
                !value[i].contains("V") &&
                !value[i].contains("W") &&
                !value[i].contains("X") &&
                !value[i].contains("Y") &&
                !value[i].contains("Z") &&
                !value[i].contains("Ñ") &&
                !value[i].contains("ñ") &&
                !value[i].contains(" ")) {
              valorIncorrectoCaracterCC = value[i];
              print("valorIncorrectoCaracter ${valorIncorrectoCaracterCC}");
            }
          }
          if (valorIncorrectoCaracterCC != "") {
            hasCaracteresEspecialesCC = false;
          } else {
            hasCaracteresEspecialesCC = true;
          }

          try {
            if (controllerConfirmarContrasena.text.isNotEmpty &&
                controllerConfirmarContrasena.text.length >= 24) {
              controllerConfirmarContrasena.text =
                  controllerConfirmarContrasena.text.substring(0, 23);
              focusConfirmarContrasena.unfocus();
            }
          } catch (e) {
            print(e);
          }
        });
      },
    );
  }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  Widget validacionesContrasena(Responsive responsive) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.hp(3),
          horizontal: responsive.wp(2),
        ),
        child: Column(
          children: <Widget>[
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                hasCuatroLetras
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color:
                                    hasCuatroLetras ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "Debe tener 4 letras y al menos 8 caracteres.",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: hasCuatroLetras ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "Debe tener 4 letras y al menos 8 caracteres.",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                lentPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: lentPass ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "Debe de ser al menos de 8 caracteres.",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: lentPass ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "Debe de ser al menos de 8 caracteres.",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                hasMayusPass && hasMinusculasPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: hasMayusPass && hasMinusculasPass
                                    ? Colors.green
                                    : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "Debe tener al menos una minúscula y una mayúscula.",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: hasMayusPass && hasMinusculasPass
                                ? Colors.green
                                : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "Debe tener al menos una minúscula y una mayúscula.",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                hasNumPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: hasNumPass ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "Debe de contener al menos un número.",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: hasNumPass ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "Debe de contener al menos un número.",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                !hasTieneEne
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: !hasTieneEne ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          'No debe tener la letra "Ñ" o "ñ".',
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: !hasTieneEne ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          'No debe tener la letra "Ñ" o "ñ".',
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                !hasGNPPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: !hasGNPPass ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "No debe de contener GNP.",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: !hasGNPPass ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "No debe de contener GNP.",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            //hasConsecutiveIgualesPass
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                !hasConsecutiveIgualesPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: !hasConsecutiveIgualesPass
                                    ? Colors.green
                                    : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "No debe contener más de dos caracteres consecutivos iguales (p.e. 222, eee).",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: !hasConsecutiveIgualesPass
                                ? Colors.green
                                : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "No debe contener más de dos caracteres consecutivos iguales (p.e. 222, eee).",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),

            //hasConsecutivosPass
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                !hasConsecutivosPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: !hasConsecutivosPass
                                    ? Colors.green
                                    : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          "No debe contener más de dos caracteres consecutivos (p.e. 123, abc).",
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: !hasConsecutivosPass
                                ? Colors.green
                                : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          "No debe contener más de dos caracteres consecutivos (p.e. 123, abc).",
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),

            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                hasCaracteresEspeciales
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: hasCaracteresEspeciales
                                    ? Colors.green
                                    : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          'Puede tener algún caracter especial: [ @ _ - : . ; , < > { } * + ? = ( ) / & % \$ # " ! | ].',
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: hasCaracteresEspeciales
                                ? Colors.green
                                : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          'Puede tener algún caracter especial: [ @ _ - : . ; , < > { } * + ? = ( ) / & % \$ # " ! | ].',
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
            controllerNuevaContrasena.text != "" ||
                    controllerConfirmarContrasena.text != ""
                ? Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                !hasEspacePass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color:
                                    !hasEspacePass ? Colors.green : Colors.red,
                                width: responsive.wp(2.3),
                                height: responsive.hp(2.3))),
                        Expanded(
                            child: Text(
                          'No debe tener espacios en blanco.',
                          style: TextStyle(
                            fontSize: prefs.getBool("useMobileLayout")
                                ? responsive.ip(1.8)
                                : responsive.ip(1),
                            color: !hasEspacePass ? Colors.green : Colors.red,
                          ),
                        ))
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(right: responsive.width * 0.02),
                            child: Image.asset(
                                "assets/login/radioContrasena.png",
                                color: Tema.Colors.togglegris,
                                width: 22,
                                height: 22)),
                        Expanded(
                            child: Text(
                          'No debe tener espacios en blanco',
                          style: TextStyle(
                              fontSize: prefs.getBool("useMobileLayout")
                                  ? responsive.ip(1.8)
                                  : responsive.ip(1),
                              color: Tema.Colors.letragris),
                        ))
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget enviar(Responsive responsive) {
    return Container(
      margin: prefs.getBool("useMobileLayout")
          ? EdgeInsets.only(top: responsive.hp(9))
          : EdgeInsets.only(),
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: controllerActualContrasena.text != "" &&
                      controllerNuevaContrasena.text != "" &&
                      controllerConfirmarContrasena.text != ""
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
                    color: controllerActualContrasena.text != "" &&
                            controllerNuevaContrasena.text != "" &&
                            controllerConfirmarContrasena.text != ""
                        ? Tema.Colors.backgroud
                        : Tema.Colors.botonletra,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {

            focusActualContrasena.unfocus();
            focusNuevaContrasena.unfocus();
            focusConfirmarContrasena.unfocus();
            if (_formKeyPass.currentState.validate() &&
                _formKeyNewPass.currentState.validate() &&
                _formKeyConfirmPass.currentState.validate()) {
              if ((controllerActualContrasena.text ==
                      controllerNuevaContrasena.text) &&
                  (controllerActualContrasena.text ==
                      controllerConfirmarContrasena.text)) {
                customAlert(
                    AlertDialogType
                        .Contrasena_invalida_debeserdiferente_a_la_actual,
                    context,
                    "",
                    "",
                    responsive,
                    funcionAlerta);
              } else {
                setState(() {
                  _saving = true;
                });
                cambioContrasenaModel cambiocontrasena =
                    await cambioContrasenaServicio(
                        context,
                        controllerActualContrasena.text,
                        controllerNuevaContrasena.text,
                        datosUsuario.idparticipante,responsive);

                if (cambiocontrasena != null) {
                  setState(() {
                    _saving = false;
                  });
                  if (cambiocontrasena.requestStatus == "FAILED" &&
                      cambiocontrasena.error != "") {
                    customAlert(
                        AlertDialogType.Contrasena_diferente_a_las_3_anteriores,
                        context,
                        "",
                        "",
                        responsive,
                        funcionAlerta);
                  } else if (cambiocontrasena.error == "") {
                    prefs.setString(
                        "contrasenaUsuario", controllerNuevaContrasena.text);
                    prefs.setString(
                        "contraenaActualizada", controllerNuevaContrasena.text);
                    customAlert(
                        AlertDialogType.contrasena_actualiza_correctamente,
                        context,
                        "",
                        "",
                        responsive,
                        funcionAlerta);
                  }
                } else {
                  setState(() {
                    _saving = false;
                  });
                }
              }
            }
          }),
    );
  }

  Widget cuadroDialogo(Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: responsive.hp(2), horizontal: responsive.wp(4)),
      color: Tema.Colors.rellenodialogo,
      child: Text(
        "Tu nueva contraseña debe ser diferente a las 3 contraseñas anteriores.",
        style: TextStyle(
            color: Tema.Colors.Azul_2,
            fontWeight: FontWeight.normal,
            fontSize: prefs.getBool("useMobileLayout")
                ? responsive.ip(2)
                : responsive.ip(1.3)),
      ),
    );
  }

  void funcionAlerta() {}

  void CallbackInactividad() {
    setState(() {
      print("CallbackInactividad Actualizar contraseñ");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
