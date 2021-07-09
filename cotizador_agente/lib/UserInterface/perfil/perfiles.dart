import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Models/DeasModel.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnBoardingApAutos.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/perfil/ListaCUA.dart';
import 'package:cotizador_agente/UserInterface/perfil/VerFotoPage.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_animation/skeleton_animation.dart';
import 'editarImagenPage.dart';
import 'package:skeleton_text/skeleton_text.dart';

List<String> listadoDA = [];
List<String> listadoCUA = [];

String dropdownValue;
String dropdownValue2;
ServiceGetDeasModel dasData;
bool showDea = false;
bool preesDea = false;
bool showCua = false;
bool preesCua = false;
bool isPortrait = false;
String valorCUA;

String valorDA;

int posicionCUA;
int posicionDA = 0;
bool internet;
var _image;
bool isSwitchedPerfill;
Responsive responsiveMainTablet;
bool _loading = false;

class PerfilPage extends StatefulWidget {
  Function callback;
  Responsive responsive;

  PerfilPage({Key key, this.responsive, this.callback}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File fotoPerfil;
  bool _saving;
  bool _loading = false;
  Timer timerLoading;
  File imagePefil;
  bool isActiveBiometric = true;
  @override
  void initState() {
    Inactivity(context: context).initialInactivity(functionInactivity);
    validateIntenetstatus(context, widget.responsive, functionConnectivity);
    systemDeviceInit();
    posicionDA = 0;
    _saving = false;
    super.initState();
    listadoDA = [];
    listadoCUA = [];
    isSwitchedPerfill = prefs.getBool("activarBiometricos");
    dropdownValue = prefs.getString("currentDA");
    valorDA = prefs.getString("currentDA");
    dropdownValue2 = prefs.getString("currentCUA");
    valorCUA = prefs.getString("currentCUA");
    print("state isSwitchedPerfill ${isSwitchedPerfill}");
    getDeasCuas(context);
    getCuas(context);
    posicionCUA = 0;
    imagePefil = datosFisicos.personales.photoFile;
    //skeletonLoad();
  }

  Future<void> systemDeviceInit() async {
    print("systemDeviceInit $isActiveBiometric");
    isActiveBiometric = await validSystemDevice();
    setState(() {});
    print("systemDeviceInit $isActiveBiometric");
  }
  Future<void> skeletonLoad() async {
    print("skeletoLoad");
    setState(() {
      _loading = true;
    });

    timerLoading = Timer.periodic(Duration(seconds: 2), (timer) {
      print("skeletoLoad: timer");

      cancelTimerLoading();
    });
  }

  void cancelTimerLoading() {
    if (timerLoading != null && timerLoading.isActive) {
      timerLoading.cancel();
    }

    imagePefil = datosFisicos.personales.photoFile;
    setState(() {
      _loading = false;
    });
  }

  void getDeasCuas(BuildContext context) async {
    listadoDA = [];
    listadoCUA = [];

    print("Da Y Cua");
    print(valorDA);
    print(datosUsuario.idparticipante);
    for (int i = 0; i < datosPerfilador.daList.length; i++) {
      listadoDA.add("${datosPerfilador.daList.elementAt(i).cveDa}");
      print(listadoDA.elementAt(i));
    }

    if (datosPerfilador.daList.length > 1) {
      showDea = true;
    } else {
      showDea = false;
    }

    // valorCUA = datosPerfilador.intermediarios[0];
    //dropdownValue2 = datosPerfilador.intermediarios[0];
    for (int j = 0; j < datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length; j++) {
      if (datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j] ==
          datosPerfilador.agenteInteresadoList.elementAt(j).codIntermediario) {
        if (datosPerfilador.agenteInteresadoList.elementAt(j).nombres != null &&
            datosPerfilador.agenteInteresadoList
                .elementAt(j)
                .nombres
                .isNotEmpty) {
          listadoCUA.add(
              "${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(j).nombres} ${datosPerfilador.agenteInteresadoList.elementAt(j).apellidoPaterno}");
        } else {
          listadoCUA.add(
              "${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(j).razonSocial}");
        }
      } else {
        //listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
      }

      //listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
    }

    print("listadoCUA ${listadoCUA.length}");

    if (listadoCUA.length >= 2) {
      showCua = true;
    } else {
      showCua = false;
    }
  }

  void getCuas(BuildContext context) async {
    listadoCUA = [];
    print("getCuas");
    print(datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length);
    // valorCUA = datosPerfilador.intermediarios[0];
    //dropdownValue2 = datosPerfilador.intermediarios[0];
    for (int j = 0; j < datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length; j++) {
      print("getCuas daList en J: ${datosPerfilador.daList.elementAt(posicionDA).cveDa}");
      print("getCuas daList en J: ${datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length}");
      bool inlist = false;

      for (int n = 0; n < datosPerfilador.agenteInteresadoList.length; n++) {
        print("getCuas datosPerfilador en ${n} ${datosPerfilador.agenteInteresadoList.elementAt(n).codIntermediario}");
        if (datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j] == datosPerfilador.agenteInteresadoList.elementAt(n).codIntermediario) {
          //print("getCuas if1");
          
          if (datosPerfilador.agenteInteresadoList.elementAt(j).nombres != null && datosPerfilador.agenteInteresadoList.elementAt(n).nombres.isNotEmpty) {
            //print("getCuas if2");
            if(!listadoCUA.contains("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(n).nombres} ${datosPerfilador.agenteInteresadoList.elementAt(n).apellidoPaterno}")){
              listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(n).nombres} ${datosPerfilador.agenteInteresadoList.elementAt(n).apellidoPaterno}");
              inlist = true;
            }else{}
           
          } else {
            //print("getCuas else1");
            if(!listadoCUA.contains("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(n).razonSocial}")){
              listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${datosPerfilador.agenteInteresadoList.elementAt(n).razonSocial}");
              inlist = true;
            }
          }
        }
      }
      if (!inlist) {
        print("getCuas if3");
        //listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
      }

      //listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
    }

    print("listadoCUA ${listadoCUA.length}");
    if (listadoCUA.length >= 2) {
      showCua = true;
    } else {
      showCua = false;
    }
  }
  

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    isSwitchedPerfill = prefs.getBool("activarBiometricos");
    return  GestureDetector(onTap: (){
      Inactivity(context:context).initialInactivity(functionInactivity);
    },child:WillPopScope(
    onWillPop: () async => false,
    child: SafeArea(
      child:Scaffold(
            appBar: _saving
                ? null
                : AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    title: Text(
                      "Mi perfil",
                      style: TextStyle(color: Theme.Colors.Azul_2),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Theme.Colors.GNP),
                      onPressed: () {
                          Inactivity(context:context).cancelInactivity();
                        if (_saving) {
                        } else {
                          Navigator.pop(context, true);
                          widget.callback();
                        }
                      },
                    ),
                  ),
            body: prefs.getBool("useMobileLayout")
                ? Container(
                    width: widget.responsive.width,
                    height: widget.responsive.height,
                    color: Theme.Colors.White,
                    child: Stack(children: builData(widget.responsive)),
                  )
                : OrientationBuilder(builder: (context, orientation) {
                    if (orientation == Orientation.portrait) {
                      responsiveMainTablet = Responsive.of(context);
                      isPortrait = true;
                    } else {
                      responsiveMainTablet = Responsive.of(context);
                      isPortrait = false;
                    }
                    return Container(
                      width: responsiveMainTablet.width,
                      height: responsiveMainTablet.height,
                      color: Theme.Colors.White,
                      child: Stack(children: builData(responsiveMainTablet)),
                    );
                  })),
      ),
    ));
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();

    data = SingleChildScrollView(
      child: Container(
        color: Theme.Colors.White,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            children: [
              //Row imagen perfil
              Container(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    // ROW Foto perfil
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerFotoPage(responsive: widget.responsive,callback: loadingImage))).then((value){
                                Inactivity(context:context).initialInactivity(functionInactivity);
                              });
                            },
                            child: _loading
                                ? Container(
                                    margin: prefs.getBool("useMobileLayout")
                                        ? EdgeInsets.only(top: responsive.hp(1))
                                        : EdgeInsets.only(),
                                    width: prefs.getBool("useMobileLayout")
                                        ? responsive.wp(22)
                                        : isPortrait
                                            ? responsive.wp(13)
                                            : responsive.wp(10),
                                    height: prefs.getBool("useMobileLayout")
                                        ? responsive.wp(24)
                                        : isPortrait
                                            ? responsive.wp(13)
                                            : responsive.wp(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Container(
                                      margin: prefs.getBool("useMobileLayout")
                                          ? EdgeInsets.only(
                                              left: responsive.wp(5),
                                              right: responsive.wp(5))
                                          : isPortrait
                                              ? EdgeInsets.only(
                                                  left: responsive.wp(2.9),
                                                  right: responsive.wp(2.9))
                                              : EdgeInsets.only(
                                                  left: responsive.wp(4),
                                                  right: responsive.wp(4)),
                                      child: Skeleton(
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        textColor: Theme.Colors.gris_load1,
                                        height: responsive.hp(10),
                                        width: responsive.width,
                                        style: SkeletonStyle.circle,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: prefs.getBool("useMobileLayout")
                                        ? EdgeInsets.only(top: responsive.hp(1))
                                        : EdgeInsets.only(),
                                    width: prefs.getBool("useMobileLayout")
                                        ? responsive.wp(22)
                                        : isPortrait
                                            ? responsive.wp(13)
                                            : responsive.wp(10),
                                    height: prefs.getBool("useMobileLayout")
                                        ? responsive.wp(24)
                                        : isPortrait
                                            ? responsive.wp(13)
                                            : responsive.wp(10),
                                    decoration: BoxDecoration(
                                        color: Theme.Colors.profile_logo,
                                        shape: BoxShape.circle,
                                        //borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Theme.Colors.Azul_2)),
                                    child: Center(
                                      child: imagePefil != null
                                          ? CircleAvatar(
                                              radius: prefs.getBool(
                                                      "useMobileLayout")
                                                  ? 43
                                                  : isPortrait
                                                      ? 52
                                                      : 70,
                                              backgroundImage: Image.file(
                                                      imagePefil,
                                                      fit: BoxFit.cover)
                                                  .image,
                                              backgroundColor:
                                                  Colors.transparent,
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
                                                      ? responsive.hp(3.4)
                                                      : responsive.hp(3.2),
                                                  color: Theme.Colors.Azul_gnp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                    )),
                          ),
                        ),
                        Expanded(
                          flex: prefs.getBool("useMobileLayout") ? 4 : 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.nombre} ${respuestaServicioCorreo.consultaUsuarioPorCorreoResponse.USUARIOS.USUARIO.apellidoPaterno}",
                                style: TextStyle(
                                    fontSize: prefs.getBool("useMobileLayout")
                                        ? responsive.ip(3)
                                        : responsive.ip(1.5),
                                    color: Theme.Colors.Azul_gnp),
                              ),
                              Text(
                                datosUsuario.emaillogin.toLowerCase(),
                                style: TextStyle(
                                    fontSize: prefs.getBool("useMobileLayout")
                                        ? responsive.ip(2)
                                        : responsive.ip(1.2),
                                    color: Theme.Colors.Azul_2),
                              ),
                            ],
                          ),
                        ),
                        prefs.getBool("useMobileLayout")
                            ? Container()
                            : Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    //DA y QA
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(5)),
                                      height: responsive.hp(7.5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: new EdgeInsets.only(
                                                  left: responsive.wp(4.4),
                                                  right: responsive.wp(2.2)),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.orange,
                                                      width: 1.5,
                                                      style: BorderStyle.solid),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom:
                                                            responsive.hp(2.2)),
                                                    child: Text(
                                                      "DA",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Theme
                                                              .Colors.Azul_gnp,
                                                          fontSize: responsive
                                                              .ip(1.5)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: (Container(
                                              margin: new EdgeInsets.only(
                                                  right: responsive.wp(4.4),
                                                  left: responsive.wp(2.2)),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.orange,
                                                      width: 1.5,
                                                      style: BorderStyle.solid),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom:
                                                            responsive.hp(2.2)),
                                                    child: Text(
                                                      "CUA",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Theme
                                                              .Colors.Azul_gnp,
                                                          fontSize: responsive
                                                              .ip(1.5)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //DA QA expanSelector
                                    Container(
                                      child: Row(
                                        children: [
                                          //DEA
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: preesDea
                                                      ? Theme.Colors.gnpOrange
                                                      : Theme
                                                          .Colors.borderInput,
                                                  width: 1,
                                                ),
                                                color: showDea
                                                    ? Theme.Colors.backgroud
                                                    : Theme.Colors.botonlogin,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 20.0, right: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 8.0),
                                              child: showDea
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (_) =>
                                                                    new listaCUA(
                                                                      responsive:
                                                                          responsive,
                                                                      list:
                                                                          listadoDA,
                                                                      isDA:
                                                                          true,
                                                                      callback:
                                                                          updateDea,
                                                                    ))).then((value){
                                                          Inactivity(context:context).initialInactivity(functionInactivity);
                                                        });
                                                      },
                                                      onLongPressStart: (p) {
                                                        setState(() {
                                                          preesDea = true;
                                                        });
                                                      },
                                                      onLongPressEnd: (p) {
                                                        setState(() {
                                                          preesDea = false;
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (_) =>
                                                                    new listaCUA(
                                                                      responsive:
                                                                          responsive,
                                                                      list:
                                                                          listadoDA,
                                                                      isDA:
                                                                          true,
                                                                      callback:
                                                                          updateDea,
                                                                    ))).then((value){
                                                          Inactivity(context:context).initialInactivity(functionInactivity);
                                                        });
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(dropdownValue,
                                                              style: TextStyle(
                                                                  color: Theme
                                                                      .Colors
                                                                      .Azul_2,
                                                                  fontSize: widget
                                                                      .responsive
                                                                      .ip(1.5))),
                                                          Icon(
                                                            preesDea
                                                                ? Icons
                                                                    .arrow_drop_up
                                                                : Icons
                                                                    .arrow_drop_down,
                                                            color: preesDea
                                                                ? Theme.Colors
                                                                    .gnpOrange
                                                                : Theme.Colors
                                                                    .Funcional_Textos_Body,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(dropdownValue,
                                                            style: TextStyle(
                                                                color: Theme
                                                                    .Colors
                                                                    .botonletra,
                                                                fontSize: widget
                                                                    .responsive
                                                                    .ip(1.5))),
                                                        Icon(Icons
                                                            .arrow_drop_down)
                                                      ],
                                                    ),
                                            ),
                                          ),
                                          //Cua
                                          Expanded(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: preesCua
                                                    ? Theme.Colors.gnpOrange
                                                    : Theme.Colors.borderInput,
                                                width: 1,
                                              ),
                                              color: showCua
                                                  ? Theme.Colors.backgroud
                                                  : Theme.Colors.botonlogin,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            margin: EdgeInsets.only(
                                                right: 20.0, left: 10.0),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 8.0),
                                            child: showCua
                                                ? GestureDetector(
                                                    onTap: () {
                                                      //getCuas(context);
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (_) =>
                                                                  new listaCUA(
                                                                    responsive:
                                                                        responsive,
                                                                    list:
                                                                        listadoCUA,
                                                                    isDA: false,
                                                                    callback:
                                                                        updateDeaCUA,
                                                                  ))).then((value){
                                                        Inactivity(context:context).initialInactivity(functionInactivity);
                                                      });
                                                    },
                                                    onLongPressStart: (p) {
                                                      setState(() async {
                                                        //await getCuas(context);
                                                        //getCuas(context);
                                                        preesCua = true;
                                                      });
                                                    },
                                                    onLongPressEnd: (p) {
                                                      setState(() async {
                                                        //getCuas(context);
                                                        //await getCuas(context);
                                                        preesCua = false;
                                                      });

                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (_) =>
                                                                  new listaCUA(
                                                                    responsive:
                                                                        responsive,
                                                                    list:
                                                                        listadoCUA,
                                                                    isDA: false,
                                                                    callback:
                                                                        updateDeaCUA,
                                                                  ))).then((value){
                                                        Inactivity(context:context).initialInactivity(functionInactivity);
                                                      });
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(dropdownValue2,
                                                            style: TextStyle(
                                                                color: Theme
                                                                    .Colors
                                                                    .Azul_2,
                                                                fontSize:
                                                                    responsive.ip(
                                                                        1.5))),
                                                        Icon(
                                                          preesCua
                                                              ? Icons
                                                                  .arrow_drop_up
                                                              : Icons
                                                                  .arrow_drop_down,
                                                          color: preesCua
                                                              ? Theme.Colors
                                                                  .gnpOrange
                                                              : Theme.Colors
                                                                  .Funcional_Textos_Body,
                                                        )
                                                      ],
                                                    ))
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(dropdownValue2,
                                                          style: TextStyle(
                                                              color: Theme
                                                                  .Colors
                                                                  .botonletra,
                                                              fontSize:
                                                                  responsive.ip(
                                                                      1.5))),
                                                      Icon(
                                                          Icons.arrow_drop_down)
                                                    ],
                                                  ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    //Button camera
                    Positioned(
                      top: prefs.getBool("useMobileLayout")
                          ? responsive.hp(6.5)
                          : isPortrait
                              ? responsive.hp(9)
                              : responsive.hp(11),
                      left: prefs.getBool("useMobileLayout")
                          ? responsive.wp(18.9)
                          : isPortrait
                              ? responsive.wp(13)
                              : responsive.wp(11),
                      child: GestureDetector(
                        onTap: () async {
                          _showPicker(context);
                        },
                        child: _loading
                            ? Container()
                            : Container(
                                width: prefs.getBool("useMobileLayout")
                                    ? responsive.wp(10)
                                    : isPortrait
                                        ? responsive.wp(5)
                                        : responsive.wp(5),
                                height: prefs.getBool("useMobileLayout")
                                    ? responsive.hp(10)
                                    : isPortrait
                                        ? responsive.wp(5)
                                        : responsive.wp(5),
                                decoration: BoxDecoration(
                                  color: Theme.Colors.White,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Theme.Colors.GNP,
                                )),
                      ),
                    )
                  ],
                ),
              ),
              //DA y QA
              prefs.getBool("useMobileLayout")
                  ? Container(
                      margin: EdgeInsets.only(top: widget.responsive.hp(5)),
                      height: widget.responsive.hp(7.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: new EdgeInsets.only(
                                  left: widget.responsive.wp(4.4),
                                  right: widget.responsive.wp(2.2)),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.orange,
                                      width: 1.5,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: widget.responsive.hp(2.2)),
                                    child: Text(
                                      "DA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.Colors.Azul_gnp,
                                          fontSize: widget.responsive.ip(2)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: (Container(
                              margin: new EdgeInsets.only(
                                  right: widget.responsive.wp(4.4),
                                  left: widget.responsive.wp(2.2)),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.orange,
                                      width: 1.5,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: widget.responsive.hp(2.2)),
                                    child: Text(
                                      "CUA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.Colors.Azul_gnp,
                                          fontSize: widget.responsive.ip(2)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              //DA QA expanSelector
              prefs.getBool("useMobileLayout")
                  ? Container(
                      child: Row(
                        children: [
                          //DEA
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: preesDea
                                      ? Theme.Colors.gnpOrange
                                      : Theme.Colors.borderInput,
                                  width: 1,
                                ),
                                color: showDea
                                    ? Theme.Colors.backgroud
                                    : Theme.Colors.botonlogin,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.only(left: 20.0, right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: showDea
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (_) => new listaCUA(
                                                      responsive:
                                                          widget.responsive,
                                                      list: listadoDA,
                                                      isDA: true,
                                                      callback: updateDea,
                                                    ))).then((value){
                                          Inactivity(context:context).initialInactivity(functionInactivity);
                                        });
                                      },
                                      onLongPressStart: (p) {
                                        setState(() {
                                          preesDea = true;
                                        });
                                      },
                                      onLongPressEnd: (p) {
                                        setState(() {
                                          preesDea = false;
                                        });
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (_) => new listaCUA(
                                                      responsive:
                                                          widget.responsive,
                                                      list: listadoDA,
                                                      isDA: true,
                                                      callback: updateDea,
                                                    ))).then((value){
                                          Inactivity(context:context).initialInactivity(functionInactivity);
                                        });
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(dropdownValue,
                                              style: TextStyle(
                                                  color: Theme.Colors.Azul_2,
                                                  fontSize: widget.responsive
                                                      .ip(1.8))),
                                          Icon(
                                            preesDea
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: preesDea
                                                ? Theme.Colors.gnpOrange
                                                : Theme.Colors
                                                    .Funcional_Textos_Body,
                                          )
                                        ],
                                      ),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(dropdownValue,
                                            style: TextStyle(
                                                color: Theme.Colors.botonletra,
                                                fontSize:
                                                    widget.responsive.ip(1.8))),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                            ),
                          ),
                          //Cua
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: preesCua
                                    ? Theme.Colors.gnpOrange
                                    : Theme.Colors.borderInput,
                                width: 1,
                              ),
                              color: showCua
                                  ? Theme.Colors.backgroud
                                  : Theme.Colors.botonlogin,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            margin: EdgeInsets.only(right: 20.0, left: 10.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: showCua
                                ? GestureDetector(
                                    onTap: () {
                                      getCuas(context);
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (_) => new listaCUA(
                                                    responsive:
                                                        widget.responsive,
                                                    list: listadoCUA,
                                                    isDA: false,
                                                    callback: updateDeaCUA,
                                                  ))).then((value){
                                        Inactivity(context:context).initialInactivity(functionInactivity);
                                      });
                                    },
                                    onLongPressStart: (p) {
                                      setState(() {
                                        preesCua = true;
                                      });
                                    },
                                    onLongPressEnd: (p) {
                                      setState(() {
                                        preesCua = false;
                                      });

                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (_) => new listaCUA(
                                                    responsive:
                                                        widget.responsive,
                                                    list: listadoCUA,
                                                    isDA: false,
                                                    callback: updateDeaCUA,
                                                  ))).then((value){
                                        Inactivity(context:context).initialInactivity(functionInactivity);
                                      });
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(dropdownValue2,
                                            style: TextStyle(
                                                color: Theme.Colors.Azul_2,
                                                fontSize:
                                                    widget.responsive.ip(1.8))),
                                        Icon(
                                          preesCua
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: preesCua
                                              ? Theme.Colors.gnpOrange
                                              : Theme
                                                  .Colors.Funcional_Textos_Body,
                                        )
                                      ],
                                    ))
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dropdownValue2,
                                          style: TextStyle(
                                              color: Theme.Colors.botonletra,
                                              fontSize:
                                                  widget.responsive.ip(1.8))),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                          )),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(top: widget.responsive.hp(9)),
                child: Divider(
                  color: Theme.Colors.divider_color,
                  thickness: widget.responsive.hp(0.15),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  sendTag("appinter_perfil_cambio_pwd");
                  prefs.setBool("seActualizarNumero", false);
                  prefs.setBool("esPerfil", true);
                  prefs.setBool("actualizarContrasenaPerfil", true);
                  prefs.setBool("esActualizarNumero", false);
                  setState(() {
                    _saving = true;
                  });

                  OrquetadorOtpJwtModel optRespuesta =
                      await orquestadorOTPJwtServicio(context,
                          prefs.getString("medioContactoTelefono"), false);

                  setState(() {
                    _saving = false;
                  });
                  if (optRespuesta != null) {
                    if (optRespuesta.error == "") {
                      prefs.setString("idOperacion", optRespuesta.idOperacion);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginCodigoVerificaion(
                                    responsive: responsive,
                                    isNumero: false,
                                  ))).then((value){
                        Inactivity(context:context).initialInactivity(functionInactivity);
                      });
                    } else {
                      customAlert(AlertDialogType.errorServicio, context, "",
                          "", responsive, funcion);
                    }
                  } else {
                    customAlert(AlertDialogType.errorServicio, context, "", "",
                        responsive, funcion);
                  }
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginActualizarContrasena(responsive: widget.responsive)));
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: 15.0,
                      left: widget.responsive.wp(4.4),
                      right: widget.responsive.wp(4.4),
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Actualizar contraseña",
                        style: TextStyle(
                            color: Theme.Colors.Encabezados,
                            fontSize: prefs.getBool("useMobileLayout")
                                ? widget.responsive.ip(2.2)
                                : widget.responsive.ip(1.4)),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.Colors.GNP,
                        size: prefs.getBool("useMobileLayout")
                            ? widget.responsive.ip(2)
                            : widget.responsive.ip(1),
                      )
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  sendTag("appinter_perfil_cambio_tel");
                  prefs.setBool("seActualizarNumero", false);
                  prefs.setBool("esPerfil", true);
                  prefs.setBool("esActualizarNumero", true);
                  prefs.setBool("actualizarContrasenaPerfil", false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginActualizarNumero(
                            responsive: widget.responsive)),
                  ).then((value){
                    Inactivity(context:context).initialInactivity(functionInactivity);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: 15.0,
                      left: widget.responsive.wp(4.4),
                      right: widget.responsive.wp(4.4),
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Actualizar número de celular",
                        style: TextStyle(
                            color: Theme.Colors.Encabezados,
                            fontSize: prefs.getBool("useMobileLayout")
                                ? widget.responsive.ip(2.2)
                                : widget.responsive.ip(1.4)),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.Colors.GNP,
                          size: prefs.getBool("useMobileLayout")
                              ? widget.responsive.ip(2)
                              : widget.responsive.ip(1)),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  sendTag("appinter_perfil_onboarding");
                  setState(() {
                    prefs.setBool("primeraVez", false);
                    prefs.setBool("esPerfil", true);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OnBoardingAppAutos())
                  ).then((value){
                    Inactivity(context:context).initialInactivity(functionInactivity);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: 15.0,
                      left: widget.responsive.wp(4.4),
                      right: widget.responsive.wp(4.4),
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ver tutorial",
                        style: TextStyle(
                            color: Theme.Colors.Encabezados,
                            fontSize: prefs.getBool("useMobileLayout")
                                ? widget.responsive.ip(2.2)
                                : widget.responsive.ip(1.4)),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.Colors.GNP,
                        size: prefs.getBool("useMobileLayout")
                            ? widget.responsive.ip(2)
                            : widget.responsive.ip(1),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Theme.Colors.divider_color,
                thickness: widget.responsive.hp(0.15),
              ),
              isActiveBiometric && (is_available_finger != false || is_available_face != false)
                  ? Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: prefs.getBool("useMobileLayout")
                                  ? widget.responsive.wp(2)
                                  : widget.responsive.wp(3)),
                          child: Switch(
                            value: isSwitchedPerfill,
                            onChanged: (on) {
                              setState(() {
                                prefs.setBool("primeraVez", false);
                                prefs.setBool("esPerfil", true);
                              });
                              if ((is_available_finger && is_available_face) &&
                                  isSwitchedPerfill == false) {
                                print("if1");
                                if (deviceType == ScreenType.phone &&
                                    isSwitchedPerfill == false) {
                                  print("if2");
                                  customAlert(
                                      AlertDialogType
                                          .opciones_de_inicio_de_sesion,
                                      context,
                                      "",
                                      "",
                                      widget.responsive,
                                      funcionAlertaBiometricos);
                                } else if (on == false) {
                                  print("if3");
                                  is_available_finger && is_available_face
                                      ? customAlert(
                                          AlertDialogType
                                              .Desactivar_huella_digital_face,
                                          context,
                                          "",
                                          "",
                                          widget.responsive,
                                          funcionAlertaBiometricos)
                                      : is_available_finger != false
                                          ? customAlert(
                                              AlertDialogType
                                                  .Desactivar_huella_digital,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos)
                                          : customAlert(
                                              AlertDialogType
                                                  .Desactivar_recoFacial,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos);
                                } else {
                                  print("else1");
                                  if (isSwitchedPerfill == false) {
                                    customAlert(
                                        AlertDialogType
                                            .opciones_de_inicio_de_sesion,
                                        context,
                                        "",
                                        "",
                                        widget.responsive,
                                        funcionAlertaBiometricos);
                                  }
                                }
                              } else {
                                print("else2");
                                int count = prefs.getInt("localAuthCount");
                                print("else3");
                                if (isSwitchedPerfill == false) {
                                  print("if5");
                                  is_available_finger && is_available_face
                                      ? customAlert(
                                          AlertDialogType
                                              .opciones_de_inicio_de_sesion,
                                          context,
                                          "",
                                          "",
                                          widget.responsive,
                                          funcionAlertaBiometricos)
                                      : is_available_finger
                                          ? customAlert(
                                              AlertDialogType.huella,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos)
                                          : customAlert(
                                              AlertDialogType
                                                  .Reconocimiento_facial,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos);
                                } else if (on == false) {
                                  print("if8");
                                  is_available_finger && is_available_face
                                      ? customAlert(
                                          AlertDialogType
                                              .Desactivar_huella_digital_face,
                                          context,
                                          "",
                                          "",
                                          widget.responsive,
                                          funcionAlertaBiometricos)
                                      : is_available_finger != false
                                          ? customAlert(
                                              AlertDialogType
                                                  .Desactivar_huella_digital,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos)
                                          : customAlert(
                                              AlertDialogType
                                                  .Desactivar_recoFacial,
                                              context,
                                              "",
                                              "",
                                              widget.responsive,
                                              funcionAlertaBiometricos);
                                }
                              }
                              setState(() {
                                isSwitchedPerfill =
                                    prefs.getBool("activarBiometricos");
                              });
                            },
                            inactiveThumbColor: Theme.Colors.Encabezados,
                            inactiveTrackColor: Colors.blueGrey[50],
                            activeTrackColor: Colors.orangeAccent[50],
                            activeColor: Theme.Colors.GNP,
                          ),
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(left: responsive.wp(1)),
                                child: Text(
                                  "Inicio de sesión con datos biométricos",
                                  style: TextStyle(
                                      color: Theme.Colors.Azul_2,
                                      fontSize: prefs.getBool("useMobileLayout")
                                          ? widget.responsive.ip(2)
                                          : widget.responsive.ip(1.4)),
                                ))),
                      ],
                    )
                  : Container(),
             Container(
                height: prefs.getBool("useMobileLayout") ? 0 : responsive.hp(30),
              ),
              isActiveBiometric && (is_available_finger != false || is_available_face != false)
                  ?Divider(
                color: Theme.Colors.divider_color,
                thickness: widget.responsive.hp(0.15),
              ):Container(),
              TextButton(
                onPressed: () {
                  Inactivity(context: context).cancelInactivity();
                  //TODO 238
                  prefs.setBool("subSecuentaIngresoCorreo", false);
                  prefs.setBool("esPerfil", false);
                  customAlert(AlertDialogType.CerrarSesion, context, "", "",
                      widget.responsive, funcionAlerta);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: widget.responsive.hp(3),
                      top: widget.responsive.hp(3)),
                  child: Text(
                    "CERRAR SESIÓN",
                    style: TextStyle(
                        fontSize: prefs.getBool("useMobileLayout")
                            ? widget.responsive.ip(2.2)
                            : widget.responsive.ip(1.4),
                        color: Theme.Colors.GNP),
                  ),
                ),
              ),
              Divider(
                color: Theme.Colors.divider_color,
                thickness: widget.responsive.hp(0.15),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: widget.responsive.hp(1),
                ),
                child: Center(
                    child: Text(
                  "Última sesión: ${ultimaSesion()}",
                  style: TextStyle(
                      fontSize: prefs.getBool("useMobileLayout")
                          ? widget.responsive.ip(2.2)
                          : widget.responsive.ip(1.4),
                      color: Theme.Colors.fecha_1),
                )),
              )
            ],
          ),
        ),
      ),
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [LoadingController()],
      );
      l.add(modal);
    }

    return l;
  }

  String ultimaSesion() {
    if (prefs.getString("ultimoAcceso") != null &&
        prefs.getString("ultimoAcceso") != "") {
      if (prefs.getBool("primerAccesoFecha") != null &&
          prefs.getBool("primerAccesoFecha")) {
        String date = prefs
            .getString("ultimoAcceso")
            .substring(11, prefs.getString("ultimoAcceso").length);
        print("date perimer aacceso  ${date}");
        return "Hoy a las " + date;
      } else {
        if (prefs.getBool("ultimoAccesoHoy") != null &&
            prefs.getBool("ultimoAccesoHoy")) {
          String date = prefs
              .getString("ultimoAcceso")
              .substring(11, prefs.getString("ultimoAcceso").length);
          //print("date hoy ${date}");
          return "Hoy a las " + date;
        } else if (prefs.getBool("ultimoAccesoAyer") != null &&
            prefs.getBool("ultimoAccesoAyer")) {
          String date = prefs
              .getString("ultimoAcceso")
              .substring(11, prefs.getString("ultimoAcceso").length);
          return "Ayer a las " + date;
        } else {
          String date = prefs.getString("ultimoAcceso") != null
              ? prefs.getString("ultimoAcceso")
              : "";
          print("date  otro dia  ${date}");
          return date;
        }
      }
    } else {
      return "";
    }
  }

  void _showPicker(context) {
    Responsive responsive = Responsive.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(
                        'Galería',
                        style: TextStyle(fontSize: responsive.ip(1.5)),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.camera_alt_outlined),
                    title: new Text(
                      'Cámara',
                      style: TextStyle(fontSize: responsive.ip(1.5)),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File _image;
    final picker = ImagePicker();
    //TODO revisar doble intento y validacion de null
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      _image = File(pickedFile.path);
      //fetchFoto(context, _image, widget.callback);
      if (_image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SimpleCropRoute(
                    image: _image,
                    callback: editFoto,
                  )),
        ).then((value){
          Inactivity(context:context).initialInactivity(functionInactivity);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _imgFromGallery() async {
    File _image;
    final picker = ImagePicker();
    //TODO revisar doble intento y validacion de null
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      _image = File(pickedFile.path);

      //fetchFoto(context, _image, widget.callback);

      if (_image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SimpleCropRoute(
                    image: _image,
                    callback: editFoto,
                  )),
        ).then((value){
          Inactivity(context:context).initialInactivity(functionInactivity);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editFoto(File sendFile) async {
    setState(() {
      _loading = true;
    });

    timerLoading = Timer.periodic(Duration(seconds: 2), (timer) {
      cancelTimerLoadingEdit(sendFile);
    });
  }

  void loadingImage(File image) {
    imagePefil = image;
    setState(() {});
  }

  void cancelTimerLoadingEdit(File image) {
    if (timerLoading != null && timerLoading.isActive) {
      timerLoading.cancel();
    }
    imagePefil = image;
    setState(() {
      _loading = false;
    });
  }

  void funcionAlerta(bool biometricosActivos) {
    setState(() {
      isSwitchedPerfill = biometricosActivos;
    });
  }


  void funcionAlertaBiometricos() {
    Inactivity(context:context).initialInactivity(functionInactivity);
    print("funcionAlertaBiometricos perfiles");
    print(prefs.getBool("activarBiometricos"));
    //Navigator.pop(context, true);
    setState(() {
      isSwitchedPerfill = prefs.getBool("activarBiometricos");
      validateBiometricstatus(vacio);
    });
  }

  void funcionAlertaBiometricosDesactivar() {
    print("funcionAlertaBiometricos perfiles");
    print(prefs.getBool("activarBiometricos"));
    Navigator.pop(context, true);
    setState(() {
      isSwitchedPerfill = prefs.getBool("activarBiometricos");
      validateBiometricstatus(vacio);
    });
  }

  void vacio() {
    setState(() {});
  }

  void updateDeaCUA() {
    setState(() {
      dropdownValue = prefs.getString("currentDA");
      valorDA = prefs.getString("currentDA");
      dropdownValue2 = prefs.getString("currentCUA");
      valorCUA = prefs.getString("currentCUA");
    });
  }

  void updateDea(int i) {
    setState(() {
      listadoCUA = [];
      for (int j = 0; j < datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length; j++) {
        for (int n = 0; n < datosPerfilador.agenteInteresadoList.length; n++) {
          print("getCuas datosPerfilador en N ${datosPerfilador.agenteInteresadoList.elementAt(n).codIntermediario}");
          if (datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j] == datosPerfilador.agenteInteresadoList.elementAt(n).codIntermediario) {
            print("contains:");
            print(!listadoCUA.contains("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}"));
            if(!listadoCUA.contains("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}")){
              listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
            }else{}
          }
        }
      }
      dropdownValue = prefs.getString("currentDA");
      valorDA = prefs.getString("currentDA");
      dropdownValue2 = listadoCUA.elementAt(0);
      valorCUA = listadoCUA.elementAt(0);
      prefs.setString("currentCUA", listadoCUA.elementAt(0).toString());
      if (listadoCUA.isNotEmpty && listadoCUA.length > 1) {
        showCua = true;
      } else {
        showCua = false;
      }
    });
  }

  void CallbackInactividad() {
    setState(() {
      print("CallbackInactividad perfiles");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
