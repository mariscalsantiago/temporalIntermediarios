import 'package:cotizador_agente/HomeModule/HomePresenter.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key}) : super(key: key);

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends State<HomeController>{
  HomePresenter presenter;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
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
          //appBar: getAppBar(context),
          body: _getBodyRemoteConfig(),
          bottomNavigationBar: TabsController(
            isSecondLevel: false,
          ),
        ));
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      leading: Image.asset("assets/icon/splash/logoGNP.png",
          height: 120, width: double.infinity, fit: BoxFit.contain),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.orange, size: 30.0),
      actions: [
      ],
    );
  }


  Widget _getBodyRemoteConfig() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only( bottom: 8, right: 16, left: 16),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset("assets/icon/splash/logoGNP.png",
                      height: 40, width: 106, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Divider(
              thickness: 1,
              color: AppColors.primary700,
            ),
          )
        ],
      ),
    );
  }

}
