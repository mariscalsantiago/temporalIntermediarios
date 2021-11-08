import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/CotizadorUnico/FormularioPaso2.dart';
import 'package:cotizador_agente/CotizadorUnico/MisCotizaciones.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;
import 'package:jiffy/jiffy.dart';

bool isChangeicon1 = true;
bool isChangeicon2 = true;

//Campos formulario uno
bool tieneEdad = false;
bool tieneCP = false;
String valorPlan = "";
String valorEtiquetaPlan = "";
bool esPlanGuardado = false;
bool seRequiereAntiguedad = false;
bool esCarteraAnterior = false;
bool seRequiereGarantiaCoaseguro = false;
bool nuevaCotizacionDesdeMisCotizaciones = false;
String valorTipoCartera;

class FormularioPaso1 extends StatefulWidget {
  FormularioPaso1({Key key,  this.scaffoldKey, this.cotizador, this.cotizacionGuardada}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  String cotizador;
  Cotizacion cotizacionGuardada;
  bool estaCargando = true;
  List<Seccion> seccionesPaso1;
  bool deboMostrarAlertaPrecarga = true;
  bool deboReemplazarGuardada = false;

  //List<Seccion> _secciones = [];//Cotización guardada

  bool validarCodigoPostalFamiliares() {
    var titular = Utilidades.buscaCampoPorID(
        Utilidades.titularSeccion, Utilidades.titularCampo, false);
    if (titular.length > 0) {
      var _titular = titular[0];
      var familiares = Utilidades.buscaCampoPorID(
          Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
      if (familiares != null) {
        return (familiares.length > 0 && familiares[0].valor != null);
      }
    }
    return false;
  }


  @override
  _FormularioPaso1State createState() => _FormularioPaso1State(scaffoldKey);
}

class _FormularioPaso1State extends State<FormularioPaso1> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey;
  String plan;
  bool preCargaFinalizada = false;
  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {};

  bool reNew = false;

  bool isLoading = true;
  PasoFormulario paso_2;
  String recargacotizador;
  String platform = "";
  bool isOpen = true;
  bool isClose = false;


  void actualizarCodigoPostalFamiliares() {
    setState(() {
      var titular = Utilidades.buscaCampoPorID(Utilidades.titularSeccion, Utilidades.titularCampo, false);
      if (titular.length > 0) {
        var _titular = titular[0];
        var familiares = Utilidades.buscaCampoPorID(
            Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
        if (familiares != null) {
          for (var familiar in familiares) {
            if(familiar.valor == null || Utilidades.actualizarCodigoPostalAdicional){
              familiar.valor = _titular.valor;
            }
          }
          Utilidades.actualizarCodigoPostalAdicional = false;
          var _seccionesFamiliares = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.where((s) => s.id_seccion==Utilidades.familiarSeccion).toList();
          for(var _seccion in _seccionesFamiliares) {
            var _campos = _seccion.campos.where((c)=>c.id_campo==Utilidades.familiarCampo).toList();
            for(var _campo in _campos) {
              _campo.valor = _titular.valor;
            }
          }
        }
      }
    });
  }

  void borrarAdicional(int hashCode) {
    setState(() {
      List<Seccion> seccionesAdicionales = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;
      seccionesAdicionales = seccionesAdicionales.where((s) => s.id_seccion == Utilidades.familiarSeccion).toList();
      for(Seccion seccion in seccionesAdicionales) {
        if (seccion.cont_child >= 1)
          seccion.cont_child -= 1;
        if (seccion.children_secc!=null) {
          seccion.children_secc.removeWhere((item) => item.hashCode == hashCode);
          int _c = 1;
          for(Seccion seccionChild in seccion.children_secc) {
            seccionChild.seccion = "Adicional " + _c.toString();
            _c += 1;
          }
        }
      }
      //widget._secciones = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;
    });
    actualizarVistaConNuevoPlan(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan);
  }

  _FormularioPaso1State(this.scaffoldKey);

  refresh() {
    setState(() {});
  }


  void recargar(){
    setState(() {

      Navigator.pop(context);
      setState(() {
        tieneEdad = false;
        tieneCP = false;
        isLoading = true;
      });
      Utilidades.cotizacionesApp.eliminarDeLaComparativa(Utilidades.cotizacionesApp.getCurrentLengthLista()-1);
      widget.cotizacionGuardada = null;
      this.getData().then((success){

        if(success == false){
          setState(() {
            isLoading = true;
          });
        }else{
          isLoading = false;
        }
      });
    });

  }

  agregarAlDiccionario(String key, String value) {
    print("Actulizar Vista---->");
    setState(() {
      isLoading = true;
      Utilidades.isloadingPlan = true;
    });
    setState(() {
      isLoading = false;
      Utilidades.isloadingPlan = false;
    });
  }

  actualizarVista() async{

    print("Actulizar Vista---->");
    setState(() {
      isLoading = true;
      Utilidades.isloadingPlan = true;
    });
    final result = await InternetAddress.lookup('google.com');
    setState(() {
      isLoading = false;
      Utilidades.isloadingPlan = false;
    });
  }

  limpiarCotizaciones(){
    for(int i =0; i < Utilidades.cotizacionesApp.listaCotizaciones.length; i++){
      if(Utilidades.cotizacionesApp.listaCotizaciones[i].idPlan == null && Utilidades.cotizacionesApp.listaCotizaciones[i].paso2 == null){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      } else if(Utilidades.cotizacionesApp.listaCotizaciones[i].seCotizo == false && Utilidades.cotizacionesApp.listaCotizaciones[i].paso2 != null ){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      }
    }
  }

  validarRestaurarCotizacionDeEdicion(){
    /*if(Utilidades.entroAEditar){
      //aun para la funcionalidad comentar el for
      *//*for(int i =0; i < Utilidades.cotizacionesApp.listaCotizaciones.length; i++){
        if(i == Utilidades.indexcotizacionEditadaARecuperar){
          setState(() {
            Utilidades.cotizacionesApp.listaCotizaciones[i] = Utilidades.cotizacionEditadaARecuperar;
            Utilidades.entroAEditar = false;
            Utilidades.cotizacionEditadaARecuperar = null;
          });
        }
      }*//*
      for(int i = Utilidades.cotizacionesApp.listaCotizaciones.length -1; i > 0; i--){
        if(Utilidades.cotizacionesApp.listaCotizaciones[i].requestCotizacion == null){
          Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
        }
      }
      Utilidades.entroAEditar = false;
    }*/
    for(int i = Utilidades.cotizacionesApp.listaCotizaciones.length -1; i > 0; i--){
      if(Utilidades.cotizacionesApp.listaCotizaciones[i].requestCotizacion == null){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      }
    }
  }

  getData() async {
    /*String dataLocal = await DefaultAssetBundle.of(context).loadString("assets/jsonLocalPaso1.json");
    String dataLocalDos = await DefaultAssetBundle.of(context).loadString("assets/jsonLocalPaso2.json");
    dataLocal = dataLocal.replaceAll("\n", "");*/

    final Trace data = FirebasePerformance.instance.newTrace("CotizadorUnico_GetPasoUno");
    data.start();
    print(data.name);
    bool success = false;


    try{

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        setState(() {
          isLoading = true;
        });

        try{
          Map<String, String> headers = {"Accept": "application/json", "Authorization" : loginData.jwt.toString()};

          var response = await http.get(Uri.encodeFull(Utilidades.url+ "?idAplicacion=" + widget.cotizador), headers: headers);
          print("URL PASO1 ${Utilidades.url+ "?idAplicacion=" + widget.cotizador}");

          int statusCode = response.statusCode;

          if(response != null){
            if(response.body != null && response.body.isNotEmpty){

              if (statusCode == 200) {
                data.stop();
                success = true;
                Utilidades.entroUrlPaso1 = true;
                this.setState(() {
                  isLoading = false;

                  FormularioCotizacion formularioCotizacion = FormularioCotizacion();
                  PasoFormulario estePaso = PasoFormulario.fromJson(json.decode(response.body));
                  formularioCotizacion.paso1=estePaso;
                  Utilidades.urlSiguiente = estePaso.urlSiguiente;
                  //actualizarVistaConNuevoPlan("6");

                  /*FormularioCotizacion formularioCotizacionDos = FormularioCotizacion();
                  PasoFormulario estePasoDos = PasoFormulario.fromJson(json.decode(dataLocalDos));
                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2 =  estePasoDos;*/


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


                  } else if (Utilidades.agregarNuevaCotizacion) {
                    Utilidades.agregarNuevaCotizacion = false;
                    int contadorUltimaCotizacion = Utilidades.cotizacionesApp.listaCotizaciones.length - 1;
                    final ultimaCotizacion = Utilidades.cotizacionesApp.listaCotizaciones[contadorUltimaCotizacion];
                    final paso1 = ultimaCotizacion.paso1;
                    final paso1Copia = paso1.copy();
                    final paso2 = ultimaCotizacion.paso2;
                    final paso2Copia = paso2.copy();
                    final copia = FormularioCotizacion(
                      paso1: paso1Copia,
                      paso2: paso2Copia,
                    );
                    copia.idPlan = ultimaCotizacion.idPlan;
                    Utilidades.cotizacionesApp.agregarCotizacion(copia);
                    //Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = Utilidades.cotizacionesApp.listaCotizaciones[contadorUltimaCotizacion].idPlan;
                    Utilidades.enviadoBotonAgregarCotizacion = true;

                  }else{
                    if(!Utilidades.editarEnComparativa){
                      if(Utilidades.entroAEditar){
                        Utilidades.cotizacionesApp.agregarCotizacion(Utilidades.cotizacionEditadaARecuperar);
                      }else{
                        Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);
                      }
                    }else{
                      Utilidades.editarEnComparativa = false;
                    }

                  }

                });
              }else if(statusCode != null){
                data.stop();
                isLoading = false;
                Navigator.pop(context);
                String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), message, context);
              }
              // return "Success!";

            }else{
              data.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                getData();
              });
            }
          }else{
            data.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              getData();
            });
          }

        }catch(e){
          data.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            getData();
          });
        }


      }else{
        data.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          getData();
        });
      }

    }catch(e){
      data.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        getData();
      });

    }
    return success;
  }

  @override
  void initState() {

    if(Utilidades.idAplicacion != null){
      widget.cotizador = Utilidades.idAplicacion.toString();
    }

    if(widget.cotizador != null){

      this.getData().then((success){ //Validar que este cotizador sea válido.

        //ENVIAR ANALYTICS
        Utilidades.sendAnalytics(context, "Acciones", "Ingreso");
        if(success!=null){
          print("Success es: "+ success.toString());
        }else{
          print("Success es: null");

        }

        if(success){
          bool encontrePlanes = false;
          List<Seccion> s = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;

          //encontrePlanes = true;
          s.forEach((f){
            //print("f --- ${f.id_seccion}");
            if(f.id_seccion == 1){
              f.campos.forEach((c) {
                if(c.id_campo == 18){
                  valorTipoCartera = c.valor;
                  c.valores.forEach((element) {
                    element.children.forEach((children) {
                      print("children.id_campo  ${children.id_campo}");
                      if(children.valores.length > 0){
                        encontrePlanes = true;
                      }
                    });
                  });
                }
              });
            }else if(f.id_seccion == 6){
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
              actualizarVistaConNuevoPlan( Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan);
            }
            if(Utilidades.enviadoBotonAgregarCotizacion){
              Utilidades.enviadoBotonAgregarCotizacion = false;
              _onAfterBuild(context);
              actualizarVistaConNuevoPlan( Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan);
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

  void _onAfterBuild(BuildContext context){
    setState(() {
      tieneCP = true;
      tieneEdad = true;
    });

    if(widget.cotizacionGuardada != null  && (isLoading==false) & Utilidades.cargarNuevoPaso){ //Mandar a paso 2


      List <Seccion> secciones = new List<Seccion>();
      secciones.add( Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);

      backPaso1(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones);

      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = widget.cotizacionGuardada.idPlan;
      setState(() {
        valorPlan = widget.cotizacionGuardada.idPlan;
      });

      //Utilidades.buscaCampoPorID(Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor = widget.cotizacionGuardada.idPlan;
      Utilidades.cargarNuevoPaso  =false;

      //var valor = secciones[0].campos[0].valores.firstWhere((v) => v.id == widget.cotizacionGuardada.idPlan);

      if(true) {


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

  bool validarCodigoPostalFamiliares() {
    var titular = Utilidades.buscaCampoPorID(
        Utilidades.titularSeccion, Utilidades.titularCampo, false);
    if (titular.length > 0) {
      var _titular = titular[0];
      var familiares = Utilidades.buscaCampoPorID(
          Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
      if (familiares != null) {
        return (familiares.length > 0);
      }
    }
    return false;
  }

  cargarSiguientePaso(Map<String, dynamic> map_plan, BuildContext context) async {
    /*String dataLocal = await DefaultAssetBundle.of(context).loadString("assets/jsonLocalPaso2.json");
    dataLocal = dataLocal.replaceAll("\n", "");
    print(map_plan.toString());*/

    setState(() {
      isLoading = true;
    });
    final Trace cargaPaso = FirebasePerformance.instance.newTrace("CotizadorUnico_PasoDos");
    cargaPaso.start();
    print(cargaPaso.name);
    bool success = false;

    try{
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try{

          Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

          String valor = json.encode(map_plan);

          var response = await http.post(Utilidades.urlSiguiente, body: json.encode(map_plan), headers: headers);
          print("URL PASO2  ${Utilidades.url}");
          print("body   ${json.encode(map_plan)}");
          print("map   ${map_plan}");
          print("JWT    ${loginData.jwt}");

          print("Response  ${response.body}");
          int statusCode = response.statusCode;

          if(response != null) {
            if (response.body != null && response.body.isNotEmpty && response != null) {

              setState(() {


                PasoFormulario estePaso = PasoFormulario.fromJson(json.decode(response.body));
                Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2 =  estePaso;
                Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan= plan;

                for(int i = 0; i < Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length; i++){
                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[i].opened = true;
                }
                //var lista_sec = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2['seccion'] as List;
                //print("s--> ${lista_sec}");
                /*lista_sec.forEach((s){

                });*/
                if(widget.cotizacionGuardada != null && (preCargaFinalizada == false)){
                  preCargaFinalizada = true;
                  Map<String,dynamic> resumenSecciones = json.decode(widget.cotizacionGuardada.responseResumen);

                  if(resumenSecciones != null){
                    var lista_secciones = resumenSecciones['seccion'] as List;

                    lista_secciones.forEach((s){
                      print("s ----> ${s}");
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

                          estePaso.secciones.forEach((secciones_este_paso){
                            if(secciones_este_paso.id_seccion == id_Seccion){
                              for(int i=0; i< lista_campos.length; i++){

                                Campo c = estePaso.buscarCampoPorID(secciones_este_paso.campos, lista_campos[i]["idCampo"], false);

                                if(c!=null){
                                  if(c.tipo_componente!= "card"){

                                    //print(c.nombre_campo);

                                    if(c.tipo_componente!="textbox" && c.tipo_componente!="checkbox" && c.tipo_componente!="date_relativa"){

                                      bool valorDisponible = false;
                                      if(c.valores!=null){
                                        for(int j = 0; j< c.valores.length; j++){

                                          if(lista_campos[i]["valor"].toString() == c.valores[j].id){
                                            valorDisponible = true;
                                            break;
                                          }

                                        }
                                      }

                                      if(valorDisponible){
                                        c.valor = lista_campos[i]["valor"].toString();
                                        if (c.seccion_dependiente != null) {
                                          //print("voy a filtrar la seccion"+ c.seccion_dependiente);
                                          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
                                              int.parse(c.seccion_dependiente),
                                              int.parse(c.valor));
                                        }

                                        if(c.oculta){

                                          //ocultar campos
                                          c.valores.forEach((valor){
                                            if(valor.id == c.valor){
                                              if(valor.oculta_campos.length>0){
                                                //print("Este valor:"+ valor.descripcion.toString()+ ", oculta campos");
                                                valor.oculta_campos.forEach((referencia){
                                                  List <Campo> campos  =  Utilidades.buscaCampoPorID(referencia.id_seccion, referencia.id_campo, true);
                                                  if(campos!=null){
                                                    campos.forEach((campo){
                                                      //print("El campo a ocultar es: "+ campo.etiqueta.toString());


                                                      //Se oculta el valor del campo padre
                                                      if(campo.parent_campo!=null){
                                                        Campo campo_padre = Utilidades.buscaCampoPorID(campo.parent_campo.id_seccion, campo.parent_campo.id_campo, true)[0];
                                                        //print("Campo Padre es: "+campo_padre.etiqueta);


                                                        if(campo_padre.valores!=null){
                                                          //campo_padre.filtrarHijos(campo.id_campo.toString());
                                                          if(campo_padre.valor == campo.id_campo.toString()){

                                                            bool esValorNoVisible = true;
                                                            String id_inicial;
                                                            //Verificar que el valor inicial sea visible.
                                                            for (int i = 0; i<campo_padre.valores.length && esValorNoVisible; i++){
                                                              if(campo_padre.valores[i].visible){
                                                                esValorNoVisible = false;
                                                                id_inicial= campo_padre.valores[i].id;
                                                              }
                                                            }
                                                            campo_padre.valor =  id_inicial;

                                                          }

                                                          campo_padre.valores.forEach((valor){

                                                            if(valor.id==campo.id_campo.toString()){
                                                              valor.visible= false;
                                                            }
                                                          });

                                                        }

                                                      }else{
                                                        print("El campo padre es null");
                                                      }

                                                      //Se oculta el campo
                                                      // print("oculto el campo"+ campo.etiqueta);
                                                      campo.visible = false;
                                                      campo.visibleLocal = false;
                                                      // print("oculto el campo"+ campo.etiqueta+ campo.visible.toString());


                                                      c.campos_modificados.add(referencia);
                                                      // print("Se agrego la referencia"+ referencia.id_campo.toString());


                                                    });
                                                  }
                                                });
                                              }
                                            }
                                          });

                                        }

                                      }
                                    }else{
                                      c.valor = lista_campos[i]["valor"].toString();
                                    }

                                  }

                                }

                              }
                            }
                          });

                        }

                      }
                    });

                    Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan= plan;
                  }

                }

              });

              cargaPaso.stop();
              setState(() {
                isLoading = false;
                Utilidades.isloadingPlan = false;
                success = true;
              });

              /*if(statusCode == 200){
                cargaPaso.stop();
                setState(() {
                  isLoading = false;
                  Utilidades.isloadingPlan = false;
                  success = true;
                });

              }else if(statusCode == 400){
                cargaPaso.stop();
                setState(() {
                  isLoading = false;
                  Utilidades.isloadingPlan = false;
                });

                Navigator.pop(context);
                Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);

              }
              else if(statusCode != null){
                cargaPaso.stop();
                Navigator.pop(context);
                String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                Utilidades.mostrarAlerta(Mensajes.titleError + statusCode.toString(),message, context);

                setState(() {
                  isLoading = false;
                  success = true;
                  Utilidades.isloadingPlan = false;
                });

              }*/

            } else {
              cargaPaso.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                cargarSiguientePaso(map_plan, context);
              });
            }
          }else{
            cargaPaso.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              cargarSiguientePaso(map_plan, context);
            });
          }

        }catch(e){
          cargaPaso.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            cargarSiguientePaso(map_plan, context);
          });
        }
      }else {
        cargaPaso.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          cargarSiguientePaso(map_plan, context);
        });
      }
    }catch(e){
      cargaPaso.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        cargarSiguientePaso(map_plan, context);
      });
    }

    return success;

  }

  actualizarVistaConNuevoPlan(String p) async{

    setState(() {
      Utilidades.isloadingPlan = true;
    });
    bool success = false;

    try{
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{

          plan = p;
          success = true;
          Map<String, dynamic> jsonMap = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON();

          Map<String, dynamic> map_gmm = jsonMap["cotizacionGMMRequest"];


          Map<String, dynamic> map_plan = {
            "idPlan":int.parse(p)
          };
          map_gmm.addAll(map_plan);

          jsonMap["cotizacionGMMRequest"]= map_gmm;


          Map<String, dynamic> map_titluar = jsonMap["cotizacionGMMRequest"]["titular"];
          if(jsonMap["cotizacionGMMRequest"]["titular"]["cp"] == ""){
            jsonMap["cotizacionGMMRequest"]["titular"]["cp"] = "00000";
          }
          Map<String, dynamic> map_id = {
            "id":1
          };
          map_titluar.addAll(map_id);


          bool hayMasAsegurados = true;
          int cont =0;
          while(hayMasAsegurados){
            try{
              jsonMap["cotizacionGMMRequest"]["asegurados"][cont]["id"] = cont+2;
            }catch(e){
              hayMasAsegurados = false;
            }
            cont++;
          }


          jsonMap["cotizacionGMMRequest"]["titular"] = map_titluar;
          final bool v = formKey.currentState.validate();
          cargarSiguientePaso(jsonMap["cotizacionGMMRequest"], context);

        }catch(e){
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            actualizarVistaConNuevoPlan(p);
          });
        }

      }else{
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          actualizarVistaConNuevoPlan(p);
        });
      }
    }catch(e){
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        actualizarVistaConNuevoPlan(p);
      });
    }

    return success;

  }

  void handleClick(String value) {
    switch (value) {
      case 'Guardar':
        print("Guardar -->");
        break;
      case 'Borrar datos':
        print("Limpiar Datos");
        Utilidades.mostrarAlertaCallbackBorrar(Mensajes.titleLimpia, Mensajes.limpiaDatos, context, (){
          Navigator.pop(context);

        }, (){

          if(formKey != null){
            formKey.currentState.reset();
            if(recargar!=null){
              recargar();
            }

            /*if(widget.recargarFormularioConPlan!=null){
              widget.recargarFormularioConPlan(widget.plan);
            }*/

            //Navigator.pop(context);
          }else {

            /*if(widget.recargarFormulario!=null){
              print("RECARGA");
              widget.recargarFormulario();

            }*/

            //Navigator.pop(context);
          }

        });
        break;
      case 'Mis cotizaciones':
        print("Mis cotizaciones -->");

        Navigator.push(context,  MaterialPageRoute(
          builder: (context) => CotizacionesGuardadas(seCreaNueva: true),
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));

    return GestureDetector(
      child: WillPopScope(
        onWillPop: () async {
          if(Utilidades.cotizacionesApp.getCurrentLengthLista()>1){
            //print("Estoy eliminando la index: "+ (Utilidades.cotizacionesApp.getCurrentLengthLista()-1).toString());
            //Utilidades.cotizacionesApp.eliminarDeLaComparativa(Utilidades.cotizacionesApp.getCurrentLengthLista()-1);

          }else{
            Navigator.of(context).popUntil(ModalRoute.withName('/cotizadorUnicoAP'));
          }
          validarRestaurarCotizacionDeEdicion();

          final cotizaciones = Utilidades.cotizacionesApp.listaCotizaciones;
          final cotizacionesLength = cotizaciones.length;
          if (cotizacionesLength > 1) {
            valorPlan = cotizaciones[cotizacionesLength - 1]?.idPlan;
            cotizaciones.removeAt(cotizacionesLength - 1);
          } else {
            valorPlan = cotizaciones.last.idPlan;
          }

          return true;
        },
        child: new Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: new Icon(Icons.arrow_back_ios,
                color: Utilidades.color_primario,
              ),
              onPressed: () {
                validarRestaurarCotizacionDeEdicion();
                Navigator.pop(context);
              },
            ),
            iconTheme: IconThemeData(color: Utilidades.color_primario),
            backgroundColor: Colors.white,
            title: Text("Cotizador GMM", style: TextStyle(color: Colors.black),),
            actions:[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Guardar', 'Borrar datos', 'Mis cotizaciones'}.map((String choice) {
                    return PopupMenuItem<String>(
                        value: choice,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: ColorsCotizador.color_Bordes),
                            choice == "Guardar" ? Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Text("ACCIONES", style: TextStyle(
                                  color: ColorsCotizador.color_Etiqueta,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
                                  letterSpacing: 0.15)
                              ),
                            ): Container(),
                            choice == "Mis cotizaciones" ? Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Text("SOPORTE", style: TextStyle(
                                  color: ColorsCotizador.color_Etiqueta,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
                                  letterSpacing: 0.15)
                              ),
                            ): Container(),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  !tieneEdad && !tieneCP &&  choice == "Guardar" ? Container(
                                    child: Text(choice, style: TextStyle(
                                        color: ColorsCotizador.color_disable,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        letterSpacing: 0.15)
                                    ),
                                  ) : Container(
                                    child: Text(choice, style: TextStyle(
                                        color: ColorsCotizador.color_appBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        letterSpacing: 0.15)
                                    ),
                                  ),
                                  tieneEdad && tieneCP &&  choice == "Guardar" ? Container(
                                      margin: EdgeInsets.only(left: 90),
                                      child: Image.asset("assets/icon/cotizador/guardar_Enabled.png", height: 25, width: 25)
                                  ):  !tieneEdad && !tieneCP &&  choice == "Guardar" ?  Container(
                                      margin: EdgeInsets.only(left: 90),
                                      child: Image.asset("assets/icon/cotizador/guardar_Disable.png", height: 25, width: 25)
                                  ) : Container(),
                                  choice == "Borrar datos" ? Container(
                                      margin: EdgeInsets.only(left: 45),
                                      child: Image.asset("assets/icon/cotizador/ic_borrar.png", height: 25, width: 25)
                                  ): Container(),
                                  choice == "Mis cotizaciones" ? Container(
                                      margin: EdgeInsets.only(right: 2),
                                      child: Image.asset("assets/icon/cotizador/miscotizaciones.png", height: 25, width: 25)
                                  ): Container(),
                                ],
                              ),
                            ),
                            choice == "Mis cotizaciones" ? Divider(color: ColorsCotizador.color_Bordes) : Container(),
                          ],
                        )
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Divider( //002e71
                            thickness: 2,
                            color: ColorsCotizador.primary700,

                            height: 0,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0, bottom: 0.0),
                  child: Container(
                    color: ColorsCotizador.color_background,
                    height: 74.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,top: 12.0,),
                          child: Image.asset("assets/icon/cotizador/paso1.png", height: 50, width: 50,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 16.0),
                          child: Text("Cotiza", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorsCotizador.gnpTextSytemt1),),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 13.0, top:10.0, bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              Visibility(visible: isOpen,
                                  child: IconButton(
                                    icon: Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                    onPressed: ((){
                                      //Mostrar container que indique en que paso se encuentra
                                      setState(() {
                                        isClose = true;
                                        isOpen = false;
                                      });
                                    }),)
                              ),
                              Visibility(visible: isClose,
                                  child: IconButton(
                                    icon: Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,),
                                    onPressed: ((){
                                      //Ocultar container que indique en que paso se encuentra
                                      setState(() {
                                        isClose = false;
                                        isOpen = true;
                                      });
                                    }),)
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: isClose,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 11.0),
                      child: Container(
                        color: ColorsCotizador.color_background,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 29.0),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: ColorsCotizador.color_borde, style: BorderStyle.solid, width: 1.0),
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(12.0),
                                            topRight: const Radius.circular(12.0),
                                            bottomLeft: const Radius.circular(12.0),
                                            bottomRight: const Radius.circular(12.0)
                                        ),
                                      ),
                                      child: Align( alignment: Alignment.center,
                                          child: Text("1", style: TextStyle(color: ColorsCotizador.secondary900,fontSize: 16, fontWeight: FontWeight.w400),textAlign: TextAlign.center,)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 29.0),
                                    child: Text("Cotiza", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorsCotizador.secondary900), textAlign: TextAlign.start,),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, top:0, bottom:0),
                                    child: Image.asset("assets/icon/cotizador/union.png", height: 24, width: 22,),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 29.0),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: ColorsCotizador.color_Bordes,
                                        border: Border.all(color: ColorsCotizador.color_Bordes, style: BorderStyle.solid, width: 1.0),
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(12.0),
                                            topRight: const Radius.circular(12.0),
                                            bottomLeft: const Radius.circular(12.0),
                                            bottomRight: const Radius.circular(12.0)
                                        ),
                                      ),
                                      child: Align( alignment: Alignment.center,
                                          child: Text("2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),textAlign: TextAlign.center,)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 29.0),
                                    child: Text("Elige", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorsCotizador.color_appBar),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                /****** Termina panel superior *******/


                /****** Comienza panel de coti *******/
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: (isLoading || (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion() == null)) ?
                        Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Utilidades.color_primario),),):
                        Column(
                          children: [
                            new ListView.builder(
                                itemCount: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: !Utilidades.
                                          cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              left: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              right: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              // bottom: BorderSide(width: 1.0,color: AppColors.color_Bordes),
                                            ),
                                          ),
                                          child: ExpansionTile(
                                            maintainState: true,
                                            onExpansionChanged: (value){
                                              setState(() {
                                                Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened = value;
                                              });
                                            },
                                            leading: (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened == true) ? Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,) : Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                            trailing: SizedBox.shrink(),
                                            initiallyExpanded: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened,
                                            title: Text(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].seccion,
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsCotizador.AzulGNP,
                                                fontFamily: "Roboto",
                                              ),),
                                            children: <Widget>[
                                              Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                              Container(
                                                margin:Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].id_seccion == 3 ? EdgeInsets.only(top: 30) : EdgeInsets.only(top: 0),
                                                color: ColorsCotizador.color_background_blanco,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                                  child: new SeccionDinamica(
                                                    agregarDicc:agregarAlDiccionario,
                                                    notifyParent:refresh,
                                                    secc: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index],
                                                    i:index,
                                                    end:Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length-1,
                                                    cantidad_asegurados: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.cantidad_asegurados,
                                                    formKey: formKey,
                                                    actualizarSecciones: actualizarVistaConNuevoPlan,
                                                    actulizarVistaParaFamiliar: actualizarVista,
                                                    actualizarCodigoPostalFamiliares:
                                                    actualizarCodigoPostalFamiliares,
                                                    validarCodigoPostalFamiliares:
                                                    widget.validarCodigoPostalFamiliares,
                                                    borrarAdicional: borrarAdicional,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: !Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                            Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2 != null ? new ListView.builder(
                                itemCount: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length-2,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: !Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].opened,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              left: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              right: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              // bottom: BorderSide(width: 1.0,color: AppColors.color_Bordes),
                                            ),
                                          ),
                                          child: ExpansionTile(
                                            onExpansionChanged: (value){
                                              setState(() {
                                                Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].opened = value;
                                              });
                                            },
                                            leading: (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].opened == true) ? Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,) : Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                            trailing: SizedBox.shrink(),
                                            initiallyExpanded: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].opened,
                                            title: Text(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].seccion != "Configuración Plan" ?
                                            Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index].seccion : "Plan - ${valorEtiquetaPlan}",
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsCotizador.AzulGNP,
                                                fontFamily: "Roboto",
                                              ),),
                                            children: <Widget>[
                                              Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                              Container(
                                                  color: ColorsCotizador.color_background_blanco,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child:
                                                    (isLoading == true || (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length-1)==0 )  ?
                                                    Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Utilidades.color_primario),),) :
                                                    new SeccionDinamica(
                                                      agregarDicc:agregarAlDiccionario,
                                                      notifyParent:refresh,
                                                      secc: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index],
                                                      i:index,
                                                      end:Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length-1,
                                                      formKey: formKey,
                                                      actualizarSecciones: actualizarVistaConNuevoPlan,
                                                      actulizarVistaParaFamiliar: actualizarVista,
                                                      actualizarCodigoPostalFamiliares:
                                                      actualizarCodigoPostalFamiliares,
                                                      validarCodigoPostalFamiliares:
                                                      validarCodigoPostalFamiliares,
                                                      borrarAdicional: borrarAdicional,
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: !Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].opened,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                            ) :
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              left: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              right: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              // bottom: BorderSide(width: 1.0,color: AppColors.color_Bordes),
                                            ),
                                          ),
                                          child: ExpansionTile(
                                            onExpansionChanged: (value){
                                              Utilidades.mostrarAlerta("Error", "Faltan datos obligatorios por capturar", context);
                                            },
                                            leading:  Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                            trailing: SizedBox.shrink(),
                                            initiallyExpanded: false,
                                            title: Text("Plan - ${valorEtiquetaPlan}",
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsCotizador.AzulGNP,
                                                fontFamily: "Roboto",
                                              ),),
                                            children: <Widget>[
                                              Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              left: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              right: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                              // bottom: BorderSide(width: 1.0,color: AppColors.color_Bordes),
                                            ),
                                          ),
                                          child: ExpansionTile(
                                            onExpansionChanged: (value){
                                              Utilidades.mostrarAlerta("Error", "Faltan datos obligatorios por capturar", context);
                                            },
                                            leading:  Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                            trailing: SizedBox.shrink(),
                                            initiallyExpanded: false,
                                            title: Text("Coberturas",
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsCotizador.AzulGNP,
                                                fontFamily: "Roboto",
                                              ),),
                                            children: <Widget>[
                                              Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoButton(
                                onPressed: (){

                                  final bool v = formKey.currentState.validate();

                                  formKey.currentState.save();

                                  bool formularioValido = true;
                                  String negocio;

                                  setState(() {

                                    List<Campo> campos =  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().obtenerSeccionesSimplificadas();
                                    final campo = campos.firstWhere(
                                          (c) => c.id_campo == 23,
                                      orElse: () => null,
                                    );
                                    campo?.valor = valorPlan;


                                    for(int i=0; (i < campos.length) && formularioValido; i++){

                                      if(campos[i].isValid == false){
                                        formularioValido = false;
                                      }
                                      if(campos[i].nombre_campo == "idNegocio"){
                                        negocio = campos[i].valor;
                                      }
                                      //en paso1 no se valida la seccion 6 que corresponde a plan
                                      if( (campos[i].obligatorio ? campos[i].valor == null && campos[i].id_seccion != 6 : false )  ){
                                        if(campos[i].id_seccion != 2 && !seRequiereAntiguedad){
                                          DateTime fecha_1_init = DateTime.now();
                                          campos[i].valor = Jiffy(fecha_1_init).format("yyy-MM-dd").toString();
                                          formularioValido = true;
                                        }else{
                                          formularioValido = false;
                                        }
                                      }
                                      if(campos[i].nombre_campo == "antiguedad_gnp" && negocio == "1"){
                                        DateTime fecha_1_init = DateTime.now();
                                        campos[i].valor = Jiffy(fecha_1_init).format("yyy-MM-dd").toString();
                                        formularioValido = true;
                                      }
                                    }
                                  });

                                  if (formularioValido) {

                                    if (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.validarFormulario()) {
                                      //Enviar a Analitycs

                                      print("Cotizador Analitycs Tags");
                                      // CotizadorAnalitycsTags.sendTagsFormulario(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion(), context);
                                      print('El formulario es valido');
                                      //Nuevos tags para analytics
                                      Utilidades.sendAnalytics(context, "Acciones", "Cotizar" + " / " + Utilidades.tipoDeNegocio);

                                      Regla r = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().calcularReglas();

                                      if(r!=null){
                                        print(r.mensaje);
                                        if(r.tipoRegla== Utilidades.REGLA_INFO){


                                          Utilidades.mostrarAlertaCallback("¿Desea Continuar?", r.mensaje, context, (){ //CANCELAR

                                            Navigator.pop(context);

                                          }, (){ //ACEPTAR
                                            setState(() {
                                              tieneEdad = false;
                                              tieneCP = false;
                                            });

                                            Navigator.pop(context);
                                            //limpiar lista de cotizaciones con paso2 null
                                            Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().seCotizo = true;
                                            limpiarCotizaciones();
                                            ////Para funcionalidad cotizacion Editada A Recuperar
                                            //validarEdicion();

                                            Navigator.pushNamed(context, "/cotizadorUnicoAPPasoTres",);

                                          });
                                        }
                                        if(r.tipoRegla== Utilidades.REGLA_STOPPER){
                                          Utilidades.mostrarAlerta("No es posible continuar", r.mensaje, context);
                                        }

                                      }else{
                                        print("No se cumplen reglas");
                                        //limpiar lista de cotizaciones con paso2 null
                                        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().seCotizo = true;
                                        limpiarCotizaciones();
                                        ////Para funcionalidad cotizacion Editada A Recuperar
                                        //validarEdicion();

                                        Navigator.pushNamed(context, "/cotizadorUnicoAPPasoTres",);

                                      }

                                    } else {
                                      print("invalid");
                                    }
                                  } else {
                                    Utilidades.mostrarAlerta("Error", "Faltan datos obligatorios por capturar", context);
                                    print("invalid");
                                  }

                                },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  color: Utilidades.color_primario,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 16.0),
                                    child: Text("Cotizar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),textAlign: TextAlign.center,),
                                  ),
                                ),

                              ),
                            )
                          ],
                        )
                    ),
                  ),

                ),
              ]),
        ),
      ),
    );
  }
}