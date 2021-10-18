
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Database.dart';
import 'package:cotizador_agente/Functions/FirebaseAuthenticationServices.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/TabsModule/TabsController.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/home/listaRamosPage.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:geocoding/geocoding.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_database/firebase_database.dart';


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

  String dropdownValue =  prefs!=null&&prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo") ? "Autos" : prefs.getBool("showAP") ? "Gastos Médicos" : "";
  String _address = "";
  List<String> listaCotizadores = [];
  bool showRamos;
  bool pressRamo;
  Timer timerPhoto;
  DatabaseReference _databaseReference;
  bool _isActiveAutos = false;

  @override
  void initState() {

    _runAsyncInit();
    Inactivity(context:context).initialInactivity(functionInactivity);
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    ultimoAcceso();
    prefs.setInt("localAuthCount", 0);
    saveDiviceIDFirebase();
    saveSesionUsuario();
    initializeTimerOtroUsuario(context,callback);
    doTimerOther=true;
    super.initState();
  }

  createCotizadoresRamo(){
    pressRamo = false;
    if( prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo")){
      print("auto ${prefs.getBool("rolAutoscotizarActivo")}");
      print("showAP ${prefs.getBool("showAP")}");
      if(prefs.getBool("showAP")!= null && prefs.getBool("showAP")){
        showRamos = true;
        listaCotizadores = ['Gastos Médicos', "Autos"];
        dropdownValue = "Autos";
      }else{
          showRamos = false;
          listaCotizadores = _isActiveAutos?['Autos']:[];
          dropdownValue = "Autos";
      }
    } else if(prefs.getBool("showAP")!= null && prefs.getBool("showAP")){
      showRamos = false;
      listaCotizadores = ['Gastos Médicos'];
      dropdownValue = "Gastos Médicos";
    }else{
      showRamos = false;
      //Todo Alerta y retorno login
      listaCotizadores=[];
      dropdownValue = "";
    }
  }
  void saveDiviceIDFirebase()async {
    print("== saveDiviceIDFirebase ==");
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime nowH = DateTime.now();
    //String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    String formattedDate = DateFormat('kk:mm:ss').format(now);
    String formatted = formatter.format(now);
    try{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission  != LocationPermission.denied && permission  != LocationPermission.deniedForever) {
      await _getPlace();
    }else{
      _address=" ";
    }
    }catch(e){
      _address=" ";
      print("Home getPlaces");
      print(e);
    }
    print("deviceID: ${deviceData["id"]}");
    String deviceName= prefs.getString("deviceName");
    try{
      DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
      Map<String, dynamic> mapa = {
        '${datosUsuario.idparticipante}': {
          'deviceID': deviceData["id"],
          //'hora':formatted + " ${formattedDate}",
          'hora':"${formattedDate}",
          'ciudad':_address,
          'dispositivo':Platform.isAndroid?"Android" + " ${deviceName}":"IOS" + " ${deviceName}",
          'isActive':true,
        }
      };
      print("mapa $mapa");
      _dataBaseReference.child("bitacora").update(mapa);
    }catch(e){
      print("== saveDiviceIDFirebase catch ==");
      print(e);
    }


    //});
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }

  void _getPlace() async {

      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    print("_getPlace");
    List<Placemark> newPlace = await placemarkFromCoordinates(userLocation.latitude, userLocation.longitude);
    // this is all you need
    Placemark placeMark  = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    //String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    String address = "${locality}";

    setState(() {
      _address = address; // update _address
    });
  }

  Future<Position> _getLocation() async {
    print("_getLocation");
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print("e _getLocation ${e}");
      currentLocation = null;
    }
    return currentLocation;
  }
  void functionConnectivity() {
    setState(() {});
  }

  void _runAsyncInit() async {
    _databaseReference=FirebaseDatabase.instance.reference();
    _databaseReference.child("AutosAvailable").onValue.listen((Event event) async {
      _isActiveAutos = validateNotEmptyBool(event.snapshot.value["dataAutos"]["show"]);
      if(!_isActiveAutos){
        List _whiteList = event.snapshot.value["dataAutos"]["whitelist"];
        final email = datosUsuario.emaillogin?.toLowerCase() ?? '';
        if (email.isNotEmpty && _whiteList.contains(email)) {
          _isActiveAutos = true;
        }
        /*for(String name in _whiteList){
          bool _whiteListMember = datosUsuario.emaillogin!=null ? name.toLowerCase() == datosUsuario.emaillogin.toLowerCase()? true : false:false;
          if(_whiteListMember){
            _isActiveAutos=true;
          }
        }*/

      }
      if(mounted) setState(() { });
      createCotizadoresRamo();
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
      createCotizadoresRamo();
    });
  }


  @override
  dispose() {
    super.dispose();
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
          Inactivity(context:context).initialInactivity(functionInactivity);
        },child:WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: getAppBar(context, responsive),
          body:
           SingleChildScrollView(
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
                  listaCotizadores.isNotEmpty?cotizadoresView(responsive):sinAccesoRamo(responsive, false),
                ],
              ),
            ),
          ),
        )

      ),
    ));
  }

  Widget cotizadoresView(Responsive responsive){

    return Container(child: Column(children: [
      //titulo Ramo
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
      //Borde Ramo
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
      //dropdown
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
              Navigator.push( context,
                  new MaterialPageRoute(builder: (_) => new ListaRamosPage(responsive: responsive, lista: listaCotizadores, callback: cambioRamo,))).then((value){
                Inactivity(context:context).initialInactivity(functionInactivity);

                  });
            },
            onLongPressStart: (p) {
              setState(() {
                pressRamo = true;
              });
            },
            onLongPressEnd: (p) {
              setState(() {
                pressRamo = false;
              });

              Navigator.push( context,
                  new MaterialPageRoute(builder: (_) => new ListaRamosPage(responsive: responsive, lista: listaCotizadores, callback: cambioRamo,))).then((value){
                Inactivity(context:context).initialInactivity(functionInactivity);

              });
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
      prefs.getBool("rolAutoscotizarActivo") != null && prefs.getBool("rolAutoscotizarActivo") && dropdownValue == "Autos" ? _isActiveAutos ?  Container(
        height: responsive.hp(36),
        width: responsive.width,
        margin: EdgeInsets.only(left: responsive.wp(3), right: responsive.wp(3)),
        child: GestureDetector(
          onTap: (){
            setState(() {
              showInactividad = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage(responsive: responsive),settings:RouteSettings(name: "CotizadorAutos") ), ).then((value){
              Inactivity(context:context).initialInactivity(functionInactivity);
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
              showInactividad = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage(responsive: responsive)), ).then((value){
              Inactivity(context:context).initialInactivity(functionInactivity);

            });
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
      ) : sinAccesoRamo(responsive,true):Container(),
      dropdownValue == "Gastos Médicos" ?  Container(
        height: responsive.hp(36),
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
                  Expanded(child:Image.asset('assets/images/gmm_cotizador.png')),
                  Container(
                    margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), top: responsive.hp(3), bottom: responsive.hp(2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Accidentes Personales", style: TextStyle(
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
    ]));

  }

  void cambioRamo(int indice){
    setState(() {
      dropdownValue = listaCotizadores[indice];
    });

  }

  Widget sinAccesoRamo(Responsive responsive, bool unico){
    return Container(margin: EdgeInsets.all(responsive.wp(6)),child: Column(children: [
      Container(margin: EdgeInsets.only(top:responsive.wp(6), bottom: responsive.wp(6)),child: Icon(Icons.info_outline_rounded, color: Theme.Colors.rowColor, size: responsive.ip(5),)),
      Container(margin: EdgeInsets.only(bottom: responsive.wp(7)),child: Row(children: [
        Expanded(child: Text(unico?"Sin acceso a herramienta de cotización.":"Sin acceso a herramientas de cotización.", textAlign: TextAlign.center, style: TextStyle(
            fontSize: prefs.getBool(
                "useMobileLayout")
                ? responsive.hp(2.0)
                : responsive.hp(2.2),
            color: Theme.Colors.Azul_gnp,
            fontWeight: FontWeight.w400)))
      ])),
      Container(child: Row(children: [
        Expanded(child: Text(unico?"Debido a tus permisos asignados no es posible ingresar a la herramienta de cotización":"Debido a tus permisos asignados no es posible ingresar a las herramientas de cotización", style: TextStyle(
    fontSize: prefs.getBool(
    "useMobileLayout")
    ? responsive.hp(1.8)
        : responsive.hp(2.0),
            height: 1.5,
    color: Theme.Colors.Funcional_Textos_Body,
    fontWeight: FontWeight.w400)))
      ])),
      
    ],));
  }
  AppBar getAppBar(BuildContext context, Responsive responsive) {
    bool tablet = false;
    tablet = prefs.getBool("useMobileLayout");
    return AppBar(
      elevation: 0.0,
      leading: Container(
        margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(1), top: responsive.hp(1), bottom: responsive.hp(1)),
      ),
      title: Center(
        child:
        Container(
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage(responsive:responsive, callback: LoadingImage,)),).then((value){
                Inactivity(context:context).initialInactivity(functionInactivity);
              });
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
                    respuestaServicioCorreo.primerApellido != null &&
                        respuestaServicioCorreo.nombre != null
                        ? "${(respuestaServicioCorreo.nombre != "" ? respuestaServicioCorreo.nombre[0] : "")} ${respuestaServicioCorreo.primerApellido != "" ? respuestaServicioCorreo.primerApellido[0] : ""}"
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
}
