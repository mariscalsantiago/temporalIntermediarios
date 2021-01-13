import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:cotizador_agente/CotizadorUnico/Analytics/Analytics.dart';
import 'package:cotizador_agente/CotizadorUnico/Analytics/CotizadorAnalyticsTags.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_tags/tag.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;




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
  bool isDownload = false;
  List<Object> parameters =  List<Object>();
  String dataLayer="";
  bool correovalido = true;
  String email, eMail;
  TextEditingController controller = new TextEditingController();
  String comentarios;
  List eMails = [];
  final formKey = GlobalKey<FormState>();
  bool esVacio =false;
  bool esVacioMail = false;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  void initState() {

    getFormato(context);
  }

  getFormato(BuildContext context) async{

    final Trace formato = FirebasePerformance.instance.newTrace("SoySocio_GetPDF");
    formato.start();
    print(formato.name);
    bool success = false;

        try{

          final result = await InternetAddress.lookup('google.com');

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

            Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : loginData.jwt};

            //TODO: Revisar esta cambio para ver si es correcto.
            Map<String, dynamic> jsonMap = {
              "idAplicacion": Utilidades.idAplicacion,
              "folioCotizacion": widget.folio,
              "idFormato": widget.idFormato,
              "idPlan": widget.id_Plan
            };

            http.Response response= await post(AppConfig.of(context).urlBase + Constants.GENERA_FORMATOPDF, body: json.encode(jsonMap), headers: headers);

            int statusCode = response.statusCode;

            if(response != null) {

                if (statusCode == 200) {
                  formato.stop();
                  success = true;
                  responseBase = response.body;
                  _createFileFromString();

                }else if(statusCode != null){
                  formato.stop();
                  isLoading = false;
                  String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";

                  Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), message, context);

                }

            }else{
              formato.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleError, response.body, context,"Reintentar",(){
                Navigator.pop(context);
                getFormato(context);
              });
            }

          }else {
            formato.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              getFormato(context);
            });
          }

        }catch(e,s){
          formato.stop();
          await FirebaseCrashlytics.instance.recordError(e, s, reason: "an error occured: $e");
        }

    return success;

  }

  Future<String> _createFileFromString() async {

      String nombreFormato = (widget.idFormato == Utilidades.FORMATO_COTIZACION_AP) || (widget.idFormato == Utilidades.FORMATO_COTIZACION) ? "Cotización-" :
      ((widget.idFormato == Utilidades.FORMATO_COMISION_AP) || (widget.idFormato == Utilidades.FORMATO_COMISION) ? "Comisión-" : (widget.idFormato == Utilidades.FORMATO_COMPARATIVA ? "Comparativa-" : ""  ));

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


  sendEmailService() async {

    final Trace mytrace = FirebasePerformance.instance.newTrace("SoySocio_EnviaEmail");
    mytrace.start();
    print(mytrace.name);
    bool success = false;

    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization" : loginData.jwt
      };

      Map<String, dynamic> jsonMap = {
        "mail": eMails,
        "comentario": comentarios,
        "idCotizacionGuardada": widget.folio,
        "idFormato": [widget.idFormato]
      };

      var request = MyRequest(
          baseUrl: AppConfig.of(context).urlBase,
          path: Constants.ENVIA_EMAIL,
          method: Method.POST,
          body: jsonEncode(jsonMap).toString(),
          headers: headers
      );

      MyResponse response = await RequestHandler.httpRequest(request);
      if(response.success){
        mytrace.stop();
        this.setState(() {
          isLoading = false;
          success = true;
          Navigator.pop(context);
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleExito, Mensajes.cotizacionEnviada, context, "Aceptar", (){
            Navigator.pop(context);
            Navigator.pushReplacement(context,  MaterialPageRoute(
              builder: (context) => CotizacionPDF(id: widget.id, folio: widget.folio, idFormato: widget.idFormato, id_Plan: widget.id_Plan,),
            ));
          });

        });
      }else{
        mytrace.stop();
        isLoading = false;
        Navigator.pop(context);
        Navigator.pop(context);
        String message = response.response != null ? response.response : response.response['message'] != null ? response.response['message'] : response.response['errors'][0] != null ? response.response['errors'][0] : "Error del servidor";

        Utilidades.mostrarAlertas(Mensajes.titleError, message, context);
      }
    }else {
      mytrace.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        sendEmailService();
      });
    }


    return success;

  }

  ValidarEmail(String val){
    String alerta;
    if (val.length == 0) {
      setState(() {
        correovalido = false;
      });
      //return "Este campo es obligatorio";
      alerta = Mensajes.campoOblig;
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\áéíóúÁÉÍÓÚ"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);


    if (!regex.hasMatch(val)){
      correovalido = false;
      //return 'Ingrese un correo válido';
      alerta = Mensajes.ingresaCorreo;
    }else{

      setState(() {
        eMails.add(eMail);

      });
      correovalido = true;
      esVacioMail = false;

    }

    if (!correovalido){

      Utilidades.mostrarAlerta("Correo", alerta, context);

      return "error";
    }
    else{
      return null;
    }


  }

  Widget mostrarAlerta(){
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: AppColors.color_titleAlert.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => AnimatedPadding(
        duration: Duration(milliseconds: 0),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 440,
          padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
          decoration : new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
              )
          ),
          child:  Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, left: 24.0, right: 24.0),
                        child:Center(
                            child: Text("Enviar cotización",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.color_titleAlert,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.15))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                        child:Row(
                          children: <Widget>[
                            Text("Correo electrónico",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary700),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16.5),
                                  child: Icon(
                                    Icons.mail_outline,
                                    color: AppColors.color_mail,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(width: 1, color: AppColors.color_mail),
                                        bottom: BorderSide(width: 1, color: AppColors.color_mail),
                                        left: BorderSide(width: 1, color: AppColors.color_mail),
                                      )),
                                ),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top:8),
                                    child: new TextFormField(
                                      readOnly: eMails.length >= 20 ? true : false,
                                      controller: controller,
                                      maxLength: 129,
                                      maxLengthEnforced: true,
                                      onFieldSubmitted: (term){
                                        eMail = controller.text;
                                        String val = ValidarEmail(eMail);
                                        if( val == null){
                                          controller.clear();
                                        }
                                      },
                                      onChanged: (val){
                                        if(val.contains(";")){
                                          eMail = controller.text.substring(0, controller.text.length-1);
                                          String val = ValidarEmail(eMail);
                                          if( val == null){
                                            controller.clear();
                                          }
                                        }
                                      },
                                      decoration: new InputDecoration(
                                        counter: SizedBox(
                                          width: 0,
                                          height: 0,
                                        ),
                                        suffixIcon:  Visibility(
                                          visible: eMails.length < 20,
                                          child: IconButton(
                                              icon: Icon(Icons.add_circle, color: AppColors.color_primario,),
                                              onPressed: () {
                                                eMail = controller.text;
                                                String val = ValidarEmail(eMail);
                                                if( val == null){
                                                  controller.clear();
                                                }
                                              }),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(color: AppColors.color_mail),
                                        ),
                                        fillColor: AppColors.color_mail,
                                        border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(color: AppColors.color_mail),
                                        ),
                                        enabledBorder:  OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(color: AppColors.color_mail),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(color: AppColors.color_mail),
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(color: AppColors.color_mail),
                                        ),
                                      ),

                                      onSaved: (val){
                                        setState(() {
                                          email = val;
                                        });
                                      },

                                      validator: (val){


                                        if(eMails.isEmpty){

                                          if(val.length>0){

                                            eMail = controller.text;
                                            String valor = ValidarEmail(eMail);
                                            if( valor == null){

                                              controller.clear();
                                              setState(() {
                                                esVacioMail = false;
                                              });
                                            }
                                          }
                                          else{

                                            setState(() {
                                              esVacioMail = true;
                                            });
                                          }
                                        }else{
                                          if(val.length>0){
                                            eMail = controller.text;
                                            String valor = ValidarEmail(eMail);
                                            if( valor == null){
                                              controller.clear();
                                            }
                                          }
                                        }
                                        return null;
                                      },
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                                visible: esVacioMail,
                                child: Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text("Al menos un destinatario es requerido", style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      textBaseline: TextBaseline.alphabetic,
                                      color: Color.fromRGBO(211,47,47,1) ),
                                      textAlign: TextAlign.right),
                                )),
                            Tags(
                              key:_tagStateKey,
                              textField: null,
                              itemCount: eMails.length, // required
                              itemBuilder: (int index){
                                final item = eMails[index];

                                return ItemTags(
                                  // Each ItemTags must contain a Key. Keys allow Flutter to
                                  // uniquely identify widgets.
                                  key: Key(index.toString()),
                                  index: index, // required
                                  title: item,
                                  elevation: 0,
                                  pressEnabled: false,
                                  activeColor: Colors.transparent,
                                  textActiveColor: Colors.black,
                                  border: Border.all(color: AppColors.color_primario, width: 1.0),
                                  textStyle: TextStyle( fontSize: 15.0, ),
                                  combine: ItemTagsCombine.withTextBefore,
                                  removeButton: ItemTagsRemoveButton( ),
                                  onRemoved: (){
                                    // Remove the item from the data source.
                                    setState(() {
                                      // required
                                      eMails.removeAt(index);
                                    });
                                    if(eMails.isEmpty){
                                      setState(() {
                                        // required
                                        esVacioMail = true;
                                      });
                                    }
                                  },
                                  onPressed: (item) => false,//print(item),
                                  onLongPressed: (item) => null,//print(item),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Row(
                          children: <Widget>[
                            Text("Comentario",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color:
                                  AppColors.primary700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 8.0,left: 16.0, right: 16.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 50,
                          maxLength: 999,
                          decoration: InputDecoration(
                            hintText: "Escribe tu mensaje...",
                            counterText: "",
                            fillColor: AppColors.color_mail,
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: AppColors.color_mail),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: AppColors.color_mail),
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: AppColors.color_mail),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: AppColors.color_mail),
                            ),
                            focusedErrorBorder:  OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: AppColors.color_mail),
                            ),
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Ingrese algún comentario";
                            } else {
                              esVacio = false;
                              return null;
                            }
                          },
                          onSaved: (val){
                            setState(() {
                              comentarios = val;
                            });
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 360.0,
                        height: 40.0,
                        buttonColor: AppColors.secondary900,
                        child: Padding(
                          padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                          child: RaisedButton(
                            onPressed: (){
                              if (formKey.currentState.validate()){
                                formKey.currentState.save();

                                if(eMails.length>0 && eMails.length<21){
                                  Utilidades.sendAnalytics(context, "Acciones", "Enviar" + " / " + Utilidades.tipoDeNegocio);
                                  sendEmailService();
                                  AnalyticsServices().sendTag(CotizadorAnalitycsTags.envioMailGMM);
                                  AnalyticsServices().setCurrentScreen(CotizadorAnalitycsTags.envioMailGMM, "SendEmail");
                                }
                              }
                            },
                            child: Text("ENVIAR",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
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
      child: Scaffold(
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: Container(
            color: Colors.white,
            child: Column(

              children: <Widget>[
                AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.chevron_left, size: 35,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  iconTheme: IconThemeData(color: AppColors.color_primario),
                  backgroundColor: Colors.white,
                  title: Text("", style: TextStyle(fontSize: 24, color: AppColors.primary700)),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Divider(
                            //002e71
                            thickness: 2,
                            color: AppColors.primary700,
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
                          child: Text( (widget.idFormato == Utilidades.FORMATO_COTIZACION_AP) || (widget.idFormato == Utilidades.FORMATO_COTIZACION) ?
                          "Formato Cotización: " + widget.folio.toString() :
                          ((widget.idFormato == Utilidades.FORMATO_COMISION_AP) || (widget.idFormato == Utilidades.FORMATO_COMISION) ?
                          "Formato Comisión: " + widget.folio.toString() :
                          ( widget.idFormato == Utilidades.FORMATO_COMPARATIVA ? "Formato Comparativa: " + widget.folio.toString() : ""  )),
                            style:
                            TextStyle(fontSize: 20.0, color: AppColors.primary700),
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
                                    Utilidades.sendAnalytics(context, "Acciones", "Descargar" + " / " + Utilidades.tipoDeNegocio);
                                    AnalyticsServices().sendTag(CotizadorAnalitycsTags.descargaGMM);
                                    AnalyticsServices().setCurrentScreen(CotizadorAnalitycsTags.descargaGMM, "CotizacionPDF");
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
                              mostrarAlerta();
                             // if(!isLoading){

                             // }
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
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child:
          isLoading ? Container() :
          PDFView(filePath: pathPdf, autoSpacing: true)
        ),

        ),
    );
  }

}
