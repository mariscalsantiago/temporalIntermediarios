import 'package:cotizador_agente/LoginModule/Entity/MaskedUser.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/LoginModule/LoginInteractor.dart';
import 'package:cotizador_agente/LoginModule/LoginRouter.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';

class LoginPresenter implements LoginPresentation, LoginInteractorOutput {

  LoginControllerState view;
  LoginInteractor interactor;
  LoginRouter router;

  LoginPresenter(LoginControllerState view) {
    this.view = view;
    this.interactor = new LoginInteractor(this, view);
    this.router = new LoginRouter(view);
  }

  @override
  void showHome() {
    router.showHome();
  }

  @override
  void checkMail(String mail) {
    interactor.checkMail(mail);
  }

  @override
  void showLoader() {
    router.showLoader();
  }

  @override
  void hideLoader() {
    router.hideLoader();
  }

  @override
  void showAlert(String title, String message, TipoDialogo tipo) {
    router.showAlert(title, message, tipo);
  }

  @override
  void checkPassword(String email, String password, MaskedUser user) {
    // TODO: implement checkPassword
  }
  @override
  Future<String> lastLogin() {
    // TODO: implement lastLogin
    throw UnimplementedError();
  }

  @override
  void openOlvideContrasenia() {
    // TODO: implement openOlvideContrasenia
  }

  @override
  void openRegistro() {
    // TODO: implement openRegistro
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