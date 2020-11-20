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
  void finishSplash(SplashData splashData) {
    // TODO: implement finishSplash
  }

  @override
  Future<SplashData> getSplashData() {
    // TODO: implement getSplashData
    throw UnimplementedError();
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