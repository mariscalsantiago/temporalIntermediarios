import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:http/http.dart';
//import 'package:cotizador_agente/Modelos/LoginModels.dart';

class DropDownNegocioOperableElement extends StatefulWidget {
  const DropDownNegocioOperableElement({Key key, this.negocioOperable})
      : super(key: key);

  @override
  _DropDownNegocioOperableElementState createState() =>
      _DropDownNegocioOperableElementState();

  final NegocioOperable negocioOperable;
}

class _DropDownNegocioOperableElementState
    extends State<DropDownNegocioOperableElement> {
  //Inicializacion de pestaña
  bool estaAbierto = false;
  IconData icon = Icons.expand_more;
  //FlutterWebviewPlugin _flutterWebViewPlugin = new FlutterWebviewPlugin();
  String _initialURL="";
  List<Object> parameters =  List<Object>();
  String dataLayer="";
  String platform = "";
  bool isFinish = false;

  //llamar para cerrar pestaña
  cerrar() {
    setState(() {
      estaAbierto = false;
      icon = Icons.expand_more;
    });
  }

  //llamar para abrir pestaña;
  abrir() {
    setState(() {
      estaAbierto = true;
      icon = Icons.expand_less;
    });
  }

  listener() {
    if (estaAbierto) {
      cerrar();
    } else {
      abrir();
    }
  }

  void seccionCotizador(){
    if (Platform.isIOS) {
      platform = "iOS";
    }else if (Platform.isAndroid){
      platform = "Android";
    }

    List<Map<String, dynamic>> lista_seccionesCot =  List<Map<String, dynamic>> ();

    //SECCIÓN: datos Cotizador Anaytics
    Map<String, dynamic> parameters_Cotizador = Map<String, dynamic>();
    parameters_Cotizador["seccion"] = "datosCotizador";
    parameters_Cotizador["datosIdParticipante"] = "datosUsuario.idparticipante.toString()";
    parameters_Cotizador["datosNombreParticipante"] = "datosUsuario.givenname";
    parameters_Cotizador["datosIdAplicacion"] = "AppAgentes/" + platform + "/" + Utilidades.idAplicacion.toString();
    parameters_Cotizador["datosTipoDeNegocio"] = Utilidades.tipoDeNegocio;
    parameters_Cotizador["datosPortal"] = "AppAgentes/" + platform + "/" + Utilidades.idAplicacion.toString();
    lista_seccionesCot.add(parameters_Cotizador);

    setState(() {
      Utilidades.lista_seccionesC.add(parameters_Cotizador);
      Map<String,dynamic> secCot = {"data": [
        {"seccion": ""},{"seccion": ""},{"seccion": ""}, {"seccion": ""},{"seccion": ""},{"seccion": ""},
        {"seccion": ""},{"seccion": ""},{"seccion": ""}, parameters_Cotizador,{"seccion": ""}]
      };
      Utilidades.seccCot = secCot;
      Utilidades.LogPrint("SECCIONCOT: " + Utilidades.seccCot.toString());
      setState(() {
        isFinish = true;
        _initialWebView();
      });

    });


  }

  Future _initialWebView() async{
    if(isFinish == true){
      dataLayer = json.encode(Utilidades.seccCot);
      Utilidades.LogPrint("DATA: " + dataLayer);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(dataLayer);

      setState(() {
        _initialURL = "config.urlAccionIngreso + encoded";
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

        if(json.decode(response.body)["short_url"] != null){
          String url = json.decode(response.body)["short_url"];
          //_flutterWebViewPlugin.reloadUrl(url);
          Utilidades.LogPrint("URL: " + url);
          url = "";
          _initialURL = "";
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {


    return Visibility(
      visible: widget.negocioOperable.cotizadores.length>0 && widget.negocioOperable.cotizadores!=null,
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            margin: EdgeInsets.only(right: 8, left: 8, top: 8),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: Offset(0, 3))
              ],
            ),
            child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  listener();
                },
                child: Container(
                  // width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Text(
                          widget.negocioOperable.negocioOperable,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          padding: EdgeInsets.all(20.0),
                          icon: Icon(
                            icon,
                            color: Utilidades.color_primario,
                          ),
                          onPressed: () {
                            listener();
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 8, left: 8, top: 2, bottom: 8),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: Offset(0, 3))
              ],
            ),

            child: ListView.builder(

                itemCount: widget.negocioOperable.cotizadores.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int j) {
                  /*if((!widget.negocioOperable.cotizadores[j].estatus ) && (!widget.negocioOperable.cotizadores[j].visible_movil)){
                    return Container();
                  }*/


                  return Visibility(
                    visible: estaAbierto && widget.negocioOperable.cotizadores[j].estatus && widget.negocioOperable.cotizadores[j].visible_movil,
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,

                        child: FlatButton(
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              widget.negocioOperable.cotizadores[j].aplicacion,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          onPressed: () {
                            CotizacionesApp nuevo = new CotizacionesApp();

                            Utilidades.cotizacionesApp = nuevo;

                            if(widget.negocioOperable.cotizadores[j].mensaje != null) {
                              Utilidades.mostrarAlertaCallback(
                                  Mensajes.titleContinuar, widget.negocioOperable.cotizadores[j].mensaje, context, () {
                                Navigator.pop(context);
                              }, () {
                                Navigator.pop(context);
                                Utilidades.idAplicacion = int.parse(widget.negocioOperable.cotizadores[j].id_aplicacion.toString());
                                Utilidades.tipoDeNegocio = widget.negocioOperable.cotizadores[j].aplicacion;
                                seccionCotizador();
                                Navigator.pushNamed(context, "/cotizadorUnicoGMMPasoUno",);
                                Utilidades.deboCargarPaso1 = false;
                              });
                            }

                            else{
                              Utilidades.idAplicacion = int.parse(widget.negocioOperable.cotizadores[j].id_aplicacion.toString());
                              Utilidades.tipoDeNegocio = widget.negocioOperable.cotizadores[j].aplicacion;
                              seccionCotizador();
                               Navigator.pushNamed(context, "/cotizadorUnicoGMMPasoUno",);
                              Utilidades.deboCargarPaso1 = false;
                            }

                          },
                        )),
                  );
                }),
          ),
          /*Container(
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
          ),*/
        ],
      ),
    );
  }
}
