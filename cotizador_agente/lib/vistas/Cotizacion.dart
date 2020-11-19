import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/utils/Mensajes.dart';
//import 'package:cotizador_agente/cotizador_analitycs_tags.dart';
//import 'package:firebase_performance/firebase_performance.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:cotizador_agente/vistas/CotizacionPDF.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';



class CotizacionVista extends StatefulWidget {

  Map<String, dynamic> jsonMap;

  CotizacionVista({Key key, this.jsonMap}) : super(key: key);


  @override
  _CotizacionVistaState createState() => _CotizacionVistaState();
}

class _CotizacionVistaState extends State<CotizacionVista> {

  bool isLoading = true;
  int cotiz=1;
  Map<String, dynamic> resumenCot;
  String nombreCot;
  FlutterWebviewPlugin _flutterWebViewPlugin = new FlutterWebviewPlugin();
  String _initialURL="";
  String _dataLayer = "";
  Map<String, dynamic> parameters =  Map<String, dynamic>();
  List<Map<String, dynamic>> lista_secciones =  List<Map<String, dynamic>> ();
  Map<String, dynamic> parameters_Calculo = Map<String, dynamic>();
  Map<String, dynamic> parameters_Calculo2 = Map<String, dynamic>();
  Map<String, dynamic> seccionCalculo =  Map<String, dynamic>();
  List<dynamic> datosAsegurados = new List<dynamic>();
  Map<String, dynamic> aseguradosD = new Map<String, dynamic>();

  String numeroPagos = "";
  String primaBase = "";
  String iva = "";
  String primaTotal = "";
  String recargoPagoFraccionado = "";
  String primaComisionable = "";
  String porcentajeComision = "";
  String comision = "";
  String parcialidad = "";
  String derechoPoliza = "";
  String aseguradoPB = "";
  String aseguradoiva = "";
  String aseguradoPT = "";
  String aseguradoRPF = "";
  String aseguradoPrimaC = "";
  String aseguradoPorC = "";
  String aseguradoCom = "";
  String aseguradoDP = "";
  String paramName = "";
  String idAseg = "";
  String platform = "";
  bool esComparativa = false;
  final _formKey = GlobalKey<FormState>();
  final namePropuesta1Controller = new TextEditingController();
  final namePropuesta2Controller = new TextEditingController();
  final nametablaCompController = new TextEditingController();
  bool ispropuesta1 = false;
  bool ispropuesta2 = false;
  bool ispropuesta3 = false;


  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  @override
  void initState() {

    if(widget.jsonMap==null){
      widget.jsonMap = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().getJSONComparativa();
    }
    generarCotizacion(context).then((success){
      if(success == false){
        setState(() {
          isLoading = true;
        });
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          generarCotizacion(context);
        });
      }else{
        isLoading = false;

      }
    });
    //_flutterWebViewPlugin.onUrlChanged.listen((String url) { print("onResume Change Url => $url"); });
    bool noTieneComparativa = false;
  }

  generarCotizacion(BuildContext context) async{

    /*final Trace generaCot = FirebasePerformance.instance.newTrace("CotizadorUnico_GenerarCotizacion");
    generaCot.start();
    print(generaCot.name);*/
    bool success = false;


    try{

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{

          Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

          Response response = await post(config.urlGeneraCotizacion, body: json.encode(widget.jsonMap), headers: headers);
          Utilidades.LogPrint(json.encode(widget.jsonMap));
          int statusCode = response.statusCode;
          if(response != null){
            Utilidades.LogPrint("RESPONSE COT: " + response.body.toString());
            if(response.body != null && response.body.isNotEmpty){
              if (statusCode == 200) {
                //generaCot.stop();

                this.setState(() {
                  success = true;
                  if(json.decode(response.body)["resumenCotizacion"]["banComparativa"] == 0){

                    Utilidades.mostrarAlertaCallback("Problema al agregar la cotización", Mensajes.agregarCot, context, (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, (){
                      setState(() {
                        FormularioCotizacion temporal = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion();


                        Utilidades.cotizacionesApp.limpiarComparativa();
                        Utilidades.cotizacionesApp.agregarCotizacion(temporal);

                        Navigator.pop(context);

                      });
                    });

                  }
                  isLoading = false;
                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().comparativa = Comparativa.fromJson(json.decode(response.body));
                  Utilidades.LogPrint("RESPONSE COT. COMPARATIVA: " + response.body.toString());

                  //ANALYTICS

                  try{

                    if (Platform.isIOS) {
                      platform = "iOS";
                    }else if (Platform.isAndroid){
                      platform = "Android";
                    }
                    //lista_secciones = CotizadorAnalitycsTags.getListaSeccionesGTM(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion());

                    //SECCIÓN: datos Cotizador Anaytics
                    //lista_secciones.addAll(Utilidades.lista_seccionesC);

                    //SECCIÓN: calculo Analytics
                    numeroPagos = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["numeroPagos"].toString();
                    primaBase = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaBase"].toStringAsFixed(2);
                    iva = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["iva"].toStringAsFixed(2);
                    primaTotal = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaTotal"].toStringAsFixed(2);
                    recargoPagoFraccionado = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["recargoPagoFraccionado"].toStringAsFixed(2);
                    primaComisionable = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaComisionable"].toStringAsFixed(2);
                    porcentajeComision = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["porcentajeComision"].toStringAsFixed(2);
                    comision = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["comision"].toStringAsFixed(2);
                    parcialidad = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["parcialidad"].toStringAsFixed(2);
                    derechoPoliza = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["derechoPoliza"].toStringAsFixed(2);

                    parameters_Calculo["seccion"] = "calculo";
                    parameters_Calculo["cotizacion-numeroPagos"] = numeroPagos.toString();
                    parameters_Calculo["cotizacion-primaBase"] = primaBase.toString();
                    parameters_Calculo["cotizacion-iva"] = iva.toString();
                    parameters_Calculo["cotizacion-primaTotal"] = primaTotal.toString();
                    parameters_Calculo["cotizacion-recargoPagoFraccionado"] = recargoPagoFraccionado.toString();
                    parameters_Calculo["cotizacion-primaComisionable"] = primaComisionable.toString();
                    parameters_Calculo["cotizacion-porcentajeComision"] = porcentajeComision.toString();
                    parameters_Calculo["cotizacion-comision"] = comision.toString();
                    parameters_Calculo["cotizacion-parcialidad"] = parcialidad.toString();
                    parameters_Calculo["cotizacion-derechoPoliza"] = derechoPoliza.toString();

                    seccionCalculo.addAll(parameters_Calculo);

                    datosAsegurados = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["asegurados"];
                    if(datosAsegurados != null){
                      if(datosAsegurados.length > 0){

                        //Búsqueda de datos por asegurado
                        for(int i = 0; i < datosAsegurados.length; i++){

                          aseguradoPB= datosAsegurados[i]["primaBase"].toStringAsFixed(2);
                          aseguradoRPF = datosAsegurados[i]["recargoPagoFraccionado"].toStringAsFixed(2);
                          aseguradoDP = datosAsegurados[i]["derechoPoliza"].toStringAsFixed(2);
                          aseguradoiva = datosAsegurados[i]["iva"].toStringAsFixed(2);
                          aseguradoPT = datosAsegurados[i]["primaTotal"].toStringAsFixed(2);
                          aseguradoPrimaC = datosAsegurados[i]["primaComisionable"].toStringAsFixed(2);
                          aseguradoPorC = datosAsegurados[i]["porcentajeComision"].toStringAsFixed(2);
                          aseguradoCom = datosAsegurados[i]["comision"].toStringAsFixed(2);

                          idAseg = (datosAsegurados[i]["idAsegurado"]).toString();

                          paramName = "cotizacion-primaBase-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoPB;
                          paramName = "cotizacion-recargoPagoFraccionado-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoRPF;
                          paramName = "cotizacion-derechoPoliza-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoDP;
                          paramName = "cotizacion-iva-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoiva;
                          paramName = "cotizacion-primaTotal-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoPT;
                          paramName = "cotizacion-primaComisionable-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoPrimaC;
                          paramName = "cotizacion-porcentajeComision-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoPorC;
                          paramName = "cotizacion-comision-asegurado-"+ idAseg;
                          parameters_Calculo2[paramName] = aseguradoCom;

                          aseguradosD.addAll(parameters_Calculo2);

                        }

                        seccionCalculo.addAll(aseguradosD);
                        lista_secciones.add(seccionCalculo);

                        Utilidades.LogPrint("LISTA_SECCIONES" + json.encode(lista_secciones).toString());

                      }
                    }


                  }catch(e){
                    print("Error al generar analytics");
                  }

                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().setrequestCotizacion(json.encode(widget.jsonMap).toString());
                  //Utilidades.LogPrint("JSONMAP: " + widget.jsonMap.toString());

                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().setresponseCotizacion(json.decode(response.body));
                  //Utilidades.LogPrint("REQUEST COT: " + response.body.toString());

                });
              }else if(statusCode == 400){
                //generaCot.stop();
                isLoading = false;
                Navigator.pop(context);
                Utilidades.mostrarAlertas("Error: " + statusCode.toString(), "Bad Request", context);

              }else if(statusCode != null) {
                //generaCot.stop();
                isLoading = false;
                //Navigator.pop(context);
                String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";

                success =  true;
                Utilidades.mostrarAlertas(Mensajes.titleLoSentimos , message, context);
              }

            }else{
              //generaCot.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                generarCotizacion(context);
              });
            }
          }else{
            //generaCot.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              generarCotizacion(context);
            });
          }

        }catch(e){
          //generaCot.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            generarCotizacion(context);
          });
        }

      }else{
        //generaCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          generarCotizacion(context);
        });
      }

    }catch(e){
      //generaCot.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        generarCotizacion(context);
      });
    }


    return success;

  }



  guardaCotizacion(int index, int idformato) async{



    bool deboGuardarCotizacion = true;
    switch(idformato){
      case Utilidades.FORMATO_COMISION:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION !=null){
          _initialWebView();
          deboGuardarCotizacion = false;
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => CotizacionPDF(
                  id: index+1,
                  folio: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION,
                  idFormato: idformato,
                  id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                ),
              ));

        }

        break;

      case Utilidades.FORMATO_COMISION_AP:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION !=null){
          _initialWebView();
          deboGuardarCotizacion = false;
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => CotizacionPDF(
                  id: index+1,
                  folio: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION,
                  idFormato: idformato,
                  id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                ),
              ));

        }

        break;

      case Utilidades.FORMATO_COTIZACION:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION !=null){
          _initialWebView();
          deboGuardarCotizacion = false;
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => CotizacionPDF(
                  id: index+1,
                  folio: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION,
                  idFormato: idformato,
                  id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                ),
              ));
        }
        break;

      case Utilidades.FORMATO_COTIZACION_AP:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION !=null){
          _initialWebView();
          deboGuardarCotizacion = false;
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => CotizacionPDF(
                  id: index+1,
                  folio: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION,
                  idFormato: idformato,
                  id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                ),
              ));
        }

        break;

    }


    bool success = false;
    if(deboGuardarCotizacion){


      /*final Trace saveCot = FirebasePerformance.instance.newTrace("CotizadorUnico_GuardarCotizacion");
      saveCot.start();
      print(saveCot.name);*/


      try{
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          try{

            Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

            String resumen;

            if(idformato == Utilidades.FORMATO_COMPARATIVA){
              List<Map<String, dynamic>> listRequest =  List<Map<String, dynamic>>();

              for(int i = 0; i < Utilidades.cotizacionesApp.getCurrentLengthLista(); i++){

                if(Utilidades.cotizacionesApp.getCotizacionElement(i).comparativa!=null){

                  Map<String, dynamic> comparativa = {
                    "responseResumen": Utilidades.cotizacionesApp.getCotizacionElement(i).generarResponseResumen(),
                    "formasPago": Utilidades.cotizacionesApp.getCotizacionElement(i).responseCotizacion["resumenCotizacion"]["formasPago"],
                    "secciones": Utilidades.cotizacionesApp.getCotizacionElement(i).responseCotizacion["resumenCotizacion"]["secciones"],
                  };

                  listRequest.add(comparativa);

                }

              }

              Map<String, dynamic> comparativas = {
                "comparativas": listRequest,
              };

              resumen = json.encode(comparativas);
              //Utilidades.LogPrint("LA COMPARATIVA"+resumen);

            }else{
              resumen = json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).generarResponseResumen()).toString();
            }

            //Formar cadena del titular (HARDCODE a Peticion del BACKEND)
            String titular = " ";

            List<Campo> nombre= Utilidades.buscaCampoPorFormularioID(index, 2, 1, false);
            List<Campo> primer_apellido= Utilidades.buscaCampoPorFormularioID(index, 2, 2, false);
            List<Campo> segundo_apellido= Utilidades.buscaCampoPorFormularioID(index, 2, 3, false);

            if(nombre!=null && primer_apellido!=null && segundo_apellido!=null ){

              if(nombre.length>0 && primer_apellido.length>0 && segundo_apellido.length>0 ){

                String t = ((nombre[0].getValorFormatted()).toString().trim() !="" ? nombre[0].getValorFormatted().toString().trim() + " " : "")  + ( (primer_apellido[0].getValorFormatted()).toString().trim() != "" ? primer_apellido[0].getValorFormatted()+ " " : "" ) + ( (segundo_apellido[0].getValorFormatted()).toString().trim() != "" ? segundo_apellido[0].getValorFormatted().toString().trim() : "");

                if(t!=""){
                  titular = t;
                }

              }

            }

            ////TODO: Revisar esta cambio. HAY UNA BRECHA EN EL SERVICIO DEL BACK 1 - POLIZA, 2 - COMPARATIVA, 3 - COMISIONES
            Map<String, dynamic> jsonMap = {
              "idUsuario": "TALLPRO",//datosUsuario.idparticipante.toString(),
              "idAplicacion": Utilidades.idAplicacion,
              "codIntermediario": "0060661001",//"datosPerfilador.intermediarios".toString().replaceAll("[", "").replaceAll("]", ""),
              "idPlan": idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
              "idFormato": idformato,
              "titularCotizacion": titular, //NOMBRE DEL TITULAR sacarlo de formulario
              "requestCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString(),
              "responseCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString(),
              "responseResumen": resumen,
              "nombreCotizacion": idformato != Utilidades.FORMATO_COMPARATIVA ? Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre != null ?  Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre : "Propuesta " + (index+1).toString() : " ",
            };

            /*Utilidades.LogPrint("REQUEST: " + Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString());
        Utilidades.LogPrint("RESPONSE: " + json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString());
        Utilidades.LogPrint("RESUMEN: " + resumen);*/


            Response response = await post(config.urlGuardaCotizacion, body: json.encode(jsonMap), headers: headers);
            int statusCode = response.statusCode;
            Utilidades.LogPrint("COT GUARDADA: \ " + json.encode(jsonMap).toString());
            Utilidades.LogPrint("RESPONSE COT G: " +json.encode(response.body).toString());


            if(response != null){
              if(response.body != null && response.body.isNotEmpty){
                if (statusCode == 200) {
                  //saveCot.stop();

                  this.setState(() {

                    isLoading = false;
                    success = true;


                    int folio =  json.decode(response.body)["folio"];


                    switch(idformato){
                      case Utilidades.FORMATO_COMISION:
                        Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION = folio;
                        break;

                      case Utilidades.FORMATO_COTIZACION:
                        Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION = folio;
                        break;

                      case Utilidades.FORMATO_COMISION_AP:
                        Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION = folio;
                        break;

                      case Utilidades.FORMATO_COTIZACION_AP:
                        Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION = folio;
                        break;

                    }

                    _initialWebView();


                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => CotizacionPDF(
                            id: index+1,
                            folio: folio,
                            idFormato: idformato,
                            id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                          ),
                        ));

                  });

                }else if(statusCode != null) {
                  //saveCot.stop();
                  isLoading = false;
                  String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                  Utilidades.mostrarAlertas("Error: " + statusCode.toString(), message, context);
                }else{
                  //saveCot.stop();
                  Utilidades.mostrarAlertas("Error: " + statusCode.toString(), response.body.toString(), context);
                }

              }else{
                //saveCot.stop();
                Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                  Navigator.pop(context);
                  guardaCotizacion(index, idformato);
                });
              }
            }else{
              //saveCot.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                guardaCotizacion(index, idformato);
              });
            }


          }catch(e){
            //saveCot.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              guardaCotizacion(index, idformato);
            });
          }

        }else {
          //saveCot.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            guardaCotizacion(index, idformato);
          });
        }
      }catch(e){
        //saveCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          guardaCotizacion(index, idformato);
        });
      }


    }else{
      success = true;
    }


    return success;

  }

  void limpiarDatos(){

    Utilidades.cotizacionesApp.limpiarComparativa();

    Navigator.of(context).popUntil(ModalRoute.withName('/cotizadorUnicoAP'));
    Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);

  }

  void editarDatos(int index){

    if(Utilidades.cotizacionesApp.getCotizacionesCompletas()<3){

      FormularioCotizacion temporal =  Utilidades.cotizacionesApp.getCotizacionElement(index);


      PasoFormulario p1 = PasoFormulario(
          id_aplicacion: temporal.paso1.id_aplicacion,
          nombre: temporal.paso1.nombre,
          descripcion: temporal.paso1.descripcion,
          cantidad_asegurados: temporal.paso1.cantidad_asegurados,
          estatus: temporal.paso1.estatus,
          estilos: temporal.paso1.estilos,
          raizRequestCotizacion: temporal.paso1.raizRequestCotizacion,
          camposRequestCotizacion: temporal.paso1.camposRequestCotizacion,
          documentos: temporal.paso1.documentos,
          documentos_configuracion: temporal.paso1.documentos_configuracion,
          secciones: backPaso1(temporal.paso1.secciones)
      );
      PasoFormulario p2 = PasoFormulario(
          id_aplicacion: temporal.paso2.id_aplicacion,
          nombre: temporal.paso2.nombre,
          descripcion: temporal.paso2.descripcion,
          cantidad_asegurados: temporal.paso2.cantidad_asegurados,
          estatus: temporal.paso2.estatus,
          estilos: temporal.paso2.estilos,
          raizRequestCotizacion: temporal.paso2.raizRequestCotizacion,
          camposRequestCotizacion: temporal.paso2.camposRequestCotizacion,
          documentos: temporal.paso2.documentos,
          documentos_configuracion: temporal.paso2.documentos_configuracion,
          secciones: backPaso1(temporal.paso2.secciones)
      );

      FormularioCotizacion copia =  FormularioCotizacion (paso1: p1, paso2: p2);
      copia.idPlan = temporal.idPlan;
      copia.comparativa = null;




      Utilidades.cotizacionesApp.agregarCotizacion(copia);

      Utilidades.editarEnComparativa = true;
     Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno");
    }else{

      Utilidades.mostrarAlerta(Mensajes.titleAdver, Mensajes.limiteCotizacion, context);
    }


  }



  List<Seccion> backPaso1(List<Seccion> secciones) {
    return backPaso1Child(secciones);
  }

  List<Seccion> backPaso1Child(List<Seccion> secciones) {
    List<Seccion> _secciones = List<Seccion>();
    for(Seccion seccion in secciones) {
      List<Campo> _campos = List<Campo>();
      for(var campo in seccion.campos)
      {
        Campo _campo = new Campo(
            valor: campo.valor,
            oculta: campo.oculta,
            rangoRelativa: campo.rangoRelativa,
            regla_catalogo: campo.regla_catalogo,
            id_campo: campo.id_campo,
            etiqueta: campo.etiqueta,
            obligatorio: campo.obligatorio,
            nombre_campo: campo.nombre_campo,
            tipo_dato: campo.tipo_dato,
            tipo_componente: campo.tipo_componente,
            visible: campo.visible,
            regla: campo.regla,
            valores: campo.valores,
            rango: campo.rango,
            view_ID: campo.view_ID,
            dato_longitud: campo.dato_longitud,
            seccion_dependiente: campo.seccion_dependiente,
            nombreRequestCotizacion: campo.nombreRequestCotizacion,
            valores_sin_filtro: campo.valores_sin_filtro,
            checked: campo.checked,
            enabled: campo.enabled,
            reg_ex: campo.reg_ex,
            visibleLocal: campo.visibleLocal);
        _campos.add(_campo);
      }

      Seccion _seccion = Seccion(id_seccion: seccion.id_seccion,
          seccion: seccion.seccion,
          multiplicador: seccion.multiplicador,
          campos: _campos, reglasNegocio:
          seccion.reglasNegocio,
          nombreRequestCotizacion: seccion.nombreRequestCotizacion,
          id_valor: seccion.id_valor,
          filtrable: seccion.filtrable,
          id_filtrado: seccion.id_filtrado );

      if(seccion.multiplicador>0) {
        _seccion.children_secc = backPaso1Child(seccion.children_secc);
      }

      _secciones.add(_seccion);
    }
    return _secciones;
  }

  void guardarFormatoComparativa(){
    setState(() {
      esComparativa = true;
    });
    guardaCotizacion(0, Utilidades.FORMATO_COMPARATIVA);
  }

  Future _initialWebView() async {

    if(esComparativa == false){
      parameters = {"data" : lista_secciones};
      _dataLayer = json.encode(parameters);
    }else{
      _dataLayer = json.encode(Utilidades.seccCot);
    }

    Utilidades.LogPrint("DATALAYER: " + _dataLayer);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(_dataLayer);
    Utilidades.LogPrint("ENCODE DATALAYER: " + encoded);

    if(esComparativa == false){
      setState(() {
        _initialURL =  config.urlAnalytics + encoded;
        Utilidades.LogPrint("VISTAPREVIA:" + _initialURL);
      });
    }else{
      setState(() {
        _initialURL = config.urlAccionComparativa + encoded;
        Utilidades.LogPrint("COMPARATIVA:" + _initialURL);
      });
    }

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
    };
    Map<String, dynamic> send = {
      "redirect_url": _initialURL,
    };

    String key = Utilidades.keyGTM;
    String gmm = stringToBase64.decode(key);

    Response response = await post(gmm, body: send, headers: headers);
    if(response.body != null && response.statusCode == 200){

      Utilidades.LogPrint(json.encode(response.body));
      if(json.decode(response.body)["short_url"] != null){
        String url = json.decode(response.body)["short_url"];
        _flutterWebViewPlugin.reloadUrl(url);
        Utilidades.LogPrint("URL: " + url);
        url = "";
        _initialURL = "";
      }


    }

  }

  @override
  Widget build(BuildContext context) {

    void _aumentar(){
      Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno");
    }
    return WillPopScope(
      onWillPop: () async{
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().comparativa = null;

        return true;
      },
      child: LoadingOverlay(
        isLoading: isLoading,
        opacity: 0.8,
        color: AppColors.color_titulo,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 5.0,
        ),
        child: Stack(
          children: <Widget>[
            Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: AppColors.color_primario),
                  backgroundColor: Colors.white,
                  title: Text("Tabla comparativa", style: TextStyle(color: AppColors.color_appBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500)),
                  actions: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/icon/cotizador/ic_appbar.png'),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          barrierColor: AppColors.color_titleAlert.withOpacity(0.6),
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => Container(
                            height: 500,
                            padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
                            decoration : new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(12.0),
                                  topRight: const Radius.circular(12.0),
                                )
                            ),
                            child:  Center(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
                                      child:Center(child: new Text(Mensajes.titleSave,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.color_titleAlert,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.15))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 12.0, right: 12.0),
                                      child:SingleChildScrollView(child: new Text(Mensajes.lblSaveCot,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: AppColors.color_appBar,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.25))),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 28.0, right: 24.0, left: 24.0),
                                            child: Row(children: <Widget>[
                                              Checkbox(
                                                value: ispropuesta1,
                                                onChanged: (bool value){
                                                setState(() {
                                                  ispropuesta1 = value;
                                                  print(ispropuesta1.toString());
                                                });
                                                },
                                                activeColor: AppColors.color_appBar,
                                                checkColor: AppColors.color_TextActive,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: TextField(
                                                  autofocus: ispropuesta1,
                                                  controller: namePropuesta1Controller,
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [WhitelistingTextInputFormatter(RegExp("[A-Za-zÁÉÍÓÚáéíóúñÑ ]"))],
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: 12.0),
                                                    labelText: Mensajes.propuesta + " 1",
                                                    hintStyle: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                      color: AppColors.gnpTextUser,
                                                    ),
                                                    focusColor: AppColors.color_primario,
                                                    fillColor: AppColors.primary200,
                                                    enabledBorder: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                    border: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 28.0, right: 24.0, left: 24.0),
                                            child: Row(children: <Widget>[
                                              Checkbox(
                                                value: ispropuesta2,
                                                onChanged: (bool value){
                                                  setState(() {
                                                    ispropuesta2 = value;
                                                    print(ispropuesta2.toString());
                                                  });
                                                },
                                                activeColor: Colors.white,
                                                checkColor: AppColors.color_TextActive,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: TextField(
                                                  controller: namePropuesta2Controller,
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [WhitelistingTextInputFormatter(RegExp("[A-Za-zÁÉÍÓÚáéíóúñÑ ]"))],
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: 12.0),
                                                    labelText: Mensajes.propuesta + " 2",
                                                    hintStyle: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                      color: AppColors.gnpTextUser,
                                                    ),
                                                    focusColor: AppColors.color_primario,
                                                    fillColor: AppColors.primary200,
                                                    enabledBorder: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                    border: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 28.0, right: 24.0, left: 24.0),
                                            child: Row(children: <Widget>[
                                              Checkbox(
                                                value: ispropuesta3,
                                                onChanged: (bool value){
                                                  setState(() {
                                                    ispropuesta3 = value;
                                                    print(ispropuesta3.toString());
                                                  });
                                                },
                                                activeColor: Colors.white,
                                                checkColor: AppColors.color_TextActive,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: TextField(
                                                  controller: nametablaCompController,
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [WhitelistingTextInputFormatter(RegExp("[A-Za-zÁÉÍÓÚáéíóúñÑ ]"))],
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: 12.0),
                                                    labelText: Mensajes.tabla_Comp,
                                                    hintStyle: TextStyle(fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                      color: AppColors.gnpTextUser,
                                                    ),
                                                    focusColor: AppColors.color_primario,
                                                    fillColor: AppColors.primary200,
                                                    enabledBorder: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                    border: new UnderlineInputBorder(
                                                      borderSide: new BorderSide(
                                                          color: AppColors.primary200
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],),
                                          ),
                                        ],),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40.0, left: 0, right: 0),
                                      child: Divider(height: 2,
                                        color: AppColors.color_borde,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0,),
                                      child: ButtonTheme(
                                        minWidth: 340.0,
                                        height: 40.0,
                                        buttonColor: AppColors.color_naranja_primario,
                                        child: RaisedButton(
                                          onPressed: ((){

                                            Navigator.pop(context);
                                          }),
                                          child: Text(Mensajes.guarda,
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },),

                  ],
                ),
                body: Column(//isLoading ? showLoading():

                  children: <Widget>[

                  //  TopBar(recargarFormulario: limpiarDatos, formatoComp: guardarFormatoComparativa,),
                    //Encabezado
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0),
                      child: Container(
                        color: AppColors.color_background,
                        height: 74.0,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0,top: 12.0, bottom: 12),
                              child: Image.asset("assets/icon/cotizador/Solicitantes.png", height: 50, width: 50,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 44, left: 16.0),
                              child: Text("Solicitantes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.color_appBar),),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 13.0, top: 25.0, bottom: 25.0, left: 140.0),
                              child: Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 2,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext ctxt, int i) {

                            switch(i){

                              case 0:
                                return Visibility(
                                  visible: Utilidades.cotizacionesApp.getCotizacionesCompletas() < 3 ? true : false,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 26, left: 16.0, right: 16.0, bottom: 11.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 6,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 56.0),
                                                  child: Text(Mensajes.btn_addCotizacion,
                                                    style: TextStyle(color:AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w600),
                                                  ),
                                                )
                                            ),
                                            Spacer(),
                                            Expanded(
                                              flex: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: IconButton(
                                                  icon: Image.asset("assets/icon/cotizador/icon_more.png", height: 24, width: 24,),
                                                  onPressed: _aumentar,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                        child: Divider(
                                          color: AppColors.color_divider,
                                          height: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                break;

                              case 1:

                                int cont = 0;

                                return ListView.builder(
                                    itemCount: Utilidades.cotizacionesApp.getCurrentLengthLista(),
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (BuildContext ctxt, int index) {

                                      if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa == null){
                                        return Container();
                                      }else{
                                        cont ++;
                                      }


                                      List<PopupMenuItem> getMenuItems() {

                                        List<PopupMenuItem> listaitems = List<PopupMenuItem>();
                                        int i = 0;

                                        for(int i = 0; i< Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago.length; i++){

                                          FormadePago formapago = Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[i];

                                          listaitems.add(PopupMenuItem(
                                            value: i,
                                            child: Container(
                                              width: double.infinity,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    formapago.forma,
                                                    style: TextStyle(
                                                        color: AppColors.color_titulo, fontWeight: FontWeight.w400),
                                                  ),
                                                  SizedBox(width: 60.0,),
                                                ],
                                              ),
                                            ),
                                          ));
                                        }
                                        return listaitems;

                                      }

                                      bool mostrarText;
                                      bool mostrarCampo;

                                      if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre == null ){
                                        mostrarText = true;
                                        mostrarCampo = false;

                                      }else{
                                        mostrarText = false;
                                        mostrarCampo = true;
                                      }

                                      List<Widget> getFormatos() {
                                        List<FlatButton> listabuttonDoc = new List<FlatButton>();
                                        for (int i = 0; i <Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion.length; i++) {

                                          Documento doc = Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion[i];

                                          if(doc.id != 2){
                                            listabuttonDoc.add(new FlatButton(
                                              color: Colors.white,
                                              onPressed: (){
                                                setState(() {
                                                  if(i < 3){
                                                    guardaCotizacion(index, Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion[i].id);
                                                  }
                                                });
                                              },
                                              child: Text("Ver " + doc.nombreDocumento.toLowerCase().replaceAll("ap", ""), style: TextStyle(color: AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w600),),
                                            ));
                                          }
                                        }
                                        return listabuttonDoc;
                                      }
                                      /*List<PopupMenuItem> getMenuItemsDoc() {
                                        List<PopupMenuItem> listaitemsDoc = List<PopupMenuItem>();

                                        for (int i = 0; i <Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion.length; i++) {

                                          Documento doc = Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion[i];

                                          if(doc.id != 2){
                                            listaitemsDoc.add(PopupMenuItem(value: i,
                                              child: Text(doc.nombreDocumento, style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w400),),
                                            ));
                                          }
                                        }

                                        listaitemsDoc.add(PopupMenuItem(value: 4,
                                          child: Text(
                                            "Editar",
                                            style: TextStyle(
                                                color: AppColors.color_titulo, fontWeight: FontWeight.w400),
                                          ),));

                                        listaitemsDoc.add(PopupMenuItem(value: 5,
                                          child: Text(
                                            "Borrar",
                                            style: TextStyle(
                                                color: AppColors.color_titulo, fontWeight: FontWeight.w400),
                                          ),));
                                        return listaitemsDoc;
                                      }*/

                                      String parcialidades = Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].parcialidades;
                                      String montoParcial = Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].pparcial;



                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 24.0, left: 300.0, top: 8.0),
                                            child: Container(
                                                width: 36,
                                                height: 36,
                                                child: FloatingActionButton(
                                                  backgroundColor: Colors.white,
                                                  onPressed: ((){
                                                    setState(() {
                                                      if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >1){
                                                        Utilidades.cotizacionesApp.eliminarDeLaComparativa(index);
                                                      }else{
                                                        limpiarDatos();
                                                      }
                                                    });
                                                  }),
                                                  child: Image.asset("assets/icon/cotizador/delete.png", height: 21.6, width: 21.6,),
                                                )
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 32.0,left: 16.0, top: 0.0),
                                            child: Container(
                                              height: 332,
                                              width: 312,
                                              decoration: new BoxDecoration(
                                                  border: Border.all(color: AppColors.color_Bordes),
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.only(
                                                    topLeft: const Radius.circular(4.0),
                                                    topRight: const Radius.circular(4.0),
                                                    bottomLeft: const Radius.circular(4.0),
                                                    bottomRight: const Radius.circular(4.0),
                                                  )),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(right:8.0, left: 8.0, top:16.0, bottom: 16.0),
                                                    child: Container(
                                                        child: Text("Cotización " + cont.toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.color_appBar),)
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 0.0, left: 0.0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 12.0),
                                                      color: AppColors.color_background,
                                                      height: 48,
                                                      width: 296,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago.length > 1 ? <Widget>[

                                                          PopupMenuButton(
                                                            offset: Offset(135, 200),
                                                            itemBuilder: (context) => getMenuItems(),
                                                            //initialValue: 2,
                                                            onCanceled: () {
                                                              print("You have canceled the menu.");
                                                            },
                                                            onSelected: (value) {
                                                              setState(() {
                                                                Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada = value;
                                                              });

                                                            },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                  child: Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma,
                                                                    style: TextStyle(color: AppColors.color_appBar,fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.left,
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma != "Anual",
                                                                  child: Container(padding: const EdgeInsets.only(left: 165.0, right: 12.0),
                                                                      child: Image.asset("assets/icon/cotizador/arrow_drop_down.png", width: 24, height: 24,)),
                                                                ),
                                                                Visibility(
                                                                  visible: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma == "Anual",
                                                                  child: Container(padding: const EdgeInsets.only(left: 195.0, right: 12.0),
                                                                      child: Image.asset("assets/icon/cotizador/arrow_drop_down.png", width: 24, height: 24,)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ] : <Widget>[
                                                          Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma,
                                                            style: TextStyle(
                                                                color: AppColors.color_appBar,fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.left,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 16.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                                          width: 144,
                                                          height: 16,
                                                          child: Text("Prima total", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.color_appBar),
                                                            textAlign: TextAlign.right,),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                          width: 144,
                                                          height: 16,
                                                          child: Text(parcialidades,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.color_appBar),
                                                            textAlign: TextAlign.left,),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Row(children: <Widget>[
                                                    Container(
                                                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                      width: 144,
                                                      height: 40,
                                                      child: Text("\$ " + Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].ptotal.toString(),
                                                        style: TextStyle(color: AppColors.color_appBar, fontSize: 20,fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.right,),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                      width: 144,
                                                      height: 40,
                                                      child: Text(montoParcial,
                                                        style: TextStyle(color: AppColors.color_appBar, fontSize: 20,fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.left,),
                                                    ),
                                                  ],),
                                                  Container(color: Colors.white,
                                                    alignment: Alignment.center,
                                                    child: Wrap(
                                                      alignment: WrapAlignment.center,
                                                      direction: Axis.vertical,
                                                      children: getFormatos(),),
                                                  ),

                                                  Container(
                                                    padding: const EdgeInsets.only(top: 8, left: 85.0, right: 85.0),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: <Widget>[
                                                        IconButton(icon: Image.asset("assets/icon/cotizador/edit.png", height: 18, width: 18,),alignment: Alignment.centerRight,),
                                                        FlatButton(
                                                          textColor: AppColors.color_TextActive,
                                                          onPressed: (){
                                                            editarDatos(index);
                                                          },
                                                          child: Text(Mensajes.edicion,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.left,),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ),
                                          ),
                                          /*CustomTextFieldCotizacion(comparativa: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa, index: index, cont: cont),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 95.0, right: 95.0, top: 8.0, bottom: 32.0),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  color: AppColors.color_titulo,
                                                  borderRadius: new BorderRadius.only(
                                                    topLeft: const Radius.circular(16.0),
                                                    topRight: const Radius.circular(16.0),
                                                    bottomLeft: const Radius.circular(16.0),
                                                    bottomRight: const Radius.circular(16.0),



                                                  )),
                                              child: Column(

                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago.length > 1 ? <Widget>[


                                                      PopupMenuButton(
                                                        offset: Offset(135, 200),
                                                        itemBuilder: (context) => getMenuItems(),
                                                        //initialValue: 2,
                                                        onCanceled: () {
                                                          print("You have canceled the menu.");
                                                        },
                                                        onSelected: (value) {
                                                          setState(() {
                                                            Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada = value;
                                                          });

                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: <Widget>[
                                                            Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma,
                                                              style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.w600),
                                                              textAlign: TextAlign.center,

                                                            ),
                                                            Container(margin: EdgeInsets.only(left: 6.0),
                                                                child: Icon(Icons.expand_more, color: AppColors.color_primario, size: 35.0,)),
                                                          ],
                                                        ),
                                                      ),
                                                    ] : <Widget>[
                                                      Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma,
                                                        style: TextStyle(
                                                            color: Colors.white,fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 24,bottom: 24),
                                                    decoration: BoxDecoration( color: AppColors.color_sombra, borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(16.0),
                                                      bottomRight: const Radius.circular(16.0),)),
                                                    child: Column(

                                                      children: <Widget>[

                                                        Text("\$ " + Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].ptotal.toString(),  style: TextStyle(
                                                            color: AppColors.color_titulo, fontSize: 24,fontWeight: FontWeight.w400),),

                                                        Container(
                                                          padding: const EdgeInsets.only(top: 20.0,right: 25.0),
                                                          width: double.infinity,
                                                          child: Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].parcialidades,
                                                            style: TextStyle(
                                                                color: AppColors.color_titulo, fontSize: 14,fontWeight: FontWeight.w400),
                                                            textAlign: TextAlign.right,),
                                                        ),

                                                        Container(
                                                          //  alignment: Alignment.centerRight,
                                                          padding: EdgeInsets.only(top: 24, right: 18),
                                                          // color: Colors.blueAccent,
                                                          child: PopupMenuButton(
                                                            offset: Offset(200, 180),
                                                            itemBuilder: (context) => getMenuItemsDoc(),
                                                            // initialValue: 4,
                                                            onCanceled: () {
                                                              print("You have canceled the menu.");
                                                            },
                                                            onSelected: (value) {

                                                              setState(() {
                                                                if(value < 3){
                                                                  guardaCotizacion(index, Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion[value].id);
                                                                }
                                                              });

                                                              switch(value){

                                                                case 4:


                                                                  editarDatos(index);
                                                                  break;

                                                                case 5:
                                                                  setState(() {
                                                                    if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >1){
                                                                      Utilidades.cotizacionesApp.eliminarDeLaComparativa(index);

                                                                    }else{

                                                                      limpiarDatos();

                                                                    }

                                                                  });
                                                                  break;
                                                              }
                                                            },

                                                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                              children: <Widget>[
                                                                Text("MÁS",
                                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: AppColors.color_primario),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                                Icon(Icons.more_vert, color: AppColors.color_primario,),
                                                              ],),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),*/
                                          Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: FlatButton(
                                              disabledTextColor: AppColors.color_disable,
                                              textColor: Utilidades.cotizacionesApp.getCotizacionesCompletas() >1 ? AppColors.color_TextActive : AppColors.color_disable,
                                              onPressed: (){
                                                if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >2){
                                                  guardarFormatoComparativa();
                                                }else{
                                                  return null;
                                                }
                                              },
                                              child: Text(Mensajes.btn_formatoComp,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                                textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 20),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  border: Border.all(color: AppColors.color_Bordes),
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.only(
                                                    topLeft: const Radius.circular(4.0),
                                                    topRight: const Radius.circular(4.0),
                                                    bottomLeft: const Radius.circular(4.0),
                                                    bottomRight: const Radius.circular(4.0),
                                                  )),
                                              child: ListView.builder(
                                                  itemCount: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones.length,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (BuildContext ctxt, int j) {


                                                    return Padding(padding: EdgeInsets.only(bottom: 20, right: 0.0, left: 0.0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          //Titlulo de seccion
                                                          Container(
                                                            height: 40,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0,),
                                                              child: Text(
                                                                (Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].seccion), maxLines: 2, overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.color_titleAlert),
                                                              ),
                                                            ),
                                                          ),

                                                          ListView.builder(
                                                              itemCount: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].tabla.length,
                                                              shrinkWrap: true,
                                                              physics: ScrollPhysics(),
                                                              itemBuilder: (BuildContext ctxt, int indexdos) {

                                                                return Padding(
                                                                  padding: const EdgeInsets.only(left: 0, right:0, top:8, ),
                                                                  child: RenglonTablaDoscolumna(titulo: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].tabla[indexdos].etiquetaElemento,
                                                                      valor:Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].tabla[indexdos].descElemento),
                                                                );

                                                              }

                                                          ),

                                                        ],
                                                      ),
                                                    );

                                                  }),
                                            ),
                                          ),

                                        ],
                                      );

                                    });

                                break;

                              default:
                                return Container();
                                break;
                            }
                          }),
                    ),
                    Container(
                      height: 0,
                      width: 0,
                      child: Visibility(
                        visible: true,
                        child: WebviewScaffold(
                          url: _initialURL,
                          withJavascript: true,
                          withZoom: false,
                          withLocalStorage: true,
                          hidden:true,
                          clearCache: true,
                          clearCookies: true,
                        ),
                      ),
                    ),
                  ],
                )
            ),

          ],
        ),
      ),
    );



  }


}
