import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/Functions/Database.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:url_launcher/url_launcher.dart';

AppConfig _appEnvironmentConfig;
SharedPreferences _sharedPreferences;

Future<LoginDatosModel> logInServices(BuildContext context, String user, String password,String emailApp) async {
  print("== Log In ==");
  config=AppConfig.of(context);
  prefs=await SharedPreferences.getInstance();
  datosUsuario = await logInPost(context, user, password, emailApp);
  if(datosUsuario==null){
    return null;
  }

  Map<String, dynamic> datos = {
    'nombre': datosUsuario.givenname,
    'email': datosUsuario.mail,
    'contraseña': password,
    'savedMailApp':emailApp,
  };

  var encodeData = json.encode(datos);
  _sharedPreferences.setString('datosHuella', encodeData);

  datosPerfilador = await getPerfiladorAcceso(context, datosUsuario.idparticipante);
  if(datosPerfilador == null){
    return null;
  }

  currentCuaGNP = datosPerfilador.intermediarios[0];
  currentCuaLogros = datosPerfilador.intermediarios[0];
  currentCuaDesignaciones = datosPerfilador.intermediarios[0];

  datosFisicos = await getPersonaFisica(datosUsuario.idparticipante, false);

  if(datosFisicos==null){
    bool responseImporta = await getImporta(datosUsuario.idparticipante);
    if(responseImporta){
      datosFisicos = await getPersonaFisica(datosUsuario.idparticipante, true);
      if(datosFisicos==null){
        return null;
      }
    }else{
      return null;
    }
    return null;
  }
 // getOptionalInformation();

  print("=> Log In <=");
  return datosUsuario;
}

Future<LoginDatosModel> logInPost(BuildContext context, String user, String password,String emailApp) async {

  String _service = "Login";
  String _serviceID = "S1";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  if(_connectivityStatus.available){
    http.Response _response;
    emailSession = emailApp;
    _appEnvironmentConfig = AppConfig.of(context);
    _sharedPreferences = await SharedPreferences.getInstance();
    Map _loginRawData = {
      "mail": user,
      "password": password,
      "projectid": "gnp-appagentes-qa",
      "tipousuario": "intermediarios"
    };
    String _loginJSONData = json.encode(_loginRawData);
    try {
      _response = await http.post(_appEnvironmentConfig.serviceLogin,
          body: _loginJSONData,
          headers: {"Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 10));
      print("end post");
      if (_response != null) {
        if (_response.body != null && _response.body.isNotEmpty) {
          if (_response.statusCode == 200) {
            Map map2 = json.decode(_response.body);
            loginData = LoginModel.fromJson(map2);
            List<String> jwt = loginData.jwt.split(".");
            var response64 = base64Decode(base64.normalize(jwt[1], 0, jwt[1].length));
            var responseLatin = latin1.decode(response64);
            Map map3 = json.decode(responseLatin.toString());
            LoginDatosModel _datosUsuario = LoginDatosModel.fromJson(map3["claims"]);
            _datosUsuario.emaillogin = emailApp;
            print("emaillogin: ${_datosUsuario.emaillogin} emailApp: $emailApp 4${_datosUsuario.mail}");
            idParticipanteMoral = _datosUsuario.idparticipante;
            String emailSesion;
            try{
              Map huella = json.decode(_sharedPreferences.getString('datosHuella'));
              emailSesion = huella["savedMailApp"];
            }catch(e){
              print(e);
              print("catch:datosHuella");
              emailSesion = _datosUsuario.emaillogin;
            }
            if(emailSesion==_datosUsuario.emaillogin){
              _datosUsuario.iscurrentUser = false;
            }else{
              _datosUsuario.iscurrentUser = true;
            }
            print("emailSesion: $emailSesion datos: ${_datosUsuario.emaillogin} ");
            print("emailSesion: ${_datosUsuario.iscurrentUser} ");
            return _datosUsuario;
          }else if (_response.statusCode == 401) {
            ErrorLoginMessageModel().passErrorAlert();
            writeLoginBinnacle(user, "${_appEnvironmentConfig.serviceLogin}", LogErrorType.userError, ErrorLoginMessageModel().passwordErrorTextAlert);
            return null;
          }else if (_response.statusCode == 404) {
            ErrorLoginMessageModel().userErrorAlert();
            writeLoginBinnacle(user, "${_appEnvironmentConfig.serviceLogin}", LogErrorType.userError, ErrorLoginMessageModel().userErrorTextAlert);
            return null;
          }else {
            throw Exception(ErrorLoginMessageModel().statusErrorTextException);
          }
        } else {
          throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
        }
      }else{
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
      }
    } on TimeoutException catch (e) {
      print(e);
      ErrorLoginMessageModel().connectionErrorAlert();
      return null;
    }catch (e) {
      writeLoginBinnacle(user,
          "${_appEnvironmentConfig.serviceLogin}",
          LogErrorType.serviceError,
          _response!= null?"(${_response.statusCode}) ${_response.body}":"null");
      ErrorLoginMessageModel().serviceErrorAlert("$_serviceID - ${_response!=null?_response.statusCode:"null"}");
      print("==$e==\n$_serviceID - ${_response!=null?_response.statusCode:"null"}\n=>$e<=");
      return null;
    }
  }else{
    ErrorLoginMessageModel().connectionErrorAlert();
    return null;
  }
}

Future<PerfiladorModel> getPerfiladorAcceso(BuildContext context, String idParticipante) async {

  String _service = "Perfilador";
  String _serviceID = "S2";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  if(_connectivityStatus.available){
    _appEnvironmentConfig = AppConfig.of(context);
    _sharedPreferences = await SharedPreferences.getInstance();
    http.Response _response;
    try {
      _response = await http.get(_appEnvironmentConfig.service_perfilador+'?idInteresado='+idParticipante, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes});
      if (_response != null) {
        if (_response.statusCode == 200) {
          if (_response.body != null) {
            mapPerfilador = json.decode(_response.body);
            PerfiladorModel _datosPerfilador = PerfiladorModel.fromJson(mapPerfilador);
            if (_datosPerfilador.agenteInteresadoList.isNotEmpty ||
                _datosPerfilador.daList.isNotEmpty ||
                _datosPerfilador.intermediarios.isNotEmpty) {
              for (var list in _datosPerfilador.agenteInteresadoList) {
                String moral = list.cveTipoInteres;
                if (moral == "INF") {
                  idParticipanteMoral = list.idAgente;
                } else if (moral == "INT") {
                  idParticipanteMoral = list.idAgente;
                }
              }
              return _datosPerfilador;
            } else {
              throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
            }
          }else {
            throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
          }
        } else {
          throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        }
      } else {
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
      }
    }catch (e) {
      writeLoginBinnacle(datosUsuario.idparticipante,
          "${_appEnvironmentConfig.service_perfilador}",
          LogErrorType.serviceError,
          _response!= null?"(${_response.statusCode}) ${_response.body}":"null"
      );
      ErrorLoginMessageModel().serviceErrorAlert("$_serviceID - ${_response!=null?_response.statusCode:"null"}");
      print("==$e==\n$_serviceID - ${_response!=null?_response.statusCode:"null"}\n=>$e<=");
      return null;
    }
  } else{
    ErrorLoginMessageModel().connectionErrorAlert();
    return null;
  }
}

Future<DatosFisicosModel> getPersonaFisica(String idParticipante, bool isImport) async {

  String _service = isImport? "Persona fisica import":"Persona fisica";
  String _serviceID = isImport? "S5": "S3";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  if(_connectivityStatus.available){
    http.Response _response;
    try {
      _response = await http.get(_appEnvironmentConfig.serviceBCA+'/app/datos-perfil/'+idParticipante, headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA});
      print(_appEnvironmentConfig.serviceBCA + '/app/datos-perfil/' + idParticipante);
      if(_response!=null) {
        if (_response.statusCode == 200) {
          if (_response.body != null && _response.body.isNotEmpty) {
            Map mapAgentes = json.decode(_response.body);
            if (mapAgentes != null && mapAgentes.isNotEmpty) {
              if (mapAgentes["success"] == false) {
                throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
              } else {
                datosFisicos = DatosFisicosModel.fromJson(mapAgentes);
                return datosFisicos;
              }
            } else {
              throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
            }
          } else {
            throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
          }
        } else {
          throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        }
      }else{
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
      }
    }catch (e) {
      writeLoginBinnacle(datosUsuario.idparticipante,
          "${_appEnvironmentConfig.serviceBCA}/app/datos-perfil/",
          LogErrorType.serviceError,
          _response!= null?"(${_response.statusCode}) ${_response.body}":"null"
      );
      ErrorLoginMessageModel().serviceErrorAlert("$_serviceID - ${_response!=null?_response.statusCode:"null"}");
      print("==$e==\n$_serviceID - ${_response!=null?_response.statusCode:"null"}\n=>$e<=");
      return null;
    }
  }else{
  ErrorLoginMessageModel().connectionErrorAlert();
  return null;
  }
}

Future<bool> getImporta(String idParticipante) async {

  String _service = "Importar Persona Fisica";
  String _serviceID = "S4";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  if(_connectivityStatus.available){
    http.Response _response;
    try {
      final response = await http.post(
          _appEnvironmentConfig.serviceBCA + '/app/importa-persona-bup-bca/' + idParticipante,
          headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA});
      if(response!=null) {
        Map mapAgentes = json.decode(response.body.toString());
        if (mapAgentes != null && mapAgentes.isNotEmpty) {
          if (mapAgentes.containsKey("success")&&mapAgentes["success"] == true) {
            return true;
          } else {
            throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
          }
        } else {
          throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
        }
      }else{
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
      }
    }catch (e) {
      writeLoginBinnacle(datosUsuario.idparticipante,
          "${_appEnvironmentConfig.serviceBCA}app/importa-persona-bup-bca/",
          LogErrorType.serviceError,
          _response!= null?"(${_response.statusCode}) ${_response.body}":"null"
      );
      ErrorLoginMessageModel().serviceErrorAlert("$_serviceID - ${_response!=null?_response.statusCode:"null"}");
      print("==$e==\n$_serviceID - ${_response!=null?_response.statusCode:"null"}\n=>$e<=");
      return null;
    }
  }else{
    ErrorLoginMessageModel().connectionErrorAlert();
    return null;
  }
}


Future<void> getOptionalInformation() async {
  getTotalClientesPolisas();
}

Future<bool> getAviso(String idParticipante) async {
  String _service = "Aviso de Privacidad";
  print("Getting $_service");
  bool _showAdvice = false;
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  http.Response response;
  if(_connectivityStatus.available){
    try {
       response = await http.get("${_appEnvironmentConfig.serviceBCA}/app/privacidad/$idParticipante",
          headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA});
      if(response!=null&&response.statusCode == 200&&response.body!= null){
        Map mapAgentes = json.decode(response.body);
        if (mapAgentes['consentimiento'] == null){
          return true;
        }
      }else{
        throw Exception("Error: $_service");
      }
    } catch (e) {
      writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.serviceBCA}/app/privacidad/", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
    }
  }
  return _showAdvice;
}

Future<List> getTotalClientesPolisas() async {

  print("getTotalClientesPolizas");
  Completer<List> completer = new Completer<List>();
  List testCuas = datosPerfilador.intermediarios;
  List<String> listMapCuas = [];
  for (var i in testCuas) {
    Map cuaItem = {"codIntermediario": "$i"};
    String jsonCuaItem = json.encode(cuaItem);
    listMapCuas.add(jsonCuaItem);
  }
  Map mapPost = {"intermediarios": "$listMapCuas"};
  String jsonBodyString = json.encode(mapPost);
  jsonBodyString = jsonBodyString.replaceAll("\"[", "[");
  jsonBodyString = jsonBodyString.replaceAll("]\"", "]");
  jsonBodyString = jsonBodyString.replaceAll("\\", "");
  try {
    print("getTotalClientesPolizas: ${_appEnvironmentConfig.serviceConteoPolizas} ${jsonBodyString}");

    final responsePolizas = await http.post(_appEnvironmentConfig.serviceConteoPolizas,
        headers: {"apiKey": _appEnvironmentConfig.apikeyAppAgentes, "Content-Type": "application/json"},
        body: "$jsonBodyString");


    if (responsePolizas != null) {
      if (responsePolizas.statusCode != 200) {
        throw new Exception('Error obteniento numero de polizas');
      }
    }
    final responseClientes = await http.post(_appEnvironmentConfig.serviceConteoClientes,
        headers: {"apiKey": _appEnvironmentConfig.apikeyAppAgentes, "Content-Type": "application/json"},
        body: "$jsonBodyString");
    if (responseClientes != null) {
      if (responseClientes.statusCode != 200) {
        throw new Exception('Error obteniento numero de clientes');
      }
    }

    print("getTotalClientesPolizas: ${responseClientes.body}");

    Map dataClientes = json.decode(responseClientes.body);
    Map dataPolizas = json.decode(responsePolizas.body);
    Map dataCientesPolizas = {};
    dataCientesPolizas.addAll(dataClientes);
    dataCientesPolizas.addAll(dataPolizas);
    var encodeData = json.encode(dataCientesPolizas);
    _sharedPreferences.setString("totalCientesPolizas", encodeData);
  } catch (e) {
    print("error getTotalPolisas: $e");
  }
  return completer.future;
}

Future<bool> updateCorreo(String email) async {
  Map body = {"idParticipante": "${datosUsuario.idparticipante}",
    "codFiliacion": datosFisicosContacto.codFiliacion,
    "tipoMedioContacto": "MAIL",
    "propositosContacto": [
      {
        "id": "CAA",
        "operacion": "AL"
      }
    ] ,
    "correo": {
      "correo": "$email"
    },
    "banPrincipal": "true",
    "usuarioAudit": "CRM_PRUEBAS"
  };
  String jsonString = json.encode(body);
//  print("response.body : ${jsonString}");
  try {

    final response = await http.post(_appEnvironmentConfig.urlNotifierService+"/crm-personas/alta-medios-contacto-evo", body: jsonString, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes,"Content-Type":"application/json"});

    // print("requset EMAIL => "+config.urlNotifierService+"/crm-personas/alta-medios-contacto-evo");
    //   print("body EMAIL => "+jsonString);
    //  print(response.body);
    if(response!=null){

      if(response.statusCode==200){
        if(response.body != null && response.body.isNotEmpty) {

          print("response.body : ${response.body}");
          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Datos actualizados.",
            'success': true
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return true;
        }else{
          throw Exception('Failed to load post code ');

        }
      }else{
        throw Exception('Failed to load post code ');

      }
    }else{
      throw Exception('Failed to load post code ');

    }

  }catch(e){
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;

  }
}

Future<bool> updateMovil(String movil, String lada) async {

  print("updateMovil");
  Map body = {
    "idParticipante": "${datosUsuario.idparticipante}",
    "codFiliacion": datosFisicosContacto.codFiliacion,
    "tipoMedioContacto": "TLCL",
    "propositosContacto": [
      {
        "id": "CAA",
        "operacion": "AL"
      }
    ],
    "telefono": {
      "lada": "$lada",
      "ladaInternacional": "52",
      "numExtension": "",
      "numTelefono": "$movil"
    },
    "banPrincipal": "true",
    "usuarioAudit": "CRM_PRUEBA"
  };
  String jsonString = json.encode(body);
  //print("response.body : ${jsonString}");
  try {

    final response = await http.post(_appEnvironmentConfig.urlNotifierService+"/crm-personas/alta-medios-contacto-evo", body: jsonString, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes,"Content-Type":"application/json"});

    //print("request MOVIL => " +config.urlNotifierService+"/crm-personas/alta-medios-contacto-evo");
    // print("body MOVIL => "+jsonString);
    if(response!=null){
      if(response.statusCode==200){
        if(response.body != null && response.body.isNotEmpty) {
          print("response.body : ${response.body}");
          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Datos actualizados.",
            'success': true
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return true;
        }else{
          throw Exception('Failed to load post response');
        }
      }else{
        throw Exception('Failed to load post response');
      }
    }else{
      throw Exception('Failed to load post response');
    }
  }catch(e){
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;

  }
}

Future<bool> updateFijo(String fijo, String lada) async {
  Map body = {
    "idParticipante": "${datosUsuario.idparticipante}",
    "codFiliacion": datosFisicosContacto.codFiliacion,
    "tipoMedioContacto": "TLPT",
    "propositosContacto": [
      {
        "id": "CAA",
        "operacion": "AL"
      }
    ],
    "telefono": {
      "lada": "$lada",
      "ladaInternacional": "52",
      "numExtension": "",
      "numTelefono": "$fijo"
    },
    "banPrincipal": "true",
    "usuarioAudit": "CRM_PRUEBA"
  };
  String jsonString = json.encode(body);
  //print("response.body : ${jsonString}");
  try {

    final response = await http.post(_appEnvironmentConfig.urlNotifierService+"/crm-personas/alta-medios-contacto-evo", body: jsonString, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes,"Content-Type":"application/json"});

    //   print("request FIJO => "+config.urlNotifierService+"/crm-personas/alta-medios-contacto-evo");
    // print("body FIJO => "+jsonString);
    if(response!=null){
      if(response.statusCode==200){
        if(response.body != null && response.body.isNotEmpty) {

          print("response.body : ${response.body}");
          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Datos actualizados.",
            'success': true
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);

          return true;
        }else{
          //  print('Failed to load post FIJO1 code ' + response.statusCode.toString());
          //print('response ' + response.body.toString());
          return false;
        }
      }else{
        throw Exception('Failed to load post response');
      }
    }else{
      throw Exception('Failed to load post response');
    }

  }catch(e){
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;
  }
}

Future<bool> fetchFotoDelete(BuildContext context) async {
  print("fetchFotoDelete");

  _appEnvironmentConfig = AppConfig.of(context);
  Navigator.of(context).pop();

  try {

    final responsePost = await http
        .delete(_appEnvironmentConfig.serviceBCA + "/app/foto/${datosUsuario.idparticipante}", headers: {
      "x-api-key": _appEnvironmentConfig.apikeyBCA,
      "Content-Type": "application/json"
    });

    //  print("response : ${config.serviceBCA}+/app/foto/${datosUsuario.idparticipante}");
    if (responsePost != null) {
      //   print("response : ${responsePost.body}");
      if (responsePost.statusCode == 200) {
        Map postMap = json.decode(responsePost.body);
        //   print("response : ${postMap}");
        if (postMap['success'] == true) {
          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Edición de fotografía",
            'success': false
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          datosFisicos.personales.foto = null;
          return true;
        } else {
          throw Exception('Failed to load post response');
        }
      } else {
        throw Exception('Failed to load post response');
      }
    } else {
      throw Exception('Failed to load post response');
    }
  } catch (e) {

    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar eliminar tu fotografía, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;
  }

}

Future<String> fetchFoto(BuildContext context, File url) async {
  print("fetchFoto");
  _appEnvironmentConfig = AppConfig.of(context);
  final Trace pfmFotografia = FirebasePerformance.instance.newTrace("EdicionFoto");
  pfmFotografia.start();

  try {
    var postUri = Uri.parse(_appEnvironmentConfig.serviceBCA + "/app/foto/${datosUsuario.idparticipante}");
    var responsePost = new http.MultipartRequest("POST", postUri);
    responsePost.headers['x-api-key'] = _appEnvironmentConfig.apikeyBCA;
    responsePost.files.add(await http.MultipartFile.fromPath('file', url.path));

    // print("postUri : $postUri");

    responsePost.send().then((responseDataPost) {
      if (responseDataPost!=null && responseDataPost.statusCode == 200) {
        responseDataPost.stream.transform(utf8.decoder).listen((value) {
          pfmFotografia.stop();

          Map postMap = json.decode(value);
          //  print("response : $postMap");
          if (postMap["success"] == true) {
            var mensaje = {
              'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
              'titulo': "Edición de fotografía",
              'success': false
            };
            // print("${postMap["url"]}");
            mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
            datosFisicos.personales.foto = postMap["url"];
            return postMap["url"];
          } else {
            throw Exception('Failed to load post response');
          }
        }, onError: (error) {
          throw Exception('Failed to load post response');

        } );
      } else {
        throw Exception('Failed to load post response');
      }
    }).catchError((error) => throw Exception('Failed to load post response'));
  } catch (e) {
    pfmFotografia.stop();
    return null;
  }

}

Future<bool> updateDomicilio(Map info) async {
  print("updateDomicilio");
  String bodyString = json.encode(info);
  print(bodyString);
  try {
    final response = await http.post(_appEnvironmentConfig.urlNotifierService+'/crm-personas/alta-domicilios-evo', body: bodyString, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes, "Content-Type":"application/json"});
//    print(response.body);
    //  print(response.headers);
    //print(response.statusCode);
    if (response != null) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Datos actualizados.",
            'success': true
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return true;
        } else {
          var mensaje;
          bool status = await internetStatus();
          if(status){
            mensaje = {
              'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
              'titulo': "",
              'success': false
            };
          }else{
            mensaje = {
              'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
              'titulo': "Error de conexión.",
              'success': false
            };
          }
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return false;
        }

      } else {
        throw Exception('Failed to load post response');
      }
    } else {
      throw Exception('Failed to load post response');
    }

  } catch (e) {
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;
  }


}

Future<bool> getRol(String cua) async {
  print("rol:");
  try {
    final response = await http.get(_appEnvironmentConfig.serviceBCA+'/consulta-bonos/tipo-rol/'+cua, headers: {"x-api-key": _appEnvironmentConfig.apikeyBCABonos});
    // print(config.serviceBCA+'/consulta-bonos/tipo-rol/'+cua);
    // print(config.apikeyBCABonos);
    //  print(response.headers);
    //print(response.statusCode);

    if (response != null) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          print("rol:bonos");
          print(response.body);
          Map result = json.decode(response.body);

          if(result!=null && result['data']!= null && result['data']['rol']!= null) {
            rolCua = '${result['data']['rol']}';
            zonaBono = '${result['data']['zona']}';
          }

          var mensaje = {
            'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
            'titulo': "Datos actualizados.",
            'success': true
          };
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return true;
        } else {
          var mensaje;
          bool status = await internetStatus();
          if(status){
            mensaje = {
              'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
              'titulo': "",
              'success': false
            };
          }else{
            mensaje = {
              'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
              'titulo': "Error de conexión.",
              'success': false
            };
          }
          mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
          return false;
        }

      } else {
        throw Exception('Failed to load post response');
      }
    } else {
      throw Exception('Failed to load post response');
    }

  } catch (e) {
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    }else{
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return false;
  }


}

Future<http.Response> getVersionApp(String idApp,String idOs, BuildContext context) async {
  final response = await http.get('http://app.gnp.com.mx/versionapp/'+ idApp + "/" + idOs);
  try {
    Map mapVersion = json.decode(response.body.toString());
    String version = mapVersion["version"];
    version = version.replaceAll("_", ".");
    bool validacion = validateExpiration(mapVersion["fecha_publicacion"]);
    if(compareVersion(version,Theme.StringsMX.appVersion)&& validacion && _appEnvironmentConfig.ambient==Ambient.prod){
      if(!mapVersion['requerida']) {
        _showDialogoUpdateApplication(context);
      }else{
        _showDialogoUpdateApplicationRequried(context);
      }
    }
  }catch(e) {
    print("Error Version: $e");
  }
  return response;
}

bool compareVersion(String store, String device){
  bool _upgrade=false;
  if(int.parse(store.substring(0,store.indexOf(".")))<=int.parse(device.substring(0,device.indexOf(".")))){
    if(int.parse(store.substring(0,store.indexOf(".")))<int.parse(device.substring(0,device.indexOf(".")))){
      return false;
    }
    if(int.parse(store.substring(store.indexOf(".")+1,store.lastIndexOf(".")))<=int.parse(device.substring(device.indexOf(".")+1,device.lastIndexOf(".")))){
      if(int.parse(store.substring(store.indexOf(".")+1,store.lastIndexOf(".")))<int.parse(device.substring(device.indexOf(".")+1,device.lastIndexOf(".")))){
        return false;
      }
      if(int.parse(store.substring(store.lastIndexOf(".")+1))<=int.parse(device.substring(device.lastIndexOf(".")+1))){
        if(int.parse(store.substring(store.lastIndexOf(".")+1))<int.parse(device.substring(device.lastIndexOf(".")+1))){
          return false;
        }
      }else {_upgrade=true;}
    }else {_upgrade=true;}
  }else {_upgrade=true;}
  return _upgrade;
}

validateExpiration(String date){
  DateTime todayDate = DateTime.parse(date).add(Duration(hours: 6));
  DateTime now = new DateTime.now().toUtc();
  try {
    return now.isAfter(todayDate);
  }catch (e){
    return false;
  }
}

void _showDialogoUpdateApplicationRequried(BuildContext context) {
  print("forzada");
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child:AlertDialog(
            title: new Text("Nueva versión", style: TextStyle(
                color: Theme.Colors.Blue,
                fontSize: 16.0,
                fontFamily: "Roboto")),
            content: new Text("Existe una nueva versión de Agentes GNP.",  style: TextStyle(
                color: Theme.Colors.Blue,
                fontSize: 16.0,
                fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Descargar"),
                onPressed: _launchURL,
              ),
            ],
          )
      );
    },
  );
}

void _showDialogoUpdateApplication(BuildContext context) {
  print("update");
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child:AlertDialog(
            title: new Text("Nueva versión", style: TextStyle(
                color: Theme.Colors.Blue,
                fontSize: 16.0,
                fontFamily: "Roboto")),
            content: new Text("Existe una nueva versión de Agentes GNP.",  style: TextStyle(
                color: Theme.Colors.Blue,
                fontSize: 16.0,
                fontFamily: "Roboto")),
            actions: <Widget>[

              new FlatButton(
                  child: new Text("Después"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }),

              new FlatButton(
                child: new Text("Descargar"),
                onPressed: _launchURL,
              ),

            ],
          ));
    },
  );
}

_launchURL() async {

  String url ='https://app.gnp.com.mx/';
  if (await canLaunch(url)) {
    SystemNavigator.pop();
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}