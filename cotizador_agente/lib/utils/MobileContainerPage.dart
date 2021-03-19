import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
    getPage(widget.vista,widget.ParentView);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return page;
  }

  Widget getPage(Vistas vista, Responsive responsive){

    switch(vista){
      case Vistas.login:
        page = PrincipalFormLogin(responsive: responsive,);
        break;
      case Vistas.home:
        break;
      case Vistas.perfil:
        break;

    }

  }
}