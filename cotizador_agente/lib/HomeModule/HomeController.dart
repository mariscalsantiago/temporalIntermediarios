import 'package:cotizador_agente/HomeModule/HomePresenter.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key}) : super(key: key);

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends State<HomeController>{
  HomePresenter presenter;
  bool badgeKey = false;
  bool drawerOpen;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 5,
        child: Scaffold(
         // drawerScrimColor: AppColors.primary700.withOpacity(0.7),
          //key: _drawerKey,
          backgroundColor: Colors.white,
          appBar: getAppBar(context),
          body: _getBodyRemoteConfig(),
          bottomNavigationBar: TabsController(
            isSecondLevel: false,
          ),
        ));
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Image.asset("assets/icon/splash/logoGNP.png",
          height: 40, width: 105.7, fit: BoxFit.contain),
      backgroundColor: Colors.white,
      leading: null,
    );
  }

  static void showCotizar(BuildContext context) {
    Navigator.pushNamed(context, "/cotizadorUnicoAP",);
  }

  Widget _getBodyRemoteConfig() {
    var healthWelcome = "Buenos días";
    return Container(
      padding: EdgeInsets.only(top: 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Divider(
              thickness: 1,
              color: AppColors.primary700,
            ),
          ),
          Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              alignment: Alignment.center,
              child: Text("¡$healthWelcome " + datosUsuario.givenname + "!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24, color: AppColors.primary700))),
        ],
      ),
    );
  }

}
