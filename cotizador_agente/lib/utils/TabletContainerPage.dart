import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

Responsive responsiveMainTablet;
bool flujoTablet = false;

class TabletContainerPage extends StatefulWidget {
  final Vistas vista;
  final Responsive ParentView;


  const TabletContainerPage({Key key, this.vista,this.ParentView}) : super(key: key);
  @override
  _TabletContainerPageState createState() => _TabletContainerPageState();
}

class _TabletContainerPageState extends State<TabletContainerPage> {

  Widget page;

  @override
  void initState() {
    flujoTablet = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]); SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.portrait){
          /*
          deviceType = ScreenType.tabletPor;
          double wid = widget.ParentView.wp(64);
          double hei = widget.ParentView.hp(70);
          double inc = math.sqrt(math.pow(wid, 2) + math.pow(hei, 2));
          responsiveMainTablet = Responsive(height: hei,width: wid, inch: inc);
          */
          responsiveMainTablet = Responsive.of(context);
          return getPage(widget.vista);
        }
        else{
          /*
          double wid = widget.ParentView.wp(60);
          double hei = widget.ParentView.hp(80);
          double inc = math.sqrt(math.pow(wid, 2) + math.pow(hei, 2));
          responsiveMainTablet = Responsive(height: hei,width: wid, inch: inc);
          */
          responsiveMainTablet = Responsive.of(context);
          print("LansTablet");
          deviceType = ScreenType.tabletLan;
          return getPage(widget.vista);
        }

      },
    );
  }

  Widget getPage(Vistas vista){
    switch(vista){
      case Vistas.login:
        page =Scaffold(
          body: Center(
            child: Container(
              height: responsiveMainTablet.height,
              width: responsiveMainTablet.width,
              child:PrincipalFormLogin(responsive: responsiveMainTablet)),
          ),
        );

        break;
      case Vistas.home:
        break;
      case Vistas.perfil:
        break;
      case Vistas.biometricos:
        page =  page =Scaffold(
          body: Center(
            child: Container(
                height: responsiveMainTablet.height,
                width: responsiveMainTablet.width,
                child: BiometricosPage(responsive: responsiveMainTablet)),
          ),
        );
        break;
    }

    return page;
  }
}