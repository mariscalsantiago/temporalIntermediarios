import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/DinamicCustumWidget.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPersonaIdParticipante.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultarUsuarioPorCorreo.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/modelos/ConexionModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/Security/EncryptData.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/Services/metricsPerformance.dart';
import 'package:firebase_performance/firebase_performance.dart';

import 'package:cotizador_agente/Functions/Analytics.dart';

AppConfig _appEnvironmentConfig;

Future<consultaPreguntasSecretasModel> consultarPreguntaSecretaServicio(
    BuildContext context, String IdParticipante,Responsive responsive) async {

  print("consultarPreguntaSecretaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== Log In ${conecxion}");
  //prefs=await SharedPreferences.getInstance();
  if(conecxion) {
    http.Response _response;

    try {
      _response = await http.get(
          Uri.parse(
              _appEnvironmentConfig.consultaPreguntasSecretas + IdParticipante),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${loginData.refreshtoken}",
            'apiKey': _appEnvironmentConfig.apiKey
          });

      print("consultarPreguntaSecretaServicio ${_response.body}");
      print("consultarPreguntaSecretaServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.consultaPreguntasSecretas + IdParticipante,
          HttpMethod.Get);
      final http.Request request = http.Request(
          "PreguntasSecretas",
          Uri.parse(_appEnvironmentConfig.consultaPreguntasSecretas +
              IdParticipante));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map map = json.decode(_response.body);
            consultaPreguntasSecretasModel _datosConsulta =
            consultaPreguntasSecretasModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else{
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;
  }
}

Future<consultaPreguntasSecretasModel> actualizarPreguntaSecretaServicio(
    BuildContext context,
    String IdParticipante,
    String contrasena,
    String preguntaUno,
    String respuestaUno,
    String preguntaDos,
    String respuestaDos, Responsive responsive) async {
  print("actualizarPreguntaSecretaServicio");
  _appEnvironmentConfig = AppConfig.of(context);


  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== actualizarPreguntaSecretaServicio conecxion: ${conecxion}");


  if (conecxion) {
    Map _loginBody = {
      "uid": IdParticipante,
      "password": contrasena,
      "preguntasRespuestas": [
        {"pregunta": preguntaUno, "respuesta": respuestaUno},
        {"pregunta": preguntaDos, "respuesta": respuestaDos}
      ]
    };
    String _loginJSON = json.encode(_loginBody);

    print("actualizarPreguntaSecretaServicio _loginJSON    ${_loginJSON}");

    http.Response _response;

    try {
      _response = await http.post(
          Uri.parse(
              _appEnvironmentConfig.actualizarEstablecerPreguntasSecretas),
          body: _loginJSON,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${loginData.refreshtoken}",
            'apiKey': _appEnvironmentConfig.apiKey
          });

      print("actualizarPreguntaSecretaServicio ${_response.body}");
      print("actualizarPreguntaSecretaServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.actualizarEstablecerPreguntasSecretas,
          HttpMethod.Post);
      final http.Request request = http.Request(
          "ActualizarPS",
          Uri.parse(
              _appEnvironmentConfig.actualizarEstablecerPreguntasSecretas));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map map = json.decode(_response.body);
            consultaPreguntasSecretasModel _datosConsulta =
                consultaPreguntasSecretasModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;
  }
}

Future<cambioContrasenaModel> cambioContrasenaServicio(
    BuildContext context,
    String contrasenaActual,
    String contrasenaNueva,
    String idIntermediario,Responsive responsive) async {
  print("cambioContrasenaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== cambioContrasenaServicio conecxion: ${conecxion}");

  if(conecxion) {
    http.Response _response;

    Map _loginBody = {"actual": contrasenaActual, "nueva": contrasenaNueva};
    String _loginJSON = json.encode(_loginBody);

    print("cambioContrasenaServicio ${_loginJSON}");

    try {
      _response = await http.post(
          Uri.parse(_appEnvironmentConfig.cambioContrasenaPerfil +
              idIntermediario +
              "/cambiar"),
          body: _loginJSON,
          headers: {
            "Content-Type": "application/json",
            'apiKey': _appEnvironmentConfig.apiKey,
            "Authorization": "Bearer ${loginData.refreshtoken}"
          });

      print(
          "url ${_appEnvironmentConfig.cambioContrasenaPerfil + idIntermediario + "/cambiar"}");
      print("cambioContrasenaServicio ${_response.body}");
      print("cambioContrasenaServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.cambioContrasenaPerfil +
              idIntermediario +
              "/cambiar",
          HttpMethod.Post);
      final http.Request request = http.Request(
          "CambioPass",
          Uri.parse(_appEnvironmentConfig.cambioContrasenaPerfil +
              idIntermediario +
              "/cambiar"));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map map = json.decode(_response.body);
            cambioContrasenaModel _datosConsulta =
                cambioContrasenaModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;
  }
}

Future<ReestablecerContrasenaModel> reestablecerContrasenaServicio(
    BuildContext context, String IdParticipante, String password, Responsive responsive) async {
  print("reestablecerContrasenaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== reestablecerContrasenaServicio conecxion: ${conecxion}");

  if(conecxion) {
    http.Response _response;

    Map<String, dynamic> _loginBody = {
      "cambioContrasena": {
        "uid": IdParticipante,
        "perfil": "Intermediario",
        "password": password
      }
    };
    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON   ${_loginJSON}");
    try {
      _response = await http.post(_appEnvironmentConfig.reestablecerContrasena,
          body: _loginJSON,
          headers: {
            'apiKey': _appEnvironmentConfig.apiKey,
            "Content-Type": "application/json",
            "Authorization": "Bearer ${loginData.refreshtoken}"
          });

      print("reestablecerContrasenaServicio ${_response.body}");
      print("reestablecerContrasenaServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.reestablecerContrasena,
          HttpMethod.Post);
      final http.Request request = http.Request("ReestablecerPass",
          Uri.parse(_appEnvironmentConfig.reestablecerContrasena));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map map = json.decode(_response.body);
            ReestablecerContrasenaModel _datosConsulta =
                ReestablecerContrasenaModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 500) {
            Map map = json.decode(_response.body);
            ReestablecerContrasenaModel _datosConsulta =
                ReestablecerContrasenaModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;
  }
}

Future<consultaPorCorreoNuevoServicio> consultaUsuarioPorCorreo(
    BuildContext context, String correo, Responsive responsive) async {
  print("consultaUsuarioPorCorreo");
  _appEnvironmentConfig = AppConfig.of(context);


  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== Log In ${conecxion}");

  if(conecxion) {
    http.Response _response;

    try {
      _response = await http.get(Uri.parse(_appEnvironmentConfig.servicioNuevoConsultaPorCorreo+"${correo}"),
          headers: {
            "Content-Type": "application/json;  charset=utf-8",
            "Authorization": "Bearer ${loginData.refreshtoken}",
            'apiKey': _appEnvironmentConfig.apiKey
          });

      print("consultaUsuarioPorCorreo ${_response.body}");
      print("consultaUsuarioPorCorreo ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.consultaUsuarioPorCorreo,
          HttpMethod.Post);
      final http.Request request = http.Request("ConsultaUserEmail",
          Uri.parse(_appEnvironmentConfig.consultaUsuarioPorCorreo));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            dynamic respons = jsonDecode(utf8.decode(_response.bodyBytes));
            Map<String, dynamic> map = respons[0];
            consultaPorCorreoNuevoServicio _datosConsulta = consultaPorCorreoNuevoServicio.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else if (_response.statusCode == 500) {
            print("StatusCode 500");
            Map<String, dynamic> map = json.decode(_response.body);

            if(map.containsKey("detail")){
              print("${map["detail"]}");
              if(map["detail"].containsKey("eotException"))
                if(map["detail"]["eotException"].containsKey("mensajeTecnico"))
                  if(map["detail"]["eotException"]["mensajeTecnico"].contains("Usuario inconsistente"))
                    customAlert(AlertDialogType.errorServicio, context, "", "", Responsive.of(context), funcionAlerta);
            }

            consultaPorCorreoNuevoServicio _datosConsulta = consultaPorCorreoNuevoServicio.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("consultaUsuarioPorCorreo -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("consultaUsuarioPorCorreo catch -- $e");
      return null;
    }
  } else {
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;

  }
}

Future<OrquestadorOTPModel> orquestadorOTPServicio(BuildContext context,
    String correo, String celular, bool esReestablecer, Responsive responsive) async {
  print("orquestadorOTPServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  if (context != null) DinamicCustumWidget(context: context).loadinGif();

  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== Log In ${conecxion}");

  if(conecxion) {
    http.Response _response;

    Map _loginBody;

    if (esReestablecer) {
      if (celular != null &&
          celular != "" &&
          celular != " " &&
          celular.isNotEmpty) {
        _loginBody = {"correo": correo, "enviarSms": true, "enviarMail": true};
      } else {
        _loginBody = {"correo": correo, "enviarSms": false, "enviarMail": true};
      }
    } else {
      _loginBody = {
        "correo": correo,
        "celular": celular,
        "enviarSms": true,
        "enviarMail": false
      };
    }

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON ${_loginJSON}");

    try {
      _response = await http.post(
          Uri.parse(_appEnvironmentConfig.orquestadorOTPSinSesion),
          body: _loginJSON,
          headers: {"Content-Type": "application/json"});

      print("orquestadorOTPServicio ${_response.body}");
      print("orquestadorOTPServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.orquestadorOTPSinSesion,
          HttpMethod.Post);
      final http.Request request = http.Request("OrquestadorOTP",
          Uri.parse(_appEnvironmentConfig.orquestadorOTPSinSesion));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_response.body);
            OrquestadorOTPModel _datosConsulta =
                OrquestadorOTPModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            if (context != null) print("context StatusCode 401");
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            if (context != null) print("context StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            if (context != null) print("context StatusCode");
            return null;
          }
        } else {
          print("Body null");
          if (context != null) print("context Body null");
          return null;
        }
      } else {
        if (context != null) print("context response null");
        print("response null");
        return null;
      }
    } on TimeoutException {
      if (context != null) print("context orquestadorOTPServicio -- TimeOut");
      //TODO time out test
      print("orquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      if (context != null) print("context orquestadorOTPServicio catch -- $e");
      print("orquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    if (context != null) print("_connectivityStatus context");
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;
  }
}

Future<ValidarOTPModel> validaOrquestadorOTPServicio(BuildContext context, String idOperacion, String OTP) async {
  print("validaOrquestadorOTPServicio");
  print("idOperacion ${idOperacion}");
  print("OTP ${OTP}");_appEnvironmentConfig = AppConfig.of(context);
  Responsive responsive = Responsive.of(context);
  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_conexion_error");
    conecxion = false;
  }

  print("== Log In ${conecxion}");

  if(conecxion) {
    http.Response _response;

    try {
      _response = await http.get(
          Uri.parse(_appEnvironmentConfig.validaOTP + idOperacion + "/" + OTP),
          headers: {
            "Authorization": "Bearer ${loginData.refreshtoken}",
            "Content-Type": "application/json",
            'apiKey': _appEnvironmentConfig.apiKey
          });

      print("url ${_appEnvironmentConfig.validaOTP + idOperacion + "/" + OTP}");
      print("validaOrquestadorOTPServicio ${_response.body}");
      print("validaOrquestadorOTPServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.validaOTP + idOperacion + "/" + OTP,
          HttpMethod.Get);
      final http.Request request = http.Request("ValidarOrquestadorOTP",
          Uri.parse(_appEnvironmentConfig.validaOTP + idOperacion + "/" + OTP));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_response.body);
            ValidarOTPModel _datosConsulta = ValidarOTPModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            Map<String, dynamic> map = json.decode(_response.body);
            ValidarOTPModel _datosConsulta = ValidarOTPModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("validaOrquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("validaOrquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    customAlert(AlertDialogType.Sin_acceso_wifi_cerrar, context, "", "", responsive, callback);
    return null;

  }
}

Future<consultaMediosContactoAgentesModel> consultaMediosContactoServicio(
    BuildContext context, String idParticipante) async {
  print("consultaMediosContactoServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus =
      await ConnectivityServices().getConnectivityStatus(false);
  Responsive responsive = Responsive.of(context);

  bool conecxion = false;
  try{
    conecxion = await validatePinig();
  } catch(e){
    sendTag("appinter_login_error");
    conecxion = false;
  }
  print("consultaMediosContactoServicio ${conecxion}");
  if (conecxion) {
    try {
      if (_connectivityStatus.available) {
        http.Response _response;

        try {
          _response = await http.get(
              Uri.parse(_appEnvironmentConfig.consultarMedioContactosAgentes +
                  idParticipante),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${loginData.refreshtoken}",
                'apiKey': _appEnvironmentConfig.apiKey
              });

          print(
              "consultaMediosContactoServicio ${Uri.parse(_appEnvironmentConfig.consultarMedioContactosAgentes + idParticipante)}");
          print("consultaMediosContactoServicio ${_response.body}");
          print("consultaMediosContactoServicio ${_response.statusCode}");

          //TODO: Metrics
          final MetricsPerformance metricsPerformance = MetricsPerformance(
              http.Client(),
              _appEnvironmentConfig.consultarMedioContactosAgentes +
                  idParticipante,
              HttpMethod.Get);
          final http.Request request = http.Request(
              "ConsultaMDC",
              Uri.parse(_appEnvironmentConfig.consultarMedioContactosAgentes +
                  idParticipante));
          metricsPerformance.send(request);

          if (_response != null) {
            if (_response.body != null) {
              if (_response.statusCode == 200) {
                Map<String, dynamic> map = json.decode(_response.body);
                consultaMediosContactoAgentesModel _datosConsulta =
                    consultaMediosContactoAgentesModel.fromJson(map);
                if (_datosConsulta != null) {
                  return _datosConsulta;
                } else {
                  return null;
                }
              } else if (_response.statusCode == 401) {
                print("StatusCode 401");
                return null;
              } else if (_response.statusCode == 404) {
                print("StatusCode 404");
                return null;
              } else if (_response.statusCode == 500) {
                print("StatusCode 500");
                return null;
              } else {
                print("StatusCode");
                return null;
              }
            } else {
              print("Body null");
              return null;
            }
          } else {
            print("response null");
            return null;
          }
        } on TimeoutException {
          //TODO time out test
          print("consultaMediosContactoServicio -- TimeOut");
          //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
          return null;
        } catch (e) {
          print("consultaMediosContactoServicio catch -- $e");
          return null;
        }
      } else {
        //errorConexion = true;
        return null;
      }
    } catch (e) {
      print("consultaMediosContactoServicio catch");
      print(e);
      customAlert(AlertDialogType.errorServicio, context, "", "", responsive,
          funcionAlerta);
      return null;
    }
  } else {
    //customAlert(AlertDialogType.Sin_acceso_wifi, context, "", "", responsive, funcionAlerta);
    return null;
  }
}

Future<AltaMedisoContactoAgentes> altaMediosContactoServicio(
    BuildContext context, String lada, String numero) async {
  print("altaMediosContactoServicio");

  EncryptData _encryptData = EncryptData();

  String idParticipante = prefs.getBool('flujoOlvideContrasena') != null &&
          prefs.getBool('flujoOlvideContrasena')
      ? idParticipanteValidaPorCorre
      : datosUsuario.idparticipante;
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus =
      await ConnectivityServices().getConnectivityStatus(false);

  if (_connectivityStatus.available) {
    http.Response _response;
    var decrypted = _encryptData.decryptData(prefs.getString("codigoAfiliacion"), "CL#AvEPrincIp4LvA#lMEXapgpsi2020");

    Map _loginBody = {
      "idParticipante": idParticipante,
      "codFiliacion": prefs.getString("codigoAfiliacion") != null &&
              prefs.getString("codigoAfiliacion") != ""
          ? decrypted
          : "",
      "tipoMedioContacto": "TLCL",
      "propositosContacto": [
        {"id": "CAA", "operacion": "AL"}
      ],
      "telefono": {
        "lada": lada,
        "ladaInternacional": "52",
        "numExtension": "",
        "numTelefono": numero
      },
      "banPrincipal": "true",
      "usuarioAudit": "CRM_PRUEBA"
    };

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON  ${_loginJSON}");

    try {
      _response = await http.post(
          Uri.parse(_appEnvironmentConfig.altaMediosContactoAgentes),
          body: _loginJSON,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${loginData.refreshtoken}",
            'apiKey': _appEnvironmentConfig.apikeyAppAgentes
          });

      print("altaMediosContactoServicio ${_response.body}");
      print("altaMediosContactoServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.altaMediosContactoAgentes,
          HttpMethod.Post);
      final http.Request request = http.Request("AltaMDC",
          Uri.parse(_appEnvironmentConfig.altaMediosContactoAgentes));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_response.body);
            AltaMedisoContactoAgentes _datosConsulta =
                AltaMedisoContactoAgentes.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("altaMediosContactoServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("altaMediosContactoServicio catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<OrquetadorOtpJwtModel> orquestadorOTPJwtServicio(
    BuildContext context, String celular, bool esActualizarNumero) async {
  print("orquestadorOTPJwtServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if (_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody;

    if (esActualizarNumero) {
      _loginBody = {"celular": celular, "enviarSms": true, "enviarMail": false};
    } else {
      _loginBody = {"enviarSms": true, "enviarMail": true};
    }

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON ${_loginJSON}");

    try {
      _response = await http.post(
          Uri.parse(_appEnvironmentConfig.orquestadorOtpJwt),
          body: _loginJSON,
          headers: {
            "Authorization": "Bearer ${loginData.refreshtoken}",
            "Content-Type": "application/json"
          });

      print("orquestadorOTPJwtServicio ${_response.body}");
      print("orquestadorOTPJwtServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.orquestadorOtpJwt,
          HttpMethod.Post);
      final http.Request request = http.Request(
          "OrquestadorJWT", Uri.parse(_appEnvironmentConfig.orquestadorOtpJwt));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_response.body);
            OrquetadorOtpJwtModel _datosConsulta =
                OrquetadorOtpJwtModel.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("orquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("orquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    print("OrquetadorOtpJwtModel");
    conexionModel = ConexionModel.fromJson({"status":true, "messages":"Conexión en servicio de OTP"});
    //errorConexion = true;
    return null;
  }
}

Future<ConsultarPorIdParticipanteConsolidado>
    ConsultarPorIdParticipanteServicio(
        BuildContext context, String idParticipante) async {
  print("ConsultarPorIdParticipanteServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus =
      await ConnectivityServices().getConnectivityStatus(false);

  if (_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody = {
      "idParticipante": idParticipante,
      "modoConsulta": "H"
    };

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON ${_loginJSON}");

    try {
      _response = await http.post(
          Uri.parse(_appEnvironmentConfig.consultaPersonaIdParticipante),
          body: _loginJSON,
          headers: {
            'apiKey': _appEnvironmentConfig.apiKey,
            "Authorization": "Bearer ${loginData.refreshtoken}"
          });

      print("ConsultarPorIdParticipanteServicio ${_response.body}");
      print("ConsultarPorIdParticipanteServicio ${_response.statusCode}");

      //TODO: Metrics
      final MetricsPerformance metricsPerformance = MetricsPerformance(
          http.Client(),
          _appEnvironmentConfig.consultaPersonaIdParticipante,
          HttpMethod.Post);
      final http.Request request = http.Request("ConsultaPPID",
          Uri.parse(_appEnvironmentConfig.consultaPersonaIdParticipante));
      metricsPerformance.send(request);

      if (_response != null) {
        if (_response.body != null) {
          if (_response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_response.body);
            ConsultarPorIdParticipanteConsolidado _datosConsulta =
                ConsultarPorIdParticipanteConsolidado.fromJson(map);
            if (_datosConsulta != null) {
              return _datosConsulta;
            } else {
              return null;
            }
          } else if (_response.statusCode == 401) {
            print("StatusCode 401");
            return null;
          } else if (_response.statusCode == 404) {
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else {
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    } on TimeoutException {
      //TODO time out test
      print("ConsultarPorIdParticipanteServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("ConsultarPorIdParticipanteServicio catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}
