import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';


abstract class LoginView {
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginPresentation {
  void showHome();
  void openOlvideContrasenia();
  void logInServices(String mail, String password, String user);
}

abstract class LoginUseCase {
  void logInServices(String mail, String password, String user);
}

abstract class LoginInteractorOutput {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title, String message, TipoDialogo tipo);
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginWireFrame {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title,String message, TipoDialogo tipo);
  void openOlvideContrasenia();
}

