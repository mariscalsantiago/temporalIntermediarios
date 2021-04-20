import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/consultarUsuarioPorCorreo.dart';
import 'package:flutter/material.dart';
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

    try {
      _response = await http.post(Uri.parse(_appEnvironmentConfig.cambioContrasenaPerfil+idIntermediario+"/cambiar"),
          body: _loginJSON,
          headers: {"Content-Type": "application/json", 'apiKey': _appEnvironmentConfig.apiKey}
      );

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
            Map map = json.decode(_response.body);
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




