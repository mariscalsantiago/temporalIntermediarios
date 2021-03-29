import 'dart:io';
import 'dart:ui';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
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

import 'editarImagenPage.dart';

String dropdownValue;
String dropdownValue2;
bool showDea = false;
bool showCua = true;
String valorCUA;
String valorDA;
int posicionCUA;
var _image;
bool isSwitchedPerfill;

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  @override
  void initState() {
    super.initState();

    isSwitchedPerfill = prefs.getBool("activarBiometricos");
    dropdownValue = "123456";
    /*if(datosPerfilador.intermediarios.isNotEmpty && datosPerfilador.intermediarios.length>1){
      showDea = true;
    }else{
      showDea =  false;
    }*/
    if(datosPerfilador.intermediarios.length>1){
      showCua = true;
    }else{
      showCua =  false;
    }
    dropdownValue2 = datosPerfilador.intermediarios[0];
    valorCUA = datosPerfilador.intermediarios[0];
    valorDA = "123456";
    posicionCUA = 0;

    print(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Text(
              "Mi Perfil",
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
                                            builder: (context) => VerFotoPage(
                                                  image: fotoPerfil,
                                                )));
                                  },
                                  child: Container(
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
                                        child: fotoPerfil != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    new FileImage(fotoPerfil),
                                                radius: 200.0,
                                              )
                                            : Text(
                                                "${(datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).nombres[0])} ${datosPerfilador.agenteInteresadoList.elementAt(posicionCUA).apellidoPaterno[0]}",
                                                style: TextStyle(
                                                    fontSize:
                                                        responsive.hp(3.7),
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
                                          fontSize: responsive.ip(3),
                                          color: Theme.Colors.Azul_gnp),
                                    ),
                                    Text(
                                      datosUsuario.emaillogin,
                                      style: TextStyle(
                                          fontSize: responsive.ip(2),
                                          color: Theme.Colors.Azul_2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Button camera
                          Positioned(
                            top: responsive.hp(6.8),
                            left: responsive.wp(18.9),
                            child: GestureDetector(
                              onTap: () async {
                                _showPicker(context);
                              },
                              child: Container(
                                  width: responsive.wp(10),
                                  height: responsive.hp(10),
                                  decoration: BoxDecoration(
                                    color: Theme.Colors.White,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Theme.Colors.GNP,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    //DA y QA
                    Container(
                      margin: EdgeInsets.only(top: responsive.hp(5)),
                      height: responsive.hp(7.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: (Container(
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
                                  Text(
                                    "DA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.Colors.Azul_gnp,
                                        fontSize: responsive.ip(2)),
                                  ),
                                ],
                              ),
                            )),
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
                                  Text(
                                    "CUA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.Colors.Azul_gnp,
                                        fontSize: responsive.ip(2)),
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
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.Colors.borderInput,
                                  width: 1,
                                ),
                                color: Theme.Colors.backgroud,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.only(left: 20.0, right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: showDea ? DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Theme.Colors.Azul_2,
                                    fontSize: responsive.ip(1.8),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>['${valorDA.toString()}']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ): Center(
                                child: Text(dropdownValue,style: TextStyle(
                                  color: Theme.Colors.Azul_2,
                                  fontSize: responsive.ip(1.8),
                                ),),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.Colors.borderInput,
                                  width: 1,
                                ),
                                color: Theme.Colors.backgroud,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.only(right: 20.0, left: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: showCua ? DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) => new listaCUA(
                                                responsive: responsive)));
                                  },
                                  value: dropdownValue2,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Theme.Colors.Azul_2,
                                    fontSize: responsive.ip(1.8),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue2 = newValue;
                                    });
                                  },
                                  items: <String>[
                                    '${valorCUA.toString()}',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ) : Center(
                                child: Text(dropdownValue2, style: TextStyle(
                                  color: Theme.Colors.Azul_2,
                                  fontSize: responsive.ip(1.8),
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: responsive.hp(9)),
                      child: Divider(
                        color: Theme.Colors.divider_color,
                        thickness: responsive.hp(0.15),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginActualizarContrasena(
                                  responsive: responsive)),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: responsive.wp(4.4),
                            right: responsive.wp(4.4),
                            bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Actualizar contraseña",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(1.8)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.Colors.GNP,
                              size: responsive.ip(1.6),
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
                                  responsive: responsive)),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: responsive.wp(4.4),
                            right: responsive.wp(4.4),
                            bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Actualizar número de celular",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(1.8)),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Theme.Colors.GNP,
                                size: responsive.ip(1.6)),
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
                              builder: (context) => OnboardingPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: responsive.wp(4.4),
                            right: responsive.wp(4.4),
                            bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ver tutorial",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(1.8)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.Colors.GNP,
                              size: responsive.ip(1.6),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: responsive.hp(0.15),
                    ),
                    is_available_finger != false || is_available_face != false ?
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: responsive.wp(2)),
                          child: Switch(
                            value: isSwitchedPerfill,
                            onChanged: (on) {
                              setState(() {
                              });
                              if (deviceType == ScreenType.phone && isSwitchedPerfill == false ) {
                                customAlert(
                                    AlertDialogType
                                        .opciones_de_inicio_de_sesion,
                                    context,
                                    "",
                                    "",
                                    responsive);
                              } else {
                                if( isSwitchedPerfill == false){
                                customAlertTablet(
                                    AlertDialogTypeTablet
                                        .opciones_de_inicio_de_sesion,
                                    context,
                                    "",
                                    "",
                                    responsive);}
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
                                    fontSize: responsive.ip(2)),
                              )),
                        ),
                      ],
                    ) : Container(),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: responsive.hp(0.15),
                    ),
                    TextButton(
                      onPressed: () {
                        customAlert(
                            AlertDialogType.CerrarSesion,
                            context,
                            "",
                            "",
                            responsive);
                      },
                      child: Text(
                        "CERRAR SESIÓN",
                        style: TextStyle(
                            fontSize: responsive.ip(2),
                            color: Theme.Colors.GNP),
                      ),
                    ),
                    Divider(
                      color: Theme.Colors.divider_color,
                      thickness: responsive.hp(0.15),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                      child: Center(
                          child: Text(
                        ""
                                "Última sesión: " +
                           ultimaSesion,
                        style: TextStyle(
                            fontSize: responsive.ip(1.8),
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
}