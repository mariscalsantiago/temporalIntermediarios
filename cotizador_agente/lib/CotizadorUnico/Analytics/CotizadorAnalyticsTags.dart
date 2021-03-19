import 'dart:convert';

import 'package:cotizador_agente/CotizadorUnico/Analytics/Analytics.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CotizadorAnalitycsTags {
  static const String cotizadorGMM = "gmm_cotizador_ingreso";
  static const String descargaGMM = "gmm_cotizador_descarga";
  static const String envioMailGMM = "gmm_cotizador_envioEmail";
  static var config;
  static String contenedor = "";

  static void sendTagsFormulario(FormularioCotizacion formularioCotizacion, BuildContext context) async {

    config = AppConfig.of(context);
    List <Seccion> seccionesFormulario= List<Seccion> ();

    //Hacer copia local de los campos del formulario
    seccionesFormulario.addAll(backPaso1(formularioCotizacion.paso1.secciones));
    seccionesFormulario.addAll(backPaso1(formularioCotizacion.paso2.secciones));

    enviarTagsFormularioSeccion(seccionesFormulario);
  }

  //Métodos para copiar Secciones.
  static List<Seccion> backPaso1(List<Seccion> secciones) {
    return backPaso1Child(secciones);
  }

  static List<Seccion> backPaso1Child(List<Seccion> secciones) {
    List<Seccion> _secciones = List<Seccion>();
    for(Seccion seccion in secciones) {
      List<Campo> _campos = List<Campo>();
      for(var campo in seccion.campos)
      {
        Campo _campo = new Campo(
            valor: campo.valor,
            oculta: campo.oculta,
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
        _campos.add(_campo);
      }

      Seccion _seccion = Seccion(id_seccion: seccion.id_seccion,
          seccion: seccion.seccion,
          multiplicador: seccion.multiplicador,
          campos: _campos, reglasNegocio:
          seccion.reglasNegocio,
          nombreRequestCotizacion: seccion.nombreRequestCotizacion,
          id_valor: seccion.id_valor,
          filtrable: seccion.filtrable,
          id_filtrado: seccion.id_filtrado );

      if(seccion.multiplicador>0) {
        _seccion.children_secc = backPaso1Child(seccion.children_secc);
      }

      _secciones.add(_seccion);
    }
    return _secciones;
  }

  static Map<String,dynamic> newTag(String paramaName, dynamic valor){
    Map<String, dynamic> esteTag = new Map<String, dynamic>();

    if(config.ambient == Ambient.qa){
      contenedor = config.idContenedorAnalytics;
    }else if (config.ambient == Ambient.uat){
      contenedor = config.idContenedorAnalytics;
    }else if(config.ambient == Ambient.prod){
      contenedor = config.idContenedorAnalytics;
    }

    esteTag["v"] = "1";
    esteTag["tid"] = config.idContenedorAnalytics;
    esteTag["cid"] = "555";
    esteTag["t"] = "event";
    esteTag["ec"] = Utilidades.getCategoria();
    esteTag["ea"] = paramaName;
    esteTag["el"] = valor;

    return esteTag;

  }

  static void enviarTagsFormularioSeccion( List<Seccion> secciones) async {
    String tagName = 'gmm_cotizador_titular';

    //El método itera todos los campos para almacenarlos en dos listas: Adicionales y del Titular
    //DEspúes de acomodar todos los campos en listas liniales, luego entonces se envían los parámetros

    Map<String, dynamic> parameters_titular = Map<String, dynamic>();
    List<Map<String, dynamic>> tagList = List<Map<String, dynamic>> ();

    List <Campo> campos_titular = List<Campo> ();
    List <Seccion> secciones_adicionales  = List <Seccion> ();

    //BUSCAR Clasificar Campos
    for(var seccion in secciones){
      if(seccion.multiplicador<1){ // Es del titular o de configuración del plan.
        List<Campo> campos = List<Campo>();
        campos = obtenerCamposSimplificados(campos, seccion.campos);

        //Agegar a los parámetros


        for(var campo in campos){

          Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);

          bool seEncuentraEnListaNegra = false;

          for(var ref in Utilidades.listaCamposNoAnalytics){
            if(ref.equals(esteCampo)){
              seEncuentraEnListaNegra = true;
            }
          }

          if(seEncuentraEnListaNegra == false){

            //Formatear campo para agregarlo a parámetros.

            if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
              var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
              //tag = tag.toUpperCase();
              dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
              if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
                Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
                valor = _valor.descripcion;
                valor = valor == 'ocultar' ? 'No' : valor;
                valor = valor == 'mostrar' ? 'Si' : valor;
              }
              valor = valor == 'true' ? 'Si' : valor;
              valor = valor == 'false' ? 'No' : valor;
              parameters_titular[paramaName] = valor; //Agregar a parámetros
              tagList.add(newTag(seccion.seccion + "/" + campo.etiqueta, valor));
              //sendTagInteractionWithANamedParam(tag, "value", valor);
              //print(tag + " { value: " + valor + " }");
            }

          }

        }
        campos_titular.addAll(campos);
      }else{ // Es de los adicionales


        for (var secc_hija in seccion.children_secc){

          if(secc_hija.id_valor == null){

            secciones_adicionales.add(secc_hija);
            print("argrego secc hija");

          }else{

            print("secc hija: "+ secc_hija.id_valor);

            if(secc_hija.id_valor=="1"){ //Agregar Campo al titular


              List<Campo> campos = List<Campo>();
              campos = obtenerCamposSimplificados(campos, secc_hija.campos);

              for(var campo in campos){


                Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);

                bool seEncuentraEnListaNegra = false;

                for(var ref in Utilidades.listaCamposNoAnalytics){
                  if(ref.equals(esteCampo)){
                    seEncuentraEnListaNegra = true;
                  }
                }

                if(seEncuentraEnListaNegra == false){

                  //Formatear campo para agregarlo a parámetros.

                  if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
                    var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
                    //tag = tag.toUpperCase();
                    dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
                    if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
                      Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
                      valor = _valor.descripcion;
                      valor = valor == 'ocultar' ? 'No' : valor;
                      valor = valor == 'mostrar' ? 'Si' : valor;
                    }
                    valor = valor == 'true' ? 'Si' : valor;
                    valor = valor == 'false' ? 'No' : valor;
                    parameters_titular[paramaName] = valor; //Agregar a parámetros
                    //sendTagInteractionWithANamedParam(tag, "value", valor);
                    //print(tag + " { value: " + valor + " }");
                  }

                }

              }
              campos_titular.addAll(campos);

            }else{ //Agregar campo al adicional que corresponda

              List<Campo> campos = List<Campo>();
              campos = obtenerCamposSimplificados(campos, secc_hija.campos);
              secciones_adicionales[int.parse(secc_hija.id_valor)-2].campos.addAll(campos);

            }

          }

        }


      }
    }

    //UNA VEZ MAPEADOS ADICIONALES AGREGAR AL TAG DE TITULAR COMO PARAM NUEVO

    //Formatear parámetros y Mandar "N" Eventos como adicionales existan.

    int num_adicional = 1; //En el cotizador

    //Mandar a llamar el método que se tiene en utilidades para enviar parameters_titular
    for(var seccion in secciones_adicionales){

      Map<String, dynamic> parameters_adicionales = Map<String, dynamic>();

      List<Campo> campos = List<Campo>();
      campos = obtenerCamposSimplificados(campos, seccion.campos);

      //Agegar a los parámetros
      for(var campo in campos){

        Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);

        bool seEncuentraEnListaNegra = false;

        for(var ref in Utilidades.listaCamposNoAnalytics){
          if(ref.equals(esteCampo)){
            seEncuentraEnListaNegra = true;
          }
        }

        if(seEncuentraEnListaNegra == false){

          //Formatear campo para agregarlo a parámetros.

          if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
            var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
            //tag = tag.toUpperCase();
            dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
            if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
              Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
              valor = _valor.descripcion;
              valor = valor == 'ocultar' ? 'No' : valor;
              valor = valor == 'mostrar' ? 'Si' : valor;
            }
            valor = valor == 'true' ? 'Si' : valor;
            valor = valor == 'false' ? 'No' : valor;
            parameters_adicionales[paramaName] = valor; //Agregar a parámetros
            //parameters_titular["adicional_"+ num_adicional.toString()+"_"+paramaName] = valor; //Agregar a parámetros de titular

            //sendTagInteractionWithANamedParam(tag, "value", valor);
            //print(tag + " { value: " + valor + " }");
          }

        }

      }


      // TAGGING

      num_adicional ++;


    }


    //tagging
    AnalyticsServices().sendTagWithDynamicParams( "gmm_cotizador_titular", parameters_titular);
    print("gmm_cotizador_titular");
    print(parameters_titular.toString());

  }


  static List<Campo> obtenerCamposSimplificados(List<Campo> acumCampos, List<Campo> campos) {

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
                  if ((c.tipo_dato == "boolean" || c.tipo_componente == "toggle" || c.tipo_componente == "date_relativa") && (c.valor == "true" || c.tipo_componente == "date_relativa")) {
                    //ENCONTRAR PQ NO TRAE FORMA PAGO - ADD IF C.TIPO_COMPONENTE DATE_RELATIVA comparar si es mayor a 1 año para saber que hijo escoger
                    List<Campo> campos_hijos = List<Campo>();
                    if(c.tipo_componente == "date_relativa"){
                      List <Campo> hijosFiltrados = List <Campo> ();

                      valor.children.forEach((c){

                        if(c.visible){
                          hijosFiltrados.add(c);

                        }

                      });

                      if(hijosFiltrados.length>0){
                        acumCampos.addAll(obtenerCamposSimplificados(campos_hijos, hijosFiltrados));

                      }
                    }else{
                      acumCampos.addAll(obtenerCamposSimplificados(campos_hijos, valor.children));
                    }

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

  //Método para GTM
  static List<Map<String, dynamic>>  getListaSeccionesGTM(FormularioCotizacion formularioCotizacion){

    List <Seccion> seccionesFormulario= List<Seccion> ();
    List <Seccion> temporalPaso1 = List<Seccion>();
    List <Seccion> temporalPaso2 = List<Seccion>();

    //Hacer copia temporal de paso1 y paso2
    temporalPaso1 = backPaso1(formularioCotizacion.paso1.secciones);
    temporalPaso2 = backPaso1(formularioCotizacion.paso2.secciones);
    var estaReferencia = Utilidades.listaOrdenAnalytics;

    for(int a=0; a<estaReferencia.length; a++){

      var ref = estaReferencia[a];

      if(ref.id_paso == 1){ //PASO 1

        //Buscar en paso1
        for(int j=0; j<temporalPaso1.length; j++){

          if(ref.id_seccion == temporalPaso1[j].id_seccion){

            seccionesFormulario.add(temporalPaso1[j]);
          }
        }

      }else if(ref.id_paso == 2){ //PASO 2
        for(int k=0; k< temporalPaso2.length; k++){

          if(ref.id_seccion == temporalPaso2[k].id_seccion){

            seccionesFormulario.add(temporalPaso2[k]);
          }

        }

      }

    }

    List<Map<String, dynamic>> secciones_gtm2 = generarTagsGTM2(seccionesFormulario);
    Utilidades.LogPrint("SECCIONES_GTM: " + secciones_gtm2.toString());

    return  secciones_gtm2;


  }

  static List<Map<String, dynamic>>  generarTagsGTM2(List<Seccion> secciones) {
    //Lista de Secciones
    List<Map<String, dynamic>> seccionAdicionales = new List<Map<String, dynamic>>();
    List<Map<String, dynamic>> lista_secciones =  List<Map<String, dynamic>> ();

    //BUSCAR Clasificar Campos
    for(var seccion in secciones){
      if(seccion.multiplicador<1){ // Es del titular o de configuración del plan.

        Map<String, dynamic> esta_seccion = Map<String, dynamic>();

        esta_seccion["seccion"] = seccion.nombreRequestCotizacion; //Generales

        if(seccion.nombreRequestCotizacion == "requestLabel"){
          esta_seccion["seccion"] = "";
        }

        List<Campo> campos = List<Campo>();
        campos = obtenerCamposSimplificados(campos, seccion.campos);

        //Agegar a los parámetros


        for(var campo in campos){

          Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);

          bool seEncuentraEnListaNegra = false;

          for(var ref in Utilidades.listaCamposNoAnalytics){
            if(ref.equals(esteCampo)){
              seEncuentraEnListaNegra = true;
            }
          }

          if(seEncuentraEnListaNegra == false){

            //Formatear campo para agregarlo a parámetros.

            if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
              //var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');

              //Para coberturas_basicas se cambia el nombre de la etiqueta porque Tagmanger se configuró de esa forma
              if(seccion.nombreRequestCotizacion == "planes" && campo.nombre_campo == "coberturas_basicas"){
                String nameC = "coberturasBasicas";
                campo.nombre_campo = nameC;
              }

              //Para analiticos espera el nombre de la etiqueda como ampliacionHospitalariaDefinida o ampliacionHospitalariaLibre
              else if( seccion.nombreRequestCotizacion == "coberturas" && (campo.nombre_campo == "ampliacionHospitalariaTipo" || campo.nombre_campo == "ampliacionHospitalariaDefinida" || campo.nombre_campo == "ampliacionHospitalariaLibre") ){
                String definida = "ampliacionHospitalariaDefinida";
                String libre = "ampliacionHospitalariaLibre";
                dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
                if(  valor == "9" || valor == "15" ) {
                  //if(  (valor is String) ) {
                  //if( valor =! true ) {
                  Valor _valor = campo.valores.singleWhere((v) =>
                  v.id == valor);
                  if (_valor.id == "9" && valor == "9") {
                    campo.nombre_campo = definida;
                  }
                  else if (_valor.id == "15" && valor == "15") {
                    campo.nombre_campo = libre;
                  }
                  //campo.valor = "Amparada";
                  //}
                }

              }

              String paramaName = seccion.nombreRequestCotizacion+ "-"+campo.nombre_campo;
              String prefijo;
              switch(seccion.nombreRequestCotizacion){
                case "general":
                  prefijo = "Cotización";
                  break;
                case "titular":
                  prefijo = "Titular";
                  break;
                case "planes":
                  prefijo = "Planes de Cotización";
                  break;
                case "contratante":
                  prefijo = "Contratante Dif. al Titular";
                  break;
                case "coberturas":
                  prefijo = "Coberturas";
                  break;
                default:
                  prefijo = "Planes de Cotización";
                  break;
              }
              //Formatear nombre de la etiqueta, debido a que web así lo manejo
              if(paramaName == "contratante-tipo_persona"){
                campo.etiqueta = "Tipo de Persona";
              }else if(paramaName == "contratante-contratante_diferente"){
                campo.etiqueta = "Contratante";
              }
              if(paramaName == "planes-id_tipo_sumaasegurada"){
                campo.etiqueta = "Tipo de Reinstalación";
              }
              if(paramaName == "coberturas-id_amp_hospitalaria"){
                campo.etiqueta = "Factor Ampliación Hospitalaria Definida";
              }
              if(paramaName == "planes-estancia_extranjero"){
                campo.etiqueta = "Estancia en el Extranjero";
              }
              prefijo = prefijo + " / " + campo.etiqueta;
              //Formatear nombre de paranmetro

              //tag = tag.toUpperCase();
              dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
              if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
                Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
                valor = _valor.descripcion;
                valor = valor == 'ocultar' ? 'No' : valor;
                valor = valor == 'mostrar' ? 'Si' : valor;
              }
              if(paramaName.contains('contratante-contratante_diferente')){
                valor = valor == 'No' ? 'ocultar' : valor;
                valor = valor == 'Si' ? 'mostrar' : valor;
              }
              if( paramaName.contains('ampliacionHospitalariaDefinida') || paramaName.contains('ampliacionHospitalariaLibre')
                  || paramaName.contains('coberturas-')){
                valor = valor == 'Definida' || valor == 'Libre' || valor == 'true' ? 'Amparada' : valor ;
              }
              if( paramaName.contains('ampliacionHospitalariaDefinida') || paramaName.contains('ampliacionHospitalariaLibre')
                  || paramaName.contains('coberturas-')){
                valor = valor == 'false' ? 'No seleccionada' : valor ;
              }
              if( paramaName.contains('riesgo_selecto') ){
                valor = valor == 'true' ? 'Selecto' : 'Normal' ;
              }
              valor = valor == 'true' ? 'Si' : valor;
              valor = valor == 'false' ? 'No' : valor;
              esta_seccion[paramaName] = valor; //Agregar a parámetros
              if(valor != ""){
                seccionAdicionales.add(newTag(prefijo, valor));
              }
              //sendTagInteractionWithANamedParam(tag, "value", valor);
              //print(tag + " { value: " + valor + " }");
            }

          }

        }

      }else{ // Es de los adicionales


        Map<String, dynamic> esta_seccion = Map<String, dynamic>();

        esta_seccion["seccion"] = seccion.nombreRequestCotizacion; //Generales
        if(seccion.nombreRequestCotizacion == "requestLabel"){
          esta_seccion["seccion"] = "";
        }

        if(seccion.children_secc.length > 0){ //si es vacía

          if(seccion.children_secc[0].id_valor==null){
            esta_seccion["cotizador-no_dependientes"] = seccion.children_secc.length; //Generales
            seccionAdicionales.add(newTag("Adicional / No. Dependientes", seccion.children_secc.length));
          }

          int idPersona = 1;
          for (var secc_hija in seccion.children_secc){

            List<Campo> campos = List<Campo>();
            campos = obtenerCamposSimplificados(campos, secc_hija.campos);


            for(var campo in campos){
              Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);
              bool seEncuentraEnListaNegra = false;
              for(var ref in Utilidades.listaCamposNoAnalytics){
                if(ref.equals(esteCampo)){
                  seEncuentraEnListaNegra = true;
                }
              }
              if(seEncuentraEnListaNegra == false){

                //Formatear campo para agregarlo a parámetros.

                if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
                  //var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');

                  String num;
                  if(secc_hija.id_valor !=null){

                    num= (int.parse(secc_hija.id_valor)-1).toString();

                  }else{
                    num= idPersona.toString();
                  }

                  String paramaName = seccion.nombreRequestCotizacion+ "-"+num+"-"+campo.nombre_campo;
                  String prefijo;
                  if(int.parse(num) > 0){
                    prefijo = "Adicional " +num+ " / " + campo.etiqueta;
                  }else{
                    prefijo = "Titular / " + campo.etiqueta;
                  }


                  //Formatear nombre de paranmetro

                  //tag = tag.toUpperCase();
                  dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
                  if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
                    Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
                    valor = _valor.descripcion;
                    valor = valor == 'ocultar' ? 'No' : valor;
                    valor = valor == 'mostrar' ? 'Si' : valor;
                  }
                  if( paramaName.contains('riesgo_selecto') ){
                    valor = valor == 'true' ? 'Selecto' : 'Normal' ;
                  }
                  valor = valor == 'true' ? 'Si' : valor;
                  valor = valor == 'false' ? 'No' : valor;
                  esta_seccion[paramaName] = valor; //Agregar a parámetros
                  //sendTagInteractionWithANamedParam(tag, "value", valor);
                  seccionAdicionales.add(newTag(prefijo, valor));
                  //print(tag + " { value: " + valor + " }");
                }else{
                  String num;
                  if(secc_hija.id_valor !=null){

                    num= (int.parse(secc_hija.id_valor)-1).toString();

                  }else{
                    num= idPersona.toString();
                  }

                  String paramaName = seccion.nombreRequestCotizacion+ "-"+num+"-"+campo.nombre_campo;
                  String prefijo;
                  if(int.parse(num) > 0){
                    prefijo = "Adicional " +num+ " / " + campo.etiqueta;
                  }else{
                    prefijo = "Titular / " + campo.etiqueta;
                  }
                  //Formatear nombre de paranmetro

                  //tag = tag.toUpperCase();
                  dynamic valor = campo.getValorFormatted()!=null ? campo.getValorFormatted().toString() : seccion.seccion;
                  if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
                    Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
                    valor = _valor.descripcion;
                    valor = valor == 'ocultar' ? 'No' : valor;
                    valor = valor == 'mostrar' ? 'Si' : valor;
                  }
                  if( paramaName.contains('riesgo_selecto') ){
                    valor = valor == 'false' ? 'Normal' : 'Normal' ;
                  }
                  valor = valor == 'true' ? 'Si' : valor;
                  valor = valor == 'false' ? 'No' : valor;
                  esta_seccion[paramaName] = valor; //Agregar a parámetros
                  seccionAdicionales.add(newTag(prefijo, valor));
                }

              }
            }

            idPersona ++;
          }
        }

        lista_secciones.add(esta_seccion);
      }
    }

    return seccionAdicionales;


  }

  static List<Map<String, dynamic>> generarSeccionDatosCotizador() {

    List<Map<String, dynamic>> seccionDatos = new List<Map<String, dynamic>>();
    String prefijo = "Datos Generales Cotizador";
    seccionDatos.add(CotizadorAnalitycsTags.newTag(prefijo + " / Id Aplicación", Utilidades.idAplicacion.toString()));
    seccionDatos.add(CotizadorAnalitycsTags.newTag(prefijo + " / Tipo de Negocio", Utilidades.tipoDeNegocio));
    seccionDatos.add(CotizadorAnalitycsTags.newTag(prefijo + " / Id Participante", datosUsuario.idparticipante));

    return seccionDatos;

  }

  static List<Map<String, dynamic>> generarSeccionCalculo(Response response) {

    List<dynamic> datosAsegurados = new List<dynamic>();
    List<Map<String, dynamic>> seccionCalculo = new List<Map<String, dynamic>>();

    //SECCIÓN: calculo Analytics
   // String numeroPagos = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["numeroPagos"].toString();
    String primaBase = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaBase"].toStringAsFixed(2);
    String iva = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["iva"].toStringAsFixed(2);
    String primaTotal = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaTotal"].toStringAsFixed(2);
    String recargoPagoFraccionado = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["recargoPagoFraccionado"].toStringAsFixed(2);
   /* String primaComisionable = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["primaComisionable"].toStringAsFixed(2);
    String porcentajeComision = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["porcentajeComision"].toStringAsFixed(2);
    String comision = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["comision"].toStringAsFixed(2);*/
    String parcialidad = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["parcialidad"].toStringAsFixed(2);
    String derechoPoliza = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["derechoPoliza"].toStringAsFixed(2);

    String prefijo = "Resultado del Cálculo";

    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Prima Neta", primaBase.toString()));
    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / IVA", iva.toString()));
    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Prima Total", primaTotal.toString()));
    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Recargo Pago Fraccionado", recargoPagoFraccionado.toString()));
    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Parcialidad", parcialidad.toString()));
    seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Derecho Póliza", derechoPoliza.toString()));

    datosAsegurados = json.decode(response.body)["motorDinamicoResponse"]["formasPago"][0]["detalleFormaPago"]["asegurados"];
    if(datosAsegurados != null){
      if(datosAsegurados.length > 0){

        //Búsqueda de datos por asegurado
        for(int i = 0; i < datosAsegurados.length; i++){

          String aseguradoPB= datosAsegurados[i]["primaBase"].toStringAsFixed(2);
          String aseguradoRPF = datosAsegurados[i]["recargoPagoFraccionado"].toStringAsFixed(2);
          String aseguradoDP = datosAsegurados[i]["derechoPoliza"].toStringAsFixed(2);
          String aseguradoiva = datosAsegurados[i]["iva"].toStringAsFixed(2);
          String aseguradoPT = datosAsegurados[i]["primaTotal"].toStringAsFixed(2);
         /* String aseguradoPrimaC = datosAsegurados[i]["primaComisionable"].toStringAsFixed(2);
          String aseguradoPorC = datosAsegurados[i]["porcentajeComision"].toStringAsFixed(2);
          String aseguradoCom = datosAsegurados[i]["comision"].toStringAsFixed(2);*/
          String idAseg;
          if((datosAsegurados[i]["idAsegurado"]).toString() == "1"){
            idAseg = "Titular";
          }else{
            idAseg = "Asegurado " + (datosAsegurados[i]["idAsegurado"]-1).toString();
          }

          seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Prima Base $idAseg", aseguradoPB.toString()));
          seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Recargo Pago Fraccionado $idAseg", aseguradoRPF.toString()));
          seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Derecho Póliza $idAseg", aseguradoDP.toString()));
          seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / IVA $idAseg", aseguradoiva.toString()));
          seccionCalculo.add(CotizadorAnalitycsTags.newTag(prefijo + " / Prima Total $idAseg", aseguradoPT.toString()));
          return seccionCalculo;
        }
      }
    }
  }

  static enviarTags(BuildContext context, List<Map<String,dynamic>> listTags){
    for(int j=0; j<listTags.length; j++){
      Utilidades.sendAnalytics(context,listTags[j]["ea"],listTags[j]["el"]);
    }

  }


}