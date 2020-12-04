import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandlerDio.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;



class SeleccionaCotizadorAP extends StatefulWidget {
  List<NegocioOperable> negociosOperables = new List<NegocioOperable>();
  SeleccionaCotizadorAP({Key key, this.negociosOperables}) : super(key: key);


  @override
  _SeleccionaCotizadorAPState createState() => new _SeleccionaCotizadorAPState();
}

class _SeleccionaCotizadorAPState extends State<SeleccionaCotizadorAP>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {


  bool isLoading = true;
  NegocioOperable negocioSelected;
  Cotizadores cotizadorSelected;

  @override
  void initState() {
    //negociosOper();
    super.initState();

      getNegociosOperables().then((success){
        setState(() {
          negocioSelected = widget.negociosOperables[0];
          cotizadorSelected = widget.negociosOperables[0].cotizadores[0];
        });
      });
  }

  getNegociosOperables( ) async {

    //final Trace negociosOp = FirebasePerformance.instance.newTrace("CotizadorUnico_NegociosOperables");
    /*negociosOp.start();
      print(negociosOp.name);*/
    bool success = false;
    var config = AppConfig.of(context);
    var headers = {
      "Content-Type": "application/json"
    };

    Map<String, dynamic> jsonMap = {
      "consultaNegocio": {
        "idParticipante": datosUsuario.idparticipante.toString(),
      }
    };

    var request = MyRequest(
      baseUrl: config.urlNegociosOperables,
      path: Constants.NEGOCIOS_OPERABLES,
      method: Method.POST,
      body: jsonEncode(jsonMap).toString(),
      headers: headers
    );

    MyResponse response = await RequestHandlerDio.httpRequest(request);

    if(response.success){
      try {
        success = true;

        var list = response.response['consultaPorParticipanteResponse']
        ["consultaNegocios"]["participante"]["listaNegocioOperable"] as List;
        list.removeWhere((element) => element["negocioOperable"].toString() != "AP Worksite");

        setState(() {
          widget.negociosOperables = list.map((i) => NegocioOperable.fromJson(i)).toList();
        });

        widget.negociosOperables.forEach((negocio) async {
          setState(() async {
            negocio.cotizadores = await getCotizadores(negocio);
            negocioSelected = widget.negociosOperables[0];
            cotizadorSelected = widget.negociosOperables[0].cotizadores[0];
          });
        });
        setState(() {
          isLoading = false;
        });
      }catch(e){
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          getNegociosOperables();
        });
      }

    }else{
      isLoading = false;
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        getNegociosOperables();
      });
    }

    return success;

  }


  Future<List<Cotizadores>> getCotizadores(NegocioOperable negocioOperable) async {
    // set up POST request arguments
    /*final Trace cotizadores = FirebasePerformance.instance.newTrace("CotizadorUnico_GetCotizadores");
    cotizadores.start();
    print(cotizadores.name);*/
    var config = AppConfig.of(context);
    List<dynamic> list;
    List<Cotizadores> listCotizadores = List<Cotizadores>();
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

        var request = MyRequest(
            baseUrl: config.urlBase,
            path: Constants.COTIZADORES,
            method: Method.POST,
            body: jsonEncode(jsonMap).toString(),
            headers: headers
        );

        MyResponse response = await RequestHandlerDio.httpRequest(request);

        if(response.success){

          list = response.response['cotizadores'];

          setState(() {
            //negocioOperable.cotizadores = list.map((i) => Cotizadores.fromJson(i)).toList();
            isLoading = false;
          });
          for(int i =0; i<list.length; i++){
            listCotizadores.add(Cotizadores.fromJson(list[i]));
          }
          return listCotizadores;
        }else{
          //cotizadores.stop();
          isLoading = false;
          Navigator.pop(context);

          //Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), "Bad Request", context);
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleError, response.response, context,"Aceptar",(){
            Navigator.pop(context);
          });
          return listCotizadores;
        }
      }else {
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          getCotizadores(negocioOperable);
        });
      }

    }catch(e){
      //cotizadores.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        getCotizadores(negocioOperable);
      });
      return listCotizadores;
    //  return list.map((i) => Cotizadores.fromJson(i)).toList(); //TODO Regresar una excepción
    }

    return listCotizadores;

  }

  @override
  Widget build(BuildContext context) {

    if(Utilidades.negociosOperables.length > 0){
      widget.negociosOperables = Utilidades.negociosOperables;
      isLoading = false;
    }else{
      if(widget.negociosOperables == null){
        getNegociosOperables();
      }else{
        isLoading = false;
      }
    }

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.secondary900, size: 28,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(color: AppColors.color_primario),
          backgroundColor: Colors.white,
          title: Text("Seguros Masivos", style: TextStyle(color: AppColors.color_TextAppBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500),),
        ),
        body:  Column(
          children:  <Widget>[

            Visibility(
              visible: widget.negociosOperables != null && widget.negociosOperables.length>0 ? widget.negociosOperables[0].cotizadores != null : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 33.5, left: 33.5, bottom: 40.0),
                child: Image.asset("assets/img/img_negocios.png", height: 208, width: 294,),
              ),
            ),
            Visibility(
              visible:  widget.negociosOperables != null && widget.negociosOperables.length>0 ? widget.negociosOperables[0].cotizadores != null : false,
              child: Expanded(
                child: new ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index){
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text("NEGOCIO OPERABLE",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, letterSpacing: 0.32, color: AppColors.primary700),
                                  textAlign: TextAlign.start,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0, left: 16.0, right: 16.0,),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.naranjaGNP,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 17.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16,),
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 1.0),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(4.0),
                                      topRight: const Radius.circular(4.0),
                                      bottomLeft: const Radius.circular(4.0),
                                      bottomRight: const Radius.circular(4.0)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: Colors.white,
                                      offset: Offset(2.0, 4.0),
                                    ),
                                  ]),
                              child: widget.negociosOperables[0] != null && widget.negociosOperables.length>0 ? DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  elevation: 1,
                                  value: negocioSelected != null ? negocioSelected : widget.negociosOperables[0],
                                  isExpanded: true,
                                  items: widget.negociosOperables.map((NegocioOperable negocio) { //Declarar una lista y solo agregar los valores que contengan cotizadores y regresar esa lista de dropdownitems
                                    return new DropdownMenuItem<NegocioOperable>(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                      },
                                      value: negocio,
                                      child: new Text(
                                        negocio.negocioOperable,
                                        style: new TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (NegocioOperable newValue) {
                                    setState(() {
                                      negocioSelected = newValue;
                                      cotizadorSelected = negocioSelected.cotizadores[0];
                                    });
                                  },
                                ),
                              ) : Container(),
                            ),
                          ),

                          Visibility(
                            visible: true,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 31.0, right: 16.0, left: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("COTIZADOR",
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, letterSpacing: 0.32, color: AppColors.primary700),
                                        textAlign: TextAlign.start,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0, left: 16.0, right: 16.0,),
                                  child: Divider(
                                    thickness: 1,
                                    color: AppColors.naranjaGNP,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 17.0, bottom: 17.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16, right: 16, ),
                                    height: 48,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 1.0),
                                        borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(4.0),
                                            topRight: const Radius.circular(4.0),
                                            bottomLeft: const Radius.circular(4.0),
                                            bottomRight: const Radius.circular(4.0)
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0.0,
                                            color: Colors.white,
                                            offset: Offset(2.0, 4.0),
                                          ),
                                        ]
                                    ),
                                    child: widget.negociosOperables.length>0 && widget.negociosOperables[0].cotizadores.length> 0 ? DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        elevation: 1,
                                        value: cotizadorSelected != null ? cotizadorSelected : widget.negociosOperables[0].cotizadores[0],
                                        isExpanded: true,
                                        items: widget.negociosOperables[widget.negociosOperables.indexOf(negocioSelected) < 0 ? 0 : widget.negociosOperables.indexOf(negocioSelected)].cotizadores.map((Cotizadores cotizador) {
                                          return new DropdownMenuItem<Cotizadores>(
                                            onTap: () {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                            },
                                            value: cotizador,
                                            child: new Text(
                                              cotizador.aplicacion,
                                              style: new TextStyle(color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (Cotizadores newValue) {
                                          setState(() {
                                            cotizadorSelected = newValue;
                                          });
                                        },
                                      ),
                                    ) : Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      );
                    }
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 31.0,bottom: 16.0, right: 16, left: 16),//
          child: ButtonTheme(
            minWidth: 400.0,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),),
            child: FlatButton(
                color: AppColors.secondary900,
                textColor: Colors.white,
                child: Text("Cotizar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 1.25),
                ),
                onPressed: () {
                  CotizacionesApp nuevo = new CotizacionesApp();

                  Utilidades.cotizacionesApp = nuevo;

                  if(cotizadorSelected.mensaje != null) {
                    Utilidades.mostrarAlertaCallback(
                        Mensajes.titleContinuar, cotizadorSelected.mensaje, context, () {
                      Navigator.pop(context);
                    }, () {
                      Navigator.pop(context);
                      Utilidades.idAplicacion = int.parse(cotizadorSelected.id_aplicacion.toString());
                      Utilidades.tipoDeNegocio = cotizadorSelected.aplicacion;
                      //   seccionCotizador();
                      Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);
                      Utilidades.deboCargarPaso1 = false;
                    });
                  } else{
                    Utilidades.idAplicacion = int.parse(cotizadorSelected.id_aplicacion.toString());
                    Utilidades.tipoDeNegocio = cotizadorSelected.aplicacion;
                    //  seccionCotizador();
                    Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);
                    Utilidades.deboCargarPaso1 = false;
                  }
                }),
          ),
        ),
      ),
    );
  }
}


