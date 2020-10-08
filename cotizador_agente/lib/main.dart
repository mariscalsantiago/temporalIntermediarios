import 'dart:convert';
import 'package:cotizador_agente/CotizadorUnicoLauncher.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:cotizador_agente/utils/validadores.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*void main() {
  runApp(
    LoadingProvider(
      child: MyApp(),
    ),
  );
}*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    apikeyPagoLinea: 'l7xxd3a72b3db531458493474a557c4ab23e',
    apikeyCampanias: 'l7xx3ecf012faeb4498995715f536c717be8',
    serviceEndPointCuentas: "",
    serviceEventos: "",
    serviceEndPoint: 'http://10.67.83.12/AppCobros/rest/',
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
  //  serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCABonos:'04985d13-d1d4-4032-9fe6-faa14c18d464',
    serviceBonosLogin:'https://api-qa.oscp.gnp.com.mx/bca-bonos/BCABonosSegundoPwd',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',
    apikeyBCABusqueda: '6d27171d-56ab-4bd2-8188-60f06741ac79',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    serviceSolicitud: 'https://solicituddigital-qa.gnp.com.mx',
    serviceHerramientasGM: 'https://test28022019-dot-gnp-pymesgmm-prod.appspot.com',
    serviceHerramientasRC: 'https://gnp-mirc-qa.appspot.com',
    servicePolizasClientesCards:"https://appagentes-qa.gnp.com.mx",
    service_Consulta_Cartera_Poliza:'https://api-qa.oscp.gnp.com.mx/crm-agente/consulta-cartera-poliza',
    service_Consulta_Cartera_Nombre:'https://api-qa.oscp.gnp.com.mx/crm-agente/consulta-cartera-nombre',
    service_perfilador: "https://api-qa.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api-qa.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    agentCod: "EHERNA978487",
    proyectId: 'gnp-appagentes-qa',
    apiKeyTipoDeCambio:'l7xx63f313ab37be41ecacb2301c7bbcad92',
    urlTipoDeCambio:'http://api.service.gnp.com.mx/sce/cut/recuperarTipoCambio',
    urlCampaniasService:'http://bca-ws-qa.gnp.com.mx',
    apiKeyCampaniasService:"d41d8cd98f00b204e9800998ecf8427e",
    urlNotifierService:'https://api-qa.oscp.gnp.com.mx',
    //urlProrrogadosService: 'https://api-dev.oscp.gnp.com.mx',
    apikeyCatalogo: 'l7xx47335731a26d4c93bf3f4288f644553d',
    serviceConsolidar:'https://us-central1-gnp-baseunicaagentes-uat.cloudfunctions.net',
    urlVersatileHome: 'https://hogarversatil-qa.gnp.com.mx',
    liferayUrl:'http://35.209.236.248/menu-noticias',
    liferayUrlEventos:'http://35.239.6.76/web/eventosgnp',
    liferayUrlBonos:'http://35.209.236.248/',
    repairFollow :'https://seguimientosiniestrosautos-qa.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    privacyAdvertisement :'http://35.209.236.248/aviso',
    formatsService :'https://us-central1-gnp-appagentes-qa.cloudfunctions.net/formatos-consulta-contenido',
    formatsServiceKey :'5f2b7910efbb4167936b051fa0f35f82',
    negocioProtegido :'https://negocioprotegido-qa.gnp.com.mx/agentes/',
    servicioDeEncriptado :'https://negocioprotegido-qa.gnp.com.mx/service/validation/v1/encriptarDatosCotizador',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/COT_CF_ConsultaNegocioCanal',
    urlCotizadores: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/negocio',
    urlGeneraCotizacion: 'https://gmm-cotizadores-qa.gnp.com.mx/orquestador-cotizador/generar-cotizacion',
    urlBorraCotizacion: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/borrarCotizacion',
    urlFormatoPDF: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/formato',
    urlCotizacionesGuardadas: 'http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/cotizaciones',
    urlFormularioPaso1: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/aplicacion?idAplicacion=',
    urlFormularioPaso2: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizador/aplicacion/',
    urlGuardaCotizacion: 'https://gmm-cotizadores-qa.gnp.com.mx/persisteCotizaciones/guardaCotizacion',
    urlEnviaEmail: 'https://gmm-cotizadores-qa.gnp.com.mx/cotizacion/correo',
    urlAnalytics: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=vistaPreviaMovil&dataLayer=',
    urlAccionDescarga: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=descargarMovil&dataLayer=',
    urlAccionEnviaCot: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=cotizacionMovil&dataLayer=',
    urlAccionEnviaMail: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=envioMovil&dataLayer=',
    urlAccionComparativa: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=comparativaMovil&dataLayer=',
    urlAccionIngreso: 'https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=ingresoMovil&dataLayer=',

    child: new MyApp(),
  );

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
  runApp(configuredApp);
  // });
  // runApp(configuredApp);
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
