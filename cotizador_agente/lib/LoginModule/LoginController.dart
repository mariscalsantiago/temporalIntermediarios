import 'package:cotizador_agente/LoginModule/Entity/MaskedUser.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginPresenter.dart';
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

  }

  @override
  void autoLogin(String mail, String password) {
    // TODO: implement autoLogin
  }

  @override
  void showMailView() {
    // TODO: implement showMailView
  }

  @override
  void showPassword(MaskedUser user, String mail) {
    // TODO: implement showPassword
  }

  @override
  void showValidatorAlert(String message) {
    // TODO: implement showValidatorAlert
  }

  @override
  void showValidatorAlertPass(String message) {
    // TODO: implement showValidatorAlertPass
  }
}