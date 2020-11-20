
import 'package:cotizador_agente/SplashModule/Entity/SplashData.dart';

abstract class SplashView {

}

abstract class SplashPresentation {
  Future<SplashData> getSplashData();
  void finishSplash(SplashData splashData);
}

abstract class SplashUseCase {
  Future<SplashData> getSplashData();
  void finishSplash(SplashData splashData);
}

abstract class SplashInteractorOutput {
  void showHome();
  void showLogin();
  Future<bool> waitOnboarding();
}

abstract class SplashWireFrame {
  void showHome();
  void showLogin();
  Future<bool> waitOnboarding();
}