import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaMediosContactoAgentesModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultarUsuarioPorCorreo.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOtpJwtModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:http/http.dart' as http;


AppConfig _appEnvironmentConfig;


Future<consultaPreguntasSecretasModel> consultarPreguntaSecretaServicio(BuildContext context, String  IdParticipante) async {

  print("consultarPreguntaSecretaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    try {
      _response = await http.get(Uri.parse(_appEnvironmentConfig.consultaPreguntasSecretas+IdParticipante),
          headers: {"Content-Type": "application/json", 'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("consultarPreguntaSecretaServicio ${_response.body}");
      print("consultarPreguntaSecretaServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map map = json.decode(_response.body);
            consultaPreguntasSecretasModel _datosConsulta = consultaPreguntasSecretasModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<consultaPreguntasSecretasModel> actualizarPreguntaSecretaServicio(BuildContext context, String  IdParticipante, String contrasena,
    String  preguntaUno, String respuestaUno, String preguntaDos, String respuestaDos) async {

  print("actualizarPreguntaSecretaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {

    Map _loginBody = {
      "uid": IdParticipante,
      "password": contrasena,
      "preguntasRespuestas": [
        {
          "pregunta": preguntaUno,
          "respuesta": respuestaUno
        },
        {
          "pregunta": preguntaDos,
          "respuesta": respuestaDos
        }
      ]
    };
    String _loginJSON = json.encode(_loginBody);

    print("actualizarPreguntaSecretaServicio _loginJSON    ${_loginJSON}");

    http.Response _response;

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.actualizarEstablecerPreguntasSecretas),
          body: _loginJSON,
          headers: {"Content-Type": "application/json", 'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("actualizarPreguntaSecretaServicio ${_response.body}");
      print("actualizarPreguntaSecretaServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map map = json.decode(_response.body);
            consultaPreguntasSecretasModel _datosConsulta = consultaPreguntasSecretasModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<cambioContrasenaModel> cambioContrasenaServicio(BuildContext context, String  contrasenaActual, String contrasenaNueva, String idIntermediario) async {

  print("cambioContrasenaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody = {
      "actual": contrasenaActual,
      "nueva": contrasenaNueva
    };
    String _loginJSON = json.encode(_loginBody);

    print("cambioContrasenaServicio ${_loginJSON}");

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.cambioContrasenaPerfil+idIntermediario+"/cambiar"),
          body: _loginJSON,
          headers: {"Content-Type": "application/json", 'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("url ${_appEnvironmentConfig.cambioContrasenaPerfil+idIntermediario+"/cambiar"}");
      print("cambioContrasenaServicio ${_response.body}");
      print("cambioContrasenaServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map map = json.decode(_response.body);
            cambioContrasenaModel _datosConsulta = cambioContrasenaModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<ReestablecerContrasenaModel> reestablecerContrasenaServicio(BuildContext context, String  IdParticipante, String password) async {

  print("reestablecerContrasenaServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {

    print("available ${_connectivityStatus.available}");
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
          headers: {'apiKey': _appEnvironmentConfig.apiKey, "Content-Type": "application/json"}
      );

      print("reestablecerContrasenaServicio ${_response.body}");
      print("reestablecerContrasenaServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map map = json.decode(_response.body);
            ReestablecerContrasenaModel _datosConsulta = ReestablecerContrasenaModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 500){
            Map map = json.decode(_response.body);
            ReestablecerContrasenaModel _datosConsulta = ReestablecerContrasenaModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("loginValidaUsuario -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("loginValidaUsuario catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<UsuarioPorCorreo> consultaUsuarioPorCorreo(BuildContext context, String  correo) async {

  print("consultaUsuarioPorCorreo");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody = {
      "consultaUsuarioPorCorreo": {
        "perfil": "Intermediario",
        "correoElectronico": correo
      }
    };
    String _loginJSON = json.encode(_loginBody);

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.consultaUsuarioPorCorreo),
          body: _loginJSON,
          headers: {"Content-Type": "application/json", 'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("consultaUsuarioPorCorreo ${_response.body}");
      print("consultaUsuarioPorCorreo ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            UsuarioPorCorreo _datosConsulta = UsuarioPorCorreo.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("consultaUsuarioPorCorreo -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("consultaUsuarioPorCorreo catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<OrquestadorOTPModel> orquestadorOTPServicio(BuildContext context, String  correo, String celular, bool esReestablcer) async {

  print("orquestadorOTPServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody;

    if(esReestablcer){
      _loginBody = {
        "correo": correo
      };
    } else {
      _loginBody = {
        "correo": correo,
        "celular": "5531149725"
        //TODO  quitar telefono harcode
        //"celular": celular
      };

    }

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON ${_loginJSON}");

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.orquestadorOTPSinSesion),
          body: _loginJSON,
          headers: {"Content-Type": "application/json"}
      );

      print("orquestadorOTPServicio ${_response.body}");
      print("orquestadorOTPServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            OrquestadorOTPModel _datosConsulta = OrquestadorOTPModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("orquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("orquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<ValidarOTPModel> validaOrquestadorOTPServicio(BuildContext context, String  idOperacion, String OTP) async {

  print("validaOrquestadorOTPServicio");
  print("idOperacion ${idOperacion}");
  print("OTP ${OTP}");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    try {
      _response = await http.get(Uri.parse(_appEnvironmentConfig.validaOTP+idOperacion+"/"+OTP),
          headers: {"Content-Type": "application/json",'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("url ${_appEnvironmentConfig.validaOTP+idOperacion+"/"+OTP}");
      print("validaOrquestadorOTPServicio ${_response.body}");
      print("validaOrquestadorOTPServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            ValidarOTPModel _datosConsulta = ValidarOTPModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            Map<String, dynamic> map = json.decode(_response.body);
            ValidarOTPModel _datosConsulta = ValidarOTPModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("validaOrquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("validaOrquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}

Future<consultaMediosContactoAgentesModel> consultaMediosContactoServicio(BuildContext context, String  idParticipante) async {

  print("consultaMediosContactoServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    try {
      _response = await http.get(Uri.parse(_appEnvironmentConfig.consultarMedioContactosAgentes+idParticipante),
          headers: {"Content-Type": "application/json",'apiKey': _appEnvironmentConfig.apiKey}
      );

      print("consultaMediosContactoServicio ${_response.body}");
      print("consultaMediosContactoServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            consultaMediosContactoAgentesModel _datosConsulta = consultaMediosContactoAgentesModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
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
}

Future<AltaMedisoContactoAgentes> altaMediosContactoServicio(BuildContext context, String lada, String numero) async {

  print("altaMediosContactoServicio");
  String idParticipante = prefs.getBool('flujoOlvideContrasena') != null && prefs.getBool('flujoOlvideContrasena') ? idParticipanteValidaPorCorre : datosUsuario.idparticipante ;
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody = {
      "idParticipante": idParticipante,
      "codFiliacion": mediosContacto.codigoFiliacion,
      "tipoMedioContacto": "TLCL",
      "propositosContacto": [
        {
          "id": "CAA",
          "operacion": "AL"
        }
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
      _response = await http.post(Uri.parse(_appEnvironmentConfig.altaMediosContactoAgentes),
          body: _loginJSON,
          headers: {"Content-Type": "application/json",'apiKey': _appEnvironmentConfig.apikeyAppAgentes}
      );

      print("altaMediosContactoServicio ${_response.body}");
      print("altaMediosContactoServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            AltaMedisoContactoAgentes _datosConsulta = AltaMedisoContactoAgentes.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
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

Future<OrquetadorOtpJwtModel> orquestadorOTPJwtServicio(BuildContext context, String celular) async {

  print("orquestadorOTPJwtServicio");
  _appEnvironmentConfig = AppConfig.of(context);

  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);

  if(_connectivityStatus.available) {
    http.Response _response;

    Map _loginBody = {
    };

    String _loginJSON = json.encode(_loginBody);

    print("_loginJSON ${_loginJSON}");

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.orquestadorOtpJwt),
          body: _loginJSON,
          headers: {"Authorization": "Bearer ${loginData.jwt}", "Content-Type": "application/json"}
      );

      print("orquestadorOTPJwtServicio ${_response.body}");
      print("orquestadorOTPJwtServicio ${_response.statusCode}");

      if(_response != null){
        if(_response.body != null){
          if(_response.statusCode == 200){
            Map<String, dynamic> map = json.decode(_response.body);
            OrquetadorOtpJwtModel _datosConsulta = OrquetadorOtpJwtModel.fromJson(map);
            if(_datosConsulta != null){
              return _datosConsulta;
            } else{
              return null;
            }
          } else if(_response.statusCode == 401){
            print("StatusCode 401");
            return null;
          } else if(_response.statusCode == 404){
            print("StatusCode 404");
            return null;
          } else {
            print("StatusCode");
            return null;
          }
        } else{
          print("Body null");
          return null;
        }
      } else {
        print("response null");
        return null;
      }
    }on TimeoutException{
      //TODO time out test
      print("orquestadorOTPServicio -- TimeOut");
      //ErrorLoginMessageModel().serviceErrorAlert("TimeOut");
      return null;
    } catch (e) {
      print("orquestadorOTPServicio catch -- $e");
      return null;
    }
  } else {
    //errorConexion = true;
    return null;
  }
}







