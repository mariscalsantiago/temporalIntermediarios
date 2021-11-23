import 'package:cotizador_agente/CotizadorUnico/Analytics/CotizadorAnalyticsTags.dart';
import 'package:cotizador_agente/CotizadorUnico/FormularioPaso1.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos/response_cotizacion/motor_dinamico_forma_pago.dart';
import 'package:cotizador_agente/modelos/response_cotizacion/resumen_cotizacion_forma_pago.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';



class CotizacionVista extends StatefulWidget {

  Map<String, dynamic> jsonMap;

  CotizacionVista({Key key, this.jsonMap}) : super(key: key);


  @override
  _CotizacionVistaState createState() => _CotizacionVistaState();
}

class _CotizacionVistaState extends State<CotizacionVista> with AutomaticKeepAliveClientMixin {

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
  bool isOpen = true;
  bool isClose = false;
  bool openExpande = true;

  List<List<PopupMenuItem>> _paymentMethodMenuItems = [];

  bool cotizacionUno = false;
  bool cotizacionDos= false;
  bool cotizacionTres = false;
  bool cotizacionComparativa = false;

  TextEditingController nombreUno = new TextEditingController();
  TextEditingController nombreDos = new TextEditingController();
  TextEditingController nombreTres = new TextEditingController();
  TextEditingController nombreCuatro = new TextEditingController();
  FocusNode focusNombreUno = new FocusNode();
  FocusNode focusNombreDos = new FocusNode();
  FocusNode focusNombreTres = new FocusNode();


  @override
  void initState() {
    cotizacionUno = false;
    cotizacionDos = false;
    cotizacionTres = false;
    cotizacionComparativa = false;

    nombreUno.text = "";
    nombreDos.text = "";
    nombreTres.text = "";
    nombreCuatro.text = "";

    //_getMenuItems();

    _generarCotizacion();
  }

  @override
  bool get wantKeepAlive => true;

  guardaCotizacion(int index, int idformato, String nombreFormato, bool esGuardar) async{
    bool deboGuardarCotizacion = true;
    switch(idformato){
      case Utilidades.FORMATO_COMISION:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION !=null){

          deboGuardarCotizacion = false;
          if(!esGuardar) {
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) =>
                      CotizacionPDF(
                        id: index + 1,
                        folio: Utilidades.cotizacionesApp
                            .getCotizacionElement(index)
                            .comparativa
                            .FOLIO_FORMATO_COMISION,
                        idFormato: idformato,
                        id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA
                            ? "99"
                            : Utilidades.cotizacionesApp
                            .listaCotizaciones[index].idPlan,
                      ),
                ));
          }

        }

        break;

      case Utilidades.FORMATO_COTIZACION:
        if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION !=null){

          deboGuardarCotizacion = false;
          if(!esGuardar) {
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) =>
                      CotizacionPDF(
                        id: index + 1,
                        folio: Utilidades.cotizacionesApp
                            .getCotizacionElement(index)
                            .comparativa
                            .FOLIO_FORMATO_COTIZACION,
                        idFormato: idformato,
                        id_Plan: idformato == Utilidades.FORMATO_COMPARATIVA
                            ? "99"
                            : Utilidades.cotizacionesApp
                            .listaCotizaciones[index].idPlan,
                      ),
                ));
          }
        }

        break;

    }
    if(idformato != Utilidades.FORMATO_COMPARATIVA){
      Utilidades.sendAnalytics(context, "Acciones", "Vista Previa" + " / " + Utilidades.tipoDeNegocio);
    }

    bool success = false;
    if(deboGuardarCotizacion || esGuardar){


      final Trace saveCot = FirebasePerformance.instance.newTrace("CotizadorUnico_GuardarCotizacion");
      saveCot.start();
      print(saveCot.name);


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
                    "secciones": Utilidades.cotizacionesApp.getCotizacionElement(i).responseCotizacion["resumenCotizacion"]["secciones"],
                    "formasPago": Utilidades.cotizacionesApp.getCotizacionElement(i).responseCotizacion["resumenCotizacion"]["formasPago"],
                    "banComparativa" : 1,
                    "responseResumen": Utilidades.cotizacionesApp.getCotizacionElement(i).generarResponseResumenComparativa(),
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
            print("nombre -----> ${nombre}");
            Map<String, dynamic> jsonMap = {
              "idUsuario": datosUsuario.idparticipante.toString(),
              "idAplicacion": Utilidades.idAplicacion,
              "codIntermediario": datosPerfilador.intermediarios.toString().replaceAll("[", "").replaceAll("]", ""),
              "idPlan": idformato == Utilidades.FORMATO_COMPARATIVA ? "99" : Utilidades.cotizacionesApp.listaCotizaciones[index].idPlan,
              "idFormato": idformato,
              "titularCotizacion": titular, //NOMBRE DEL TITULAR sacarlo de formulario
              "requestCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString(),
              "responseCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString(),
              "responseResumen": resumen,
              "nombreCotizacion": nombreFormato,
              "origenCotizacion": true
            };

            /*Utilidades.LogPrint("REQUEST: " + Utilidades.cotizacionesApp.getCotizacionElement(index).requestCotizacion.toString());
        Utilidades.LogPrint("RESPONSE: " + json.encode(Utilidades.cotizacionesApp.getCotizacionElement(index).responseCotizacion).toString());
        Utilidades.LogPrint("RESUMEN: " + resumen);*/

            //se hace validacion de si el formato trae folio para modificar el jsonMap y agregarle el parametro de folio para que el servicio actualice la cotizacion
            switch(idformato){
              case Utilidades.FORMATO_COMISION:
                if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION !=null){
                  jsonMap["folio"] = Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COMISION;
                }
                break;
              case Utilidades.FORMATO_COTIZACION:
                if(Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION !=null){
                  jsonMap["folio"] = Utilidades.cotizacionesApp.getCotizacionElement(index).comparativa.FOLIO_FORMATO_COTIZACION;
                }
                break;
            }

            String mapa = json.encode(jsonMap);
            //log('Url guarda cotizacion ${mainConfiguration.urlGuardaCotizacion}');
            //log(mapa);
            Response response = await post(Utilidades.urlGuardar, body: json.encode(jsonMap), headers: headers);
            int statusCode = response.statusCode;
            /*Utilidades.LogPrint("COT GUARDADA: \ " + json.encode(jsonMap).toString());
        Utilidades.LogPrint("RESPONSE COT G: " +json.encode(response.body).toString());*/


            if(response.body != null && response.body.isNotEmpty){
              if (statusCode == 200) {
                saveCot.stop();

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

                  }

                  if(!esGuardar) {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CotizacionPDF(
                                id: index + 1,
                                folio: folio,
                                idFormato: idformato,
                                id_Plan: idformato == Utilidades
                                    .FORMATO_COMPARATIVA ? "99" : Utilidades
                                    .cotizacionesApp.listaCotizaciones[index]
                                    .idPlan,
                              ),
                        ));
                  } else {

                  }

                });

              }else if(statusCode != null) {
                saveCot.stop();
                isLoading = false;
                String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                Utilidades.mostrarAlertas("Error: " + statusCode.toString(), message, context);
              }

            }else{
              saveCot.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                guardaCotizacion(index, idformato, "", false);
              });
            }

          }catch(e){
            saveCot.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              guardaCotizacion(index, idformato, "", false);
            });
          }

        }else {
          saveCot.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            guardaCotizacion(index, idformato, "", false);
          });
        }
      }catch(e){
        saveCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          guardaCotizacion(index, idformato, "", false);
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

  void editarDatos(int index) {
    if (Utilidades.cotizacionesApp.getCotizacionesCompletas() < 3) {
      FormularioCotizacion temporal =
      Utilidades.cotizacionesApp.getCotizacionElement(index);

      final paso1Copia = temporal.paso1.copy();
      final paso2Copia = temporal.paso2.copy();

      FormularioCotizacion copia = FormularioCotizacion(
        paso1: paso1Copia,
        paso2: paso2Copia,
      );
      copia.idPlan = temporal.idPlan.toString();

      Utilidades.cotizacionesApp.agregarCotizacion(copia);
      Utilidades.editarEnComparativa = true;
      Navigator.pushNamed(
        context,
        "/cotizadorUnicoAPPasoUno",
      );
    } else {
      Utilidades.mostrarAlerta(
        Mensajes.titleAdver,
        Mensajes.limiteCotizacion,
        context,
      );
    }
  }

  void guardarFormatoComparativaAcciones(){
    setState(() {
      esComparativa = true;
    });

    Utilidades.sendAnalytics(context, "Acciones", "Comparativa" + " / " + Utilidades.tipoDeNegocio);
    //guardaCotizacion(0, Utilidades.FORMATO_COMPARATIVA, nombre, esGuardar);
  }

  void cambioCheckGuardado(bool value, int indice){
    switch(indice){
      case 1:
        setState(() {
          cotizacionUno = value;
          print("cotizacionUno ${cotizacionUno}");
        });
        break;
      case 2:
        setState(() {
          cotizacionDos = value;
        });
        break;
      case 3:
        setState(() {
          cotizacionTres = value;
        });
        break;
      case 4:
        setState(() {
          cotizacionComparativa = value;
        });
        break;
    }
  }

  void cerrar(){
    Navigator.pop(context);
  }

  void alertaCotizacionesGuardadas(){
    double dataHeight = MediaQuery.of(context).size.height;
    double dataWidth = MediaQuery.of(context).size.width;
    AlertDialog alert = AlertDialog(
        content: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: dataHeight* 0.06),
                  child: Text("Formatos guardados(s) correctamente",
                      style: TextStyle(
                          fontSize: 20,
                          color: ColorsCotizador.color_appBar,
                          letterSpacing: 0.2
                      )
                  )
              ),
              Container(
                width: dataWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: ColorsCotizador.color_borde,
                      thickness: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: CupertinoButton(
                        color: ColorsCotizador.secondary900,
                        onPressed: (){
                          cerrar();
                        },
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          child: Text("Aceptar", style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            alert,
            Positioned(
              top: dataHeight *0.33,
              left: dataWidth * 0.83,
              child: CupertinoButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      width: 1,
                      color: ColorsCotizador.color_disable,
                    ),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: ColorsCotizador.secondary900,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void iniciaLoading(){
    setState(() {
      isLoading = true;
    });
  }

  void finLoading(){
    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> dialogo(BuildContext context){
    String mensaje = "Selecciona los documentos que deseas guardar. Recuerda que los podrás revisar en la sección de Mis cotizaciones.";
    int cantidad = Utilidades.cotizacionesApp.getCurrentLengthLista();

    print("CAntidad......> ${cantidad}");
    double alturaHeight = cantidad == 1 ? 300 : cantidad == 2 ? 360 : cantidad == 3 ? 420 : 0;
    return
      showMaterialModalBottomSheet(
      barrierColor: AppColors.AzulGNP.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context, scrollController) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              margin: EdgeInsets.only(
                  top: focusNombreUno.hasFocus || focusNombreDos.hasFocus || focusNombreTres.hasFocus
                      ? MediaQuery.of(context).size.height / 2 -
                      MediaQuery.of(context)
                          .viewInsets
                          .bottom // adjust values according to your need
                      : cantidad == 1 ? 380 : cantidad == 2 ? 320 : cantidad == 3 ? 260 : 0),
              height: MediaQuery.of(context).size.height,
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
                        padding: EdgeInsets.only(top:0.0),
                        child:Center(child: new Text("Guardar cotización", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.AzulGNP),)),
                      ),
                      SingleChildScrollView(
                        //fit: BoxFit.contain,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                              child:SingleChildScrollView(child: new Text(mensaje, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.color_appBar),)),
                            ),
                            cantidad >= 1 ? Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: cotizacionUno,
                                    activeColor:  ColorsCotizador.secondary900,
                                    onChanged: (bool value) {
                                      print("value ${value}");
                                      setState(() {
                                        cambioCheckGuardado(value, 1);
                                      });
                                    },
                                  ),
                                  Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8),
                                        child: TextFormField(
                                            focusNode: focusNombreUno,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(30),
                                            ],
                                            enabled: cotizacionUno,
                                            style: new TextStyle(fontSize: 12),
                                            controller: nombreUno,
                                            decoration: new InputDecoration(
                                              labelText: "Nombre de propuesta 1",
                                              labelStyle: new TextStyle(
                                                  color: ColorsCotizador.color_Etiqueta
                                              ),
                                              contentPadding: EdgeInsets.all(10),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorsCotizador.color_Etiqueta,
                                                    width: 0.5
                                                ),
                                              ),
                                            ),
                                            onEditingComplete: () {
                                              focusNombreUno.unfocus();
                                            },
                                            onChanged: (value){
                                              focusNombreUno.unfocus();
                                            }
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ) : Container(),
                            cantidad >= 2 ? Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: cotizacionDos,
                                    activeColor:  ColorsCotizador.secondary900,
                                    onChanged: (bool value) {
                                      setState(() {
                                        cambioCheckGuardado(value, 2);
                                      });
                                    },
                                  ),
                                  Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8),
                                        child: TextFormField(
                                            focusNode: focusNombreDos,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(30),
                                            ],
                                            enabled: cotizacionDos,
                                            style: new TextStyle(fontSize: 12),
                                            controller: nombreDos,
                                            decoration: new InputDecoration(
                                              labelText: "Nombre de propuesta 2",
                                              labelStyle: new TextStyle(
                                                  color: ColorsCotizador.color_Etiqueta
                                              ),
                                              contentPadding: EdgeInsets.all(10),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorsCotizador.color_Etiqueta,
                                                    width: 0.5
                                                ),
                                              ),
                                            ),
                                            onEditingComplete: () {
                                              focusNombreDos.unfocus();
                                            },
                                            onChanged: (value){
                                              focusNombreDos.unfocus();
                                            }
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ) : Container(),
                            cantidad >= 3 ? Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: cotizacionTres,
                                    activeColor:  ColorsCotizador.secondary900,
                                    onChanged: (bool value) {
                                      setState(() {
                                        cambioCheckGuardado(value, 3);
                                      });
                                    },
                                  ),
                                  Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8),
                                        child: TextFormField(
                                            focusNode: focusNombreTres,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(30),
                                            ],
                                            enabled: cotizacionTres,
                                            style: new TextStyle(fontSize: 12),
                                            controller: nombreTres,
                                            decoration: new InputDecoration(
                                              labelText: "Nombre de propuesta 3",
                                              labelStyle: new TextStyle(
                                                  color: ColorsCotizador.color_Etiqueta
                                              ),
                                              contentPadding: EdgeInsets.all(10),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorsCotizador.color_Etiqueta,
                                                    width: 0.5
                                                ),
                                              ),
                                            ),
                                            onEditingComplete: () {
                                              focusNombreTres.unfocus();
                                            },
                                            onChanged: (value){
                                              focusNombreTres.unfocus();
                                            }
                                        ),
                                      )
                                  )
                                ],
                              ),
                            )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Divider(
                                color: ColorsCotizador.color_borde,
                                thickness: 1,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                /*setState(() {
                            isLoading = true;
                          });*/
                                iniciaLoading();
                                if(cotizacionUno){
                                  print("cotizacion uno ${nombreUno.text}");
                                  await guardaCotizacion(0, 1, nombreUno.text, true);
                                }
                                if(cotizacionDos){
                                  print("cotizacion uno ${nombreDos.text}");
                                  await guardaCotizacion(1, 1, nombreDos.text, true);
                                }
                                if(cotizacionTres){
                                  print("cotizacion uno ${nombreTres.text}");
                                  await guardaCotizacion(2, 1, nombreTres.text, true);
                                }
                                if(cotizacionUno || cotizacionDos || cotizacionTres ) {
                                  alertaCotizacionesGuardadas();
                                }
                                finLoading();
                                /*setState(() {
                            isLoading = true;
                          });*/
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: EdgeInsets.only(right: 32, left: 32, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.secondary900,
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: Text("Guardar", style: TextStyle(
                                    letterSpacing: 1.25,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }
      )
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Guardar':
        print("Guardar -->");
        focusNombreUno.requestFocus();
        dialogo(context);
        break;
      case 'Borrar datos':
        print("Limpiar Datos");
        Utilidades.mostrarAlertaCallbackBorrar(Mensajes.titleLimpia, Mensajes.limpiaDatos, context, (){
          Navigator.pop(context);

        }, (){

          limpiarDatos();

        });
        break;
      case 'Mis cotizaciones':
        print("Mis cotizaciones -->");
        Navigator.push(context,  MaterialPageRoute(
          builder: (context) => CotizacionesGuardadas(seCreaNueva: false),
        ));
        break;
    }
  }

  void eliminarCotizacionSinValor(){
    for(int i =0; i < Utilidades.cotizacionesApp.listaCotizaciones.length; i++){
      if( Utilidades.cotizacionesApp.listaCotizaciones[i].idPlan == null && Utilidades.editarEnComparativa){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      } else if(Utilidades.cotizacionesApp.listaCotizaciones[i].idPlan == null && nuevaCotizacionDesdeMisCotizaciones){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      } /*else if(Utilidades.cotizacionesApp.listaCotizaciones[i].seCotizo == false && Utilidades.cotizacionesApp.listaCotizaciones[i].paso2 != null ){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      }*//*else if(Utilidades.cotizacionesApp.listaCotizaciones[i].idPlan == null && Utilidades.cotizacionesApp.listaCotizaciones[i].paso2 == null){
        Utilidades.cotizacionesApp.listaCotizaciones.removeAt(i);
      }*/
    }
  }

  String leyendaTipoPago(String valor){
    if(valor == "1"){
      return "1 pago único por";
    } else if(valor == "2"){
      return "2 pagos semestrales de";
    }else if(valor == "4"){
      return "4 pagos trimestrales de";
    } else if(valor == "12"){
      return "12 pagos mensuales de";
    } else if(valor == "24"){
      return "24 pagos quincenales de";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    eliminarCotizacionSinValor();
    return WillPopScope(
      onWillPop: () async{
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().comparativa = null;
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().seCotizo = false;

        return true;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
              backgroundColor: ColorsCotizador.color_background_blanco,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Utilidades.color_primario),
                backgroundColor: Colors.white,
                title: Text("Tabla comparativa",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorsCotizador.texto_tabla_comparativa
                    )
                ),
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

              body: isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Utilidades.color_primario),),):
              Column(
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
                            child: Image.asset("assets/icon/cotizador/Solicitantes.png", height: 50, width: 50,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 16.0),
                            child: Text("Solicitantes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorsCotizador.gnpTextSytemt1),),
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
                  /*TopBar(recargarFormulario: limpiarDatos, formatoComp: guardarFormatoComparativa,),*/
                  Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Visibility(
                                visible: Utilidades.cotizacionesApp.getCotizacionesCompletas() < 3 ? true : false,
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text("Agregar cotización",
                                                style: TextStyle(
                                                    color:ColorsCotizador.color_appBar,
                                                    fontSize: 14),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                final cotizacionesLength = Utilidades.cotizacionesApp.listaCotizaciones.length;
                                                editarDatos(cotizacionesLength - 1);
                                              },
                                              child: const Icon(Icons.add,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: ColorsCotizador.color_Bordes, height: 2,),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount:  Utilidades.cotizacionesApp.getCurrentLengthLista(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  final FormularioCotizacion cotizacion =
                                  Utilidades.cotizacionesApp.getCotizacionElement(index);
                                  final comparativa = cotizacion.comparativa;

                                  if(comparativa == null){
                                    return Container();
                                  }

                                  final formaPago = cotizacion.formasPago[
                                  comparativa.formapagoseleccionada];

                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(width: 1.0, color: ColorsCotizador.color_Bordes),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))

                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(top: 16),
                                                          child: Text("Cotización ${index+1}", style: TextStyle(
                                                              color: ColorsCotizador.color_appBar,
                                                              letterSpacing: 0.15,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16

                                                          ),)
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Visibility(
                                                          visible: true,
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                              margin: EdgeInsets.only(top: 10),
                                                              decoration: BoxDecoration(
                                                                  color: ColorsCotizador.color_background_blanco,
                                                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                  border: Border.all(color: ColorsCotizador.color_Bordes, style: BorderStyle.solid, width: 1.0),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: ColorsCotizador.color_background,
                                                                        blurRadius: 1.0,
                                                                        spreadRadius: 1.0,
                                                                        offset: Offset(0.0, 1.5))
                                                                  ]
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(formaPago.formaPago,
                                                                        style: TextStyle(color: ColorsCotizador.color_Etiqueta, fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'Roboto', letterSpacing: 1.5),
                                                                        textAlign: TextAlign.center,
                                                                ),
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      /*Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Visibility(
                                                          visible: true,
                                                          child: Container(
                                                              margin: EdgeInsets.only(top: 10),
                                                              decoration: BoxDecoration(
                                                                  color: ColorsCotizador.color_background_blanco,
                                                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                  border: Border.all(color: ColorsCotizador.color_Bordes, style: BorderStyle.solid, width: 1.0),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: ColorsCotizador.color_background,
                                                                        blurRadius: 1.0,
                                                                        spreadRadius: 1.0,
                                                                        offset: Offset(0.0, 1.5))
                                                                  ]
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  PopupMenuButton(
                                                                    itemBuilder: (context) => _paymentMethodMenuItems[index],
                                                                    //initialValue: menuItems.first.value,
                                                                    onCanceled: () {
                                                                      print("You have canceled the menu.");
                                                                    },
                                                                    onSelected: (value) => _onSelectedPaymentMethod(value, index),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: <Widget>[
                                                                        Text(_obtenerNombreFormaDePagoSeleccionada(index),
                                                                          style: TextStyle(color: ColorsCotizador.color_Etiqueta, fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'Roboto', letterSpacing: 1.5),
                                                                          textAlign: TextAlign.right,
                                                                        ),
                                                                        _paymentMethodMenuItems[index].length > 1 ? Container(
                                                                            margin: EdgeInsets.only(left: 6.0),
                                                                            child: Icon(Icons.arrow_drop_down, color: ColorsCotizador.gnpTextUser, size: 30.0,))
                                                                            :Container(
                                                                          height: 30,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ),*/
                                                      Container(
                                                        padding: EdgeInsets.only(top: 8,bottom: 24),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(16.0),
                                                              bottomRight: const Radius.circular(16.0),)),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                    margin: EdgeInsets.only(right: 10),
                                                                    child: Column(
                                                                      children: [
                                                                        Text("Prima total",  style: TextStyle(
                                                                            color: ColorsCotizador.color_appBar, fontSize: 12,fontWeight: FontWeight.normal),),
                                                                        Text('\$ ${formaPago.primaTotal}',
                                                                          style: TextStyle(
                                                                              color: Utilidades.color_titulo,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w600,
                                                                              letterSpacing: 0.15
                                                                          ),),
                                                                      ],
                                                                    )
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.only(left: 10),
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                          '${leyendaTipoPago(formaPago.numPagos)}',
                                                                          style: TextStyle(
                                                                            color: ColorsCotizador.color_appBar, fontSize: 12,fontWeight: FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          formaPago.primaParcial,
                                                                          style: TextStyle( color: Utilidades.color_titulo, fontSize: 20,fontWeight: FontWeight.w600, letterSpacing: 0.15),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                            ListView.builder(
                                                                itemCount: cotizacion.paso1.documentos_configuracion.length,
                                                                shrinkWrap: true,
                                                                itemBuilder: (BuildContext ctxt, int i) {
                                                                  final paso1 = cotizacion.paso1;
                                                                  final jsonMap = cotizacion.jsonComparativa;
                                                                  final jsonGMMRequest = jsonMap["cotizacionGMMRequest"];
                                                                  final idPlan = jsonGMMRequest["idPlan"];
                                                                  Documento doc = paso1.documentos_configuracion[i];
                                                                  return (idPlan != "49" && doc.id != 2) || (idPlan == "49" && doc.id != 2 && doc.id != 3) ? GestureDetector(
                                                                    onTap: () {
                                                                      if((idPlan != "49" && doc.id != 2) || (idPlan == "49" && doc.id != 2 && doc.id != 3)){
                                                                        guardaCotizacion(index, paso1.documentos_configuracion[i].id, "", false);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      margin: const EdgeInsets.only(top: 24.0),
                                                                      padding: EdgeInsets.zero,
                                                                      child: Text("Ver ${doc.nombreDocumento.toLowerCase()}",
                                                                        style: TextStyle( color: ColorsCotizador.color_appBar, fontSize: 14,fontWeight: FontWeight.normal),
                                                                        textAlign: TextAlign.center,),
                                                                    ),
                                                                  ): Container();
                                                                }
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(top: 32.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap: (){
                                                                        setState(() {
                                                                          tieneEdad = true;
                                                                          tieneCP = true;
                                                                        });
                                                                        editarDatos(index);
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.edit,
                                                                            color: Colors.orange,
                                                                          ),
                                                                          Text("Editar", style: TextStyle(
                                                                              letterSpacing: 1.25,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16,
                                                                              color: ColorsCotizador.secondary900
                                                                          ), textAlign: TextAlign.center)
                                                                        ],
                                                                      )
                                                                  ),

                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 10,
                                                child: Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: ColorsCotizador.color_Bordes, style: BorderStyle.solid, width: 1.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: CupertinoButton(
                                                    onPressed: (){
                                                      Utilidades.mostrarAlertaBorrarCotizacion(
                                                        titulo: Mensajes.titleEliminarCotizacion,
                                                        mensaje: Mensajes.seEliminaraLaCotizacion,
                                                        context: context,
                                                        onPressed: () {
                                                          setState(() {
                                                            if(Utilidades.cotizacionesApp.getCotizacionesCompletas() >1){
                                                              Utilidades.cotizacionesApp.eliminarDeLaComparativa(index);
                                                              Navigator.of(context).pop();
                                                            }else{
                                                              setState(() {
                                                                tieneEdad = false;
                                                                tieneCP = false;
                                                              });
                                                              limpiarDatos();
                                                            }
                                                          });
                                                          //Navigator.of(context).pop();
                                                        },
                                                      );

                                                    },
                                                    padding: EdgeInsets.zero,
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16, right: 16),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  left: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                                  right: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                                  bottom: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                                  top: BorderSide(width: 1.0, color: ColorsCotizador.color_Bordes),
                                                  // bottom: BorderSide(width: 1.0,color: AppColors.color_Bordes),
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(5))

                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                                                  child: Text("Prima Total",
                                                    textAlign: TextAlign.start,
                                                    style: new TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: ColorsCotizador.AzulGNP,
                                                      fontFamily: "Roboto",
                                                    ),),
                                                ),
                                                ListView.builder(
                                                    itemCount: cotizacion.comparativa.detalleAsegurados.length,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemBuilder: (BuildContext ctxt, int k) {
                                                      return Container(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                color: ColorsCotizador.color_background_blanco,
                                                                child: Container(
                                                                    margin: EdgeInsets.only(left: 8),
                                                                    color: ColorsCotizador.color_background_blanco,
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:8, bottom: 8),
                                                                          child: RenglonTablaDoscolumna(titulo: k == 0 ? "Titular" : "Adicional ${k}",
                                                                              valor: cotizacion.comparativa.detalleAsegurados[k].primaTotal),
                                                                        )
                                                                      ],
                                                                    )
                                                                ),

                                                              ),
                                                            ],
                                                          )
                                                      );
                                                    }
                                                ),
                                                ListView.builder(
                                                    itemCount: cotizacion.comparativa.secciones.length,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemBuilder: (BuildContext ctxt, int j) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          cotizacion.comparativa.secciones[j].tabla.length > 0 ? Container(
                                                            margin: EdgeInsets.only(top: 20, bottom: 10, left: 20),
                                                            child: Text(cotizacion.comparativa.secciones[j].seccion,
                                                              style: new TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w600,
                                                                color: ColorsCotizador.AzulGNP,
                                                                fontFamily: "Roboto",
                                                              ),),
                                                          ): Container(),
                                                          Container(
                                                            color: ColorsCotizador.color_background_blanco,
                                                            child: Container(
                                                              color: ColorsCotizador.color_background_blanco,
                                                              child: ListView.builder(
                                                                  itemCount: cotizacion.comparativa.secciones[j].tabla.length,
                                                                  shrinkWrap: true,
                                                                  physics: ScrollPhysics(),
                                                                  itemBuilder: (BuildContext ctxt, int indexdos) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(left: 8, right:8, top:8, bottom: 8),
                                                                      child: RenglonTablaDoscolumna(titulo: cotizacion.comparativa.secciones[j].tabla[indexdos].etiquetaElemento,
                                                                          valor: cotizacion.comparativa.secciones[j].tabla[indexdos].descElemento),
                                                                    );
                                                                  }
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      )
                  ),
                ],
              )
          ),

        ],
      ),
    );
  }

  List<PopupMenuItem> _getMenuItems() {
    _paymentMethodMenuItems.clear();
    final cotizaciones = Utilidades.cotizacionesApp.listaCotizaciones;
    final ultimaCotizacion = cotizaciones.last;

    cotizaciones.forEach((cotizacion) {
      final List<PopupMenuItem> paymentMethodsMenuItems = [];
      final campos = cotizacion.paso2.secciones[0].campos;
      Campo campo = campos.firstWhere(
            (campo) => (campo.id_campo == 33 || campo.id_campo == 52),
        orElse: () => null,
      );
      if (campo != null) {
        if (campo.id_campo == 33) {
          if (cotizacion == ultimaCotizacion) {
            campo.valor = null;
          }
          campo.valores.forEach((formaPago) {
            if (formaPago.descripcion != 'Todas') {
              paymentMethodsMenuItems.add(
                _getPaymentMethodMenuItem(formaPago),
              );
            }
          });
        } else if (campo.id_campo == 52) {
          campo.valores.forEach((valor) {
            final child0 = valor.children[0];
            if (child0.visible) {
              child0.valores.forEach((formaPago) {
                final descripcion = formaPago.descripcion;
                final esTodas = descripcion == 'Todas';
                final esUnica = descripcion == 'Única';
                if (!esTodas && !esUnica) {
                  paymentMethodsMenuItems.add(
                    _getPaymentMethodMenuItem(formaPago),
                  );
                }
              });
              if (cotizacion == ultimaCotizacion) {
                if (paymentMethodsMenuItems.isNotEmpty) {
                  child0.valor = paymentMethodsMenuItems.first.value.toString();
                }
              }
            }
          });
        }

        _paymentMethodMenuItems.add(paymentMethodsMenuItems.reversed.toList());
      }
    });
  }

  Widget _getPaymentMethodMenuItem(Valor formaPago) => PopupMenuItem(
    value: int.parse(formaPago.id),
    child: Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Text(
            formaPago.descripcion,
            style: TextStyle(
              color: Utilidades.color_titulo,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 60.0,
          ),
        ],
      ),
    ),
  );

  _onSelectedPaymentMethod(int value, int index) {
    print("Value $value");

    if (_isSamePaymentForm(value, index)) return;

    final valueString = value.toString();

    final paymentMethods = _paymentMethodMenuItems[index];
    final FormularioCotizacion cotizacion = Utilidades.cotizacionesApp
        .getCotizacionElement(index);

    if (paymentMethods.length > 1) {
      List<Campo> campos = cotizacion.paso2.secciones[0].campos;
      final campo = campos.firstWhere(
            (campo) => (campo.id_campo == 33 || campo.id_campo == 52),
        orElse: () => null,
      );

      if (campo != null) {
        if (campo.id_campo == 33) {
          campo.valor = valueString;
        } else if (campo.id_campo == 52) {
          campo.valores.forEach((valor) {
            final child0 = valor.children[0];
            if (child0.visible) {
              child0.valor = valueString;
            }
          });
        }
      }
    }

    _changeSelectedPaymentForm(cotizacion, value);
  }

  bool _isSamePaymentForm(
      int value,
      int index,
      ) {
    final FormularioCotizacion cotizacion =
    Utilidades.cotizacionesApp.getCotizacionElement(index);
    final formaPagoSeleccionada = cotizacion.comparativa.formapagoseleccionada;

    return cotizacion.formasPago[formaPagoSeleccionada].idFormaPago == value;
  }

  _changeSelectedPaymentForm(
      FormularioCotizacion cotizacion,
      int value,
      ) {
    final formaPago = cotizacion.formasPago.firstWhere(
          (e) => e.idFormaPago == value,
    );
    final motorDinamicoFormaPago =
    cotizacion.motorDinamicoFormasPago.firstWhere(
          (e) => e.idFormaPago == value,
    );

    cotizacion.responseCotizacion['resumenCotizacion']['formasPago'] =
    [formaPago.toJson()];
    cotizacion.responseCotizacion['motorDinamicoResponse']['formasPago'] =
    [motorDinamicoFormaPago.toJson()];

    final jsonComp = _prepararJsonCompPorCotizacion(cotizacion);
    cotizacion.requestCotizacion = jsonEncode(jsonComp).toString();
    cotizacion.comparativa.FOLIO_FORMATO_COMISION = null;
    cotizacion.comparativa.FOLIO_FORMATO_COTIZACION = null;

    final formaPagoIndex = cotizacion.formasPago.indexOf(formaPago);
    setState(
          () => cotizacion.comparativa.formapagoseleccionada = formaPagoIndex,
    );
  }

  _generarCotizacion([int index]) async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    final Trace generaCot = FirebasePerformance.instance.newTrace(
      "CotizadorUnico_GenerarCotizacion",
    );
    generaCot.start();

    if (index == null) {
      index = Utilidades.cotizacionesApp.listaCotizaciones.length - 1;
    }
    try {
      await _requestCotizacion(index);
    } catch (e) {
      print("e-------------> ${e}");
      generaCot.stop();
      setState(() => isLoading = false);
      Utilidades.mostrarAlertaCallBackCustom(
        Mensajes.titleConexion,
        Mensajes.errorConexion,
        context,
        'Reintentar',
            () {
          Navigator.pop(context);
          _generarCotizacion();
        },
      );
    } finally {
      generaCot.stop();
      if (isLoading) {
        setState(() => isLoading = false);
      }
    }
  }

  _requestCotizacion(
      int index,
      ) async {
    final FormularioCotizacion cotizacion = Utilidades.cotizacionesApp
        .getCotizacionElement(index);
    final jsonComp = _prepararJsonCompPorCotizacion(cotizacion);

    final response = await _generarNuevaCotizacion(jsonComp);
    final body = response.body;
    final jsonResponse = json.decode(body);

    if (response.statusCode == 200) {
      final resumenCotizacion = jsonResponse['resumenCotizacion'];
      if (resumenCotizacion['banComparativa'] == 0) {
        _mostrarErrorAlAgregarNuevaCotizacion();
      }
      setState(() {
        isLoading = false;
        _setResponseCotizacionPropertiesToCotizacion(
          cotizacion: cotizacion,
          jsonResponse: jsonResponse,
          jsonComp: jsonComp,
          resumenCotizacion: resumenCotizacion,
        );
        _sendAnalyticsFromResponseCotizacion(response, index);
      });
    } else {
      setState(() => isLoading = false);
      String message = jsonResponse['message'] != null
          ? jsonResponse['message']
          : jsonResponse['errors'][0] != null
          ? jsonResponse['errors'][0]
          : 'Error del servidor';

      Utilidades.mostrarAlertas(Mensajes.titleLoSentimos, message, context);
    }
  }

  _setResponseCotizacionPropertiesToCotizacion({
    FormularioCotizacion cotizacion,
    dynamic jsonResponse,
    Map<String, dynamic> jsonComp,
    dynamic resumenCotizacion,
  }) {
    final motorDinamicoResponse = jsonResponse['motorDinamicoResponse'];
    cotizacion.comparativa = Comparativa.fromJson(jsonResponse);
    cotizacion.jsonComparativa = jsonComp;
    cotizacion.requestCotizacion = json.encode(jsonComp).toString();
    cotizacion.responseCotizacion = jsonResponse;
    final List<dynamic> formasPago = resumenCotizacion['formasPago'].toList();
    cotizacion.formasPago = formasPago
        .map(
          (e) => ResumenCotizacionFormaPago.fromJson(e),
    )
        .toList();
    final List<dynamic> motorDinamicoFormasPago =
    motorDinamicoResponse['formasPago'].toList();
    cotizacion.motorDinamicoFormasPago = motorDinamicoFormasPago
        .map(
          (e) => MotorDinamicoFormaPago.fromJson(e),
    )
        .toList();
  }

  Map<String, dynamic> _prepararJsonCompPorCotizacion(
      FormularioCotizacion cotizacion,
      ) {
    final paso1 = cotizacion.paso1;
    final trueString = 'true';
    final jsonComp = cotizacion.getJSONComparativa();
    final jsonGMMRequest = jsonComp['cotizacionGMMRequest'];

    final jsonDescuento = jsonGMMRequest['descuentos'][0];
    final banRiesgoSelecto = paso1.secciones[1].campos[7].valor == trueString;
    final banGarantiaCoaseguro =
        paso1.secciones[1].campos[8].valor == trueString;
    jsonDescuento['banRiesgoSelecto'] = banRiesgoSelecto;
    jsonDescuento['banGarantiaCoaseguroCero'] = banGarantiaCoaseguro;

    List<Seccion> familiares = paso1.secciones[3].children_secc;
    for (int i = 0; i < familiares.length; i++) {
      final banRiesgoSelecto = familiares[i].campos[9].valor == trueString;
      final banGarantia = familiares[i].campos[10].valor == trueString;
      final adicional = {
        "banRiesgoSelecto": banRiesgoSelecto,
        "banGarantiaCoaseguroCero": banGarantia,
        "idPersona": i + 2
      };
      jsonGMMRequest["descuentos"].add(adicional);
    }

    return jsonComp;
  }

  Future<Response> _generarNuevaCotizacion(
      Map<String, dynamic> jsonComp,
      ) async {
    String jsonCompString = json.encode(jsonComp);
    //log(jsonCompString);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": loginData.jwt
    };

    Response response = await post(
      Utilidades.urlCotizar,
      /*config.urlBase+Constants.GENERA_COTIZACION,*/
      body: jsonCompString,
      headers: headers,
    );

    return response;
  }

  _mostrarErrorAlAgregarNuevaCotizacion() {
    Utilidades.mostrarAlertaCallback(
        'Problema al agregar la cotización',
        Mensajes.agregarCot,
        context, () {
      Navigator.pop(context);
      Navigator.pop(context);
    }, () {
      setState(() {
        final cotizacionesCopia =
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion();

        Utilidades.cotizacionesApp.limpiarComparativa();
        Utilidades.cotizacionesApp.agregarCotizacion(cotizacionesCopia);

        Navigator.pop(context);
      });
    });
  }

  _sendAnalyticsFromResponseCotizacion(Response response, int index) {
    try {
      Utilidades.sendAnalyticsBatch(context,
          CotizadorAnalitycsTags.generarSeccionCalculo(response));
      Utilidades.sendAnalyticsBatch(context,
          CotizadorAnalitycsTags.generarSeccionDatosCotizador());
      lista_secciones = CotizadorAnalitycsTags.getListaSeccionesGTM(
          Utilidades.cotizacionesApp.getCotizacionElement(index));

      Utilidades.sendAnalyticsBatch(context, lista_secciones);
    } catch (e) {
      print('Error al generar analytics');
    }
  }

  String _obtenerNombreFormaDePagoSeleccionada(int index) {
    final FormularioCotizacion cotizacion =
    Utilidades.cotizacionesApp.getCotizacionElement(index);
    final formaPagoSeleccionada = cotizacion.comparativa.formapagoseleccionada;

    return cotizacion.formasPago[formaPagoSeleccionada].formaPago;
  }
}

