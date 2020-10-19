import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/vistas/FormularioPaso1.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:http/http.dart';

class NegocioOperableElement extends StatefulWidget {
  const NegocioOperableElement({Key key, this.negocioOperable})
      : super(key: key);

  @override
  _NegocioOperableElementState createState() =>
      _NegocioOperableElementState();

  final NegocioOperable negocioOperable;
}

class _NegocioOperableElementState
    extends State<NegocioOperableElement> {
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
        Utilidades.LogPrint(" URLACCION: " + _initialURL);
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
      visible: true,//widget.negocioOperable.cotizadores.length>0 && widget.negocioOperable.cotizadores!=null,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: FlatButton(
          color: Colors.white,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Text(
              "Cotizador",//widget.negocioOperable.cotizadores[j].aplicacion,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          onPressed: () {
            CotizacionesApp nuevo = new CotizacionesApp();

            Utilidades.cotizacionesApp = nuevo;

            Utilidades.idAplicacion = 2343;//int.parse(widget.negocioOperable.cotizadores[j].id_aplicacion.toString());
            Utilidades.tipoDeNegocio = "Planes Individuales";//widget.negocioOperable.cotizadores[j].aplicacion;
            seccionCotizador();
            //Navigator.pushNamed(FormularioPaso1; FormularioPaso1;,);
            Utilidades.deboCargarPaso1 = false;
            //Navigator.pop(FormularioPaso1);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => FormularioPaso1(),
            ));
            },
        ),
      ),
    );

    /*return Visibility(
      visible: true,//widget.negocioOperable.cotizadores.length>0 && widget.negocioOperable.cotizadores!=null,
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
            //child: FlatButton(onPressed:(){ FormularioPaso1;}, child: null),
            child: Visibility(
              visible: estaAbierto,
              child: Container(
                  color: Colors.white,
                  width: double.infinity,

                  child: FlatButton(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Cotizador",//widget.negocioOperable.cotizadores[j].aplicacion,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    onPressed: () {
                      CotizacionesApp nuevo = new CotizacionesApp();

                      Utilidades.cotizacionesApp = nuevo;


                      Utilidades.idAplicacion = 2343;//int.parse(widget.negocioOperable.cotizadores[j].id_aplicacion.toString());
                      Utilidades.tipoDeNegocio = "Planes Individuales";//widget.negocioOperable.cotizadores[j].aplicacion;
                      seccionCotizador();
                      //Navigator.pushNamed(FormularioPaso1; FormularioPaso1;,);
                      Utilidades.deboCargarPaso1 = false;
                      //Navigator.pop(FormularioPaso1);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioPaso1(),
                          ));

                    },
                  )),
            ),
          ),
        ],
      ),
    );*/
  }
}
