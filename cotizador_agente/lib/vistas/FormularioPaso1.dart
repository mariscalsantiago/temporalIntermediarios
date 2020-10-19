
import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
//import 'package:firebase_performance/firebase_performance.dart';
//import 'package:agentesgnp/Modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/modelos_widget/modelo_topbar.dart';
import 'package:cotizador_agente/utils/CircleButton.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FormularioPaso1 extends StatefulWidget {
  FormularioPaso1({Key key, this.scaffoldKey, this.cotizador, this.cotizacionGuardada}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  String cotizador;
  Cotizacion cotizacionGuardada;
  bool estaCargando = true;
  List<Seccion> seccionesPaso1;
  bool deboMostrarAlertaPrecarga = true;
  bool deboReemplazarGuardada = false;


  //List<Seccion> _secciones = [];//Cotización guardada

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


  @override
  _FormularioPaso1State createState() => _FormularioPaso1State(scaffoldKey);
}

class _FormularioPaso1State extends State<FormularioPaso1> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey;


  void actualizarCodigoPostalFamiliares() {
    setState(() {
      var titular = Utilidades.buscaCampoPorID(Utilidades.titularSeccion, Utilidades.titularCampo, false);
      if (titular.length > 0) {
        var _titular = titular[0];
        var familiares = Utilidades.buscaCampoPorID(
            Utilidades.familiarSeccion, Utilidades.familiarCampo, false);
        if (familiares != null) {
          for (var familiar in familiares) {
            if(familiar.valor == null || Utilidades.actualizarCodigoPostalAdicional){
              familiar.valor = _titular.valor;
            }
          }
          Utilidades.actualizarCodigoPostalAdicional = false;
          var _seccionesFamiliares = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.where((s) => s.id_seccion==Utilidades.familiarSeccion).toList();
          for(var _seccion in _seccionesFamiliares) {
            var _campos = _seccion.campos.where((c)=>c.id_campo==Utilidades.familiarCampo).toList();
            for(var _campo in _campos) {
              _campo.valor = _titular.valor;
            }
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
        seccion.cont_child -= 1;
        if (seccion.children_secc!=null) {
          seccion.children_secc.removeWhere((item) => item.hashCode == hashCode);
          int _c = 1;
          for(Seccion seccionChild in seccion.children_secc) {
            seccionChild.seccion = "Adicional " + _c.toString();
            _c += 1;
          }
        }
      }
      //widget._secciones = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;
    });
  }

  _FormularioPaso1State(this.scaffoldKey);

  //Se van a guardar los datos de la forma aquí createdoc[rango_edad]
  var createDoc = {};


  bool reNew = false;
  bool isLoading = true;
  PasoFormulario paso_2;
  String recargacotizador;
  String platform = "";

  refresh() {
    setState(() {});
  }

  void recargar(){
    setState(() {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      Utilidades.cotizacionesApp.eliminarDeLaComparativa(Utilidades.cotizacionesApp.getCurrentLengthLista()-1);
      widget.cotizacionGuardada = null;
      this.getData().then((success){

        if(success == false){
          setState(() {
            isLoading = true;
          });
        }else{
          isLoading = false;
        }
      });
    });

  }


  agregarAlDiccionario(String key, String value) {
    setState(() {
      //El metodo que ya funciona
    });
  }

  void _sendDataToSecondScreen(BuildContext context, Seccion seccion) {
    List <Seccion> secciones = new List<Seccion>();
    secciones.add(seccion);
    Utilidades.isloadingPlan = true;

    //print("Se va con el plan: " + seccion.campos[0].valor);
    //print("El Arreglo de planes es: " );
    seccion.campos[0].valores.forEach((v){

      // print ("id: "+ v.id + " "+ v.descripcion);
    });


    if(widget.cotizacionGuardada!=null){
      //Mandar Alerta de los datos precargados

      bool sonIguales = verifyPaso1(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones);
      if(sonIguales){ //Son iguales;


        secciones = new List<Seccion>();
        secciones.add(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormularioPaso2(
                secciones: secciones,
                cotizacionGuardada: widget.cotizacionGuardada,
                text: "test",
              ),
            ));



      }else{

        //Mostrar alerta para decidir si continuar con datos precargados o Continuar con paso 2, SIN RESTABLECER.


        Utilidades.mostrarAlertCargaDeDatos(Mensajes.titleCargaD, Mensajes.cargaDatos, context,
                (){ //NEGATIVE

              //Bloquea

              setState(() {
                isLoading = true;

              });
              Navigator.pop(context);

              widget.deboReemplazarGuardada  = true;

              this.getData().then((s){ //Volver a precargar la cotizacion


                //Desbloquea

                secciones = new List<Seccion>();
                secciones.add(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormularioPaso2(
                        secciones: secciones,
                        cotizacionGuardada: widget.cotizacionGuardada,
                        text: "test",
                        seleccionarValorDefecto: false,
                      ),
                    ));

              });


            }, (){ //POSITIVE


              //Son diferentes, paso 2 normal. SIN RESTABLECER.
              Navigator.pop(context);


              secciones = new List<Seccion>();
              secciones.add(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormularioPaso2(
                      secciones: secciones,
                      text: "test",
                      seleccionarValorDefecto: true,
                    ),
                  ));

            });

      }

    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormularioPaso2(
              secciones: secciones,
              text: "test",
              seleccionarValorDefecto: true,
            ),
          ));
    }

  }


  getData() async {

    /*final Trace data = FirebasePerformance.instance.newTrace("CotizadorUnico_GetPasoUno");
    data.start();
    print(data.name);*/
    bool success = false;


    try{

      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        setState(() {
          isLoading = true;
        });

        try{
          Map<String, String> headers = {"Accept": "application/json"};

          var response = await http.get(Uri.encodeFull("https://gmm-cotizadores-uat.gnp.com.mx/cotizador/aplicacion?idAplicacion=2343"), headers: headers);

          int statusCode = response.statusCode;

          if(response != null){
            if(response.body != null && response.body.isNotEmpty){

              if (statusCode == 200) {
                //data.stop();
                success = true;
                this.setState(() {
                  isLoading = false;

                  FormularioCotizacion formularioCotizacion = FormularioCotizacion();
                  PasoFormulario estePaso = PasoFormulario.fromJson(json.decode(response.body));
                  formularioCotizacion.paso1=estePaso;


                  if(widget.cotizacionGuardada != null){
                    if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().comparativa == null){

                      if(widget.deboReemplazarGuardada){

                        Utilidades.cotizacionesApp.listaCotizaciones.last = formularioCotizacion;

                        widget.deboReemplazarGuardada = false;

                      }else{
                        Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);

                      }

                      //Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = widget.cotizacionGuardada.idPlan;

                    }
                    else{

                      Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);

                    }


                    Map<String,dynamic> resumenSecciones = json.decode(widget.cotizacionGuardada.responseResumen);

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
                          lista_campos.forEach((esteCampo){


                            if(esteCampo["valor"] != null){
                              List<Campo> campos = Utilidades.buscaCampoPorID(id_Seccion, esteCampo["idCampo"], false);
                              if(campos != null){
                                campos[0].valor = esteCampo["valor"].toString();

                                if (campos[0].seccion_dependiente != null) {

                                  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
                                      int.parse(campos[0].seccion_dependiente),
                                      int.parse(campos[0].valor));
                                }

                              }
                            }

                          });
                        }

                      }
                    });

                    Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3].campos[0].valor;
                    //_onAfterBuild(context);



                  }else{
                    if(!Utilidades.editarEnComparativa){
                      Utilidades.cotizacionesApp.agregarCotizacion(formularioCotizacion);
                    }else{
                      Utilidades.editarEnComparativa = false;
                    }

                  }

                });
              }else if(statusCode != null){
                //data.stop();
                isLoading = false;
                Navigator.pop(context);
                String message = json.decode(response.body)['message'] != null ? json.decode(response.body)['message'] : json.decode(response.body)['errors'][0] != null ? json.decode(response.body)['errors'][0] : "Error del servidor";
                Utilidades.mostrarAlertas(Mensajes.titleError + statusCode.toString(), message, context);
              }
              // return "Success!";

            }else{
              //data.stop();
              Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
                Navigator.pop(context);
                getData();
              });
            }
          }else{
            //data.stop();
            Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
              Navigator.pop(context);
              getData();
            });
          }

        }catch(e){
          //data.stop();
          Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
            Navigator.pop(context);
            getData();
          });
        }


      }else{
        //data.stop();
        Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
          Navigator.pop(context);
          getData();
        });
      }

    }catch(e){
      //data.stop();
      Utilidades.mostrarAlertaCallBackCustom(Mensajes.titleConexion, Mensajes.errorConexion, context,"Reintentar",(){
        Navigator.pop(context);
        getData();
      });

    }

    return success;


  }


  @override
  void initState() {

    if(Utilidades.idAplicacion != null){
      widget.cotizador = Utilidades.idAplicacion.toString();
    }

    if(widget.cotizador != null){

      this.getData().then((success){ //Validar que este cotizador sea válido.

        if(success!=null){
          print("Success es: "+ success.toString());
        }else{
          print("Success es: null");

        }

        if(success){
          bool encontrePlanes = false;
          List<Seccion> s = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones;

          s.forEach((f){
            if(f.id_seccion == 6){
              encontrePlanes = true;

            }
          });

          if(!encontrePlanes){
            Navigator.pop(context);

            Utilidades.mostrarAlerta("Error", Mensajes.errorConfig, context);

          }else{

            //Este cotizador es válido
            if(widget.cotizacionGuardada!=null){
              _onAfterBuild(context);
            }

          }
        }else{
          setState(() {
            isLoading = true;
          });
        }
      });


    }else {
      isLoading = false;
      Navigator.pop(context);
    }
  }



  void _onAfterBuild(BuildContext context){

    if(widget.cotizacionGuardada != null  && (isLoading==false) & Utilidades.cargarNuevoPaso){ //Mandar a paso 2


      List <Seccion> secciones = new List<Seccion>();
      secciones.add( Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[3]);

      backPaso1(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones);

      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = widget.cotizacionGuardada.idPlan;
      Utilidades.buscaCampoPorID(Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor = widget.cotizacionGuardada.idPlan;
      Utilidades.cargarNuevoPaso  =false;

      var valor = secciones[0].campos[0].valores.firstWhere((v) => v.id == widget.cotizacionGuardada.idPlan);

      if(valor.visible == true) {


        if(widget.deboMostrarAlertaPrecarga){
          Utilidades.mostrarAlerta(Mensajes.titleCotRec, Mensajes.propRestablecida, context);
          widget.deboMostrarAlertaPrecarga = false;

        }



      }
      else {
        var titulo = "Aviso";
        var mensaje = Mensajes.recuperarPlan;
        showDialog(
            context: context,
            builder: (context2) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(titulo),
                content: new Text(mensaje),
                actions: <Widget>[
                  FlatButton(
                    child: new Text(
                      "Aceptar",
                      style: TextStyle(color: AppColors.color_primario),
                    ),
                    onPressed: () {
                      Navigator.pop(context2);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }

    }

  }

  void backPaso1(List<Seccion> secciones) {
    widget.seccionesPaso1 = backPaso1Child(secciones);
  }

  List<Seccion> backPaso1Child(List<Seccion> secciones) {
    List<Seccion> _secciones = List<Seccion>();
    for(Seccion seccion in secciones) {
      List<Campo> _campos = List<Campo>();
      for(var campo in seccion.campos)
      {
        Campo _campo = Campo(id_campo: campo.id_campo, valor: campo.valor, id_seccion: campo.id_seccion);
        _campos.add(_campo);
      }
      Seccion _seccion = Seccion(id_seccion: seccion.id_seccion, seccion: seccion.seccion, multiplicador: seccion.multiplicador, campos: _campos );

      if(seccion.multiplicador>0) {
        _seccion.children_secc = backPaso1Child(seccion.children_secc);
      }

      _secciones.add(_seccion);
    }
    return _secciones;
  }

  bool verifyPaso1(List<Seccion> secciones) {
    return verifyPaso1Child(secciones, widget.seccionesPaso1, true);
  }

  bool verifyPaso1Child(List<Seccion> secciones, List<Seccion> seccionesBack, bool byIdSeccion) {
    bool verify = true;

    if(secciones == null || seccionesBack == null) {
      return false;
    }

    if(secciones.length == seccionesBack.length) {
      for(Seccion seccion in secciones) {
        var _seccion = byIdSeccion ? seccionesBack.singleWhere((s) => s.id_seccion == seccion.id_seccion) : seccionesBack.singleWhere((s) => s.seccion == seccion.seccion);
        if(seccion.multiplicador>0) {
          bool result = verifyPaso1Child(seccion.children_secc, _seccion.children_secc, false);
          if(!result) {
            return false;
          }
        }
        else {
          if(_seccion != null) {
            for(Campo campo in seccion.campos) {
              var _campo = _seccion.campos.singleWhere((c) => (c.id_seccion == campo.id_seccion) && (c.id_campo == campo.id_campo));
              if(campo != null) {
                verify = (campo.valor == _campo.valor);
                if(!verify) {
                  return false;
                }
              }
              else {
                verify = false;
              }
            }
          }
          else {
            verify = false;
          }
        }
      }
    }
    else {
      return false;
    }

    return verify;
  }



  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));


    return GestureDetector(
      /*onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },*/
      child: WillPopScope(
        onWillPop: () async {

          if(Utilidades.cotizacionesApp.getCurrentLengthLista()>1){
            //print("Estoy eliminando la index: "+ (Utilidades.cotizacionesApp.getCurrentLengthLista()-1).toString());
            Utilidades.cotizacionesApp.eliminarDeLaComparativa(Utilidades.cotizacionesApp.getCurrentLengthLista()-1);

          }else{
           // Navigator.of(context).popUntil(ModalRoute.withName('/cotizadorUnicoAP'));
            Navigator.pop(context);
          }

          return true;
        },
        child: new Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.color_primario),
            backgroundColor: Colors.white,
            title: Text("Cotizador Accidentes Personales", style: TextStyle(color: Colors.black),),

          ),

          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Visibility(
                  visible: !isLoading,
                  child: TopBar(recargarFormulario: recargar),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Divider( //002e71
                            thickness: 2,
                            color: AppColors.color_titulo,

                            height: 0,
                          )),
                    ),
                  ],
                ),
                /****** Termina panel superior *******/


                /****** Comienza panel de coti *******/

                Expanded(
                  child: Form(
                    key: formKey,
                    child: (isLoading || (Utilidades.cotizacionesApp.getCurrentFormularioCotizacion() == null)) ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(AppColors.color_primario),),):
                    new ListView.builder(
                        itemCount: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length+1,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int index) {


                          //Botón de continuar al último
                          if(index == Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length){
                            return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  FlatButton(
                                    color: AppColors.color_primario,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                    padding: EdgeInsets.all(8.0),
                                    onPressed: () {
                                      final bool v = formKey.currentState.validate();



                                      formKey.currentState.save();


                                      bool formularioValido = true;
                                      setState(() {

                                        List<Campo> campos =  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().obtenerSeccionesSimplificadas();


                                        for(int i=0; (i < campos.length) && formularioValido; i++){

                                          if(campos[i].isValid == false){
                                            formularioValido = false;
                                          }
                                        }

                                      });


                                      if (formularioValido) {
                                        _sendDataToSecondScreen(context, paso_2.secciones[0] );

                                        if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON() != null){
                                          print(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON());
                                        }else{
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        print("invalid");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "CONTINUAR",
                                        style: TextStyle(fontSize: 15.0, letterSpacing: 1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );

                          }



                          //Para el primero
                          if(index==0){
                            return Column(
                              children: <Widget>[

                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(top: 32, left: 16, bottom: 24),
                                  child: Text(
                                    Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].seccion,
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
                                        child: Text("Datos Personales", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_primario, fontWeight: FontWeight.w500, fontSize: 15),),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Planes", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w500, fontSize: 15),),
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
                                                  CircleButton(backgroundColor: AppColors.color_primario ,onTap: () => print("Cool")),
                                                  Expanded(
                                                    child: Container(
                                                        child: Divider( //002e71
                                                          thickness: 2,
                                                          color: Colors.grey,
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
                                                          color: Colors.grey,

                                                          height: 0,
                                                        )),
                                                  ),
                                                  CircleButton(backgroundColor: Colors.grey ,onTap: () => print("Cool")),

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
                                        child: Text("Paso 1", textAlign: TextAlign.center, style: TextStyle(color: AppColors.color_primario, fontWeight: FontWeight.w500, fontSize: 15),),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Paso 2", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ))
                                    ],
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new SeccionDinamica( agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index], i:index, end:Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length-1, cantidad_asegurados: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.cantidad_asegurados, formKey: formKey,
                                    actualizarCodigoPostalFamiliares:
                                    actualizarCodigoPostalFamiliares,
                                    validarCodigoPostalFamiliares:
                                    widget.validarCodigoPostalFamiliares,
                                    borrarAdicional: borrarAdicional,
                                  ),
                                )


                              ],
                            );

                          }




                          if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].id_seccion == 6){ // El ID 6 siempre va a ponerse en el paso 2

                            List <Seccion> secciones = new List ();
                            secciones.add(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index]);
                            paso_2 = new PasoFormulario(secciones:secciones );
                            // print("Para la sección dos:" + Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index].seccion.toString());
                            return Container();
                          }



                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: new SeccionDinamica(agregarDicc:agregarAlDiccionario, notifyParent:refresh,secc: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones[index], i:index, end:Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.secciones.length-1, cantidad_asegurados: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.cantidad_asegurados, formKey: formKey,
                              actualizarCodigoPostalFamiliares:
                              actualizarCodigoPostalFamiliares,
                              validarCodigoPostalFamiliares:
                              widget.validarCodigoPostalFamiliares,
                              borrarAdicional: borrarAdicional,
                            ),
                          );
                        }

                    ),
                  ),

                ),
              ]),
        ),
      ),
    );
  }
}
