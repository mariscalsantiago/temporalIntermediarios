import 'package:cotizador_agente/LoginModule/Entity/MaskedUser.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';


abstract class LoginView {
  void showPassword(MaskedUser user, String mail);
  void autoLogin(String mail, String password);
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginPresentation {
  void showHome();
  void checkMail(String mail);
  void checkPassword(String email, String password, MaskedUser user);
  void openRegistro();
  void openOlvideContrasenia();
  Future<String> lastLogin();
}

abstract class LoginUseCase {
  void checkMail(String mail);
  void checkPassword(String email, String password, MaskedUser user);
  Future<String> lastLogin();
}

abstract class LoginInteractorOutput {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title, String message, TipoDialogo tipo);
  void showPassword(MaskedUser user, String mail);
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginWireFrame {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title,String message, TipoDialogo tipo);
  void openRegistro();
  void openOlvideContrasenia();
}

