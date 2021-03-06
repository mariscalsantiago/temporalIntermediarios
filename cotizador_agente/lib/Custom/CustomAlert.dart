import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cotizador_agente/Cotizar/CotizarController.dart';
import 'package:cotizador_agente/Custom/Constantes.dart';
import 'package:cotizador_agente/Custom/Crypto.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/home/HomePage.dart';
import 'package:cotizador_agente/UserInterface/home/autos.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarNumero.dart';
import 'package:cotizador_agente/UserInterface/login/loginPreguntasSecretas.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/UserInterface/login/subsecuente_biometricos.dart';
import 'package:cotizador_agente/UserInterface/perfil/Terminos_y_condiciones.dart';
import 'package:cotizador_agente/UserInterface/perfil/condiciones_uso.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/Security/EncryptData.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:device_info/device_info.dart';
import 'package:system_settings/system_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:intl/intl.dart';

FocusNode focusContrasenaInactividad = new FocusNode();
bool contrasenaInactividad = true;
bool _didAuthenticate = true;
var isShowAlert = false;
bool _firstSession = true;
bool _showFinOtro = false;
EncryptData _encryptData = EncryptData();

enum AlertDialogType {
  errorPermisosGeneric,
  errorConexion,
  timeOut,
  inactividad,
  testUno,
  archivoInvalido,
  acesso_camara_galeria,
  ajustes_sin_guardar,
  opciones_de_inicio_de_sesion,
  huella,
  //terminosYcondiciones_Huella,
  activacionExitosa_Huella_Face,
  activacionExitosa_Huella,
  activacionExitosa_Face,
  EnOtroMomento_Huella,
  EnOtroMomento_Huella_face,
  verificaTuNumeroCelular,
  Reconocimiento_facial,
  activacionExitosa_Reconocimiento_facial,
  //terminosYcondiciones_reconocimiento_facial,
  EnOtroMomento_reconocimiento_facial,
  finalizar_seccion_en_otro_dispositivo,
  Sesionfinalizada_por_dispositivo,
  Sesionfinalizada_por_inactividad,
  Sesionfinalizada_por_inactividad_contrasenia,
  Sesionfinalizada_por_intentos_huella,
  Sesionafinalizada_por_contrasena_debeserdiferente,
  Correo_electronico_o_contrasena_no_coinciden,
  Correo_no_registrado,
  Cuenta_inactiva,
  Cuenta_bloqueada,
  Cuenta_temporalmente_bloqueada,
  Cuenta_temporalmente_bloqueada_temporizador,
  Contrasena_invalida_debeserdiferente_a_la_actual,
  Rostro_no_reconocido,
  Rostro_huella_no_reconocido,
  Rostro_no_reconocido_2,
  Huella_no_reconocida,
  Numero_de_celular_verificado,
  Numero_de_celular_actualizado_correctamente,
  AjustesSinGuardar_camara,
  ArchivoInvalido_imagen,
  Tienes_una_sesion_activa,
  Desactivar_huella_digital,
  Desactivar_huella_digital_face,
  FACE_PERMISS_DECLINADO,
  HUELLA_PERMISS_DECLINADO,
  FACE_HUELLA_PERMISS_DECLINADO,
  Desactivar_recoFacial,
  DatosMoviles_Activados,
  Sin_acceso_wifi,
  Sin_acceso_wifi_cerrar,
  CerrarSesion,
  En_mantenimiento_cel,
  En_mantenimiento_llave,
  Sin_acceso_herramientas_cotizacion,
  menu_home,
  errorServicio,
  error_codigo_verificacion,
  contrasena_actualiza_correctamente,
  preguntasSecretasActualizadas,
  inicio_de_sesion_inactivo_contador,
  versionTag,
  inicio_de_sesion_con_huella_bloqueado,
  inicio_de_sesion_con_facial_bloqueado,
  inicio_de_sesion_con_huella_facial_bloqueado,
  inicio_de_sesion_active_faceID,
  Contrasena_diferente_a_las_3_anteriores,
  Contrasena_diferente_a_las_3_anteriores_nueva
}

Future<void> customAlert(AlertDialogType type, BuildContext context, String title,
    String message, Responsive responsive, Function callback) async {
  switch (type) {
    case AlertDialogType.errorPermisosGeneric:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                            //Nuevo icono
                            Center(
                                child: Container(
                                    margin: EdgeInsets.only(top: responsive.hp(3)),
                                    child: Image.asset('assets/icon/phonelink.png'))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text("Configuraci??n de permisos.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: responsive.width * 0.04,
                                right: responsive.width * 0.04,
                                  ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  left: responsive.wp(2),
                                  right: responsive.wp(2),
                                  bottom: responsive.height * 0.02,
                                ),
                                child: Center(
                                  child: Text("No se logr?? realizar la configuraci??n de los permisos que requiere tu App Intermediario GNP.",
                                    style: TextStyle(
                                        height:responsive.ip(0.2),
                                        color:Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.5)),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                          margin: EdgeInsets.only(
                          left: responsive.width * 0.04,
                              right: responsive.width * 0.04,
                          bottom: responsive.height * 0.04),
                          child: Container(
                              margin: EdgeInsets.only(
                                left: responsive.wp(2),
                                right: responsive.wp(2),
                              ),
                              child: Center(
                                child: Text("Ve a Ajustes y v??lida que los permisos est??n habilitados para tu App Intermediario GNP.",
                                  style: TextStyle(
                                      height:responsive.ip(0.2),
                                      color:Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.5)),
                                ),
                              ),
                            )),
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
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    SystemSettings.app();
                                  },
                                  child: Text("CONFIGURAR PERMISOS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                  onPressed: () async {
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
                  ],
                ),
              ],
            );
          });

      break;

      case AlertDialogType.errorConexion:
      if (!isShowAlert) {
        isShowAlert = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error de conexi??n.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Se produjo un error en la red, verifica tu conexi??n e intenta nuevamente.",
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
              title: new Text("Error de conexi??n.",
                  style: TextStyle(
                      color: Theme.Colors.appBarTextBlueDark,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Se produjo un error en la red por el tiempo de espera, verifica tu conexi??n e intenta nuevamente.",
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
    case AlertDialogType.inicio_de_sesion_active_faceID:
      showDialog(
          useSafeArea: false,
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
                                  "Inicio de sesi??n con reconocimiento facial fue declinado",
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
                                    "Para continuar con inicio de sesi??n de biom??tricos, debe ir a configuraciones de tu dispositivo y activar.",
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
    case AlertDialogType.inactividad:
      showDialog(
          useSafeArea: false,
          context: context,
          builder: (context) => AlertDialog(
                title: new Text("Cierre de sesi??n.",
                    style: TextStyle(
                        color: Theme.Colors.appBarTextBlueDark,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                content: new Text(
                    "Su sesi??n ha expirado por "
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
          useSafeArea: false,
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
    case AlertDialogType.archivoInvalido:
      showDialog(
          useSafeArea: false,
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

    case AlertDialogType.acesso_camara_galeria:
      showDialog(
          useSafeArea: false,
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
                              "Acesso a c??mara y galer??a",
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(2)),
                            ),
                            Text(
                                "Es necesario otorgar los permisos correspondientes para cargar tus im??genes o archivos."),
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
    case AlertDialogType.ajustes_sin_guardar:
      showDialog(
          useSafeArea: false,
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
                            Text("??Quieres descartarlos?"),
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

    case AlertDialogType.opciones_de_inicio_de_sesion:
      showDialog(
          useSafeArea: false,
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
                                "Opciones de inicio de sesi??n",
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
                                "Al activar la funcionalidad permites iniciar sesi??n en tu App Intermediario GNP usando los datos biom??tricos que tienes activados en este dispositivo.",
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
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(2.3)),
                                      )),
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
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Theme
                                                  .Colors.Funcional_Textos_Body,
                                              fontSize: responsive.ip(2.3)),
                                        )),
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
                                  "CONTINUAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.White,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
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
                                  side: BorderSide(
                                      color: Theme.Colors.GNP, width: 2),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Theme.Colors.White,
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  customAlert(
                                      AlertDialogType.EnOtroMomento_Huella_face,
                                      context,
                                      "",
                                      "",
                                      responsive,
                                      callback);
                                },
                                child: Text(
                                  "EN OTRO MOMENTO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.GNP,
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
          useSafeArea: false,
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
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "??Activa tu ingreso con huella digital!",
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
                                "Al activar esta funcionalidad podr??s iniciar sesi??n en tu App Intermediario GNP m??s r??pido con cualquier huella registrada en este dispositivo.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
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
                                    Navigator.pop(context, true);
                                    customAlert(
                                        AlertDialogType.EnOtroMomento_Huella,
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

    /*case AlertDialogType.terminosYcondiciones_Huella:
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
      break;*/
    case AlertDialogType.activacionExitosa_Huella_Face:
      showDialog(
          useSafeArea: false,
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
                                  "Activaci??n exitosa de huella digital o reconocimiento facial",
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
                                "Ya puedes iniciar sesi??n solo con tu huella digital o reconocimiento facial.",
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
                                  onTap: () async {
                                    print(
                                        "-----------Exito----------------------");
                                    primerAccesoUsuario();
                                    if (prefs.getBool("primeraVez") ||
                                        prefs.getBool("flujoCompletoLogin") ==
                                            null ||
                                        !prefs.getBool("flujoCompletoLogin")) {
                                      if (prefs.getBool(
                                                  'primeraVezIntermediario') !=
                                              null &&
                                          prefs.getBool(
                                              'primeraVezIntermediario')) {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                        print(
                                            "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                        if (prefs.getBool(
                                                "aceptoCondicionesDeUso") ==
                                            null) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            !prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            // validamos si el usuario ya inicio sesi??n por primera vez
                                            if (_firstSession) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginActualizarContrasena(
                                                            responsive:
                                                                responsive,
                                                          )));
                                            }
                                          }
                                        } else {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        }
                                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                      } else {
                                        if (prefs.getString(
                                                "medioContactoTelefono") !=
                                            "") {
                                          if (deviceType == ScreenType.phone) {
                                            print("Verifica codigo celular");
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          } else {
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                            //TODO tablet
                                            //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive, callback);
                                          }
                                        } else {
                                          print(
                                              "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                          Navigator.pop(context, true);
                                          Navigator.pop(context, true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginActualizarNumero(
                                                            responsive:
                                                                responsive,
                                                          )));
                                        }
                                      }
                                    } else {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        callback();
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      } else {
                                        print("Exito----------------------");
                                        await consultaBitacora();
                                        Navigator.pop(context, true);
                                        if(_showFinOtro){
                                          customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                        }else{
                                          sendTag("appinter_login_ok");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    responsive: responsive,
                                                  ),settings: RouteSettings(name: "Home")));
                                        }

                                      }
                                    }
                                    prefs.setBool(
                                        "aceptoTerminos", checkedValue);
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
    case AlertDialogType.activacionExitosa_Huella:
      showDialog(
          useSafeArea: false,
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
                                  "Activaci??n exitosa de huella digital",
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
                                "Ya puedes iniciar sesi??n solo con tu huella digital.",
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
                                  onTap: () async {
                                    print(
                                        "-----------Exito----------------------");
                                    if (prefs.getBool("primeraVez") ||
                                        prefs.getBool("flujoCompletoLogin") ==
                                            null ||
                                        !prefs.getBool("flujoCompletoLogin")) {
                                      if (prefs.getBool(
                                                  'primeraVezIntermediario') !=
                                              null &&
                                          prefs.getBool(
                                              'primeraVezIntermediario')) {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                        print(
                                            "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                        if (prefs.getBool(
                                                "aceptoCondicionesDeUso") ==
                                            null) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            !prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        }
                                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                      } else {
                                        if (prefs.getString(
                                                "medioContactoTelefono") !=
                                            "") {
                                          if (deviceType == ScreenType.phone) {
                                            print("Verifica codigo celular");
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          } else {
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                            //TODO tablet
                                            //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive, callback);
                                          }
                                        } else {
                                          Navigator.pop(context, true);
                                          Navigator.pop(context, true);
                                          print(
                                              "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginActualizarNumero(
                                                            responsive:
                                                                responsive,
                                                          )));
                                        }
                                      }
                                    } else {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        callback();
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      } else {
                                        print("Exito----------------------");
                                        await consultaBitacora();
                                        Navigator.pop(context, true);
                                        if(_showFinOtro){
                                          customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                        }else{
                                          sendTag("appinter_login_ok");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    responsive: responsive,
                                                  ),settings: RouteSettings(name: "Home")));
                                        }
                                      }
                                    }
                                    prefs.setBool(
                                        "aceptoTerminos", checkedValue);
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
    case AlertDialogType.activacionExitosa_Face:
      showDialog(
          useSafeArea: false,
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
                                top: responsive.height * 0.05,
                                left: responsive.width * 0.06,
                                right: responsive.width * 0.06,
                              ),
                              child: Center(
                                child: Text(
                                  "Activaci??n exitosa de reconocimiento facial",
                                  textAlign: TextAlign.center,
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
                                "Ya puedes iniciar sesi??n mostrando solo tu rostro.",
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
                                  onTap: () async {
                                    print(
                                        "-----------Exito----------------------");
                                    if (prefs.getBool("primeraVez") ||
                                        prefs.getBool("flujoCompletoLogin") ==
                                            null ||
                                        !prefs.getBool("flujoCompletoLogin")) {
                                      if (prefs.getBool(
                                                  'primeraVezIntermediario') !=
                                              null &&
                                          prefs.getBool(
                                              'primeraVezIntermediario')) {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                        print(
                                            "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                        if (prefs.getBool(
                                                "aceptoCondicionesDeUso") ==
                                            null) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            !prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          // validamos si el usuario ya inicio sesi??n por primera vez
                                          if (_firstSession) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginActualizarContrasena(
                                                          responsive:
                                                              responsive,
                                                        )));
                                          }
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else {
                                        if (prefs.getString(
                                                "medioContactoTelefono") !=
                                            "") {
                                          if (deviceType == ScreenType.phone) {
                                            print("Verifica codigo celular");
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          } else {
                                            Navigator.pop(context, true);
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                            //TODO tablet
                                            //customAlertTablet(AlertDialogTypeTablet.verificaTuNumeroCelular, context, "",  "", responsive, callback);
                                          }
                                        } else {
                                          print(
                                              "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                          Navigator.pop(context, true);
                                          Navigator.pop(context, true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginActualizarNumero(
                                                            responsive:
                                                                responsive,
                                                          )));
                                        }
                                      }
                                    } else {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        callback();
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      } else {
                                        await consultaBitacora();
                                        print("Exito----------------------");
                                        Navigator.pop(context, true);
                                        if(_showFinOtro){
                                          customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                        }else{
                                          sendTag("appinter_login_ok");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    responsive: responsive,
                                                  ),settings: RouteSettings(name: "Home")));
                                        }
                                      }
                                    }
                                    prefs.setBool(
                                        "aceptoTerminos", checkedValue);
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
          useSafeArea: false,
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
                                  "El inicio de sesi??n con tu huella digital es m??s r??pido",
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
                                "??Deseas cancelar la configuraci??n?",
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
                                  onPressed: () async {
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
                                       await consultaBitacora();
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else if (prefs.getBool(
                                                'primeraVezIntermediario') !=
                                            null &&
                                        prefs.getBool(
                                            'primeraVezIntermediario')) {
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      print(
                                          "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                      if (prefs.getBool(
                                              "aceptoCondicionesDeUso") ==
                                          null) {
                                        // validamos si el usuario ya inicio sesi??n por primera vez
                                        if (_firstSession) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          !prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        // validamos si el usuario ya inicio sesi??n por primera vez
                                        if (_firstSession) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      }
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                    } else {
                                      Navigator.pop(context, true);
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      if (prefs.getString(
                                              "medioContactoTelefono") !=
                                          "") {
                                        customAlert(
                                            AlertDialogType
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      } else {
                                        print(
                                            "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoginActualizarNumero(
                                                          responsive:
                                                              responsive,
                                                        )));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "S??",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                    customAlert(AlertDialogType.huella, context,
                                        "", "", responsive, callback);
                                  },
                                  child: Text(
                                    "NO",
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
    case AlertDialogType.EnOtroMomento_Huella_face:
      showDialog(
          useSafeArea: false,
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
                                  "El inicio de sesi??n con tu huella digital o tu reconocimiento facial es m??s r??pido",
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
                                "??Deseas cancelar la configuraci??n?",
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
                                  onPressed: () async {
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
                                      await consultaBitacora();
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else if (prefs.getBool(
                                                'primeraVezIntermediario') !=
                                            null &&
                                        prefs.getBool(
                                            'primeraVezIntermediario')) {
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      print(
                                          "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                      if (prefs.getBool(
                                              "aceptoCondicionesDeUso") ==
                                          null) {
                                        // validamos si el usuario ya inicio sesi??n por primera vez
                                        if (_firstSession) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          !prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        // validamos si el usuario ya inicio sesi??n por primera vez
                                        if (_firstSession) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      }
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                    } else {
                                      Navigator.pop(context, true);
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      if (prefs.getString(
                                              "medioContactoTelefono") !=
                                          "") {
                                        customAlert(
                                            AlertDialogType
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      } else {
                                        print(
                                            "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoginActualizarNumero(
                                                          responsive:
                                                              responsive,
                                                        )));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "S??",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                    customAlert(
                                        AlertDialogType
                                            .opciones_de_inicio_de_sesion,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        callback);
                                  },
                                  child: Text(
                                    "NO",
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
    case AlertDialogType.verificaTuNumeroCelular:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          context: context,
          builder: (context) {
            Responsive responsive = Responsive.of(context);
            return Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: GestureDetector(
                    onTap: () {
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
                                  "Verifica tu n??mero celular",
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
                                  //bottom: responsive.height * 0.03,
                                  right: responsive.width * 0.04),
                              child: Text(
                                "Te enviamos un c??digo de verificaci??n por SMS al n??mero " +
                                    numero(),
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontWeight: FontWeight.normal,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Image.asset(
                              "assets/login/verificaNumero.png",
                              height: responsive.hp(28.0),
                              width: responsive.wp(28),
                            ),
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Theme.Colors.GNP,
                                    ),
                                    width: responsive.width,
                                    margin: EdgeInsets.only(
                                        // top: responsive.height * 0.04,

                                        left: responsive.width * 0.04,
                                        bottom: responsive.height * 0.03,
                                        right: responsive.width * 0.04),
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
                                              fontSize: responsive.ip(2.1)),
                                          textAlign: TextAlign.center,
                                        ))),
                                onPressed: () async {
                                  prefs.setBool("seActualizarNumero", false);
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
                                        bottom: responsive.hp(2)),
                                    child: Text("NO ES MI N??MERO ACTUAL",
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(2.1)),
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Reconocimiento_facial:
      showDialog(
          useSafeArea: false,
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
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "??Activa tu ingreso con reconocimiento facial!",
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
                                "Al activar esta funcionalidad podr??s iniciar sesi??n en tu App Intermediario GNP m??s r??pido con cualquier rostro registrado en este dispositivo.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2.0)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
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
                                    Navigator.pop(context, true);
                                    customAlert(
                                        AlertDialogType
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
          useSafeArea: false,
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
                                    "El inicio de sesi??n con reconocimiento facial es m??s r??pido",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.Encabezados,
                                        fontSize: responsive.ip(2.0)),
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
                                  "??Deseas cancelar la configuraci??n?",
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
                                      "S??",
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
                                    top: responsive.height * 0.02,
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
              ),
            );
          });
      break;

    case AlertDialogType.activacionExitosa_Reconocimiento_facial:
      showDialog(
          useSafeArea: false,
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
                                  "Activaci??n exitosa de reconocimiento facial",
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
                                "Ya puedes iniciar sesi??n mostrando solo tu rostro.",
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
                                  onTap: () async {
                                    print(
                                        "-----------Exito----------------------");
                                    if (prefs.getBool("primeraVez") ||
                                        prefs.getBool("flujoCompletoLogin") ==
                                            null ||
                                        !prefs.getBool("flujoCompletoLogin")) {
                                      print("primeraVez");

                                      if (prefs.getBool(
                                                  'primeraVezIntermediario') !=
                                              null &&
                                          prefs.getBool(
                                              'primeraVezIntermediario')) {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                        print(
                                            "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                        if (prefs.getBool(
                                                "aceptoCondicionesDeUso") ==
                                            null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        } else if (prefs.getBool(
                                                    "aceptoCondicionesDeUso") !=
                                                null &&
                                            !prefs.getBool(
                                                "aceptoCondicionesDeUso")) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CondicionesPage(
                                                            responsive: responsive,
                                                            callback:
                                                                FuncionAlerta,
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      LoginActualizarContrasena(
                                                        responsive: responsive,
                                                      )));
                                        }
                                      } else {
                                        if (prefs.getString(
                                                "medioContactoTelefono") !=
                                            "") {
                                          if (deviceType == ScreenType.phone) {
                                            print("Verifica codigo celular--");
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          } else {
                                            Navigator.pop(context, true);
                                            customAlert(
                                                AlertDialogType
                                                    .verificaTuNumeroCelular,
                                                context,
                                                "",
                                                "",
                                                responsive,
                                                callback);
                                          }
                                        } else {
                                          Navigator.pop(context, true);
                                          print(
                                              "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginActualizarNumero(
                                                            responsive:
                                                                responsive,
                                                          )));
                                        }
                                      }
                                    } else {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        Navigator.pop(context, true);
                                      } else {
                                        print("Exito----------------------");
                                        await consultaBitacora();
                                        Navigator.pop(context, true);
                                        if(_showFinOtro){
                                          customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                        }else{
                                          sendTag("appinter_login_ok");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    responsive: responsive,
                                                  ),settings: RouteSettings(name: "Home")));
                                        }
                                      }
                                    }
                                    prefs.setBool(
                                        "aceptoTerminos", checkedValue);
                                    //callback();
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

    /*case AlertDialogType.terminosYcondiciones_reconocimiento_facial:
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
                                        text: 'Consentimiento para el tratamiento de uso de datos biom??tricos \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),

                                        children: <InlineSpan>[

                                          TextSpan(
                                            text: 'Grupo Nacional Provincial, S.A.B., ',
                                            style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'con domicilio en Avenida Cerro de las Torres No. 395, Colonia Campestre Churubusco,'
                                                ' C??digo Postal 04200, Alcald??a Coyoac??n, Ciudad de M??xico, tratar?? sus datos personales'
                                                ' para que a trav??s de su huella digital que previamente tenga configurada o disponible en el '
                                                'dispositivo electr??nico que utilice, facilitar el acceso a determinadas aplicaciones o '
                                                'plataformas de GNP relacionadas con el desarrollo de sus actividades propias como agente,'
                                                ' sin que esto implique el resguardo o almacenamiento de este dato por parte de GNP. '
                                                'Puede consultar la versi??n integral del Aviso de Privacidad en ',
                                            style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'www.gnp.com.mx ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),
                                          TextSpan(
                                            text: 'o en el tel??fono ',
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
                                            text: 'Al activar el uso de datos biom??tricos, reconozco que se ha puesto a mi disposici??n el ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),

                                          TextSpan(
                                            text: 'Aviso de Privacidad Integral de Grupo Nacional Provincial S. A. B. ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),
                                          TextSpan(
                                            text: '(en adelante GNP), mismo que contiene y detalla las finalidades del tratamiento de los datos personales y'
                                                ' acept?? su tratamiento por parte de GNP. Asimismo se me inform?? que puedo consultar dicho aviso y sus actualizaciones'
                                                ' en cualquier momento en la p??gina ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: 'www.gnp.com.mx ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),

                                          TextSpan(
                                            text: 'o en el tel??fono ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                          TextSpan(
                                            text: '(55) 5227 9000 ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                          ),

                                          TextSpan(
                                            text: 'a nivel nacional. En caso de haber proporcionado datos personales de otros titulares, reconozco haber cumplido con mi'
                                                ' obligaci??n de informarles sobre su entrega, haber obtenido de forma previa el consentimiento de ??stos para su tratamiento, '
                                                'as?? como haberles informado los lugares en los que se encuentra disponible el Aviso de Privacidad para su consulta. ',
                                            style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              CheckboxListTile(
                                title: Text("Acepto los t??rminos y condiciones de uso"),
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
      break;*/

    case AlertDialogType.EnOtroMomento_reconocimiento_facial:
      showDialog(
          useSafeArea: false,
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
                                  "El inicio de sesi??n con reconocimiento\nfacial es m??s r??pido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.0)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: responsive.wp(4),
                                  right: responsive.wp(4),
                                  bottom: responsive.hp(2)),
                              child: Text(
                                "??Deseas cancelar la configuraci??n?",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.9)),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () async {
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

                                      await consultaBitacora();
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else if (prefs.getBool(
                                                'primeraVezIntermediario') !=
                                            null &&
                                        prefs.getBool(
                                            'primeraVezIntermediario')) {
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      print(
                                          "-----IntermediarioPrimeraVez TerminosYCondiciones------");

                                      if (prefs.getBool(
                                              "aceptoCondicionesDeUso") ==
                                          null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      } else if (prefs.getBool(
                                                  "aceptoCondicionesDeUso") !=
                                              null &&
                                          !prefs.getBool(
                                              "aceptoCondicionesDeUso")) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CondicionesPage(
                                                          responsive: responsive,
                                                          callback:
                                                              FuncionAlerta,
                                                        )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginActualizarContrasena(
                                                      responsive: responsive,
                                                    )));
                                      }
                                      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,)));
                                    } else {
                                      Navigator.pop(context, true);
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      if (prefs.getString(
                                              "medioContactoTelefono") !=
                                          "") {
                                        customAlert(
                                            AlertDialogType
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      } else {
                                        print(
                                            "No tiene medios de contacto login sin biometricos usuario ya registrado");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoginActualizarNumero(
                                                          responsive:
                                                              responsive,
                                                        )));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "S??",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    Navigator.pop(context, true);
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

    case AlertDialogType.finalizar_seccion_en_otro_dispositivo:

      bool showCiudad = false;
      String hora ="";
      String ciudad ="";
      String dispositivo ="";
      DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
      await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
        var jsoonn = json.encode(_snapshot.value);
        Map response = json.decode(jsoonn);
        if(response!= null && response.isNotEmpty){
          print("id ${response["deviceID"]}");
          hora = response["hora"];
          ciudad = response["ciudad"];
          dispositivo = response["dispositivo"];
        }
      });
      if(ciudad!= null && ciudad.isNotEmpty && ciudad!="" && ciudad!=" "){
        showCiudad = true;
      }else{
        showCiudad = false;
      }

      showDialog(
          useSafeArea: false,
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
                                  "Tienes una sesi??n activa",
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
                                showCiudad==true ?"Iniciada a las ${hora} en ${ciudad} desde ${dispositivo}. ??Deseas cerrar esa sesi??n e iniciar en este dispositivo?":"Iniciada a las ${hora} desde ${dispositivo}. ??Deseas cerrar esa sesi??n e iniciar en este dispositivo?",
                                //"??Deseas cerrar esa sesi??n e iniciar en este dispositivo?",
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
                                 // bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                    Navigator.push(context, new MaterialPageRoute(builder: (_) => new HomePage(responsive: responsive,),settings: RouteSettings(name: "Home")));
                                  },
                                  child: Text(
                                    "S??",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                 // bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme.Colors.White,
                                  onPressed: () {
                                    callback();
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    "NO",
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

    case AlertDialogType.Sesionfinalizada_por_dispositivo:
      Inactivity(context: context).cancelInactivity();
      showDialog(
          useSafeArea: false,
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
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(3)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: responsive.ip(5),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(5)),
                                child: Center(
                                  child: Text(
                                    "Sesi??n finalizada",
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
                                      "Has iniciado sesi??n en otro dispositivo",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.8)),
                                    ),
                                  )),
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
                                      //TODO subsecuentes
                                      Navigator.pop(context, true);
                                      if (prefs.getBool("activarBiometricos")) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    BiometricosPage(
                                                        responsive: responsive),settings: RouteSettings(name: "Biometricos")));
                                      } else {

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    PrincipalFormLogin(
                                                        responsive: responsive),settings: RouteSettings(name: "Login")));
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
              ),
            );
          });
      break;

    case AlertDialogType.Sesionfinalizada_por_inactividad:
      inactiveFirebaseDivice(false);
      showDialog(
          useSafeArea: false,
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
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(2.5)),
                                      child: Icon(
                                        Icons.warning_amber_outlined,
                                        color: Theme.Colors.Error_Dark,
                                        size: responsive.ip(6),
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: responsive.hp(4)),
                                child: Center(
                                  child: Text(
                                    "Sesi??n finalizada por inactividad",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(2.3)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                ),
                                child: Center(
                                  child: Text(
                                    "Vuelve a iniciar sesi??n para ingresar a tu cuenta.",
                                    style: TextStyle(
                                        color:
                                            Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: responsive.wp(4),
                                      right: responsive.wp(4),
                                      top: responsive.hp(2),
                                      bottom: responsive.hp(2)),
                                  child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.Colors.GNP,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: responsive.hp(2),
                                            bottom: responsive.hp(2)),
                                        width: responsive.width,
                                        child: Text("INICIAR SESI??N",
                                            style: TextStyle(
                                              color: Theme.Colors.backgroud,
                                            ),
                                            textAlign: TextAlign.center),
                                      ),
                                      onPressed: () async {
                                        customAlert(
                                            AlertDialogType
                                                .Sesionfinalizada_por_inactividad_contrasenia,
                                            context,
                                            title,
                                            message,
                                            responsive,
                                            callback);
                                      }),
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
    case AlertDialogType.Sesionfinalizada_por_inactividad_contrasenia:
      initializeTimerOtroUsuario(context,callback);
      if (prefs.getBool("activarBiometricos")) {
        doLoginBiometrics(context, callback);
      } else {
        Navigator.pop(context, true);
        showDialog(
            context: context,
            builder: (context) {
              return MyDialogContrasenaInactividad(callback: callback);
            });
      }
      break;

    case AlertDialogType.Sesionfinalizada_por_intentos_huella:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Sesi??n finalizada",
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
                                    "Has superado los intentos permitidos de huella digital, por su seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con huella digital, deber??s bloquear y desbloquear tu dispositivo.",
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Sesionafinalizada_por_contrasena_debeserdiferente:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Contrase??a inv??lida",
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
                                  left: responsive.width * 0.06,
                                  right: responsive.width * 0.06,
                                  bottom: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "Tu nueva contrase??a debe ser diferente a la actual.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.contrasena_actualiza_correctamente:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  child: Image.asset(
                                    'assets/images/verifica.png',
                                    fit: BoxFit.contain,
                                    height: responsive.hp(7),
                                    width: responsive.hp(6),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(4)),
                              child: Center(
                                child: Text(
                                  "Tu contrase??a se actualiz?? \ncorrectamente",
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
                                  left: responsive.width * 0.04,
                                  right: responsive.width * 0.04,
                                  bottom: responsive.height * 0.01,
                                ),
                                child: Center(
                                  child: Text(
                                    "Esta contrase??a es la misma para ingresar a todas nuestras plataformas digitales disponibles para ti.",
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
                                        prefs
                                            .getBool("flujoOlvideContrasena")) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PrincipalFormLogin(
                                                      responsive: responsive)));*/
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PreguntasSecretas(
                                                      responsive: responsive)));
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Contrase??a inv??lida",
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
                                  "Tu nueva contrase??a debe ser diferente a la actual.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Correo_electronico_o_contrasena_no_coinciden:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Correo electr??nico o contrase??a no coinciden",
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
                                    "Por seguridad, tu cuenta se bloquear?? despu??s de 3 intentos.",
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Correo_no_registrado:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    "El correo que ingresaste a??n no ha sido registrado.",
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Cuenta_inactiva:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  right: responsive.width * 0.04,
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
                                            'Para mayor informaci??n o reactivar tu cuenta comunicate a Soporte GNP al ',
                                        style: TextStyle(
                                            color: Theme
                                                .Colors.Funcional_Textos_Body,
                                            fontSize: responsive.ip(1.8)),
                                        children: <InlineSpan>[
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            print("numero");
                                            launch('tel:5552273966');
                                          },
                                        text: '55 5227 3966 ',
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.8)),
                                      ),
                                      TextSpan(
                                        text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y s??bados de 8:00 a 14:00 hrs.',
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Cuenta_bloqueada:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  right: responsive.width * 0.04,
                                  bottom: responsive.height * 0.03),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
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
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            print("numero");
                                            launch('tel:5552273966');
                                          },
                                        text: '55 5227 3966 ',
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.8)),
                                      ),
                                      TextSpan(
                                        text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y s??bados de 8:00 a 14:00 hrs.',
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Cuenta_temporalmente_bloqueada:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                              margin: EdgeInsets.only(
                                top: responsive.hp(5),
                                left: responsive.wp(8),
                                right: responsive.wp(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Tu cuenta est?? temporalmente bloqueada",
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
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            print("numero");
                                            launch('tel:5552273966');
                                          },
                                        text: '55 5227 3966 ',
                                        style: TextStyle(
                                            color: Theme.Colors.GNP,
                                            fontSize: responsive.ip(1.8)),
                                      ),
                                      TextSpan(
                                        text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y s??bados de 8:00 a 14:00 hrs.',
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
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.Cuenta_temporalmente_bloqueada_temporizador:
     // initializeTimerBloqueo(context, callback);
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                            margin: EdgeInsets.only(
                              top: responsive.hp(5),
                              left: responsive.wp(8),
                              right: responsive.wp(8),
                            ),
                            child: Center(
                              child: Text(
                                "Inicio de sesi??n inactivo",
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
                                      'Has superado el n??mero permitido de intentos para iniciar sesi??n, en un momento podr??s intentarlo de nuevo',
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.8)),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Theme.Colors.GNP,
                                              fontSize: responsive.ip(1.8)),
                                        ),
                                      ]))),
                            ),
                          ),
                          Center(child:Container(margin: EdgeInsets.only(bottom:40),child:CountdownFormatted(
                            duration: Duration(seconds: 15),
                            onFinish: () {
                              Navigator.pop(context);
                            },
                            builder: (BuildContext ctx, String remaining) {
                              return Text("${remaining}",
                                style: TextStyle(
                                    color: int.parse(remaining)<=5?Colors.green:Colors.red,
                                    fontWeight: FontWeight.normal,
                                    fontSize: prefs.getBool("useMobileLayout")
                                        ? responsive.ip(3.8)
                                        : responsive.ip(2.5)),
                              ); // 01:00:00
                            },
                          ))),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
     /* showDialog(
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
                              margin: EdgeInsets.only(
                                top: responsive.hp(5),
                                left: responsive.wp(8),
                                right: responsive.wp(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Tu cuenta est?? temporalmente bloqueada",
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
                                            recognizer: new TapGestureRecognizer()
                                              ..onTap = () {
                                                print("numero");
                                                launch('tel:5552273966');
                                              },
                                            text: '55 5227 3966 ',
                                            style: TextStyle(
                                                color: Theme.Colors.GNP,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                          TextSpan(
                                            text:
                                            'en un horario de lunes a viernes de 8:00 a 20:00 hrs y s??bados de 8:00 a 14:00 hrs.',
                                            style: TextStyle(
                                                color: Theme
                                                    .Colors.Funcional_Textos_Body,
                                                fontSize: responsive.ip(1.8)),
                                          ),
                                        ]))),
                              ),
                            ),
                            Center(child:Container(child: Text(""))),
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
                  ],
                ),
              ],
            );
          });*/
      break;
    case AlertDialogType.FACE_PERMISS_DECLINADO:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  Constantes.FACE_TITLE_PERMISS_DECLINADO,
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
                                    Constantes
                                        .FACE_DECRIPTION_PERMISS_DECLINADO,
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
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    SystemSettings.defaultApps();
                                  },
                                  child: Text(
                                    Constantes.ACTIVAR_AHORA,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.Colors.GNP, width: 2),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      await consultaBitacora();
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
                                              .verificaTuNumeroCelular,
                                          context,
                                          "",
                                          "",
                                          responsive,
                                          callback);
                                    }
                                  },
                                  child: Text(
                                    Constantes.OTRO_MOMENTO,
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

    case AlertDialogType.HUELLA_PERMISS_DECLINADO:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  Constantes.HUELLA_TITLE_PERMISS_DECLINADO,
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
                                    Constantes
                                        .HUELLA_DECRIPTION_PERMISS_DECLINADO,
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
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    SystemSettings.defaultApps();
                                  },
                                  child: Text(
                                    Constantes.ACTIVAR_AHORA,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
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
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.Colors.GNP, width: 2),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      await consultaBitacora();
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
                                              .verificaTuNumeroCelular,
                                          context,
                                          "",
                                          "",
                                          responsive,
                                          callback);
                                    }
                                  },
                                  child: Text(
                                    Constantes.OTRO_MOMENTO,
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

    case AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  Constantes
                                      .FACE_HUELLA_TITLE_PERMISS_DECLINADO,
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
                                    "$message${Constantes.FACE_HUELLA_DECRIPTION_PERMISS_DECLINADO}",
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
                                    prefs.setInt("localAuthCountIOS", 0);
                                    if(Platform.isIOS)
                                      SystemSettings.defaultApps();
                                    else
                                      SystemSettings.security();
                                  },
                                  child: Text(
                                    Constantes.ACTIVAR_AHORA,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
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
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.Colors.GNP, width: 2),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      await consultaBitacora();
                                      callback(false, responsive);
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
                                              .verificaTuNumeroCelular,
                                          context,
                                          "",
                                          "",
                                          responsive,
                                          callback);
                                    }
                                  },
                                  child: Text(
                                    Constantes.OTRO_MOMENTO,
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    "Has superado los intentos permitidos de reconocimiento facial, por su seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con reconocimiento facial, deber??s bloquear y desbloquear tu dispositivo.",
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
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      callback(false, responsive);

                                      await consultaBitacora();
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
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
    case AlertDialogType.Rostro_huella_no_reconocido:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Rostro o huella no reconocido",
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
                                    "Has superado los intentos permitidos de reconocimiento facial o huella digital, por su seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con reconocimiento facial o huella digital, deber??s bloquear y desbloquear tu dispositivo.",
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
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      await consultaBitacora();
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{

                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    Navigator.pop(context, true);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                      margin: EdgeInsets.only(
                                          top: responsive.hp(3)),
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
                                      "Has superado los intentos permitidos para identificar tu huella digital, por su seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con huella digital, deber??s bloquear y desbloquear tu dispositivo.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
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
                                    onPressed: () async {
                                      if ((prefs.getBool("esPerfil") != null &&
                                              prefs.getBool("esPerfil")) ||
                                          (prefs.getBool(
                                                      "subSecuentaIngresoCorreo") !=
                                                  null &&
                                              prefs.getBool(
                                                  "subSecuentaIngresoCorreo"))) {
                                        print("1 subsecuentes------------");
                                        if (prefs.getBool("esPerfil")) {
                                          print("2 subsecuentes------------");
                                          prefs.setBool(
                                              "activarBiometricos", false);
                                        } else {
                                          print("3 subsecuentes------------");
                                          prefs.setBool(
                                              "activarBiometricos", true);
                                        }
                                        Navigator.pop(context, true);
                                        callback();
                                      } else if (prefs.getBool(
                                                  "flujoCompletoLogin") !=
                                              null &&
                                          prefs.getBool("flujoCompletoLogin")) {
                                        Navigator.pop(context, true);
                                        callback(false, responsive);
                                        await consultaBitacora();
                                        if(_showFinOtro){
                                          customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                        }else{
                                          sendTag("appinter_login_ok");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    responsive: responsive,
                                                  ),settings: RouteSettings(name: "Home")));
                                        }
                                      } else {
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                        callback(false, responsive);
                                        Navigator.pop(context, true);
                                        customAlert(
                                            AlertDialogType
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "N??mero de celular verificado",
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
                                    "Mantener tu n??mero de celular actualizado te permitir?? agilizar ciertos tr??mites, por ejemplo si olvidas la contrase??a de tu cuenta.",
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.Numero_de_celular_actualizado_correctamente:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "N??mero de celular actualizado exitosamente",
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
                                    "Ahora recibir??s notificaciones en este n??mero.",
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
                                  onPressed: () async {
                                    if (prefs.getBool("esPerfil") != null &&
                                        prefs.getBool("esPerfil") &&
                                        prefs.getBool("esActualizarNumero")) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else if (prefs.getBool("esPerfil") !=
                                            null &&
                                        prefs.getBool("esPerfil") &&
                                        prefs.getBool(
                                            "actualizarContrasenaPerfil")) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginActualizarContrasena(
                                                      responsive: responsive)));
                                    } else if (prefs.getBool(
                                                'flujoOlvideContrasena') !=
                                            null &&
                                        prefs
                                            .getBool('flujoOlvideContrasena')) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginRestablecerContrasena(
                                                      responsive: responsive)));
                                    } else {
                                      Navigator.pop(context);
                                      print("Flujoo completo");
                                      prefs.setBool("flujoCompletoLogin", true);
                                      await consultaBitacora();
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                      //callback(responsive);
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

    case AlertDialogType.AjustesSinGuardar_camara:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text(
                                  "Tienes ajustes sin guardar",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(3.5),
                                  left: responsive.width * 0.03),
                              child: Text(
                                "??Quieres descartarlos?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin:
                                    EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
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
                                    Navigator.pop(context, true);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    EdgeInsets.only(top: responsive.hp(3.6)),
                                child: Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.redAccent,
                                  size: responsive.ip(6.6),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: responsive.hp(3.6)),
                                child: Text(
                                  "Archivo inv??lido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.Colors.Azul_gnp,
                                    fontSize: responsive.ip(2.4),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(4.1),
                                  left: responsive.width * 0.05),
                              child: Text(
                                "Debe ser formato im??gen",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.07,
                                left: responsive.wp(20),
                                bottom: responsive.height * 0.04,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
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
                                              color: Theme.Colors.GNP,
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text(
                                  "Tienes una sesi??n activa",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(3.5),
                                  left: responsive.width * 0.03),
                              child: Text(
                                "Iniciada a las {hora} en {ciudad} desde\n {dispositivo}. ??Deseas cerrar esa sesi??n e iniciar\n en este dispositivo?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin:
                                    EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                    customAlert(
                                        AlertDialogType.DatosMoviles_Activados,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        FuncionAlerta);
                                  },
                                  child: Text(
                                    "S??",
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
                                    Navigator.pop(context, true);
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
    case AlertDialogType.Desactivar_huella_digital_face:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: Text(
                                    "Desactivar huella digital o reconocimiento facial",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.5),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(3.5),
                                    left: responsive.width * 0.03),
                                child: Text(
                                  "Al desactivar esta funcionalidad iniciar??s sesi??n solo con contrase??a.\n\n ??Deseas desactivarla?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
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
                                      "S??",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(2.0)),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      left: responsive.height * 0.02,
                                      right: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
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
              ),
            );
          });
      break;
    case AlertDialogType.Desactivar_huella_digital:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: Text(
                                    "Desactivar huella digital",
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.5),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(3.5),
                                    left: responsive.width * 0.03),
                                child: Text(
                                  "Al desactivar esta funcionalidad iniciar??s sesi??n solo con contrase??a.\n\n ??Deseas desactivarla?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
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
                                      "S??",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(2.0)),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  prefs.setBool("activarBiometricos", true);
                                  isSwitchedPerfill = true;
                                  callback();
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      left: responsive.height * 0.02,
                                      right: responsive.height * 0.02,
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.02),
                                  child: Center(
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
              ),
            );
          });
      break;

    case AlertDialogType.Desactivar_recoFacial:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: Text(
                                    "Desactivar reconocimiento facial",
                                    style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.5),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: responsive.hp(3.5),
                                    left: responsive.width * 0.03),
                                child: Text(
                                  "Al desactivar esta funcionalidad iniciar??s sesi??n solo con contrase??a.\n \n  ??Deseas desactivarla?",
                                  //child: Text("Al desactivar esta funcionalidad iniciar??s s??lo\n con contrase??a.\n\n ??Deseas desactivarla?",
                                  style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin:
                                      EdgeInsets.only(top: responsive.hp(3.5)),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
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
                                      "S??",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.White,
                                          fontSize: responsive.ip(2.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: responsive.hp(6.25),
                                  width: responsive.wp(90),
                                  margin: EdgeInsets.only(
                                      top: responsive.height * 0.02,
                                      bottom: responsive.height * 0.02),
                                  child: TextButton(
                                    onPressed: () {
                                      prefs.setBool("activarBiometricos", true);
                                      isSwitchedPerfill = true;
                                      callback();
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(
                                      "NO",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(2.0)),
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

    case AlertDialogType.DatosMoviles_Activados:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
          context: navigatorKey.currentState.overlay.context,
          builder: (context) {
              dialogMobileContext = context;
            Responsive responsive = Responsive.of(context);
            return WillPopScope(
              onWillPop: () async => false,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      callback();
                      Navigator.pop(context, true);
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
                                    "Datos m??viles activados",
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
                                  "Tu dispositivo no est?? conetado a una red wifi.",
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
                                      Navigator.pop(context, true);
                                      isMessageMobileClose = false;
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

    case AlertDialogType.Sin_acceso_wifi:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
          context: navigatorKey.currentState.overlay.context,
          builder: (context) {
            dialogConnectivityContext = context;
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
                                    "Sin conexi??n a internet",
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
                                ),
                                child: Text(
                                  "Comprueba que tienes acceso a una red Wi-Fi o que cuentas con datos m??viles activados.",
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
                                      Navigator.pop(context, true);
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

    case AlertDialogType.Sin_acceso_wifi_cerrar:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    "Sin conexi??n a internet",
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
                                  "Comprueba que tienes acceso a una red Wi-Fi o que cuentas con datos m??viles activados.",
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
              ),
            );
          });
      break;




    case AlertDialogType.CerrarSesion:
      Inactivity(context:context).cancelInactivity();
      showDialog(
          useSafeArea: false,
          barrierDismissible: false,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                      //width: responsive.width,
                      child: Card(
                        color: Theme.Colors.White,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: responsive.hp(3.5)),
                                child: Text(
                                  "Cerrar sesi??n",
                                  style: TextStyle(
                                    color: Theme.Colors.Encabezados,
                                    fontSize: responsive.ip(2.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(3.5),
                                  left: responsive.width * 0.05),
                              child: Text(
                                "??Est??s seguro de que deseas salir de tu App Intermediario GNP?",
                                style: TextStyle(
                                  color: Theme.Colors.Funcional_Textos_Body,
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin:
                                    EdgeInsets.only(top: responsive.hp(3.5)),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: Theme.Colors.GNP,
                                  onPressed: () {
                                    isMessageMobileClose = false;
                                    sendTag("appinter_perfil_cerrar");
                                    prefs.setBool("showAP", null);
                                    prefs.setBool("rolAutoscotizarActivo", null);
                                    inactiveFirebaseDivice(false);
                                    connectivitySubscription.cancel();
                                    connectivitySubscription = null;
                                    if (prefs.getBool("activarBiometricos")) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BiometricosPage(
                                                      responsive: responsive),settings: RouteSettings(name: "Biometricos")));
                                    }
                                    else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PrincipalFormLogin(
                                                      responsive: responsive),settings: RouteSettings(name: "Login")));
                                    }
                                  },
                                  child: Text(
                                    "CERRAR SESI??N",
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
                                    Navigator.pop(context, true);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    Navigator.pop(context, true);
                                    customAlert(
                                        AlertDialogType.En_mantenimiento_llave,
                                        context,
                                        "",
                                        "",
                                        responsive,
                                        FuncionAlerta);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    Navigator.pop(context, true);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                              height: responsive.hp(15),
                              width: responsive.wp(15),
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.03),
                              child: Center(
                                child: Image.asset(
                                  "assets/info_24px.png",
                                  fit: BoxFit.contain,
                                  height: responsive.hp(14),
                                  width: responsive.wp(14),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.05),
                              child: Center(
                                child: Text(
                                  "Sin acesso a herramientas de cotizaci??n",
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
                                "Debido a tus permisos asignados no es posible ingresar a las herramientas de cotizaci??n.",
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
                                    Navigator.pop(context, true);
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  builder: (context) => AutosPage(
                                        responsive: responsive,
                                      )),
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


    case AlertDialogType.error_codigo_verificacion:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: responsive.hp(2),
                                bottom: responsive.hp(2)),
                            child: Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.redAccent,
                              size: responsive.ip(6),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Codigo de verificaci??n",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.Colors.Encabezados,
                                fontSize: responsive.ip(2.2)),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: responsive.height * 0.04,
                                bottom: responsive.height * 0.05,
                                right: responsive.wp(5),
                                left: responsive.wp(5)),
                            child: Text.rich(TextSpan(
                                text:
                                "Has superado el l??mite de env??o de c??digos de verificaci??n. En 7 minutos podr??s solicitar su env??o nuevamente",
                                style: TextStyle(
                                    color: Theme.Colors.Funcional_Textos_Body,
                                    fontSize: responsive.ip(1.7))
                            ))),
                        Center(
                          child: Container(
                            height: responsive.hp(6.25),
                            width: responsive.wp(90),
                            margin: EdgeInsets.only(
                              bottom: responsive.height * 0.03,
                            ),
                            child: RaisedButton(
                              elevation: 0,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                "Aceptar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.Colors.GNP,
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

    case AlertDialogType.errorServicio:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: responsive.hp(2),
                                  bottom: responsive.hp(2)),
                              child: Icon(
                                Icons.warning_amber_outlined,
                                color: Colors.redAccent,
                                size: responsive.ip(6),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Servicio no disponible",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.Colors.Encabezados,
                                  fontSize: responsive.ip(2.2)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: responsive.height * 0.04,
                                  bottom: responsive.height * 0.05,
                                  right: responsive.wp(5),
                                  left: responsive.wp(5)),
                              child: Text.rich(TextSpan(
                                  text:
                                      "Por el momento no podemos completar tu solicitud, int??ntalo m??s tarde. Si el error persiste, comun??cate a Soporte GNP al ",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
                                      fontSize: responsive.ip(1.7)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            print("numero");
                                            launch('tel:5552273966');
                                          },
                                        text: "55 5227 3966 ",
                                        style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(1.7),
                                        )),
                                    TextSpan(
                                      text:
                                          "en un horario de lunes a viernes de 8:00 a 20:00 hrs. y s??bados de 8:00 a 14:00 hrs.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
                                          fontSize: responsive.ip(1.7)),
                                    ),
                                  ]))),
                          Center(
                            child: Container(
                              height: responsive.hp(6.25),
                              width: responsive.wp(90),
                              margin: EdgeInsets.only(
                                bottom: responsive.height * 0.03,
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
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                    child: Image.asset(
                                      'assets/images/verifica.png',
                                      fit: BoxFit.contain,
                                      height: responsive.hp(5),
                                      width: responsive.hp(4),
                                    )),
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
                                    right: responsive.width * 0.04,
                                    bottom: responsive.height * 0.03),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: responsive.height * 0.04,
                                    left: responsive.width * 0.04,
                                    right: responsive.width * 0.04,
                                    bottom: responsive.height * 0.01,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Estas preguntas de seguridad son las mismas para todas las plataformas digitales disponibles para ti.",
                                      style: TextStyle(
                                          color: Theme
                                              .Colors.Funcional_Textos_Body,
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
                                      top: responsive.height * 0.01),
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: Theme.Colors.White,
                                    onPressed: () {
                                      if (prefs.getBool("esPerfil") != null &&
                                          prefs.getBool("esPerfil")) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else if (prefs.getString(
                                              "medioContactoTelefono") !=
                                          "") {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        customAlertTablet(
                                            AlertDialogTypeTablet
                                                .verificaTuNumeroCelular,
                                            context,
                                            "",
                                            "",
                                            responsive,
                                            callback);
                                      } else {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        print(
                                            "No tiene medios de contacto preguntas");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoginActualizarNumero(
                                                          responsive:
                                                              responsive,
                                                        )));
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
              ),
            );
          });
      break;

    case AlertDialogType.inicio_de_sesion_inactivo_contador:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Inicio de sesi??n inactivo",
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
                                    "Has superado el n??mero permitido de intentos para iniciar sesi??n, en un momento podr??s intentarlo de nuevo.",
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
                  ],
                ),
              ],
            );
          });
      break;

    case AlertDialogType.versionTag:
      config = AppConfig.of(context);
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: responsive.hp(80),
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
                                      Icons.tag_faces_outlined,
                                      color: Colors.green,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(
                                  "Ambiente : ${config.ambient}",
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
                                  children:
                                      deviceData.keys.map((String property) {
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            property,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.fromLTRB(
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
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Inicio de sesi??n con huella digital o reconocimiento facial bloqueado",
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
                                    "Por seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con huella digital o reconocimiento facial, deber??s bloquear y desbloquear tu dispositivo.",
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
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
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
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      callback(false, responsive);

                                      await consultaBitacora();
                                          if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                            sendTag("appinter_login_ok");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                responsive: responsive,
                                              ),settings: RouteSettings(name: "Home")));
                                    }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
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

    case AlertDialogType.inicio_de_sesion_con_huella_bloqueado:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Inicio de sesi??n con huella digital bloqueado",
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
                                    "Por seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con huella digital, deber??s bloquear y desbloquear tu dispositivo.",
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
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) ||
                                        (prefs.getBool(
                                                    "subSecuentaIngresoCorreo") !=
                                                null &&
                                            prefs.getBool(
                                                "subSecuentaIngresoCorreo"))) {
                                      print("1 subsecuentes------------");
                                      if (prefs.getBool("esPerfil")) {
                                        print("2 subsecuentes------------");
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                      } else {
                                        print("3 subsecuentes------------");
                                        prefs.setBool(
                                            "activarBiometricos", true);
                                      }
                                      Navigator.pop(context, true);
                                      callback();
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      await consultaBitacora();
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
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

    case AlertDialogType.inicio_de_sesion_con_facial_bloqueado:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Inicio de sesi??n con reconocimiento \nfacial bloqueado",
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
                                    "Por seguridad deber??s iniciar sesi??n con tu contrase??a.\n\nPara continuar utilizando el inicio de sesi??n con reconocimiento facial, deber??s bloquear y desbloquear tu dispositivo.",
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
                                  onPressed: () async {
                                    if ((prefs.getBool("esPerfil") != null &&
                                            prefs.getBool("esPerfil")) ||
                                        (prefs.getBool(
                                                    "subSecuentaIngresoCorreo") !=
                                                null &&
                                            prefs.getBool(
                                                "subSecuentaIngresoCorreo"))) {
                                      print("1 subsecuentes------------");
                                      if (prefs.getBool("esPerfil")) {
                                        print("2 subsecuentes------------");
                                        prefs.setBool(
                                            "activarBiometricos", false);
                                      } else {
                                        print("3 subsecuentes------------");
                                        prefs.setBool(
                                            "activarBiometricos", true);
                                      }
                                      Navigator.pop(context, true);
                                      callback();
                                    } else if (prefs.getBool(
                                                "flujoCompletoLogin") !=
                                            null &&
                                        prefs.getBool("flujoCompletoLogin")) {
                                      Navigator.pop(context, true);
                                      callback(false, responsive);
                                      await consultaBitacora();
                                      if(_showFinOtro){
                                        customAlert(AlertDialogType.finalizar_seccion_en_otro_dispositivo, context, title, message, responsive, callback);
                                      }else{
                                        sendTag("appinter_login_ok");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  responsive: responsive,
                                                ),settings: RouteSettings(name: "Home")));
                                      }
                                    } else {
                                      prefs.setBool(
                                          "activarBiometricos", false);
                                      callback(false, responsive);
                                      Navigator.pop(context, true);
                                      customAlert(
                                          AlertDialogType
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

    case AlertDialogType.Contrasena_diferente_a_las_3_anteriores:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Contrase??a inv??lida",
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
                                  left: responsive.width * 0.06,
                                  right: responsive.width * 0.06,
                                  bottom: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "Tu nueva contrase??a debe ser diferente a las 3 contrase??as anteriores.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                  ],
                ),
              ],
            );
          });
      break;
    case AlertDialogType.Contrasena_diferente_a_las_3_anteriores_nueva:
      showDialog(
          useSafeArea: false,
          barrierDismissible: true,
          barrierColor: Theme.Colors.Back.withOpacity(0),
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
                                  "Contrase??a inv??lida",
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
                                  left: responsive.width * 0.06,
                                  right: responsive.width * 0.06,
                                  bottom: responsive.height * 0.03),
                              child: Center(
                                child: Text(
                                  "Has usado la contrase??a recientemente. Tu nueva contrase??a debe ser diferente a las 3 contrase??as anteriores.",
                                  style: TextStyle(
                                      color: Theme.Colors.Funcional_Textos_Body,
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
                  ],
                ),
              ],
            );
          });
      break;
  }
}

class MyDialogContrasenaInactividad extends StatefulWidget {
  Function callback;
  MyDialogContrasenaInactividad({Key key, this.callback}) : super(key: key);
  @override
  _MyDialogContrasenaInactividadState createState() =>
      new _MyDialogContrasenaInactividadState();
}

class _MyDialogContrasenaInactividadState
    extends State<MyDialogContrasenaInactividad> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerContrasena = new TextEditingController();
  bool _enable = true;
  bool _validPassword = false;
  bool _validPass = true;
  String errorMessagePassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusContrasenaInactividad.addListener(() {
      String password = controllerContrasena.text.trimRight();
      String passwordReplace = password.trimLeft();
      controllerContrasena.text =
          passwordReplace.replaceAll(new RegExp(r"\s+"), "");

      setState(() {
        _validPass = _formKey.currentState.validate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.only(
                    top: focusContrasenaInactividad.hasFocus
                        ? MediaQuery.of(context).size.height / 2 -
                            250 // adjust values according to your need
                        : MediaQuery.of(context).size.height / 2 + 15),
                width: responsive.width,
                child: Card(
                  color: Theme.Colors.White,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: responsive.hp(2)),
                        child: Center(
                          child: Text(
                            "Iniciar sesi??n",
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
                          right: responsive.height * 0.04,
                          left: responsive.height * 0.04,
                        ),
                        child: Text(
                          "Por tu seguridad es necesario que ingreses nuevamente tu contrase??a.",
                          style: TextStyle(
                              color: Theme.Colors.Funcional_Textos_Body,
                              fontSize: responsive.ip(1.8)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: responsive.height * 0.04,
                          left: responsive.height * 0.04,
                        ),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(24),
                            ],
                            controller: controllerContrasena,
                            focusNode: focusContrasenaInactividad,
                            autofocus: true,
                            obscureText: contrasenaInactividad,
                            keyboardType: TextInputType.visiblePassword,
                            enabled: _enable,
                            onFieldSubmitted: (s) {
                              String password =
                                  controllerContrasena.text.trimRight();
                              String passwordReplace = password.trimLeft();
                              controllerContrasena.text = passwordReplace
                                  .replaceAll(new RegExp(r"\s+"), "");
                            },
                            cursorColor: _validPass
                                ? Theme.Colors.GNP
                                : Theme.Colors.validarCampo,
                            decoration: new InputDecoration(
                                errorText: _validPassword
                                    ? null
                                    : errorMessagePassword,
                                labelText: "Contrase??a",
                                labelStyle: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal,
                                  fontSize: responsive.ip(2),
                                  color: _validPass
                                      ? focusContrasenaInactividad.hasFocus
                                          ? Theme.Colors.GNP
                                          : Theme.Colors.inputcorreo
                                      : Theme.Colors.validarCampo,
                                ),
                                errorStyle: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal,
                                  fontSize: responsive.ip(1.2),
                                  color: Theme.Colors.validarCampo,
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.Colors.validarCampo,
                                      width: 2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _validPass
                                          ? Theme.Colors.inputlinea
                                          : Theme.Colors.validarCampo),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _validPass
                                          ? Theme.Colors.GNP
                                          : Theme.Colors.validarCampo,
                                      width: 2),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _validPass
                                          ? Theme.Colors.inputlinea
                                          : Theme.Colors.validarCampo,
                                      width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: contrasenaInactividad
                                      ? _validPass
                                          ? Image.asset(
                                              "assets/login/novercontrasena.png")
                                          : Image.asset(
                                              "assets/login/_icon_error_contrasena.png")
                                      : _validPass
                                          ? Image.asset(
                                              "assets/login/vercontrasena.png")
                                          : Image.asset(
                                              "assets/login/_icono-withmask.png"),
                                  color: Theme.Colors.VLMX_Navy_40,
                                  onPressed: () {
                                    setState(() {
                                      contrasenaInactividad =
                                          !contrasenaInactividad;
                                    });
                                    //contrasenaInactividad = !contrasenaInactividad;
                                  },
                                )),
                            onTap: () {
                              setState(() {
                                focusContrasenaInactividad.requestFocus();
                              });
                            },
                            onEditingComplete: () {
                              _formKey.currentState.validate();
                              setState(() {
                                focusContrasenaInactividad.unfocus();
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                _validPassword = false;
                                return 'Este campo es requerido';
                              } else if (value.contains(" ")) {
                                _validPassword = false;
                                return 'No debe tener espacios en blanco';
                              } else {
                                _validPassword = true;
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                controllerContrasena.text;
                                _validPass = _formKey.currentState.validate();
                                if (controllerContrasena.text.isNotEmpty &&
                                    controllerContrasena.text.length >= 24) {
                                  String tem = controllerContrasena.text;
                                  controllerContrasena.text =
                                      tem.substring(0, 23);
                                  focusContrasenaInactividad.unfocus();
                                }
                              });
                            },
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
                            color: controllerContrasena.text != ""
                                ? Theme.Colors.GNP
                                : Theme.Colors.botonlogin,
                            onPressed: () {
                              var value = _encryptData.decryptData(prefs.getString("contrasenaUsuario"),
                                  "CL#AvEPrincIp4LvA#lMEXapgpsi2020");

                              if ( controllerContrasena.text != null &&
                                  controllerContrasena.text.isNotEmpty ) {
                                if (controllerContrasena.text == value ) {
                                  sendTag("appinter_inactividad_login");
                                  inactiveFirebaseDivice(true);
                                  initializeTimerOtroUsuario(context,(){});
                                  Navigator.pop(context, true);
                                  showInactividad = false;
                                  widget.callback();
                                  //initializeTimer(context,widget.callback);
                                } else {
                                  cancelTimerDosApps();
                                  Navigator.pop(context, true);
                                  AlertaContraseniaErronea();
                                }
                              }
                            },
                            child: Text(
                              "ACEPTAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: controllerContrasena.text != ""
                                    ? Theme.Colors.White
                                    : Theme.Colors.botonletra,
                                fontSize: responsive.ip(1.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              focusContrasenaInactividad.hasFocus
                  ? Container(
                      height: responsive.hp(42),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  void AlertaContraseniaErronea() {
    Inactivity(context: context).cancelInactivity();
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
                                  "No se puede iniciar sesi??n",
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
                                    "Correo electr??nico o contrase??a no coinciden",
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
                                    prefs.setBool("esPerfil", false);
                                    sendTag("appinter_inactividad");

                                    Navigator.pop(context, true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PrincipalFormLogin(
                                                  responsive:
                                                      Responsive.of(context),
                                                ),settings: RouteSettings(name: "Login")));
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
  }
}

Future<void> doLoginBiometrics(BuildContext context, Function callback) async {
  try {
    bool authenticated;

    if (Platform.isIOS) {
      authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: is_available_finger ?  'Coloca tu dedo para continuar.' : 'Mira fijamente a la c??mara para continuar.',
          iOSAuthStrings: new IOSAuthMessages (
              lockOut: 'Has superado los intentos permitidos para usar biom??tricos, deber??s bloquear y desbloquear tu dispositivo.',
              goToSettingsDescription:  is_available_finger
                  ? "Tu huella no est?? configurada en el dispositivo, ve a configuraciones para a??adirla."
                  : "Tu reconocimiento facial no est?? configurado en el dispositivo, ve a configuraciones para a??adirla.",
              goToSettingsButton: "Ir a configuraciones",
              cancelButton: "Cancelar"),
          useErrorDialogs: true,
          stickyAuth: false);
    } else {
      authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: "Coloca tu dedo o mira a la c??mara para continuar.",
          androidAuthStrings: new AndroidAuthMessages(
              fingerprintNotRecognized: 'Has superado los intentos permitidos para usar biom??tricos, deber??s bloquear y desbloquear tu dispositivo.',
              signInTitle: "Inicio de sesi??n",
              fingerprintHint: '',
              cancelButton: "Cancelar",
              fingerprintRequiredTitle: "Solicitud de huella digital o reconocimiento facial",
              goToSettingsDescription: "Tu reconocimiento facial o tu huella no est?? configurada en el dispositivo, ve a configuraciones para a??adirla.",
              goToSettingsButton: "Ir a configuraciones"),
          useErrorDialogs: true,
          stickyAuth: false);
    }

    if (authenticated) {
      inactiveFirebaseDivice(true);
      callback();
      showInactividad = false;
      Navigator.pop(context, true);
    } else {
      localAuth.stopAuthentication();
      bool localAuths = await localAuth.canCheckBiometrics;
      print(
          "didAuthenticate not $localAuths ${prefs.getInt("localAuthCountIOS")}");

      if (!localAuths) {
        Inactivity(context: context).cancelInactivity();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BiometricosPage(
                      responsive: Responsive.of(context),
                    ),settings: RouteSettings(name: "Biometricos")));
        if (prefs != null &&
            prefs.getInt("localAuthCountIOS") != null &&
            prefs.getInt("localAuthCountIOS") == 102) {
          prefs.setInt("localAuthCountIOS", 102);
          localAuth.stopAuthentication();
          Platform.isAndroid
              ? customAlert(
                  AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO,
                  context,
                  "",
                  "",
                  Responsive.of(context),
                  BiometricInactividadBack)
              : is_available_finger
                  ? customAlert(
                      AlertDialogType.HUELLA_PERMISS_DECLINADO,
                      context,
                      "",
                      "",
                      Responsive.of(context),
                      BiometricInactividadBack)
                  : customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context,
                      "", "", Responsive.of(context), BiometricInactividadBack);
        } else {
          prefs.setInt("localAuthCountIOS", 100);
          customAlert(
              Platform.isAndroid
                  ? AlertDialogType.Rostro_huella_no_reconocido
                  : is_available_face
                      ? AlertDialogType.Rostro_no_reconocido
                      : AlertDialogType.Huella_no_reconocida,
              context,
              "",
              "",
              Responsive.of(context),
              BiometricInactividadBack);
        }
      }
    }
  } on PlatformException catch (e) {
    print("PlatformException ${e}");
    print("PlatformException: code ${e.code}");
    print("PlatformException: message ${e.message}");
    print("PlatformException: stacktrace ${e.stacktrace}");
    Inactivity(context: context).cancelInactivity();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BiometricosPage(
                  responsive: Responsive.of(context),
                ),settings: RouteSettings(name: "Biometricos")));
    prefs.setBool("subSecuentaIngresoCorreo", true);

    if (e.code == auth_error.lockedOut) {
      print("auth_error.lockedOut");
      prefs.setInt("localAuthCountIOS", 100);
      prefs.setInt("localAuthCount", 5);
      localAuth.stopAuthentication();
      customAlert(
            Platform.isAndroid ?
               AlertDialogType.Rostro_huella_no_reconocido
              : is_available_face
                  ? AlertDialogType.Rostro_no_reconocido
                  : AlertDialogType.Huella_no_reconocida,
          context,
          "",
          "",
          Responsive.of(context),
          BiometricInactividadBack);
    } else if (e.code == auth_error.permanentlyLockedOut) {
      prefs.setInt("localAuthCountIOS", 101);
      print("auth_error.permanentlyLockedOut");
      prefs.setInt("localAuthCount", 6);
      localAuth.stopAuthentication();

      customAlert(
Platform.isAndroid
    ? AlertDialogType.inicio_de_sesion_con_huella_facial_bloqueado
              : is_available_finger
                  ? AlertDialogType.inicio_de_sesion_con_huella_bloqueado
                  : AlertDialogType.inicio_de_sesion_con_facial_bloqueado,
          context,
          "",
          "",
          Responsive.of(context),
          BiometricInactividadBack);
    } else if (e.code == auth_error.notAvailable) {
      prefs.setInt("localAuthCountIOS", 102);
      localAuth.stopAuthentication();
      Platform.isAndroid
          ? customAlert(AlertDialogType.FACE_HUELLA_PERMISS_DECLINADO, context,
              "", "", Responsive.of(context), BiometricInactividadBack)
          : is_available_finger
              ? customAlert(AlertDialogType.HUELLA_PERMISS_DECLINADO, context,
                  "", "", Responsive.of(context), BiometricInactividadBack)
              : customAlert(AlertDialogType.FACE_PERMISS_DECLINADO, context, "",
                  "", Responsive.of(context), BiometricInactividadBack);
    }
  }
}

void BiometricInactividadBack() {}

void FuncionAlerta(bool abc) {}

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

void consultaBitacora() async {
print("consultaBitacora CustomAlerts");
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
  try{
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {
      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);
      print("-- response -- ${response}");
      if(response!= null && response.isNotEmpty){
        if(deviceData["id"]==response["deviceID"]){
          _showFinOtro = false;
        }else{
          if(response["isActive"]!= null && response["isActive"]){
              _showFinOtro = true;
          }
          else{
              _showFinOtro = false;
          }
        }
      } else{
        _showFinOtro = false;
      };

    });
  }catch(e){
    print(e);
  }

}

void primerAccesoUsuario() async {
  Map userInfo;
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();

  String correoUsuario;
  String emailFirst;
  String email;
  correoUsuario = _encryptData.decryptData(prefs.getString("correoUsuario"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
  emailFirst = correoUsuario.replaceAll('.', '-');
  email = emailFirst.replaceAll('@', '-');

  try {
    await _dataBaseReference
        .child("firstSessionUser")
        .child(email.toLowerCase())
        .once()
        .then((DataSnapshot _snapshot) {
      var jsoonn = json.encode(_snapshot.value);
      userInfo = json.decode(jsoonn);

      if (userInfo.isNotEmpty && userInfo != null) {
        if (userInfo["isFirstMobileSession"]) {
          _dataBaseReference
              .child("firstSessionUser")
              .child(email.toLowerCase())
              .set({'isFirstMobileSession': false});
        }
        _firstSession = false;
      } else {
        _firstSession = true;
      }
    });
  } catch (err) {
    _firstSession = true;
    _dataBaseReference
        .child("firstSessionUser")
        .child(email.toLowerCase())
        .set({'isFirstMobileSession': true});
  }
}

void inactiveFirebaseDivice(bool active) async {
  //cancelTimerDosApps();
  DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime nowH = DateTime.now();
  //String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
  String formattedDate = DateFormat('kk:mm:ss').format(now);
  String formatted = formatter.format(now);
  List<Placemark> newPlace;
  String locality="";
  String address;
  String deviceName= _encryptData.decryptData(prefs.getString("deviceName"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");
  try{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission  != LocationPermission.denied && permission  != LocationPermission.deniedForever) {
      userLocation= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      newPlace = await placemarkFromCoordinates(userLocation.latitude, userLocation.longitude);
      Placemark placeMark  = newPlace[0];
      String name = placeMark.name;
      String subLocality = placeMark.subLocality;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      String address = "${locality}";
      // this is all you need
      //String address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    }else{
      address=" ";
    }
  }catch(e){
    address=" ";
    print("interactions Places costum");
    print(e);
  }

  print("deviceID: ${deviceData["id"]}");
  try{
    await _dataBaseReference.child("bitacora").child(datosUsuario.idparticipante).once().then((DataSnapshot _snapshot) {

      var jsoonn = json.encode(_snapshot.value);
      Map response = json.decode(jsoonn);
      print("-- response -- ${response}");

      print("id ${deviceData["id"]}");
      print("isActive $active");
      Map<String, dynamic> mapa = {
        '${datosUsuario.idparticipante}': {
          'deviceID' : deviceData["id"],
          'hora':"${formattedDate}",
          'ciudad':address,
          'dispositivo':Platform.isAndroid?"Android" + " ${deviceName}":"IOS" + " ${deviceName}",
          'isActive':active,
        }
      };
      _dataBaseReference.child("bitacora").update(mapa);

    });
  }catch(e){
    print("inactiveFirebaseDivice");
    print(e);
  }
}
