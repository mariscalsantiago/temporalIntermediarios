import 'package:cotizador_agente/CotizadorUnico/Analytics/CotizadorAnalyticsTags.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/CotizadorUnico/MisCotizaciones.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:cotizador_agente/CotizadorUnico/CotizacionPDF.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;



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
  bool propuesta1 = false;
  bool propuesta2 = false;
  bool propuesta3 = false;
  bool comparativa = false;
  bool mostrarFcomparativa = false;

  //verificar que sean diferentes de null
  void guardarPropuestas(String texto1, String texto2, String texto3, String texto4, int idFormato, int index, bool abrirPdf){
    print(texto1);
    setState(() {
      if(abrirPdf == false){
        if(texto1.isNotEmpty){
          Utilidades.cotizacionesApp.listaCotizaciones[0].comparativa.nombre = texto1;
          guardarFormato(Utilidades.FORMATO_COTIZACION_AP, 0, false);
          guardarFormato(Utilidades.FORMATO_COMISION_AP, 0, false);
        }
        if(texto2.isNotEmpty){
          Utilidades.cotizacionesApp.listaCotizaciones[1].comparativa.nombre = texto2;
          guardarFormato(Utilidades.FORMATO_COTIZACION_AP, 1, false);
          guardarFormato(Utilidades.FORMATO_COMISION_AP, 1, false);
        }
        if(texto3.isNotEmpty){
          Utilidades.cotizacionesApp.listaCotizaciones[2].comparativa.nombre = texto3;
          guardarFormato(Utilidades.FORMATO_COTIZACION_AP, 2, false);
          guardarFormato(Utilidades.FORMATO_COMISION_AP, 2, false);
        }
        if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >1 && mostrarFcomparativa){
          guardarFormatoComparativa();
        }
      }
      if(abrirPdf && texto1.isNotEmpty){
        if(idFormato != Utilidades.FORMATO_COMPARATIVA){
          Utilidades.cotizacionesApp.listaCotizaciones[index].comparativa.nombre = texto1;
        }
        guardarFormato(idFormato, index, true);
      }
    });
  }

  guardarFormato( int idformato, int index, bool abrirPdf) async {
    //if(deboGuardarCotizacion){

      final Trace saveCot = FirebasePerformance.instance.newTrace("SoySocio_GuardarCotizacion");
      saveCot.start();
      print(saveCot.name);

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {


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

        ////TO DO: Revisar esta cambio. HAY UNA BRECHA EN EL SERVICIO DEL BACK 1 - POLIZA, 2 - COMPARATIVA, 3 - COMISIONES
        Map<String, dynamic> jsonMap = {
          "idUsuario": datosUsuario.idparticipante.toString(),
          "idAplicacion": Utilidades.idAplicacion,
          "codIntermediario": datosPerfilador.intermediarios.toString().replaceAll("[", "").replaceAll("]", ""),
          "idPlan": idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
          "idFormato": idformato,
          "titularCotizacion": titular, //NOMBRE DEL TITULAR sacarlo de formulario
          "requestCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString(),
          "responseCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString(),
          "responseResumen": resumen,
          "nombreCotizacion": idformato != Utilidades.FORMATO_COMPARATIVA ? Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre != null ?  Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre : "Propuesta " + (index+1).toString() : "Prueba AP",
        };

        /*Utilidades.LogPrint("REQUEST: " + Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString());
        Utilidades.LogPrint("RESPONSE: " + json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString());
        Utilidades.LogPrint("RESUMEN: " + resumen);*/
        var request = MyRequest(
            baseUrl: AppConfig.of(context).urlBase,
            path: Constants.GUARDA_COTIZACION,
            method: Method.POST,
            body: jsonEncode(jsonMap).toString(),
            headers: headers
        );

        MyResponse response = await RequestHandler.httpRequest(request);
        if(response.success){
          saveCot.stop();
          Utilidades.LogPrint("COT GUARDADA: \ " + json.encode(jsonMap).toString());
          Utilidades.LogPrint("RESPONSE COT G: " + response.response.toString());
          //saveCot.stop();
          this.setState(() {
            isLoading = false;

            int folio = response.response["folio"];
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
            // _initialWebView();

            if(abrirPdf){
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => CotizacionPDF(
                      id: index+1,
                      folio: folio,
                      idFormato: idformato,
                      id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.buscaCampoPorFormularioID(index, 6, 23, false)[0].valor,
                    ),
                  ));
            }


          });
        }else{
          saveCot.stop();
          isLoading = false;
          String message = response.response['message'] != null ? response.response['message'] : response.response['errors'][0] != null ? response.response['errors'][0] : "Error del servidor";
          Utilidades.mostrarAlertas(Mensajes.titleError, message, context);
        }

      }else {
        saveCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          guardaCotizacion(index, idformato, abrirPdf);
        });
      }


   // }
  }


  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  @override
  void initState() {
    if(widget.jsonMap==null){
      //widget.jsonMap = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().getJSONComparativa();
      //eliminar la linea funciona para no mandar adicionales
      widget.jsonMap = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().getJSONComparativaSinAsegurados();
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

  }

  generarCotizacion(BuildContext context) async{

    final Trace generaCot = FirebasePerformance.instance.newTrace("SoySocio_GenerarCotizacion");
    generaCot.start();
    print(generaCot.name);
    bool success = false;

    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      try{

        Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

        Response response = await post(AppConfig.of(context).urlBase + Constants.GENERA_COTIZACION, body: json.encode(widget.jsonMap), headers: headers);
        Utilidades.LogPrint(json.encode(widget.jsonMap));
        int statusCode = response.statusCode;

        Utilidades.LogPrint("RESPONSE COT: " + response.body.toString());
        if(response.body != null && response.body.isNotEmpty){
          if (statusCode == 200) {
                generaCot.stop();

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
                    Utilidades.sendAnalyticsBatch(context, CotizadorAnalitycsTags.generarSeccionCalculo(response));
                    Utilidades.sendAnalyticsBatch(context, CotizadorAnalitycsTags.generarSeccionDatosCotizador());
                    lista_secciones = CotizadorAnalitycsTags.getListaSeccionesGTM(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion());

                    Utilidades.sendAnalyticsBatch(context, lista_secciones);
                  }catch(e){
                    print("Error al generar analytics");
                  }

                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().setrequestCotizacion(json.encode(widget.jsonMap).toString());
                  //Utilidades.LogPrint("JSONMAP: " + widget.jsonMap.toString());

                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().setresponseCotizacion(json.decode(response.body));
                  //Utilidades.LogPrint("REQUEST COT: " + response.body.toString());

                });
              }else if(statusCode != null) {
            generaCot.stop();
            isLoading = false;
            //Navigator.pop(context);
            String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";

            success =  true;
            Utilidades.mostrarAlertas(Mensajes.titleLoSentimos , message, context);
          }

        }else{
          generaCot.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            generarCotizacion(context);
          });
        }

      }catch(e,s){
        generaCot.stop();
        await FirebaseCrashlytics.instance.recordError(e, s, reason: "an error occured: $e");
      }

      }else{
        generaCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          generarCotizacion(context);
        });
      }

    return success;

  }



  guardaCotizacion(int index, int idformato, bool abrirPdf) async{

    bool deboGuardarCotizacion = true;
    switch(idformato){
      case Utilidades.FORMATO_COMISION:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION !=null){
         // _initialWebView();
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
         // _initialWebView();
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
         // _initialWebView();
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
          //_initialWebView();
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

    if(idformato != Utilidades.FORMATO_COMPARATIVA){
      Utilidades.sendAnalytics(context, "Acciones", "Vista Previa" + " / " + Utilidades.tipoDeNegocio);
    }

    bool success = false;
    if(deboGuardarCotizacion){
      if(abrirPdf){
        showModalGuardar(idformato, index, abrirPdf, mostrarFcomparativa);
      }else{
        guardarFormato(idformato, index, abrirPdf);
      }
    }else{
      success = true;
    }

    return success;

  }

  void limpiarDatos(){

    Utilidades.mostrarAlertaBorrarCallback(Mensajes.titleLimpia, Mensajes.limpiaDatos, context, (){
      Navigator.pop(context);
    }, (){
      Utilidades.cotizacionesApp.limpiarComparativa();

      Navigator.of(context).popUntil(ModalRoute.withName('/cotizadorUnicoAP'));
      Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);
    });

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
    Utilidades.sendAnalytics(context, "Acciones", "Comparativa" + " / " + Utilidades.tipoDeNegocio);
    guardaCotizacion(0, Utilidades.FORMATO_COMPARATIVA, false);
  }


  // ignore: missing_return
  Widget showModalGuardar(int idFormato, int index, bool abrirPdf, bool mostrarFormato){
    double altoModal = mostrarFormato ? (Utilidades.cotizacionesApp.getCotizacionesCompletas() > 2 && abrirPdf == false ? 497 : Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1 && abrirPdf == false ? 430 : 295) : (Utilidades.cotizacionesApp.getCotizacionesCompletas() > 2 && abrirPdf == false ? 437 : Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1 && abrirPdf == false ? 360 : 295);
     showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: AppColors.color_titleAlert.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => AnimatedPadding(
        duration: Duration(milliseconds: 0),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: altoModal,
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
                    padding: EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
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
                          padding: const EdgeInsets.only(right: 24.0, left: 24.0),
                          child: listaCheck(ispropuesta1: propuesta1, ispropuesta2: propuesta2, ispropuesta3: propuesta3, ispropuesta4: comparativa, guardarPropuestas: guardarPropuestas, idFormato: idFormato, index: index, abrirPdf: abrirPdf, mostrarFormato: mostrarFormato,),
                        ),
                      ],),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
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
        color: AppColors.primary700,
        progressIndicator: SizedBox(
          width: 100.0,
          height: 100.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 5.0,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.chevron_left, size: 35,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  iconTheme: IconThemeData(color: AppColors.color_primario),
                  backgroundColor: Colors.white,
                  title: Text("Tabla comparativa", style: TextStyle(color: AppColors.color_appBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500, fontFamily: "Roboto", letterSpacing: 0.15)),
                  actions: <Widget>[
                    PopupMenuButton(icon: Image.asset('assets/icon/cotizador/ic_appbar.png'),
                        offset: Offset(100, 100),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Column(
                              children: <Widget>[
                                Divider(height: 4,color: AppColors.color_divider,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(Mensajes.acciones,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: AppColors.color_popupmenu,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                          )
                                      ),
                                      Spacer(flex: 1,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value:2,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0,right: 16.0, left: 16.0),
                                      child: Text(Mensajes.guarda,
                                          style: TextStyle(
                                              color: AppColors.color_appBar,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: 0.15)
                                      ),
                                    ),
                                    Spacer(flex: 2,),
                                    IconButton(
                                      icon: Image.asset('assets/icon/cotizador/guardar_Enabled.png'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        //TextEditingController nombrePropuesta1Controller = TextEditingController();

                                        showModalGuardar(0, 0 , false,mostrarFcomparativa);
                                      },),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                  child: Divider(height: 2,color: AppColors.color_divider,),
                                ),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value:3,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0,right: 16.0, left: 16.0),
                                      child: Text(Mensajes.titleLimpia,
                                          style: TextStyle(
                                            color: AppColors.color_appBar,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 0.15,)
                                      ),),
                                    Spacer(flex: 2,),
                                    IconButton(
                                      icon: Image.asset('assets/icon/cotizador/ic_borrar.png'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        limpiarDatos();
                                      },),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
                                  child: Divider(height: 2,color: AppColors.color_divider,),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Column(
                              children: <Widget>[
                                Divider(height: 4,color: AppColors.color_divider,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(Mensajes.soporte,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: AppColors.color_popupmenu,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 1.5,)),
                                      Spacer(flex: 1,)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                      child: Text(Mensajes.misCotizaciones,
                                          style: TextStyle(
                                            color: AppColors.color_appBar,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 0.15,)
                                      ),),
                                    Spacer(flex: 2,),
                                    IconButton(
                                      icon: Image.asset('assets/icon/cotizador/miscotizaciones.png'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(context,  MaterialPageRoute(
                                          builder: (context) => MisCotizaciones(),
                                        ));
                                      },),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                  child: Divider(height: 2,color: AppColors.color_divider,),
                                ),
                              ],
                            ),
                          ),
                        ],
                        initialValue: 0,
                        onCanceled: () {
                          print("You have canceled the menu.");
                        },
                        onSelected: (value) {
                          switch (value) {
                            case 2:
                              showModalGuardar(0, 0 , false, mostrarFcomparativa);
                              break;
                            case 3:
                              limpiarDatos();
                              break;
                            case 4:
                              Navigator.push(context,  MaterialPageRoute(
                                builder: (context) => MisCotizaciones(),
                              ));
                              break;
                          }
                        }
                    ),
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
                              padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 16.0),
                              child: Text("Solicitantes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.color_appBar, letterSpacing: 0.15),),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0),
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
                              //Agregar cotización
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
                                                    style: TextStyle(color:AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
                                                  ),
                                                )
                                            ),
                                            Spacer(),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                padding: const EdgeInsets.only(right: 8.0, bottom: 0.0),
                                                height: 45,
                                                width: 45,
                                                child: FittedBox(
                                                  child: FloatingActionButton(
                                                    onPressed: _aumentar,
                                                    elevation: 0.0,
                                                    heroTag: "btn1",
                                                    tooltip: "Agregar",
                                                    child: Icon(Icons.add, color: AppColors.secondary900,),
                                                    backgroundColor: Colors.white,
                                                  ),
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
                              //Cotizaciones
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
                                                        color: AppColors.primary700, fontWeight: FontWeight.w400),
                                                  ),
                                                  SizedBox(width: 60.0,),
                                                ],
                                              ),
                                            ),
                                          ));
                                        }
                                        return listaitems;

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
                                                    guardaCotizacion(index, Utilidades.cotizacionesApp.getCotizacionElement(index).paso1.documentos_configuracion[i].id, true);
                                                  }
                                                });
                                              },
                                              child: Text("Ver " + doc.nombreDocumento.toLowerCase().replaceAll("ap", ""), style: TextStyle(color: AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.25),),
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
                                            padding: const EdgeInsets.only(right: 16.0,left: 16.0),
                                            child: Container(
                                              margin: EdgeInsets.only(left: 0.0,right: 0.0, top: 8.0),
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    height: 332,
                                                    width: 312,
                                                    margin: EdgeInsets.only(top: 8.0,right: 8.0),
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
                                                              child: Text( Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre != null ?  Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.nombre : "Cotización " + (index+1).toString(),
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
                                                                          style: TextStyle(color: AppColors.color_appBar,fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5), textAlign: TextAlign.left,
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
                                                              ] : <Widget>[//
                                                                Text(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].forma,
                                                                  style: TextStyle(
                                                                      color: AppColors.color_appBar,fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5), textAlign: TextAlign.left,),
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
                                                                child: Text("Prima total", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.color_appBar, letterSpacing: 0.4),
                                                                  textAlign: TextAlign.center,),
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                width: 144,
                                                                height: 16,
                                                                child: Text(parcialidades,
                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.color_appBar, letterSpacing: 0.4),
                                                                  textAlign: TextAlign.center,),
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
                                                              style: TextStyle(color: AppColors.color_appBar, fontSize: 20,fontWeight: FontWeight.w600, letterSpacing: 0.15),
                                                              textAlign: TextAlign.center,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                            width: 144,
                                                            height: 40,
                                                            child: Text(montoParcial,
                                                              style: TextStyle(color: AppColors.color_appBar, fontSize: 20,fontWeight: FontWeight.w600, letterSpacing: 0.15),
                                                              textAlign: TextAlign.center,),
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
                                                              IconButton(icon: Image.asset("assets/icon/cotizador/edit.png", height: 18, width: 18,),alignment: Alignment.centerRight, onPressed: null,),
                                                              FlatButton(
                                                                textColor: AppColors.secondary900,
                                                                onPressed: (){
                                                                  editarDatos(index);
                                                                },
                                                                child: Text(Mensajes.edicion,
                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.25), textAlign: TextAlign.left,),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 0.0,
                                                      child: SizedBox(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        child: FloatingActionButton(
                                                          heroTag: null, //Se establece en null para evitar que choque con el btn1 de Agregar
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
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos_configuracion[i].id == 2 ? Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: FlatButton(
                                              disabledTextColor: AppColors.color_disable,
                                              textColor: Utilidades.cotizacionesApp.getCotizacionesCompletas() >1 ? AppColors.secondary900 : AppColors.color_disable,
                                              onPressed: (){
                                                setState(() {
                                                 // var list = Utilidades.cotizacionesApp.getCotizacionElement(0).paso1.documentos_configuracion as List;
                                                  mostrarFcomparativa = true;
                                                });
                                                if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >1){
                                                  guardaCotizacion(index, Utilidades.FORMATO_COMPARATIVA, true);
                                                }else{
                                                  return null;
                                                }
                                              },
                                              child: Text(Mensajes.btn_formatoComp,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.25),
                                                textAlign: TextAlign.center,),
                                            ),
                                          ): Container(padding: const EdgeInsets.all(16.0),),
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
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    width: 294,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0,),
                                                      child: Text(
                                                        ("Prima total"), overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.color_titleAlert, letterSpacing: 0.15),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0, right:0, top:8, ),
                                                    child: RenglonTablaDoscolumna(titulo: "Titular",
                                                        valor:"\$ " + Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].ptotal.toString()
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0, right:0, top:8, bottom: 12.0,),
                                                    child: RenglonTablaDoscolumna(titulo: "Total",
                                                        valor:"\$ " + Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formaspago[Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.formapagoseleccionada].ptotal.toString()
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      itemCount: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones.length,
                                                      shrinkWrap: true,
                                                      physics: ScrollPhysics(),
                                                      itemBuilder: (BuildContext ctxt, int j) {

                                                        return Padding(padding: EdgeInsets.only(bottom: 20, right: 0.0, left: 0.0),
                                                          child: Visibility(
                                                            visible: Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].tabla.length > 0,
                                                            child: Column(
                                                              children: <Widget>[
                                                                //Titulo de seccion
                                                                Container(
                                                                  height: 40,
                                                                  width: 294,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0,),
                                                                    child: Text(
                                                                      (Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.secciones[j].seccion), overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.color_titleAlert, letterSpacing: 0.15),
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
                                                          ),
                                                        );

                                                      }),
                                                ],
                                              ),
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
                  ],
                )
            ),

          ],
        ),
      ),
    );



  }


}

class listaCheck extends StatefulWidget {
  listaCheck({Key key, this.ispropuesta1, this.ispropuesta2, this.ispropuesta3, this.ispropuesta4, this.guardarPropuestas, this.idFormato, this.index, this.abrirPdf, this.mostrarFormato}) : super(key: key);

  @override
  _listaCheckState createState() => _listaCheckState();
  bool ispropuesta1 = false,ispropuesta2 = false, ispropuesta3 = false, ispropuesta4 = false;
  bool abrirPdf, mostrarFormato;
  int idFormato, index;
  final void Function(String t1, String t2, String t3, String t4, int idFormato, int index, bool abrirPdf) guardarPropuestas;
  final namePropuesta1Controller = new TextEditingController();
  final namePropuesta2Controller = new TextEditingController();
  final namePropuesta3Controller = new TextEditingController();
  final nametablaCompController = new TextEditingController();

}

class _listaCheckState extends State<listaCheck> {
  bool propuesta1;
  bool propuesta2;
  bool propuesta3;
  bool comparativa;
  bool abrirPdf;
  int idFormato, index;
  String texto1 = "";
  String texto2 = "";
  String texto3 = "";
  String texto4 = "";
  @override
  Widget build(BuildContext context) {
    if(propuesta1 != null){
      widget.ispropuesta1 = propuesta1;
    }
    if(propuesta2 != null){
      widget.ispropuesta2 = propuesta2;
    }
    if(propuesta3 != null){
      widget.ispropuesta3 = propuesta3;
    }
    if(comparativa != null){
      widget.ispropuesta4 = comparativa;
    }
    if(texto1 != null){
      widget.namePropuesta1Controller.text = texto1;
    }
    if(texto2 != null){
      widget.namePropuesta2Controller.text = texto2;
    }
    if(texto3 != null){
      widget.namePropuesta3Controller.text = texto3;
    }
    if(texto4 != null){
      widget.nametablaCompController.text = texto4;
    }
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.secondary900,
                width:4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white
              ),
              child: Checkbox(
                value: widget.ispropuesta1,
                onChanged: (value){
                  setState(() {
                    widget.ispropuesta1 = value;
                    propuesta1 = widget.ispropuesta1;
                    print(value);
                  });
                },
                activeColor: Colors.white,
                checkColor: AppColors.secondary900,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              onChanged: (text) {
                setState(() {
                  widget.namePropuesta1Controller.text = text;
                  texto1 = widget.namePropuesta1Controller.text;
                });
              },
              keyboardType: TextInputType.text,
              inputFormatters: [LengthLimitingTextInputFormatter(30), WhitelistingTextInputFormatter(RegExp("[A-Za-zÀ-ÿ\u00f1\u00d10-9 ]")),],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12.0),
                labelText: widget.abrirPdf == true && widget.idFormato != Utilidades.FORMATO_COMPARATIVA ? Mensajes.propuesta +" "+ (widget.index + 1).toString() : widget.abrirPdf == true && widget.idFormato == Utilidades.FORMATO_COMPARATIVA ?  Mensajes.tabla_Comp : Mensajes.propuesta + " 1",
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
        Visibility(
          visible: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1 && widget.abrirPdf == false,
          child: Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: Row(children: <Widget>[
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary900,
                    width:4,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Colors.white
                  ),
                  child: Checkbox(
                    value: widget.ispropuesta2,
                    onChanged: (bool value){
                      if(Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1) {
                        setState(() {
                        widget.ispropuesta2 = value;
                        propuesta2 = widget.ispropuesta2;
                        print(widget.ispropuesta2.toString());
                      });
                      }else{
                        null;
                      }
                    },
                    activeColor: Colors.white,
                    checkColor: AppColors.secondary900,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  enabled: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1,
                  onChanged: (text) {
                    setState(() {
                      widget.namePropuesta2Controller.text = text;
                      texto2 = widget.namePropuesta2Controller.text;
                    });
                  },
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(30), WhitelistingTextInputFormatter(RegExp("[A-Za-zÀ-ÿ\u00f1\u00d10-9 ]")),],
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
        ),
        Visibility(
          visible: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 2 && widget.abrirPdf == false,
          child: Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: Row(children: <Widget>[
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary900,
                    width:4,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Colors.white
                  ),
                  child: Checkbox(
                    value: widget.ispropuesta3,
                    onChanged: (bool value){
                      if(Utilidades.cotizacionesApp.getCotizacionesCompletas() > 2) {
                        setState(() {
                          widget.ispropuesta3 = value;
                          propuesta3 = widget.ispropuesta3;
                          print(widget.ispropuesta3.toString());
                        });
                      }else{
                        null;
                      }
                    },
                    activeColor: Colors.white,
                    checkColor: AppColors.secondary900,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  enabled: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 2,
                  onChanged: (text) {
                    setState(() {
                      widget.namePropuesta3Controller.text = text;
                      texto3 = widget.namePropuesta3Controller.text;
                    });
                  },
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(30), WhitelistingTextInputFormatter(RegExp("[A-Za-zÀ-ÿ\u00f1\u00d10-9 ]")),],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12.0),
                    labelText: Mensajes.propuesta + " 3",
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
        ),
        Visibility(
          visible: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1 && widget.abrirPdf == false && widget.mostrarFormato == true,
          child: Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Row(children: <Widget>[
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary900,
                    width:4,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Colors.white
                  ),
                  child: Checkbox(
                    value: widget.ispropuesta4,
                    onChanged: (bool value){
                      if(Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1) {
                        setState(() {
                        widget.ispropuesta4 = value;
                        comparativa = widget.ispropuesta4;
                        print(widget.ispropuesta4.toString());
                      });
                      }else{
                        null;
                      }
                    },
                    activeColor: Colors.white,
                    checkColor: AppColors.secondary900,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  enabled: Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1,
                  onChanged: (text) {
                    setState(() {
                      widget.nametablaCompController.text = text;
                      texto4 = widget.nametablaCompController.text;
                    });
                  },
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(30), WhitelistingTextInputFormatter(RegExp("[A-Za-zÀ-ÿ\u00f1\u00d10-9 ]")),],
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 0, right: 0),
          child: Divider(thickness: 1,
            color: AppColors.color_borde,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0,),
          child: ButtonTheme(
            minWidth: 340.0,
            height: 40.0,
            buttonColor: AppColors.secondary900,
            child: RaisedButton(
              onPressed: ((){
                if(texto1.isNotEmpty && texto1 != null){
                  if(widget.abrirPdf && widget.idFormato != Utilidades.FORMATO_COMPARATIVA){
                    Utilidades.cotizacionesApp.listaCotizaciones[widget.index].comparativa.nombre = widget.namePropuesta1Controller.text;
                  }
                  else{
                    Utilidades.cotizacionesApp.listaCotizaciones[0].comparativa.nombre = widget.namePropuesta1Controller.text;
                  }
                }
                if(texto2 != null && texto2.isNotEmpty){
                  Utilidades.cotizacionesApp.listaCotizaciones[1].comparativa.nombre = widget.namePropuesta2Controller.text;
                }
                if(texto3.isNotEmpty && texto3 != null){
                  Utilidades.cotizacionesApp.listaCotizaciones[2].comparativa.nombre = widget.namePropuesta3Controller.text;
                }
                /*if(texto3.isNotEmpty && texto3 != null){
                  Utilidades.cotizacionesApp.listaCotizaciones[2].comparativa.nombre = widget.nametablaCompController.text;
                }*/
                Navigator.pop(context);
                widget.guardarPropuestas(texto1,texto2,texto3, texto4, widget.idFormato, widget.index, widget.abrirPdf);
              }),
              child: Text(Mensajes.guarda,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,letterSpacing: 1.25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
