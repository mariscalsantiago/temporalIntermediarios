import 'dart:convert';
import 'dart:io';

//import 'package:agentesgnp/Functions/Analytics.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/CotizadorUnico/CotizacionPDF.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_performance/firebase_performance.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_tags/tag.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;

//import '../../cotizador_analitycs_tags.dart';


class SendEmail extends StatefulWidget {
  final int folio;
  final int idFormato;
  final int id;
  final String id_Plan;

  const SendEmail({Key key, this.folio, this.idFormato, this.id, this.id_Plan}) : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool correovalido = true;
  String email, eMail;
  TextEditingController controller = new TextEditingController();
  String comentarios;
  List eMails = [];

  bool esVacio =false;
  bool esVacioMail = false;
  Map<String, dynamic> parameters =  Map<String, dynamic>();
  String dataLayer="";

  _sendEmailService() async {

    /*final Trace mytrace = FirebasePerformance.instance.newTrace("CotizadorUnico_EnviaEmail");
    mytrace.start();
    print(mytrace.name);*/
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
            //mytrace.stop();
            this.setState(() {
              isLoading = false;
              success = true;

              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleExito, Mensajes.cotizacionEnviada, context, "Aceptar", (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(context,  MaterialPageRoute(
                  builder: (context) => CotizacionPDF(id: widget.id, folio: widget.folio, idFormato: widget.idFormato, id_Plan: widget.id_Plan,),
                ));
              });

            });
          }else{
            //mytrace.stop();
            isLoading = false;
            Navigator.pop(context);
            String message = response.response['message'] != null ? response.response['message'] : response.response['errors'][0] != null ? response.response['errors'][0] : "Error del servidor";

            Utilidades.mostrarAlertas(Mensajes.titleError, message, context);
          }
      }else {
        //mytrace.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          _sendEmailService();
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

  Future _initialWebView() async{

    /*dataLayer = json.encode(Utilidades.seccCot);

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(dataLayer);

    setState(() {
      _initialURL = AppConfig.of(context).urlBaseAnalytics + Constants.ENVIA_MAIL + encoded; // "https://gmm-cotizadores-qa.gnp.com.mx/?esMobile=true&accion=envioMovil&dataLayer="
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

    Response response = await post(gmm, body: send, headers: headers);
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
*/
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

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
      child: WillPopScope(
        onWillPop: () async{
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(context,  MaterialPageRoute(
            builder: (context) => CotizacionPDF(id: widget.id, folio: widget.folio, idFormato: widget.idFormato, id_Plan: widget.id_Plan,),
          ));


          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.chevron_left, size: 35,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              iconTheme: IconThemeData(color: AppColors.color_primario),
              backgroundColor: Colors.white,
              title: Text("Compartir",
                  style: TextStyle(color: AppColors.color_appBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500, fontFamily: "Roboto")),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 24, left: 24),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              "Enviar cotización",
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary700),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                            EdgeInsets.only(right: 16, top: 32, bottom: 24),
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacement(context,  MaterialPageRoute(
                                  builder: (context) => CotizacionPDF(id: widget.id, folio: widget.folio, idFormato: widget.idFormato, id_Plan: widget.id_Plan,),
                                ));

                              },
                              heroTag: "btn1",
                              tooltip: "Cerrar",
                              backgroundColor: AppColors.color_primario,
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                switch (index) {
                                  case 0:
                                    return Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Mail",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary700),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;

                                  case 1:
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
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
                                                      top: BorderSide(
                                                          width: 1,
                                                          color: AppColors.color_mail),
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: AppColors.color_mail),
                                                      left: BorderSide(
                                                          width: 1,
                                                          color: AppColors.color_mail),
                                                    )),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.only(top:8),
                                                  child: new TextFormField(
                                                    readOnly: eMails.length >= 20 ? true : false,
                                                    //enabled: eMails.length >= 2 ? false : true,
                                                    controller: controller,
                                                    maxLength: 129,
                                                    maxLengthEnforced: true,
                                                    //buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
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
                                                        borderRadius:
                                                        new BorderRadius.circular(
                                                            0.0),
                                                        borderSide: new BorderSide(
                                                            color: AppColors.color_mail),
                                                      ),
                                                      fillColor: AppColors.color_mail,
                                                      border: new OutlineInputBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(
                                                            0.0),
                                                        borderSide: new BorderSide(
                                                            color: AppColors.color_mail),
                                                      ),
                                                      enabledBorder:  OutlineInputBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(
                                                            0.0),
                                                        borderSide: new BorderSide(
                                                            color: AppColors.color_mail),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(
                                                            0.0),
                                                        borderSide: new BorderSide(
                                                            color: AppColors.color_mail),
                                                      ),
                                                      focusedErrorBorder:  OutlineInputBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(
                                                            0.0),
                                                        borderSide: new BorderSide(
                                                            color: AppColors.color_mail),
                                                      ),
                                                    ),

                                                    onSaved: (val){
                                                      setState(() {

                                                        email = val;
                                                      });
                                                    },

                                                    validator: (val){
                                                      String mensaje;

                                                      if(eMails.isEmpty){

                                                        if(val.length>0){

                                                          eMail = controller.text;
                                                          String valor = ValidarEmail(eMail);
                                                          if( valor == null){

                                                            controller.clear();
                                                            setState(() {
                                                              esVacioMail = false;
                                                            });
                                                            //esVacioMail = false;
                                                            //mensaje = null;
                                                          }
                                                        }
                                                        else{

                                                          setState(() {
                                                            esVacioMail = true;
                                                          });
                                                        }
                                                        /*
                                                        setState(() {
                                                          esVacio = true;
                                                          //mensaje = "Ingrese al menos un correo";
                                                        });
                                                        */
                                                      }else{
                                                        if(val.length>0){
                                                          eMail = controller.text;
                                                          String valor = ValidarEmail(eMail);
                                                          if( valor == null){
                                                            controller.clear();
                                                            //mensaje = null;
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

                                          /*Row(
                                              children: <Widget>[
                                                Visibility(
                                                    visible: esVacio,
                                                    child: Text("Al menos un destinatorio es requerido", style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.w400,
                                                        textBaseline: TextBaseline.alphabetic,
                                                        color: Color.fromRGBO(211,47,47,1) ),
                                                        textAlign: TextAlign.start))
                                              ]
                                          ),
                                          */



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
                                              ))

                                        ],
                                      ),
                                    );
                                    break;

                                  case 3:
                                    return Container(margin: EdgeInsets.only(top: 24),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Comentario",
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
                                            child: TextFormField(
                                              keyboardType: TextInputType.multiline,
                                              minLines: 4,
                                              maxLines: 50,
                                              maxLength: 999,
                                              decoration: InputDecoration(

                                                hintText: "Escribe tu mensaje...",
                                                fillColor: AppColors.color_mail,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      0.0),
                                                  borderSide: new BorderSide(
                                                      color: AppColors.color_mail),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      0.0),
                                                  borderSide: new BorderSide(
                                                      color: AppColors.color_mail),
                                                ),
                                                enabledBorder:  OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      0.0),
                                                  borderSide: new BorderSide(
                                                      color: AppColors.color_mail),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      0.0),
                                                  borderSide: new BorderSide(
                                                      color: AppColors.color_mail),
                                                ),
                                                focusedErrorBorder:  OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      0.0),
                                                  borderSide: new BorderSide(
                                                      color: AppColors.color_mail),
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
                                        ],
                                      ),
                                    );
                                    break;

                                  case 4:
                                    return Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 100),
                                        child: FlatButton(
                                          color: AppColors.color_primario,
                                          textColor: Colors.white,
                                          disabledColor: Colors.grey,
                                          disabledTextColor: Colors.black,
                                          padding: EdgeInsets.all(8.0),
                                          onPressed: () {



                                            if (formKey.currentState.validate()){
                                              formKey.currentState.save();

                                              if(eMails.length>0 && eMails.length<21){
                                               // _initialWebView();
                                                _sendEmailService();
                                                /*final FirebaseAnalytics analytics = new FirebaseAnalytics();
                                                analytics.logEvent(name: CotizadorAnalitycsTags.envioMailGMM, parameters: <String, dynamic>{});

                                                sendTag(CotizadorAnalitycsTags.envioMailGMM);
                                                setCurrentScreen(CotizadorAnalitycsTags.envioMailGMM, "SendEmail");*/
                                              }


                                            }


                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "ENVIAR",
                                              style: TextStyle(
                                                  fontSize: 15.0, letterSpacing: 1),
                                            ),
                                          ),
                                        ));
                                    break;

                                  case 2:
                                    return Tags(
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
                                          //color: AppColors.color_primario,
                                          //active: item.active,
                                          //customData: item.customData,
                                          textStyle: TextStyle( fontSize: 15.0, ),
                                          combine: ItemTagsCombine.withTextBefore,
                                          //image: ItemTagsImage(image: AssetImage("img.jpg");) OR null,
                                          //icon: ItemTagsIcon(icon: Icons.add,) OR null,
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
                                    );
                                    break;

                                  default:
                                    return Container();
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
