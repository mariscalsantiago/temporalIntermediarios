import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos_widget/NegocioOperableElement.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';



class SeleccionaCotizadorAP extends StatefulWidget {
  List<NegocioOperable> negociosOperables = new List<NegocioOperable>();
  SeleccionaCotizadorAP({Key key, this.negociosOperables}) : super(key: key);


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
    Future.delayed(Duration.zero, () {
      _getNegociosOperables();
    });
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
            "idParticipante": "TALLPRO",//datosUsuario.idparticipante.toString(),
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
          "Authorization" : loginData.jwt.toString()
        };

        Map<String, dynamic> jsonMap = {
        "clave_negocio_operable": negocioOperable.idNegocioOperable.toString(), //"NOP0002010",
        "correo": datosUsuario.mail.toString(), //"TallerdeProductos@gnp.com.mx", //
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

    if(Utilidades.negociosOperables.length > 0){
      widget.negociosOperables = Utilidades.negociosOperables;
      isLoading = false;
    }else{
      if(widget.negociosOperables == null){
        _getNegociosOperables();
      }else{
        isLoading = false;
      }
    }

    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.8,
      color: AppColors.primary700,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 5.0,
      ),
      child: Scaffold(
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
          title: Text("Cotizador Único GMM", style: TextStyle(color: AppColors.color_TextAppBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500),),
        ),
        body:  Column(
          children:  <Widget>[

            Visibility(
              visible:  widget.negociosOperables != null && widget.negociosOperables.length>0 ? widget.negociosOperables[0].cotizadores != null : false,
              child: Expanded(
                child: new ListView.builder(
                    itemCount: widget.negociosOperables != null && widget.negociosOperables.length>0 ? widget.negociosOperables.length : 0,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1.0,
                                  color: AppColors.color_borde,
                                  offset: Offset(1.0, 3.0),
                                ),
                              ]),
                          child: NegocioOperableElement(negocioOperable: widget.negociosOperables[index],),
                        ),);
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


