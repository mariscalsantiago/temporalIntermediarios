import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Responsive responsiveMainMobile;
bool flujoMobile = false;

class MobileContainerPage extends StatefulWidget {
 final Vistas vista;
 final Responsive ParentView;

  const MobileContainerPage({Key key, this.vista,this.ParentView}) : super(key: key);
  @override
  _MobileContainerPageState createState() => _MobileContainerPageState();
}

class _MobileContainerPageState extends State<MobileContainerPage> {

  Widget page;

  @override
  void initState() {
    responsiveMainMobile = widget.ParentView;
    flujoMobile = true;
    getPage(widget.vista);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return page;
  }

  Widget getPage(Vistas vista){

    switch(vista){
      case Vistas.login:
        page = PrincipalFormLogin(responsive: responsiveMainMobile);
        break;
      case Vistas.home:
        break;
      case Vistas.perfil:
        break;
      case Vistas.biometricos:
        page = BiometricosPage(responsive: responsiveMainMobile);
      break;
    }

  }
}