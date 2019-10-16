import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/CotizacionesGuardadas.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
import 'package:flutter/cupertino.dart';

import 'package:cotizador_agente/utils/validadores.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/vistas/Cotizacion.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    LoadingProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      key: scaffoldKey,
      home: MyHomePage(title: 'GNP'),

     // home: CotizacionVista(),
     // home: CotizacionesGuardadas(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(scaffoldKey);
}

class _MyHomePageState extends State<MyHomePage> with Validadores {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey;

  _MyHomePageState(this.scaffoldKey);

  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {};

  final LocalStorage storage = new LocalStorage('formulario_1');

  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;
  bool isLoading = true;

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

  agregarAlDiccionario(String key, String value) {
    setState(() {
      //El metodo que ya funciona
      print("llegue al metodo del diccionario");
      createDoc[key] = value;
      print(createDoc);
      guardarLocalStorage();

      // Otro metodo
      storage.setItem(key, createDoc);
      print("esto etoy guardando" + json.encode(storage.getItem(key)));
    });
  }

  guardarLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'PASO1';
    prefs.setString(key, createDoc.toString());

    final value = prefs.getString(key) ?? "no hay";
    print('read: $value');
  }

  Formulario data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://35.232.57.52:8008/cotizador/aplicacion?id_aplicacion=1438"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));
      this.setState(() {
        //data = json.decode(response.body);
        isLoading = false;
        data = Formulario.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load post');
    }

    return "Success!";
  }

  @override
  void initState() {
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

        title: Text("GNP"),

      ),

      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Container(
            color: Utilidades.sombra,
            child: Row(

              children: <Widget>[

                Expanded(
                  flex: 7,

                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      textColor: Utilidades.color_primario,
                      child: Text("COTIZACIONES GUARDADAS"),
                      onPressed: () {},
                      borderSide: BorderSide(
                        color: Utilidades.color_primario, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.8, //width of the border
                      ),
                    ),
                  ),

                ),



                Expanded(

                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: (
                        PopupMenuButton(

                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                "Guardar",
                                style: TextStyle(
                                    color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                "Limpiar datos",
                                style: TextStyle(
                                    color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Text(
                                "Imprimir",
                                style: TextStyle(
                                    color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                              ),
                            ),
                            PopupMenuItem(
                              value: 4,
                              child: Text(
                                "Material de apoyo",
                                style: TextStyle(
                                    color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                          initialValue: 2,
                          onCanceled: () {
                            print("You have canceled the menu.");
                          },
                          onSelected: (value) {
                            print("value:$value");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "MÁS",
                                style: TextStyle(fontSize: 14.0, color: Utilidades.color_primario),
                                textAlign: TextAlign.right,

                              ),
                              Icon(Icons.more_vert, color: Utilidades.color_primario,),
                            ],
                          ),
                        )

                    ),
                  ),

                ),

              ],


            ),
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Divider( //002e71
                      thickness: 2,
                      color: Utilidades.color_titulo,

                      height: 0,
                    )),
              ),
            ],
          ),

          Expanded(

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
                      child: new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: data.secciones[index], i:index, end:data.secciones.length-1, cantidad_asegurados: data.cantidad_asegurados, formKey: formKey,),

                    );

                  }


              ),
            ),

          ),
        ]),
      );
  }
}
