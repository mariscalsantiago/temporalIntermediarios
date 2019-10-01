
import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/validadores.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      key: scaffoldKey,
      home: MyHomePage(title: 'GNP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.scaffoldKey}) : super(key: key);


  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState( scaffoldKey);
}


class _MyHomePageState extends State<MyHomePage> with Validadores{

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey;

  _MyHomePageState(this.scaffoldKey);

  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {

  };




  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;



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
      print("llegue al metodo del diccionario");
      createDoc[key]=value;

      print(createDoc);

    });
  }



  Formulario data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://35.232.57.52:8008/cotizador/aplicacion?id_aplicacion=1438"),
        headers: {
          "Accept": "application/json"
        }
    );


    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));
      this.setState(() {
        //data = json.decode(response.body);

        data = Formulario.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load post');
    }

    return "Success!";
  }


  @override
  void initState(){
    this.getData();
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
        title: Text(data.nombre),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Form(
              key: formKey,
              child: ListView.builder
                (
                  itemCount: data.secciones.length-1,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: data.secciones[index], i:index, end:data.secciones.length-1, cantidad_asegurados: data.cantidad_asegurados, formKey: formKey,),
                    );
                  }
              ),
            ),
          ),


        ]

      ),
    );
  }
}



class Post {
  final String userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["title"] = title;
    map["body"] = body;

    return map;
  }
}


Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}


