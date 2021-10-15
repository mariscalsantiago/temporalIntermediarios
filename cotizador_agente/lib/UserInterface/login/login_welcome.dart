import 'dart:async';
import 'dart:ffi';

import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/MobileContainerPage.dart';
import 'package:cotizador_agente/utils/TabletContainerPage.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'dart:math' as math;
bool useMobileLayout;

class LoginMainPage extends StatefulWidget {
  @override
  _LoginMainPageState createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {

  @override
  void initState() {
    super.initState();
  }

  void doDevice(){
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    Timer(
        Duration(seconds: 2),
            () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => useMobileLayout ?
            MobileContainerPage(ParentView: Responsive.of(context), vista: Vistas.login,)
                //Todo tablet
                :  TabletContainerPage(ParentView: Responsive.of(context), vista: Vistas.login,))));
                //:  MobileContainerPage(ParentView: Responsive.of(context), vista: Vistas.login,))));


  }
  @override
  Widget build(BuildContext context) {
    doDevice();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.Colors.backgroud,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: AspectRatio(
              aspectRatio: 22/18,
              child: LayoutBuilder(
                  builder: (_, contraints){
                    return Container(
                      child: Stack(
                        children:<Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: 35.0, right:35.0),
                              child: Image.asset("assets/login/logoGNP.png"
                              ),
                            ),
                          ),
                        ]
                      ),
                    );
                  }
              ),
            ),
        ),
      ),
    );
  }
}
