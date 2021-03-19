import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';


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

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.portrait){
          deviceType = ScreenType.tabletPor;
          double wid = widget.ParentView.wp(64);
          double hei = widget.ParentView.hp(70);
          double inc = math.sqrt(math.pow(wid, 2) + math.pow(hei, 2));
          Responsive tabletPort = Responsive(height: hei,width: wid, inch: inc);
          return getPage(widget.vista,tabletPort);
        }
        else{
          double wid = widget.ParentView.wp(60);
          double hei = widget.ParentView.hp(80);
          double inc = math.sqrt(math.pow(wid, 2) + math.pow(hei, 2));
          Responsive tabletPort = Responsive(height: hei,width: wid, inch: inc);
          print("LansTablet");
          deviceType = ScreenType.tabletLan;
          print(tabletPort.width);
          print(tabletPort.height);
          return getPage(widget.vista,tabletPort);
        }

      },
    );
  }

  Widget getPage(Vistas vista, Responsive responsive){
    switch(vista){
      case Vistas.login:
        page =Scaffold(
          body: Center(
            child: Container(
              height: responsive.height,
              width: responsive.width,
              child:PrincipalFormLogin(responsive: responsive,) ,),
          ),
        );

        break;
      case Vistas.home:
        break;
      case Vistas.perfil:
        break;
    }

    return page;
  }
}