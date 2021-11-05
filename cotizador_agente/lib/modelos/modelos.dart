import 'dart:collection';
import 'dart:convert';

import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos/response_cotizacion/motor_dinamico_forma_pago.dart';
import 'package:cotizador_agente/modelos/response_cotizacion/resumen_cotizacion_forma_pago.dart';
import 'package:cotizador_agente/utils/Utils.dart';

class CotizacionesApp {
  List<FormularioCotizacion> listaCotizaciones = List<FormularioCotizacion>();

  bool agregarCotizacion(FormularioCotizacion formularioCotizacion) {

    //Invalidar folios de Formato Comparativa

    if (listaCotizaciones.length <= 3) {
      if(listaCotizaciones.length == 3){
        return false;
      } else {
        listaCotizaciones.add(formularioCotizacion);
        return true;
      }
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
  Map<String, dynamic> jsonComparativa;
  String idPlan;
  Map<String, dynamic> responseCotizacion;
  String requestCotizacion;
  List<ResumenCotizacionFormaPago> formasPago;
  List<MotorDinamicoFormaPago> motorDinamicoFormasPago;

  bool esValido = false;
  bool seCotizo = false;

  FormularioCotizacion({this.paso1, this.paso2});




  Regla calcularReglas(){

    for (int i = 0; i<paso1.secciones.length; i++){
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

    List<Regla> reglas = new List<Regla>();

    print("incia calculación de reglas******");

    for (int i = 0; i<paso2.secciones.length; i++){
      Regla reglaAcumulada;
      String mensaje = "";
      if(paso2.secciones[i].reglasNegocio!=null){
        if(paso2.secciones[i].reglasNegocio.length>0){
          for (int j=0; j<paso2.secciones[i].reglasNegocio.length; j++){
            print("Calculando regla: "+ paso2.secciones[i].reglasNegocio[j].mensaje);
            for(int k=0; k<paso2.secciones[i].reglasNegocio[j].operaciones.length; k++){

              final operation = paso2.secciones[i].reglasNegocio[j].operaciones[k];
              bool resultadoRegla = operation.calcularOperacion();
              if(resultadoRegla==true){
                if(paso2.secciones[i].reglasNegocio[j].tipoRegla == Utilidades.REGLA_STOPPER){

                  reglaAcumulada = Regla(tipoRegla: Utilidades.REGLA_STOPPER, mensaje: mensaje);

                }
                reglas.add(paso2.secciones[i].reglasNegocio[j]);

                mensaje += paso2.secciones[i].reglasNegocio[j].mensaje + "\n";
              }
            }
          }
          if(reglaAcumulada != null){
            reglaAcumulada = Regla(tipoRegla: Utilidades.REGLA_STOPPER, mensaje: mensaje);
            return reglaAcumulada;
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

    map["cotizacionGMMRequest"]["idPlan"] = idPlan;
    print("valorPlan/// $idPlan");

    List<int> planesPRevios = List<int>();

    int total =  Utilidades.cotizacionesApp.getCurrentLengthLista();

    for(int i=0; i<total-1; i++){
      if(Utilidades.cotizacionesApp.getCotizacionElement(i).comparativa!=null){
        planesPRevios.add(int.parse(Utilidades.buscaCampoPorFormularioID(i,Utilidades.referenciaPlan.id_seccion, Utilidades.referenciaPlan.id_campo, false)[0].valor));
        //planesPRevios.add(int.parse(idPlan));
      }
    }

    map["cotizacionGMMRequest"]["planesPrevios"] = planesPRevios;
    print("PLANES PREVIOS: " + planesPRevios.toString());

    //TODO: Hardcode id titular, siempre el uno
    map["cotizacionGMMRequest"]["titular"]["id"] = 1;

    //TODO: HARCODED Para sólo un usuario, revisar para múltiples asegurados
    map["cotizacionGMMRequest"]["descuentos"][0]["idPersona"] = 1;

    //TODO:Se eliminaba el contratante por que el codigo postal no se estaba enviando.

    print("JSON COMPARATIVA: " + map.toString());

    return map;
  }

  String obtenerValorEtiqueta(dynamic valor, Campo c){
    if(c.valores != null) {
      if (c.valores.length > 0) {
        for (int i = 0; i < c.valores.length; i++) {
          if (c.valores[i].id == valor.toString()) {
            return c.valores[i].descripcion;
          }
        }
      } else {
        return c.valores[0].descripcion;
      }
    } else {
      return "";
    }
  }

  List<Map<String, dynamic>> obtenerListaCamposCamparativa(List<Map<String, dynamic>> acumCampos, List<Campo> campos) {
    for (int i = 0; i < campos.length; i++) {
      Campo c = campos[i];
      if (c.valores != null) {
        if (c.valores.length > 0) {

          if(c.nombre_campo != "nombre_completo" && c.nombre_campo != "label_divider") {
            Map<String, dynamic> campo = {
              //Tiene valores, puede que tenga hijos o no, pero se agrega el campo
              "valor": c.getValorFormatted(),
              "idCampo": c.id_campo,
              "etiqueta": c.nombre_campo,
              "valorString": obtenerValorEtiqueta(c.getValorFormatted(), c)
            };
            acumCampos.add(campo);
          }

          for (int j = 0; j < c.valores.length; j++) {
            Valor valor = c.valores[j];
            if (valor.children != null) {
              if (valor.children.length > 0) {
                //Tiene hijos, evaluar los hijos y agregar al acumulador

                if (valor.id == c.valor) {
                  List<Map<String, dynamic>> campos_hijos =
                  List<Map<String, dynamic>>();


                  acumCampos.addAll(obtenerListaCamposCamparativa(campos_hijos, valor.children));
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
                            obtenerListaCamposCamparativa(campos_hijos, hijosFiltrados));

                      }
                    }else{
                      acumCampos.addAll(
                          obtenerListaCamposCamparativa(campos_hijos, valor.children));
                    }


                  }
                }
              }
            }
          }


        }
      } else {
        //Es un campo sin valores, se agrega a la lista
        if(c.nombre_campo != "nombre_completo" && c.nombre_campo != "label_divider") {
          Map<String, dynamic> campo = {
            "valor": c.getValorFormatted(),
            "idCampo": c.id_campo,
            "etiqueta": c.nombre_campo,
            "valorString": obtenerValorEtiqueta(c.getValorFormatted(), c)
          };
          acumCampos.add(campo);
        }
      }
    }

    //Terminé de evaluar la lista de campos (hijos o de raíz)
    return acumCampos;
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
            "valorString": obtenerValorEtiqueta(c.getValorFormatted(), c),
            "tipo_componente": c.tipo_componente,
            "label": c.etiqueta,
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


                  acumCampos.addAll(obtenerListaCampos(campos_hijos, valor.children));
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
          "valorString": c.getValorFormatted(),
          "tipo_componente": c.tipo_componente,
          "label": c.etiqueta,
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
                  }else if(c.valor == null && c.valores.length == 1 && c.tipo_componente == "select"){
                    c.valor = c.valores[0].id;
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



  Map<String, dynamic> generarResponseResumenComparativa() {
    //todos los datos del formulario (Paso1 y paso 2)

    List<Map<String, dynamic>> secciones = List<Map<String, dynamic>>();
    paso1.secciones.forEach((s) {
      if (s.multiplicador > 0) {
        List<Map<String, dynamic>> lista_asegurqados =
        List<Map<String, dynamic>>();

        for (int i = 0; i < s.children_secc.length; i++) {
          Seccion s_child = s.children_secc[i];
          List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();

          campos = obtenerListaCamposCamparativa(campos, s_child.campos);

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
        campos = obtenerListaCamposCamparativa(campos, s.campos);

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

    Map<String, dynamic> seccionPlan = {
      "nombre": "planes",
      "valores": [
        {
          "valor": secciones.elementAt(0)["valores"][2]["valor"].toString(),
          "idCampo": secciones.elementAt(0)["valores"][2]["idCampo"],
          "etiqueta": "id_plan",
          "valorString": secciones.elementAt(0)["valores"][2]["valorString"]
        }
      ],
      "idSeccion": 6
    };

    secciones.add(seccionPlan);

    paso2.secciones.forEach((s) {
      if (s.multiplicador > 0) {
        List<Map<String, dynamic>> lista_asegurqados =
        List<Map<String, dynamic>>();

        for (int i = 0; i < s.children_secc.length; i++) {
          Seccion s_child = s.children_secc[i];
          List<Map<String, dynamic>> campos = List<Map<String, dynamic>>();

          campos = obtenerListaCamposCamparativa(campos, s_child.campos);

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
        campos = obtenerListaCamposCamparativa(campos, s.campos);

        Map<String, dynamic> seccion = {
          "nombre": s.nombreRequestCotizacion,
          "valores": campos,
          "idSeccion": s.id_seccion
        };

        secciones.add(seccion);
      }
    });

    Map<String, dynamic> responseResumen = {
      "seccion": secciones,
      "idParticipante": datosUsuario.idparticipante.toString(),
      "nombreParticipante": datosUsuario.givenname,
      "parametroCotizador": Utilidades.idAplicacion,
    };

    print("NUEVO RESPONSE RESUMEN" + json.encode(responseResumen));

    return responseResumen;
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
      "idParticipante": datosUsuario.idparticipante.toString(),
      "nombreParticipante": datosUsuario.givenname,
      "parametroCotizador": Utilidades.idAplicacion,
      "seccion": secciones,
    };

    print("NUEVO RESPONSE RESUMEN" + json.encode(responseResumen));

    return responseResumen;
  }
}

class PasoFormulario {
  int id_aplicacion;
  List<Seccion> secciones;
  String nombre;
  String descripcion;
  int cantidad_asegurados;
  String estatus;
  Estilos estilos;
  String raizRequestCotizacion;
  String urlSiguiente;
  List<PropiedadConfiguracionRequest> camposRequestCotizacion;
  List<Documento> documentos;
  List<Documento> documentos_configuracion;

  PasoFormulario({
    this.id_aplicacion,
    this.secciones,
    this.nombre,
    this.descripcion,
    this.cantidad_asegurados,
    this.estatus,
    this.estilos,
    this.raizRequestCotizacion,
    this.urlSiguiente,
    this.camposRequestCotizacion,
    this.documentos,
    this.documentos_configuracion,
  });

  PasoFormulario copy() {
    final json = toJson2();
    final jsonString = jsonEncode(json);
    final jsonCopy = jsonDecode(jsonString);
    return PasoFormulario.fromJson2(jsonCopy);
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
            print("Este campo no es valida " + s.campos[j].etiqueta +
                s.campos[j].valor);
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

              if (resultado != null) {
                if (resultado.visibleLocal) {
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
                  if ((current_valor.id == current_campo.valor) ||
                      busquedaProfunda) {
                    Campo buscar = buscarCampoPorID(
                        current_valor.children, id, busquedaProfunda);
                    if (buscar != null) {
                      return buscar;
                    }
                  } else {
                    if (((current_campo.tipo_dato == "boolean" ||
                        current_campo.tipo_componente == "toggle" ||
                        current_campo.tipo_componente == "date_relativa") &&
                        (current_campo.valor == "true") ||
                        current_campo.tipo_componente == "date_relativa") ||
                        busquedaProfunda) {
                      print(
                          "Busqueda profunda: " + busquedaProfunda.toString());

                      Campo buscar =
                      buscarCampoPorID(
                          current_valor.children, id, busquedaProfunda);
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
      if (secc.id_seccion.toString() == idSeccion.toString()) {
        secc.filtrarSeccion(filtro);
      }
    });
  }

  factory PasoFormulario.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['secciones'] != null
        ? parsedJson['secciones'] as List
        : parsedJson['seccionesPlan'] as List;
    List<Seccion> secc = list?.map((i) => Seccion.fromJson(i))?.toList();

    var list_raw_configs = parsedJson["camposRequestCotizacion"] as List;
    List<PropiedadConfiguracionRequest> configs = list_raw_configs
        ?.map((i) => PropiedadConfiguracionRequest.fromJson(i))
        ?.toList();

    var list_raw_docs = parsedJson["documentos"] != null
        ? parsedJson["documentos"] as List
        : List();
    List<Documento> docs;
    if (list?.length > 0) {
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
      urlSiguiente: parsedJson["urlSiguiente"],
      camposRequestCotizacion: configs,
      documentos: docs != null ? docs : new List<Documento>(),
      documentos_configuracion: docs_conf != null ? docs_conf : new List<
          Documento>(),

    );
  }

  Map<String, dynamic> toJson2() =>
      {
        "id_aplicacion": id_aplicacion,
        "secciones": (secciones != null && secciones.isNotEmpty)
            ? List<dynamic>.from(secciones.map((e) => e.toJson2()))
            : [],
        "nombre": nombre,
        "descripcion": descripcion,
        "cantidad_asegurados": cantidad_asegurados,
        "estatus": estatus,
        "estilos": estilos?.toJson2(),
        "raizRequestCotizacion": raizRequestCotizacion,
        "camposRequestCotizacion": (camposRequestCotizacion != null &&
            camposRequestCotizacion.isNotEmpty)
            ? List<dynamic>.from(
            camposRequestCotizacion.map((e) => e.toJson2()))
            : [],
        "documentos": (documentos != null && documentos.isNotEmpty)
            ? List<dynamic>.from(documentos.map((e) => e.toJson2()))
            : [],
        "documentos_configuracion": (documentos_configuracion != null &&
            documentos_configuracion.isNotEmpty)
            ? List<dynamic>.from(
            documentos_configuracion.map((e) => e.toJson2()))
            : [],
      };

  factory PasoFormulario.fromJson2(Map<String, dynamic> json) {
    final jsonSecciones = json["secciones"];
    final jsonCamposRequestCotizacion = json["camposRequestCotizacion"];
    final jsonDocumentos = json["documentos"];
    final jsonDocumentosConfiguracion = json["documentos_configuracion"];
    final jsonEstilos = json["estilos"];
    return PasoFormulario(
      id_aplicacion: json["id_aplicacion"],
      secciones: (jsonSecciones != null && jsonSecciones.isNotEmpty)
          ? List<Seccion>.from(jsonSecciones.map((x) => Seccion.fromJson2(x)))
          : <Seccion>[],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      cantidad_asegurados: json["cantidad_asegurados"],
      estatus: json["estatus"],
      estilos: jsonEstilos != null ? Estilos.fromJson2(json["estilos"]) : null,
      raizRequestCotizacion: json["raizRequestCotizacion"],
      camposRequestCotizacion: (jsonCamposRequestCotizacion != null &&
          jsonCamposRequestCotizacion.isNotEmpty)
          ? List<PropiedadConfiguracionRequest>.from(jsonCamposRequestCotizacion
          .map((x) => PropiedadConfiguracionRequest.fromJson2(x)))
          : <PropiedadConfiguracionRequest>[],
      documentos: (jsonDocumentos != null && jsonDocumentos.isNotEmpty)
          ? List<Documento>.from(
          jsonDocumentos.map((x) => Documento.fromJson2(x)))
          : <Documento>[],
      documentos_configuracion: (jsonDocumentosConfiguracion != null &&
          jsonDocumentosConfiguracion.isNotEmpty)
          ? List<Documento>.from(jsonDocumentosConfiguracion
          .map((x) => Documento.fromJson2(x)))
          : <Documento>[],
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

  Map<String, dynamic> toJson2() => {
    "seccion": seccion,
    "campo": campo,
  };

  factory PropiedadConfiguracionRequest.fromJson2(Map<String, dynamic> json) {
    final jsonCampos = json['campo'];
    return PropiedadConfiguracionRequest(
      seccion: json["seccion"],
      campo: (jsonCampos != null && jsonCampos.isNotEmpty)
          ? List<int>.from(jsonCampos.map((x) => x)) : <int>[],
    );
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

  Map<String, dynamic> toJson2() => {
    "colorPrimario": colorPrimario,
    "colorSecundario": colorSecundario,
    "colorSombra": colorSombra,
    "colorTitulo": colorTitulo,
    "colorTexto": colorTexto,
    "bannerUrl": bannerUrl,
  };

  factory Estilos.fromJson2(Map<String, dynamic> json) => Estilos(
    colorPrimario: json["colorPrimario"],
    colorSecundario: json["colorSecundario"],
    colorSombra: json["colorSombra"],
    colorTitulo: json["colorTitulo"],
    colorTexto: json["colorTexto"],
    bannerUrl: json["bannerUrl"],
  );
}

class Regla {
  final int idRegla;
  final int tipoRegla;
  final int seccion;
  final String mensaje;
  final List<OperacionRegla> operaciones; // definicionRegla


  Regla({
    this.idRegla,
    this.tipoRegla,
    this.seccion,
    this.mensaje,
    this.operaciones,
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

  Map<String, dynamic> toJson2() =>
      {
        "idRegla": idRegla,
        "tipoRegla": tipoRegla,
        "seccion": seccion,
        "mensaje": mensaje,
        "operaciones": (operaciones != null && operaciones.isNotEmpty)
            ? List<dynamic>.from(operaciones.map((e) => e.toJson2()))
            : [],
      };

  factory Regla.fromJson2(Map<String, dynamic> json) {
    final jsonOperaciones = json["operaciones"];

    return Regla(
      idRegla: json["idRegla"],
      tipoRegla: json["tipoRegla"],
      seccion: json["seccion"],
      mensaje: json["mensaje"],
      operaciones: (jsonOperaciones != null && jsonOperaciones.isNotEmpty)
          ? List<OperacionRegla>.from(
          jsonOperaciones.map((x) => OperacionRegla.fromJson2(x)))
          : <OperacionRegla>[],
    );
  }
}
class OperacionRegla {

  final List <Operando> operandos;
  final String operacion;

  OperacionRegla({
    this.operandos,
    this.operacion,
  });


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

        bool res = valor_1.toString() == valor_2.toString();
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

  Map<String, dynamic> toJson2() =>
      {
        "operandos": (operandos != null && operandos.isNotEmpty)
            ? List<dynamic>.from(operandos.map((e) => e.toJson2()))
            : [],
        "operacion": operacion,
      };

  factory OperacionRegla.fromJson2(Map<String, dynamic> json) {
    final jsonOperandos = json["operandos"];
    return OperacionRegla(
      operandos: (jsonOperandos != null && jsonOperandos.isNotEmpty)
          ? List<Operando>.from(jsonOperandos.map((x) => Operando.fromJson2(x)))
          : <Operando>[],
      operacion: json["operacion"],
    );
  }
}

class Operando{

  final dynamic operando; //un numero o string con el que se va a comparar
  final int referencia_id; // un campo que hay que buscar en el formulario
  final int referencia_seccion; // un campo que hay que buscar en el formulario
  final OperacionRegla child_operacion; //este valor es el resultado de una operación.
  final String nombreComponente;

  Operando({
    this.operando,
    this.referencia_id,
    this.child_operacion,
    this.referencia_seccion,
    this.nombreComponente,
  });

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

  Map<String, dynamic> toJson2() => {
    "operando": operando,
    "referencia_id": referencia_id,
    "child_operacion": child_operacion?.toJson2(),
    "referencia_seccion": referencia_seccion,
    "nombreComponente": nombreComponente,
  };

  factory Operando.fromJson2(Map<String, dynamic> json) {
    final jsonChildOperacion = json["child_operacion"];
    return Operando(
      operando: json["operando"],
      referencia_id: json["referencia_id"],
      child_operacion: jsonChildOperacion != null
          ? OperacionRegla.fromJson2(json["child_operacion"])
          : null,
      referencia_seccion: json["referencia_seccion"],
      nombreComponente: json["nombreComponente"],
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
  bool opened = true;
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
    this.opened,
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
        print("campo----> ${campo.id_seccion}");
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
            visibleLocal: campo.visibleLocal,
            oculta: campo.oculta);

        nuevosCampos.add(c);
      });

      children_secc.add(Seccion(
          id_seccion: this.id_seccion,
          campos: nuevosCampos,
          multiplicador: 0,
          seccion: "Adicional " + (cont_child).toString()));
    }
  }

  addChildFamiliares(String nombre, String ApellidoP, String ApellidoM, String sexo,String edad,  String cp, String fecha, String riengoSelecto, String garantiaCoaseguro) {
    if (this.multiplicador > 0) {
      cont_child = children_secc.length>0 ? children_secc.length + 1 : cont_child + 1 ;

      List<Campo> nuevosCampos = List<Campo>();

      this.campos.forEach((campo) {
        print("campo----> ${campo.id_seccion}");
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
            visibleLocal: campo.visibleLocal,
            oculta: campo.oculta);

        nuevosCampos.add(c);
      });

      Seccion temp = Seccion(
          id_seccion: this.id_seccion,
          campos: nuevosCampos,
          multiplicador: 0,
          seccion: "Adicional " + (cont_child).toString());

      for(int i = 0; i < temp.campos.length; i++){
        if(i == 1 && nombre != ""){
          temp.campos[i].valor = nombre;
        } else if(i == 2 && ApellidoP != ""){
          temp.campos[i].valor = ApellidoP;
        } else if(i == 3 && ApellidoM != ""){
          temp.campos[i].valor = ApellidoM;
        } else if (i == 4){
          temp.campos[i].valor = sexo;
        } else if (i == 5 && edad != ""){
          temp.campos[i].valor = edad;
        } else if (i == 7 && cp != ""){
          temp.campos[i].valor = cp;
        } else if (i == 6){
          temp.campos[i].valor = fecha;
        } else if(i == 9){
          temp.campos[i].valor = riengoSelecto;
        } else if(i == 10){
          temp.campos[i].valor = garantiaCoaseguro;
        }
      }

      children_secc.add(temp);

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
      opened: parsedJson["opened"] ?? true,
    );
  }

  Map<String, dynamic> toJson2() => {
    "reglasNegocio": (reglasNegocio != null && reglasNegocio.isNotEmpty)
        ? List<dynamic>.from(reglasNegocio?.map((e) => e.toJson2()))
        : [],
    "id_seccion": id_seccion,
    "campos": (campos != null && campos.isNotEmpty)
        ? List<dynamic>.from(campos.map((e) => e.toJson2()))
        : [],
    "seccion": seccion,
    "multiplicador": multiplicador,
    "children_secc": (children_secc != null && children_secc.isNotEmpty)
        ? List<dynamic>.from(children_secc.map((e) => e.toJson2()))
        : [],
    "id_filtrado": id_filtrado,
    "filtrable": filtrable,
    "children_secc_sin_filtro": (children_secc_sin_filtro != null &&
        children_secc_sin_filtro.isNotEmpty)
        ? List<dynamic>.from(
        children_secc_sin_filtro.map((e) => e.toJson2()))
        : [],
    "nombreRequestCotizacion": nombreRequestCotizacion,
    "id_valor": id_valor,
    "opened": opened,
  };

  factory Seccion.fromJson2(Map<String, dynamic> json) {
    final jsonReglasNegocio = json["reglasNegocio"];
    final jsonCampos = json["campos"];
    final jsonChildrenSecc = json["children_secc"];
    final jsonChildrenSeccSinFiltro = json["children_secc_sin_filtro"];

    final seccion = Seccion(
      reglasNegocio: (jsonReglasNegocio != null && jsonReglasNegocio.isNotEmpty)
          ? List<Regla>.from(
          json["reglasNegocio"].map((x) => Regla.fromJson2(x)))
          : null,
      id_seccion: json["id_seccion"],
      campos: (jsonCampos != null && jsonCampos.isNotEmpty)
          ? List<Campo>.from(jsonCampos.map((x) => Campo.fromJson2(x)))
          : <Campo>[],
      seccion: json["seccion"],
      multiplicador: json["multiplicador"],
      children_secc: (jsonChildrenSecc != null && jsonChildrenSecc.isNotEmpty)
          ? List<Seccion>.from(
          jsonChildrenSecc.map((x) => Seccion.fromJson2(x)))
          : [],
      id_filtrado: json["id_filtrado"],
      filtrable: json["filtrable"],
      children_secc_sin_filtro: (jsonChildrenSeccSinFiltro != null &&
          jsonChildrenSeccSinFiltro.isNotEmpty)
          ? List<Seccion>.from(
          jsonChildrenSeccSinFiltro?.map((x) => Seccion.fromJson2(x)))
          : null,
      nombreRequestCotizacion: json["nombreRequestCotizacion"],
      id_valor: json["id_valor"],
      opened: json["opened"],
    );
    seccion.cont_child = json["cont_child"] ?? 0;

    return seccion;
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
            return  valores != null ? valores[0].id : 1;
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

  Map<String, dynamic> toJson2() => {
    "rangoRelativa": (rangoRelativa != null && rangoRelativa.isNotEmpty)
        ? List<dynamic>.from(rangoRelativa.map((e) => e.toJson2()))
        : [],
    "regla_catalogo": regla_catalogo?.toJson2(),
    "id_campo": id_campo,
    "id_seccion": null,
    "campos_modificados":
    (campos_modificados != null && campos_modificados.isNotEmpty)
        ? List<dynamic>.from(campos_modificados.map((e) => e.toJson2()))
        : [],
    "reg_ex": reg_ex,
    "etiqueta": etiqueta,
    "obligatorio": obligatorio,
    "nombre_campo": nombre_campo,
    "tipo_dato": tipo_dato,
    "tipo_componente": tipo_componente,
    "visible": visible,
    "regla": regla,
    "valores": (valores != null && valores.isNotEmpty)
        ? List<dynamic>.from(valores.map((e) => e.toJson2()))
        : [],
    "rango": rango?.toJson2(),
    "view_ID": view_ID,
    "dato_longitud": dato_longitud,
    "valor": valor,
    "oculta": oculta,
    "seccion_dependiente": seccion_dependiente,
    "nombreRequestCotizacion": nombreRequestCotizacion,
    "valores_sin_filtro":
    (valores_sin_filtro != null && valores_sin_filtro.isNotEmpty)
        ? List<dynamic>.from(valores_sin_filtro.map((e) => e.toJson2()))
        : [],
    "checked": checked,
    "parent_campo": parent_campo?.toJson2(),
    "enabled": enabled,
    "visibleLocal": visibleLocal,
  };

  factory Campo.fromJson2(Map<String, dynamic> json) {
    final jsonRangoRelativa = json["rangoRelativa"];
    final jsonCamposModificados = json["campos_modificados"];
    final jsonValores = json["valores"];
    final jsonValoresSinFiltro = json["valores_sin_filtro"];
    final jsonReglaCatalogo = json["regla_catalogo"];
    final jsonParentCampo = json["parent_campo"];
    final jsonRango = json["rango"];
    final jsonDatoLongitud = json["dato_longitud"];
    return Campo(
      rangoRelativa: (jsonRangoRelativa != null && jsonRangoRelativa.isNotEmpty)
          ? List<FechaRelativa>.from(
          jsonRangoRelativa.map((x) => FechaRelativa.fromJson2(x)))
          : null,
      regla_catalogo: jsonReglaCatalogo != null
          ? FechaRelativa.fromJson2(json["regla_catalogo"])
          : null,
      id_campo: json["id_campo"],
      id_seccion: json["id_seccion"],
      campos_modificados:
      (jsonCamposModificados != null && jsonCamposModificados.isNotEmpty)
          ? List<Referencia>.from(
          jsonCamposModificados.map((x) => Referencia.fromJson2(x)))
          : [],
      reg_ex: json["reg_ex"],
      etiqueta: json["etiqueta"],
      obligatorio: json["obligatorio"],
      nombre_campo: json["nombre_campo"],
      tipo_dato: json["tipo_dato"],
      tipo_componente: json["tipo_componente"],
      visible: json["visible"],
      regla: json["regla"],
      valores: (jsonValores != null && jsonValores.isNotEmpty)
          ? List<Valor>.from(jsonValores.map((x) => Valor.fromJson2(x)))
          : null,
      rango: jsonRango != null ? Rango.fromJson2(json["rango"]) : null,
      view_ID: json["view_ID"],
      dato_longitud: (jsonDatoLongitud != null && jsonDatoLongitud.isNotEmpty)
          ? List<int>.from(jsonDatoLongitud)
          : null,
      valor: json["valor"],
      oculta: json["oculta"],
      seccion_dependiente: json["seccion_dependiente"],
      nombreRequestCotizacion: json["nombreRequestCotizacion"],
      valores_sin_filtro:
      (jsonValoresSinFiltro != null && jsonValoresSinFiltro.isNotEmpty)
          ? List<Valor>.from(
          jsonValoresSinFiltro.map((x) => Valor.fromJson2(x)))
          : null,
      checked: json["checked"],
      parent_campo: jsonParentCampo != null
          ? Referencia.fromJson2(json["parent_campo"])
          : null,
      enabled: json["enabled"],
      visibleLocal: json["visibleLocal"],
    );
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

  Map<String, dynamic> toJson2() => {
    "rango_inicio": rango_inicio,
    "rango_fin": rango_fin,
  };

  factory Rango.fromJson2(Map<String, dynamic> json) => Rango(
    rango_inicio: json["rango_inicio"],
    rango_fin: json["rango_fin"],
  );
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


  Valor({
    this.id,
    this.descripcion,
    this.oculta_campos,
    this.subnivel,
    this.child,
    this.id_filtrado,
    this.children,
    this.visible,
    this.icono,
    this.valor_default,
  });

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

  Map<String, dynamic> toJson2() => {
    "id": id,
    "descripcion": descripcion,
    "oculta_campos": (oculta_campos != null && oculta_campos.isNotEmpty)
        ? List<dynamic>.from(oculta_campos.map((e) => e.toJson2()))
        : [],
    "subnivel": subnivel,
    "child": child?.toJson2(),
    "id_filtrado": id_filtrado,
    "children": (children != null && children.isNotEmpty)
        ? List<dynamic>.from(children.map((e) => e.toJson2()))
        : [],
    "visible": visible,
    "icono": icono,
    "valor_default": valor_default,
  };

  factory Valor.fromJson2(Map<String, dynamic> json) {
    final jsonOcultaCampos = json["oculta_campos"];
    final jsonChildren = json["children"];
    final jsonChild = json["child"];
    return Valor(
      id: json["id"],
      descripcion: json["descripcion"],
      oculta_campos: (jsonOcultaCampos != null && jsonOcultaCampos.isNotEmpty)
          ? List<Referencia>.from(
          jsonOcultaCampos.map((x) => Referencia.fromJson2(x)))
          : <Referencia>[],
      subnivel: json["subnivel"],
      child: jsonChild != null ? Campo.fromJson2(json["child"]) : null,
      id_filtrado: json["id_filtrado"],
      children: (jsonChildren != null && jsonChildren.isNotEmpty)
          ? List<Campo>.from(jsonChildren.map((x) => Campo.fromJson2(x)))
          : <Campo>[],
      visible: json["visible"],
      icono: json["icono"],
      valor_default: json["valor_default"],
    );
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

  Map<String, dynamic> toJson2() =>
      {
        "nombreDocumento": nombreDocumento,
        "descDocumento": descDocumento,
        "productos": productos,
        "urlPDF": urlPDF,
        "id": id,
      };

  factory Documento.fromJson2(Map<String, dynamic> json) => Documento(
    id: json["id"],
    nombreDocumento: json["nombreDocumento"],
    descDocumento: json["descDocumento"],
    productos: json["productos"],
    urlPDF: json["urlPDF"],
  );
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
  final String url;
  final String urlCotizaciones;
  final String urlBorrar;
  final String urlVer;
  final String urlGuardar;
  final String urlCorreo;
  final String mensaje;

  Cotizadores(
      {this.id_aplicacion,
        this.cantidad_asegurados,
        this.aplicacion,
        this.descripcion,
        this.estatus,
        this.visible_movil,
        this.url,
        this.urlCotizaciones,
        this.urlBorrar,
        this.urlVer,
        this.urlGuardar,
        this.urlCorreo,
        this.mensaje,
      });

  factory Cotizadores.fromJson(Map<String, dynamic> parsedJson) {
    return Cotizadores(
        id_aplicacion: parsedJson["id_aplicacion"],
        aplicacion: parsedJson["aplicacion"],
        descripcion: parsedJson["descripcion"],
        cantidad_asegurados: parsedJson["cantidad_asegurados"],
        estatus: parsedJson["estatus"],
        visible_movil: parsedJson["visible_movil"],
        url: parsedJson["url"],
        urlCotizaciones: parsedJson["urlCotizaciones"],
        urlBorrar: parsedJson["urlBorrar"],
        urlVer: parsedJson["urlVer"],
        urlGuardar: parsedJson["urlGuardar"],
        urlCorreo: parsedJson["urlCorreo"],
        mensaje: parsedJson["mensaje"]
    );
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

  List<DetalleAsegurados> detalleAsegurados;

  Comparativa({this.formaspago, this.secciones, this.banComparativa, this.detalleAsegurados});

  factory Comparativa.fromJson(Map<String, dynamic> parsedJson) {

    var raw_Formaspago = parsedJson["resumenCotizacion"]["formasPago"] as List;
    var raw_DetalleAsegurados = parsedJson["resumenCotizacion"]["detalleAsegurados"] as List;
    print("FORMAS DE PAGO: " + raw_Formaspago.toString());

    var comp = parsedJson["resumenCotizacion"]["banComparativa"] as int;
    print("Comparativa: " + comp.toString());

    List<FormadePago> renglonesformas =
    raw_Formaspago.map((i) => FormadePago.fromJson(i)).toList();

    List<DetalleAsegurados> renglonesAsegurados =
    raw_DetalleAsegurados.map((i) => DetalleAsegurados.fromJson(i)).toList();

    var raw_Renglones = parsedJson["resumenCotizacion"]["secciones"] as List;
    List<SeccionComparativa> renglones =
    raw_Renglones.map((i) => SeccionComparativa.fromJson(i)).toList();

    return Comparativa(
        secciones: renglones,
        banComparativa: comp,
        formaspago: renglonesformas,
        detalleAsegurados: renglonesAsegurados
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

class DetalleAsegurados {
  final int id;
  final String primaBase;
  final String primaTotal;

  DetalleAsegurados({this.id, this.primaBase, this.primaTotal});

  factory DetalleAsegurados.fromJson(Map<String, dynamic> parsedJson) {
    return DetalleAsegurados(
        id: parsedJson["id"], primaBase: parsedJson["primaBase"], primaTotal: parsedJson["primaTotal"]);
  }
}

class Referencia {

  int id_seccion;
  int id_campo;
  int id_paso;

  Referencia({
    this.id_campo,
    this.id_seccion,
    this.id_paso,
  });

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

  Map<String, dynamic> toJson2() => {
    "id_campo": id_campo,
    "id_seccion": id_seccion,
    "id_paso": id_paso,
  };

  factory Referencia.fromJson2(Map<String, dynamic> json) => Referencia(
    id_campo: json["id_campo"],
    id_seccion: json["id_seccion"],
    id_paso: json["id_paso"],
  );
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

  Map<String, dynamic> toJson2() => {
    "dia": dia,
    "mes": mes,
    "anio": anio,
  };

  factory FechaRelativa.fromJson2(Map<String, dynamic> json) => FechaRelativa(
    dia: json["dia"],
    mes: json["mes"],
    anio: json["anio"],
  );
}
