
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

//import 'package:agentesgnp/Functions/Analytics.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/vistas/SendEmail.dart';
import 'package:dio/dio.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

//import '../../cotizador_analitycs_tags.dart';




class CotizacionPDF extends StatefulWidget {

  final int id;
  final int folio;
  final int idFormato;
  final String id_Plan;

  const CotizacionPDF({Key key, this.id, this.folio, this.idFormato, this.id_Plan}) : super(key: key);

  @override
  _CotizacionPDFState createState() => _CotizacionPDFState();
}

class _CotizacionPDFState extends State<CotizacionPDF> {

  bool isLoading = true;
  String responseBase;
  int contador = 0;
  String pathPdf;
  PDFDocument doc;
  Dio dio;
  Future<Directory> downloadsDirectory;
  FlutterWebviewPlugin _flutterWebViewPlugin = new FlutterWebviewPlugin();
  String _initialURL="";
  bool isDownload = false;
  List<Object> parameters =  List<Object>();
  String dataLayer="";

  @override
  void initState() {

    getFormato(context);
  }


  getFormato(BuildContext context) async{

    /*final Trace formato = FirebasePerformance.instance.newTrace("CotizadorUnico_GetPDF");
    formato.start();
    print(formato.name);*/
    bool success = false;

        try{

          final result = await InternetAddress.lookup('google.com');

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

            Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

            //TO DO: Revisar esta cambio para ver si es correcto.
            Map<String, dynamic> jsonMap = {
              "idAplicacion": Utilidades.idAplicacion,
              "folioCotizacion": widget.folio,
              "idFormato": widget.idFormato,
              "idPlan": widget.id_Plan
            };

            http.Response response= await post("http://gmm-cotizadores-qa.gnp.com.mx/cotizacion/formato", body: json.encode(jsonMap), headers: headers);

            int statusCode = response.statusCode;

            if(response != null) {
              if (response.body != null && response.body.isNotEmpty) {

                if (statusCode == 200) {
                  //formato.stop();
                  success = true;
                  responseBase = response.body;
                  _createFileFromString();

                }else if(statusCode != null){
                  //formato.stop();
                  isLoading = false;
                  String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";

                  Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), message, context);

                }else{
                  //formato.stop();
                  Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                    Navigator.pop(context);
                    getFormato(context);
                  });
                }

              }else{
                //formato.stop();
                Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                  Navigator.pop(context);
                  getFormato(context);
                });
              }
            }else{
              //formato.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                getFormato(context);
              });
            }

          }else {
            //formato.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              getFormato(context);
            });
          }

        }catch(e){
          //formato.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            getFormato(context);
          });
        }



    return success;

  }

  Future<String> _createFileFromString() async {

      String nombreFormato = widget.idFormato == Utilidades.FORMATO_COTIZACION ? "Cotización-" :
      (widget.idFormato == Utilidades.FORMATO_COMISION ? "Comisión-" : (widget.idFormato == Utilidades.FORMATO_COMPARATIVA ? "Comparativa-" : ""  ));

      final encodedStr = responseBase;
      Uint8List bytes = base64.decode(encodedStr);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" + nombreFormato + DateTime.now().toString().substring(0,10) + ".pdf");
      file.writeAsBytesSync(bytes);

      doc = await PDFDocument.fromFile(file);
      setState(() {
        pathPdf = file.path;
        isLoading = false;
      });

      return pathPdf;
  }

  Future<String> _saveFile() async {

    OpenFile.open(pathPdf);

  }

  Future _initialWebView() async{
    if(isDownload == true){

      dataLayer = json.encode(Utilidades.seccCot);
      Utilidades.LogPrint("DATA: " + dataLayer);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(dataLayer);

      setState(() {
        _initialURL = "config.urlAccionDescarga "+ encoded; // "https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=descargarMovil&dataLayer="
        Utilidades.LogPrint("URLACCION: " + _initialURL);
      });

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
      };
      Map<String, dynamic> send = {
        "redirect_url": _initialURL,
      };

      String key = Utilidades.keyGTM;
      String gmm = stringToBase64.decode(key);

      http.Response response = await post(gmm, body: send, headers: headers);
      if(response.body != null && response.statusCode == 200){

        //  Utilidades.LogPrint(json.encode(response.body));
        if(json.decode(response.body)["short_url"] != null){
          String url = json.decode(response.body)["short_url"];
          _flutterWebViewPlugin.reloadUrl(url);
          Utilidades.LogPrint("URL: " + url);
          url = "";
          _initialURL = "";
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: Container(
          color: Colors.white,
          child: Column(

            children: <Widget>[
              AppBar(
                iconTheme: IconThemeData(color: AppColors.color_primario),
                backgroundColor: Colors.white,
                title: Text("", style: TextStyle(fontSize: 24, color: AppColors.color_titulo)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Divider(
                          //002e71
                          thickness: 2,
                          color: AppColors.color_titulo,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child:
                      Visibility(
                        visible: widget.id != null,
                        child: Text( widget.idFormato == Utilidades.FORMATO_COTIZACION ?
                        "Formato Cotización: " + widget.folio.toString() : (widget.idFormato == Utilidades.FORMATO_COMISION ? "Formato Comisión: " + widget.folio.toString() : ( widget.idFormato == Utilidades.FORMATO_COMPARATIVA ? "Formato Comparativa: " + widget.folio.toString() : ""  )),
                          style:
                          TextStyle(fontSize: 20.0, color: AppColors.color_titulo),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: FloatingActionButton(
                        onPressed: () {
                         // Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        heroTag: "btn1",
                        tooltip: "Cerrar",
                        backgroundColor: AppColors.color_primario,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          textColor: AppColors.color_primario,
                          child: Text("DESCARGAR"),
                          onPressed: () {
                            setState(() {
                              if(isLoading){
                                null;
                              } else{
                                setState(() {
                                  isDownload = true;
                                  _initialWebView();
                                  /*final FirebaseAnalytics analytics = new FirebaseAnalytics();
                                  analytics.logEvent(name: CotizadorAnalitycsTags.descargaGMM, parameters: <String, dynamic>{});

                                  sendTag(CotizadorAnalitycsTags.descargaGMM);
                                  setCurrentScreen(CotizadorAnalitycsTags.descargaGMM, "CotizacionPDF");*/

                                });
                                contador++;
                                _saveFile();
                              }
                            });

                          },

                          borderSide: BorderSide(
                            color: AppColors.color_primario, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          textColor: AppColors.color_primario,
                          child: Text("ENVIAR"),
                          onPressed: () {

                            if(!isLoading){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendEmail(folio: widget.folio, idFormato: widget.idFormato, id: widget.id, id_Plan: widget.id_Plan,),
                                  ));
                            }

                          },
                          borderSide: BorderSide(
                            color: AppColors.color_primario, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      clearCache: true
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
        ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(AppColors.color_primario),),)
        : PDFView(filePath: pathPdf, autoSpacing: true)
      ),

      );
  }


}
