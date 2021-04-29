import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

var isShowAlert = false;

enum AlertDialogTypeTablet {
  errorConexion,
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
}

void customAlertTablet(AlertDialogTypeTablet type, BuildContext context, String title,
    String message, Responsive responsive) {

  switch (type) {
    case AlertDialogTypeTablet.errorConexion:
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
                              Icons.warning,
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
                                Navigator.pop(context,true);
                              },
                            ),
                            RaisedButton(
                              child: Text("En otro momento"),
                              onPressed: () {
                                Navigator.pop(context,true);
                                Row(
                                  children: [],
                                );
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: responsive.wp(50),
                      height: responsive.hp(30),
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.01, bottom:responsive.height * 0.01 ),
                              child: Center(
                                child: Text(
                                  "Opciones de inicio de sesión",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(1.6)),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.01,
                                    bottom: responsive.height * 0.02,
                                    right: responsive.wp(2),
                                    left: responsive.wp(2)),
                                child: Text(
                                  "Al activar la funcionalidad permites iniciar sesión en tu App Intermediario GNP usando los datos biométricos que tienes activados en este dispositivo.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1)),
                                )),
                            is_available_finger != false ? Container(
                              margin: EdgeInsets.only(
                                left: responsive.wp(1),
                                right: responsive.wp(1),
                                bottom: responsive.hp(1.5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,true);
                                  customAlertTablet(AlertDialogTypeTablet.huella, context, "",
                                      "", responsive);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.fingerprint,
                                      color: Theme.Colors.Encabezados,
                                      size: responsive.ip(3),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: responsive.width * 0.07, right: responsive.width * 0.07),

                                        child: Text(
                                          "Huella digital",
                                          style: TextStyle(
                                              color: Theme.Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(1.4),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ) : Container(),
                                is_available_face != false ? Container(
                              margin: EdgeInsets.only(
                                bottom: responsive.height * 0.01,
                                left: responsive.wp(1),
                                right: responsive.wp(1),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                    customAlertTablet(
                                        AlertDialogTypeTablet.Reconocimiento_facial,
                                        context,
                                        "",
                                        "",
                                        responsive);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.face,
                                        color: Theme.Colors.Encabezados,
                                        size: responsive.ip(3) ,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: responsive.width * 0.07, right: responsive.width * 0.07 ),
                                          child: Text(
                                            "Reconocimiento facial",
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.4)),
                                          )),
                                    ],
                                  )),
                            ): Container(),
                            Center(
                              child: Container(
                                height: responsive.hp(3),
                                width: responsive.wp(50),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.01,
                                  top: responsive.height * 0.01,
                                  right: responsive.wp(2),
                                  left: responsive.wp(2),
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
                                    "EN OTRO MOMENTO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(1.4)),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: responsive.wp(50),
                      height: responsive.hp(38),
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
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.2)),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.01),
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
                                  Navigator.pop(context,true);
                                  customAlertTablet(
                                      AlertDialogTypeTablet.terminosYcondiciones_reconocimiento_facial,
                                      context,
                                      "",
                                      "",
                                      responsive);
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
                                    Navigator.pop(context,true);
                                    customAlertTablet(
                                        AlertDialogTypeTablet.EnOtroMomento_Huella,
                                        context,
                                        "",
                                        "",
                                        responsive);
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
                ],
              ),
            ]);
          });
      break;

    case AlertDialogTypeTablet.terminosYcondiciones_Huella:
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
                    ],
                  ),
                ],
              ),
            );
          });
      break;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
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
                                    top: responsive.height * 0.02,
                                    bottom: responsive.height * 0.02),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(55),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.04, right: responsive.wp(2), left: responsive.wp(2)),
                                child: Center(
                                  child: Text(
                                    "El incio de sesión con tu huella digital es\n más rápido",
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
                                    left: responsive.wp(4),
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
                                  width: responsive.wp(50),
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
                                      Navigator.pop(context,true);
                                      customAlertTablet(AlertDialogTypeTablet.Desactivar_huella_digital, context,
                                          "", "", responsive);
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
                                      Navigator.pop(context,true);

                                      customAlertTablet(AlertDialogTypeTablet.huella, context,
                                          "", "", responsive);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(35),
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
                                  "Te enviamos un código de verificación por SMS al número ****1234.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                                              bottom: responsive.height * 0.001,
                                              right: responsive.width * 0.02),
                                          child: Text(
                                            "ACEPTAR \n",
                                            style: TextStyle(
                                                color: Theme.Colors.backgroud,
                                                fontSize: responsive
                                                    .ip(responsive.ip(0.07))),
                                            textAlign: TextAlign.center,
                                          ))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginCodigoVerificaion(
                                                  responsive: responsive,
                                                  isNumero: false,
                                                )));
                                  }),
                              CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: responsive.hp(0.6)),
                                      child: Text("NO ES MI NÚMERO ACTUAL",
                                          style:
                                              TextStyle(color: Theme.Colors.GNP),
                                          textAlign: TextAlign.center)),
                                  onPressed: () {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: responsive.wp(50),
                      height: responsive.hp(40),
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.03, left: responsive.wp(2), right: responsive.wp(2)),
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
                              margin:
                                  EdgeInsets.only(top: responsive.height * 0.01),
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
                                  Navigator.pop(context,true);
                                  customAlertTablet(
                                      AlertDialogTypeTablet
                                          .terminosYcondiciones_reconocimiento_facial,
                                      context,
                                      "",
                                      "",
                                      responsive);
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
                                    Navigator.pop(context,true);
                                    customAlertTablet(
                                        AlertDialogTypeTablet
                                            .EnOtroMomento_reconocimiento_facial,
                                        context,
                                        "",
                                        "",
                                        responsive);
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
                                  "El incio de sesión con reconocimiento facial es\n más rápido",
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
                                  Icons.verified_user,
                                  color: Colors.green,
                                  size: 57,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.05),
                              child: Center(
                                child: Text(
                                  "Activación Exitosa de reconocimiento facial",
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
                                "Ya puedes iniciar sesión con reconocimiento facial",
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

    case AlertDialogTypeTablet.terminosYcondiciones_reconocimiento_facial:
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.03, right: responsive.wp(2.5), left: responsive.wp(2.5)),
                                child: Center(
                                  child: Text(
                                    "El incio de sesión con reconocimiento facial es más rápido",
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
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogTypeTablet.Sesionfinalizada_por_dispositivo:
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
                                      Icons.warning,
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

    case AlertDialogTypeTablet.Sesionfinalizada_por_inactividad:
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
                                      Icons.warning,
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
                                      Icons.warning,
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

    case AlertDialogTypeTablet.Sesionafinalizada_por_contrasena_debeserdiferente:
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: responsive.hp(0.02)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(4),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2.5)),
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
                                      "Tu nueva contraseña debe ser diferente a las 3 contraseñas anteriores.",
                                      style: TextStyle(
                                          color:
                                              Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(2)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(5),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2.5), bottom: responsive.hp(2.5)),
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
                                    bottom: responsive.height * 0.02, right: responsive.wp(2.5), left: responsive.wp(2.5)),
                                child: Center(
                                  child: Text(
                                    "Tu nueva contraseña debe ser diferente a la actual.",
                                    style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: responsive.hp(3)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(4),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2), right: responsive.wp(2), left: responsive.wp(2)),
                                child: Center(
                                  child: Text(
                                    "Correo electrónico o contraseña no coinciden",
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
                                    bottom: responsive.height * 0.01),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: responsive.wp(2.5),
                                    right: responsive.wp(2.5),
                                    bottom: responsive.height * 0.015,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Por seguridad, tu cuenta se bloqueará después de 3 intentos.",
                                      style: TextStyle(
                                          color:
                                              Theme.Colors.Funcional_Textos_Body,
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
                                    top: responsive.height * 0.01,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(1.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(3),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2.5)),
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
                                      "El correo que ingresaste aún no ha sido registrado. Verifícalo e inténtalo nuevamente.",
                                      style: TextStyle(
                                          color:
                                          Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: responsive.hp(1.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(3.5),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2.5)),
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
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(1.2)),
                                          children: <InlineSpan>[
                                        TextSpan(
                                          text: '55 5227 3966 ',
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.GNP,
                                              fontSize: responsive.ip(1.2)),
                                        ),
                                        TextSpan(
                                          text:
                                              'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(1.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(3),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(1.5)),
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
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(1.2)),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: '55 5227 3966 ',
                                              style: TextStyle(
                                                  color: Theme
                                                      .Colors.GNP,
                                                  fontSize: responsive.ip(1.2)),
                                            ),
                                            TextSpan(
                                              text:
                                              'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                              style: TextStyle(
                                                  color: Theme
                                                      .Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(35),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(1.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(3),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(1), left: responsive.wp(1), right: responsive.wp(1), ),
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
                                    right:responsive.width * 0.02,
                                    bottom: responsive.height * 0.01,
                                  ),
                                  child: Center(
                                      child: Text.rich(TextSpan(
                                          text:
                                          'Para desbloquearla, comunicate a Soporte GNP al ',
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(1.22)),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: '55 5227 3966 ',
                                              style: TextStyle(
                                                  color: Theme
                                                      .Colors.GNP,
                                                  fontSize: responsive.ip(1.22)),
                                            ),
                                            TextSpan(
                                              text:
                                              'en un horario de lunes a viernes de 8:00 a 20:00 hrs y sábados de 8:00 a 14:00 hrs.',
                                              style: TextStyle(
                                                  color: Theme
                                                      .Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(35),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                margin: EdgeInsets.only(top: responsive.hp(2.5)),
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
                                          color:
                                          Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Container(
                                      margin:
                                      EdgeInsets.only(top: responsive.hp(1.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(5),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2)),
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
                                          color:
                                          Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(35),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                margin: EdgeInsets.only(top: responsive.hp(2)),
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
                                          color:
                                          Theme.Colors.Funcional_Textos_Body,
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
                                      Navigator.pop(context,true);
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
                                      Icons.verified_user,
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
                                      Icons.verified_user,
                                      color: Colors.green,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Número de celular actualizado exitosamente",
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
                                    "Ahora recibirás notificaciones en este número.",
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

    case AlertDialogTypeTablet.ArchivoInvalido_imagen:
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
                                  customAlertTablet(
                                      AlertDialogTypeTablet.Tienes_una_sesion_activa,
                                      context,
                                      "",
                                      "",
                                      responsive);
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

    case AlertDialogTypeTablet.Tienes_una_sesion_activa:
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: responsive.hp(1)),
                                  child: Text("Tienes una sesión activa",
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(1.4),
                                    ),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.wp(2), right: responsive.wp(2), bottom: responsive.hp(2)),
                                child: Text("Iniciada a las {hora} en {ciudad} desde\n {dispositivo}. ¿Deseas cerrar esa sesión e iniciar\n en este dispositivo?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.2),
                                  ),),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(3),
                                  width: responsive.wp(50),
                                  margin: EdgeInsets.only(top: responsive.hp(1), right: responsive.wp(2), left: responsive.wp(2)),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    color: Theme.Colors.GNP,
                                    onPressed: () {
                                      Navigator.pop(context,true);
                                      customAlertTablet(
                                          AlertDialogTypeTablet.DatosMoviles_Activados,
                                          context,
                                          "",
                                          "",
                                          responsive);
                                    },
                                    child: Text(
                                      "SÍ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(1.5)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.015,
                                    bottom: responsive.height * 0.025),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Text(
                                      "NO",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.5)),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: responsive.hp(1.2)),
                                  child: Text("Desactivar huella digital",
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(1.8),
                                    ),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2), left: responsive.wp(2), right: responsive.wp(2), bottom: responsive.hp(2)),
                                child: Text("Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n \n ¿Deseas desactivarla?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.2),
                                  ),),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(3),
                                  width: responsive.wp(50),
                                  margin: EdgeInsets.only(top: responsive.hp(2), right: responsive.wp(2), left: responsive.wp(2)),
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
                                          fontSize: responsive.ip(1.6)),
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
                                      Navigator.pop(context,true);
                                      customAlertTablet(AlertDialogTypeTablet.EnOtroMomento_Huella, context,
                                          "", "", responsive);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: responsive.wp(50),
                        height: responsive.hp(30),
                        child: Card(
                          color: Theme.Colors.White,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: responsive.hp(2)),
                                  child: Text("Desactivar reconocimiento facial",
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(1.6),
                                    ),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(2), left: responsive.width * 0.025, right: responsive.width * 0.025),
                                child: Text("Al desactivar esta funcionalidad iniciarás sesión solo con contraseña.\n \n ¿Deseas desactivarla?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.2),
                                  ),),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(3),
                                  width: responsive.wp(50),
                                  margin: EdgeInsets.only(top: responsive.hp(4), right: responsive.wp(2), left: responsive.wp(2)),
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
                                          fontSize: responsive.ip(1.4)),
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
                                      Navigator.pop(context,true);
                                      customAlertTablet(AlertDialogTypeTablet.EnOtroMomento_reconocimiento_facial, context,
                                          "", "", responsive);
                                    },
                                    child: Text(
                                      "NO",
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
                                    Navigator.pop(context,true);
                                    customAlertTablet(
                                        AlertDialogTypeTablet.DatosMoviles_Activados_comprueba,
                                        context,
                                        "",
                                        "",
                                        responsive);
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

    case AlertDialogTypeTablet.DatosMoviles_Activados_comprueba:
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
            "Comprueba que tienes acceso a una red Wi-Fi o que cuentes con el uso de datos móviles activado, se pueden aplicar cargos adicionales por el uso de datos móviles.",
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
                                    customAlertTablet(
                                        AlertDialogTypeTablet.CerrarSesion,
                                        context,
                                        "",
                                        "",
                                        responsive);
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

    case AlertDialogTypeTablet.CerrarSesion:
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
                              margin: EdgeInsets.only(top: responsive.hp(3.5), left: responsive.width * 0.03),
                              child: Text("¿Estás seguro de que deseas salir de tu App Intermediario\n GNP?",
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
                                    customAlertTablet(
                                        AlertDialogTypeTablet.En_mantenimiento_cel,
                                        context,
                                        "",
                                        "",
                                        responsive);
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
                                  Icons.app_settings_alt,
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
                                    customAlertTablet(
                                        AlertDialogTypeTablet.En_mantenimiento_llave,
                                        context,
                                        "",
                                        "",
                                        responsive);
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
                                  Icons.settings_outlined,
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
  }
}
