import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
enum HomeSelection {Atuos,AP,None}

HomeSelection opcionElegida =  HomeSelection.None;

String iniciales="EJ";
class HomePage extends StatefulWidget {
  bool verificacionCodigo;
  Responsive responsive;
  HomePage({Key key, this.verificacionCodigo, this.responsive}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String dropdownValue = "Autos";

  @override
  void initState() {
    dropdownValue = "Autos";
    //validateIntenetstatus(context, widget.responsive);
    super.initState();
  }
  int _selectedIndex = 0;
void getInicialesName(){
  if(datosPerfilador != null){
    if(datosPerfilador.agenteInteresadoList.isNotEmpty){
      try{
        iniciales = "${(datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).nombres[0])} ${datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).apellidoPaterno[0]}";
      }catch(e){
        print(e);
      }}
  }
}
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    getInicialesName();
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
                          border: Border.all(color: Theme.Colors.Azul_gnp)
                        ),
                        //margin: EdgeInsets.only(left: 20.0, right: 10),
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
                                //if(dropdownValue == "Atuos"){opcionElegida = HomeSelection.Atuos;}else if(dropdownValue == "AP"){opcionElegida = HomeSelection.AP;}
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
                    height: responsive.hp(36),
                    width: responsive.width,
                    margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3)),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage()), );
                        setState(() {
                        });
                        //opcionElegida = HomeSelection.Atuos;
                      },
                      onLongPressStart: (j){
                        setState(() {
                          opcionElegida = HomeSelection.Atuos;
                        });
                      },
                      onLongPressEnd: (j){
                        setState(() {
                          opcionElegida = HomeSelection.None;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage()), );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:  opcionElegida == HomeSelection.Atuos ? (Colors.orange): (Colors.white),
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/autosymotos.png'),
                            Container(
                              color: Theme.Colors.White,
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
                        setState(() {
                        });
                        //opcionElegida = HomeSelection.AP;
                      },
                      onLongPressStart: (j){
                        setState(() {
                          opcionElegida = HomeSelection.AP;
                        });
                      },
                      onLongPressEnd: (j){
                        setState(() {
                          opcionElegida = HomeSelection.None;
                        });
                        Navigator.pushNamed(context, "/cotizadorUnicoAP");
                      },
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: opcionElegida == HomeSelection.AP ? (Colors.orange): (Colors.white),
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          /*decoration: BoxDecoration(
                              border: selectAP ?Border.all(color: Colors.orange): Border.all(color: Colors.white)
                          ),*/

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
          /*
          bottomNavigationBar: TabsController(
            isSecondLevel: false,
          ),*/
        ),
      ),
    );

  }

  AppBar getAppBar(BuildContext context, Responsive responsive) {
    return AppBar(
      elevation: 0.0,
      leading: Container(
        margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
        //child: Image.asset("assets/icon/splash/logoGNP.png",
            //height: responsive.hp(25), width: responsive.wp(25)),
      ),
      title: Center(
        child: Container(
          //margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
         child: Image.asset("assets/icon/splash/logoGNP.png",
            height: responsive.hp(25), width: responsive.wp(25),
          )
        ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage(responsive:responsive, callback: updateFoto,)),);
          },
          child:Container(
              width: responsive.wp(13),
              height: responsive.hp(13),
              decoration: BoxDecoration(
                  color: Theme.Colors.profile_logo,
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 2,
                      color: Theme.Colors.Azul_2)),
              child: Center(
                child: datosFisicos != null && datosFisicos.personales.foto != null &&
                    datosFisicos.personales.foto != ""
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(datosFisicos.personales.foto),
                        backgroundColor: Colors.transparent,
                        radius: 200.0,
                    )
                    : Text(datosPerfilador != null && datosPerfilador.agenteInteresadoList != null && datosPerfilador.agenteInteresadoList.elementAt(0)!= null?
                      "${(datosPerfilador.agenteInteresadoList.elementAt(0).nombres.isNotEmpty? datosPerfilador.agenteInteresadoList.elementAt(0).nombres[0]: "")} ${datosPerfilador.agenteInteresadoList.elementAt(0).apellidoPaterno.isNotEmpty ? datosPerfilador.agenteInteresadoList.elementAt(0).apellidoPaterno[0]: ""}": "",
                      style: TextStyle(
                          fontSize:
                          responsive.hp(2.2),
                          color:
                          Theme.Colors.Azul_gnp,
                          fontWeight:
                          FontWeight.w400),
                    ),
              ))     )
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

  void updateFoto(){setState(() {
    datosFisicos.personales.foto;
  });}
}
