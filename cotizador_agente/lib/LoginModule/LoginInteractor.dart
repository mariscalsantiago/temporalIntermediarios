
import 'package:cotizador_agente/LoginModule/Entity/MaskedUser.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class LoginInteractor implements LoginUseCase {
  LoginInteractorOutput output;
  LoginControllerState view;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uPhone;
  int errorTimes = 0;
  var temporalCVE;
  String uMail;
  String uPass;
  //UserJWT userJWT;
  final LocalAuthentication auth = LocalAuthentication();

  LoginInteractor(LoginInteractorOutput output, LoginControllerState view) {
    this.output = output;
    this.view = view;
  }

  @override
  void checkMail(String mail) {
    // TODO: implement checkMail
  }

  @override
  void checkPassword(String mail, String password, MaskedUser user) async{
    // TODO: implement checkPassword
  }

  @override
  Future<String> lastLogin() {
    // TODO: implement lastLogin
    throw UnimplementedError();
  }

}