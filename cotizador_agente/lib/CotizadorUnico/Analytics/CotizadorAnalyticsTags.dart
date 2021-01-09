
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';

class CotizadorAnalitycsTags {
  static const String cotizadorGMM = "gmm_cotizador_ingreso";
  static const String descargaGMM = "gmm_cotizador_descarga";
  static const String envioMailGMM = "gmm_cotizador_envioEmail";


  /*static void sendTagsFormulario(FormularioCotizacion formularioCotizacion) async {

    final FirebaseAnalytics analytics = new FirebaseAnalytics();

    List <Seccion> seccionesFormulario= List<Seccion> ();

    //Hacer copia local de los campos del formulario
    seccionesFormulario.addAll(backPaso1(formularioCotizacion.paso1.secciones));
    seccionesFormulario.addAll(backPaso1(formularioCotizacion.paso2.secciones));

    enviarTagsFormularioSeccion(analytics,seccionesFormulario);

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

  static void enviarTagsFormularioSeccion(FirebaseAnalytics analytics, List<Seccion> secciones) async {
    String tagName = 'gmm_cotizador_titular';

    //El método itera todos los campos para almacentarlos en dos listas: Adicionales y del Titular
    //DEspúes de acomodar todos los campos en listas liniales, luego entonces se envían los parámetros

    Map<String, dynamic> parameters_titular = Map<String, dynamic>();

    List <Campo> campos_titular = List<Campo> ();
    List <Seccion> secciones_adicionales  = List <Seccion> ();

    List <Campo> campos_adicionales = List<Campo> ();

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
            //sendTagInteractionWithANamedParam(tag, "value", valor);
            //print(tag + " { value: " + valor + " }");
          }

        }

      }

      // TAGGING
      num_adicional ++;
    }

    //tagging
    await analytics.logEvent(name: "gmm_cotizador_titular", parameters: parameters_titular);
    print("gmm_cotizador_titular");
    print(parameters_titular.toString());

  }

  static void sendTagsFormularioSeccion(FirebaseAnalytics analytics, String seccionTag, List<Seccion> secciones, Map<String, dynamic> parameters) async {
    String tagName = 'gmm_cotizador_titular';

    for(var seccion in secciones) {
      if (seccion.multiplicador == 0) {
        print('\n**************************************');
        sendTagsFormularioCampo(analytics, seccion, parameters);

        if(seccion.id_seccion == Utilidades.familiarSeccion) {
          tagName = 'gmm_cotizador_familiares_adicionales';
        }
        else {
          tagName = 'gmm_cotizador_titular';
        }

        //tagging
        await analytics.logEvent(name: tagName, parameters: parameters);

        print(tagName);
        print(parameters.toString());
        print('**************************************\n');
      }
      if (seccion.children_secc != null ) {
        sendTagsFormularioSeccion(analytics, (seccionTag + ( seccionTag.length>0 ? '_' : '' ) + seccion.seccion.replaceAll(new RegExp(r' '), '_')), seccion.children_secc, parameters);
      }
    }
  }

  static void sendTagsFormularioCampo(FirebaseAnalytics analytics, Seccion seccion, Map<String, dynamic> parameters) {
    for(var campo in seccion.campos) {

      Referencia esteCampo = Referencia(id_campo: campo.id_campo, id_seccion: seccion.id_seccion);

      bool seEncuentraEnListaNegra = false;

      for(var ref in Utilidades.listaCamposNoAnalytics){
        if(ref.equals(esteCampo)){
          seEncuentraEnListaNegra = true;
        }
      }

      if(!seEncuentraEnListaNegra){
        if (campo.visible == true) {  // + "-" + campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
          var paramaName = campo.nombre_campo.replaceAll(new RegExp(r'id_'), '');
          //tag = tag.toUpperCase();
          dynamic valor = campo.valor!=null ? campo.valor : seccion.seccion;
          if(campo.tipo_componente == Utilidades.tipoCampoSelect || campo.tipo_componente == Utilidades.tipoCampoToggle || campo.tipo_componente == Utilidades.tipoCampoSwitch) {
            Valor _valor = campo.valores.singleWhere((v) => v.id == valor);
            valor = _valor.descripcion;
            valor = valor == 'ocultar' ? 'No' : valor;
            valor = valor == 'mostrar' ? 'Si' : valor;
          }
          valor = valor == 'true' ? 'Si' : valor;
          valor = valor == 'false' ? 'No' : valor;
          parameters[paramaName] = valor;
          //sendTagInteractionWithANamedParam(tag, "value", valor);
          //print(tag + " { value: " + valor + " }");
        }
      }

    }
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

    List<Map<String, dynamic>> secciones_gtm = generarTagsGTM(seccionesFormulario);
    Utilidades.LogPrint("SECCIONES_GTM: " + secciones_gtm.toString());

    return  secciones_gtm;

  }

  static List<Map<String, dynamic>>  generarTagsGTM(List<Seccion> secciones) {

    //Lista de Secciones

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

                  Valor _valor = campo.valores.singleWhere((v) =>
                  v.id == valor);
                  if (_valor.id == "9" && valor == "9") {
                    campo.nombre_campo = definida;
                  }
                  else if (_valor.id == "15" && valor == "15") {
                    campo.nombre_campo = libre;
                  }
                }

              }

              String paramaName = seccion.nombreRequestCotizacion+ "-"+campo.nombre_campo;

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
              //sendTagInteractionWithANamedParam(tag, "value", valor);
              //print(tag + " { value: " + valor + " }");
            }

          }

        }

        lista_secciones.add(esta_seccion);
      }else{ // Es de los adicionales


        Map<String, dynamic> esta_seccion = Map<String, dynamic>();

        esta_seccion["seccion"] = seccion.nombreRequestCotizacion; //Generales
        if(seccion.nombreRequestCotizacion == "requestLabel"){
          esta_seccion["seccion"] = "";
        }

        if(seccion.children_secc.length > 0){ //si es vacía

          if(seccion.children_secc[0].id_valor==null){
            esta_seccion["cotizador-no_dependientes"] = seccion.children_secc.length; //Generales

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

                  String num;
                  if(secc_hija.id_valor !=null){

                    num= (int.parse(secc_hija.id_valor)-1).toString();

                  }else{
                    num= idPersona.toString();
                  }

                  String paramaName = seccion.nombreRequestCotizacion+ "-"+num+"-"+campo.nombre_campo;

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
                  //print(tag + " { value: " + valor + " }");
                }else{
                  String num;
                  if(secc_hija.id_valor !=null){

                    num= (int.parse(secc_hija.id_valor)-1).toString();

                  }else{
                    num= idPersona.toString();
                  }

                  String paramaName = seccion.nombreRequestCotizacion+ "-"+num+"-"+campo.nombre_campo;

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
                }

              }
            }

            idPersona ++;
          }
        }

        lista_secciones.add(esta_seccion);
      }
    }
    return lista_secciones;
  }
*/
}