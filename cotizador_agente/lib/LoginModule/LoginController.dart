import 'package:cotizador_agente/LoginModule/Entity/MaskedUser.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginPresenter.dart';
import 'package:cotizador_agente/ThemeGNP/EnabledButton.dart';
import 'package:cotizador_agente/ThemeGNP/EyeButton.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/utils/WidgetsReusables.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  LoginController({Key key}) : super(key: key);

  @override
  LoginControllerState createState() => LoginControllerState();
}

class LoginControllerState extends State<LoginController> implements LoginView {
  LoginPresenter presenter;

  MaskedUser user;
  String mail;
  bool biometricLogin = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  FocusNode passFocusNode = new FocusNode();
  final _formKeyPass = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  bool _isButtonContinuarDisabled = false;
  bool _isButtonInicisrDisabled = false;
  bool visibleOpcion = false;
  bool _showPassword = false;
  String inputMessage;

  LoginControllerState() {
    this.presenter = LoginPresenter(this);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          contentLogo(),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: ReusableWidgets.getTextCenterBienvenido('Soy Socio GNP\n¡Te damos la bienvenida!'),
          ),
          centerBody(),
        ],
      ),
    );
  }

  /// Muestra el logo de aplicación
  Widget contentLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Image.asset('assets/icon/splash/logoGNP.png', width: 135, height: 51),
          width: double.infinity),
    );
  }

  Widget centerBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(16, 32, 16, 0),
          child: Form(
            key: _formKeyEmail,
            child: TextFormField(
              focusNode: myFocusNode,
              onTap: requestFocus,
              onChanged: (value) {
                _isEmptyEmail(value);
              },
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "Este campo es requerido";
                } else if (!Utilidades.isVaidMail(value) && value.isNotEmpty) {
                 // AnalyticsHandler.logEvent(name: "aviso_correo_no_valido");
                  return "El campo es inválido.";
                } else if (this.inputMessage != null) {
                  return this.inputMessage;
                } else {
                  return null;
                }
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  alignLabelWithHint: true,
                  labelText: "Correo electrónico",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: myFocusNode.hasFocus
                              ? AppColors.secondary900
                              : AppColors.primary200)),
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? AppColors.secondary900
                          : AppColors.gnpTextUser,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      letterSpacing: 0.5)),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Form(
                key: _formKeyPass,
                child: TextFormField(
                  focusNode: passFocusNode,
                  onTap: requestFocusPass,
                  onChanged: (value) {
                    _isEmptyPassword(value);
                  },
                  obscureText: !_showPassword,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Este campo es requerido';

                    } else if (this.inputMessage != null) {
                      //passwordController.clear();
                      return this.inputMessage;
                    }
                    return null;
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      alignLabelWithHint: true,
                      labelText: "Contraseña",
                      suffixIcon: EyeButton(
                          enabled: _showPassword,
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          }),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: passFocusNode.hasFocus
                                  ? AppColors.secondary900
                                  : AppColors.primary200)),
                      labelStyle: TextStyle(
                          color: passFocusNode.hasFocus
                              ? AppColors.secondary900
                              : AppColors.gnpTextUser,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: 0.5)),
                ))),

        _buttonIniciarSesion(),
        Container(
          height: 24,
          width: 326,
          margin: EdgeInsets.fromLTRB(17, 140, 17, 16),
          child: Text("Versión " + "1.0",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: 0.32,
                  color: AppColors.gnpTextSytemt1)),
        ),
      ],
    );
  }

  void requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  void requestFocusPass() {
    setState(() {
      FocusScope.of(context).requestFocus(passFocusNode);
    });
  }

  ///botón para iniciar sesión
  Widget _buttonIniciarSesion() {
    return EnabledButton(
        margin: EdgeInsets.fromLTRB(16, 71, 16, 0),
        title: "Iniciar sesión",
        enabled: _isButtonInicisrDisabled,
        onPressed: () {
          if (_formKeyEmail.currentState.validate() && _formKeyPass.currentState.validate()) {
            _iniciarPressed();
          }
        });
  }

  void _iniciarPressed(){
    setState(() {
      FocusScope.of(context).unfocus();
      presenter.logInServices(emailController.text, passwordController.text, emailController.text);

    });
  }

  void _isEmptyEmail(String value) {
    if (value.isEmpty) {
      if (_isButtonContinuarDisabled) {
        setState(() {
          _isButtonContinuarDisabled = false;
        });
      }
    } else if (value.isNotEmpty) {
      if (!_isButtonContinuarDisabled) {
        setState(() {
          _isButtonContinuarDisabled = true;
        });
      }
    }
  }

  void _isEmptyPassword(String value) {
    if (value.isEmpty) {
      if (_isButtonInicisrDisabled) {
        setState(() {
          _isButtonInicisrDisabled = false;
        });
      }
    } else if (value.isNotEmpty) {
      if (!_isButtonInicisrDisabled) {
        setState(() {
          _isButtonInicisrDisabled = true;
        });
      }
    }
  }

  @override
  void showMailView() {
    setState(() {
      this.user = null;
      passwordController.clear();
    });
  }

  @override
  void showPassword(MaskedUser user, String mail) {
    this.user = user;
    this.mail = mail;
    setState(() {});
  }

  @override
  void showValidatorAlert(String message) {
    this.inputMessage = message;
    setState(() {
      _formKeyEmail.currentState.validate();
      this.inputMessage = null;
    });
  }

  @override
  void showValidatorAlertPass(String message) {
    this.inputMessage = message;
    setState(() {
      _formKeyPass.currentState.validate();
      this.inputMessage = null;
    });
  }
}