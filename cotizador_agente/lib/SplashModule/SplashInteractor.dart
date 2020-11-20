import 'package:cotizador_agente/SplashModule/Entity/SplashData.dart';
import 'package:cotizador_agente/SplashModule/SplashContract.dart';

class SplashInteractor implements SplashUseCase {
  SplashInteractorOutput output;

  SplashInteractor(SplashInteractorOutput output) {
    this.output = output;
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
}