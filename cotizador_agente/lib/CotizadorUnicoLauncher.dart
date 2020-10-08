import 'dart:convert';
import 'dart:io';

import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:http/http.dart';

import 'modelos_widget/DropDownNegocioOperableElement.dart';

class SeleccionaCotizadorUnicoGMM extends StatefulWidget {
  List<NegocioOperable> negociosOperables = new List<NegocioOperable>();
  SeleccionaCotizadorUnicoGMM({Key key, this.negociosOperables}) : super(key: key);


  @override
  _SeleccionaCotizadorUnicoGMMState createState() => new _SeleccionaCotizadorUnicoGMMState();
}

class _SeleccionaCotizadorUnicoGMMState extends State<SeleccionaCotizadorUnicoGMM>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {


  bool isLoading = true;


  @override
  void initState() {

    negociosOper();
    super.initState();
  }

  void negociosOper() async{

    try{

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          /*final FirebaseAnalytics analytics = new FirebaseAnalytics();
          analytics.logEvent(name: CotizadorAnalitycsTags.cotizadorGMM, parameters: <String, dynamic>{});

          sendTag(CotizadorAnalitycsTags.cotizadorGMM);
          setCurrentScreen(CotizadorAnalitycsTags.cotizadorGMM, "SeleccionaCotizadorUnicoGMM");*/

          if(Utilidades.negociosOperables.length == 0){
            widget.negociosOperables = Utilidades.negociosOperables;
            isLoading = false;
          }else{
            if(widget.negociosOperables == null){
              _getNegociosOperables();
            }else{
              isLoading = false;
            }
          }
        }catch(e){
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            negociosOper();
          });
        }
      }else{
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          negociosOper();
        });
      }

    }catch(e){
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        negociosOper();
      });
    }

  }


    _getNegociosOperables( ) async {
      // set up POST request arguments

      //final Trace negociosOp = FirebasePerformance.instance.newTrace("CotizadorUnico_NegociosOperables");
      /*negociosOp.start();
      print(negociosOp.name);*/
      bool success = false;

      try{
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          try{

            Map<String, dynamic> jsonMap = {
              "consultaNegocio": {
                "idParticipante": "datosUsuario.idparticipante.toString()"
              }
            };

            // make POST request
            Response response = await post("config.urlNegociosOperables", body: jsonMap.toString());
            // check the status code for the result
            int statusCode = response.statusCode;

            if(response != null) {
              if (response.body != null && response.body.isNotEmpty) {

                // this API passes back the id of the new item added to the body
                String body = response.body;
                print(body);
                print(statusCode);

                if(statusCode == 200){
                  //negociosOp.stop();
                  success = true;
                  var list = json.decode(response.body)['consultaPorParticipanteResponse']
                  ["consultaNegocios"]["participante"]["listaNegocioOperable"] as List;
                  setState(() {
                    widget.negociosOperables = list.map((i) => NegocioOperable.fromJson(i)).toList();

                  });

                  widget.negociosOperables.forEach((negocio) {
                    _getCotizadores(negocio);
                  });
                  setState(() {
                    isLoading = false;
                  });

                }else if(statusCode == 400){
                  //negociosOp.stop();
                  isLoading = false;
                  Navigator.pop(context);
                  Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);
                }else if(statusCode != null){
                  //negociosOp.stop();
                  Navigator.pop(context);
                  isLoading = false;
                  String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                  Utilidades.mostrarAlertas("Error: " + statusCode.toString(), message, context);
                }
              } else {
                //negociosOp.stop();
                Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                  Navigator.pop(context);
                  _getNegociosOperables();
                });
              }
            }else{
              //negociosOp.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                _getNegociosOperables();
              });
            }

          } catch(e){
            //negociosOp.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              _getNegociosOperables();
            });
          }

        }else {
          //negociosOp.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            _getNegociosOperables();
          });
        }
      }catch(e){
        //negociosOp.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          _getNegociosOperables();
        });
      }


      return success;

  }

  _getCotizadores(NegocioOperable negocioOperable) async {
    // set up POST request arguments
    /*final Trace cotizadores = FirebasePerformance.instance.newTrace("CotizadorUnico_GetCotizadores");
    cotizadores.start();
    print(cotizadores.name);*/
    bool success = false;


        try{

          final result = await InternetAddress.lookup('google.com');

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

            Map<String, String> headers = {
              "Content-type": "application/json",
              "Authorization" : "loginData.jwt"
            };

            Map<String, dynamic> jsonMap = {
              "clave_negocio_operable": negocioOperable.idNegocioOperable,
              "correo": "datosUsuario.mail"

            };
            // make POST request
            Response response = await post("config.urlCotizadores", headers: headers, body: json.encode(jsonMap));
            // check the status code for the result
            int statusCode = response.statusCode;
            // this API passes back the id of the new item added to the body

            if(response != null) {
              if (response.body != null && response.body.isNotEmpty) {

                String body = response.body;
                Utilidades.LogPrint("COTIZADORES: " + json.decode(body).toString());
                print(statusCode);

                if(statusCode == 200){
                  //cotizadores.stop();
                  var list = json.decode(response.body)['cotizadores'] as List;

                  setState(() {
                    success = true;
                    negocioOperable.cotizadores = list.map((i) => Cotizadores.fromJson(i)).toList();
                    isLoading = false;
                  });

                }else if(statusCode == 400){
                  //cotizadores.stop();
                  isLoading = false;
                  Navigator.pop(context);

                  Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);

                } else if(statusCode != null){
                  //cotizadores.stop();
                  Navigator.pop(context);
                  isLoading = false;
                  String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                  Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), message, context);
                }

              } else {
                //cotizadores.stop();
                Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                  Navigator.pop(context);
                  _getCotizadores(negocioOperable);
                });
              }
            }else{
              //cotizadores.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                _getCotizadores(negocioOperable);
              });
            }

          }else {
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              _getCotizadores(negocioOperable);
            });
          }

        }catch(e){
          //cotizadores.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            _getCotizadores(negocioOperable);
          });
        }


    return success;

  }





  @override
  Widget build(BuildContext context) {

    if(Utilidades.negociosOperables.length == 0){
      widget.negociosOperables = Utilidades.negociosOperables;
      isLoading = false;
    }else{
      if(widget.negociosOperables == null){
        _getNegociosOperables();
      }else{
        isLoading = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Utilidades.color_primario),
        backgroundColor: Colors.white,
        title: Text("Seleccione un cotizador", style: TextStyle(color: Colors.black),),
      ),
      body:  isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Utilidades.color_primario),),): Column(
        children:  <Widget>[
          Visibility(
            visible: true, //widget.negociosOperables[0].cotizadores != null,
            child: Expanded(
                child: Container(
                  child: new ListView.builder(
                      itemCount: widget.negociosOperables.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return DropDownNegocioOperableElement(negocioOperable: widget.negociosOperables[index]);
                      }),
                )),
          )
        ],
      ),
    );
  }

}

