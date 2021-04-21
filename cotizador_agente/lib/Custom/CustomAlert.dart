import 'dart:ui';

import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/loginPreguntasSecretas.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/UserInterface/perfil/Terminos_y_condiciones.dart';
import 'package:cotizador_agente/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';

var isShowAlert = false;

enum AlertDialogType {
  errorConexion,
  timeOut,
  inactividad,
  testUno,
  archivoInvalido,
  acesso_camara_galeria,
  ajustes_sin_guardar,
  opciones_de_inicio_de_sesion,
  huella,
  terminosYcondiciones_Huella,
  activacionExitosa_Huella,
  EnOtroMomento_Huella,
  verificaTuNumeroCelular,
  Reconocimiento_facial,
  activacionExitosa_Reconocimiento_facial,
  terminosYcondiciones_reconocimiento_facial,
  EnOtroMomento_reconocimiento_facial,
  Sesionfinalizada_por_dispositivo,
  Sesionfinalizada_por_inactividad,
  Sesionfinalizada_por_intentos_huella,
  Sesionafinalizada_por_contrasena_debeserdiferente,
  Correo_electronico_o_contrasena_no_coinciden,
  Correo_no_registrado,
  Cuenta_inactiva,
  Cuenta_bloqueada,
  Cuenta_temporalmente_bloqueada,
  Contrasena_invalida_debeserdiferente_a_la_actual,
  Rostro_no_reconocido,
  Rostro_no_reconocido_2,
  Huella_no_reconocida,
  Numero_de_celular_verificado,
  Numero_de_celular_actualizado_correctamente,
  AjustesSinGuardar_camara,
  ArchivoInvalido_imagen,
  Tienes_una_sesion_activa,
  Desactivar_huella_digital,
  Desactivar_recoFacial,
  DatosMoviles_Activados,
  DatosMoviles_Activados_comprueba,
  CerrarSesion,
  En_mantenimiento_cel,
  En_mantenimiento_llave,
  Sin_acceso_herramientas_cotizacion,
  menu_home,
  errorServicio,
  contrasena_actualiza_correctamente,
  preguntasSecretasActualizadas
}

void customAlert(AlertDialogType type, BuildContext context, String title, String message, Responsive responsive,  Function callback) {

  switch (type) {
    case AlertDialogType.errorConexion:
      if (!isShowAlert) {
        isShowAlert = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error de conexión.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.primary,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    isShowAlert = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {}
      break;
      case AlertDialogType.timeOut:
      if (!isShowAlert) {
        isShowAlert = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error de conexión.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Se produjo un error en la red por el tiempo de espera, verifica tu conexión e intenta nuevamente.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.primary,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    isShowAlert = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {}
      break;
    case AlertDialogType.inactividad:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Cierre de sesión.",
                    style: TextStyle(
                        color: Theme.Colors.appBarTextBlueDark,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                content: new Text(
                    "Su sesión ha expirado por "
                    "inactividad.",
                    style: TextStyle(
                        color: Theme.Colors.appBarTextBlueDark,
                        fontSize: 12.0,
                        fontFamily: "Roboto")),
                actions: <Widget>[
                  FlatButton(
                      child: Text("ACEPTAR",
                          style: TextStyle(
                              color: Theme.Colors.primary,
                              fontSize: 16.0,
                              fontFamily: "Roboto")),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ));
      break;
    case AlertDialogType.testUno:
      showDialog(
          context: context,
          builder: (context) {
            return Opacity(
                opacity: 0.6, // some opacity
                child: Container(
                    // container to set color
                    color: Theme.Colors.Azul_gnp,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 500,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sim_card_alert,
                                    color: Theme.Colors.Orange,
                                  ),
                                  Text("data"),
                                  Text("data"),
                                  Text("data"),

                                  RaisedButton(
                                    child: Text("cerrar"),
                                    onPressed: () {
                                      Navigator.pop(context,true);
                                    },
                                  ), // replace with your buttons
                                ],
                              ),
                            ),
                          )
                        ])));
          });
      break;
    case AlertDialogType.archivoInvalido:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(children: [
              Opacity(
                  opacity: 0.6, // some opacity
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  )),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: responsive.hp(38),
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              size: responsive.ip(6),
                              color: Theme.Colors.Error_Dark,
                            ),
                            Text(
                              "Archivo invalido",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(2)),
                            ),
                            Text("data"),
                            Text("data"),
                            DialogButton(
                              child: Text(
                                "CONFIGURAR AHORA",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                            ),

                            RaisedButton(
                              child: Text("cerrar"),
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                            ), // replace with your buttons
                          ],
                        ),
                      ),
                    )
                  ])
            ]);
          });
      break;

    case AlertDialogType.acesso_camara_galeria:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(children: [
              Opacity(
                  opacity: 0.6, // some opacity
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  )),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: responsive.hp(38),
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Acesso a cámara y galería",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(2)),
                            ),
                            Text(
                                "Es necesario otorgar los permisos correspondientes para cargar tus imágenes o archivos."),
                            Text("data"),
                            DialogButton(
                              child: Text(
                                "CONFIGURAR AHORA",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                            ),
                            RaisedButton(
                              child: Text("En otro momento"),
                              onPressed: () {
                                prefs.setBool("activarBiometricos", false);
                                Navigator.pop(context,true);
                              },
                            ), // replace with your buttons
                          ],
                        ),
                      ),
                    )
                  ])
            ]);
          });

      break;
    case AlertDialogType.ajustes_sin_guardar:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(children: [
              Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  )),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: responsive.hp(38),
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tienes ajustes sin guardar",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(2)),
                            ),
                            Text("¿Quieres descartarlos?"),
                            RaisedButton(
                              child: Text("Descartar"),
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                            ), // replace with your buttons
                          ],
                        ),
                      ),
                    )
                  ])
            ]);
          });
      break;

    case AlertDialogType.opciones_de_inicio_de_sesion:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  height: responsive.height,
                  width: responsive.width,
                  color: Theme.Colors.Azul_gnp,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    child: Card(
                      color: Theme.Colors.White,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: responsive.height * 0.03),
                            child: Center(
                              child: Text(
                                "Opciones de inicio de sesión",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5)),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  bottom: responsive.height * 0.05,
                                  right: responsive.wp(1),
                                  left: responsive.wp(5)),
                              child: Text(
                                "Al activar la funcionalidad permites iniciar sesión en tu App Intermediario GNP usando los datos biométricos que tienes activados en este dispositivo.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2)),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: responsive.height * 0.05,
                              left: responsive.wp(4),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context,true);
                                customAlert(AlertDialogType.huella, context, "",
                                    "", responsive, callback);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    color: Theme.Colors.Encabezados,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: responsive.width * 0.07),
                                      child: Text(
                                        "Huella digital",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(2.3)),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only( right: responsive.wp(4)),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Theme.Colors.gnpOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: responsive.height * 0.05,
                              left: responsive.wp(4),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,true);
                                  customAlert(
                                      AlertDialogType.Reconocimiento_facial,
                                      context,
                                      "",
                                      "",
                                      responsive, FuncionAlerta);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.face,
                                      color: Theme.Colors.Encabezados,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: responsive.width * 0.07),
                                        child: Text(
                                          "Reconocimiento facial",
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(2.3)),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only( right: responsive.wp(4)),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.Colors.gnpOrange,
                                      ),
                                    ),
                                  ],

                                )),
                          ),
                          Center(
                            child: Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(
                                bottom: responsive.height * 0.03,
                                top: responsive.height * 0.02,
                              ),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.GNP,
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                                    prefs.setBool("activarBiometricos", false);
                                    callback(false);
                                    Navigator.pop(context,true);
                                  } else {
                                    prefs.setBool("activarBiometricos", false);
                                    callback(false);
                                    Navigator.pop(context,true);
                                    if(prefs.getBool("flujoCompletoLogin") != null && prefs.getBool("flujoCompletoLogin")){
                                    }else{
                                      customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, callback);
                                    }
                                  }
                                },
                                child: Text(
                                  "EN OTRO MOMENTO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.White,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ]);
          });
      break;

    case AlertDialogType.huella:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Stack(children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "¡Activa tu ingreso con huella digital!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  bottom: responsive.height * 0.01,
                                  right: responsive.wp(1),
                                  left: responsive.wp(5)),
                              child: Text(
                                "Al activar esta funcionalidad podrás iniciar sesión en tu App Intermediario GNP más rápido con cualquier huella registrada en este dispositivo.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.03),
                              child: Center(
                                child: Icon(
                                  Icons.fingerprint,
                                  color: Theme.Colors.GNP,
                                  size: 116,
                                ),
                              ),
                            ),
                            Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  left: responsive.wp(4.4),
                                  right: responsive.wp(4.4)),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.GNP,
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TerminosYCondicionesPage(callback: callback,)));
                                },
                                child: Text(
                                  "ACEPTAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.Colors.White,
                                    fontSize: responsive.ip(2.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                    customAlert(AlertDialogType.EnOtroMomento_Huella, context, "", "", responsive, callback);
                                  },
                                  child: Text(
                                    "EN OTRO MOMENTO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            );
          });
      break;

    case AlertDialogType.terminosYcondiciones_Huella:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.57,
                    child: Container(
                      height: responsive.height,
                      width: responsive.width,
                      color: Theme.Colors.Azul_gnp,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: responsive.width,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context,true);
                              customAlert(
                                  AlertDialogType.activacionExitosa_Huella,
                                  context,
                                  "",
                                  "",
                                  responsive, FuncionAlerta);
                            },
                            child: Text(
                              "Terminos y\n condiciones",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.Colors.White,
                                  fontSize: responsive.ip(2.5)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
      break;

    case AlertDialogType.activacionExitosa_Huella:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.green,
                                  size: 57,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(2),
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(3)),
                              child: Center(
                                child: Text(
                                  "Activación exitosa de huella digital",
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.06,
                                right: responsive.width * 0.06,
                              ),
                              child: Text(
                                "Ya puedes iniciar sesión solo con tu huella digital.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.06,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    print("-----------Exito----------------------");
                                    if(prefs.getBool("primeraVez") || prefs.getBool("flujoCompletoLogin") == null || !prefs.getBool("flujoCompletoLogin") ){

                                      if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                      } else{
                                        if (deviceType == ScreenType.phone) {
                                          customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, FuncionAlerta);
                                        }
                                        else{
                                          customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
                                        }
                                      }

                                    } else {
                                      if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil") ){
                                        Navigator.pop(context,true);
                                      } else{
                                        print("Exito----------------------");
                                        Navigator.pop(context,true);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(responsive: responsive,)));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "CERRAR",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.2)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.EnOtroMomento_Huella:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(2),
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(3)),
                              child: Center(
                                child: Text(
                                  "El inicio de sesión con tu huella digital es más rápido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(1)),
                              child: Text(
                                "¿Desea cancelar la configuración?",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                                      prefs.setBool("activarBiometricos", false);
                                      callback(false);
                                      Navigator.pop(context,true);
                                    } else {
                                      prefs.setBool("activarBiometricos", false);
                                      callback(false);
                                      customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, callback);

                                    }

                                  },
                                  child: Text(
                                    "SÍ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.01,
                                  bottom: responsive.height * 0.04),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType.huella,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        callback);
                                  },
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.verificaTuNumeroCelular:
      showDialog(
        barrierDismissible: true,
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: responsive.height,
                      width: responsive.width,
                      color: Theme.Colors.Azul_gnp,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "Verifica tu número celular",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                  right: responsive.width * 0.04),
                              child: Text(
                                "Te enviamos un código de verificación por SMS al número ****1234.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontWeight: FontWeight.normal,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Image.asset(
                              "assets/login/verificaNumero.png",
                              height: responsive.hp(15.0),
                              width: responsive.wp(12),
                            ),
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Container(
                                    width: responsive.width,
                                    margin: EdgeInsets.only(
                                        top: responsive.height * 0.04,
                                        left: responsive.width * 0.04,
                                        bottom: responsive.height * 0.03,
                                        right: responsive.width * 0.04),
                                    color: Theme.Colors.GNP,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.height * 0.02,
                                            left: responsive.width * 0.04,
                                            bottom: responsive.height * 0.02,
                                            right: responsive.width * 0.04),
                                        child: Text(
                                          "ACEPTAR",
                                          style: TextStyle(
                                              color: Theme.Colors.backgroud,
                                              fontSize: responsive
                                                  .ip(responsive.ip(0.2))),
                                          textAlign: TextAlign.center,
                                        ))),
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginCodigoVerificaion(
                                                responsive: responsive,
                                              )));
                                }),
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: responsive.hp(2)),
                                    child: Text("NO ES MI NÚMERO ACTUAL",
                                        style:
                                            TextStyle(color: Theme.Colors.GNP),
                                        textAlign: TextAlign.center)),
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginActualizarNumero(
                                                  responsive: responsive)));
                                })

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Reconocimiento_facial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Stack(children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "¡Activa tu ingreso con reconocimiento facial!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.2)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  bottom: responsive.height * 0.01,
                                  right: responsive.wp(1),
                                  left: responsive.wp(5)),
                              child: Text(
                                "Al activar esta funcionalidad podrás iniciar sesión en tu App Intermediario GNP más rápido con cualquier rostro registrado en este dispositivo.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.03),
                              child: Center(
                                child: Icon(
                                  Theme.Icons.facial,
                                  color: Theme.Colors.GNP,
                                  size: 116,
                                ),
                              ),
                            ),
                            Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  left: responsive.wp(4.4),
                                  right: responsive.wp(4.4)),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.GNP,
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TerminosYCondicionesPage(callback: callback,)));
                                },
                                child: Text(
                                  "ACEPTAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.Colors.White,
                                    fontSize: responsive.ip(2.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType
                                            .EnOtroMomento_reconocimiento_facial,
                                        context,
                                        "",
                                        "",
                                        responsive, FuncionAlerta);
                                  },
                                  child: Text(
                                    "EN OTRO MOMENTO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            );
          });
      break;

    case AlertDialogType.Reconocimiento_facial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: responsive.height,
                      width: responsive.width,
                      color: Theme.Colors.Azul_gnp,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: responsive.width,
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.03),
                                child: Center(
                                  child: Text(
                                    "El inicio de sesión con reconocimiento facial es más rápido",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2.3)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(1),
                                    left: responsive.wp(1),
                                    right: responsive.wp(1),
                                    bottom: responsive.hp(1)),
                                child: Text(
                                  "¿Desea cancelar la configuración?",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin: EdgeInsets.only(
                                    bottom: responsive.height * 0.02,
                                    top: responsive.height * 0.02,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    color: Theme.Colors.GNP,
                                    onPressed: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Text(
                                      "SÍ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01,
                                    bottom: responsive.height * 0.04),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Text(
                                      "NO",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
      break;

    case AlertDialogType.activacionExitosa_Reconocimiento_facial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(2),
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(3)),
                              child: Center(
                                child: Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.green,
                                  size: 57,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: responsive.wp(2),
                                  right: responsive.wp(2),
                                  bottom: responsive.hp(1)),
                              child: Center(
                                child: Text(
                                  "Activación exitosa de reconocimiento facial",
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.2)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.06,
                                right: responsive.width * 0.06,
                              ),
                              child: Text(
                                "Ya puedes iniciar sesión mostrando solo tu rostro.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.06,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if(prefs.getBool("primeraVez") || prefs.getBool("flujoCompletoLogin") == null || !prefs.getBool("flujoCompletoLogin")){
                                      if(prefs.getBool('primeraVezIntermediario') != null && prefs.getBool('primeraVezIntermediario')){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                      } else{
                                        if (deviceType == ScreenType.phone) {
                                          customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, FuncionAlerta);
                                        }
                                        else{
                                          customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive);
                                        }
                                      }
                                    } else {
                                      if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil") ){
                                        Navigator.pop(context,true);
                                      } else{
                                        Navigator.pop(context,true);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(responsive: responsive,)));
                                      }
                                    }

                                  },
                                  child: Text(
                                    "CERRAR",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.2)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.terminosYcondiciones_reconocimiento_facial:
      bool checkedValue = false;
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);

            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  leading: IconButton(
                    icon:Icon(Icons.close, color: Theme.Colors.GNP,),
                    onPressed: (){
                      Navigator.pop(context,true);
                    },
                  ),
                  backgroundColor: Theme.Colors.White,
                ),
                body: Container(
                  color: Theme.Colors.White,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: responsive.wp(2.5), right: responsive.wp(2.5), top: responsive.hp(2)),
                                child: Text("Terminos y condiciones de uso",
                                  style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                ),
                              ),
                              Image.asset("assets/icon/splash/logo.png", fit:BoxFit.contain,height:responsive.ip(15), width: responsive.ip(15),),
                              Container(
                                margin: EdgeInsets.only(left: responsive.wp(2.5), right: responsive.wp(2.5)),
                                child: Text.rich(
                                    TextSpan(
                                        text: 'Consentimiento para el tratamiento de uso de datos biométricos \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),

                                        children: <InlineSpan>[

                                          TextSpan(
                                            text: 'Grupo Nacional Provincial, S.A.B., ',
                                            style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'con domicilio en Avenida Cerro de las Torres No. 395, Colonia Campestre Churubusco,'
                                                ' Código Postal 04200, Alcaldía Coyoacán, Ciudad de México, tratará sus datos personales'
                                                ' para que a través de su huella digital que previamente tenga configurada o disponible en el '
                                                'dispositivo electrónico que utilice, facilitar el acceso a determinadas aplicaciones o '
                                                'plataformas de GNP relacionadas con el desarrollo de sus actividades propias como agente,'
                                                ' sin que esto implique el resguardo o almacenamiento de este dato por parte de GNP. '
                                                'Puede consultar la versión integral del Aviso de Privacidad en ',
                                            style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'www.gnp.com.mx ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),
                                          TextSpan(
                                            text: 'o en el teléfono ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: '(55) 5227 9000 ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),
                                          TextSpan(
                                            text: 'a nivel nacional. \n \n',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),

                                          TextSpan(
                                            text: 'Al activar el uso de datos biométricos, reconozco que se ha puesto a mi disposición el ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),

                                          TextSpan(
                                            text: 'Aviso de Privacidad Integral de Grupo Nacional Provincial S. A. B. ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),
                                          TextSpan(
                                            text: '(en adelante GNP), mismo que contiene y detalla las finalidades del tratamiento de los datos personales y'
                                                ' aceptó su tratamiento por parte de GNP. Asimismo se me informó que puedo consultar dicho aviso y sus actualizaciones'
                                                ' en cualquier momento en la página ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'www.gnp.com.mx ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),

                                          TextSpan(
                                            text: 'o en el teléfono ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: '(55) 5227 9000 ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),

                                          TextSpan(
                                            text: 'a nivel nacional. En caso de haber proporcionado datos personales de otros titulares, reconozco haber cumplido con mi'
                                                ' obligación de informarles sobre su entrega, haber obtenido de forma previa el consentimiento de éstos para su tratamiento, '
                                                'así como haberles informado los lugares en los que se encuentra disponible el Aviso de Privacidad para su consulta. ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              CheckboxListTile(
                                title: Text("Acepto los términos y condiciones de uso"),
                                value: checkedValue,
                                onChanged: (bool value) {
                                  checkedValue = value;
                                  prefs.setBool("aceptoTerminos", checkedValue);
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                              CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: (checkedValue) ?
                                      Theme.Colors.GNP : Theme.Colors.botonlogin ,
                                    ),
                                    padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
                                    width: responsive.width,
                                    child: Text("Continuar", style: TextStyle(
                                      color:  (checkedValue) ?
                                      Theme.Colors.backgroud : Theme.Colors.botonletra,
                                    ),
                                        textAlign: TextAlign.center),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType
                                            .activacionExitosa_Reconocimiento_facial,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        FuncionAlerta);
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
      break;

    case AlertDialogType.EnOtroMomento_reconocimiento_facial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(2),
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(3)),
                              child: Center(
                                child: Text(
                                  "El inicio de sesión con reconocimiento facial es más rápido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(1)),
                              child: Text(
                                "¿Desea cancelar la configuración?",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                                      prefs.setBool("activarBiometricos", false);
                                      callback(false);
                                      Navigator.pop(context,true);
                                    } else {
                                      prefs.setBool("activarBiometricos", false);
                                      callback(false);
                                      customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, callback);

                                    }

                                  },
                                  child: Text(
                                    "SÍ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.01,
                                  bottom: responsive.height * 0.04),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType.Reconocimiento_facial,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        callback);
                                  },
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sesionfinalizada_por_dispositivo:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Sesión finalizada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Text(
                                "Has iniciado sesión en otro dispositivo",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.8)),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sesionfinalizada_por_inactividad:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Sesión finalizada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Text(
                                "Sesión finalizada por inactividad",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.8)),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sesionfinalizada_por_intentos_huella:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Sesión finalizada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "Has superado los intentos permitidos de huella digital, por seguridad inicia sesión nuevamente.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sesionafinalizada_por_contrasena_debeserdiferente:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Contraseña inválida",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "Tu nueva contraseña debe ser diferente a las 3 contraseñas anteriores.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.contrasena_actualiza_correctamente:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin: EdgeInsets.only(top: responsive.hp(3)),
                                    child: Image.asset('assets/images/verifica.png',
                                        fit:BoxFit.contain,
                                        height: responsive.hp(5),
                                        width: responsive.hp(4),
                                    )
                                ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Tu contraseña se actualizó \ncorrectamente",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.01,
                                ),
                                child: Center(
                                  child: Text(
                                    "Esta contraseña es la misma para ingresar a todas las plataformas digitales disponibles para ti.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only( bottom: responsive.height * 0.02,  top: responsive.height * 0.01),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else if(prefs.getBool("flujoOlvideContrasena") != null && prefs.getBool("flujoOlvideContrasena")) {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: responsive)));
                                    }else {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PreguntasSecretas(responsive: responsive)));
                                    }

                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Contrasena_invalida_debeserdiferente_a_la_actual:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Contraseña inválida",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(5),
                                  right: responsive.wp(5),
                                  bottom: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "Tu nueva contraseña debe ser diferente a la actual.",
                                  style: TextStyle(
                                      color:
                                      Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.8)),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Correo_electronico_o_contrasena_no_coinciden:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Correo electrónico o contraseña no coinciden",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  right: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "Por seguridad, tu cuenta se bloqueará después de 3 intentos.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Correo_no_registrado:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Correo no registrado",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(5),
                                  right: responsive.wp(5),
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "El correo que ingresaste aún no ha sido registrado. Verifícalo e inténtalo nuevamente.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Cuenta_inactiva:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Cuenta inactiva",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                    child: Text.rich(TextSpan(
                                        text:
                                            'Para mayor información o reactivar tu cuenta comunicate a Soporte GNP al ',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.8)),
                                        children: <InlineSpan>[
                                      TextSpan(
                                        text: '55 5227 3966 ',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.GNP,
                                            fontSize: responsive.ip(1.8)),
                                      ),
                                      TextSpan(
                                        text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.8)),
                                      ),
                                    ]))),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;


    case AlertDialogType.Cuenta_bloqueada:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Tu cuenta ha sido bloqueada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                    child: Text.rich(TextSpan(
                                        text:
                                        'Para desbloquearla, comunicate a Soporte GNP al ',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.8)),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.GNP,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                          TextSpan(
                                            text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                        ]))),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Cuenta_temporalmente_bloqueada:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5), left: responsive.wp(8), right: responsive.wp(8), ),
                              child: Center(
                                child: Text(
                                  "Tu cuenta está temporalmente bloqueada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                    child: Text.rich(TextSpan(
                                        text:
                                        'Para desbloquearla, comunicate a Soporte GNP al ',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.8)),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.GNP,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                          TextSpan(
                                            text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                        ]))),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Rostro_no_reconocido:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Rostro no reconocido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(6),
                                  right: responsive.wp(6),
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "Has superado los intentos permitidos de reconocimiento facial, por seguridad inicia sesión nuevamente.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                    callback();
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.Rostro_no_reconocido_2:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Rostro no reconocido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(6),
                                  right: responsive.wp(6),
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "No se ha podido reconocer tu rostro, por favor vuelve a intentarlo.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                    callback();
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;


    case AlertDialogType.Huella_no_reconocida:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () async => false,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: responsive.height,
                      width: responsive.width,
                      color: Theme.Colors.Azul_gnp,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: responsive.width,
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(3)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(5),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(5)),
                                child: Center(
                                  child: Text(
                                    "Huella digital no reconocida",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2.3)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    left: responsive.width * 0.04,
                                    bottom: responsive.height * 0.03),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    left: responsive.wp(6),
                                    right: responsive.wp(6),
                                    bottom: responsive.height * 0.03,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Has superado los intentos permitidos para identificar tu huella digital, por seguridad inicia sesión nuevamente.",
                                      style: TextStyle(
                                          color:
                                          Theme.Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin: EdgeInsets.only(
                                    bottom: responsive.height * 0.02,
                                    top: responsive.height * 0.02,
                                  ),
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: Theme.Colors.White,
                                    onPressed: () {
                                      Navigator.pop(context,true);
                                      callback();
                                    },
                                    child: Text(
                                      "CERRAR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
      break;

    case AlertDialogType.Numero_de_celular_verificado:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.verified_user_outlined,
                                      color: Colors.green,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Número de celular verificado",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(6),
                                  right: responsive.wp(6),
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "Mantener tu número de celular actualizado te permitirá agilizar ciertos trámites, por ejemplo si olvidas la contraseña de tu cuenta.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Numero_de_celular_actualizado_correctamente:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.verified_user_outlined,
                                      color: Colors.green,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Tu número de celular se actualizó correctamente",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(6),
                                  right: responsive.wp(6),
                                  bottom: responsive.height * 0.03,
                                ),
                                child: Center(
                                  child: Text(
                                    "A partir de ahora, te enviaremos las notificaciones al número de celular proporcionado.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.AjustesSinGuardar_camara:
      showDialog(
        context: context,
        builder: (context) {
          Responsive responsive = Responsive.of(context);
          return Stack(
            children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  height: responsive.height,
                  width: responsive.width,
                  color: Theme.Colors.Azul_gnp,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    child: Card(
                      color: Theme.Colors.White,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: responsive.hp(3.5)),
                              child: Text("Tienes ajustes sin guardar",
                              style: TextStyle(
                                color: Theme.Colors.Encabezados,
                                fontSize: responsive.ip(2.5),
                              ),),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.03),
                            child: Text("¿Quieres descartarlos?",
                            style: TextStyle(
                              color: Theme.Colors.Funcional_Textos_Body,
                              fontSize: responsive.ip(2),
                            ),),
                          ),
                          Center(
                            child: Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(top: responsive.hp(3.5)),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.GNP,
                                onPressed: () {
                                  Navigator.pop(context,true);
                                  },
                                child: Text(
                                  "DESCARTAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.White,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: responsive.height * 0.03,
                                bottom: responsive.height * 0.05),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,true);
                                  },
                                child: Text(
                                  "SEGUIR MODIFICANDO",
                                  style: TextStyle(
                                      color: Theme.Colors.GNP,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
    break;

    case AlertDialogType.ArchivoInvalido_imagen:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                             child: Container(
                               margin: EdgeInsets.only(top: responsive.hp(3.6)),
                               child: Icon(
                                 Icons.warning_amber_outlined,
                                 color: Colors.redAccent,
                                 size: responsive.ip(6.6),
                               ),
                             ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.6)),
                                child: Text("Archivo inválido",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.Colors.Azul_gnp,
                                  fontSize: responsive.ip(2.4),
                                ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(4.1), left: responsive.width * 0.05),
                              child: Text("Debe ser formato imagen",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.07,
                                left: responsive.wp(20),
                                bottom: responsive.height * 0.04,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,true);
                                  customAlert(
                                      AlertDialogType.Tienes_una_sesion_activa,
                                      context,
                                      "",
                                      "",
                                      responsive,
                                      FuncionAlerta);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.Colors.GNP,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: responsive.width * 0.07),
                                        child: Text(
                                          "SELECCIONAR FOTO",
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.GNP,
                                              fontSize: responsive.ip(2.0)),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Tienes_una_sesion_activa:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text("Tienes una sesión activa",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.03),
                              child: Text("Iniciada a las {hora} en {ciudad} desde\n {dispositivo}. ¿Deseas cerrar esa sesión e iniciar\n en este dispositivo?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType.DatosMoviles_Activados,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        FuncionAlerta);
                                  },
                                  child: Text(
                                    "SÍ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Desactivar_huella_digital:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text("Desactivar huella digital",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.03),
                              child: Text("Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n\n ¿Deseas desactivarla?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    prefs.setBool("activarBiometricos", false);
                                    isSwitchedPerfill = false;
                                    Navigator.pop(context,false);
                                  },
                                  child: Text(
                                    "SÍ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Desactivar_recoFacial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text("Desactivar reconocimiento facial",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.03),
                               child: Text("Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n \n  ¿Deseas desactivarla?",
                              //child: Text("Al desactivar esta funcionalidad iniciarás sólo\n con contraseña.\n\n ¿Deseas desactivarla?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    prefs.setBool("activarBiometricos", false);
                                    isSwitchedPerfill = false;
                                    Navigator.pop(context,false);
                                  },
                                  child: Text(
                                    "SÍ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.DatosMoviles_Activados:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: (){
                callback();
                Navigator.pop(context,true);
              },
              child:Stack(
                children: [
                  GestureDetector(
                    onTap: (){
                      callback();
                      Navigator.pop(context,true);
                    },
                    child: Opacity(
                      opacity: 0.6,
                      child: Container(
                        height: responsive.height,
                        width: responsive.width,
                        color: Theme.Colors.Azul_gnp,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: responsive.width,
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.03),
                                child: Center(
                                  child: Icon(
                                    Icons.wifi_off_outlined,
                                    color: Colors.blueAccent,
                                    size: 57,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.05),
                                child: Center(
                                  child: Text(
                                    "Datos móviles activados",
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2.3)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.05,
                                  left: responsive.width * 0.03,
                                ),
                                child: Text(
                                  "Tu dispositivo no está conetado a una red wifi.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.06,
                                    bottom: responsive.height * 0.05),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      callback();
                                      Navigator.pop(context,true);
                                    },
                                    child: Text(
                                      "CERRAR",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(2.2)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
      break;

    case AlertDialogType.DatosMoviles_Activados_comprueba:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () async => false,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: responsive.height,
                      width: responsive.width,
                      color: Theme.Colors.Azul_gnp,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: responsive.width,
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.03),
                                child: Center(
                                  child: Icon(
                                    Icons.wifi_off_outlined,
                                    color: Theme.Colors.azul_apoyo,
                                    size: 57,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.05),
                                child: Center(
                                  child: Text(
                                    "Sin conexión a internet",
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2.3)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.05,
                                  left: responsive.width * 0.04,
                                  right: responsive.width * 0.04,
                                  bottom: responsive.height * 0.05,
                                ),
                                child: Text(
                                  "Comprueba que tienes acceso a una red Wi-Fi o que cuentas con datos móviles activados.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                              /*Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.06,
                                    bottom: responsive.height * 0.05),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,true);

                                    },
                                    child: Text(
                                      "CERRAR",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(2.2)),
                                    ),
                                  ),
                                ),
                              )*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
      break;

    case AlertDialogType.CerrarSesion:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text("Cerrar sesión",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.05),
                              child: Text("¿Estás seguro de que deseas salir de tu App Intermediario GNP?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    if(prefs.getBool("activarBiometricos")){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BiometricosPage(responsive: responsive)));
                                    } else{
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrincipalFormLogin(responsive: responsive)));
                                    }

                                  },
                                  child: Text(
                                    "CERRAR SESIÓN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CONTINUAR TRABAJANDO",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.0)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.En_mantenimiento_cel:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Icon(
                                  Icons.phonelink_setup_outlined,
                                  color: Colors.blueAccent,
                                  size: 57,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.05),
                              child: Center(
                                child: Text(
                                  "En mantenimiento",
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.03,
                              ),
                              child: Text(
                                "Estamos mejorando tu App Intemediario GNP.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.06,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                    customAlert(
                                        AlertDialogType.En_mantenimiento_llave,
                                        context,
                                        "",
                                        "",
                                        responsive, FuncionAlerta);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.2)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.En_mantenimiento_llave:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Icon(
                                  Icons.build_outlined,
                                  color: Colors.blueAccent,
                                  size: 57,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.05),
                              child: Center(
                                child: Text(
                                  "En mantenimiento",
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.03,
                              ),
                              child: Text(
                                "Estamos mejorando tu App Intermediario GNP.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.06,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.2)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sin_acceso_herramientas_cotizacion:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height:responsive.hp(15), width: responsive.wp(15),
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Image.asset("assets/info_24px.png", fit:BoxFit.contain,height:responsive.hp(14), width: responsive.wp(14),),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.05),
                              child: Center(
                                child: Text(
                                  "Sin acesso a herramientas de cotización",
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.05,
                                right: responsive.width * 0.05,
                              ),
                              child: Text(
                                "Debido a tus permisos asignados no es posible ingresar a las herramientas de cotización.",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.8)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.06,
                                  bottom: responsive.height * 0.05),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(
                                    "CERRAR",
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(2.2)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;


    case AlertDialogType.menu_home:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        switch(opcionElegida){
                          case HomeSelection.Atuos:
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AutosPage()), );
                            break;

                          case HomeSelection.AP:
                            Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return CotizarController();
                                }));
                            break;

                        }
                      },
                      child: Container(
                        width: responsive.width,
                        child: Card(
                          color: Theme.Colors.White,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5), right: responsive.wp(1), left: responsive.wp(8)),
                                child: Image.asset("assets/cotizar.png", fit:BoxFit.contain,height:responsive.hp(5), width: responsive.wp(5),),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(5), left: responsive.wp(8), right: responsive.wp(1), bottom: responsive.hp(16)),
                                child: Text("Cotizar",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

            );
          });
      break;
    case AlertDialogType.errorServicio:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  height: responsive.height,
                  width: responsive.width,
                  color: Theme.Colors.Azul_gnp,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    child: Card(
                      color: Theme.Colors.White,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                            EdgeInsets.only(top: responsive.height * 0.03),
                            child: Center(
                              child: Text(
                                "¡ Lo sentimos !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5)),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  bottom: responsive.height * 0.05,
                                  right: responsive.wp(1),
                                  left: responsive.wp(5)),
                              child: Text(
                                "Se produjo un error en el servicio, intente más tarde.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2)),
                              )
                          ),
                          Center(
                            child: Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(
                                bottom: responsive.height * 0.03,
                                top: responsive.height * 0.02,
                              ),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.GNP,
                                onPressed: () {
                                  Navigator.pop(context,true);
                                },
                                child: Text(
                                  "Aceptar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.White,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ]);
          });
      break;

    case AlertDialogType.preguntasSecretasActualizadas:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: responsive.hp(3)),
                                  child: Image.asset('assets/images/verifica.png',
                                    fit:BoxFit.contain,
                                    height: responsive.hp(5),
                                    width: responsive.hp(4),
                                  )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Tus preguntas de seguridad se \nactualizaron correctamente",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.width * 0.04,
                                  bottom: responsive.height * 0.01,
                                ),
                                child: Center(
                                  child: Text(
                                    "Estas preguntas de seguridad son las mismas para todas las plataformas digitales disponibles para ti.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only( bottom: responsive.height * 0.02,  top: responsive.height * 0.01),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else{
                                      Navigator.pop(context);
                                      customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, FuncionAlerta);
                                    }

                                  },
                                  child: Text(
                                    "CERRAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;
  }
}

void FuncionAlerta(bool abc){

}
