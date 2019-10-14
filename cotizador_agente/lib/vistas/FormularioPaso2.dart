import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_tag_manager/google_tag_manager.dart' as gtm;



class FormularioPaso2 extends StatefulWidget {
  final String text;
  FormularioPaso2({Key key, @required this.text}) : super(key: key);
  @override
  _FormularioPaso2State createState() => _FormularioPaso2State();
}

class _FormularioPaso2State extends State<FormularioPaso2> {

  String _something ="Cargando... ";
  final formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> scaffoldKey;
  static final CREATE_POST_URL = 'http://35.232.57.52:8008/cotizador/aplicacion';

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'PASO2';
    final value = prefs.getString(key) ?? "no hay";
    print('read: $value');

    setState(() {
      _something = value;


    });

  }


  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {

  };

  final LocalStorage storage = new LocalStorage('formulario_3');




  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;
  bool isLoading = false;


  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }


  refresh() {
    setState(() {});
  }

  agregarAlDiccionario(String key, String value){
    setState(() {

      //El metodo que ya funciona
      print("llegue al metodo del diccionario");
      createDoc[key]=value;
      print(createDoc);
      guardarLocalStorage();

      // Otro metodo
      storage.setItem(key, createDoc);
      print("esto etoy guardando"+json.encode(storage.getItem(key)));


    });
  }



  guardarLocalStorage() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'PASO2';
    prefs.setString(key, createDoc.toString());

    final value = prefs.getString(key) ?? "no hay";
    print('read: $value');

    // Segundo método



  }



  Formulario data;
  Future<Post> createPost(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return Post.fromJson(json.decode(response.body));
    });
  }

  @override
  void initState(){
    //this.getData();
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-90.0, 0.0), Offset(90.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }


  @override

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("PASO 2"),
      ),

      body: Column(

        children:<Widget>[


          Expanded(
/*
            child: Form(
              key: formKey,
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : new ListView.builder
                (
                  itemCount: data.secciones.length-1,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {

                    return Padding(

                      padding: const EdgeInsets.all(16.0),
                    //  child: new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: data.secciones[index], i:index, end:data.secciones.length-1, cantidad_asegurados: data.cantidad_asegurados, formKey: formKey,),

                    );

                  }


              ),
            ),*/

        child: Form(
        key: formKey,
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : new RaisedButton(

          onPressed: () async {
            Post newPost = new Post(
                body: "{'id_aplicacion': 991, 'id_plan': 25,'cp':'09310','id_coaseguro': 3,'edad_titular':'23','sexo':'H','id_negocio': 2,'asegurados': [{'id': 25,'cp': '09311','edad_titular': '20','sexo': 'M'},{'id': 33,'cp': '09310','edad_titular': '25','sexo': 'H'}]}");
            Post p = await createPost(CREATE_POST_URL,
                body: newPost.toMap());
           // print(p.body);
          },
          child: const Text("Enviar"),
        )

        ),
          ),

          Text(
          widget.text + _something,
          style: TextStyle(fontSize: 24),),
        ]
        ),
      );
  }
}



class Post {
  final String body;

  Post({this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json['body'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["body"] = body;

    return map;
  }
}