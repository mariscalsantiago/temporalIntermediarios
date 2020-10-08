import 'package:cotizador_agente/modelos/modelos.dart';

import 'package:flutter/material.dart';
class Utilidades {


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
   static final Referencia referenciaPlan = Referencia(id_seccion: 6, id_campo: 23);
   static const int FORMATO_COTIZACION = 1;
   static const int FORMATO_COMPARATIVA = 2;
   static const int FORMATO_COMISION = 3;
   static final String tipoCampoSelect = "select";
   static final String tipoCampoToggle = "toggle";
   static final String tipoCampoSwitch = "switch";
   static final int REGLA_STOPPER = 2;
   static final int REGLA_INFO = 1;

   static bool isloadingPlan = true;
   static bool deboCargarPaso1 = false;
   static bool actualizarCodigoPostalAdicional = false;

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

      //Buscar la Sección en paso 1
      for (int i = 0; i < paso1.secciones.length; i++) {
         //Repetir para paso 1 y paso 2
         if (paso1.secciones[i].id_seccion == referencia_seccion) {
            //Encontré la sección

            if (paso1.secciones[i].multiplicador > 0) {
               for (int j = 0; j < paso1.secciones[i].children_secc.length; j++) {
                  Campo campo_resultado;
                  campo_resultado = paso1.buscarCampoPorID(
                      paso1.secciones[i].children_secc[j].campos,
                      referencia_id,
                      busquedaProfunda);
                  if (campo_resultado != null) {
                     campos
                         .add(campo_resultado); //Encontré el campo
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
                  return campos; //Encontré el campo
               }
            }
         }
      }

      PasoFormulario paso2 =
          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso2;
      //Buscar la Sección en paso 2

      if (paso2 != null) {
         for (int i = 0; i < paso2.secciones.length; i++) {
            //Repetir para paso 1 y paso 2
            if (paso2.secciones[i].id_seccion == referencia_seccion) {
               //Encontré la sección

               if (paso2.secciones[i].multiplicador > 0) {
                  for (int j = 0; j < paso2.secciones[i].children_secc.length; j++) {
                     Campo campo_resultado;
                     campo_resultado = paso2.buscarCampoPorID(
                         paso2.secciones[i].children_secc[j].campos,
                         referencia_id,
                         busquedaProfunda);
                     if (campo_resultado != null) {
                        campos.add(
                            campo_resultado.getValorFormatted()); //Encontré el campo
                     }
                  }

                  if (campos.length > 0) {
                     return campos; //Encontré los campos
                  }
               } else {
                  Campo campo_resultado;
                  campo_resultado = paso2.buscarCampoPorID(
                      paso2.secciones[i].campos, referencia_id, busquedaProfunda);

                  if (campo_resultado != null) {
                     campos.add(campo_resultado);
                     return campos; //Encontré el campo
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

      //Buscar la Sección en paso 1
      for (int i = 0; i < paso1.secciones.length; i++) {
         //Repetir para paso 1 y paso 2
         if (paso1.secciones[i].id_seccion == referencia_seccion) {
            //Encontré la sección

            if (paso1.secciones[i].multiplicador > 0) {
               for (int j = 0; j < paso1.secciones[i].children_secc.length; j++) {
                  Campo campo_resultado;
                  campo_resultado = paso1.buscarCampoPorID(
                      paso1.secciones[i].children_secc[j].campos,
                      referencia_id,
                      busquedaProfunda);
                  if (campo_resultado != null) {
                     campos
                         .add(campo_resultado.getValorFormatted()); //Encontré el campo
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
                  return campos; //Encontré el campo
               }
            }
         }
      }

      PasoFormulario paso2 = Utilidades.cotizacionesApp.getCotizacionElement(index_formulario).paso2;
      //Buscar la Sección en paso 2

      if (paso2 != null) {
         for (int i = 0; i < paso2.secciones.length; i++) {
            //Repetir para paso 1 y paso 2
            if (paso2.secciones[i].id_seccion == referencia_seccion) {
               //Encontré la sección

               if (paso2.secciones[i].multiplicador > 0) {
                  for (int j = 0; j < paso2.secciones[i].children_secc.length; j++) {
                     Campo campo_resultado;
                     campo_resultado = paso2.buscarCampoPorID(
                         paso2.secciones[i].children_secc[j].campos,
                         referencia_id,
                         busquedaProfunda);
                     if (campo_resultado != null) {
                        campos.add(
                            campo_resultado.getValorFormatted()); //Encontré el campo
                     }
                  }

                  if (campos.length > 0) {
                     return campos; //Encontré los campos
                  }
               } else {
                  Campo campo_resultado;
                  campo_resultado = paso2.buscarCampoPorID(
                      paso2.secciones[i].campos, referencia_id, busquedaProfunda);

                  if (campo_resultado != null) {
                     campos.add(campo_resultado);
                     return campos; //Encontré el campo
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
                  content: new Text(mensaje),
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

   static void mostrarAlertaCallback(String titulo, String mensaje,
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
                           "Cancelar",
                           style: TextStyle(color: Utilidades.color_primario),
                        ),
                        onPressed: negative,
                     ),
                     FlatButton(
                        child: new Text(
                           "Aceptar",
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


}
