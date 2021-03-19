import 'dart:io';

import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:image_picker/image_picker.dart';
import 'editarImagenPage.dart';


class VerFotoPage extends StatefulWidget {
  final File image;
  VerFotoPage({Key key, this.image}) : super(key: key);

  @override
  _VerFotoPageState createState() => _VerFotoPageState();
}

File _image;

class _VerFotoPageState extends State<VerFotoPage> {
  double width = 300.0;
  double height = 150.0;
  @override
  void initState() {
    _image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);

    return Scaffold(
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
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              margin:EdgeInsets.only(top: responsive.hp(9.4)),
              height: responsive.hp(56),
              width: responsive.width,
              child:_image != null ? Image.file(File(_image.path)) :Image(image: NetworkImage("https://blog.altabel.com/wp-content/uploads/2019/12/1-768x446.png"),
              ),
            ),
            Container(
              margin:EdgeInsets.only(top: responsive.hp(9.4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleCropRoute(image: _image,)),);
                      },
                      child: Icon(Theme.Icons.edit, color: Theme.Colors.GNP,)),
                  GestureDetector(
                      onTap: (){
                        _showPicker(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Editar()),);
                      },
                      child: Icon(Theme.Icons.camera_alt_24px, color: Theme.Colors.GNP,)),
                  GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Editar()),);
                      },
                      child: Icon(Theme.Icons.delete_24px, color: Theme.Colors.GNP,)),
                ],
              ),
            )
          ],
        ));
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
                    title: new Text('Cámara',
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
  }  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
}
