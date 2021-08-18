import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/perfil/VerFotoPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:image/image.dart' as newImage;
import 'package:vector_math/vector_math.dart' as vector;

import '../../main.dart';

class SimpleCropRoute extends StatefulWidget {
  final Function callback;
  final File image;
  final Responsive responsive;

  const SimpleCropRoute({Key key, this.responsive, this.image, this.callback}) : super(key: key);
  @override
  _SimpleCropRouteState createState() => _SimpleCropRouteState();
}

class _SimpleCropRouteState extends State<SimpleCropRoute> {
  final cropKey = GlobalKey<ImgCropState>();

  Future<Null> showImage(BuildContext context, File file) async {
    new FileImage(file)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      print('-------------------------------------------$info');
    }));
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Current screenshot：',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    color: Theme.Colors.Azul_gnp,
                    letterSpacing: 1.1),
              ),
              content: Image.file(file));
        });
  }

  double angle = 0.0;
  bool flagRotate = false;


  @override
  Widget build(BuildContext context) {


    try {
      if (widget.image != null || widget.image.isAbsolute == false) {
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
    Responsive responsive = Responsive.of(context);
    final Map args = ModalRoute.of(context).settings.arguments;
    return  GestureDetector(
        onTap: (){
      Inactivity(context:context).initialInactivity(functionInactivity);
    },child:SafeArea(
        bottom: false,
        child:Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Ajustar foto',
          style: TextStyle(color: Theme.Colors.Azul_gnp),
        ),
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back,
              color: Theme.Colors.Rectangle_PA, size: 24),
          onPressed: () {
            Inactivity(context:context).cancelInactivity();
            customAlert(AlertDialogType.AjustesSinGuardar_camara, context, "", "", responsive, widget.callback);
            /* setState(() {
              datosFisicos.personales.foto;
              widget.callback();
            });*/
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (!flagRotate && angle == 0) {
                  angle = 270;
                } else if (flagRotate && angle == 0) {
                  angle = 270;
                } else {
                  if (angle == 0) {
                    angle = 360;
                  } else {
                    angle -= 90;
                  }
                }
                flagRotate = true;
              });
            },
            icon: Image.asset(
              'assets/icon/perfil/prev.png',
              width: 24,
              height: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (flagRotate && angle == 360) {
                  angle = 90;
                } else if (!flagRotate && angle == 360) {
                  angle = 90;
                } else {
                  if (angle == 360) {
                    angle = 0;
                  } else {
                    angle += 90;
                  }
                }

                flagRotate = false;
              });
            },
            icon: Image.asset(
              "assets/icon/perfil/next.png",
              width: 24,
              height: 24,
            ),
          )
        ],
      ),
      body: Center(
        child: Stack(children: [
          Container(
              color: Theme.Colors.Azul_gnp,
              child: Transform.rotate(
                angle: vector.radians(angle),
                child: ImgCrop(
                  key: cropKey,
                  chipRadius: 150,
                  chipShape: 'circle',
                  maximumScale: 3,
                  image: FileImage(widget.image),
                  onImageError: (exception, stackTrace) {
                    Navigator.pop(context);
                  },
                ),
              )),
          new Positioned(
            bottom: 0.0,
            child: GestureDetector(
                onTap: () async {
                 // widget.callback();
                  File fotoPerfil;
                  final crop = cropKey.currentState;
                  fotoPerfil = await crop.cropCompleted(widget.image, pictureQuality: 900);
                  final fotoActualizada = newImage.copyRotate(newImage.readJpg(fotoPerfil.readAsBytesSync()), angle);
                  File newPicture = fotoPerfil..writeAsBytesSync(newImage.encodePng(fotoActualizada));
                  try {

                    await fetchFoto(context, newPicture);
                    widget.callback(newPicture);
                    Navigator.pop(context);

                  } catch (e) {
                    widget.callback();
                    Navigator.pop(context, newPicture);
                    print(e);
                  }

                },
                child: Container(
                  color: Theme.Colors.White,
                  height: responsive.hp(10),
                  width: responsive.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            right: responsive.height * 0.02,
                          ),
                          child: Icon(
                            Icons.save_outlined,
                            color: Theme.Colors.GNP,
                          )),
                      Container(
                          child: Text(
                        "GUARDAR AJUSTES",
                        style: TextStyle(
                            color: Theme.Colors.GNP,
                            fontSize: responsive.ip(2)),
                      ))
                    ],
                  ),
                )),
          ),
          new WillPopScope(
              child: Text(""),
              // ignore: missing_return
              onWillPop: () {
                customAlert(AlertDialogType.AjustesSinGuardar_camara, context,
                    "", "", responsive, widget.callback);
              })
        ]),
      ),
    )));
  }


  @override
  void initState() {
    Inactivity(context: context).initialInactivity(functionInactivity);

  }
  @override
  dispose() {

    super.dispose();
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }

  void CallbackInactividad(){
    setState(() {
      print("CallbackInactividad editarfoto");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
