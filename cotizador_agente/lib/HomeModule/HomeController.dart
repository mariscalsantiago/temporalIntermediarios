import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key}) : super(key: key);

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends State<HomeController>{

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 5,
        child: Scaffold(
          drawerScrimColor: AppColors.primary700.withOpacity(0.7),
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
      leading: Container(color: AppColors.secondary900,),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.orange, size: 30.0),
      title: Image.asset("assets/icon/cotizador/logoGNP.png",
          height: 60, width: double.infinity, fit: BoxFit.contain),
      actions: [

      ],
    );
  }


  Widget _getBodyRemoteConfig() {
    return Container();
  }

}
