import 'dart:io';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/perfil/VerFotoPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';

import '../../main.dart';


class SimpleCropRoute extends StatefulWidget {
  final Function callback;
  final File image;
  const SimpleCropRoute({Key key, this.image, this.callback}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Ajustar foto',
            style: TextStyle(color: Theme.Colors.Azul_gnp),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon:
            new Icon(Icons.arrow_back, color: Theme.Colors.Rectangle_PA, size: 24),
            onPressed: (){
              customAlert(AlertDialogType.AjustesSinGuardar_camara, context, "",  "", responsive,widget.callback);
            setState(() {
              datosFisicos.personales.foto;
              widget.callback();
            });
            },
          ),
        ),
        body: Center(
          child: Stack(
            children:[ Container(
              color: Theme.Colors.Azul_gnp,
              child: ImgCrop(
                key: cropKey,
                chipRadius: 150,
                chipShape: 'circle',
                maximumScale: 3,
                image: FileImage(widget.image),
                // handleSize: 0.0,
              ),
            ),
              new Positioned(
                bottom: 0.0,
                child: GestureDetector(
                    onTap: () async {
                      widget.callback();
                      final crop = cropKey.currentState;
                      File fotoPerfil;
                      fotoPerfil =  await crop.cropCompleted(widget.image, pictureQuality: 900);
                      try{
                        await fetchFoto(context, fotoPerfil,widget.callback);
                        Navigator.of(context).pop();
                        setState(() {
                          urlImagen = datosFisicos.personales.foto;
                          image = fotoPerfil;
                          widget.callback();
                        });
                      }catch(e){
                        widget.callback();
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
                              margin: EdgeInsets.only( right: responsive.height * 0.02, ),
                              child: Icon(Icons.save_outlined, color: Theme.Colors.GNP,)),
                          Container(child: Text("GUARDAR AJUSTES", style: TextStyle(color: Theme.Colors.GNP, fontSize: responsive.ip(2)),))
                        ],
                      ),
                    )
                ),
              )
            ]
          ),
        ),
    );

        /*
        FloatingActionButton(
          onPressed: () async {
            final crop = cropKey.currentState;
            final croppedFile =
            await crop.cropCompleted(widget.image);
            showImage(context, croppedFile);
          },
          tooltip: 'Increment',
          child: Text('Crop'),
        ));*/
  }
}