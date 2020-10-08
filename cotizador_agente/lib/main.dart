import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/CotizadorUnicoLauncher.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/CotizacionesGuardadas.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
import 'package:cotizador_agente/vistas/SendEmail.dart';
import 'package:flutter/cupertino.dart';

import 'package:cotizador_agente/utils/validadores.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/vistas/Cotizacion.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // español
      ],
        debugShowCheckedModeBanner: false,
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      key: scaffoldKey,
      home: SeleccionaCotizadorUnicoGMM(),
      //  home: SendEmail(),
      //home: CotizacionVista(),
      //home: CotizacionesGuardadas(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  String cotizador;
  Cotizacion cotizacionGuardada;
  bool estaCargando = true;
  List<Seccion> seccionesPaso1;
  bool deboMostrarAlertaPrecarga = true;
  bool deboReemplazarGuardada = false;

  @override
  _MyHomePageState createState() => _MyHomePageState(scaffoldKey);
}

class _MyHomePageState extends State<MyHomePage> with Validadores {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey;

  _MyHomePageState(this.scaffoldKey);

  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {};

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

  getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://gmm-cotizadores-uat.gnp.com.mx/cotizador/aplicacion?idAplicacion=2343"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));
      this.setState(() {
        //data = json.decode(response.body);
        isLoading = false;
        FormularioCotizacion formularioCotizacion = FormularioCotizacion();
        PasoFormulario estePaso = PasoFormulario.fromJson(json.decode(response.body));
        formularioCotizacion.paso1=estePaso;

        if(widget.cotizacionGuardada != null){
          if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().comparativa == null){

            if(widget.deboReemplazarGuardada){

              Utilidades.cotizacionesApp.listaCotizaciones.last = formularioCotizacion;

              widget.deboReemplazarGuardada = false;

            }else{
              Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);

            }

            //Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = widget.cotizacionGuardada.idPlan;

          }
          else{

            Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);

          }


          Map<String,dynamic> resumenSecciones = json.decode(widget.cotizacionGuardada.responseResumen);

          var lista_secciones = resumenSecciones['seccion'] as List;

          lista_secciones.forEach((s){
            var lista_campos = s['valores'] as List;
            int id_Seccion = s["idSeccion"];

            if(lista_campos != null && lista_campos.length > 0){


              if(lista_campos[0]["valores"] != null){
                //La lista campos se convierte en lista de secciones child

                estePaso.secciones.forEach((seccion_mult){

                  if(seccion_mult.id_seccion == id_Seccion){
                    for(int i=0; i< lista_campos.length; i++){

                      seccion_mult.addChild();

                      var lista_camposmult = lista_campos[i]["valores"] as List;

                      for(int j=0; j<lista_camposmult.length; j++){

                        if(lista_camposmult[j]["valor"] != null){

                          Campo campo_result = estePaso.buscarCampoPorID(seccion_mult.children_secc[i].campos, lista_camposmult[j]["idCampo"], false);

                          if(campo_result != null){
                            campo_result.valor = lista_camposmult[j]["valor"].toString();


                          }

                        }
                      }




                    }

                  }

                });


              }else{
                lista_campos.forEach((esteCampo){


                  if(esteCampo["valor"] != null){
                    List<Campo> campos = Utilidades.buscaCampoPorID(id_Seccion, esteCampo["idCampo"], false);
                    if(campos != null){
                      campos[0].valor = esteCampo["valor"].toString();

                      if (campos[0].seccion_dependiente != null) {

                        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
                            int.parse(campos[0].seccion_dependiente),
                            int.parse(campos[0].valor));
                      }

                    }
                  }

                });
              }

            }
          });

          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3].campos[0].valor;
          //_onAfterBuild(context);



        }else {
          if (!Utilidades.editarEnComparativa) {
            Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);
          } else {
            Utilidades.editarEnComparativa = false;
          }
        }
      });
    } else {
      print("VVV");
      throw Exception('Failed to load post');
    }

    return "Success!";
  }

  @override
  void initState() {

    if(Utilidades.idAplicacion != null){
      widget.cotizador = Utilidades.idAplicacion.toString();
    }

    if(widget.cotizador != null){

      this.getData().then((success){ //Validar que este cotizador sea válido.

        if(success!=null){
          print("Success es: "+ success.toString());
        }else{
          print("Success es: null");

        }

        if(success){
          bool encontrePlanes = false;
          List<Seccion> s = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;

          s.forEach((f){
            if(f.id_seccion == 6){
              encontrePlanes = true;

            }
          });

          if(!encontrePlanes){
            Navigator.pop(context);

            Utilidades.mostrarAlerta("Error", Mensajes.errorConfig, context);

          }else{

            //Este cotizador es válido
            if(widget.cotizacionGuardada!=null){
              _onAfterBuild(context);
            }

          }
        }else{
          setState(() {
            isLoading = true;
          });
        }
      });


    }else {
      isLoading = false;
      Navigator.pop(context);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-90.0, 0.0), Offset(90.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _onAfterBuild(BuildContext context){

    if(widget.cotizacionGuardada != null  && (isLoading==false) & Utilidades.cargarNuevoPaso){ //Mandar a paso 2


      List <Seccion> secciones = new List<Seccion>();
      secciones.add( Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);

      backPaso1(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones);

      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = widget.cotizacionGuardada.idPlan;
      Utilidades.buscaCampoPorID(Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor = widget.cotizacionGuardada.idPlan;
      Utilidades.cargarNuevoPaso  =false;

      var valor = secciones[0].campos[0].valores.firstWhere((v) => v.id == widget.cotizacionGuardada.idPlan);

      if(valor.visible == true) {


        if(widget.deboMostrarAlertaPrecarga){
          Utilidades.mostrarAlerta(Mensajes.titleCotRec, Mensajes.propRestablecida, context);
          widget.deboMostrarAlertaPrecarga = false;

        }



      }
      else {
        var titulo = "Aviso";
        var mensaje = Mensajes.recuperarPlan;
        showDialog(
            context: context,
            builder: (context2) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(titulo),
                content: new Text(mensaje),
                actions: <Widget>[
                  FlatButton(
                    child: new Text(
                      "Aceptar",
                      style: TextStyle(color: Utilidades.color_primario),
                    ),
                    onPressed: () {
                      Navigator.pop(context2);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }

    }

  }

  void backPaso1(List<Seccion> secciones) {
    widget.seccionesPaso1 = backPaso1Child(secciones);
  }

  List<Seccion> backPaso1Child(List<Seccion> secciones) {
    List<Seccion> _secciones = List<Seccion>();
    for(Seccion seccion in secciones) {
      List<Campo> _campos = List<Campo>();
      for(var campo in seccion.campos)
      {
        Campo _campo = Campo(id_campo: campo.id_campo, valor: campo.valor, id_seccion: campo.id_seccion);
        _campos.add(_campo);
      }
      Seccion _seccion = Seccion(id_seccion: seccion.id_seccion, seccion: seccion.seccion, multiplicador: seccion.multiplicador, campos: _campos );

      if(seccion.multiplicador>0) {
        _seccion.children_secc = backPaso1Child(seccion.children_secc);
      }

      _secciones.add(_seccion);
    }
    return _secciones;
  }

  bool verifyPaso1(List<Seccion> secciones) {
    return verifyPaso1Child(secciones, widget.seccionesPaso1, true);
  }

  bool verifyPaso1Child(List<Seccion> secciones, List<Seccion> seccionesBack, bool byIdSeccion) {
    bool verify = true;

    if(secciones == null || seccionesBack == null) {
      return false;
    }

    if(secciones.length == seccionesBack.length) {
      for(Seccion seccion in secciones) {
        var _seccion = byIdSeccion ? seccionesBack.singleWhere((s) => s.id_seccion == seccion.id_seccion) : seccionesBack.singleWhere((s) => s.seccion == seccion.seccion);
        if(seccion.multiplicador>0) {
          bool result = verifyPaso1Child(seccion.children_secc, _seccion.children_secc, false);
          if(!result) {
            return false;
          }
        }
        else {
          if(_seccion != null) {
            for(Campo campo in seccion.campos) {
              var _campo = _seccion.campos.singleWhere((c) => (c.id_seccion == campo.id_seccion) && (c.id_campo == campo.id_campo));
              if(campo != null) {
                verify = (campo.valor == _campo.valor);
                if(!verify) {
                  return false;
                }
              }
              else {
                verify = false;
              }
            }
          }
          else {
            verify = false;
          }
        }
      }
    }
    else {
      return false;
    }

    return verify;
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
            child: FlatButton(
                onPressed:(){ SeleccionaCotizadorUnicoGMM();}, child: null),
          ),

          /*Container(
            color: Utilidades.color_sombra,
            child: Row( //Barra de menú superior
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      textColor: Utilidades.color_primario,
                      child: Text("COTIZACIONES GUARDADAS"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CotizacionesGuardadas(),
                            ));
                      },
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
          ),*/

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
          /****** Termina panel superior *******/


          /****** Comienza panel de coti *******/

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
