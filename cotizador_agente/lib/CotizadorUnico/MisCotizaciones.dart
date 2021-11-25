import 'dart:core';
import 'dart:io';

import 'package:cotizador_agente/CotizadorUnico/FiltrosCotizacionesGuardadas.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos_widget/modelo_reglon_misCotizaciones.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'CotizacionPDF.dart';
import '../CotizadorUnico/FormularioPaso1.dart';

import 'dart:async';

class CotizacionesGuardadas extends StatefulWidget {

  bool seCreaNueva;
  CotizacionesGuardadas({Key key, this.seCreaNueva}) : super(key: key);

  @override
  _CotizacionesGuardadasState createState() => _CotizacionesGuardadasState();
}

class _CotizacionesGuardadasState extends State<CotizacionesGuardadas> {
  //Dummy data
  List<Cotizacion> cotizaciones = List<Cotizacion>();
  bool isLoading = true;
  int pagina = 1;
  int registrosGuardados;
  String filtro = "";
  bool nuevaBusqueda = false;
  String nombreCotizacionFiltro; //folioFiltro
  String nombreFiltro = "";
  String fechaInicioFiltro = "null", fechaFinFiltro = "null";
  int maxpagina = 0;
  TextEditingController controllerdday = new TextEditingController();
  TextEditingController controlleraday = new TextEditingController();
  TextEditingController controller = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  String filteraday;
  String filterdday;

  bool nombreAscendente = false;
  bool IDAscendente = false;
  bool FechaAscendente = false;

  IconData col_1_filter_icon = Icons.arrow_drop_down;
  IconData col_2_filter_icon = Icons.arrow_drop_down;
  IconData col_3_filter_icon = Icons.arrow_drop_down;


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {

    llenarTabla(context).then((success){
      if(success == false){
        setState(() {
          isLoading = true;
        });
      }else{
        isLoading = false;
      }
    });
    setState(() {
      controllerdday.addListener(() {
        setState(() {
          filterdday = controllerdday.text;
        });
      });
      controlleraday.addListener(() {
        setState(() {
          filteraday = controlleraday.text;
        });
      });
    });

  }

  eliminarDelServer(int id, BuildContext context) async {

    final Trace deleteCot = FirebasePerformance.instance.newTrace("CotizadorUnico_EliminarCotizacion");
    deleteCot.start();
    print(deleteCot.name);
    bool success = false;

    try{

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{

          Map<String, dynamic> jsonMap = {"folioCotizacion": id};

          Map<String, String> headers = {
            "Content-Type": "application/json",
            "Authorization": loginData.jwt
          };

          Response response = await http.post(Utilidades.urlBorrar, body: json.encode(jsonMap), headers: headers);

          if(response != null){

            if(response.body != null && response.body.isNotEmpty){
              if (json.decode(response.body) == true) {
                success = true;
                deleteCot.stop();
              }

            }else{
              deleteCot.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                eliminarDelServer(id, context);
              });
            }
          }else{
            deleteCot.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              eliminarDelServer(id, context);
            });
          }


        } catch (e) {
          deleteCot.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            eliminarDelServer(id, context);
          });
        }

      }else {
        deleteCot.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          eliminarDelServer(id, context);
        });
      }

    }catch (e) {
      deleteCot.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        eliminarDelServer(id, context);
      });
    }


    return success;

  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }
  changeValueName(String val){
    setState(() {
      nombreFiltro = val;
    });
  }
  changeValues(String valNombreFiltro, String valNombreCotizacionFiltro, String valFechaInicioFiltro, String valFechaFinFiltro, String valFiltro, int valPagina){
    setState(() {
      nombreFiltro = valNombreFiltro;
      nombreCotizacionFiltro = valNombreCotizacionFiltro;
      fechaInicioFiltro = valFechaInicioFiltro;
      fechaFinFiltro = valFechaFinFiltro;
      filtro = valFiltro;
      pagina = valPagina;
      nuevaBusqueda = true;
    });
  }

  llenarTabla(BuildContext context) async {

    final Trace llenaTbl = FirebasePerformance.instance.newTrace("CotizadorUnico_CotizacionesGuardadas");
    llenaTbl.start();
    print(llenaTbl.name);
    bool success = false;

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        setState(() {
          isLoading = true;
        });
        try{
          Map<String, dynamic> jsonMap = {
            "idAplicacion": Utilidades.idAplicacion,
            "pagina": pagina,
            "idUsuario": datosUsuario.idparticipante.toString(),
            "origenCotizacion" : true
          };


          if (filtro != "") {

            if (nuevaBusqueda) {
              cotizaciones.removeRange(0, cotizaciones.length);
              pagina = 1;
              nuevaBusqueda = false;
            }

            switch (filtro) {
              case "nombre":
                jsonMap = {
                  "idAplicacion": Utilidades.idAplicacion,
                  "idUsuario": datosUsuario.idparticipante.toString(),
                  "titularCotizacion": nombreFiltro,
                  "pagina": pagina,
                  "origenCotizacion" : true
                };
                break;
              case "nombreCotizacion":

                jsonMap = {
                  "idAplicacion": Utilidades.idAplicacion,
                  "idUsuario": datosUsuario.idparticipante.toString(),
                  "nombreCotizacion": nombreCotizacionFiltro,
                  "pagina": pagina,
                  "origenCotizacion" : true
                };
                break;
              case "fecha":
                jsonMap = {
                  "idAplicacion": Utilidades.idAplicacion,
                  "idUsuario": datosUsuario.idparticipante.toString(),
                  "fechaInicio": fechaInicioFiltro.substring(0, 10),
                  "fechaFin": fechaFinFiltro.substring(0, 10),
                  "pagina": pagina,
                  "origenCotizacion" : true
                };
                break;
              default:
                filtro = "";
                break;
            }

          }
          //Utilidades.LogPrint("JSONMAP COT G: " + jsonMap.toString());
          Map<String, String> headers = {
            "Content-Type": "application/json",
            "Authorization": loginData.jwt
          };


          if (!blockSearch) {
            blockSearch = true;
            return http.post(Utilidades.urlCotizaciones, body: json.encode(jsonMap), headers: headers).then((Response response) {
              //Utilidades.LogPrint("RESPONSE COT G: " + response.body.toString());

              int statusCode = response.statusCode;

              if(response != null){
                if(response.body != null && response.body.isNotEmpty){
                  if (statusCode == 200) {
                    success = true;
                    registrosGuardados = json.decode(response.body)['registrosEncontrados'];
                    llenaTbl.stop();
                    var list = json.decode(response.body)['cotizaciones'] as List;

                    maxpagina = json.decode(response.body)['numeroPaginas'];


                    //cambios en setState se egrega validacion con mounted
                    if (this.mounted){
                      setState(() {
                        List<Cotizacion> newcotizaciones =
                        list.map((i) => Cotizacion.fromJson(i)).toList();
                        cotizaciones.addAll(newcotizaciones);
                      });
                    }

                    /*setState(() {
                      List<Cotizacion> newcotizaciones =
                      list.map((i) => Cotizacion.fromJson(i)).toList();
                      cotizaciones.addAll(newcotizaciones);
                    });*/

                    isLoading = false;
                  } else if (statusCode == 400) {
                    llenaTbl.stop();
                    isLoading = false;
                    Navigator.pop(context);
                    Utilidades.mostrarAlerta(Mensajes.titleError + statusCode.toString(), "Bad Request", context);

                  } else if (statusCode != null) {
                    llenaTbl.stop();
                    isLoading = false;
                    Navigator.pop(context);
                    String message = json.decode(response.body)['message'] != null
                        ? json.decode(response.body)['message']
                        : json.decode(response.body)['errors'][0] != null
                        ? json.decode(response.body)['errors'][0]
                        : "Error del servidor";

                    Utilidades.mostrarAlerta(Mensajes.titleError + statusCode.toString(), message, context);
                  }

                  if (registrosGuardados == 0) {

                    Utilidades.mostrarAlerta(Mensajes.titleLoSentimos, Mensajes.sinCotizaciones, context);
                  }

                  blockSearch = false;

                }else{
                  llenaTbl.stop();
                  Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                    Navigator.pop(context);
                    llenarTabla(context);
                  });
                }
              }else{
                llenaTbl.stop();
                Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                  Navigator.pop(context);
                  llenarTabla(context);
                });
              }

            });
          }

        }catch(e){
          llenaTbl.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            llenarTabla(context);
          });
        }

      } else {
        llenaTbl.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          llenarTabla(context);
        });
      }
    }catch(e){
      llenaTbl.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        llenarTabla(context);
      });
    }

    return success;
  }

  mostrarMas() {
    setState(() {
      pagina++;
      llenarTabla(context);
    });
  }

  validarRangoFechas(fecha) {

    if (fechaInicioFiltro != "null" && fechaFinFiltro != "null") {
      isLoading = true;
      filtro = "fecha";
      llenarTabla(context);
      //fechaInicioFiltro = "null";
      //fechaFinFiltro = "null";
      /*setState(() {
      FechaAscendente = false;
      col_1_filter_icon = Icons.arrow_drop_down;
    });*/
      nuevaBusqueda = false;
    } else if (fechaInicioFiltro == "null" && fechaFinFiltro == "null") {

      filtro = "";
      llenarTabla(context);
    }
    //print(fechaInicioFiltro + "<--fecha inicio   fecha fin --->" + fechaFinFiltro);
  }

  eliminarCotizacion(Cotizacion c) {
    setState(() {
      if (cotizaciones.contains(c)) {

        cotizaciones.remove(c); //Eliminar de la lista dinámica y actualizar vista
        eliminarDelServer(c.id, context);
      }
    });
  }

  mostrarVistaPrevia(Cotizacion c) {
    Utilidades.sendAnalytics(context, "Acciones", "Vista Previa" + " / " + Utilidades.tipoDeNegocio);
    this.setState(() {
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => CotizacionPDF(
              id: c.id,
              folio: c.id,
              idFormato: c.idFormato,
              id_Plan: c.idPlan,
            ),
          ));
    });
  }

  cotizacionEditar(Cotizacion c) {
    Map<String, dynamic> guardada = json.decode(c.responseResumen);

    Utilidades.cargarNuevoPaso = true;

    Navigator.pop(context);

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => FormularioPaso1(
              cotizacionGuardada: c,
              cotizador: Utilidades.idAplicacion.toString(),
            )));
  }

  ordenarPorNombre() {
    setState(() {
      if (!nombreAscendente) {
        col_2_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto

      } else {
        col_2_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto

      }
      nombreAscendente = !nombreAscendente;

      IDAscendente = false;
      col_3_filter_icon = Icons.arrow_drop_down;
      //llamar al servicio ordenado distinto

      FechaAscendente = false;
      col_1_filter_icon = Icons.arrow_drop_down;

      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      //llamar al servicio ordenado distinto
    });
  }

  ordenarPorID() {
    setState(() {
      if (!IDAscendente) {
        col_3_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto

      } else {
        col_3_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto

      }
      IDAscendente = !IDAscendente;
      FechaAscendente = false;
      col_1_filter_icon = Icons.arrow_drop_down;

      nombreAscendente = false;
      col_2_filter_icon = Icons.arrow_drop_down;

      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    });
  }

  ordenarPorFecha() {
    setState (() {
      if (!FechaAscendente) {
        col_1_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto
      } else {
        col_1_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto
      }
      FechaAscendente = !FechaAscendente;
      IDAscendente = false;
      col_3_filter_icon = Icons.arrow_drop_down;
      nombreAscendente = false;
      col_2_filter_icon = Icons.arrow_drop_down;
    });
  }

  bool blockSearch = false;

  void handleClick(String value) {
    switch (value) {
      case 'Nueva cotización':
        print("Nueva cotización -->");
        if (Utilidades.cotizacionesApp.listaCotizaciones.length >= 3) {
          Utilidades.mostrarAlerta(
            Mensajes.titleAdver,
            Mensajes.limiteCotizacion2,
            context,
          );
          return;
        }
        setState(() {
          //valorEtiquetaPlan = "VIP";
          tieneEdad = false;
          tieneCP = false;
          seRequiereAntiguedad = false;

          if(widget.seCreaNueva){
            nuevaCotizacionDesdeMisCotizaciones = true;
          } else {
            nuevaCotizacionDesdeMisCotizaciones = false;
          }

        });
        print("getCurrentLengthLista ${Utilidades.cotizacionesApp.getCurrentLengthLista()}" );
        Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);
        break;
    }
  }

  Widget listaGuardados() {
    if(isLoading==true)
    {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              Utilidades.color_primario),
        ),
      );
    }
    else if(cotizaciones == null) {
      return Container();
    }
    else if (cotizaciones.length <= 0) {
      return Center(child:Container(child: Text('¡No se encontraron cotizaciones!'),),);
    }
    else {
      List<Widget> cotizacionFiltradas = cotizaciones.map(
              (cotizacion) => Padding(
            padding: const EdgeInsets.only(
                left: 6.0,
                right: 6.0,
                top: 2.0,
                bottom: 0.0), //all(16.0),
            child: GestureDetector(
              onTap: () {
                mostrarVistaPrevia(cotizacion);
              },
              child: RenglonMisCotizaciones(
                cotizacion: cotizacion,
                eliminar: eliminarCotizacion,
                vistaprevia: mostrarVistaPrevia,
                editar: cotizacionEditar,
              ),
            ),
          )).toList();
      if(pagina < maxpagina) {
        cotizacionFiltradas.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: FlatButton(
              child: new Text("Mostrar más"),
              onPressed: () {
                mostrarMas();
              },
            ),
          ),
        ));
      }
      return ListView.builder(
          itemCount: cotizacionFiltradas.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctxt, int index) {
            return cotizacionFiltradas[index];
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //nuevaBusqueda = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mis cotizaciones",
          style: TextStyle(
              color:ColorsCotizador.texto_tabla_comparativa,
              letterSpacing: 0.15,
              fontWeight: FontWeight.normal,
              fontSize: 20
          ),
        ),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios,
            color: Utilidades.color_primario,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Utilidades.color_primario),
        backgroundColor: Colors.white,
        actions:[
          IconButton(
            icon: new Icon(Icons.tune,
              color: Utilidades.color_primario,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => FiltrosCotizacionesGuardadas(
                        handleClick: handleClick,
                        llenarTabla: llenarTabla,
                        changeValues: changeValues
                    ),
                  )
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Nueva cotización'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: ColorsCotizador.color_Bordes),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text("ACCIONES", style: TextStyle(
                              color: ColorsCotizador.color_Etiqueta,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0,
                              letterSpacing: 0.15)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(


                                child: Text(choice, style: TextStyle(
                                    color: ColorsCotizador.color_appBar,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    letterSpacing: 0.15)
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 60),
                                  child: Image.asset("assets/icon/cotizador/guardar_Enabled.png", height: 25, width: 25)
                              ),

                            ],
                          ),
                        ),
                        Divider(color: ColorsCotizador.color_Bordes),
                      ],
                    )
                );
              }).toList();
            },
          ),
        ],
      ),
      body:  SafeArea(
        top: true,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
              child: Text(
                'Se encontraron $registrosGuardados resultados para:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(100, 112, 133, 1),
                ),
              ),
            ),
            filtro == "" ?
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 10, left: 20),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text("Todos", style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.15,
                  fontWeight: FontWeight.w600
              ),),
              decoration: BoxDecoration(
                color: ColorsCotizador.itemFiltros,
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ) :
            filtro == "nombre" ?
            GestureDetector(
              onTap: (){
                setState(() {
                  filtro = "";
                });
                llenarTabla(context);
              },
              child: Container(
                width: 100,
                margin: EdgeInsets.only(top: 15, bottom: 10, left: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Titular", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600
                    ),),
                    Icon(Icons.cancel, color: ColorsCotizador.itemRellenoFiltros,)
                  ],
                ),
                decoration: BoxDecoration(
                  color: ColorsCotizador.itemFiltros,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ) :
            filtro == "nombreCotizacion" ?
            GestureDetector(
              onTap: (){
                setState(() {
                  filtro = "";
                });
                llenarTabla(context);
              },
              child: Container(
                width: 210,
                margin: EdgeInsets.only(top: 15, bottom: 10, left: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Nombre de cotización", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600
                    ),),
                    Icon(Icons.cancel, color: ColorsCotizador.itemRellenoFiltros,)
                  ],
                ),
                decoration: BoxDecoration(
                  color: ColorsCotizador.itemFiltros,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ) :
            filtro == "fecha" ?
            GestureDetector(
              onTap: (){
                setState(() {
                  filtro = "";
                });
                llenarTabla(context);
              },
              child: Container(
                width: 100,
                margin: EdgeInsets.only(top: 15, bottom: 10, left: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Fecha", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600
                    ),),
                    Icon(Icons.cancel, color: ColorsCotizador.itemRellenoFiltros,)
                  ],
                ),
                decoration: BoxDecoration(
                  color: ColorsCotizador.itemFiltros,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ):
            Container(),
            Expanded(
              child: listaGuardados(),
            ),
          ],
        ),
      ),
    );
  }

}
