import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/perfil/editarImagenPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

File image;
String urlImagen;

class VerFotoPage extends StatefulWidget {
  VerFotoPage({Key key}) : super(key: key);

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
      });

    } else{
      setState(() {
        image = null;
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
          CachedNetworkImage(
            imageUrl: urlImagen,
            fit: BoxFit.cover,
          ) : Image(image: NetworkImage("https://blog.altabel.com/wp-content/uploads/2019/12/1-768x446.png"),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleCropRoute(image: image)),);
                    } else{

                    }
                  },
                  child: Icon(Tema.Icons.edit, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: (){
                    _showPicker(context);
                  },
                  child: Icon(Tema.Icons.camera_alt_24px, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: () async{
                    bool resp = await fetchFotoDelete(context);

                    if (resp) {
                      setState(() {
                        //_saving = false;
                        datosFisicos.personales.foto = null;
                      });
                    } else {
                      setState(() {
                        //_saving = false;
                      });

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
          Container(
            height: responsive.height,
            child: Opacity(
              opacity: 0.7,
              child: const ModalBarrier(dismissible: false, color: Tema.Colors.primary),
            ),
          ),
          new Center(
            child: Container(
                height: responsive.height*0.1,
                width: responsive.width* 0.2,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Tema.Colors.tituloTextoDrop),
                  child:   new CircularProgressIndicator(),
                )
            ),
          ),
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
  }

  _imgFromCamera() async {
    print(urlImagen);
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _saving = true;
      urlImagen = "";
    });
    print(urlImagen);
    fetchFoto(context, image);
    setState(() {
      urlImagen = datosFisicos.personales.foto;
      print(urlImagen);
      image = image;
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
    });
  }
}
