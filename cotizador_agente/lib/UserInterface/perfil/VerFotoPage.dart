import 'dart:io';
import 'dart:math';
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
var _image;
String urlImagen;

class VerFotoPage extends StatefulWidget {

  Function callback;
  VerFotoPage({Key key, this.callback}) : super(key: key);


  @override
  _VerFotoPageState createState() => _VerFotoPageState();
}


class _VerFotoPageState extends State<VerFotoPage> {
  File fotoPerfil;
  double width = 300.0;
  double height = 150.0;
  bool _saving;

  @override
  void initState() {
    _saving = false;
    //updateFoto();
    obtenerImagen();
    super.initState();
  }

  void obtenerImagen() async {
    urlImagen = "";
    if( datosFisicos != null && datosFisicos.personales.foto != null && datosFisicos.personales.foto != "" ) {
      await urlToFile(datosFisicos.personales.foto);
      setState(() {
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

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(imageUrl);
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      image = file;
    });
    return file;
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
            "Mi perfil",
            style: TextStyle(color: Tema.Colors.Azul_2),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Tema.Colors.GNP),
            onPressed: () {
              Navigator.pop(context,true);
              setState(() {
                datosFisicos.personales.foto;
                updateFoto();
              });
            },
          ),
        ),
        body:  Container(
          color: Tema.Colors.White,
          child: Stack(
              children: builData(responsive)
          ),
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
                      updateFoto();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleCropRoute(image: image, callback: updateFoto,)),);
                    } else{
                      updateFoto();
                    }
                  },
                  child: Icon(Icons.create_outlined, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: (){
                    _showPicker(context);
                    updateFoto();
                  },
                  child: Icon(Icons.camera_alt_outlined, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: () async{
                    bool resp = await fetchFotoDelete(context, updateFoto);
                    print("resp");
                    print(resp);

                    if (resp!= null && resp) {
                        //_saving = false;
                        datosFisicos.personales.foto = null;
                        updateFoto();
                    } else {
                    }
                  },
                  child: Icon(Icons.delete_outlined, color: Tema.Colors.GNP,)),
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
                        updateFoto();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.camera_alt_outlined),
                    title: new Text('Cámara',
                      style: TextStyle(fontSize: responsive.ip(1.5)),
                    ),
                    onTap: () {
                      _imgFromCamera();
                     updateFoto();
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
    try{
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      _image = File(pickedFile.path);
      //fetchFoto(context, _image, widget.callback);
      if(_image!= null){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SimpleCropRoute(
                image: _image,
                callback: updateFoto,
              )),
        );
      }}catch(e){
      print(e);
    }

  }

  _imgFromGallery() async {
    File _image;
    final picker = ImagePicker();
    //TODO revisar doble intento y validacion de null
    try{
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      _image = File(pickedFile.path);
      //fetchFoto(context, _image, widget.callback);
      if(_image!= null){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SimpleCropRoute(
                image: _image,
                callback: updateFoto,
              )),
        );
      }}catch(e){
      print(e);
    }

  }
  void updateFoto(){
    setState(() {
      fotoPerfil;
      datosFisicos.personales.foto;
      obtenerImagen();
      widget.callback();
    });
  }
}
