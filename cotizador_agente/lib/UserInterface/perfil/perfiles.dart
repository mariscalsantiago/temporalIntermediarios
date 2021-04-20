import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/Models/DeasModel.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnBoardingApAutos.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnboardinPage.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/perfil/ListaCUA.dart';
import 'package:cotizador_agente/UserInterface/perfil/VerFotoPage.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'editarImagenPage.dart';

List<String> listadoDA= [];
List<String> listadoCUA= [];

String dropdownValue;
String dropdownValue2;
ServiceGetDeasModel dasData;
bool showDea = false;
bool preesDea = false;
bool showCua = false;
bool preesCua = false;
String valorCUA ;
String valorDA ;
int posicionCUA;
int posicionDA=0;
bool internet;
var _image;
bool isSwitchedPerfill;
class PerfilPage extends StatefulWidget {
  Responsive responsive;
  PerfilPage({Key key, this.responsive}) : super(key: key);
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File fotoPerfil;

  @override
  void initState() {
    super.initState();
    listadoDA= [];
    listadoCUA= [];
    isSwitchedPerfill = prefs.getBool("activarBiometricos");
    print("state isSwitchedPerfill ${isSwitchedPerfill}");
    getDeasCuas(context);
    posicionCUA = 0;
    //validateIntenetstatus(context, widget.responsive);
    print(DateTime.now());
  }

  void getDeasCuas (BuildContext context) async {
    listadoDA = [];
    listadoCUA = [];

    print("Da Y Cua");
    valorDA = datosPerfilador.daList.elementAt(0).cveDa;
    dropdownValue = datosPerfilador.daList.elementAt(0).cveDa;
    print(valorDA);
    print(datosPerfilador.daList);
    print(datosUsuario.idparticipante);
    for(int i =0; i < datosPerfilador.daList.length; i++ ){
      
      listadoDA.add("${datosPerfilador.daList.elementAt(i).cveDa}");
      print(listadoDA.elementAt(i));
    }

    if(datosPerfilador.daList.length>1){
      showDea = true;
    }else{
      showDea =  false;
    }

   // valorCUA = datosPerfilador.intermediarios[0];
    valorCUA = datosPerfilador.daList.elementAt(posicionDA).codIntermediario[0];
    dropdownValue2 =  datosPerfilador.daList.elementAt(posicionDA).codIntermediario[0];
    //dropdownValue2 = datosPerfilador.intermediarios[0];

    for(int j =0; j <  datosPerfilador.daList.elementAt(posicionDA).codIntermediario.length; j++ ){
      //listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]} - ${ datosPerfilador.agenteInteresadoList.elementAt(j).nombres} ${datosPerfilador.agenteInteresadoList.elementAt(j).apellidoPaterno}");
      listadoCUA.add("${datosPerfilador.daList.elementAt(posicionDA).codIntermediario[j]}");
    }

    if(listadoCUA.length>1){
      showCua = true;
    }else{
      showCua =  false;
    }
  }
  void setDACua(String pos, bool isDea){
    if(isDea){
      valorDA = pos;
      dropdownValue = pos;
      getDeasCuas(context);
    }else{
      valorCUA = pos;
      dropdownValue2 = pos;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    isSwitchedPerfill = prefs.getBool("activarBiometricos");
    print("build isSwitchedPerfill ${isSwitchedPerfill}");
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
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
                Navigator.pop(context,true);
              },
            ),
          ),
          body: SingleChildScrollView(
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
                                            builder: (context) => VerFotoPage()));
                                  },
                                  child: Container(
                                      width: widget.responsive.wp(13),
                                      height: widget.responsive.hp(13),
                                      decoration: BoxDecoration(
                                          color: Theme.Colors.profile_logo,
                                          shape: BoxShape.circle,
                                          //borderRadius: BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.Colors.Azul_2)),
                                      child: Center(
                                        child:  datosFisicos != null && datosFisicos.personales.foto != null &&
                                                datosFisicos.personales.foto != ""
                                            ? CircleAvatar(
                                                radius: 200.0,
                                                backgroundImage: NetworkImage(datosFisicos.personales.foto),
                                                backgroundColor: Colors.transparent,
                                              )
                                            : Text(datosPerfilador != null && datosPerfilador.agenteInteresadoList != null && datosPerfilador.agenteInteresadoList.elementAt(0)!= null?
                                          "${(datosPerfilador.agenteInteresadoList.elementAt(0).nombres.isNotEmpty? datosPerfilador.agenteInteresadoList.elementAt(0).nombres[0]: "")} ${datosPerfilador.agenteInteresadoList.elementAt(0).apellidoPaterno.isNotEmpty ? datosPerfilador.agenteInteresadoList.elementAt(0).apellidoPaterno[0]: ""}": "",
                                                style: TextStyle(
                                                    fontSize:
                                                    widget.responsive.hp(3.7),
                                                    color:
                                                        Theme.Colors.Azul_gnp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                      )),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).nombres} ${datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).apellidoPaterno}",
                                      style: TextStyle(
                                          fontSize: widget.responsive.ip(3),
                                          color: Theme.Colors.Azul_gnp),
                                    ),
                                    Text(
                                      datosUsuario.emaillogin,
                                      style: TextStyle(
                                          fontSize: widget.responsive.ip(2),
                                          color: Theme.Colors.Azul_2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Button camera
                          Positioned(
                            top: widget.responsive.hp(6.8),
                            left: widget.responsive.wp(18.9),
                            child: GestureDetector(
                              onTap: () async {
                                _showPicker(context);
                              },
                              child: Container(
                                  width: widget.responsive.wp(10),
                                  height: widget.responsive.hp(10),
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
                    Container(
                      margin: EdgeInsets.only(top: widget.responsive.hp(5)),
                      height: widget.responsive.hp(7.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: (Container(
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
                                  Text(
                                    "DA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.Colors.Azul_gnp,
                                        fontSize: widget.responsive.ip(2)),
                                  ),
                                ],
                              ),
                            )),
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
                                  Text(
                                    "CUA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.Colors.Azul_gnp,
                                        fontSize: widget.responsive.ip(2)),
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
                                  color: preesDea ? Theme.Colors.gnpOrange:Theme.Colors.borderInput,
                                  width: 1,
                                ),
                                color: showDea ? Theme.Colors.backgroud :Theme.Colors.botonlogin,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.only(left: 20.0, right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: showDea ? GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) => new listaCUA(
                                            responsive: widget.responsive,
                                            list: listadoDA,
                                            isDA: true,
                                            callback: setDACua,
                                          )));
                                },
                                onLongPressStart: (p){
                                  setState(() {
                                    preesDea=true;
                                  });

                                },
                                onLongPressEnd: (p){
                                  setState(() {
                                    preesDea=false;
                                  });
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) => new listaCUA(
                                            responsive: widget.responsive,
                                            list: listadoDA,
                                            isDA: true,
                                            callback: setDACua,
                                          )));
                                },
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(dropdownValue,style: TextStyle(
                                  color: Theme.Colors.Azul_2,
                                  fontSize: widget.responsive.ip(1.8))),
                                    Icon(preesDea ? Icons.arrow_drop_up:Icons.arrow_drop_down, color:preesDea ? Theme.Colors.gnpOrange:Theme.Colors.Funcional_Textos_Body,)
                                  ],
                                ),
                              ):Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dropdownValue,style: TextStyle(
                                      color: Theme.Colors.botonletra,
                                      fontSize: widget.responsive.ip(1.8))),
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
                                  color: preesCua ? Theme.Colors.gnpOrange:Theme.Colors.borderInput,
                                  width: 1,
                                ),
                                color: showCua ? Theme.Colors.backgroud :Theme.Colors.botonlogin,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.only(right: 20.0, left: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: showCua ? GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) => new listaCUA(
                                            responsive: widget.responsive,
                                            list: listadoCUA,
                                            isDA: false,
                                            callback: setDACua,
                                          )));
                                },
                                onLongPressStart: (p){
                                  setState(() {
                                    preesCua=true;
                                  });

                                },
                                onLongPressEnd: (p){
                                  setState(() {
                                    preesCua=false;
                                  });

                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) => new listaCUA(
                                            responsive: widget.responsive,
                                            list: listadoCUA,
                                            isDA: false,
                                            callback: setDACua,
                                          )));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(dropdownValue2,style: TextStyle(
                                        color: Theme.Colors.Azul_2,
                                        fontSize: widget.responsive.ip(1.8))),
                                    Icon(preesCua ? Icons.arrow_drop_up:Icons.arrow_drop_down, color:preesCua ? Theme.Colors.gnpOrange:Theme.Colors.Funcional_Textos_Body,)
                                  ],
                              )):Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text(dropdownValue2,style: TextStyle(
                                color: Theme.Colors.botonletra,
                                fontSize: widget.responsive.ip(1.8))),
                            Icon(Icons.arrow_drop_down)
                            ],
                            ),
                                  )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: widget.responsive.hp(9)),
                      child: Divider(
                        color: Theme.Colors.divider_color,
                        thickness: widget.responsive.hp(0.15),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginActualizarContrasena(
                                  responsive: widget.responsive)),
                        );
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
                                  fontSize: widget.responsive.ip(1.8)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.Colors.GNP,
                              size: widget.responsive.ip(1.6),
                            )
                          ],
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginActualizarNumero(
                                  responsive: widget.responsive)),
                        );
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
                                  fontSize: widget.responsive.ip(1.8)),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.Colors.GNP,
                                size: widget.responsive.ip(1.6)),
                          ],
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnBoardingAppAutos()),
                        );
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
                                  fontSize: widget.responsive.ip(1.8)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.Colors.GNP,
                              size: widget.responsive.ip(1.6),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: widget.responsive.hp(0.15),
                    ),
                    is_available_finger != false || is_available_face != false ?
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: widget.responsive.wp(2)),
                          child: Switch(
                            value: isSwitchedPerfill,
                            onChanged: (on) {
                              setState(() {
                                isSwitchedPerfill;
                              });
                              prefs.setBool("primeraVez", false);
                              prefs.setBool("esPerfil", true);
                              if(is_available_finger != false && is_available_face != false && isSwitchedPerfill == false){
                                if (deviceType == ScreenType.phone && isSwitchedPerfill == false ) {
                                  customAlert(AlertDialogType.opciones_de_inicio_de_sesion, context, "", "", widget.responsive, funcionAlerta);
                                }else if(on == false){
                                  is_available_finger != false ? customAlert(AlertDialogType.Desactivar_huella_digital, context, "", "", widget.responsive, funcionAlerta)
                                      :customAlert(AlertDialogType.Desactivar_recoFacial, context, "", "", widget.responsive, funcionAlerta);
                                } else {
                                  if( isSwitchedPerfill == false){
                                    customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion, context, "", "", widget.responsive);
                                  }
                                }
                              } else{

                                if(isSwitchedPerfill == false){
                                  is_available_finger != false ? customAlert(AlertDialogType.huella, context, "", "", widget.responsive, funcionAlertaBiometricos)
                                      : customAlert(AlertDialogType.Reconocimiento_facial, context, "", "", widget.responsive, funcionAlertaBiometricos);
                                }else if(on == false){
                                  is_available_finger != false ? customAlert(AlertDialogType.Desactivar_huella_digital, context, "", "", widget.responsive, funcionAlerta)
                                      :customAlert(AlertDialogType.Desactivar_recoFacial, context, "", "", widget.responsive, funcionAlerta);
                                }

                              }

                              setState(() {
                                isSwitchedPerfill = on;
                                print("isSwitched ${isSwitchedPerfill} ");
                                prefs.setBool("activarBiometricos", isSwitchedPerfill);
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
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Inicio de sesión con datos biométricos",
                                style: TextStyle(
                                    color: Theme.Colors.Azul_2,
                                    fontSize: widget.responsive.ip(2)),
                              )),
                        ),
                      ],
                    ) : Container(),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: widget.responsive.hp(0.15),
                    ),
                    TextButton(
                      onPressed: () {
                        customAlert(
                            AlertDialogType.CerrarSesion,
                            context,
                            "",
                            "",
                            widget.responsive,
                            funcionAlerta);
                      },
                      child: Text(
                        "CERRAR SESIÓN",
                        style: TextStyle(
                            fontSize: widget.responsive.ip(2),
                            color: Theme.Colors.GNP),
                      ),
                    ),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: widget.responsive.hp(0.15),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: widget.responsive.hp(1)),
                      child: Center(
                          child: Text(
                        ""
                                "Última sesión: " +
                           ultimaSesion,
                        style: TextStyle(
                            fontSize: widget.responsive.ip(1.8),
                            color: Theme.Colors.fecha_1),
                      )),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
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
                    leading: new Icon(Icons.photo_camera),
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
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SimpleCropRoute(
                image: _image,
              )),
    );
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SimpleCropRoute(
                image: _image,
              )),
    );
  }

  void funcionAlerta(bool biometricosActivos){
      setState(() {
        isSwitchedPerfill = biometricosActivos;
      });
  }

  void funcionAlertaBiometricos(bool biometricosActivos){
    setState(() {
      isSwitchedPerfill = biometricosActivos;
    });
  }
}