import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:flutter/material.dart';


abstract class LoginView {
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginPresentation {
  void showHome();
  void openOlvideContrasenia();
  void logInServices(String mail, String password, String user);
  void getVersionApp(String idApp, String idOs, BuildContext context);
}

abstract class LoginUseCase {
  void logInServices(String mail, String password, String user);
}

abstract class LoginInteractorOutput {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title, String message, TipoDialogo tipo, String txtbutton);
  void showMailView();
  void showValidatorAlert(String message);
  void showValidatorAlertPass(String message);
}

abstract class LoginWireFrame {
  void showHome();
  void showLoader();
  void hideLoader();
  void showAlert(String title,String message, TipoDialogo tipo, String txtbutton);
  void openOlvideContrasenia();
}

