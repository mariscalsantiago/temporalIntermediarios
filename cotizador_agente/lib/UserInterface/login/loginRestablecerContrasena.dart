import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginRestablecerContrasena extends StatefulWidget {
  final Responsive responsive;
  const LoginRestablecerContrasena({Key key, this.responsive})
      : super(key: key);
  @override
  _LoginRestablecerContrasenaState createState() =>
      _LoginRestablecerContrasenaState();
}

class _LoginRestablecerContrasenaState
    extends State<LoginRestablecerContrasena> {
  bool machPass = false;
  bool validPass = false;
  bool lentPass = false;
  bool hasMayusPass = false;
  bool hasNumPass = false;
  bool hasGNPPass = true;
  bool hasEspacePass = true;
  bool hasConsecutiveIgualesPass = false;
  bool hasConsecutivosPass = false;
  bool hasMinusculaPass = false;
  bool hasCuatroLetras = false;
  bool hasTieneEne = false;
  bool hasCaracteresEspeciales = false;
  String valorIncorrectoCaracter = "";

  bool machPassCC = false;
  bool validPassCC = false;
  bool lentPassCC = false;
  bool hasMayusPassCC = false;
  bool hasNumPassCC = false;
  bool hasGNPPassCC = true;
  bool hasEspacePassCC = true;
  bool hasConsecutiveIgualesPassCC = false;
  bool hasConsecutivosPassCC = false;
  bool hasMinusculaPassCC = false;
  bool hasCuatroLetrasCC = false;
  bool hasTieneEneCC = false;
  bool hasCaracteresEspecialesCC = false;
  String valorIncorrectoCaracterCC = "";

  bool _saving;
  bool nuevaContrasena;
  bool confirmarnuevaContrasena;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNuevaContrasena;
  FocusNode focusNuevaContrasena;
  TextEditingController controllerConfirmarContrasena;
  FocusNode focusConfirmarContrasena;
  bool _validActualPass = true;

  RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
  RegExp reConsecutive2 = RegExp(
      '(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)'); // 123 abcd
  //abcdefghijklmnñopqrstuvwxyz

  // Validation
  final _formKeyNewPass = GlobalKey<FormState>();
  final _formKeyConfirmPass = GlobalKey<FormState>();
  bool _validNewPass = true;
  bool _validConfirmPass = true;

  @override
  void initState() {

    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    _saving = false;
    nuevaContrasena = true;
    confirmarnuevaContrasena = true;
    controllerNuevaContrasena = new TextEditingController();
    controllerConfirmarContrasena = new TextEditingController();
    focusNuevaContrasena = new FocusNode();
    focusConfirmarContrasena = new FocusNode();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    //print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (!visible) {
        focusNuevaContrasena.unfocus();
        focusConfirmarContrasena.unfocus();
        focusContrasenaInactividad.unfocus();
      }
    });
    super.initState();

    focusNuevaContrasena.addListener(() {
      String password = controllerNuevaContrasena.text.trimRight();
      String passwordReplace = password.trimLeft();
      controllerNuevaContrasena.text =
          passwordReplace.replaceAll(new RegExp(r"\s+"), "");

      setState(() {
        hasEspacePass = false;
        _validNewPass = _formKeyNewPass.currentState.validate();

        // aaaa 1111
        if (reConsecutive
            .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
          Iterable<RegExpMatch> machList = reConsecutive
              .allMatches(controllerNuevaContrasena.text.toLowerCase());
          for (int i = 0; i < machList.length; i++) {
            if (!machList.elementAt(i).group(i).contains(" ")) {
              hasConsecutiveIgualesPass = true;
            }
          }
        } else {
          hasConsecutiveIgualesPass = false;
        }
        if (reConsecutive2
            .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
          hasConsecutivosPass = true;
        } else {
          hasConsecutivosPass = false;
        }
        print(
            "Consecutivo: ${reConsecutive2.hasMatch(controllerNuevaContrasena.text.toLowerCase())}");

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

        // aaaa 1111
        /*if (reConsecutive.hasMatch(controllerConfirmarContrasena.text)) {
          hasConsecutiveIgualesPassCC = true;
        } else {
          hasConsecutiveIgualesPassCC = false;
        } //123 abc
        if (reConsecutive2.hasMatch(controllerConfirmarContrasena.text)) {
          hasConsecutivosPassCC = true;
        } else {
          hasConsecutivosPassCC = false;
        }*/

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

  void functionConnectivity() {
    setState(() {});
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
                      'Restablecer contraseña',
                      style: TextStyle(
                          color: Tema.Colors.Azul_2,
                          fontWeight: FontWeight.normal,
                          fontSize: widget.responsive.ip(2.5)),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Tema.Colors.GNP,
                      ),
                      onPressed: () {
                        print("flujoOlvideContrasena");
                        if (prefs.getBool('flujoOlvideContrasena') != null &&
                            prefs.getBool('flujoOlvideContrasena')) {
                          print("if flujoOlvideContrasena");
                          Navigator.pop(context, true);
                          //Navigator.pop(context, true);
                        } else {
                          print("else flujoOlvideContrasena");
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
            body: Stack(children: builData(widget.responsive))),
    );
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();
    Form form;

    data = SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(
                left: responsive.wp(6), right: responsive.wp(6)),
            child: form = new Form(
              key: _formKey,
              child: Column(
                children: [
                  separacion(responsive, 3),
                  cuadroDialogo(responsive),
                  separacion(responsive, 3),
                  Form(
                      key: _formKeyNewPass,
                      child: Column(
                        children: <Widget>[
                          inputTextNuevaContrasena(responsive),
                          focusNuevaContrasena.hasFocus
                              ? validacionesContrasena(responsive)
                              : Container(),
                        ],
                      )),
                  separacion(responsive, 3),
                  Form(
                      key: _formKeyConfirmPass,
                      child: inputTextConfirmarContrasena(responsive)),
                  //focusConfirmarContrasena.hasFocus ? validacionesContrasena(responsive):Container(),
                  focusNuevaContrasena.hasFocus == true ||
                          focusConfirmarContrasena.hasFocus
                      ? Container()
                      : separacion(responsive, 25),
                  validarCodigo(responsive)
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
            fontSize: responsive.ip(2)),
      ),
    );
  }

  Widget inputTextNuevaContrasena(Responsive responsive) {
    return TextFormField(
      autofocus: true,
      maxLength: 24,
      autocorrect: true,
      inputFormatters: [LengthLimitingTextInputFormatter(24)],
      controller: controllerNuevaContrasena,
      focusNode: focusNuevaContrasena,
      obscureText: nuevaContrasena,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: _validNewPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: new InputDecoration(
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
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
                confirmarnuevaContrasena = !confirmarnuevaContrasena;
                nuevaContrasena = !nuevaContrasena;
              });
            },
          )),
      onTap: () {
        setState(() {
          focusNuevaContrasena.requestFocus();
          focusConfirmarContrasena.unfocus();
          _validConfirmPass = _formKeyConfirmPass.currentState.validate();

          // aaaa 1111
          if (reConsecutive
              .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
            Iterable<RegExpMatch> machList = reConsecutive
                .allMatches(controllerNuevaContrasena.text.toLowerCase());
            for (int i = 0; i < machList.length; i++) {
              if (!machList.elementAt(i).group(i).contains(" ")) {
                hasConsecutiveIgualesPass = true;
              }
            }
          } else {
            hasConsecutiveIgualesPass = false;
          }

          //123 abc
          if (reConsecutive2
              .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
            hasConsecutivosPass = true;
          } else {
            hasConsecutivosPass = false;
          }
          print(
              "Consecutivo: ${reConsecutive2.hasMatch(controllerNuevaContrasena.text.toLowerCase())}");

          if (controllerNuevaContrasena.text.length < 8) {
            lentPass = false;
          } else {
            lentPass = true;
          }
        });
      },
      onFieldSubmitted: (S) {
        FocusScope.of(context).requestFocus(focusConfirmarContrasena);
        focusNuevaContrasena.nextFocus();
        focusNuevaContrasena.unfocus();
        String password = controllerNuevaContrasena.text.trimRight();
        String passwordReplace = password.trimLeft();
        controllerNuevaContrasena.text =
            passwordReplace.replaceAll(new RegExp(r"\s+"), "");

        setState(() {
          hasEspacePass = false;
          _validConfirmPass = _formKeyConfirmPass.currentState.validate();

          // aaaa 1111
          if (reConsecutive
              .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
            Iterable<RegExpMatch> machList = reConsecutive
                .allMatches(controllerNuevaContrasena.text.toLowerCase());
            for (int i = 0; i < machList.length; i++) {
              if (!machList.elementAt(i).group(i).contains(" ")) {
                hasConsecutiveIgualesPass = true;
              }
            }
          } else {
            hasConsecutiveIgualesPass = false;
          }
          //123 abc
          if (reConsecutive2
              .hasMatch(controllerNuevaContrasena.text.toLowerCase())) {
            hasConsecutivosPass = true;
            print("Consecutivo 2 -> mensaje");
          } else {
            hasConsecutivosPass = false;
          }
          print(
              "Consecutivo: ${reConsecutive2.hasMatch(controllerNuevaContrasena.text.toLowerCase())}");

          if (controllerNuevaContrasena.text.length < 8) {
            lentPass = false;
          } else {
            lentPass = true;
          }
        });
      },
      validator: (value) {
        if (value.isEmpty && !focusNuevaContrasena.hasFocus) {
          return 'Este campo es requerido';
        }
        if (hasEspacePass && !focusNuevaContrasena.hasFocus) {
          return 'No debe tener espacios en blanco';
        }

        if (hasTieneEne && !focusNuevaContrasena.hasFocus) {
          return 'No debe tener la letra "Ñ" o "ñ"';
        }
        if (!hasCuatroLetras && !focusNuevaContrasena.hasFocus) {
          return 'Debe tener 4 letras y al menos 8 caracteres';
        }

        if (!lentPass && !focusNuevaContrasena.hasFocus) {
          return 'Debe ser de al menos 8 caracteres';
        }

        if ((!hasMayusPass || !hasMinusculaPass) &&
            !focusNuevaContrasena.hasFocus) {
          return 'Debe tener al menos una minúscula y una mayúscula';
        }
        if (!hasNumPass && !focusNuevaContrasena.hasFocus) {
          return 'Debe de contener al menos un número';
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
          _validNewPass = _formKeyNewPass.currentState.validate();
          controllerNuevaContrasena.text;
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
            hasMinusculaPass = true;
          } else {
            hasMinusculaPass = false;
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
            Iterable<RegExpMatch> machList = reConsecutive
                .allMatches(controllerNuevaContrasena.text.toLowerCase());
            for (int i = 0; i < machList.length; i++) {
              if (!machList.elementAt(i).group(i).contains(" ")) {
                hasConsecutiveIgualesPass = true;
              }
            }
          } else {
            hasConsecutiveIgualesPass = false;
          }

          if (reConsecutive2.hasMatch(value.toLowerCase())) {
            hasConsecutivosPass = true;
          } else {
            hasConsecutivosPass = false;
          }
          print("Consecutivo: ${reConsecutive2.hasMatch(value.toLowerCase())}");

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
      inputFormatters: [
        LengthLimitingTextInputFormatter(24),
      ],
      onFieldSubmitted: (S) {
        focusNuevaContrasena.unfocus();
        focusConfirmarContrasena.unfocus();

        String password = controllerConfirmarContrasena.text.trimRight();
        String passwordReplace = password.trimLeft();
        controllerConfirmarContrasena.text =
            passwordReplace.replaceAll(new RegExp(r"\s+"), "");

        setState(() {
          hasEspacePassCC = false;
          // aaaa 1111
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
      controller: controllerConfirmarContrasena,
      focusNode: focusConfirmarContrasena,
      obscureText: confirmarnuevaContrasena,
      keyboardType: TextInputType.visiblePassword,
      cursorColor:
          _validConfirmPass ? Tema.Colors.GNP : Tema.Colors.validarCampo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      onTap: () {
        setState(() {
          focusConfirmarContrasena.requestFocus();
          focusNuevaContrasena.unfocus();
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        /*if (hasEspacePassCC) {
          return 'No debe tener espacios en blanco';
        }
        if (hasTieneEneCC) {
          return 'No debe de contener la letra "Ñ" o "ñ"';
        }
        if (!hasCuatroLetrasCC) {
          return 'Debe tener 4 letras y al menos 8 caracteres';
        }
        if (!lentPassCC) {
          return 'Debe ser de al menos 8 caracteres';
        }
        if (!hasMayusPassCC || !hasMinusculaPassCC) {
          return 'Debe tener al menos una minúscula y una mayúscula';
        }

        if (!hasNumPassCC) {
          return 'Debe contener al menos un número';
        }
        if (hasGNPPassCC) {
          return 'No debe contener la palabra GNP';
        }
        if (hasConsecutiveIgualesPassCC) {
          return 'No debe contener más de dos caracteres consecutivos\n iguales (p.e. 222, eee)';
        }
        if (hasConsecutivosPassCC) {
          return 'No debe contener más de dos caracteres consecutivos\n (p.e. 123, abc)';
        }
        if (!hasCaracteresEspecialesCC) {
          return 'El caracter ${valorIncorrectoCaracterCC} no está permitido';
        }*/

        if (value != controllerNuevaContrasena.text)
          return 'La contraseña no coincide';

        return null;
      },
      onChanged: (value) {
        setState(() {
          _validConfirmPass = _formKeyConfirmPass.currentState.validate();
          print("value");
          print(value);
          controllerNuevaContrasena.text;
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
            hasMinusculaPassCC = true;
          } else {
            hasMinusculaPassCC = false;
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
                !value[i].contains("ñ")) {
              valorIncorrectoCaracterCC = value[i];
              print("valorIncorrectoCaracterCC ${valorIncorrectoCaracterCC}");
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

  Widget validarCodigo(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(21.5)),
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: controllerNuevaContrasena.text != "" &&
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
                    color: controllerNuevaContrasena.text != "" &&
                            controllerConfirmarContrasena.text != ""
                        ? Tema.Colors.backgroud
                        : Tema.Colors.botonletra,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            focusNuevaContrasena.unfocus();
            focusConfirmarContrasena.unfocus();
            if (_formKeyNewPass.currentState.validate() &&
                _formKeyConfirmPass.currentState.validate()) {
              setState(() {
                _saving = true;
              });

              ReestablecerContrasenaModel restablecerContrasena =
                  await reestablecerContrasenaServicio(
                      context,
                      idParticipanteValidaPorCorre,
                      controllerNuevaContrasena.text,responsive);

              print("restablecerContrasena     ${restablecerContrasena}");

              if (restablecerContrasena != null) {
                setState(() {
                  _saving = false;
                });
                if (restablecerContrasena.cambioContrasenaResponse != null &&
                    restablecerContrasena.cambioContrasenaResponse.retorno ==
                        "SUCCEEDED") {
                  customAlert(
                      AlertDialogType.contrasena_actualiza_correctamente,
                      context,
                      "",
                      "",
                      responsive,
                      funcionAlerta);
                } else {
                  customAlert(
                      AlertDialogType
                          .Contrasena_diferente_a_las_3_anteriores_nueva,
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
            } else {}
          }),
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
                                hasMayusPass && hasMinusculaPass
                                    ? "assets/login/checkcircle.png"
                                    : "assets/login/checkfail.png",
                                color: hasMayusPass && hasMinusculaPass
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
                            color: hasMayusPass && hasMinusculaPass
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
                          'No debe tener espacios en blanco.',
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

  void funcionAlerta() {}
}
