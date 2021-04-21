import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/perfil/editarImagenPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

File image;
String urlImagen;

class VerFotoPage extends StatefulWidget {

  Function callback;
  VerFotoPage({Key key, this.callback}) : super(key: key);


  @override
  _VerFotoPageState createState() => _VerFotoPageState();
}


class _VerFotoPageState extends State<VerFotoPage> {
  double width = 300.0;
  double height = 150.0;
  bool _saving;

  @override
  void initState() {
    _saving = false;
    obtenerImagen();
    super.initState();
  }

  void obtenerImagen() async {
    urlImagen = "";
    if( datosFisicos != null && datosFisicos.personales.foto != null && datosFisicos.personales.foto != "" ) {
      final response = await http.get(datosFisicos.personales.foto);
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File(documentDirectory.path+ 'imagetest.png');
      file.writeAsBytesSync(response.bodyBytes);
      setState(() {
        image = file;
        urlImagen = datosFisicos.personales.foto;
        widget.callback();
      });

    } else{
      setState(() {
        image = null;
        widget.callback();
      });

    }
    return null;
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
            style: TextStyle(color: Tema.Colors.Azul_2),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Tema.Colors.GNP),
            onPressed: () {
              Navigator.pop(context,true);
              setState(() {
                datosFisicos.personales.foto;
                widget.callback();
              });
            },
          ),
        ),
        body:  Stack(
            children: builData(responsive)
        ));
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();
    data = Column(
      children: [
        Container(
          margin:EdgeInsets.only(top: responsive.hp(9.4)),
          height: responsive.hp(56),
          width: responsive.width,
          child:  datosFisicos != null && datosFisicos.personales.foto != null &&
              datosFisicos.personales.foto != "" ?
              Image(image:NetworkImage(datosFisicos.personales.foto,) ): Image(image: NetworkImage("https://blog.altabel.com/wp-content/uploads/2019/12/1-768x446.png"),),
        ),
        Container(
          margin:EdgeInsets.only(top: responsive.hp(9.4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: (){
                    print("image ${image}");
                    if(image != null){
                      print("image ${image}");
                      widget.callback();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleCropRoute(image: image, callback: widget.callback,)),);
                    } else{
                      widget.callback();
                    }
                  },
                  child: Icon(Tema.Icons.edit, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: (){
                    _showPicker(context);
                    widget.callback();
                  },
                  child: Icon(Tema.Icons.camera_alt_24px, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: () async{
                    bool resp = await fetchFotoDelete(context);
                    print("resp");
                    print(resp);

                    if (resp!= null && resp) {
                        //_saving = false;
                        datosFisicos.personales.foto = null;
                        widget.callback();
                    } else {
                    }
                  },
                  child: Icon(Tema.Icons.delete_24px, color: Tema.Colors.GNP,)),
            ],
          ),
        )
      ],
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          LoadingController(

          )
        ],
      );
      l.add(modal);
    }
    return l;
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
                        widget.callback();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara',
                      style: TextStyle(fontSize: responsive.ip(1.5)),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      widget.callback();
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
    print(urlImagen);
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _saving = true;
      urlImagen = "";
      widget.callback();
    });
    print(urlImagen);
    fetchFoto(context, image);
    setState(() {
      urlImagen = datosFisicos.personales.foto;
      print(urlImagen);
      image = image;
      widget.callback();
      _saving = false;
    });
  }

  _imgFromGallery() async {
    print("urlImagen");
    print(urlImagen);
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _saving = true;
      urlImagen = "";
      widget.callback();
    });
    print("urlImagen");
    print(urlImagen);
    fetchFoto(context, image);
    setState(() {
      urlImagen = datosFisicos.personales.foto;
      print("urlImagen");
      print(urlImagen);
      image = image;
      _saving = false;
      widget.callback();
    });
  }
}
