
import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/MisCotizaciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cotizador_agente/utils/Constants.dart' as Constants;
//import 'package:cotizador_agente/cotizador_analitycs_tags.dart';


class FormularioPaso2 extends StatefulWidget {

  final String text;
  Cotizacion cotizacionGuardada;
  bool preCargaFinalizada = false;
  final bool deboCargarSiguientePaso = true;
  bool seleccionarValorDefecto = false;

  List <Seccion> secciones; //secciones del paso formulario intermedio
  FormularioPaso2({Key key, this.text, this.secciones, this.cotizacionGuardada, this.seleccionarValorDefecto = false}) : super(key: key);
  @override
  _FormularioPaso2State createState() => _FormularioPaso2State();
}

class _FormularioPaso2State extends State<FormularioPaso2> {
  bool isLoading = true;
  String plan;
  FlutterWebviewPlugin _flutterWebViewPlugin = new FlutterWebviewPlugin();
  String _initialURL="";
  Map<String, dynamic> parameters =  Map<String, dynamic>();
  String dataLayer= "";
  bool isLoadURL = false;
  bool isFinish = false;
  bool isOpen = true;
  bool isClose = false;
  bool isChangeicon1 = true;
  bool isChangeicon2 = true;
  //final FirebaseAnalytics analytics = new FirebaseAnalytics();

  String _something ="Cargando... ";
  final formKey = GlobalKey<FormState>();

  void actualizarCodigoPostalFamiliares() {
    setState(() {
      var titular = Utilidades.buscaCampoPorID(
          Utilidades.titularSeccion, Utilidades.titularCampo, false);
      if (titular.length > 0) {
        var _titular = titular[0];
        var familiares = Utilidades.buscaCampoPorID(
            Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
        if (familiares != null) {
          for (var familiar in familiares) {
            familiar.valor = _titular.valor;
          }
        }
      }
    });
  }

  void borrarAdicional(int hashCode) {
    setState(() {
      List<Seccion> seccionesAdicionales = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;
      seccionesAdicionales = seccionesAdicionales.where((s) => s.id_seccion == Utilidades.familiarSeccion).toList();
      for(Seccion seccion in seccionesAdicionales) {
        if (seccion.children_secc!=null) {
          seccion.children_secc.removeWhere((item) => item.hashCode == hashCode);
          int _c = 1;
          for(Seccion seccionChild in seccion.children_secc) {
            seccionChild.seccion = "Adicional " + _c.toString();
            _c += 1;
          }
        }
      }
    });
  }

  bool validarCodigoPostalFamiliares() {
    var titular = Utilidades.buscaCampoPorID(
        Utilidades.titularSeccion, Utilidades.titularCampo, false);
    if (titular.length > 0) {
      var _titular = titular[0];
      var familiares = Utilidades.buscaCampoPorID(
          Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
      if (familiares != null) {
        return (familiares.length > 0);
      }
    }
    return false;
  }


  void recargarPaso2(String p){
    //actualizarVistaConNuevoPlan(p);
    //Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Utilidades.cotizacionesApp.eliminarDeLaComparativa(Utilidades.cotizacionesApp.getCurrentLengthLista()-1);

    Navigator.pushNamed(context, "/cotizadorUnicoAPPasoUno",);



  }


  actualizarVistaConNuevoPlan(String p) async{

    setState(() {
      Utilidades.isloadingPlan = true;
    });
    bool success = false;

    try{
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{

          plan = p;
          success = true;
          Map<String, dynamic> jsonMap = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON();

          Map<String, dynamic> map_gmm = jsonMap["cotizacionGMMRequest"];


          Map<String, dynamic> map_plan = {
            "idPlan":int.parse(p)
          };
          map_gmm.addAll(map_plan);

          jsonMap["cotizacionGMMRequest"]= map_gmm;


          Map<String, dynamic> map_titluar = jsonMap["cotizacionGMMRequest"]["titular"];
          Map<String, dynamic> map_id = {
            "id":1
          };
          map_titluar.addAll(map_id);


          bool hayMasAsegurados = true;
          int cont =0;
          while(hayMasAsegurados){
            try{
              jsonMap["cotizacionGMMRequest"]["asegurados"][cont]["id"] = cont+2;
            }catch(e){
              hayMasAsegurados = false;
            }
            cont++;
          }


          jsonMap["cotizacionGMMRequest"]["titular"] = map_titluar;

          cargarSiguientePaso(jsonMap["cotizacionGMMRequest"]);

        }catch(e){
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            actualizarVistaConNuevoPlan(p);
          });
        }

      }else{
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          actualizarVistaConNuevoPlan(p);
        });
      }
    }catch(e){
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        actualizarVistaConNuevoPlan(p);
      });
    }

    return success;

  }


  cargarSiguientePaso(Map<String, dynamic> map_plan) async {

    print(map_plan.toString());

    setState(() {
      isLoading = true;
    });
    /*final Trace cargaPaso = FirebasePerformance.instance.newTrace("CotizadorUnico_PasoDos");
    cargaPaso.start();
    print(cargaPaso.name);*/
    bool success = false;

    final result = await InternetAddress.lookup('google.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      Map<String, String> headers = {"Content-Type": "application/json"};

      var request = MyRequest(
          baseUrl: AppConfig.of(context).urlBase,
          path: Constants.FORMULARIO_PASO2,
          method: Method.POST,
          body: jsonEncode(map_plan).toString(),
          headers: headers
      );

      MyResponse response = await RequestHandler.httpRequest(request);

      if(response.success){
        setState(() {
          PasoFormulario estePaso = PasoFormulario.fromJson(response.response);
          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2 =  estePaso;
          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan= plan;


          if(widget.cotizacionGuardada != null && (widget.preCargaFinalizada == false)){
            widget.preCargaFinalizada = true;
            Map<String,dynamic> resumenSecciones = json.decode(widget.cotizacionGuardada.responseResumen);

            if(resumenSecciones != null){
              var lista_secciones = resumenSecciones['seccion'] as List;

              lista_secciones.forEach((s){
                var lista_campos = s['valores'] as List;
                int id_Seccion = s["idSeccion"];


                if(lista_campos != null && lista_campos.length > 0){

                      if(lista_campos[0]["valores"] != null){
                        //La lista campos se convierte en lista de secciones child

                        estePaso.secciones.forEach((seccion_mult){
                          if(seccion_mult.id_seccion == id_Seccion){
                            for(int i=0; i< lista_campos.length; i++){


                              seccion_mult.addChild();
                              var lista_camposmult = lista_campos[i]["valores"] as List;
                              for(int j=0; j<lista_camposmult.length; j++){
                                if(lista_camposmult[j]["valor"] != null){
                                  Campo campo_result = estePaso.buscarCampoPorID(seccion_mult.children_secc[i].campos, lista_camposmult[j]["idCampo"], false);
                                  if(campo_result != null){
                                    campo_result.valor = lista_camposmult[j]["valor"].toString();
                                  }
                                }
                              }
                            }
                          }
                        });

                      }else{

                        estePaso.secciones.forEach((secciones_este_paso){
                          if(secciones_este_paso.id_seccion == id_Seccion){
                            for(int i=0; i< lista_campos.length; i++){

                              Campo c = estePaso.buscarCampoPorID(secciones_este_paso.campos, lista_campos[i]["idCampo"], false);

                              if(c!=null){
                                if(c.tipo_componente!= "card"){

                                  //print(c.nombre_campo);

                                  if(c.tipo_componente!="textbox" && c.tipo_componente!="checkbox" && c.tipo_componente!="date_relativa"){

                                    bool valorDisponible = false;
                                    if(c.valores!=null){
                                      for(int j = 0; j< c.valores.length; j++){

                                        if(lista_campos[i]["valor"].toString() == c.valores[j].id){
                                          valorDisponible = true;
                                          break;
                                        }

                                      }
                                    }

                                    if(valorDisponible){
                                      c.valor = lista_campos[i]["valor"].toString();
                                      if (c.seccion_dependiente != null) {
                                        //print("voy a filtrar la seccion"+ c.seccion_dependiente);
                                        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
                                            int.parse(c.seccion_dependiente),
                                            int.parse(c.valor));
                                      }

                                      if(c.oculta){

                                        //ocultar campos
                                        c.valores.forEach((valor){
                                          if(valor.id == c.valor){
                                            if(valor.oculta_campos.length>0){
                                              //print("Este valor:"+ valor.descripcion.toString()+ ", oculta campos");
                                              valor.oculta_campos.forEach((referencia){
                                                List <Campo> campos  =  Utilidades.buscaCampoPorID(referencia.id_seccion, referencia.id_campo, true);
                                                if(campos!=null){
                                                  campos.forEach((campo){
                                                    //print("El campo a ocultar es: "+ campo.etiqueta.toString());


                                                    //Se oculta el valor del campo padre
                                                    if(campo.parent_campo!=null){
                                                      Campo campo_padre = Utilidades.buscaCampoPorID(campo.parent_campo.id_seccion, campo.parent_campo.id_campo, true)[0];
                                                      //print("Campo Padre es: "+campo_padre.etiqueta);


                                                      if(campo_padre.valores!=null){
                                                        //campo_padre.filtrarHijos(campo.id_campo.toString());
                                                        if(campo_padre.valor == campo.id_campo.toString()){

                                                          bool esValorNoVisible = true;
                                                          String id_inicial;
                                                          //Verificar que el valor inicial sea visible.
                                                          for (int i = 0; i<campo_padre.valores.length && esValorNoVisible; i++){
                                                            if(campo_padre.valores[i].visible){
                                                              esValorNoVisible = false;
                                                              id_inicial= campo_padre.valores[i].id;
                                                            }
                                                          }
                                                          campo_padre.valor =  id_inicial;

                                                        }

                                                        campo_padre.valores.forEach((valor){

                                                          if(valor.id==campo.id_campo.toString()){
                                                            valor.visible= false;
                                                          }
                                                        });

                                                      }

                                                    }else{
                                                      print("El campo padre es null");
                                                    }

                                                    //Se oculta el campo
                                                    // print("oculto el campo"+ campo.etiqueta);
                                                    campo.visible = false;
                                                    campo.visibleLocal = false;
                                                    // print("oculto el campo"+ campo.etiqueta+ campo.visible.toString());


                                                    c.campos_modificados.add(referencia);
                                                    // print("Se agrego la referencia"+ referencia.id_campo.toString());


                                                  });
                                                }
                                              });
                                            }
                                          }
                                        });

                                      }

                                    }
                                  }else{
                                    c.valor = lista_campos[i]["valor"].toString();
                                  }

                                }

                              }

                            }
                          }
                        });

                      }

                    }
                  });

                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan= plan;
                }

              }

            });
            //cargaPaso.stop();
            setState(() {
              isLoading = false;
              Utilidades.isloadingPlan = false;
              success = true;
            });

          }else{
            //cargaPaso.stop();
            Navigator.pop(context);
            String message = response.response['message'] != null ? response.response['message'] : response.response['errors'][0] != null ? response.response['errors'][0] : "Error del servidor";
            Utilidades.mostrarAlerta(Mensajes.titleError,message, context);

            setState(() {
              isLoading = false;
              success = true;
              Utilidades.isloadingPlan = false;
            });

          }

      }else {
        //cargaPaso.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          cargarSiguientePaso(map_plan);
        });
      }

    return success;

  }


  refresh() {
    setState(() {});
  }

  agregarAlDiccionario(String key, String value){
    setState(() {
      //El metodo que ya funciona
      print("llegue al metodo del diccionario");
    });
  }

  Future _initialWebView() async {

    dataLayer = json.encode(Utilidades.seccCot);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(dataLayer);

    setState(() {
      _initialURL = AppConfig.of(context).urlBaseAnalytics + Constants.ENVIA_COTIZACION + encoded;
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

  }


  @override
  void initState(){

    if(widget.secciones[0].campos[0].valor !=null && !widget.seleccionarValorDefecto ){ //Agregar validación para saber si los datos se modificaron

      bool seEncuentraValorEnLista = false;
      widget.secciones[0].campos[0].valores.forEach((valor){

        if(valor.id==widget.secciones[0].campos[0].valor && valor.visible){
          seEncuentraValorEnLista = true;
        }

      });


      if(!seEncuentraValorEnLista){
        bool esValorNoVisible = true;
        String id_inicial;
        //Verificar que el valor inicial sea visible.
        for (int i = 0; i<widget.secciones[0].campos[0].valores.length && esValorNoVisible; i++){
          if(widget.secciones[0].campos[0].valores[i].visible){
            esValorNoVisible = false;
            id_inicial= widget.secciones[0].campos[0].valores[i].id;
          }


        }
        widget.secciones[0].campos[0].valor = id_inicial;
      }

      actualizarVistaConNuevoPlan(widget.secciones[0].campos[0].valor);
    }else{

      String valorDefecto;

      for(int i=0; i<widget.secciones[0].campos[0].valores.length; i++){ //Buscar si existe valorDefault
        if(widget.secciones[0].campos[0].valores[i].valor_default){

          if(widget.secciones[0].campos[0].valores[i].visible){//Asigna valor default si es visible
            valorDefecto = widget.secciones[0].campos[0].valores[i].id;
          }else{
            for(int j=0; j<widget.secciones[0].campos[0].valores.length; j++){
              if(widget.secciones[0].campos[0].valores[j].visible){ //Asigna primer valor visible
                valorDefecto = widget.secciones[0].campos[0].valores[j].id;
              }
            }
          }
        }

      }

      if(valorDefecto == null){
        for(int k=0; k<widget.secciones[0].campos[0].valores.length; k++){
          if(widget.secciones[0].campos[0].valores[k].visible){ //Asigna primer valor visible
            valorDefecto = widget.secciones[0].campos[0].valores[k].id;
          }
        }

      }
      widget.secciones[0].campos[0].valor = valorDefecto;
      actualizarVistaConNuevoPlan(widget.secciones[0].campos[0].valor);

    }

  }

  @override
  Widget build(BuildContext context) {


    /*if(Utilidades.deboCargarPaso1){

      if(Utilidades.cotizacionesApp.listaCotizaciones.length == 0){
        Utilidades.deboCargarPaso1 = true;
        //Navigator.pop(context);
      }
    }

*/
    return GestureDetector(
      /*onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },*/

      child: LoadingOverlay(
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
            leading: IconButton(
              icon: Icon(Icons.chevron_left, size: 35,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            iconTheme: IconThemeData(color: AppColors.color_primario),
            backgroundColor: Colors.white,
            title: Text("Cotizador AP", style: TextStyle(color: AppColors.color_appBar.withOpacity(0.87), fontSize: 20, fontWeight: FontWeight.w500, fontFamily: "Roboto", letterSpacing: 0.15),),
            actions: <Widget>[
              PopupMenuButton(icon: Image.asset('assets/icon/cotizador/ic_appbar.png'),
                  offset: Offset(100, 100),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Column(
                        children: <Widget>[
                          Divider(height: 4,color: AppColors.color_divider,),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(Mensajes.acciones,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: AppColors.color_popupmenu,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      letterSpacing: 1.5,)
                                ),
                                Spacer(flex: 1,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value:2,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0,right: 16.0, left: 16.0),
                                child: Text(Mensajes.guarda,
                                    style: TextStyle(
                                        color: AppColors.color_disable,//AppColors.color_appBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                    letterSpacing: 0.15)
                                ),
                              ),
                              Spacer(flex: 2,),
                              IconButton(
                                icon: Image.asset('assets/icon/cotizador/guardar_Disable.png'),
                                onPressed: () {

                                },),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Divider(height: 2,color: AppColors.color_divider,),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value:3,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0,right: 16.0, left: 16.0),
                                child: Text(Mensajes.titleLimpia,
                                    style: TextStyle(
                                        color: AppColors.color_appBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                    letterSpacing: 0.15)
                                ),),
                              Spacer(flex: 2,),
                              IconButton(
                                icon: Image.asset('assets/icon/cotizador/ic_borrar.png'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  actualizarVistaConNuevoPlan(plan);

                                },),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
                            child: Divider(height: 2,color: AppColors.color_divider,),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Column(
                        children: <Widget>[
                          Divider(height: 4,color: AppColors.color_divider,),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(Mensajes.soporte,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: AppColors.color_popupmenu,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      letterSpacing: 1.5,)),
                                Spacer(flex: 1,)
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Text(Mensajes.misCotizaciones,
                                    style: TextStyle(
                                        color: AppColors.color_appBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                    letterSpacing: 0.15)
                                ),),
                              Spacer(flex: 2,),
                              IconButton(
                                icon: Image.asset('assets/icon/cotizador/miscotizaciones.png'),
                                onPressed: () {
                                  Navigator.push(context,  MaterialPageRoute(
                                    builder: (context) => MisCotizaciones(),
                                  ));
                                },),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Divider(height: 2,color: AppColors.color_divider,),
                          ),
                        ],
                      ),
                    ),
                  ],
                  initialValue: 0,
                  onCanceled: () {
                    print("You have canceled the menu.");
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 2:
                        break;
                      case 3:
                        Navigator.pop(context);
                        actualizarVistaConNuevoPlan(plan);
                        break;
                      case 4:
                        Navigator.push(context,  MaterialPageRoute(
                          builder: (context) => MisCotizaciones(),
                        ));
                        break;
                    }
                  }
              ),
            ],
          ),
          /*AppBar(
            iconTheme: IconThemeData(color: AppColors.color_primario),
            backgroundColor: Colors.white,
            title: Text("Paso 2", style: TextStyle(color: Colors.black)),
          )*/

          body: Column(

              children:<Widget>[

               // TopBar(formKey: formKey, recargarFormularioConPlan: recargarPaso2, plan: plan,),

                /****** Termina panel superior *******/



                Expanded(
                  child: Form(
                    key: formKey,
                    child:
                    isLoading ? Container() :
                    new ListView.builder(
                        itemCount: widget.secciones.length+1,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int index) {



                          //Para el primero
                          if(index==0){
                            return Column(
                              children: <Widget>[

                                /*Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(top: 32, left: 16, bottom: 24),
                                  child: Text(
                                    widget.secciones[index].seccion,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.color_titulo,
                                        fontSize: 20),
                                  ),
                                ),

                                Container(//Etiquetas
                                  color: AppColors.color_sombra,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Datos Personales", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w500, fontSize: 15),),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Planes", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_primario, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(//Puntos
                                  color: AppColors.color_sombra,

                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          color: AppColors.color_sombra,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[

                                                  Spacer(),
                                                  CircleButton(backgroundColor: AppColors.color_titulo ,onTap: () => print("Cool"), iconData: Icons.check,),
                                                  Expanded(
                                                    child: Container(
                                                        child: Divider( //002e71
                                                          thickness: 2,
                                                          color: AppColors.color_primario,
                                                          height: 0,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Container(
                                          color: AppColors.color_sombra,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                        child: Divider( //002e71
                                                          thickness: 2,
                                                          color: AppColors.color_primario,

                                                          height: 0,
                                                        )),
                                                  ),
                                                  CircleButton(backgroundColor: AppColors.color_primario ,onTap: () => print("Cool")),

                                                  Spacer(),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                Container(//Etiquetas
                                  color: AppColors.color_sombra,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Paso 1", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w500, fontSize: 15),),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Paso 2", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_primario, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ))
                                    ],
                                  ),
                                ),*/

                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0, bottom: 0.0),
                                  child: Container(
                                    color: AppColors.color_background,
                                    height: 74.0,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0,top: 12.0,),
                                          child: Image.asset("assets/icon/cotizador/paso1.png", height: 50, width: 50,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 44, left: 16.0),
                                          child: Text("Solicitantes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.color_appBar),),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 13.0, top:10.0, bottom: 10.0),
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(visible: isOpen,
                                                  child: IconButton(
                                                    icon: Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                                    onPressed: ((){
                                                      //Mostrar container que indique en que paso se encuentra
                                                      setState(() {
                                                        isClose = true;
                                                        isOpen = false;
                                                      });
                                                    }),)
                                              ),
                                              Visibility(visible: isClose,
                                                  child: IconButton(
                                                    icon: Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,),
                                                    onPressed: ((){
                                                      //Mostrar container que indique en que paso se encuentra
                                                      setState(() {
                                                        isClose = false;
                                                        isOpen = true;
                                                      });
                                                    }),)
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: isClose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0.0, bottom: 11.0),
                                      child: Container(
                                        color: AppColors.color_background,
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 29.0),
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: FlatButton(
                                                        onPressed: null,
                                                        color: Colors.white,
                                                        textColor: AppColors.secondary900,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            side: BorderSide(color: AppColors.primary700)
                                                        ),
                                                        child: Text("1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 29.0),
                                                    child: Text("Cotiza", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.secondary900),),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 35.0, top:0, bottom:0),
                                                    child: Image.asset("assets/icon/cotizador/union.png", height: 24, width: 22,),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 29.0),
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: FlatButton(
                                                        onPressed: null,
                                                        color: Colors.grey,
                                                        textColor: AppColors.color_appBar,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            side: BorderSide(color: AppColors.primary700)
                                                        ),
                                                        child: Text("2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 29.0),
                                                    child: Text("Elige", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.color_appBar),),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                                  child: Container(
                                    color: AppColors.color_background,
                                    child: ExpansionTile(
                                      onExpansionChanged: (value){
                                        setState(() {
                                          isChangeicon1 = value;
                                        });
                                      },
                                      trailing: (isChangeicon1 == true) ? Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,) : Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                      initiallyExpanded: true,
                                      title: Text(widget.secciones[index].seccion,
                                        style: new TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.color_titleAlert,
                                          fontFamily: "Roboto",
                                        ),),
                                      children: <Widget>[
                                        Container(
                                          color: AppColors.color_background_blanco,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: widget.secciones[index], i:index, end:widget.secciones.length-1, formKey: formKey,actualizarSecciones: actualizarVistaConNuevoPlan,
                                              actualizarCodigoPostalFamiliares:
                                              actualizarCodigoPostalFamiliares,
                                              validarCodigoPostalFamiliares:
                                              validarCodigoPostalFamiliares,
                                              borrarAdicional: borrarAdicional,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            );

                          }

                          if(index==widget.secciones.length){ //Aqui va el formulario paso 2
                            try{
                              return Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2==null
                                  ? Container() : isLoading == true
                                  ? Container() : ListView.builder(
                                  itemCount:  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length+1,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (BuildContext ctxt, int index_paso2) {

                                    //Botón de continuar al último
                                    if(index_paso2 == Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length){
                                      return  Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            FlatButton(
                                              color: AppColors.secondary900,
                                              textColor: Colors.white,
                                              disabledColor: Colors.grey,
                                              disabledTextColor: Colors.black,
                                              padding: EdgeInsets.all(8.0),
                                              onPressed: () {
                                                final bool v = formKey.currentState.validate();

                                                formKey.currentState.save();

                                                if (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.validarFormulario()) {
                                                  //Enviar a Analitycs
                                                  print("Cotizador Analitycs Tags");
                                                  //CotizadorAnalitycsTags.sendTagsFormulario(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion());
                                                  //CotizadorAnalitycsTags.sendTags('', Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().getJSONComparativa(1));
                                                  //_sendDataToSecondScreen(context);
                                                  print('El formulario es valido');
//                                              print(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.toJSON());
//                                              Utilidades.LogPrint("Esto es para cotizar: " + json.encode(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().getJSONComparativa()));
                                                  setState(() {
                                                    //_initialWebView();
                                                  });
                                                  Regla r = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().calcularReglas();

                                                  if(r!=null){
                                                    print(r.mensaje);
                                                    if(r.tipoRegla== Utilidades.REGLA_INFO){


                                                      Utilidades.mostrarAlertaCallback("¿Desea Continuar?", r.mensaje, context, (){ //CANCELAR

                                                        Navigator.pop(context);

                                                      }, (){ //ACEPTAR

                                                        Navigator.pop(context);
                                                        Navigator.pushNamed(context, "/cotizadorUnicoAPPasoTres",);

                                                      });
                                                    }
                                                    if(r.tipoRegla== Utilidades.REGLA_STOPPER){
                                                      Utilidades.mostrarAlerta("No es posible continuar", r.mensaje, context);
                                                    }

                                                  }else{
                                                    print("No se cumplen reglas");

                                                    Navigator.pushNamed(context, "/cotizadorUnicoAPPasoTres");

                                                  }

                                                } else {
                                                  print("invalid");
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "COTIZAR",
                                                  style: TextStyle(fontSize: 15.0, letterSpacing: 1),
                                                ),
                                              ),
                                            ),
                                            Container(
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
                                            ),
                                          ],
                                        ),
                                      );

                                    }



                                    return Padding(
                                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                                      child: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2].campos.length != 0 || (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2].children_secc.length != 0 && Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2].children_secc_sin_filtro.length > 1) ? Container(
                                        color: AppColors.color_background,
                                        child: ExpansionTile(
                                          onExpansionChanged: (value){
                                            setState(() {
                                              isChangeicon2 = value;
                                            });
                                          },
                                          trailing: (isChangeicon2 == true) ? Image.asset("assets/icon/cotizador/expand_less.png", height: 24, width: 24,) : Image.asset("assets/icon/cotizador/expand_more.png", height: 24, width: 24,),
                                          initiallyExpanded: true,
                                          title: Text(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2].seccion,
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.color_titleAlert,
                                              fontFamily: "Roboto",
                                            ),),
                                          children: <Widget>[
                                            Container(
                                              color: AppColors.color_background_blanco,
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child:
                                                isLoading == true
                                                    ? Container()
                                                    : new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc:  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2], i:index_paso2, end: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length-1, formKey: formKey, actualizarSecciones: actualizarVistaConNuevoPlan,
                                                  actualizarCodigoPostalFamiliares:
                                                  actualizarCodigoPostalFamiliares,
                                                  validarCodigoPostalFamiliares:
                                                  validarCodigoPostalFamiliares,
                                                  borrarAdicional: borrarAdicional,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ) :
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child:
                                        isLoading == true ?
                                        Container() :
                                        new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc:  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones[index_paso2], i:index_paso2, end: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2.secciones.length-1, formKey: formKey, actualizarSecciones: actualizarVistaConNuevoPlan,
                                          actualizarCodigoPostalFamiliares:
                                          actualizarCodigoPostalFamiliares,
                                          validarCodigoPostalFamiliares:
                                          validarCodigoPostalFamiliares,
                                          borrarAdicional: borrarAdicional,
                                        ),
                                      ),
                                    );


                                  });
                            }catch(e){

                            }



                          }



                          //Secciones restantes estáticas restantes de paso 2
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                            (isLoading == true || (widget.secciones.length-1)==0 )  ?
                            Container() :
                            new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: widget.secciones[index], i:index, end:widget.secciones.length-1, formKey: formKey, actualizarSecciones: actualizarVistaConNuevoPlan,
                              actualizarCodigoPostalFamiliares:
                              actualizarCodigoPostalFamiliares,
                              validarCodigoPostalFamiliares:
                              validarCodigoPostalFamiliares,
                              borrarAdicional: borrarAdicional,
                            ),
                          );
                        }
                    ),
                  ),

                ),





              ]
          ),
        ),
      ),
    );
  }
}