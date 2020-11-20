import 'package:cotizador_agente/SplashModule/SplashContract.dart';
import 'package:cotizador_agente/SplashModule/SplashController.dart';

class SplashRouter implements SplashWireFrame {

  SplashControllerState view;

  SplashRouter(SplashControllerState view) {
    this.view = view;
  }

  @override
  void showHome() {
    // TODO: implement showHome
  }

  @override
  void showLogin() {
    // TODO: implement showLogin
  }

  @override
  Future<bool> waitOnboarding() {
    // TODO: implement waitOnboarding
    throw UnimplementedError();
  }
}