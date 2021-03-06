import 'dart:io';

import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/material.dart';
class Utilidades {

  static bool tabCotizarSelect = false;
  // Campos que no deben ser enviados a Firebase para analytics

  static final List<Referencia> listaCamposNoAnalytics =[

    /*  DATOS DEL TITULAR */
    Referencia(id_seccion: 2, id_campo: 1), //NOMBRE TITULAR
    Referencia(id_seccion: 2, id_campo: 2), //Apellido 1 TITULAR
    Referencia(id_seccion: 2, id_campo: 3), //Apellido 2 TITULAR

    /*  DATOS DE LOS DEPENDIENTES */
    Referencia(id_seccion: 3, id_campo: 1), //NOMBRE TITULAR
    Referencia(id_seccion: 3, id_campo: 2), //Apellido 1 TITULAR
    Referencia(id_seccion: 3, id_campo: 3), //Apellido 2 TITULAR


    /*  DATOS DE CONTRATANTE DIFERENTE AL TITULAR */
    Referencia(id_seccion: 4, id_campo: 1), //NOMBRE TITULAR
    Referencia(id_seccion: 4, id_campo: 2), //Apellido 1 TITULAR
    Referencia(id_seccion: 4, id_campo: 3), //Apellido 2 TITULAR
    Referencia(id_seccion: 4, id_campo: 15), //Apellido 2 TITULAR


  ];

  static final List<Referencia> listaOrdenAnalytics = [
    Referencia(id_seccion: 1, id_paso: 1),
    Referencia(id_seccion: 2, id_paso: 1),
    Referencia(id_seccion: 3, id_paso: 1),
    Referencia(id_seccion: 4, id_paso: 1),
    Referencia(id_seccion: 6, id_paso: 2),
    Referencia(id_seccion: 7, id_paso: 2),
    Referencia(id_seccion: 8, id_paso: 2),
    Referencia(id_seccion: 11, id_paso: 2),
    Referencia(id_seccion: 6, id_paso: 1),
  ];


  static final int titularSeccion = 2;
  static final int titularCampo = 5;
  static const int familiarSeccion = 3;
  static final int familiarCampo = 5;
  static const int descuentoSeccion = 11;
  static final Referencia referenciaPlan = Referencia(id_seccion: 1, id_campo: 23);
  static const int FORMATO_COTIZACION = 1;
  static const int FORMATO_COMPARATIVA = 2;
  static const int FORMATO_COMISION = 3;
  static const int FORMATO_COTIZACION_AP = 5;//Cambia para Cotizador AP
  static const int FORMATO_COMISION_AP = 6;
  static final String tipoCampoSelect = "select";
  static final String tipoCampoToggle = "toggle";
  static final String tipoCampoSwitch = "switch";
  static final int REGLA_STOPPER = 2;
  static final int REGLA_INFO = 1;

  static bool isloadingPlan = true;
  static bool deboCargarPaso1 = false;
  static bool actualizarCodigoPostalAdicional = false;

  //variable utilizada para detonar el onChanged del ComboBoxDinamico
  static bool entroUrlPaso1 = false;

  //variables utilizada en el boton agregar nueva cotizacion
  static bool agregarNuevaCotizacion = false;
  static bool enviadoBotonAgregarCotizacion = false;

  //variables para cotizacion Editada A Recuperar
  static FormularioCotizacion cotizacionEditadaARecuperar;//listo
  static int indexcotizacionEditadaARecuperar;//listo
  static bool entroAEditar = false;//listo
  static bool terminoCotizacionEditada = false;//listo

  static bool cargarNuevoPaso;
  static bool editarEnComparativa = false;
  static bool isInternet = true;
  static bool isShowGMM = false;
  static String keyGTM = "aHR0cHM6Ly9taW5pZmllZC5jYy9hcGkvbWluaWZ5";
  static Map<String,dynamic> seccCot =  new Map<String,dynamic>();
  static List<Map<String, dynamic>> lista_seccionesC =  List<Map<String, dynamic>> ();

  static Color color_sombra =
  Color(int.parse("F3F4F5", radix: 16)).withOpacity(1.0);
  static Color color_titulo =
  Color(int.parse("002e71", radix: 16)).withOpacity(1.0);
  static Color color_primario =
  Color(int.parse("fc6c25", radix: 16)).withOpacity(1.0);
  static Color color_texto =
  Color(int.parse("000000", radix: 16)).withOpacity(1.0);
  static Color color_filtro =
  Color(int.parse("e4e4e4", radix: 16)).withOpacity(1.0);
  static Color color_texto_filtro =
  Color(int.parse("6c7480", radix: 16)).withOpacity(1.0);
  static Color color_texto_campo =
  Color(int.parse("343f61", radix: 16)).withOpacity(1.0);
  static Color color_texto_place_holder =
  Color(int.parse("343f61", radix: 16)).withOpacity(1.0);
  static Color color_switch_apagado =
  Color(int.parse("dcdcdc", radix: 16)).withOpacity(1.0);
  static Color color_mail =
  Color(int.parse("aac3ee", radix: 16)).withOpacity(1.0);
  static Color color_encabezado_guardados =
  Color(int.parse("6c7480", radix: 16)).withOpacity(1.0);

  static Comparativa currentComparativa;
  static int idAplicacion;
  static String  tipoDeNegocio;

  //NUEVAS URLS DEL SERVICIO
  static String url;
  static String urlSiguiente;
  static String urlCotizar;
  static String urlCotizaciones;
  static String urlBorrar;
  static String urlVer;
  static String urlGuardar;
  static String urlCorreo;

  //static Documento documentos_conf;

  static CotizacionesApp cotizacionesApp = new CotizacionesApp();

  static List<NegocioOperable> negociosOperables = new List<NegocioOperable>();

  static void resetEstilos() {
    color_sombra = Color(int.parse("F3F4F5", radix: 16)).withOpacity(1.0);
    color_titulo = Color(int.parse("002e71", radix: 16)).withOpacity(1.0);
    color_primario = Color(int.parse("fc6c25", radix: 16)).withOpacity(1.0);
    color_texto = Color(int.parse("000000", radix: 16)).withOpacity(1.0);
    color_filtro = Color(int.parse("e4e4e4", radix: 16)).withOpacity(1.0);
    color_texto_filtro = Color(int.parse("6c7480", radix: 16)).withOpacity(1.0);
    color_texto_campo = Color(int.parse("343f61", radix: 16)).withOpacity(1.0);
    color_texto_place_holder =
        Color(int.parse("343f61", radix: 16)).withOpacity(1.0);
  }

  static void setColorPrimario(String s) {
    color_primario =
        Color(int.parse(s.substring(1), radix: 16)).withOpacity(1.0);
  }

  static void setColorSecundario(String s) {
    color_titulo = Color(int.parse(s.substring(1), radix: 16)).withOpacity(1.0);
  }

  static void setColorTitulo(String s) {
    color_titulo = Color(int.parse(s.substring(1), radix: 16)).withOpacity(1.0);
  }

  static void setSombra(String s) {
    color_sombra = Color(int.parse(s.substring(1), radix: 16)).withOpacity(1.0);
  }

  static void setColorTexto(String s) {
    color_texto_campo =
        Color(int.parse(s.substring(1), radix: 16)).withOpacity(1.0);
  }

  //Solo sirve para el formulario actual.
  static List<Campo> buscaCampoPorID(
      int referencia_seccion, int referencia_id, bool busquedaProfunda) {
    List<Campo> campos = List<Campo>();
    PasoFormulario paso1 =
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1;

    //Buscar la Secci??n en paso 1
    for (int i = 0; i < paso1.secciones.length; i++) {
      //Repetir para paso 1 y paso 2
      if (paso1.secciones[i].id_seccion == referencia_seccion) {
        //Encontr?? la secci??n

        if (paso1.secciones[i].multiplicador > 0) {
          for (int j = 0; j < paso1.secciones[i].children_secc.length; j++) {
            Campo campo_resultado;
            campo_resultado = paso1.buscarCampoPorID(
                paso1.secciones[i].children_secc[j].campos,
                referencia_id,
                busquedaProfunda);
            if (campo_resultado != null) {
              campos
                  .add(campo_resultado); //Encontr?? el campo
            }
          }

          if (campos.length > 0) {
            return campos;
          }
        } else {
          Campo campo_resultado;
          campo_resultado = paso1.buscarCampoPorID(
              paso1.secciones[i].campos, referencia_id, busquedaProfunda);

          if (campo_resultado != null) {
            campos.add(campo_resultado);
            return campos; //Encontr?? el campo
          }
        }
      }
    }

    PasoFormulario paso2 =
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2;
    //Buscar la Secci??n en paso 2

    if (paso2 != null) {
      for (int i = 0; i < paso2.secciones.length; i++) {
        //Repetir para paso 1 y paso 2
        if (paso2.secciones[i].id_seccion == referencia_seccion) {
          //Encontr?? la secci??n

          if (paso2.secciones[i].multiplicador > 0) {
            for (int j = 0; j < paso2.secciones[i].children_secc.length; j++) {
              Campo campo_resultado;
              campo_resultado = paso2.buscarCampoPorID(
                  paso2.secciones[i].children_secc[j].campos,
                  referencia_id,
                  busquedaProfunda);
              if (campo_resultado != null) {
                campos.add(
                    campo_resultado.getValorFormatted()); //Encontr?? el campo
              }
            }

            if (campos.length > 0) {
              return campos; //Encontr?? los campos
            }
          } else {
            Campo campo_resultado;
            campo_resultado = paso2.buscarCampoPorID(
                paso2.secciones[i].campos, referencia_id, busquedaProfunda);

            if (campo_resultado != null) {
              campos.add(campo_resultado);
              return campos; //Encontr?? el campo
            }
          }
        }
      }
    }
  }

//// Sirve para el formulario index
  static List<Campo> buscaCampoPorFormularioID(int index_formulario,
      int referencia_seccion, int referencia_id, bool busquedaProfunda) {
    List<Campo> campos = List<Campo>();
    PasoFormulario paso1 =
        Utilidades.cotizacionesApp.getCotizacionElement(index_formulario).paso1;

    //Buscar la Secci??n en paso 1
    for (int i = 0; i < paso1.secciones.length; i++) {
      //Repetir para paso 1 y paso 2
      if (paso1.secciones[i].id_seccion == referencia_seccion) {
        //Encontr?? la secci??n

        if (paso1.secciones[i].multiplicador > 0) {
          for (int j = 0; j < paso1.secciones[i].children_secc.length; j++) {
            Campo campo_resultado;
            campo_resultado = paso1.buscarCampoPorID(
                paso1.secciones[i].children_secc[j].campos,
                referencia_id,
                busquedaProfunda);
            if (campo_resultado != null) {
              campos
                  .add(campo_resultado.getValorFormatted()); //Encontr?? el campo
            }
          }

          if (campos.length > 0) {
            return campos;
          }
        } else {
          Campo campo_resultado;
          campo_resultado = paso1.buscarCampoPorID(
              paso1.secciones[i].campos, referencia_id, busquedaProfunda);

          if (campo_resultado != null) {
            campos.add(campo_resultado);
            return campos; //Encontr?? el campo
          }
        }
      }
    }

    PasoFormulario paso2 = Utilidades.cotizacionesApp.getCotizacionElement(index_formulario).paso2;
    //Buscar la Secci??n en paso 2

    if (paso2 != null) {
      for (int i = 0; i < paso2.secciones.length; i++) {
        //Repetir para paso 1 y paso 2
        if (paso2.secciones[i].id_seccion == referencia_seccion) {
          //Encontr?? la secci??n

          if (paso2.secciones[i].multiplicador > 0) {
            for (int j = 0; j < paso2.secciones[i].children_secc.length; j++) {
              Campo campo_resultado;
              campo_resultado = paso2.buscarCampoPorID(
                  paso2.secciones[i].children_secc[j].campos,
                  referencia_id,
                  busquedaProfunda);
              if (campo_resultado != null) {
                campos.add(
                    campo_resultado.getValorFormatted()); //Encontr?? el campo
              }
            }

            if (campos.length > 0) {
              return campos; //Encontr?? los campos
            }
          } else {
            Campo campo_resultado;
            campo_resultado = paso2.buscarCampoPorID(
                paso2.secciones[i].campos, referencia_id, busquedaProfunda);

            if (campo_resultado != null) {
              campos.add(campo_resultado);
              return campos; //Encontr?? el campo
            }
          }
        }
      }
    }
  }

  static void mostrarAlerta(
      String titulo, String mensaje, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: AlertDialog(
            title: new Text(titulo),
            content: SingleChildScrollView(child: Column(
              children: [
                new Text(mensaje),
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  "Aceptar",
                  style: TextStyle(color: Utilidades.color_primario),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }static void mostrarAlertas(
      String titulo, String mensaje, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: AlertDialog(
            title: new Text(titulo),
            content: new Text(mensaje),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  "Aceptar",
                  style: TextStyle(color: Utilidades.color_primario),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  static void mostrarAlertaCallbackBorrar(String titulo, String mensaje,
      BuildContext context, Function negative, Function positive) {

    double alturaHeight = mensaje.length < 94 ? 216 : mensaje.contains("Esta acci??n no se puede deshacer") ? 168 : 240;
    // flutter defined function
    showMaterialModalBottomSheet(
      barrierColor: AppColors.AzulGNP.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context, scrollController) => Container(
        height: alturaHeight,
        padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
        decoration : new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )
        ),
        child:  Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:0.0),
                  child:Center(child: new Text("Borrar datos", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.AzulGNP),)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                  child:SingleChildScrollView(child: new Text("Se eliminar?? la informaci??n no guardada.", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.color_appBar),)),
                ),
                Divider(
                  color: ColorsCotizador.color_borde,
                  thickness: 2,
                ),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        height: 40.0,
                        buttonColor: AppColors.secondary900,
                        child: RaisedButton(
                          onPressed: negative,
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        height: 40.0,
                        buttonColor: AppColors.secondary900,
                        child: RaisedButton(
                          onPressed: positive,
                          child: Text(
                            "Aceptar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  static void mostrarAlertaCallback(String titulo, String mensaje,
      BuildContext context, Function negative, Function positive) {
    // flutter defined function
    double alturaHeight = mensaje.length < 94 ? 216 : mensaje.contains("Esta acci??n no se puede deshacer") ? 168 : 240;
    // flutter defined function
    showMaterialModalBottomSheet(
      barrierColor: AppColors.AzulGNP.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context, scrollController) => Container(
        height: alturaHeight,
        padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
        decoration : new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )
        ),
        child:  Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:0.0),
                  child:Center(child: new Text(titulo, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.AzulGNP),)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                  child:SingleChildScrollView(child: new Text(mensaje, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.color_appBar),)),
                ),
                ButtonTheme(
                  minWidth: 340.0,
                  height: 40.0,
                  buttonColor: AppColors.secondary900,
                  child: RaisedButton(
                    onPressed: positive,
                    child: Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  static void mostrarAlertaBorrarCotizacion({
    String titulo,
    String mensaje,
    BuildContext context,
    Function onPressed,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(child: Text(mensaje)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Borrar",
                style: TextStyle(color: Utilidades.color_primario),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      );

  static void mostrarAlertCargaDeDatos(String titulo, String mensaje,
      BuildContext context, Function negative, Function positive) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: AlertDialog(
            title: new Text(titulo),
            content: SingleChildScrollView(child: new Text(mensaje)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Continuar con datos pre-cargados",
                  style: TextStyle(color: Utilidades.color_primario),
                ),
                onPressed: negative,
              ),
              FlatButton(
                child: new Text(
                  "Continuar con datos modificados",
                  style: TextStyle(color: Utilidades.color_primario),
                ),
                onPressed: positive,
              )
            ],
          ),
        );
      },
    );
  }

  static void mostrarAlertaCallBackCustom(String titulo, String mensaje, BuildContext context,String buttonText,Function positive) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: AlertDialog(
            title: new Text(titulo),
            content: SingleChildScrollView(child: new Text(mensaje)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  buttonText,
                  style: TextStyle(color: Utilidades.color_primario),
                ),
                onPressed: positive,
              ),
            ],
          ),
        );
      },
    );
  }


  //Imprime Logs
  static void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }

  static void sendAnalytics(BuildContext context, String ea,String el) async {
    try {
      var config = AppConfig.of(context);
      var idContenedor;
      idContenedor = config.idContenedorAnalytics;

      String categoria = getCategoria();
      var parametros = "v=1&tid=$idContenedor&cid=555&t=event&ec=$categoria&ea=$ea&el=$el";
      Response response = await post(config.urlSendAnalytics + "collect?" + parametros, body: null, headers: { "Content-Type": "text/plain"});

      print(config.urlSendAnalytics + parametros);
      if (response.statusCode == 200) {
        print(response.body.toString());
      } else {
        print("No se pudo enviar tag");
      }
    }catch(e){
      print("Fallo el env??o de analytics en collect: " + e);
    }
  }

  static void sendAnalyticsBatch(BuildContext context, List<Map<String, dynamic>> listTags) async {
    try {
      var config = AppConfig.of(context);

      String body = "";
      int i = 0;
      while (i < listTags.length) {
        body = "";
        for (int j = 0; i < listTags.length && j < 11; j++) {
          body = body + "v=" + listTags[i]["v"].toString() + "&tid=" +
              listTags[i]["tid"].toString() + "&cid=" +
              listTags[i]["cid"].toString()
              + "&t=" + listTags[i]["t"].toString() + "&ec=" +
              listTags[i]["ec"].toString() + "&ea=" +
              listTags[i]["ea"].toString()
              + "&el=" + listTags[i]["el"].toString() + "\n";
          i++;
        }
        Response response = await post(config.urlSendAnalytics + "batch?", body: body, headers: { "Content-Type": "text/plain"});

        LogPrint(config.urlSendAnalytics + "batch?" + body.toString());
        if (response.statusCode == 200) {
          print(response.body.toString());
        } else {
          print("No se pudo enviar tag");
        }
      }
    }catch(e){
      print("Fallo el env??o de analytics batch: " + e);
    }
  }

  static String getCategoria(){

    var categoria = "AppAgentes/" + ((Platform.isIOS) ? "iOS" : "Android") + "/" + Utilidades.idAplicacion.toString() + "/" + datosUsuario.idparticipante;
    return categoria;
  }



}

class ColorsCotizador {
  static HexColor color_switch_apagado = HexColor("dcdcdc");
  static HexColor color_background = HexColor("#F6F9FD");
  static HexColor color_titleAlert = HexColor("002E71");
  static HexColor color_background_blanco = HexColor("FEFEFE");
  static HexColor color_Bordes = HexColor("CED8E8");
  static HexColor color_Etiqueta = HexColor("647085");
  static HexColor color_disable = HexColor("A3AAB6");
  static HexColor color_appBar = HexColor("33445F");
  static HexColor gnpTextUser = HexColor("0C2040");
  static HexColor primary700 = HexColor("002E71");
  static HexColor gnpTextSytemt1 = HexColor("#33486C");
  static HexColor secondary900 = HexColor("FF6B0B");
  static HexColor color_borde = HexColor("E8EEF8");
  static HexColor AzulGNP = HexColor("002E71");
  static HexColor color_primario = HexColor("fc6c25");
  static HexColor color_mail = HexColor("aac3ee");
  static HexColor color_sombra = HexColor("F3F4F5");
  static HexColor secondary300 = HexColor("#FFD357");
  static HexColor color_switch_simple_apagado = HexColor("595959");
  static HexColor boton_cotizar_apagado = HexColor("ECEDF0");
  static HexColor texto_tabla_comparativa = HexColor("404040");
  static HexColor texto_tb_comparativa = HexColor("567099");
  static HexColor menuGMM = HexColor("#FFF8E2");
  static HexColor tituloTablaGMM = HexColor("#647085");
  static HexColor valorTablaGMM = HexColor("#33445F");
  static HexColor valorComparativaActivo = HexColor("#FF6B0B");
  static HexColor inputUnderlineFiltros = HexColor("#AAC3EE");
  static HexColor itemFiltros = HexColor("#2155AB");
  static HexColor itemRellenoFiltros = HexColor("#DADADA");
}

class HexColor extends Color {

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
