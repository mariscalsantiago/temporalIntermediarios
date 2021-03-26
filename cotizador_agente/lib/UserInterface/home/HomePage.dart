import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Models/LoginModel.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  bool verificacionCodigo;
  HomePage({Key key, this.verificacionCodigo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String dropdownValue = "Autos";

  @override
  void initState() {
    dropdownValue = "Autos";
    super.initState();
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Responsive responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: getAppBar(context, responsive),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3), top: responsive.hp(2)),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.Colors.backgroud,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        margin: EdgeInsets.only(left: 20.0, right: 10),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 20,
                            style: TextStyle(
                              color: Theme.Colors.Azul_2,
                              fontSize: responsive.ip(1.8),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['AP', "Autos"]
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  dropdownValue == "Autos" ? Container(
                    height: responsive.hp(35),
                    width: responsive.width,
                    margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3)),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage()), );
                      },
                      child: Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Group_542.png'),
                            Container(
                              margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), top: responsive.hp(3), bottom: responsive.hp(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Autos y motos", style: TextStyle(
                                      letterSpacing: 0.15,
                                      fontWeight: FontWeight.w600,
                                      fontSize: responsive.ip(2),
                                      color: Theme.Colors.Azul_gnp
                                  ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: Theme.Colors.gnpOrange)
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ) : Container(),
                  dropdownValue == "AP" ?  Container(
                    height: responsive.hp(35),
                    width: responsive.width,
                    margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3)),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/cotizadorUnicoAP");
                      },
                      child: Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Group_435.png'),
                            Container(
                              margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), top: responsive.hp(3), bottom: responsive.hp(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("AP", style: TextStyle(
                                      letterSpacing: 0.15,
                                      fontWeight: FontWeight.w600,
                                      fontSize: responsive.ip(2),
                                      color: Theme.Colors.Azul_gnp
                                  ), textAlign: TextAlign.right,),
                                  Icon(Icons.arrow_forward_ios, color: Theme.Colors.gnpOrange)
                                ],
                              ),
                            ),

                        ],),
                      ),
                    ),
                  ): Container(),

                ],
              )
              /*Container(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled:true,
                  initialUrl: 'https://gnp-appcontratacionautos-qa.appspot.com/?idParticipante=TSUAUT',
                ),
              )*/
            ),
          ),
          bottomNavigationBar: TabsController(
            isSecondLevel: false,
          ),
        ),
      ),
    );

  }

  AppBar getAppBar(BuildContext context, Responsive responsive) {
    return AppBar(
      elevation: 0.0,
      leading: Container(
        margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
        child: Image.asset("assets/icon/splash/logoGNP.png",
            height: responsive.hp(25), width: responsive.wp(25)),
      ),
      title: Container(
        //margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
        child: Image.asset("assets/icon/splash/logoGNP.png",
            height: responsive.hp(25), width: responsive.wp(25)),
      ),
      //centerTitle: true,
      backgroundColor: Colors.white,
      bottom: new PreferredSize(
          child: new Container(
              color: Theme.Colors.Encabezados,
              padding: const EdgeInsets.all(0.5),
             ),
          preferredSize: const Size.fromHeight(10.0)),
      actions: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()),);
          },
          child: fotoPerfil != null
          ? CircleAvatar(backgroundImage: new FileImage(fotoPerfil), radius:  105.7,)
              : Image.asset('assets/images/examplePerfil.png')
        )
      ],
    );
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
              color: Theme.Colors.Azul_gnp,
            ),
          ),
          Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              alignment: Alignment.center,
              child: Text("¡$healthWelcome " + datosUsuario.givenname + "!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24, color: Theme.Colors.Azul_gnp))),
        ],
      ),
    );
  }

}
