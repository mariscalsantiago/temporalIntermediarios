
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/home/listaRamosPage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
enum HomeSelection {Atuos,AP,None}

HomeSelection opcionElegida =  HomeSelection.None;
bool _loading=false;
String iniciales="EJ";

bool _isPortrait = false;
Responsive _responsiveMainTablet;
class HomePage extends StatefulWidget {
  bool verificacionCodigo;
  Responsive responsive;
  HomePage({Key key, this.verificacionCodigo, this.responsive}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  String dropdownValue =  prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo") ? "Autos" : prefs.getBool("showAP") ? "AP" : "";
  List<String> listaCotizadores = [];
  bool showRamos;
  bool pressRamo;
  Timer timerPhoto;

  @override
  void initState() {
   // skeletonLoad();

    pressRamo = false;

    if( prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo")){
      print("auto ${prefs.getBool("rolAutoscotizarActivo")}");
      print("showAP ${prefs.getBool("showAP")}");
      if(prefs.getBool("showAP")!= null && prefs.getBool("showAP")){
        showRamos = true;
        listaCotizadores = ['AP', "Autos"];
        dropdownValue = "Autos";
      }else{
        showRamos = false;
        listaCotizadores = ['Autos'];
        dropdownValue = "Autos";
      }
    } else if(prefs.getBool("showAP")!= null && prefs.getBool("showAP")){
      showRamos = false;
      listaCotizadores = ['AP'];
      dropdownValue = "AP";
    }else{
      showRamos = false;
      //Todo Alerta y retorno login
      listaCotizadores=[""];
      dropdownValue = "";
    }
    //dropdownValue =  prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo") ? "Autos": "AP";
    ultimoAcceso();
    prefs.setInt("localAuthCount", 0);
    handleUserInteraction(context,CallbackInactividad);
    //validateIntenetstatus(context, widget.responsive);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState_home $state");
    validateIntenetstatus(context, widget.responsive,CallbackInactividad);

  }

  void  skeletonLoad(){
    setState(() {
      _loading = true;
    });

    timerPhoto = Timer.periodic(Duration(seconds: 3), (timer) {
      cancelTimerLoadingEdit();
    });

  }

  void LoadingImage(){
    setState(() {

    });
  }
  void cancelTimerLoadingEdit(){
    if(timerPhoto!=null&&timerPhoto.isActive){
      timerPhoto.cancel();
    }
    setState(() {
      _loading = false;
    });
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        _responsiveMainTablet = Responsive.of(context);
        _isPortrait = true;
      } else {
        _responsiveMainTablet = Responsive.of(context);
        _isPortrait = false;
      }
      return builData(_responsiveMainTablet);
    });

  }

  Widget builData(Responsive responsive) {
    return GestureDetector(
        onTap: (){
          validateIntenetstatus(context,responsive,CallbackInactividad);
          handleUserInteraction(context,CallbackInactividad);
        },child:WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: getAppBar(context, responsive),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  
                  Container(
                    margin: EdgeInsets.only(top: responsive.hp(2),),
                    child: Text( prefs.getString("nombreUsuario") != null &&  prefs.getString("nombreUsuario")  != "" ?
                    "¡Hola ${prefs.getString("nombreUsuario")}!"
                        : "¡Hola !", style: TextStyle(
                        color: Theme.Colors.Azul_gnp,
                        fontWeight: FontWeight.normal,
                        fontSize: responsive.ip(2.8)
                    ), textAlign: TextAlign.center,),
                  ),
                  Row(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left: responsive.wp(4), top: responsive.hp(2), bottom: responsive.hp(0.5)),
                          child: Text("RAMO",
                            style: TextStyle(
                              color: Theme.Colors.Encabezados,
                              fontSize: responsive.ip(1.3),
                                fontWeight: FontWeight.bold,


                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: responsive.wp(4), right: responsive.wp(4)),
                    height: 10,
                    decoration: BoxDecoration(
                        border:  Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Theme.Colors.torneosContenedorSP,
                            width: 1.2,
                          ),
                        )
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: pressRamo ? Theme.Colors.gnpOrange : Theme.Colors.borderInput,
                        width: 1,
                      ),
                      color: showRamos ? Theme.Colors.backgroud : Theme.Colors.botonlogin,
                      borderRadius:BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.only(left: responsive.wp(4), right: responsive.wp(4), top: responsive.hp(2),  bottom: responsive.hp(2)),
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: responsive.hp(1.6)),
                    child: showRamos ? GestureDetector(
                        onTap: () {
                          validateIntenetstatus(context,responsive,CallbackInactividad);
                          handleUserInteraction(context,CallbackInactividad);
                          Navigator.push( context,
                              new MaterialPageRoute(builder: (_) => new ListaRamosPage(responsive: responsive, lista: listaCotizadores, callback: cambioRamo,)));
                        },
                        onLongPressStart: (p) {
                          handleUserInteraction(context,CallbackInactividad);
                          setState(() {
                            pressRamo = true;
                          });
                        },
                        onLongPressEnd: (p) {
                          handleUserInteraction(context,CallbackInactividad);
                          setState(() {
                            pressRamo = false;
                          });

                          Navigator.push( context,
                              new MaterialPageRoute(builder: (_) => new ListaRamosPage(responsive: responsive, lista: listaCotizadores, callback: cambioRamo,)));
                        },
                        child: Container(
                          color: Theme.Colors.backgroud,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dropdownValue,
                                  style: TextStyle(
                                      color: Theme.Colors.Azul_2,
                                      fontSize: responsive.ip(1.5))),
                              Icon(
                                preesCua ? Icons.arrow_drop_up: Icons.arrow_drop_down,
                                color: preesCua ? Theme.Colors.gnpOrange
                                    : Theme.Colors.Funcional_Textos_Body,
                              )
                            ],
                          ),
                        )
                    ) : Row(
                          crossAxisAlignment:CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dropdownValue,
                                style: TextStyle(
                                    color: Theme
                                        .Colors
                                        .botonletra,
                                    fontSize: responsive
                                        .ip(1.5))),
                            Icon(
                                Icons.arrow_drop_down)
                          ],
                    ),
                  ),
                  prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo") && dropdownValue == "Autos" ? Container(
                    height: responsive.hp(36),
                    width: responsive.width,
                    margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3)),
                    child: GestureDetector(
                      onTap: (){
                        validateIntenetstatus(context,responsive,CallbackInactividad);
                        setState(() {
                          showInactividad = false;
                          handleUserInteraction(context, callback);
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage(responsive: responsive)), );

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
                          showInactividad = false;
                          handleUserInteraction(context, callback);
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage(responsive: responsive)), );
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
                            Expanded(child:Image.asset('assets/images/autosymotos.png')),
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
                        validateIntenetstatus(context,responsive,CallbackInactividad);
                        handleUserInteraction(context,CallbackInactividad);
                        Navigator.pushNamed(context, "/cotizadorUnicoAP");
                        setState(() {
                        });
                        //opcionElegida = HomeSelection.AP;
                      },
                      onLongPressStart: (j){
                        handleUserInteraction(context,CallbackInactividad);
                        setState(() {
                          opcionElegida = HomeSelection.AP;
                        });
                      },
                      onLongPressEnd: (j){
                        handleUserInteraction(context,CallbackInactividad);
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
              ),
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
    ));
  }

  void cambioRamo(int indice){
    setState(() {
      dropdownValue = listaCotizadores[indice];
    });

  }

  AppBar getAppBar(BuildContext context, Responsive responsive) {
    bool tablet = false;
    tablet = prefs.getBool("useMobileLayout");
   // print("tablet ${tablet}");
   // validateIntenetstatus(context, widget.responsive);
    return AppBar(
      elevation: 0.0,
      leading: Container(
        margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
        //child: Image.asset("assets/icon/splash/logoGNP.png",
            //height: responsive.hp(25), width: responsive.wp(25)),
      ),
      title: Center(
        child:
      Container(
          //margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
         child: Image.asset("assets/icon/splash/logoGNP.png",
            height:tablet ? responsive.hp(15): responsive.hp(10),
           width:tablet ? responsive.hp(15): responsive.hp(10),
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
            validateIntenetstatus(context,responsive,CallbackInactividad);
            handleUserInteraction(context,CallbackInactividad);
            Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage(responsive:responsive, callback: LoadingImage,)),);
          },
          child:
          _loading ?
          Container(
            margin:prefs.getBool("useMobileLayout")
                ? EdgeInsets.only(top: responsive.hp(0.5)) : isPortrait
                ? EdgeInsets.only(right: responsive.wp(2)) : EdgeInsets.only(right: responsive.wp(3)) ,
            width: prefs.getBool("useMobileLayout")
                ? responsive.wp(13) : isPortrait
                ? responsive.wp(5.5) : responsive.wp(4) ,
            child: Skeleton(
              animationDuration: Duration(milliseconds: 500),
              textColor: Theme.Colors.gris_load1,
              height: responsive.hp(10),
              width: responsive.width,
              style: SkeletonStyle.circle,),)
              :
          Container(
              width: prefs.getBool("useMobileLayout")
                  ? responsive.wp(13)
                  : isPortrait
                  ? responsive.wp(10)
                  : responsive.wp(10),
              height: prefs.getBool("useMobileLayout")
                  ? responsive.wp(13)
                  : isPortrait
                  ? responsive.wp(10)
                  : responsive.wp(10),
              decoration: BoxDecoration(
                  color: Theme.Colors.profile_logo,

                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 2, color: Theme.Colors.Azul_2)),
              child: Center(
                child: datosFisicos != null &&
                    datosFisicos.personales.photoFile != null
                    ? CircleAvatar(
                  radius: prefs.getBool("useMobileLayout")
                      ? 22.0: isPortrait ? 28 : 27 ,
                  backgroundImage: Image.file(datosFisicos.personales.photoFile, fit: BoxFit.cover,).image,
                  backgroundColor: Colors.transparent,
                )
                    : Text(
                  respuestaServicioCorreo
                      .consultaUsuarioPorCorreoResponse
                      .USUARIOS
                      .USUARIO
                      .apellidoPaterno !=
                      null &&
                      respuestaServicioCorreo
                          .consultaUsuarioPorCorreoResponse
                          .USUARIOS
                          .USUARIO
                          .nombre !=
                          null
                      ? "${(respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.nombre != "" ? respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.nombre[0] : "")} ${respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.apellidoPaterno != "" ? respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.apellidoPaterno[0] : ""}"
                      : "",
                  style: TextStyle(
                      fontSize: prefs.getBool(
                          "useMobileLayout")
                          ? responsive.hp(1.8)
                          : responsive.hp(2.0),
                      color: Theme.Colors.Azul_gnp,
                      fontWeight: FontWeight.w400),
                ),
              ))
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


  void CallbackInactividad(){
  setState(() {
    print("CallbackInactividad home");
    focusContrasenaInactividad.hasFocus;
    showInactividad;
    handleUserInteraction(context,CallbackInactividad);
    //contrasenaInactividad = !contrasenaInactividad;
  });
  }
}
