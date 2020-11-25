import 'package:cotizador_agente/SplashModule/Entity/SplashData.dart';
import 'package:cotizador_agente/SplashModule/SplashContract.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';

class SplashInteractor implements SplashUseCase {
  SplashInteractorOutput output;

  SplashInteractor(SplashInteractorOutput output) {
    this.output = output;
  }

  @override
  Future<SplashData> getSplashData() {
    return null;
  }

  @override
  void finishSplash(SplashData splashData) async {
    await Future.delayed(Duration(milliseconds: splashData.duracion));
    //var showOnboarding = await checkOnboarding();
    /*if (await checkOnboarding()) {
      await output?.waitOnboarding();

    } else {*/
      output?.showLogin();
    // }
  }


  static Future<bool> checkOnboarding() async {
    var info = await PackageInfo.fromPlatform();
    var thisVersion = info.version;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var lastVersion = prefs.getString("LAST_VERSION") ?? "0";
    prefs.setString("LAST_VERSION", thisVersion);
    print("thisVersion: $thisVersion");
    print("lastVersion: $lastVersion");
    Version thisV = Version.parse(thisVersion);
    Version lastV = Version.parse(lastVersion);
    prefs.setString("LAST_VERSION", thisVersion);
    if (thisV > lastV) {
      return true;
    } else {
      return false;
    }
  }
}