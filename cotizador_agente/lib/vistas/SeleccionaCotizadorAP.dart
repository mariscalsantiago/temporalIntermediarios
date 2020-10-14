import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos_widget/NegocioOperableElement.dart';
import 'package:cotizador_agente/utils/Colores.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:http/http.dart';



class SeleccionaCotizadorAP extends StatefulWidget {
  List<NegocioOperable> negociosOperables = new List<NegocioOperable>();
  NegocioOperable negocioOperableNew = NegocioOperable(
    ramo: "Fuerza Productora Regular GMM",
    negocioOperable: "NOP0002000",
    idNegocioOperable: "G",
    idNegocioComercial: "NC00000FPR",
    idUnidadNegocio: "SDP",
  );
  SeleccionaCotizadorAP({Key key, this.negocioOperableNew}) : super(key: key);


  @override
  _SeleccionaCotizadorAPState createState() => new _SeleccionaCotizadorAPState();
}

class _SeleccionaCotizadorAPState extends State<SeleccionaCotizadorAP>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {


  bool isLoading = true;

  @override
  void initState() {
    //negociosOper();
    super.initState();
  }

  _getNegociosOperables( ) async {

    //final Trace negociosOp = FirebasePerformance.instance.newTrace("CotizadorUnico_NegociosOperables");
    /*negociosOp.start();
      print(negociosOp.name);*/
    bool success = false;
    var config = AppConfig.of(context);

    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try{

        Map<String, dynamic> jsonMap = {
          "consultaNegocio": {
            "idParticipante": "datosUsuario.idparticipante.toString()"
          }
        };

        // make POST request
        Response response = await post(config.urlNegociosOperables, body: jsonMap.toString());
        // check the status code for the result
        int statusCode = response.statusCode;

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

          }else{
            //negociosOp.stop();
            isLoading = false;
            Navigator.pop(context);
            Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);
          }
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

    return success;

  }


  _getCotizadores(NegocioOperable negocioOperable) async {
    // set up POST request arguments
    /*final Trace cotizadores = FirebasePerformance.instance.newTrace("CotizadorUnico_GetCotizadores");
    cotizadores.start();
    print(cotizadores.name);*/
    bool success = false;
    var config = AppConfig.of(context);

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
        Response response = await post(config.urlCotizadores, headers: headers, body: json.encode(jsonMap));
        // check the status code for the result
        int statusCode = response.statusCode;
        // this API passes back the id of the new item added to the body

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

          }else {
            //cotizadores.stop();
            isLoading = false;
            Navigator.pop(context);

            Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);

          }
        }
      }else {
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){Navigator.pop(context);
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
      //widget.negociosOperables = Utilidades.negociosOperables;
      Cotizadores cotizador = Cotizadores(id_aplicacion: 2343,cantidad_asegurados: 6,aplicacion: "Planes Individuales",descripcion: "Cotizador WEB con configuración PI",estatus: true,visible_movil: true,mensaje: null);
      NegocioOperable negocioOperable = NegocioOperable(
        ramo: "Fuerza Productora Regular GMM",
        negocioOperable: "NOP0002000",
        idNegocioOperable: "G",
        idNegocioComercial: "NC00000FPR",
        idUnidadNegocio: "SDP",
      );
      //negocioOperable.cotizadores.add(cotizador);
      widget.negociosOperables.add(negocioOperable);
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
        iconTheme: IconThemeData(color: AppColors.color_primario),
        backgroundColor: Colors.white,
        title: Text("Cotizador Accidentes Personales", style: TextStyle(color: Colors.black),),
      ),
      body:  isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(AppColors.color_primario),),): Column(
        children:  <Widget>[
          Text(Mensajes.legendCotizador, style: TextStyle(),),
          Visibility(
            visible: true, //widget.negociosOperables[0].cotizadores != null,
            child: Expanded(
                child: Container(
                  child: new ListView.builder(
                      itemCount: widget.negociosOperables.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return NegocioOperableElement(negocioOperable: widget.negociosOperables[index]);
                      }),
                )),
          )
        ],
      ),
    );
  }
}



