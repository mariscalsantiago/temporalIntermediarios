
import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(title: 'GNP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void changeView() {
  print('hellow');
}


class _MyHomePageState extends State<MyHomePage> {
  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;
 // List _cities =
 // ["Cluj-Napoca", "Bucuresti", "Timisoara", "Brasov", "Constanta"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;


  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }



  Formulario data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://35.232.57.52:8008/cotizador/aplicacion?id_aplicacion=991"),
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


    print(data.nombre.toString());

    return "Success!";
  }


  @override
  void initState(){
    this.getData();
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
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
        title: Text(data.secciones[1].seccion),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder
              (
                itemCount: data.secciones.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),


                itemBuilder: (BuildContext ctxt, int index) {
                  return new SeccionDinamica(secc: data.secciones[index],);
                }
            ),
          )
        ],

                color: colorHex,
                width: double.infinity,

                  /*
              child: FutureBuilder<Formulario>(
                future: getQuote(),
                builder: (context, snapshot){

                  if (snapshot.hasData){


                    return Center(
                      child: Column(

                          children: <Widget>[

                            Text(snapshot.data.secciones.elementAt(0).seccion),

                            SizedBox(
                              height: 10.0,
                            ),
                            Text(" - ${snapshot.data.descripcion}"),
                          ]
                      ),

                    );
                  }

                  else if
                  (snapshot.hasError) { //checks if the response throws an error
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),*/

                  child:  ComboBoxDinamico(valores: data.secciones[0].campos[0].valores),
                  ),
              Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                child: Row(

                  children: <Widget>[
                    CheckBoxDinamico(campo: data.secciones[1].campos[7],)

                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),

                child: Row(

                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Text(
                        'Datos del titular',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: colorLetters,
                            fontSize: 19),
                      ),

                    ),







                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                child: Row(

                  children: <Widget>[
                   // CalendarioDinamico()

                  ],
                ),

              ),
              Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                child: Row(

                  children: <Widget>[



                    Container(
                      child: Row(

                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: Text(
                                'Imagen1'
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Text(
                                'Imagen2'

                            ),

                          ),
                        ],

                      ),
                    ),

                    Container(
                      child: Row(

                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: Text(
                              'Hombre',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: colorLetters,
                                  fontSize: 19),

                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Mujer',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: colorLetters,
                                  fontSize: 19),

                            ),

                          ),
                        ],

                      ),

                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                      child: Row(

                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Nombre'
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                      child: Row(

                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Apellidos'
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              ),



              Container(
                margin: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 24, bottom: 0),
                child: Row(

                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Edad'
                        ),

                      ),

                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'C.P'),

                      ),

                    ),
                  ],

                ),

              ),




            ],
          ),
        ),

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


