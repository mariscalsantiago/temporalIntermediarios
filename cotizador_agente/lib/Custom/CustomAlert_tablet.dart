import 'dart:io';
import 'dart:ui';

import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:cotizador_agente/Custom/Crypto.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
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
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:device_info/device_info.dart';
import 'package:system_settings/system_settings.dart';
import 'package:url_launcher/url_launcher.dart';

var isShowAlert = false;

enum AlertDialogTypeTablet {
  inactividad,
  testUno,
  archivoInvalido,
  acesso_camara_galeria,
  ajustes_sin_guardar,
  opciones_de_inicio_de_sesion,
  huella,
  //terminosYcondiciones_Huella,
  activacionExitosa_Huella,
  EnOtroMomento_Huella,
  verificaTuNumeroCelular,
  Reconocimiento_facial,
  activacionExitosa_Reconocimiento_facial,
  //terminosYcondiciones_reconocimiento_facial,
  EnOtroMomento_reconocimiento_facial,
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
  Desactivar_huella_digital,
  Desactivar_recoFacial,
  DatosMoviles_Activados,
  En_mantenimiento_cel,
  En_mantenimiento_llave,
  Sin_acceso_herramientas_cotizacion,
  menu_home,
  errorServicio,
  contrasena_actualiza_correctamente,
  preguntasSecretasActualizadas,
  inicio_de_sesion_inactivo_contador,
  versionTag,
  inicio_de_sesion_con_huella_bloqueado,
  inicio_de_sesion_con_facial_bloqueado,
  inicio_de_sesion_active_faceID,
  Contrasena_diferente_a_las_3_anteriores,
  Contrasena_diferente_a_las_3_anteriores_nueva
}

void customAlertTablet(AlertDialogTypeTablet type, BuildContext context,
    String title, String message, Responsive responsive, Function callback) {
  switch (type) {
    case AlertDialogTypeTablet.inicio_de_sesion_active_faceID:
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
                                  "Inicio de sesión con reconocimiento facial fue declinado",
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
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: responsive.width * 0.04,
                                ),
                                child: Center(
                                  child: Text(
                                    "Para continuar con inicio inicio de sesión de biométricos, debe ir a configuraciones de tu dispositivo y activar.",
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
                                    Navigator.of(context).pop();
                                    // SystemSettings.defaultApps();
                                  },
                                  child: Text(
                                    "Aceptar",
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
    case AlertDialogTypeTablet.inactividad:
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
    case AlertDialogTypeTablet.testUno:
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
                                      Navigator.pop(context, true);
                                    },
                                  ), // replace with your buttons
                                ],
                              ),
                            ),
                          )
                        ])));
          });
      break;
    case AlertDialogTypeTablet.archivoInvalido:
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
                                Navigator.pop(context, true);
                              },
                            ),

                            RaisedButton(
                              child: Text("cerrar"),
                              onPressed: () {
                                Navigator.pop(context, true);
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

    case AlertDialogTypeTablet.acesso_camara_galeria:
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
                                Navigator.pop(context, true);
                              },
                            ),
                            RaisedButton(
                              child: Text("En otro momento"),
                              onPressed: () {
                                prefs.setBool("activarBiometricos", false);
                                Navigator.pop(context, true);
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
    case AlertDialogTypeTablet.ajustes_sin_guardar:
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
                                callback();
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
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

    case AlertDialogTypeTablet.opciones_de_inicio_de_sesion:
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    color: Theme.Colors.White,
                    child: Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(40),
                        child: Card(
                          shape: null,
                          elevation: 0,
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01),
                                child: Center(
                                  child: Text(
                                    "Opciones de inicio de sesión",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.03,
                                      bottom: responsive.height * 0.03,
                                      right: responsive.wp(1),
                                      left: responsive.wp(5)),
                                  child: Text(
                                    "Al activar la funcionalidad permites iniciar sesión en tu App Intermediario GNP usando los datos biométricos que tienes activados en este dispositivo.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.6)),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.01,
                                  left: responsive.wp(4),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, true);
                                    customAlertTablet(
                                        AlertDialogTypeTablet.huella,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        callback);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        color: Theme.Colors.Encabezados,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: responsive.width * 0.07,
                                            bottom: responsive.height * 0.02,
                                          ),
                                          child: Text(
                                            "Huella digital",
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.5)),
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: responsive.wp(4)),
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
                                  bottom: responsive.height * 0.01,
                                  left: responsive.wp(4),
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      customAlertTablet(
                                          AlertDialogTypeTablet
                                              .Reconocimiento_facial,
                                          context,
                                          "",
                                          "",
                                          responsive,
                                          callback);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  color: Theme.Colors
                                                      .Funcional_Textos_Body,
                                                  fontSize: responsive.ip(1.5)),
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: responsive.wp(4)),
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
                                  width: responsive.wp(40),
                                  margin: EdgeInsets.only(
                                    bottom: responsive.height * 0.01,
                                    top: responsive.height * 0.01,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    color: Theme.Colors.GNP,
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        callback();
                                        Navigator.pop(context, true);
                                      } else {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        callback(false);
                                        Navigator.pop(context, true);
                                        if (prefs.getBool(
                                                    "flujoCompletoLogin") !=
                                                null &&
                                            prefs.getBool(
                                                "flujoCompletoLogin")) {
                                        } else {
                                          customAlertTablet(
                                              AlertDialogTypeTablet
                                                  .verificaTuNumeroCelular,
                                              context,
                                              "",
                                              "",
                                              responsive,
                                              callback);
                                        }
                                      }
                                    },
                                    child: Text(
                                      "EN OTRO MOMENTO",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(1.5)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]);
          });
      break;

    case AlertDialogTypeTablet.huella:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
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
                                      "¡Activa tu ingreso con huella digital!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.04,
                                      bottom: responsive.height * 0.01,
                                      right: responsive.wp(2.5),
                                      left: responsive.wp(2.5)),
                                  child: Text(
                                    "Al activar esta funcionalidad podrás iniciar sesión en tu App Intermediario GNP más rápido con cualquier huella registrada en este dispositivo.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.2)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.01),
                                  child: Center(
                                    child: Icon(
                                      Icons.fingerprint,
                                      color: Theme.Colors.GNP,
                                      size: responsive.ip(6),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: responsive.hp(3),
                                  width: responsive.wp(50),
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.wp(2),
                                      right: responsive.wp(2)),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    color: Theme.Colors.GNP,
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TerminosYCondicionesPage(
                                                    responsive: responsive,
                                                    callback: callback,
                                                  )));
                                    },
                                    child: Text(
                                      "ACEPTAR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(1.6),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.03,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .EnOtroMomento_Huella,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      },
                                      child: Text(
                                        "EN OTRO MOMENTO",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            );
          });
      break;

    /* case AlertDialogTypeTablet.terminosYcondiciones_Huella:
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
                              customAlertTablet(
                                  AlertDialogTypeTablet.activacionExitosa_Huella,
                                  context,
                                  "",
                                  "",
                                  responsive, callback);
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
*/
    case AlertDialogTypeTablet.activacionExitosa_Huella:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Container(
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01),
                                child: Center(
                                  child: Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.green,
                                    size: responsive.ip(5),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.02),
                                child: Center(
                                  child: Text(
                                    "Activación exitosa de huella digital",
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.6)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.02,
                                  left: responsive.width * 0.02,
                                  right: responsive.width * 0.02,
                                ),
                                child: Text(
                                  "Ya puedes iniciar sesión solo con tu huella digital.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.2)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    bottom: responsive.height * 0.02),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      print(
                                          "-----------Exito----------------------");
                                      if (prefs.getBool("primeraVez") ||
                                          prefs.getBool("flujoCompletoLogin") ==
                                              null ||
                                          !prefs
                                              .getBool("flujoCompletoLogin")) {
                                        if (prefs.getBool(
                                                    'primeraVezIntermediario') !=
                                                null &&
                                            prefs.getBool(
                                                'primeraVezIntermediario')) {
                                          Navigator.pop(context, true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        } else {
                                          if (deviceType == ScreenType.phone) {
                                            print("Verifica codigo celular");
                                            Navigator.pop(context, true);
                                            customAlertTablet(
                                                AlertDialogTypeTablet
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          } else {
                                            Navigator.pop(context, true);
                                            customAlertTablet(
                                                AlertDialogTypeTablet
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          }
                                        }
                                      } else {
                                        if (prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) {
                                          callback();
                                          Navigator.pop(context, true);
                                        } else {
                                          print("Exito----------------------");
                                          callback(true, responsive);
                                          Navigator.pop(context, true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        responsive: responsive,
                                                      ),settings: RouteSettings(name: "Home")));
                                        }
                                      }
                                      prefs.setBool(
                                          "aceptoTerminos", checkedValue);
                                    },
                                    child: Text(
                                      "CERRAR",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                              )
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
    case AlertDialogTypeTablet.EnOtroMomento_Huella:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Container(
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    right: responsive.wp(2),
                                    left: responsive.wp(2)),
                                child: Center(
                                  child: Text(
                                    "El incio de sesión con tu huella digital es más rápido",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.5)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(2),
                                    left: responsive.wp(26.5),
                                    right: responsive.wp(2),
                                    bottom: responsive.hp(3)),
                                child: Text(
                                  "¿Deseas cancelar la configuración?",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.2)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(3),
                                  width: responsive.wp(46),
                                  margin: EdgeInsets.only(
                                    bottom: responsive.height * 0.01,
                                    top: responsive.height * 0.01,
                                    right: responsive.wp(4),
                                    left: responsive.wp(4),
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    color: Theme.Colors.GNP,
                                    onPressed: () {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        callback();
                                        Navigator.pop(context, true);
                                      } else if (prefs.getBool(
                                                  "flujoCompletoLogin") !=
                                              null &&
                                          prefs.getBool("flujoCompletoLogin")) {
                                        Navigator.pop(context, true);
                                        callback(false, responsive);
                                      } else {
                                        Navigator.pop(context, true);
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        callback(false, responsive);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      }
                                    },
                                    child: Text(
                                      "SÍ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01,
                                    bottom: responsive.height * 0.02),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, true);

                                      customAlertTablet(
                                          AlertDialogTypeTablet.huella,
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
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
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
    case AlertDialogTypeTablet.verificaTuNumeroCelular:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(35),
                          child: Card(
                            color: Theme.Colors.White,
                            shape: null,
                            elevation: 0,
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
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.02,
                                      bottom: responsive.height * 0.0001,
                                      right: responsive.width * 0.02),
                                  child: Text(
                                    "Te enviamos un código de verificación por SMS al número " +
                                        numero(),
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontWeight: FontWeight.normal,
                                        fontSize: responsive.ip(1.2)),
                                  ),
                                ),
                                Image.asset(
                                  "assets/login/verificaNumero.png",
                                  height: responsive.hp(10.0),
                                  width: responsive.wp(8),
                                ),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                        width: responsive.width,
                                        margin: EdgeInsets.only(
                                            top: responsive.height * 0.01,
                                            left: responsive.width * 0.02,
                                            bottom: responsive.height * 0.01,
                                            right: responsive.width * 0.02),
                                        color: Theme.Colors.GNP,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: responsive.height * 0.01,
                                                left: responsive.width * 0.02,
                                                bottom:
                                                    responsive.height * 0.001,
                                                right: responsive.width * 0.02),
                                            child: Text(
                                              "ACEPTAR \n",
                                              style: TextStyle(
                                                  color: Theme.Colors.backgroud,
                                                  fontSize: responsive
                                                      .ip(responsive.ip(0.07))),
                                              textAlign: TextAlign.center,
                                            ))),
                                    onPressed: () async {
                                      if (prefs.getBool("esFlujoBiometricos") !=
                                              null &&
                                          prefs.getBool("esFlujoBiometricos")) {
                                        print("flujo biomertricos");
                                        callback(true, responsive);
                                        Navigator.pop(context, true);
                                      } else {
                                        print("sin biomertricos");
                                        callback(responsive);
                                        Navigator.pop(context, true);
                                      }
                                    }),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: responsive.hp(0.6)),
                                        child: Text("NO ES MI NÚMERO ACTUAL",
                                            style: TextStyle(
                                                color: Theme.Colors.GNP),
                                            textAlign: TextAlign.center)),
                                    onPressed: () {
                                      Navigator.pop(context, true);
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogTypeTablet.Reconocimiento_facial:
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    color: Theme.Colors.White,
                    child: Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(40),
                        child: Card(
                          shape: null,
                          elevation: 0,
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: responsive.wp(2),
                                    right: responsive.wp(2)),
                                child: Center(
                                  child: Text(
                                    "¡Activa tu ingreso con reconocimiento facial!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.4)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    right: responsive.wp(2.5),
                                    left: responsive.wp(2.5)),
                                child: Text(
                                  "Al activar esta funcionalidad podrás iniciar sesión en tu App Intermediario GNP más rápido con cualquier rostro registrado en este dispositivo.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.2)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01),
                                child: Center(
                                  child: Icon(
                                    Theme.Icons.facial,
                                    color: Theme.Colors.GNP,
                                    size: responsive.ip(5),
                                  ),
                                ),
                              ),
                              Container(
                                height: responsive.hp(3),
                                width: responsive.wp(50),
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.wp(2.5),
                                    right: responsive.wp(2.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                    if (prefs.getBool("esPerfil") != null &&
                                        prefs.getBool("esPerfil")) {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback();
                                      Navigator.pop(context, true);
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false);
                                      Navigator.pop(context, true);
                                      if (prefs.getBool("flujoCompletoLogin") !=
                                              null &&
                                          prefs.getBool("flujoCompletoLogin")) {
                                      } else {
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      }
                                    }
                                  },
                                  child: Text(
                                    "ACEPTAR",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.Colors.White,
                                      fontSize: responsive.ip(1.4),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    bottom: responsive.height * 0.02),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      customAlertTablet(
                                          AlertDialogTypeTablet
                                              .EnOtroMomento_reconocimiento_facial,
                                          context,
                                          "",
                                          "",
                                          responsive,
                                          callback);
                                    },
                                    child: Text(
                                      "EN OTRO MOMENTO",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          });
      break;

    case AlertDialogTypeTablet.Reconocimiento_facial:
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
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "El incio de sesión con reconocimiento facial es más rápido",
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
                                "¿Deseas cancelar la configuración?",
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
                                    Navigator.pop(context, true);
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
                                    Navigator.pop(context, true);
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

    case AlertDialogTypeTablet.activacionExitosa_Reconocimiento_facial:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(60),
                          height: responsive.hp(40),
                          child: Card(
                            color: Theme.Colors.White,
                            shape: null,
                            elevation: 0,
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
                                      size: responsive.ip(4),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.05),
                                  child: Text(
                                    "Activación exitosa de reconocimiento facial.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.05,
                                    left: responsive.width * 0.03,
                                  ),
                                  child: Text(
                                    "Ya puedes iniciar sesión mostrando solo tu rostro.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.6)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.03,
                                      bottom: responsive.height * 0.01),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            "-----------Exito----------------------");
                                        if (prefs.getBool("primeraVez") ||
                                            prefs.getBool(
                                                    "flujoCompletoLogin") ==
                                                null ||
                                            !prefs.getBool(
                                                "flujoCompletoLogin")) {
                                          if (prefs.getBool(
                                                      'primeraVezIntermediario') !=
                                                  null &&
                                              prefs.getBool(
                                                  'primeraVezIntermediario')) {
                                            Navigator.pop(context, true);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          } else {
                                            if (deviceType ==
                                                ScreenType.phone) {
                                              print("Verifica codigo celular");
                                              Navigator.pop(context, true);
                                              customAlertTablet(
                                                  AlertDialogTypeTablet
                                                      .verificaTuNumeroCelular,
                                                  context,
                                                  "",
                                                  "",
                                                  responsive,
                                                  callback);
                                            } else {
                                              Navigator.pop(context, true);
                                              customAlertTablet(
                                                  AlertDialogTypeTablet
                                                      .verificaTuNumeroCelular,
                                                  context,
                                                  "",
                                                  "",
                                                  responsive,
                                                  callback);
                                            }
                                          }
                                        } else {
                                          if (prefs.getBool("esPerfil") !=
                                                  null &&
                                              prefs.getBool("esPerfil")) {
                                            Navigator.pop(context, true);
                                          } else {
                                            print(
                                                "Exito----------------------");
                                            Navigator.pop(context, true);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                          responsive:
                                                              responsive,
                                                        ),settings: RouteSettings(name: "Home")));
                                          }
                                        }
                                        prefs.setBool(
                                            "aceptoTerminos", checkedValue);
                                        callback();
                                      },
                                      child: Text(
                                        "CERRAR",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(2)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    /*case AlertDialogTypeTablet.terminosYcondiciones_reconocimiento_facial:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Scaffold(
                appBar: AppBar(
                elevation: 0.0,
                leading: IconButton(
                icon:Icon(Icons.cancel, color: Theme.Colors.GNP,),
            onPressed: (){
            Navigator.pop(context,true);
            },
            ),
            backgroundColor: Theme.Colors.White,
            ),
            body: Container(
            color: Theme.Colors.White,
            child:Stack(
                children: [
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*
                      Container(
                        width: responsive.width,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context,true);
                              customAlert(
                                  AlertDialogType
                                      .activacionExitosa_Reconocimiento_facial,
                                  context,
                                  "",
                                  "",
                                  responsive);
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
                      */
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
                    ],
                  ),
                ],
              ),)
            );
          });
      break;
      */

    case AlertDialogTypeTablet.EnOtroMomento_reconocimiento_facial:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right: responsive.wp(2.5),
                                      left: responsive.wp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "El inicio de sesión con reconocimiento facial es más rápido",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.03),
                                  child: Text(
                                    "¿Deseas cancelar la configuración?",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.2)),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.01,
                                      top: responsive.height * 0.01,
                                      right: responsive.wp(2.5),
                                      left: responsive.wp(2.5),
                                    ),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: Theme.Colors.GNP,
                                      onPressed: () {
                                        if (prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) {
                                          prefs.setBool(
                                              "activarBiometricos", false);
                                          callback();
                                          Navigator.pop(context, true);
                                        } else if (prefs.getBool(
                                                    "flujoCompletoLogin") !=
                                                null &&
                                            prefs.getBool(
                                                "flujoCompletoLogin")) {
                                          Navigator.pop(context, true);
                                          callback(false, responsive);
                                        } else {
                                          Navigator.pop(context, true);
                                          prefs.setBool(
                                              "activarBiometricos", false);
                                          callback(false, responsive);
                                          customAlertTablet(
                                              AlertDialogTypeTablet
                                                  .verificaTuNumeroCelular,
                                              context,
                                              "",
                                              "",
                                              responsive,
                                              callback);
                                        }
                                      },
                                      child: Text(
                                        "SÍ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.White,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.01,
                                      bottom: responsive.height * 0.01),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .Reconocimiento_facial,
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
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Sesionfinalizada_por_intentos_huella:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(70),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(5)),
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
                                  child: Center(
                                    child: Text(
                                      "Has superado los intentos permitidos de huella digital, por seguridad inicia sesión nuevamente.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogTypeTablet
        .Sesionafinalizada_por_contrasena_debeserdiferente:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(0.02)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Contraseña inválida",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.01),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.02,
                                      right: responsive.width * 0.02,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Tu nueva contraseña debe ser diferente a la actual.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.01,
                                      top: responsive.height * 0.01,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Contrasena_invalida_debeserdiferente_a_la_actual:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(2)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.hp(2.5),
                                      bottom: responsive.hp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Contraseña inválida",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      right: responsive.wp(2.5),
                                      left: responsive.wp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Tu nueva contraseña debe ser diferente a la actual.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.2)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Correo_electronico_o_contrasena_no_coinciden:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(60),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(5)),
                                  child: Center(
                                    child: Text(
                                      "No se puede iniciar sesión",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(2)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: responsive.width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Correo electrónico o contraseña no coinciden",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.6)),
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
                                        Navigator.pop(context, true);
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogTypeTablet.Correo_no_registrado:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1.5)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(3),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Correo no registrado",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.15)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.015),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.wp(2.5),
                                      right: responsive.wp(2.5),
                                      bottom: responsive.height * 0.015,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "El correo que ingresaste aún no ha sido registrado.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Cuenta_inactiva:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1.5)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(3.5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Cuenta inactiva",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.15)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.015,
                                      left: responsive.ip(1.5),
                                      right: responsive.ip(1.5)),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.015,
                                    ),
                                    child: Center(
                                        child: Text.rich(TextSpan(
                                            text:
                                                'Para mayor información o reactivar tu cuenta comunicate a Soporte GNP al ',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.2)),
                                            children: <InlineSpan>[
                                          TextSpan(
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () {
                                                    print("numero");
                                                    launch('tel:5552273966');
                                                  },
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme.Colors.GNP,
                                                fontSize: responsive.ip(1.2)),
                                          ),
                                          TextSpan(
                                            text:
                                                'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.2)),
                                          ),
                                        ]))),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(1.5),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Cuenta_bloqueada:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1.5)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(3),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(1.5)),
                                  child: Center(
                                    child: Text(
                                      "Tu cuenta ha sido bloqueada",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.15)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.02,
                                      bottom: responsive.height * 0.015),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.02,
                                      right: responsive.width * 0.02,
                                      bottom: responsive.height * 0.015,
                                    ),
                                    child: Center(
                                        child: Text.rich(TextSpan(
                                            text:
                                                'Para desbloquearla, comunicate a Soporte GNP al ',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.2)),
                                            children: <InlineSpan>[
                                          TextSpan(
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () {
                                                    print("numero");
                                                    launch('tel:5552273966');
                                                  },
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme.Colors.GNP,
                                                fontSize: responsive.ip(1.2)),
                                          ),
                                          TextSpan(
                                            text:
                                                'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.2)),
                                          ),
                                        ]))),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Cuenta_temporalmente_bloqueada:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(35),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1.5)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(3),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.hp(1),
                                    left: responsive.wp(1),
                                    right: responsive.wp(1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Tu cuenta está temporalmente bloqueada",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.015),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.02,
                                      right: responsive.width * 0.02,
                                      bottom: responsive.height * 0.01,
                                    ),
                                    child: Center(
                                        child: Text.rich(TextSpan(
                                            text:
                                                'Para desbloquearla, comunicate a Soporte GNP al ',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.22)),
                                            children: <InlineSpan>[
                                          TextSpan(
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme.Colors.GNP,
                                                fontSize: responsive.ip(1.22)),
                                          ),
                                          TextSpan(
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () {
                                                    print("numero");
                                                    launch('tel:5552273966');
                                                  },
                                            text:
                                                'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme.Colors
                                                    .Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.22)),
                                          ),
                                        ]))),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.01,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Rostro_no_reconocido:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(35),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2.5)),
                                  child: Center(
                                    child: Text(
                                      "Rostro no reconocido",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.03),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.04,
                                      left: responsive.wp(3),
                                      right: responsive.wp(3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Has superado los intentos permitidos de reconocimiento facial, por seguridad inicia sesión nuevamente.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        if ((prefs.getBool("esPerfil") !=
                                                    null &&
                                                prefs.getBool("esPerfil")) ||
                                            (prefs.getBool(
                                                        "subSecuentaIngresoCorreo") !=
                                                    null &&
                                                prefs.getBool(
                                                    "subSecuentaIngresoCorreo"))) {
                                          if (prefs.getBool("esPerfil")) {
                                            prefs.setBool(
                                                "activarBiometricos", false);
                                          } else {
                                            prefs.setBool(
                                                "activarBiometricos", true);
                                          }
                                          callback();
                                          Navigator.pop(context, true);
                                        } else {
                                          Navigator.pop(context, true);
                                          prefs.setBool(
                                              "activarBiometricos", false);
                                          callback(false, responsive);
                                          customAlertTablet(
                                              AlertDialogTypeTablet
                                                  .verificaTuNumeroCelular,
                                              context,
                                              "",
                                              "",
                                              responsive,
                                              callback);
                                        }
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    case AlertDialogTypeTablet.Rostro_no_reconocido_2:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1.5)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Rostro no reconocido",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.wp(3),
                                      right: responsive.wp(3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No se ha podido reconocer tu rostro, por favor vuelve a intentarlo.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        callback();
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Huella_no_reconocida:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(35),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Huella digital no reconocida",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.03),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.wp(3),
                                      right: responsive.wp(3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Has superado los intentos permitidos para identificar tu huella digital, por seguridad inicia sesión nuevamente.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.2)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        if ((prefs.getBool("esPerfil") !=
                                                    null &&
                                                prefs.getBool("esPerfil")) ||
                                            (prefs.getBool(
                                                        "subSecuentaIngresoCorreo") !=
                                                    null &&
                                                prefs.getBool(
                                                    "subSecuentaIngresoCorreo"))) {
                                          if (prefs.getBool("esPerfil")) {
                                            prefs.setBool(
                                                "activarBiometricos", false);
                                          } else {
                                            prefs.setBool(
                                                "activarBiometricos", true);
                                          }
                                          Navigator.pop(context, true);
                                          callback();
                                        } else {
                                          Navigator.pop(context, true);
                                          prefs.setBool(
                                              "activarBiometricos", false);
                                          callback(false, responsive);
                                          customAlertTablet(
                                              AlertDialogTypeTablet
                                                  .verificaTuNumeroCelular,
                                              context,
                                              "",
                                              "",
                                              responsive,
                                              callback);
                                        }
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Numero_de_celular_verificado:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.verified_user_outlined,
                                          color: Colors.green,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(5)),
                                  child: Center(
                                    child: Text(
                                      "Número de celular verificado",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.04,
                                      left: responsive.width * 0.04,
                                      bottom: responsive.height * 0.03),
                                  child: Center(
                                    child: Text(
                                      "Mantener tu número de celular actualizado te permitirá agilizar ciertos trámites, por ejemplo si olvidas la contraseña de tu cuenta.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.2)),
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
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Numero_de_celular_actualizado_correctamente:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(3)),
                                        child: Icon(
                                          Icons.verified_user_outlined,
                                          color: Colors.green,
                                          size: responsive.ip(5),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(5)),
                                  child: Center(
                                    child: Text(
                                      "Número de celular actualizado exitosamente",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.04,
                                      left: responsive.width * 0.04,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
                                    child: Text(
                                      "Ahora recibirás notificaciones en este número.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.02,
                                      top: responsive.height * 0.01,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () async {
                                        if (prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil") &&
                                            prefs.getBool(
                                                "esActualizarNumero")) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          callback(responsive);
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogTypeTablet.AjustesSinGuardar_camara:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(2)),
                                    child: Text(
                                      "Tienes ajustes sin guardar",
                                      style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.hp(3.5),
                                      left: responsive.width * 0.03),
                                  child: Text(
                                    "¿Quieres descartarlos?",
                                    style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                        top: responsive.hp(3.5)),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: Theme.Colors.GNP,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "DESCARTAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.White,
                                            fontSize: responsive.ip(1.6)),
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
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "SEGUIR MODIFICANDO",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.Desactivar_huella_digital:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: responsive.hp(1.2)),
                                    child: Text(
                                      "Desactivar huella digital",
                                      style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.hp(2),
                                      left: responsive.wp(2),
                                      right: responsive.wp(2),
                                      bottom: responsive.hp(2)),
                                  child: Text(
                                    "Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n \n ¿Deseas desactivarla?",
                                    style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.2),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                        top: responsive.hp(2),
                                        right: responsive.wp(2),
                                        left: responsive.wp(2)),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: Theme.Colors.GNP,
                                      onPressed: () {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        isSwitchedPerfill = false;
                                        callback();
                                        Navigator.pop(context, false);
                                      },
                                      child: Text(
                                        "SÍ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.White,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                        top: responsive.height * 0.02,
                                        bottom: responsive.height * 0.02),
                                    child: TextButton(
                                      onPressed: () {
                                        prefs.setBool(
                                            "activarBiometricos", true);
                                        isSwitchedPerfill = true;
                                        callback();
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.6)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.Desactivar_recoFacial:
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(30),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: responsive.hp(2)),
                                    child: Text(
                                      "Desactivar reconocimiento facial",
                                      style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(1.6),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.hp(2),
                                      left: responsive.width * 0.025,
                                      right: responsive.width * 0.025),
                                  child: Text(
                                    "Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n \n ¿Deseas desactivarla?",
                                    style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.2),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                        top: responsive.hp(4),
                                        right: responsive.wp(2),
                                        left: responsive.wp(2)),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: Theme.Colors.GNP,
                                      onPressed: () {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        isSwitchedPerfill = false;
                                        callback();
                                        Navigator.pop(context, false);
                                      },
                                      child: Text(
                                        "SÍ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.White,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(3),
                                    width: responsive.wp(50),
                                    margin: EdgeInsets.only(
                                        top: responsive.height * 0.02,
                                        bottom: responsive.height * 0.02),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "NO",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.DatosMoviles_Activados:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
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
                                      size: responsive.ip(4),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02),
                                  child: Center(
                                    child: Text(
                                      "Datos móviles activados",
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
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
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.6)),
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
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.En_mantenimiento_cel:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
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
                                      Icons.app_settings_alt,
                                      color: Colors.blueAccent,
                                      size: responsive.ip(4),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02),
                                  child: Center(
                                    child: Text(
                                      "En mantenimiento",
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.width * 0.03,
                                  ),
                                  child: Text(
                                    "Estamos mejorando tu App Intermediario GNP.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.4)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.04,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .En_mantenimiento_llave,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.En_mantenimiento_llave:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
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
                                      Icons.settings_outlined,
                                      color: Colors.blueAccent,
                                      size: responsive.ip(4),
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
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    left: responsive.width * 0.03,
                                  ),
                                  child: Text(
                                    "Estamos mejorando tu App Intermediario GNP.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.4)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.03,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .En_mantenimiento_llave,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.Sin_acceso_herramientas_cotizacion:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: responsive.hp(15),
                                  width: responsive.wp(15),
                                  margin: EdgeInsets.only(),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/info_24px.png",
                                      fit: BoxFit.contain,
                                      height: responsive.hp(7),
                                      width: responsive.wp(7),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(),
                                  child: Center(
                                    child: Text(
                                      "Sin acesso a herramientas de cotización",
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.width * 0.05,
                                    right: responsive.width * 0.05,
                                  ),
                                  child: Text(
                                    "Debido a tus permisos asignados no es posible ingresar a las herramientas de cotización.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.3)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.03,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.4)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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

    case AlertDialogTypeTablet.inicio_de_sesion_inactivo_contador:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(2)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Inicio de sesión inactivo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: responsive.width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Has superado el número permitido de intentos para iniciar sesión, en un momento podrás intentarlo de nuevo.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.00,
                                      top: responsive.height * 0.02,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.errorServicio:
      showDialog(
          barrierDismissible: false,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: responsive.width,
                    color: Theme.Colors.White,
                    child: Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(40),
                        child: Card(
                          shape: null,
                          elevation: 0,
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.hp(2),
                                      bottom: responsive.hp(2)),
                                  child: Icon(
                                    Icons.warning_amber_outlined,
                                    color: Colors.redAccent,
                                    size: responsive.ip(4),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Servicio no disponible",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(1.8)),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.02,
                                      right: responsive.wp(5),
                                      left: responsive.wp(5)),
                                  child: Text.rich(TextSpan(
                                      text:
                                          "Por el momento no podemos completar tu solicitud, inténtalo más tarde. Si el error persiste, comunícate a Soporte GNP al ",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.3)),
                                      children: <InlineSpan>[
                                        TextSpan(
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () {
                                                    print("numero");
                                                    launch('tel:+525552273966');
                                                  },
                                            text: "55 5227 3966 ",
                                            style: TextStyle(
                                              color: Theme.Colors.GNP,
                                              fontSize: responsive.ip(1.3),
                                            )),
                                        TextSpan(
                                          text:
                                              "en un horario de lunes a viernes de 8:00 a 20:00 hrs. y sábados de 8:00 a 14:00 hrs.",
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(1.3)),
                                        ),
                                      ]))),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin: EdgeInsets.only(
                                    bottom: responsive.height * 0.02,
                                  ),
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      "CERRAR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.4)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]);
          });
      break;

    case AlertDialogTypeTablet.menu_home:
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
                      onTap: () {
                        switch (opcionElegida) {
                          case HomeSelection.Atuos:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AutosPage(responsive: responsive)),
                            );
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
                                margin: EdgeInsets.only(
                                    top: responsive.hp(3.5),
                                    right: responsive.wp(1),
                                    left: responsive.wp(8)),
                                child: Image.asset(
                                  "assets/cotizar.png",
                                  fit: BoxFit.contain,
                                  height: responsive.hp(5),
                                  width: responsive.wp(5),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(5),
                                    left: responsive.wp(8),
                                    right: responsive.wp(1),
                                    bottom: responsive.hp(16)),
                                child: Text(
                                  "Cotizar",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),
                                ),
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

    case AlertDialogTypeTablet.contrasena_actualiza_correctamente:
      Inactivity(context: context).cancelInactivity();
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
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(2)),
                                      child: Image.asset(
                                        'assets/images/verifica.png',
                                        fit: BoxFit.contain,
                                        height: responsive.hp(5),
                                        width: responsive.hp(4),
                                      )),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(4)),
                                  child: Center(
                                    child: Text(
                                      "Tu contraseña se actualizó \ncorrectamente",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.3)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.04,
                                      right: responsive.width * 0.04,
                                      bottom: responsive.height * 0.01),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: responsive.width * 0.04,
                                      right: responsive.width * 0.04,
                                      bottom: responsive.height * 0.01,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Esta contraseña es la misma para ingresar a todas nuestras plataformas digitales disponibles para ti.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.3)),
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
                                        top: responsive.height * 0.01),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        if (prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else if (prefs.getBool(
                                                    "flujoOlvideContrasena") !=
                                                null &&
                                            prefs.getBool(
                                                "flujoOlvideContrasena")) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PrincipalFormLogin(
                                                              responsive:
                                                                  responsive),settings: RouteSettings(name: "Login")));
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PreguntasSecretas(
                                                              responsive:
                                                                  responsive)));
                                        }
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.preguntasSecretasActualizadas:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(2)),
                                      child: Image.asset(
                                        'assets/images/verifica.png',
                                        fit: BoxFit.contain,
                                        height: responsive.hp(4),
                                        width: responsive.hp(3),
                                      )),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Tus preguntas de seguridad se \nactualizaron correctamente",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.6)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.04,
                                      bottom: responsive.height * 0.01),
                                  child: Center(
                                    child: Text(
                                      "Estas preguntas de seguridad son las mismas para todas las plataformas digitales disponibles para ti.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.3)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                        top: responsive.height * 0.01),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        if (prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          customAlertTablet(
                                              AlertDialogTypeTablet
                                                  .verificaTuNumeroCelular,
                                              context,
                                              "",
                                              "",
                                              responsive,
                                              callback);
                                        }
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.versionTag:
      showDialog(
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(80),
                          child: Card(
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(2)),
                                        child: Icon(
                                          Icons.tag_faces_outlined,
                                          color: Colors.green,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Tag : 2.2.5",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(2.3)),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: responsive.hp(60),
                                  child: SingleChildScrollView(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: deviceData.keys
                                          .map((String property) {
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                property,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 0.0, 10.0),
                                              child: Text(
                                                '${deviceData[property]}',
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.inicio_de_sesion_con_huella_bloqueado:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            color: Theme.Colors.White,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Inicio de sesión con huella digital bloqueado",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: responsive.width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Por seguridad deberás iniciar sesión con tu contraseña.\n\nPara continuar utilizando el inicio de sesión con huella digital, deberás bloquear y desbloquear tu dispositivo.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.3)),
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
                                        Navigator.pop(context, true);
                                        callback();
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    case AlertDialogTypeTablet.inicio_de_sesion_con_facial_bloqueado:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: responsive.hp(1)),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.hp(2),
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Inicio de sesión con reconocimiento facial bloqueado",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.02,
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: responsive.width * 0.04,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Por seguridad deberás iniciar sesión con tu contraseña.\n\nPara continuar utilizando el inicio de sesión con reconocimiento facial, deberás bloquear y desbloquear tu dispositivo.",
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                      bottom: responsive.height * 0.01,
                                      top: responsive.height * 0.01,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        callback();
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

    case AlertDialogTypeTablet.Contrasena_diferente_a_las_3_anteriores:
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: responsive.width,
                      color: Theme.Colors.White,
                      child: Center(
                        child: Container(
                          width: responsive.wp(50),
                          height: responsive.hp(40),
                          child: Card(
                            shape: null,
                            elevation: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(),
                                        child: Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.red,
                                          size: responsive.ip(4),
                                        ))),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                  child: Center(
                                    child: Text(
                                      "Contraseña inválida",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.Encabezados,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      left: responsive.width * 0.06,
                                      right: responsive.width * 0.06,
                                      bottom: responsive.height * 0.01),
                                  child: Center(
                                    child: Text(
                                      "Tu nueva contraseña debe ser diferente a las 3 anteriores.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.3)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: responsive.hp(6.25),
                                    width: responsive.wp(90),
                                    margin: EdgeInsets.only(
                                      top: responsive.height * 0.01,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Theme.Colors.White,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "CERRAR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.3)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
  }
}

String numero() {
  if (prefs.getString("medioContactoTelefono") != null &&
      prefs.getString("medioContactoTelefono") != "") {
    String decryptedNumber = decryptAESCryptoJS(prefs.getString("medioContactoTelefono"),
        "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
    int numero = decryptedNumber.length;
    return "******" + decryptedNumber.substring(numero - 4, numero);
  } else {
    return "**********";
  }
}
