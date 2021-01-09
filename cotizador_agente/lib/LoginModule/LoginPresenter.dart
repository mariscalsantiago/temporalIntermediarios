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
  void showLoader() {
    router.showLoader();
  }

  @override
  void hideLoader() {
    router.hideLoader();
  }

  @override
  void showAlert(String title, String message, TipoDialogo tipo, String txtbutton) {
    router.showAlert(title, message, tipo, txtbutton);
  }

  @override
  void openOlvideContrasenia() {
  }

  @override
  void showMailView() {
    view?.showMailView();
  }

  @override
  void showPassword(MaskedUser user, String mail) {
    view.showPassword(user,mail);
  }

  @override
  void logInServices(String mail, String password, String user){
    interactor.logInServices(mail, password, user);
  }

  @override
  void showValidatorAlert(String message) {
    view?.showValidatorAlert(message);
  }

  @override
  void showValidatorAlertPass(String message) {
    view?.showValidatorAlertPass(message);
  }

}