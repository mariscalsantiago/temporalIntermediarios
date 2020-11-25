import 'package:cotizador_agente/SplashModule/Entity/SplashData.dart';
import 'package:cotizador_agente/SplashModule/SplashContract.dart';
import 'package:cotizador_agente/SplashModule/SplashController.dart';
import 'package:cotizador_agente/SplashModule/SplashInteractor.dart';
import 'package:cotizador_agente/SplashModule/SplashRouter.dart';

class SplashPresenter implements SplashPresentation, SplashInteractorOutput {

  SplashControllerState view;
  SplashInteractor interactor;
  SplashRouter router;

  SplashPresenter(SplashControllerState view) {
    this.view = view;
    this.interactor = new SplashInteractor(this);
    this.router = new SplashRouter(view);
  }

  @override
  Future<SplashData> getSplashData() {
    return interactor?.getSplashData();
  }

  @override
  void finishSplash(SplashData splashData) {
    interactor?.finishSplash(splashData);
  }

  @override
  void showHome() {
    router?.showHome();
  }

  @override
  void showLogin() {
    router?.showLogin();
  }

  @override
  Future<bool> waitOnboarding() {
    return router?.waitOnboarding();
  }
}