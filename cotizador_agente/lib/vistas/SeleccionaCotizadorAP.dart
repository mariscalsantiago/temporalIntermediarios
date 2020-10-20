import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos_widget/NegocioOperableElement.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
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
    this._getNegociosOperables();
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
            "idParticipante": "MMONTA330374"
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
          "Authorization" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWFwcGFnZW50ZXMtcWEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1qd3RAZ25wLWFwcGFnZW50ZXMtcWEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczpcL1wvaWRlbnRpdHl0b29sa2l0Lmdvb2dsZWFwaXMuY29tXC9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTYwMzEyNzIxNiwiZXhwIjoxNjAzMTI5MDE2LCJwcm9qZWN0aWQiOiJnbnAtYXBwYWdlbnRlcy1xYSIsInVpZCI6Ik1NT05UQTMzMDM3NCIsImNsYWltcyI6eyJyb2wiOiJNb250YWx2byBSb2RyaWd1ZXoiLCJuZWdvY2lvc09wZXJhYmxlcyI6Ik1NT05UQTMzMDM3NCIsImlkcGFydGljaXBhbnRlIjoiTU1PTlRBMzMwMzc0IiwibWFpbCI6Im1hcmlvbW9udGFsdm9Ac2VndXJvc21vbnRhbHZvLmNvbSIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJNYXJpbyBNb250YWx2byBSb2RyaWd1ZXoiLCJhcGVwYXRlcm5vIjoiIiwiY3VlbnRhYmxvcXVlYWRhIjpmYWxzZSwidGlwb3VzdWFyaW8iOiJpbnRlcm1lZGlhcmlvcyIsImNlZHVsYSI6IiIsInJvbGVzIjpbIkFnZW50ZXMiLCJTZWd1cm8gTWFzaXZvIiwiU2VndXJvIFBlcnNvbmFzIiwiR00gV29yayBTaXRlIENvdGl6YSJdfX0.tCTGnZYipt6jzX-wq_k03sojnWjvXmTSnEPmue-hVLiBJEf2NIwrlnSV0vwW3xwEprrvF1jr7DnaAqBcKTDzOZ447Cmu6tjRqi2RlOCRHlL5_3wH_kA71Lo9nn8tT21vg0HQCTzgRYSonkG4dzDN2JExekqJgRBIxmp4hP1197XBCiqYis4zBpJGHAr1KHtxOuRlB1FkZY_j_VcuSv3UfMa-EhVrH-m9InllFWACBv18n66gMgdNOBmjICoekxib5qiFFU7qsOm1fVthAaEqwwb1a4UMYpQ8v1GeCpRtLU58BBFk6ZGNp4vPtaohtv6xja-ilUPzaesWKxAwDTmKVQ"
        };

        Map<String, dynamic> jsonMap = {
        "clave_negocio_operable": "NOP0002000",
        "correo": "mariomontalvo@segurosmontalvo.com"
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.color_primario),
        backgroundColor: Colors.white,
        title: Text("Selecciona un cotizador", style: TextStyle(color: Colors.black),),
      ),
      body:  isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(AppColors.color_primario),),): Column(
        children:  <Widget>[

          Visibility(
            visible:  true,//widget.negociosOperables[0].cotizadores != null,
            child: Expanded(
              child: new ListView.builder(
                  itemCount: widget.negociosOperables.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index){
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1.0,
                            color: AppColors.color_borde,
                            offset: Offset(1.0, 3.0),
                          ),
                        ]),
                    child: new ExpansionTile(
                      title: new Text(widget.negociosOperables[0].negocioOperable,
                        style: new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.color_appBar),),
                      children: <Widget>[
                        NegocioOperableElement(negocioOperable: widget.negociosOperables[index],),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


