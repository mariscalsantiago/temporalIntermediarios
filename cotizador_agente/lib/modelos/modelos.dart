import 'dart:collection';
import 'dart:convert';

import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';

class CotizacionesApp {
  List<FormularioCotizacion> listaCotizaciones = List<FormularioCotizacion>();
  Queue<FormularioCotizacion> listaCotizacionesEliminadas = Queue<FormularioCotizacion>();
  bool elimineUnaCotizacion = false;
  bool vengoDePrecargada = false;

  bool agregarCotizacion(FormularioCotizacion formularioCotizacion) {

    //Invalidar folios de Formato Comparativa

    if (listaCotizaciones.length <= 3) {
      listaCotizaciones.add(formularioCotizacion);
      return true;
    }
    return false;
  }

  getCurrentFormularioCotizacion() {

    if(listaCotizaciones.length >0){
      return listaCotizaciones.last;
    }

    return null;

  }

  getCotizacionElement(int i) {
    return listaCotizaciones[i];
  }

  int getCurrentLengthLista() {
    return listaCotizaciones.length;
  }

  eliminarDeLaComparativa(int i) {
    //Invalidar folios de Formato Comparativa
    listaCotizaciones.removeAt(i);
  }

  limpiarComparativa() {
    listaCotizaciones.clear();
  }

  int getCotizacionesCompletas(){

    int cont = 0;

    listaCotizaciones.forEach((c){
      if(c.comparativa!=null){
        cont++;
      }
    });

    return cont;
  }
}

class FormularioCotizacion {
  PasoFormulario paso1;
  PasoFormulario paso2;
  Comparativa comparativa;
  String idPlan;
  Map<String, dynamic> responseCotizacion;
  String requestCotizacion;

  bool esValido = false;

  FormularioCotizacion({this.paso1, this.paso2});




  Regla calcularReglas(){

    /*for (int i = 0; i<paso1.secciones.length; i++){
      if(paso1.secciones[i].reglasNegocio!=null){
        if(paso1.secciones[i].reglasNegocio.length>0){
          for (int j=0; j<paso1.secciones[i].reglasNegocio.length; j++){
            for(int k=0; k<paso1.secciones[i].reglasNegocio[j].operaciones.length; k++){
              if(paso1.secciones[i].reglasNegocio[j].operaciones[k].calcularOperacion()){
                return paso1.secciones[i].reglasNegocio[j];

              }
            }
          }
        }
      }
    }
*/

    List<Regla> reglas = new List<Regla>();

    print("incia calculación de reglas******");

    for (int i = 0; i<paso2.secciones.length; i++){
      if(paso2.secciones[i].reglasNegocio!=null){
        if(paso2.secciones[i].reglasNegocio.length>0){
          for (int j=0; j<paso2.secciones[i].reglasNegocio.length; j++){
            for(int k=0; k<paso2.secciones[i].reglasNegocio[j].operaciones.length; k++){

              print("Calculando regla: "+ paso2.secciones[i].reglasNegocio[j].mensaje);
              bool resultadoRegla=paso2.secciones[i].reglasNegocio[j].operaciones[k].calcularOperacion();
              if(resultadoRegla==true){
                if(paso2.secciones[i].reglasNegocio[j].tipoRegla == Utilidades.REGLA_STOPPER){
                  return paso2.secciones[i].reglasNegocio[j];
                }
                reglas.add(paso2.secciones[i].reglasNegocio[j]);

              }
            }
          }
        }
      }
    }

    if(reglas.length > 0){

      String mensaje = "";
      reglas.forEach((r){

        mensaje += r.mensaje + "\n";

      });
      Regla reglaAcumulada = Regla(tipoRegla: Utilidades.REGLA_INFO, mensaje: mensaje);
      return reglaAcumulada;
    }



  }


  setPaso1(PasoFormulario paso) {
    paso1 = paso;
  }

  setPaso2(PasoFormulario paso) {
    this.paso2 = paso;
  }

  PasoFormulario getPaso1() {
    return this.paso1;
  }

  PasoFormulario getPaso2() {
    return this.paso2;
  }

  setresponseCotizacion(Map<String, dynamic> response) {
    this.responseCotizacion = response;
  }

  setrequestCotizacion(String response) {
    this.requestCotizacion = response;
  }

  filtrarSeccion(int idSeccion, int filtro) {
    this.paso1.filtrarSeccion(idSeccion, filtro);
    if (this.paso2 != null) {
      this.paso2.filtrarSeccion(idSeccion, filtro);
    }
  }

  Map<String, dynamic> getJSONComparativa() {
    Map<String, dynamic> map = paso2.toJSON();
    map["cotizacionGMMRequest"].addAll(paso1.toJSON()["cotizacionGMMRequest"]);

    //La cotizacion debe saber con qué plan se cotiza
    map["cotizacionGMMRequest"]["idPlan"] = Utilidades.buscaCampoPorID(Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor;

    List<int> planesPRevios = List<int>();

    int total =  Utilidades.cotizacionesApp.getCurrentLengthLista();

    for(int i=0; i<total-1; i++){
      if(Utilidades.cotizacionesApp.getCotizacionElement(i).comparativa!=null){
        planesPRevios.add(int.parse(Utilidades.buscaCampoPorFormularioID(i,Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor));
      }
    }

    map["cotizacionGMMRequest"]["planesPrevios"] = planesPRevios;
    print("PLANES PREVIOS: " + planesPRevios.toString());

    //TODO: Hardcode id titular, siempre el uno
    map["cotizacionGMMRequest"]["titular"]["id"] = 1;

    //TODO: HARCODED Para sólo un usuario, revisar para múltiples asegurados
    map["cotizacionGMMRequest"]["descuentos"][0]["idPersona"] = 1;

    //map["cotizacionGMMRequest"].remove("contratante");

    //map["cotizacionGMMRequest"]["contratante"]["cpContratante"] = "09880";
    //map["cotizacionGMMRequest"]["contratante"]["id"] = "1";

    //TODO:Se eliminaba el contratante por que el codigo postal no se estaba enviando.

    print("JSON COMPARATIVA: " + map.toString());

    return map;
  }

  List<Map<String, dynamic>> obtenerListaCampos(List<Map<String, dynamic>> acumCampos, List<Campo> campos) {
    for (int i = 0; i < campos.length; i++) {
      Campo c = campos[i];
      if (c.valores != null) {
        if (c.valores.length > 0) {

          Map<String, dynamic> campo = {
            //Tiene valores, puede que tenga hijos o no, pero se agrega el campo
            "etiqueta": c.nombre_campo,
            "valor": c.getValorFormatted(),
            "idCampo": c.id_campo,
          };
          acumCampos.add(campo);

          for (int j = 0; j < c.valores.length; j++) {
            Valor valor = c.valores[j];
            if (valor.children != null) {
              if (valor.children.length > 0) {
                //Tiene hijos, evaluar los hijos y agregar al acumulador

                if (valor.id == c.valor) {
                  List<Map<String, dynamic>> campos_hijos =
                  List<Map<String, dynamic>>();


                  acumCampos
                      .addAll(obtenerListaCampos(campos_hijos, valor.children));
                } else {
                  if ((c.tipo_dato == "boolean" || c.tipo_componente == "toggle" || c.tipo_componente == "date_relativa") && (c.valor == "true" || c.tipo_componente == "date_relativa")) {
                    List<Map<String, dynamic>> campos_hijos =
                    List<Map<String, dynamic>>();


                    if(c.tipo_componente == "date_relativa"){
                      List <Campo> hijosFiltrados = List <Campo> ();

                      valor.children.forEach((c){

                        if(c.visible){
                          hijosFiltrados.add(c);

                        }

                      });

                      if(hijosFiltrados.length>0){
                        acumCampos.addAll(
                            obtenerListaCampos(campos_hijos, hijosFiltrados));

                      }
                    }else{
                      acumCampos.addAll(
                          obtenerListaCampos(campos_hijos, valor.children));
                    }


                  }
                }
              }
            }
          }


        }
      } else {
        //Es un campo sin valores, se agrega a la lista
        Map<String, dynamic> campo = {
          "etiqueta": c.nombre_campo,
          "valor": c.getValorFormatted(),
          "idCampo": c.id_campo,
        };
        acumCampos.add(campo);
      }
    }

    //Terminé de evaluar la lista de campos (hijos o de raíz)
    return acumCampos;
  }


  List<Campo> obtenerCamposSimplificados(List<Campo> acumCampos, List<Campo> campos) {

    for (int i = 0; i < campos.length; i++) {
      Campo c = campos[i];
      if (c.valores != null) {
        if (c.valores.length > 0) {
          for (int j = 0; j < c.valores.length; j++) {
            Valor valor = c.valores[j];
            if (valor.children != null) {
              if (valor.children.length > 0) {
                //Tiene hijos, evaluar los hijos y agregar al acumulador

                if (valor.id == c.valor) {
                  List<Campo> campos_hijos = List<Campo>();

                  acumCampos.addAll(obtenerCamposSimplificados(campos_hijos, valor.children));

                } else {
                  if ((c.tipo_dato == "boolean" ||
                      c.tipo_componente == "toggle" || c.tipo_componente == "date_relativa") &&
                      c.valor == "true") {
                    List<Campo> campos_hijos = List<Campo>();

                    acumCampos.addAll(obtenerCamposSimplificados(campos_hijos, valor.children));
                  }
                }
              }
            }
          }

          acumCampos.add(c);
        }
      } else {
        //Es un campo sin valores, se agrega a la lista
        acumCampos.add(c);
      }
    }

    //Terminé de evaluar la lista de campos (hijos o de raíz)
    return acumCampos;
  }



  List<Campo> obtenerSeccionesSimplificadas(){


    List<Campo> secciones = List<Campo>();
    paso1.secciones.forEach((s) {
      if (s.multiplicador > 0) {
        List<Campo> lista_asegurqados =
        List<Campo>();

        for (int i = 0; i < s.children_secc.length; i++) {
          Seccion s_child = s.children_secc[i];
          List<Campo> campos = List<Campo>();

          campos = obtenerCamposSimplificados(campos, s_child.campos);

          lista_asegurqados.addAll(campos);
        }


        secciones.addAll(lista_asegurqados);
      } else {
        List<Campo> campos = List<Campo>();
        campos = obtenerCamposSimplificados(campos, s.campos);


        secciones.addAll(campos);
      }
    });



    return secciones;
  }





  //Repsonse Resumen
  Map<String, dynamic> generarResponseResumen() {
    //todos los datos del formulario (Paso1 y paso 2)

    List<Map<String, dynamic>> secciones = List<Map<String, dynamic>>();
    paso1.secciones.forEach((s) {
      if (s.multiplicador > 0) {
        List<Map<String, dynamic>> lista_asegurqados =
        List<Map<String, dynamic>>();

        for (int i = 0; i < s.children_secc.length; i++) {
          Seccion s_child = s.children_secc[i];
          List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();

          campos = obtenerListaCampos(campos, s_child.campos);

          Map<String, dynamic> seccion_child_json = {
            "idPersona": s_child.id_valor != null ? s_child.id_valor : i + 2,
            "valores": campos,
            "idSeccion": s.id_seccion
          };

          lista_asegurqados.add(seccion_child_json);
        }

        Map<String, dynamic> seccion = {
          "nombre": s.nombreRequestCotizacion,
          "valores": lista_asegurqados,
          "idSeccion": s.id_seccion
        };

        secciones.add(seccion);
      } else {
        List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();
        campos = obtenerListaCampos(campos, s.campos);

        Map<String, dynamic> seccion;
        if (s.nombreRequestCotizacion == "titular") {
          seccion = {
            "nombre": s.nombreRequestCotizacion,
            "valores": campos,
            "idPersona": "1",
            "idSeccion": s.id_seccion
          };
        } else {
          seccion = {
            "nombre": s.nombreRequestCotizacion,
            "valores": campos,
            "idSeccion": s.id_seccion
          };
        }

        secciones.add(seccion);
      }
    });

    paso2.secciones.forEach((s) {
      if (s.multiplicador > 0) {
        List<Map<String, dynamic>> lista_asegurqados =
        List<Map<String, dynamic>>();

        for (int i = 0; i < s.children_secc.length; i++) {
          Seccion s_child = s.children_secc[i];
          List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();

          campos = obtenerListaCampos(campos, s_child.campos);

          Map<String, dynamic> seccion_child_json = {
            "idPersona": s_child.id_valor != null ? s_child.id_valor : i + 2,
            "valores": campos,
            "idSeccion": s.id_seccion
          };

          lista_asegurqados.add(seccion_child_json);
        }

        Map<String, dynamic> seccion = {
          "nombre": s.nombreRequestCotizacion,
          "valores": lista_asegurqados,
          "idSeccion": s.id_seccion
        };

        secciones.add(seccion);
      } else {
        List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();
        campos = obtenerListaCampos(campos, s.campos);

        Map<String, dynamic> seccion = {
          "nombre": s.nombreRequestCotizacion,
          "valores": campos,
          "idSeccion": s.id_seccion
        };

        secciones.add(seccion);
      }
    });

    Map<String, dynamic> responseResumen = {
      "idParticipante": "datosUsuario.idparticipante.toString()",
      "nombreParticipante": "datosUsuario.givenname",
      "parametroCotizador": Utilidades.idAplicacion,
      "seccion": secciones,
    };

    print("NUEVO RESPONSE RESUMEN" + json.encode(responseResumen));

    return responseResumen;
  }
}

class PasoFormulario {
  final int id_aplicacion;
  final List<Seccion> secciones;
  final String nombre;
  final String descripcion;
  final int cantidad_asegurados;
  final String estatus;
  final Estilos estilos;
  final String raizRequestCotizacion;
  final List<PropiedadConfiguracionRequest> camposRequestCotizacion;
  final List<Documento> documentos;
  final List<Documento> documentos_configuracion;

  PasoFormulario(
      {this.id_aplicacion,
        this.secciones,
        this.nombre,
        this.descripcion,
        this.cantidad_asegurados,
        this.estatus,
        this.estilos,
        this.raizRequestCotizacion,
        this.camposRequestCotizacion,
        this.documentos,
        this.documentos_configuracion});



  String obtenerValorPrecargada (int idSeccion, int idCampo){

  }

  bool validarFormulario() {
    for (int i = 0; i < secciones.length; i++) {
      Seccion s = secciones[i];

      if (s.multiplicador > 0) {
        print("valido la seccion " + s.seccion);

        for (int k = 0; k < s.children_secc.length; k++) {
          Seccion seccion = s.children_secc[k];

          for (int j = 0; j < seccion.campos.length; j++) {
            if (!seccion.campos[j].isValid) {
              return false;
            }
          }
        }
      } else {
        print("valido la seccion no mult " + s.seccion);

        for (int j = 0; j < s.campos.length; j++) {
          //print("valido el campo" + s.campos[j].etiqueta + " con valor "+ s.campos[j].valor);

          if (!s.campos[j].isValid) {
            print("Este campo no es valida " + s.campos[j].etiqueta + s.campos[j].valor);
            return false;
          }
        }
      }
    }

    return true;
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> secciones_json = {
      "idAplicacion": id_aplicacion,
    };

    Map<String, dynamic> raiz = {
      raizRequestCotizacion: secciones_json,
    };

    camposRequestCotizacion.forEach((seccion) {
      //Buscar las secciones requeridas
      int secc_id = seccion.seccion;

      secciones.forEach((s) {
        if (s.id_seccion == secc_id) {
          Map<String, dynamic> campos = Map<String, dynamic>();

          Map<String, dynamic> seccion_json = {
            s.nombreRequestCotizacion: campos
          };

          print("build json of seccion " +
              s.seccion +
              " con multiplicador" +
              s.multiplicador.toString());

          if (s.multiplicador > 0) {
            //Lista de hijos

            List<Map<String, dynamic>> lista_hijos =
            List<Map<String, dynamic>>();

            int i = 2;

            s.children_secc.forEach((children_secc) {
              Map<String, dynamic> hijo = Map<String, dynamic>();
              children_secc.campos.forEach((c) {
                seccion.campo.forEach((id) {
                  if (c.id_campo == id) {
                    hijo.addAll(c.toJson());
                  }
                });
              });

              if (children_secc.id_valor != null) {
                hijo["idPersona"] = int.parse(children_secc.id_valor);
              } else {
                hijo["id"] = i;
                i++;
              }

              lista_hijos.add(hijo);
            });

            seccion_json[s.nombreRequestCotizacion] = lista_hijos;
          } else {
            seccion.campo.forEach((id) {
              Campo resultado = buscarCampoPorID(s.campos, id, false);

              if (resultado != null ) {
                if(resultado.visibleLocal){
                  campos.addAll(resultado.toJson());
                }
                print("======== Se encontró el campo" +
                    id.toString() +
                    "de la seccion: " +
                    secc_id.toString());
              } else {
                print(
                    "*********************************************************");
                print("* No se encontró el campo: " +
                    id.toString() +
                    "de la seccion: " +
                    secc_id.toString());
                print(
                    "*********************************************************");
              }
            });
          }

          secciones_json.addAll(seccion_json);
        }
      });
    });
    return raiz;
  }

  Campo buscarCampoPorID(List<Campo> campos, int id, bool busquedaProfunda) {

    for (int i = 0; i < campos.length; i++) {
      Campo current_campo = campos[i];

      if (current_campo.id_campo == id) {
        return current_campo;
      } else {
        if (current_campo.valores != null) {
          if (current_campo.valores.length > 0) {
            for (int j = 0; j < current_campo.valores.length; j++) {
              Valor current_valor = current_campo.valores[j];

              if (current_valor.children != null) {
                if (current_valor.children.length > 0) {
                  if ((current_valor.id == current_campo.valor) || busquedaProfunda) {
                    Campo buscar = buscarCampoPorID(current_valor.children, id, busquedaProfunda);
                    if (buscar != null) {
                      return buscar;
                    }
                  } else {
                    if (((current_campo.tipo_dato == "boolean" ||
                        current_campo.tipo_componente == "toggle" ||
                        current_campo.tipo_componente == "date_relativa") &&
                        (current_campo.valor == "true") || current_campo.tipo_componente == "date_relativa" )|| busquedaProfunda) {
                      print("Busqueda profunda: "+ busquedaProfunda.toString());

                      Campo buscar =
                      buscarCampoPorID(current_valor.children, id, busquedaProfunda);
                      if (buscar != null && buscar.visible) {
                        return buscar;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  filtrarSeccion(int idSeccion, int filtro) {
    print("llego al filtrar del form");

    secciones.forEach((secc) {
      print("busco en la seccion " + secc.id_seccion.toString());
      if (secc.id_seccion.toString() == idSeccion.toString()) {
        print("encotnré la seccion");

        secc.filtrarSeccion(filtro);
      }
    });
  }

  factory PasoFormulario.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['secciones'] != null
        ? parsedJson['secciones'] as List
        : parsedJson['seccionesPlan'] as List;
    List<Seccion> secc = list.map((i) => Seccion.fromJson(i)).toList();

    var list_raw_configs = parsedJson["camposRequestCotizacion"] as List;
    List<PropiedadConfiguracionRequest> configs = list_raw_configs
        .map((i) => PropiedadConfiguracionRequest.fromJson(i))
        .toList();

    var list_raw_docs = parsedJson["documentos"] != null
        ? parsedJson["documentos"] as List
        : List();
    List<Documento> docs;
    if (list.length > 0) {
      docs = list_raw_docs.map((i) => Documento.fromJson(i)).toList();
    } else {
      docs = List<Documento>();
    }

    var list_raw_docs_conf = parsedJson["documentos_configuracion"] != null
        ? parsedJson["documentos_configuracion"] as List
        : List();
    List<Documento> docs_conf;
    if (list.length > 0) {
      docs_conf = list_raw_docs_conf.map((i) => Documento.fromJson(i)).toList();
    } else {
      docs_conf = List<Documento>();
    }

    Estilos es;
    try {
      es = Estilos.fromJson(parsedJson["estilos"]);
    } on NoSuchMethodError {
      es = null;
    }

    return PasoFormulario(
      id_aplicacion: parsedJson["id_aplicacion"],
      nombre: parsedJson["nombre"],
      descripcion: parsedJson["descripcion"],
      cantidad_asegurados: parsedJson["cantidad_asegurados"],
      estatus: parsedJson["estatus"],
      estilos: es,
      secciones: secc,
      raizRequestCotizacion: parsedJson["raizRequestCotizacion"],
      camposRequestCotizacion: configs,
      documentos: docs != null ? docs : new List<Documento>(),
      documentos_configuracion: docs_conf != null ? docs_conf : new List<Documento>(),

    );
  }
}

class PropiedadConfiguracionRequest {
  final int seccion;
  final List<int> campo;

  PropiedadConfiguracionRequest({this.seccion, this.campo});

  factory PropiedadConfiguracionRequest.fromJson(
      Map<String, dynamic> parsedJson) {
    var camposDelJSON = parsedJson['campo'];
    List<int> campos = new List<int>.from(camposDelJSON);

    return PropiedadConfiguracionRequest(
        seccion: parsedJson["seccion"], campo: campos);
  }
}

class Estilos {
  final String colorPrimario;
  final String colorSecundario;
  final String colorSombra;
  final String colorTitulo;
  final String colorTexto;
  final String bannerUrl;

  Estilos(
      {this.colorPrimario,
        this.colorSecundario,
        this.colorSombra,
        this.colorTitulo,
        this.colorTexto,
        this.bannerUrl});

  factory Estilos.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson["colorPrimario"] != null) {
      Utilidades.setColorPrimario(parsedJson["colorPrimario"]);
    } else {
      Utilidades.resetEstilos();
    }

    if (parsedJson["colorSecundario"] != null) {
      Utilidades.setColorSecundario(parsedJson["colorSecundario"]);
    } else {
      Utilidades.resetEstilos();
    }

    if (parsedJson["colorTitulo"] != null) {
      Utilidades.setColorTitulo(parsedJson["colorTitulo"]);
    } else {
      Utilidades.resetEstilos();
    }

    return Estilos(
      colorPrimario: parsedJson["colorPrimario"],
      colorSecundario: parsedJson["colorSecundario"],
      colorSombra: parsedJson["colorSombra"],
      colorTitulo: parsedJson["colorTitulo"],
      colorTexto: parsedJson["colorTexto"],
      bannerUrl: parsedJson["bannerUrl"],
    );
  }
}

class Regla {
  final int idRegla;
  final int tipoRegla;
  final int seccion;
  final String mensaje;
  final List <OperacionRegla> operaciones; // definicionRegla


  Regla({
    this.idRegla,
    this.tipoRegla,
    this.seccion,
    this.mensaje,
    this.operaciones
  });


  factory Regla.fromJson(Map<String, dynamic> parsedJson) {

    List<OperacionRegla> operaciones_json;
    if (parsedJson["definicionRegla"] != null) {
      var list = parsedJson["definicionRegla"] as List;
      operaciones_json = list.map((i) => OperacionRegla.fromJson(i)).toList();
    }

    return Regla(
      idRegla: parsedJson["idRegla"],
      tipoRegla: parsedJson["tipoRegla"],
      mensaje: parsedJson["mensaje"],
      //seccion: parsedJson["seccion"]=!null?parsedJson["seccion"]: null,
      operaciones: operaciones_json,
    );
  }

}




class OperacionRegla {

  final List <Operando> operandos;
  final String operacion;

  OperacionRegla({this.operandos, this.operacion});


  //Calcular operacion se calcula la unidad

  bool calcularOperacion(){

    switch(operacion){
    //Operaciones binarias (dos operandos, dos valores)
      case">=":

        dynamic valor_1 = operandos[0].getValor();
        dynamic valor_2 = operandos[1].getValor();

        if(valor_1==null || valor_2 == null){
          return false;
        }


        if(valor_1 is List<dynamic>){
          print("es lista");
          if(valor_1.length>1){
            for (int i =0 ; i<valor_1.length; i++){
              if(valor_1[i]>=valor_2){ //Si alguno de los adicionales incumple, se dispara la regla
                print ("Se cumple que");
                print(valor_1[i].toString() + ">=" + valor_2.toString()+": "+ (valor_1[i] >= valor_2).toString());
                return true;
              }
            }

            return false; // para todos los hijos se cumple la regla

          }else{
            print(valor_1[0].toString() + ">=" + valor_2.toString()+": "+ (valor_1[0] >= valor_2).toString());

            return valor_1[0] >= valor_2;
          }
        }

        bool res=  valor_1 >= valor_2;
        print(valor_1.toString() + ">=" + valor_2.toString()+": "+ res.toString());


        return res;
        break;

      case "<=":
        dynamic valor_1 = operandos[0].getValor();
        dynamic valor_2 = operandos[1].getValor();

        if(valor_1==null || valor_2 == null){
          return false;
        }


        if(valor_1 is List<dynamic>){
          print("es lista");
          if(valor_1.length>1){
            for (int i =0 ; i<valor_1.length; i++){
              if(valor_1[i]<=valor_2){ //Si alguno de los adicionales incumple, se dispara la regla
                print ("Se cumple que");
                print(valor_1[i].toString() + "<=" + valor_2.toString()+": "+ (valor_1[i] <= valor_2).toString());
                return true;
              }
            }

            return false; // para todos los hijos se cumple la regla

          }else{
            print(valor_1[0].toString() + "<=" + valor_2.toString()+": "+ (valor_1[0] <= valor_2).toString());

            return valor_1[0] <= valor_2;
          }
        }

        bool res=  valor_1 <= valor_2;
        print(valor_1.toString() + "<=" + valor_2.toString()+": "+ res.toString());


        return res;
        break;

      case">":
        dynamic valor_1 = operandos[0].getValor();
        dynamic valor_2 = operandos[1].getValor();

        if(valor_1==null || valor_2 == null){
          return false;
        }


        if(valor_1 is List<dynamic>){
          print("es lista");
          if(valor_1.length>1){
            for (int i =0 ; i<valor_1.length; i++){
              if(valor_1[i]>valor_2){ //Si alguno de los adicionales incumple, se dispara la regla
                print ("Se cumple que");
                print(valor_1[i].toString() + ">" + valor_2.toString()+": "+ (valor_1[i] > valor_2).toString());
                return true;
              }
            }

            return false; // para todos los hijos se cumple la regla

          }else{
            print(valor_1[0].toString() + ">" + valor_2.toString()+": "+ (valor_1[0] > valor_2).toString());

            return valor_1[0] > valor_2;
          }
        }

        bool res=  valor_1 > valor_2;
        print(valor_1.toString() + ">" + valor_2.toString()+": "+ res.toString());


        return res;
        break;

      case "<":
        dynamic valor_1 = operandos[0].getValor();
        dynamic valor_2 = operandos[1].getValor();

        if(valor_1==null || valor_2 == null){
          return false;
        }


        if(valor_1 is List<dynamic>){
          print("es lista");
          if(valor_1.length>1){
            for (int i =0 ; i<valor_1.length; i++){
              if(valor_1[i]<valor_2){ //Si alguno de los adicionales incumple, se dispara la regla
                print ("Se cumple que");
                print(valor_1[i].toString() + "<" + valor_2.toString()+": "+ (valor_1[i] < valor_2).toString());
                return true;
              }
            }

            return false; // para todos los hijos se cumple la regla

          }else{
            print(valor_1[0].toString() + "<" + valor_2.toString()+": "+ (valor_1[0] < valor_2).toString());

            return valor_1[0] < valor_2;
          }
        }

        bool res=  valor_1 < valor_2;
        print(valor_1.toString() + "<" + valor_2.toString()+": "+ res.toString());


        return res;
        break;

    //Operaciones con múltiples operandos (Sólo booleanos)

      case "==":

        dynamic valor_1 = operandos[0].getValor();
        dynamic valor_2 = operandos[1].getValor();

        if(valor_1==null || valor_2 == null){
          return false;
        }


        if(valor_1 is List<dynamic>){
          print("es lista");
          if(valor_1.length>1){
            for (int i =0 ; i<valor_1.length; i++){
              if(valor_1[i]==valor_2){ //Si alguno de los adicionales incumple, se dispara la regla
                print ("Se cumple que");
                print(valor_1[i].toString() + "==" + valor_2.toString()+": "+ (valor_1[i] == valor_2).toString());
                return true;
              }
            }

            return false; // para todos los hijos se cumple la regla

          }else{
            print(valor_1[0].toString() + "==" + valor_2.toString()+": "+ (valor_1[0] == valor_2).toString());

            return valor_1[0] == valor_2;
          }
        }

        bool res=  valor_1 == valor_2;
        print(valor_1.toString() + "==" + valor_2.toString()+": "+ res.toString());


        return res;
        break;

      case "&&":

        if(operandos.length>1){
          print("*Inicia operación &&");

          dynamic valor_1 = operandos[0].getValor();
          dynamic valor_2 = operandos[1].getValor();

          print("Inicial: "+valor_1.toString()+" && "+ valor_2.toString());
          bool acum = valor_1 && valor_2;

          if(operandos.length>2){
            for(int i =2; i<operandos.length; i++){
              dynamic valor_n = operandos[i].getValor();
              print(" && "+ valor_n.toString());
              acum = acum && valor_n;
            }
            return acum;

          }else{
            return acum;
          }
        }else{
          return operandos[0].getValor();
        }

        break;


      case "||":

        if(operandos.length>1){

          bool acum = operandos[0].getValor() || operandos[1].getValor();

          if(operandos.length>2){

          }else{
            return acum;
          }

          for(int i =2; i<operandos.length; i++){
            acum = acum || operandos[i].getValor();
          }
          return acum;

        }else{
          return operandos[0].getValor();
        }


        break;

    }


  }


  factory OperacionRegla.fromJson(Map<String, dynamic> parsedJson) {

    List <Operando> operandos_json = List <Operando>();

    //Verificar cuantos operandos tiene esta operación
    bool hayMasOperandos = true;
    int contOperandos = 1;

    while(hayMasOperandos){ //no sabemos cuantos operandos tiene
      try{//intentamos revisar la llave porque no sabemos si aún tiene más operandos

        if(parsedJson["valor"+contOperandos.toString()]!=null){
          Operando nuevoOperando;
          nuevoOperando = Operando.fromJsonValor(parsedJson["valor"+contOperandos.toString()]);
          operandos_json.add(nuevoOperando);
          contOperandos ++;

        }else{
          if(contOperandos==5){
            print("El operando 5");
          }
          print("no hay operando"+ contOperandos.toString());
          hayMasOperandos = false; //ya no tiene más operandos, detener el ciclo
        }

      }catch(e){
        print(e+ "no hay operando"+ contOperandos.toString());
        hayMasOperandos = false; //ya no tiene más operandos, detener el ciclo
      }
    }


    return OperacionRegla(
        operacion: parsedJson["operacion"],
        operandos: operandos_json

    );
  }



}

class Operando{

  final dynamic operando; //un numero o string con el que se va a comparar
  final int referencia_id; // un campo que hay que buscar en el formulario
  final int referencia_seccion; // un campo que hay que buscar en el formulario
  final OperacionRegla child_operacion; //este valor es el resultado de una operación.
  final String nombreComponente;

  Operando( {this.operando, this.referencia_id, this.child_operacion, this.referencia_seccion, this.nombreComponente,});

  dynamic getValor(){

    if(child_operacion!=null){
      return child_operacion.calcularOperacion();
    }

    if(referencia_id!=null){

      Campo campo_resultado;
      PasoFormulario paso1 = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1;



      //Buscar la Sección en paso 1
      for (int i =0 ; i<paso1.secciones.length; i++){ //Repetir para paso 1 y paso 2
        if(paso1.secciones[i].id_seccion == referencia_seccion){ //Encontré la sección

          if(paso1.secciones[i].multiplicador>0){
            List <dynamic> hijos = List <dynamic>();
            for (int j = 0 ; j< paso1.secciones[i].children_secc.length; j++){
              campo_resultado = paso1.buscarCampoPorID(paso1.secciones[i].children_secc[j].campos, referencia_id, false);
              if(campo_resultado!=null){
                hijos.add(campo_resultado.getValorFormatted());//Encontré el campo
              }
            }

            if(hijos.length>0){
              return hijos;
            }

          }else{
            campo_resultado = paso1.buscarCampoPorID(paso1.secciones[i].campos, referencia_id, false);
          }

          if(campo_resultado!=null){
            return campo_resultado.getValorFormatted();//Encontré el campo
          }
        }
      }

      PasoFormulario paso2 = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2;
      //Buscar la Sección en paso 2
      for (int i =0 ; i<paso2.secciones.length; i++){ //Repetir para paso 1 y paso 2
        if(paso2.secciones[i].id_seccion == referencia_seccion){ //Encontré la sección

          if(paso2.secciones[i].multiplicador>0){
            List <dynamic> hijos = List <dynamic>();
            for (int j = 0 ; j< paso2.secciones[i].children_secc.length; j++){
              campo_resultado = paso2.buscarCampoPorID(paso2.secciones[i].children_secc[j].campos, referencia_id, false);
              if(campo_resultado!=null){
                hijos.add(campo_resultado.getValorFormatted());//Encontré el campo
              }
            }

            if(hijos.length>0){
              return hijos;
            }

          }else{
            campo_resultado = paso2.buscarCampoPorID(paso2.secciones[i].campos, referencia_id, false);
          }

          if(campo_resultado!=null){
            return campo_resultado.getValorFormatted();//Encontré el campo
          }
        }
      }
    }
    return operando;
  }


  factory Operando.fromJsonValor(dynamic parsedJson) {
    OperacionRegla child_operacion_json;

    try{
      if(parsedJson["operacion"]!=null){ //Existe una operación hijo
        child_operacion_json = OperacionRegla.fromJson(parsedJson);

        return Operando(
          child_operacion: child_operacion_json,
        );


      }


    }catch(e){
      print(e.toString() + parsedJson.toString() +"Es un valor o referencia");

    }



    try{


      if(parsedJson["id_seccion"]!=null){

        //print("Es una referencia: idComponente:" + parsedJson["idComponente"].toString() + " idComponente:" + parsedJson["id_seccion"].toString());

        return Operando(
          child_operacion: child_operacion_json,
          operando: parsedJson["idComponente"]!=null? null: parsedJson,
          referencia_id: parsedJson["idComponente"]!=null? parsedJson["idComponente"] : null,
          referencia_seccion: parsedJson["id_seccion"]!=null? parsedJson["id_seccion"] : null,
          nombreComponente: parsedJson["nombreComponente"]!=null? parsedJson["nombreComponente"] : null,

        );
      }

    }catch (e){

      print("Error: "+e.toString() + " "+parsedJson.toString()+" es un valor.");


    }



    return Operando(
      child_operacion: null,
      operando: parsedJson,
      referencia_id: null,
      referencia_seccion: null,
    );
  }





}

class Seccion {
  final int id_seccion;
  List<Campo> campos;
  String seccion;
  int multiplicador;
  List<Seccion> children_secc;
  final List<Seccion> children_secc_sin_filtro;
  bool filtrable = false;
  int id_filtrado;
  final String nombreRequestCotizacion;
  String id_valor;
  final List<Regla> reglasNegocio;

  int cont_child = 0;

  Seccion({
    this.reglasNegocio,
    this.id_seccion,
    this.campos,
    this.seccion,
    this.multiplicador,
    this.children_secc,
    this.id_filtrado,
    this.filtrable,
    this.children_secc_sin_filtro,
    this.nombreRequestCotizacion,
    this.id_valor,
  });

  bool existeUnCampoVisible() {

    if(multiplicador > 0){
      for (int j= 0 ; j< children_secc.length; j++){

        if(children_secc[j].existeUnCampoVisible()){
          return true;

        }
      }
      return false;

    }


    for (int i = 0; i < campos.length; i++) {
      Campo campo = campos[i];
      if (campo.visible) {
        return true;
      }
    }
    return false;
  }



  addChild() {
    if (this.multiplicador > 0) {
      cont_child = children_secc.length>0 ? children_secc.length + 1 : cont_child + 1 ;

      List<Campo> nuevosCampos = List<Campo>();

      this.campos.forEach((campo) {
        Campo c = new Campo(
            rangoRelativa: campo.rangoRelativa,
            regla_catalogo: campo.regla_catalogo,
            id_campo: campo.id_campo,
            etiqueta: campo.etiqueta,
            obligatorio: campo.obligatorio,
            nombre_campo: campo.nombre_campo,
            tipo_dato: campo.tipo_dato,
            tipo_componente: campo.tipo_componente,
            visible: campo.visible,
            regla: campo.regla,
            valores: campo.valores,
            rango: campo.rango,
            view_ID: campo.view_ID,
            dato_longitud: campo.dato_longitud,
            seccion_dependiente: campo.seccion_dependiente,
            nombreRequestCotizacion: campo.nombreRequestCotizacion,
            valores_sin_filtro: campo.valores_sin_filtro,
            checked: campo.checked,
            enabled: campo.enabled,
            reg_ex: campo.reg_ex,
            visibleLocal: campo.visibleLocal);

        nuevosCampos.add(c);
      });

      children_secc.add(Seccion(
          id_seccion: this.id_seccion,
          campos: nuevosCampos,
          multiplicador: 0,
          seccion: "Adicional " + (cont_child).toString()));
    }
  }

  removeLastChild() {
    if (this.multiplicador > 0) {
      cont_child--;
      children_secc.removeLast();
    }
  }

  filtrarSeccion(int v) {
    print("Estoy filtrando una seccion ");

    if (this.filtrable) {
      print("Estoy filtrando una sección, WTFno ");
      children_secc = new List<Seccion>.from(children_secc_sin_filtro);
      children_secc.removeWhere((item) => item.id_filtrado != v);
    } else {
      campos[0].filtrarValores(v);
    }
  }

  factory Seccion.fromJson(Map<String, dynamic> parsedJson) {

    List<Regla> reglas_json;
    if (parsedJson["reglasNegocio"] != null) {
      print(parsedJson["reglasNegocio"]);
      var list = parsedJson["reglasNegocio"] as List;
      reglas_json = list.map((i) => Regla.fromJson(i)).toList();
    }

    List<Seccion> secc_valores = List<Seccion>();
    bool filtro = false;

    List<Campo> campos_filtrables = List<Campo>();

    if (parsedJson['valores'] != null) {
      var lista_valores = parsedJson['valores'] as List;

      lista_valores.forEach((elemento) {
        Seccion s = Seccion(
            seccion:elemento["id_valor"] == "1"? "Titular": "Adicional " + (int.parse(elemento["id_valor"])-1).toString(),
            id_seccion: parsedJson["id_seccion"],
            id_filtrado: elemento["idFiltrado"],
            id_valor: elemento["id_valor"],
            multiplicador: 0);
        var lista_valores_campos = elemento['campos'] as List;
        print("tiene " + lista_valores_campos.length.toString() + "campos");
        s.campos = lista_valores_campos.map((i) => Campo.fromJson(i)).toList();
        print("se agregaron " +
            s.campos.length.toString() +
            " campos a la seccion");
        secc_valores.add(s);
      });

      filtro = true;
      print("son " + secc_valores.length.toString() + " hijos");
    }


    List<Campo> camp;
    if (parsedJson["campos"] != null) {
      var list = parsedJson["campos"] as List;
      camp = list.map((i) => Campo.fromJson(i)).toList();
      if(camp.length>0 && camp!=null){
        camp.forEach((c){
          c.id_seccion = parsedJson["id_seccion"];
          c.propagarReferencia(parsedJson["id_seccion"], c.id_campo);
        });
      }
    }

    return Seccion(
      reglasNegocio: reglas_json,
      id_seccion: parsedJson["id_seccion"],
      campos: parsedJson["campos"] != null ? camp : campos_filtrables,
      seccion: parsedJson["seccion"],
      multiplicador: //Se resta 1 porque el primer asegurado es el titular
      parsedJson["multiplicador"] != null ? parsedJson["multiplicador"] : 0,
      //Si es multiplicador
      children_secc:
      parsedJson['valores'] != null ? secc_valores : List<Seccion>(),
      id_filtrado:
      parsedJson['id_filtrado'] != null ? parsedJson['id_filtrado'] : null,
      filtrable: filtro,
      children_secc_sin_filtro: parsedJson['valores'] != null
          ? new List<Seccion>.from(secc_valores)
          : List<Seccion>(),
      nombreRequestCotizacion: parsedJson["nombreRequestCotizacion"] != null
          ? parsedJson["nombreRequestCotizacion"]
          : "",
    );
  }
}

class Campo {
  int id_seccion;
  Referencia parent_campo;
  static int view_cont_ID = 0;
  final int view_ID;
  final int id_campo;
  String etiqueta;
  final bool obligatorio;
  String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  bool visible;
  bool visibleLocal = true;
  final String regla;
  final List<Valor> valores_sin_filtro;
  List<Valor> valores;
  final Rango rango;
  final List<int> dato_longitud;
  String valor = "";
  final String seccion_dependiente;
  final String nombreRequestCotizacion;
  String error = "";
  bool isValid = true;
  bool esConsulta = false;
  final bool checked;
  final bool enabled;
  final String reg_ex;
  List <Referencia> campos_modificados;
  final bool oculta;
  final List <FechaRelativa> rangoRelativa;
  final FechaRelativa regla_catalogo;



  Campo(
      {this.rangoRelativa,
        this.regla_catalogo,
        this.id_campo,
        this.id_seccion,
        this.campos_modificados,
        this.reg_ex,
        this.etiqueta,
        this.obligatorio,
        this.nombre_campo,
        this.tipo_dato,
        this.tipo_componente,
        this.visible,
        this.regla,
        this.valores,
        this.rango,
        this.view_ID,
        this.dato_longitud,
        this.valor, this.oculta,
        this.seccion_dependiente,
        this.nombreRequestCotizacion,
        this.valores_sin_filtro,
        this.checked,
        this.parent_campo,
        this.enabled,
        this.visibleLocal});

  propagarReferencia(int id_secc, int id_campo){
    if(valores!=null){
      valores.forEach((v){
        if(v.children!=null){
          if(v.children.length>0){ //Si tiene hijos, les ligamos la referencia de su campo padre
            v.children.forEach((ch){
              ch.parent_campo = Referencia(id_campo: id_campo, id_seccion: id_secc);

              if(ch.valores!=null){
                ch.valores.forEach((valores_hijo){ //Los valores del campo hijo
                  if(valores_hijo.children!=null){
                    valores_hijo.children.forEach((hijos_hijo){
                      hijos_hijo.parent_campo =  Referencia(id_seccion: id_secc, id_campo: ch.id_campo);
                      hijos_hijo.propagarReferencia(id_secc, hijos_hijo.id_campo);
                    });
                  }

                });

              }



              if(ch.valores_sin_filtro!=null){
                ch.valores_sin_filtro.forEach((valores_hijo){ //Los valores del campo hijo
                  if(valores_hijo.children!=null){
                    valores_hijo.children.forEach((hijos_hijo){
                      hijos_hijo.parent_campo =  Referencia(id_seccion: id_secc, id_campo: ch.id_campo);
                      hijos_hijo.propagarReferencia(hijos_hijo.id_seccion, hijos_hijo.id_campo);
                    });
                  }

                });

              }



            });
          }
        }
      });

      valores_sin_filtro.forEach((v){
        if(v.children.length!=null){
          if(v.children.length>0){ //Si tiene hijos, les ligamos la referencia de su campo padre
            v.children.forEach((ch){
              ch.parent_campo = Referencia(id_campo: id_campo, id_seccion: id_secc);

              if(ch.valores!=null){
                ch.valores.forEach((valores_hijo){ //Los valores del campo hijo
                  if(valores_hijo.children!=null){
                    valores_hijo.children.forEach((hijos_hijo){
                      hijos_hijo.parent_campo =  Referencia(id_seccion: id_secc, id_campo: ch.id_campo);
                      hijos_hijo.propagarReferencia(id_secc, hijos_hijo.id_campo);
                    });
                  }

                });

              }


              if(ch.valores_sin_filtro!=null){
                ch.valores_sin_filtro.forEach((valores_hijo){ //Los valores del campo hijo
                  if(valores_hijo.children!=null){
                    valores_hijo.children.forEach((hijos_hijo){
                      hijos_hijo.parent_campo =  Referencia(id_seccion: id_secc, id_campo: ch.id_campo);
                      hijos_hijo.propagarReferencia(hijos_hijo.id_seccion, hijos_hijo.id_campo);
                    });
                  }

                });

              }
            });
          }
        }

      });
    }


  }

  filtrarValores(int filtro) {
    valores = new List<Valor>.from(valores_sin_filtro);
    valores.removeWhere((item) => item.id_filtrado != filtro);
  }

  filtrarHijos(String filtro) { //Quita a los hijos con este ID
    valores = new List<Valor>.from(valores_sin_filtro);
    valores.removeWhere((item) => item.id == filtro);
  }

  resetHijos() {
    valores = new List<Valor>.from(valores_sin_filtro);
  }

  bool validaCampo(String s) {
    print("estoy validando por el onValidate " +
        this.etiqueta +
        " valor " +
        s.length.toString());
    this.isValid = false;
    Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().esValido = false;

    if (this.obligatorio) {
      if (s.isEmpty) {
        print("Error Vacio" + this.etiqueta + " valor " + s.length.toString());

        this.error = "Este campo es requerido";
        this.isValid = false;
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().esValido = false;
        return false;

      }
    }

    if(s.isNotEmpty){
      if (this.dato_longitud != null) {
        if (this.dato_longitud.length > 0) {
          if (this.dato_longitud.length == 1) {
            if (s.length > this.dato_longitud[0]) {
              this.error =
                  "La longitud máxima es " + this.dato_longitud[0].toString();

              return false;
            }
//          if(s.length < this.dato_longitud[0]){
//            this.error =
//                "La longitud mínima es " + this.dato_longitud[0].toString();
//            return false;
//          }
          } else {
            if (s.length < this.dato_longitud[0]) {
              this.error =
                  "La longitud mínima es " + this.dato_longitud[0].toString();
              return false;
            }
            if (s.length > this.dato_longitud[1]) {
              this.error =
                  "La longitud máxima es " + this.dato_longitud[1].toString();
              return false;
            }
          }
        }
      }

      if (this.rango != null) {
        if (!(double.parse(s) >= double.parse(this.rango.rango_inicio) &&
            double.parse(s) <= double.parse(this.rango.rango_fin))) {
          this.error = "El valor se encuentra fuera de rango (" +
              this.rango.rango_inicio +
              ", " +
              this.rango.rango_fin +
              ")";
          return false;
        }
      }

    }

    print("El campo pasó todas las validaciones " + this.isValid.toString() + this.etiqueta +
        " valor " + s.length.toString());
    this.error = "";
    Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().esValido = true;
    this.isValid = true;
    return true;

  }

  bool validaLongitud(int val) {
    if (dato_longitud.isEmpty) {
      return true;
    }

    if (dato_longitud.length >= 1) {
      if (val > dato_longitud[0] && val < dato_longitud[1]) {
        return true;
      }
    } else {
      if (val < dato_longitud[0]) {
        return true;
      }
    }

    return false;
  }

  factory Campo.fromJson(Map<String, dynamic> parsedJson) {
    view_cont_ID++;

    List<Valor> val;
    List<Valor> val2;

    try {
      var list = parsedJson["catalogo"]["valores"] as List;
      val = list.map((i) => Valor.fromJson(i)).toList();
      val2 = list.map((i) => Valor.fromJson(i)).toList();


    } on NoSuchMethodError {
      val = null;
      val2 = null;
    }

    Rango r;

    try {
      //var list = parsedJson["catalogo"]["rangos"] as List;
      //val = list.map((i) => Valor.fromJson(i)).toList();

      r = Rango.fromJson(parsedJson["catalogo"]["rangos"]);
    } on NoSuchMethodError {


      r = null;
    }

    List <FechaRelativa> fechas_json; //RangoRelativa
    try {
      var list = parsedJson["rangoRelativa"] as List;
      fechas_json = list.map((i) => FechaRelativa.fromJson(i)).toList();
    } on NoSuchMethodError {
      fechas_json = null;
    }



    if(parsedJson["tipo_dato"]=="date"){


      try {

        r=  new Rango(
          rango_inicio: parsedJson["fechaInicial"] != null
              ? parsedJson["fechaInicial"].toString().isNotEmpty
              ? parsedJson["fechaInicial"].toString()
              : null
              : null,
          rango_fin: parsedJson["fechaFinal"] != null
              ? parsedJson["fechaFinal"].toString().isNotEmpty
              ? parsedJson["fechaFinal"].toString()
              : null
              : null,
        );



      } catch (e) {

        print(e.toString());
      }

    }





    try {

      r = Rango.fromJson(parsedJson["rangos"]);
    } on NoSuchMethodError {


    }

    List<int> longitud;

    try {
      var list = parsedJson['dato_longitud'];

      List<int> streetsList = new List<int>.from(list);
      longitud = streetsList;
    } catch (e) {
      longitud = null;
    }

    return Campo(
      //TODO: Esta propiedad deberìa venir en los campos que son hijos para el correcto enviado de json dinamico.
        id_campo: parsedJson["id_campo"] != null
            ? parsedJson["id_campo"]
            : int.parse(parsedJson["id_valor"]),
        etiqueta: parsedJson["etiqueta"],
        obligatorio: parsedJson["obligatorio"],
        nombre_campo: parsedJson["nombre_campo"],
        regla_catalogo: parsedJson["regla_catalogo"] != null ? FechaRelativa.fromJson(parsedJson["regla_catalogo"]) : null,
        rangoRelativa: fechas_json,
        tipo_dato: parsedJson["tipo_dato"],
        tipo_componente: parsedJson["tipo_componente"],
        visible: parsedJson["visible"],
        regla: parsedJson["regla"],
        valores: val,
        rango: r,
        oculta: parsedJson["oculta"]!=null ? parsedJson["oculta"]: false,
        campos_modificados: List<Referencia>(),
        view_ID: view_cont_ID,
        dato_longitud: longitud,
        seccion_dependiente: parsedJson["seccion_dependiente"] != null
            ? parsedJson["seccion_dependiente"]
            : null,
        nombreRequestCotizacion: parsedJson["nombreRequestCotizacion"] != null
            ? parsedJson["nombreRequestCotizacion"]
            : null,
        valores_sin_filtro: val2,
        checked: parsedJson["checked"] != null ? parsedJson["checked"] : false,
        reg_ex: parsedJson["reg_ex"] != null
            ? parsedJson["reg_ex"]
            : "[A-Za-zÀ-ÿ\u00f1\u00d1 ]", //[A-Za-zÀ-ÿ\u00f1\u00d1\u0023\u002E0-9 ] RegExp for address
        enabled: parsedJson["enabled"] != null ? parsedJson["enabled"] : true,
        visibleLocal: true);
  }

  Map<String, dynamic> toJson() =>
      {nombreRequestCotizacion.toString(): getValorFormatted()};

  dynamic getValorFormatted() {
    switch (tipo_dato) {
      case "integer":
        if (valor != null) {
          return int.parse(valor);
        } else {
          if (tipo_componente == "select") {
            return valores[0].id;
          } else {
            return 1;
          }
        }
        break;

      case "rango":
        if (valor != null) {
          return int.parse(valor);
        } else {
          return null;
        }
        break;

      case "string":
        return valor != null ? valor : "";

      case "seccion":
      //return valor == "true" ? 2 : 1;

        return valor != null ?  int.parse(valor) : 1;
        break;

      case "boolean":
        if (valor != null) {
          return valor == "true" ? true : false;
        } else {
          return checked;
        }
        break;

      case "date":
        return valor != null ? valor : "";
        break;

      default:
        return valor;
        break;
    }
  }
}

class Catalogo {
  final List<Valor> valores;

  Catalogo({this.valores});

  factory Catalogo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["valores"] as List;

    List<Valor> val = list.map((i) => Valor.fromJson(i)).toList();

    return Catalogo(
      valores: parsedJson["id_valor"],
    );
  }
}

class Rango {
  final String rango_inicio;
  final String rango_fin;

  Rango({this.rango_inicio, this.rango_fin});

  factory Rango.fromJson(Map<String, dynamic> parsedJson) {
    return Rango(
      rango_inicio: parsedJson["rango_inicio"].toString() != null
          ? parsedJson["rango_inicio"].toString()
          : parsedJson["fechaInicial"] != null
          ? parsedJson["fechaInicial"].toString().isNotEmpty
          ? parsedJson["fechaInicial"].toString()
          : null
          : null,
      rango_fin: parsedJson["rango_fin"].toString() != null
          ? parsedJson["rango_fin"].toString()
          : parsedJson["fechaFinal"] != null
          ? parsedJson["fechaFinal"].toString().isNotEmpty
          ? parsedJson["fechaFinal"].toString()
          : null
          : null,
    );
  }
}

class Valor {
  final String id;
  final String descripcion;
  final Campo child;
  final bool subnivel;
  final int id_filtrado;
  final List<Campo> children;
  bool visible;
  final List <Referencia> oculta_campos;
  final String icono;
  final bool valor_default;


  Valor(
      {this.id,
        this.descripcion,
        this.oculta_campos,
        this.subnivel,
        this.child,
        this.id_filtrado,
        this.children,
        this.visible,
        this.icono,
        this.valor_default});

  factory Valor.fromJson(Map<String, dynamic> parsedJson) {

    List<Referencia> oculta_campos_json =  List<Referencia>();
    if(parsedJson["oculta_campos"]!=null){
      var list = parsedJson["oculta_campos"] as List;
      oculta_campos_json = list.map((i) => Referencia.fromJson(i)).toList();
    }



    Campo hijo = null;

    List<Campo> hijos = List<Campo>();

    bool sub_nivel =
    parsedJson["subnivel"] != null ? parsedJson["subnivel"] : false;

    if (parsedJson["tipo_componente"] != null) {
      hijo = Campo.fromJson(parsedJson);

      if (hijo.etiqueta == null) {
        hijo.etiqueta = parsedJson["descripcion"];
      }
      hijos.add(hijo);
    } else {
      if (sub_nivel) {
        var list = parsedJson["catalogo"]["valores"] as List;
        hijos = list.map((i) => Campo.fromJson(i)).toList();
      } else {
        try {
          if (parsedJson["catalogo"]["valores"][0]["subnivel"] != null
              ? parsedJson["catalogo"]["valores"][0]["subnivel"]
              : false) {
            print("Le estoy asignando hijos " +
                parsedJson["descripcion"].toString());

            var list = parsedJson["catalogo"]["valores"] as List;
            hijos = list.map((i) => Campo.fromJson(i)).toList();
          }
        } catch (Exception) {
          //TODO:todo bien.

        }
      }
    }

    return Valor(
        id: parsedJson["id_valor"],
        oculta_campos: oculta_campos_json,
        descripcion: parsedJson["descripcion"],
        subnivel: sub_nivel,
        child: hijo,
        visible: parsedJson["visible"] != null ? parsedJson["visible"] : true,
        id_filtrado:
        parsedJson["id_cartera"] != null ? parsedJson["id_cartera"] : null,
        children: hijos,
        icono: parsedJson["icono"],
        valor_default: parsedJson["valor_default"] != null ? parsedJson["valor_default"] : false);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "OBJETO VALOR:\n Descc:" +
        descripcion +
        " Child: " +
        child.nombre_campo.toString();
  }
}

class Documento {
  final int id;
  final String nombreDocumento;
  final String descDocumento;
  final String productos;
  final String urlPDF;

  Documento(
      {this.nombreDocumento, this.descDocumento, this.productos, this.urlPDF, this.id});

  factory Documento.fromJson(Map<String, dynamic> parsedJson) {
    return Documento(
      id: parsedJson["id"],
      nombreDocumento: parsedJson["nombre_documento"],
      descDocumento: parsedJson["descripcion"],
      productos: parsedJson["productos"],
      urlPDF: parsedJson["url"],
    );
  }
}

class Cotizacion2Campos {
  final String etiquetaElemento;
  final String descElemento;

  Cotizacion2Campos({this.etiquetaElemento, this.descElemento});

  factory Cotizacion2Campos.fromJson(Map<String, dynamic> parsedJson) {
    return Cotizacion2Campos(
        etiquetaElemento: parsedJson["etiquetaElemento"],
        descElemento: parsedJson["descElemento"]);
  }
}

class Cotizacion {
  final String fecha;
  final String titular;
  final int id;
  final String requestCotizacion;
  final String responseCotizacion;
  final String responseResumen;
  final String nombreCotizacion;
  final int idFormato;
  final String idPlan;


  Cotizacion( {this.fecha, this.titular, this.id, this.nombreCotizacion, this.requestCotizacion, this.responseCotizacion, this.responseResumen, this.idFormato, this.idPlan});

  factory Cotizacion.fromJson(Map<String, dynamic> parsedJson) {
    return Cotizacion(
        fecha: parsedJson["fechaCotizacion"],
        titular: parsedJson["titularCotizacion"],
        id: parsedJson["folioCotizacion"],
        requestCotizacion: parsedJson["requestCotizacion"],
        responseCotizacion: parsedJson["responseCotizacion"],
        responseResumen: parsedJson["responseResumen"],
        nombreCotizacion: parsedJson["nombreCotizacion"] == null ? " " :  parsedJson["nombreCotizacion"],
        idFormato: parsedJson["idFormato"],
        idPlan: parsedJson["idPlan"].toString()
    );
  }
}

class NegocioOperable {
  final String negocioOperable;
  final String idNegocioOperable;
  final String ramo;
  final String idNegocioComercial;
  final String idUnidadNegocio;
  List<Cotizadores> cotizadores;

  NegocioOperable(
      {this.negocioOperable,
        this.idNegocioOperable,
        this.ramo,
        this.idNegocioComercial,
        this.idUnidadNegocio});

  factory NegocioOperable.fromJson(Map<String, dynamic> parsedJson) {
    return NegocioOperable(
      ramo: parsedJson["ramo"],
      negocioOperable: parsedJson["negocioOperable"],
      idNegocioOperable: parsedJson["idNegocioOperable"],
      idNegocioComercial: parsedJson["idNegocioComercial"],
      idUnidadNegocio: parsedJson["idUnidadNegocio"],
    );
  }
}

class Cotizadores {
  final int id_aplicacion;
  final int cantidad_asegurados;
  final String aplicacion;
  final String descripcion;
  final bool estatus;
  final bool visible_movil;
  final String mensaje;

  Cotizadores(
      {this.id_aplicacion,
        this.cantidad_asegurados,
        this.aplicacion,
        this.descripcion,
        this.estatus,
        this.visible_movil,
        this.mensaje});

  factory Cotizadores.fromJson(Map<String, dynamic> parsedJson) {
    return Cotizadores(
        id_aplicacion: parsedJson["id_aplicacion"],
        cantidad_asegurados: parsedJson["cantidad_asegurados"],
        aplicacion: parsedJson["aplicacion"],
        descripcion: parsedJson["descripcion"],
        estatus: parsedJson["estatus"],
        visible_movil: parsedJson["visible_movil"],
        mensaje: parsedJson["mensaje"]);
  }
}

class Comparativa {
  List<FormadePago> formaspago;
  final int banComparativa;
  final List<SeccionComparativa> secciones;
  String nombre;
  //Agregar Folio de comparativa
  int FOLIO_FORMATO_COTIZACION;
  int FOLIO_FORMATO_COMISION;

  int formapagoseleccionada = 0;

  Comparativa({this.formaspago, this.secciones, this.banComparativa,});

  factory Comparativa.fromJson(Map<String, dynamic> parsedJson) {

    var raw_Formaspago = parsedJson["resumenCotizacion"]["formasPago"] as List;
    print("FORMAS DE PAGO: " + raw_Formaspago.toString());

    var comp = parsedJson["resumenCotizacion"]["banComparativa"] as int;
    print("Comparativa: " + comp.toString());

    List<FormadePago> renglonesformas =
    raw_Formaspago.map((i) => FormadePago.fromJson(i)).toList();

    var raw_Renglones = parsedJson["resumenCotizacion"]["secciones"] as List;
    List<SeccionComparativa> renglones =
    raw_Renglones.map((i) => SeccionComparativa.fromJson(i)).toList();

    return Comparativa(
      secciones: renglones,
      banComparativa: comp,
      formaspago: renglonesformas,
    );
  }
}

class SeccionComparativa {
  final String seccion;
  final List<Cotizacion2Campos> tabla;

  SeccionComparativa({this.seccion, this.tabla});

  factory SeccionComparativa.fromJson(Map<String, dynamic> parsedJson) {
    var raw_Renglones = parsedJson["elementos"] as List;
    List<Cotizacion2Campos> renglones =
    raw_Renglones.map((i) => Cotizacion2Campos.fromJson(i)).toList();

    return SeccionComparativa(seccion: parsedJson["seccion"], tabla: renglones);
  }
}

class FormadePago {
  final String forma;
  final String ptotal;
  final String parcialidades;

  FormadePago({this.forma, this.ptotal, this.parcialidades});

  factory FormadePago.fromJson(Map<String, dynamic> parsedJson) {
    return FormadePago(
        forma: parsedJson["formaPago"], ptotal: parsedJson["primaTotal"].toString(), parcialidades: parsedJson["parcialidades"]);
  }
}

class Referencia {

  int id_seccion;
  int id_campo;
  int id_paso;

  Referencia({this.id_campo, this.id_seccion, this.id_paso});

  String toString(){
    return "Seccion: "+ id_seccion.toString()+", Campo:"+ id_campo.toString();
  }

  bool equals(Referencia r){
    return (r.id_seccion == this.id_seccion && r.id_campo== this.id_campo);
  }

  factory Referencia.fromJson(Map<String, dynamic> parsedJson){
    return Referencia(
      id_campo: parsedJson["id_campo"],
      id_seccion: parsedJson["id_seccion"],

    );
  }


}

class FechaRelativa {
  //Cantidad de días, meses y años a agregar a otra fecha.

  int dia;
  int mes;
  int anio;

  FechaRelativa({this.dia, this.mes, this.anio});


  factory FechaRelativa.fromJson(Map<String, dynamic> parsedJson){
    return FechaRelativa(
        dia: parsedJson["dia"],
        mes: parsedJson["mes"],
        anio: parsedJson["anio"]
    );
  }
}