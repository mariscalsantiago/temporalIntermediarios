import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:agentesgnp/Controllers/PagoEnLineaControllers.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/Functions/Database.dart';
import 'package:cotizador_agente/Functions/Validate.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';

AppConfig _appEnvironmentConfig;
SharedPreferences _sharedPreferences;
DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();

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

  /*datosMorales = await getPersonaMoral(datosPerfilador.intermediarios[0], 0);
  if(datosMorales==null){
    return null;
  }*/

  getOptionalInformation();

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

Future<DatosMoralesModel> getPersonaMoral(String codigoIntermediario, int value) async {
  String fechaYearFirebase = "2019";
  String _service = "Persona Moral";
  String _serviceID = "S6";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus(false);
  if(_connectivityStatus.available){

    http.Response _response;
    await _dataBaseReference.child("AnioLogros").once().then((DataSnapshot snapshot) {
      fechaYearFirebase = validateNotEmptyToString(snapshot.value, "");
    });
    DateTime fecha = DateTime.now();
    var fechaYear = fecha.year-1;
    try {
      _response = await http.get(
          _appEnvironmentConfig.serviceBCA + '/app/datos-intermediario/'+codigoIntermediario+"?anio=$fechaYear",
          headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA});
      print(_appEnvironmentConfig.serviceBCA + '/app/datos-intermediario/' + codigoIntermediario+"?anio=$fechaYear");

      if (_response != null) {
        if (_response.statusCode == 200) {
          if (_response.body != null) {
            Map mapIntermediario = json.decode(_response.body);
            if (mapIntermediario != null) {
              if (mapIntermediario["success"] == false) {
                return null;
              } else {
                switch(value){
                  case 0:
                    datosMorales = DatosMoralesModel.fromJson(mapIntermediario);
                    getPersonaMoralLogros(codigoIntermediario, fechaYearFirebase);
                    break;
                  case 1:
                    getPersonaMoralLogros(codigoIntermediario,fechaYearFirebase);
                    break;
                  case 2:
                    datosMorales.designaciones = new DatosMoralesDesignacionesModel.fromJson(mapIntermediario['designaciones']);
                    break;
                  case 3:
                    datosMorales.datosIntermediario = new DatosMoralesIntermediarioModel.fromJson(mapIntermediario['datosIntermediario']);
                    break;
                  default:
                    datosMorales = DatosMoralesModel.fromJson(mapIntermediario);
                    break;
                }
                return datosMorales;
              }
            }else{
              throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
            }
          }else{
            throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
          }
        }else{
          throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        }
      }else{
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
      }
    } catch (e) {
      writeLoginBinnacle(datosUsuario.idparticipante,
          "${_appEnvironmentConfig.serviceBCA}/app/datos-intermediario/",
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
  Map mediosDireccion = await getMediosDireccion();
  Map mediosContacto = await getMediosContacto();
  datosFisicosContacto = implementacionMediosContacto(mediosDireccion, mediosContacto);
 // getCarrusel();
  getTotalClientesPolisas();
  getHomeBody();
  //getUrlPAI();
 // getFolderGuidesContent();
  getDivisas();
  //getRecibosExigibles();
}

DatosFisicosMediosContactoModel implementacionMediosContacto(Map mediosDireccion, Map mediosContacto){

  print("implementacionMediosContacto");
  String codigoFiliacion;
  String datosContactoMediosTelefono;
  String datosContactoMediosTelefonoMovil;
  String datosContactoMediosTelefonoLada;
  String datosContactoMediosTelefonoMovilLada;
  String datosContactoMediosEmail;
  String datosContactoMediosDireccionF;
  DomicilioParticularModel datosContactoMediosDireccionP;
//print("mediosContacto:contactoMedios");
  // print(mediosContacto);


  if(mediosContacto!=null && mediosContacto.isNotEmpty) {
    if (mediosContacto.containsKey("codigoFiliacion") &&
        mediosContacto["codigoFiliacion"] != null &&
        mediosContacto["codigoFiliacion"].isNotEmpty &&
        mediosContacto["codigoFiliacion"] != "") {
      codigoFiliacion = mediosContacto["codigoFiliacion"];
    }

    if (mediosContacto.containsKey("mediosContacto")) {
      Map contactoMedios = mediosContacto['mediosContacto'];
      if (contactoMedios != null && contactoMedios.isNotEmpty) {
        if (contactoMedios.containsKey("telefonos") &&
            contactoMedios["telefonos"] != null
            && contactoMedios["telefonos"].isNotEmpty) {
          //  print("5to if");
          contactoMedios["telefonos"].forEach((x) {
            //  print("5to if $x");
            //print(x["propositosContacto"]);
            if (x.containsKey("propositosContacto") &&
                x["propositosContacto"] != null) {
              //  print("6to if $x");
              x["propositosContacto"].forEach((y) {
                //  print("67to if y: $y");
                if (y["id"] == "CAA" && x["tipoContacto"]["id"] == "TLPT") {
                  //  print("propositosContacto::x");
                  //print(x);
                  datosContactoMediosTelefono = x["valor"];
                  datosContactoMediosTelefonoLada = x["lada"];
                }
              });
            }
          });

          if (datosContactoMediosTelefono == null) {
            contactoMedios["telefonos"].forEach((x) {
              if (x["banConexionAgente"] == true &&
                  x["tipoContacto"]["id"] == "TLPT") {
                //print("propositosContacto::x");
                // print(x);
                datosContactoMediosTelefono = x["valor"];

              }
            });
          }

          if (datosContactoMediosTelefonoLada == null) {
            contactoMedios["telefonos"].forEach((x) {
              if (x["banConexionAgente"] == true &&
                  x["tipoContacto"]["id"] == "TLPT") {
                //  print("propositosContacto::x");
                //print(x);
                datosContactoMediosTelefonoLada = x["lada"];
              }
            });
          }
          contactoMedios["telefonos"].forEach((x) {
            if (x.containsKey("propositosContacto") &&
                x["propositosContacto"] != null) {
              x["propositosContacto"].forEach((y) {
                if (y["id"] == "CAA" && x["tipoContacto"]["id"] == "TLCL") {
                  //   print("datosContactoMediosTelefonoMovil::x");
                  // print(x);
                  datosContactoMediosTelefonoMovil = x["valor"];
                  datosContactoMediosTelefonoMovilLada = x["lada"];
                }
              });
            }
          });

          if (datosContactoMediosTelefonoMovil == null) {
            contactoMedios["telefonos"].forEach((x) {
              if (x["banConexionAgente"] == true &&
                  x["tipoContacto"]["id"] == "TLCL") {
                //   print("datosContactoMediosTelefonoMovil::x");
                // print(x);
                datosContactoMediosTelefonoMovil = x["valor"];
              }
            });
          }
          if (datosContactoMediosTelefonoMovilLada == null) {
            contactoMedios["telefonos"].forEach((x) {
              if (x["banConexionAgente"] == true &&
                  x["tipoContacto"]["id"] == "TLCL") {
                //  print("datosContactoMediosTelefonoMovil::x");
                //print(x);
                datosContactoMediosTelefonoMovilLada = x["lada"];
              }
            });
          }
        }
        if (contactoMedios.containsKey("correos") &&
            contactoMedios["correos"] != null &&
            contactoMedios["correos"].isNotEmpty) {
          contactoMedios["correos"].forEach((x) {
            if (x.containsKey("propositosContacto") &&
                x["propositosContacto"] != null) {
              x["propositosContacto"].forEach((y) {
                if (y["id"] == "CAA") {
                  datosContactoMediosEmail = x["valor"];
                }
              });
            }
          });

          if (datosContactoMediosEmail == null) {
            contactoMedios["correos"].forEach((x) {
              if (x["banConexionAgente"] == true) {
                datosContactoMediosEmail = x["valor"];
              }
            });
          }
        }
      }
    }
  }
  if (mediosDireccion != null && mediosDireccion.isNotEmpty) {
    if (mediosDireccion.containsKey("codigoFiliacion") &&
        mediosDireccion["codigoFiliacion"] != null &&
        mediosDireccion["codigoFiliacion"].isNotEmpty &&
        mediosDireccion["codigoFiliacion"] != "") {
      codigoFiliacion = mediosDireccion["codigoFiliacion"];
    }

    if (mediosDireccion.containsKey("domicilios")) {
      //    print(mediosDireccion);
      List contactoDireccion = mediosDireccion['domicilios'];

      // print("contactoDireccion: $contactoDireccion");
      if (contactoDireccion != null &&
          contactoDireccion.isNotEmpty) {


        contactoDireccion.forEach((x) {
          if (x.containsKey("propositosContacto") &&
              x["propositosContacto"] != null) {
            x["propositosContacto"].forEach((y) {

              if (y["id"] == "CAA" && x["tipoDomicilio"]["id"] == "FI") {

                var calle = "";
                var num = "";
                var municipio = "";
                var cp = "";
                var colonia = "";
                var estado = "";
                var pais = "";

                if (x["calle"] != null) {
                  calle = x["calle"];
                }
                if (x["numExt"] != null) {
                  num = "${x["numExt"]}";
                }
                if (x["municipioDelegacion"] != null && x["municipioDelegacion"]["descripcion"]!=null) {
                  municipio = "${x["municipioDelegacion"]["descripcion"]},";
                }
                if (x["codPostal"] != null && x["codPostal"]["id"]!=null) {
                  cp = "${x["codPostal"]["id"]}";
                }
                if (x["colonia"] != null && x["colonia"]["descripcion"]!=null) {
                  colonia = "${x["colonia"]["descripcion"]}";
                }
                if (x["pais"] != null&&x["pais"]["descripcion"]!=null) {
                  pais = "${x["pais"]["descripcion"]}";
                }
                if (x["estado"] != null&&x["estado"]["descripcion"]!=null) {
                  estado = "${x["estado"]["descripcion"]}";
                }

                datosContactoMediosDireccionF =  "$calle $num $colonia $municipio $estado $cp $pais";

              }
              if (y["id"] == "CAA" && x["tipoDomicilio"]["id"] != "FI") {

                var calle = "";
                var numEx = "";
                var numIn = "";
                var municipio = "";
                var cp = "";
                var colonia = "";
                var estado = "";
                var pais = "";

                if (x["calle"] != null) {
                  calle = x["calle"];
                }
                if (x["numExt"] != null) {
                  numEx = "${x["numExt"]}";
                }
                if (x["numInt"] != null) {
                  numIn = "${x["numInt"]}";
                }
                if (x["municipioDelegacion"] != null && x["municipioDelegacion"]["descripcion"]!=null) {
                  municipio = "${x["municipioDelegacion"]["descripcion"]}";
                }
                if (x["codPostal"] != null && x["codPostal"]["id"]!=null) {
                  cp = "${x["codPostal"]["id"]}";
                }
                if (x["colonia"] != null && x["colonia"]["descripcion"]!=null) {
                  colonia = "${x["colonia"]["descripcion"]}";
                }
                if (x["pais"] != null&&x["pais"]["descripcion"]!=null) {
                  pais = "${x["pais"]["descripcion"]}";
                }
                if (x["estado"] != null&&x["estado"]["descripcion"]!=null) {
                  estado = "${x["estado"]["descripcion"]}";
                }
                datosContactoMediosDireccionP = DomicilioParticularModel(calle: calle,municipio: municipio,numeroEx: numEx,numeroIn: numIn, pais: pais, estado: estado,colonia: colonia, codigoPostal: cp, direccionCompleta:"$calle , $numIn ,$numEx , $colonia , $municipio , $estado , $cp , $pais");
              }
            });
          }
        });


        if (datosContactoMediosDireccionF == null) {
          // print("datosContactoMediosDireccionF:null");
          contactoDireccion.forEach((x) {
            if(x.containsKey("banConexionAgente")&& x["banConexionAgente"]!=null) {
              if (x["banConexionAgente"] == true &&
                  x["tipoDomicilio"]["id"] == "FI") {

                var calle = "";
                var num = "";
                var municipio = "";
                var cp = "";
                var colonia = "";
                var estado = "";
                var pais = "";

                if (x["calle"] != null) {
                  calle = x["calle"];
                }
                if (x["numExt"] != null) {
                  num = "${x["numExt"]}";
                }
                if (x["municipioDelegacion"] != null && x["municipioDelegacion"]["descripcion"]!=null) {
                  municipio = "${x["municipioDelegacion"]["descripcion"]},";
                }
                if (x["codPostal"] != null && x["codPostal"]["id"]!=null) {
                  cp = "${x["codPostal"]["id"]},";
                }
                if (x["colonia"] != null && x["colonia"]["descripcion"]!=null) {
                  colonia = "${x["colonia"]["descripcion"]},";
                }
                if (x["pais"] != null&&x["pais"]["descripcion"]!=null) {
                  pais = "${x["pais"]["descripcion"]}";
                }
                if (x["estado"] != null&&x["estado"]["descripcion"]!=null) {
                  estado = "${x["estado"]["descripcion"]},";
                }

                datosContactoMediosDireccionF =  "$calle $num $colonia $municipio $estado $cp $pais";

              }
            }
          });
        }
        if (datosContactoMediosDireccionP == null) {
          contactoDireccion.forEach((x) {
            if(x.containsKey("banConexionAgente")&& x["banConexionAgente"]!=null) {
              if (x["banConexionAgente"] == true &&
                  x["tipoDomicilio"]["id"] != "FI") {

                var calle = "";
                var numEx = "";
                var numIn = "";
                var municipio = "";
                var cp = "";
                var colonia = "";
                var estado = "";
                var pais = "";

                if (x["calle"] != null) {
                  calle = x["calle"];
                }
                if (x["numExt"] != null) {
                  numEx = "${x["numExt"]}";
                }
                if (x["numInt"] != null) {
                  numIn = "${x["numInt"]}";
                }
                if (x["municipioDelegacion"] != null && x["municipioDelegacion"]["descripcion"]!=null) {
                  municipio = "${x["municipioDelegacion"]["descripcion"]}";
                }
                if (x["codPostal"] != null && x["codPostal"]["id"]!=null) {
                  cp = "${x["codPostal"]["id"]}";
                }
                if (x["colonia"] != null && x["colonia"]["descripcion"]!=null) {
                  colonia = "${x["colonia"]["descripcion"]},";
                }
                if (x["pais"] != null&&x["pais"]["descripcion"]!=null) {
                  pais = "${x["pais"]["descripcion"]}";
                }
                if (x["estado"] != null&&x["estado"]["descripcion"]!=null) {
                  estado = "${x["estado"]["descripcion"]}";
                }
                datosContactoMediosDireccionP = DomicilioParticularModel(calle: calle,municipio: municipio,numeroEx: numEx,numeroIn: numIn, pais: pais, estado: estado,colonia: colonia, codigoPostal: cp, direccionCompleta:"$calle , $numIn , $numEx , $colonia , $municipio , $estado , $cp , $pais");
              }
            }
          });
        }

      }
    }
  }
  var mapMediosContacto = {"domicilioFiscal": datosContactoMediosDireccionF,
    "domicilioParticular":  datosContactoMediosDireccionP,
    "telefonoFijo": datosContactoMediosTelefono!=null && datosContactoMediosTelefonoLada!=null?"$datosContactoMediosTelefonoLada$datosContactoMediosTelefono":null,
    "telefonoMovil": datosContactoMediosTelefonoMovilLada!=null && datosContactoMediosTelefonoMovil!=null? "$datosContactoMediosTelefonoMovilLada$datosContactoMediosTelefonoMovil":null,
    "email": datosContactoMediosEmail,
    "codFiliacion": codigoFiliacion,
  };

  return DatosFisicosMediosContactoModel.fromJson(mapMediosContacto,datosContactoMediosDireccionP);

}

Future<Map> getMediosContacto() async {
  print("getMediosContacto");
  try {
    final response = await http.get(_appEnvironmentConfig.urlNotifierService+"/crm-personas/consulta-medios-contacto-agt-id?idAgente=${datosUsuario.idparticipante}", headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes});
    print(_appEnvironmentConfig.urlNotifierService+"/crm-personas/consulta-medios-contacto-agt-id?idAgente="+datosUsuario.idparticipante);
    if(response!=null) {
      Map mapResponse = json.decode(response.body.toString());
      if (mapResponse != null && mapResponse.isNotEmpty) {
        return mapResponse;
      } else {
        writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/crm-personas/consulta-medios-contacto-agt-id", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
        throw Exception('Failed to load post code ');
      }
    }else{
      writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/crm-personas/consulta-medios-contacto-agt-id", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
      throw Exception('Failed to load post code ');
    }
  }catch(e) {
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar recuperar tu información, intenta más tarde.",
        'titulo': "Sin acceso a la App de GNP Agentes",
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
    return null;
  }

}

Future<Map> getMediosDireccion() async {

  print("getMediosDireccion");
  try {
    final response = await http.get(_appEnvironmentConfig.urlNotifierService+"/crm-personas/consulta-direcciones-agt-id?idAgente="+datosUsuario.idparticipante, headers: {"apikey": _appEnvironmentConfig.apikeyAppAgentes});

    print(_appEnvironmentConfig.urlNotifierService+"/crm-personas/consulta-direcciones-agt-id?idAgente="+datosUsuario.idparticipante);
    //print(response.body);
    if(response!=null) {
      Map mapResponse = json.decode(response.body.toString());
      // print("mapResponse: $mapResponse");
      if (mapResponse != null && mapResponse.isNotEmpty) {
        //  print("mapResponse: $mapResponse");

        return mapResponse;
      }else{
        writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/crm-personas/consulta-direcciones-contacto-agt-id", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
        throw Exception('Failed to load post code ');
      }
    }else{
      writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/crm-personas/consulta-direcciones-contacto-agt-id", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
      throw Exception('Failed to load post code ');
    }
  }catch(e) {
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar recuperar tu información, intenta más tarde.",
        'titulo': "Sin acceso a la App de GNP Agentes",
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
    return null;
  }

}

Future<DatosMoralesModel> getPersonaMoralLogros(String codigoIntermediario, String fechaYearFirebase) async {
  print("getPersonaMoralLogros");

  try {
    final response = await http.get(
        _appEnvironmentConfig.serviceBCA + '/app/datos-intermediario/'+codigoIntermediario+"?anio=$fechaYearFirebase",
        headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA});
    print(_appEnvironmentConfig.serviceBCA + '/app/datos-intermediario/' + codigoIntermediario+"?anio=$fechaYearFirebase");
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          Map mapIntermediario = json.decode(response.body);
          if (mapIntermediario != null) {
            if (mapIntermediario["success"] == false) {
              return null;
            } else {
              print("getPersonaMoralLogros");
              print(response.body);
              var list = mapIntermediario['logros'] as List;
              datosMorales.logrosList = list.map((value) =>  new DatosMoralesLogrosModel.fromJson(value)).toList();
              return datosMorales;
            }
            //  print("datosIntermediario: ${datosMorales.datosIntermediario.cua}");
          }
        }else{
          writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.serviceBCA}/app/datos-intermediario/?anio=$fechaYearFirebase", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
          throw Exception('Failed to load post code ');
        }
      }else{
        writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.serviceBCA}/app/datos-intermediario/?anio=$fechaYearFirebase", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
        throw Exception('Failed to load post code ');
      }
    }else{
      writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.serviceBCA}/app/datos-intermediario/?anio=$fechaYearFirebase", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
      throw Exception('Failed to load post code ');
    }
  } catch (e) {
    var mensaje;
    bool status = await internetStatus();
    if(status){
      mensaje = {
        'mensaje': "Se produjo un error al intentar recuperar tu información, intenta más tarde.",
        'titulo': "Sin acceso a la App de GNP Agentes",
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
    return null;
  }
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

Future<List> getFolderGuidesContent() async {
  Completer<List> completer = new Completer<List>();
  _dataBaseReference.child("Guias").once().then((DataSnapshot snapshot) async {
    Map formatFirebase = snapshot.value;
    try {
      final response = await http.get(formatFirebase["Url"]);
      final String folder = formatFirebase["folder"];
      final Xml2Json myTransformer = Xml2Json();
      String paiContentString = response.body;
      myTransformer.parse(paiContentString);
      String jsonPAI = myTransformer.toBadgerfish();
      Map mapPAI = json.decode(jsonPAI);
      List listContent = mapPAI["ListBucketResult"]["Contents"];
      List filesTreeList = [];
      String filesTree = "{";

      for (var i in listContent) {
        String data = i["Key"]["\$"].toString();
        if(data.contains(folder)){
          if (data != null&&data.substring(folder.length).length!=0) {

            filesTreeList.add(data.substring(folder.length));

          }
        }
      }
      List ramosList = [];
      List foldersList = [];
      List iconList = [];

      for (var i in filesTreeList) {
        String dataI = i.toString();
        if (dataI.substring(dataI.indexOf("/") + 1).length == 0) {
          ramosList.add(dataI);
        }
        if (dataI.endsWith("/") ) {
          foldersList.add(dataI);
        }
        if (dataI.endsWith(".png")) {
          iconList.add(dataI);
        }
      }
      for (var i in ramosList) {
        filesTreeList.remove(i);
      }
      for (var i in foldersList) {
        filesTreeList.remove(i);
      }
      for (var i in iconList) {
        filesTreeList.remove(i);
      }

      List iconOn = [];
      List iconOff = [];

      for (var i in iconList) {
        if (i.toString().contains("Off")) {
          iconOff.add(i);
        } else {
          iconOn.add(i);
        }
      }
      iconList = iconOn;
      for (var i in ramosList) {
        foldersList.remove(i);
      }
      for (var i in ramosList) {
        String dataI = i.toString();
        String iconPad = iconList[ramosList.indexOf(i)];
        filesTree = filesTree +
            "\"" +
            dataI.substring(0, dataI.indexOf("/")) +
            "\":{" +
            "\"Icon\":\"" +
            formatFirebase["Url"] + "Apoyos/"+
            iconPad +

            "\"," +
            "\"Section\":{";
        for (var j in foldersList) {
          String dataJ = j.toString();
          if (dataJ.contains(dataI)) {
            String title = dataJ;
            if (dataJ.substring(0, dataI.length).length == 0) {
              title = "dataI";
            } else {
              for (var l in foldersList.reversed) {
                String dataL = l.toString();
                if (dataJ.contains(l) &&
                    dataJ.substring(dataL.length).length != 0) {
                  title = dataJ.substring(dataL.length);
                }
              }
            }
            filesTree = filesTree +
                "\"" +
                title.substring(0, title.indexOf("/")) +
                "\":[";
            for (var k in filesTreeList) {
              String dataK = k.toString();
              String fileName = dataK.substring(dataK.lastIndexOf("/") + 1);
              String filePad = dataK.replaceAll(fileName, "");
              String fileType =
              fileName.substring(fileName.lastIndexOf(".") + 1);
              int isFolder = dataJ.compareTo(filePad);
              if (isFolder == 0) {
                filePad = filePad + fileName;
                filesTree = filesTree +
                    "{\"Name\":\"" +
                    fileName +
                    "\",\"Type\":\"" +
                    fileType +
                    "\",\"Url\":\"" +
                    formatFirebase["Url"] + "Apoyos/"+
                    filePad +
                    "\"},";
              }
            }
            filesTree = filesTree + "],";
          }
        }
        filesTree = filesTree + "}},";
      }
      filesTree = filesTree + "}";
      String dataEncode = jsonEncode(filesTree.toString());
      dataEncode = dataEncode.replaceAll("\\", "");
      dataEncode = dataEncode.replaceAll(",]", "]");
      dataEncode = dataEncode.replaceAll(",}", "}");
      dataEncode = dataEncode.substring(1, dataEncode.length - 1);
      Map filesTreeMap = jsonDecode(dataEncode);
      var encodeData = json.encode(filesTreeMap);
      _sharedPreferences.setString("guias", encodeData);
      print("Guias Data:\n$encodeData");
    } catch (e) {
      print("error en getFolderGuidesContent: $e");
    }
  });
  return completer.future;
}

Future<List> getCarrusel() async {

  Completer<List> completer = new Completer<List>();
  _dataBaseReference = FirebaseDatabase.instance.reference();
  _dataBaseReference.child("carrusel").once().then((DataSnapshot snapshot) async {
    Map values = snapshot.value;
    Map carruselFirebase = values;
    try {
      final response = await http.get(carruselFirebase["url"]);
      final Xml2Json myTransformer = Xml2Json();
      String carrucelContentString = response.body;
      myTransformer.parse(carrucelContentString);
      String jsonCarrucel = myTransformer.toBadgerfish();
      Map mapCarrucel = json.decode(jsonCarrucel);
      List listCarrucel = mapCarrucel["ListBucketResult"]["Contents"];
      List listContent = [];
      for (var i in listCarrucel) {
        listContent.add(i["Key"]["\$"]);
      }
      var encodeDatas = json.encode({
        "url": carruselFirebase["url"],
        "total": listContent.length,
        "listContent": listContent
      });
      _sharedPreferences.setString("carrusel", encodeDatas);
    } catch (e) {
      print("error de catch carrucel: $e");
    }
  });
  return completer.future;
}

Future getHomeBody() async {

  print("getHomeBody");
  _dataBaseReference.child("Contenidos/NoticiasHome").once().then((DataSnapshot snapshot) async {
    try {
      Map values = snapshot.value;
      print("Home content values: $values");
      Map mapFireBase = values;
      var encodeData = json.encode(mapFireBase);
      _sharedPreferences.setString("bodyHome", encodeData);
      print("prefs $encodeData");
    } catch (e) {
      print("error catch bodyHome: $e");
    }
  });

}

Future<DomicilioModel> getCodigoPostal(String codigo) async {
  print("getCodigoPostal");
  var codigoPostal = {
    "consultarAnidadosCRM":{
      "arg0":[
        {
          "mapaValores":{
            "entry":[
              {
                "key":"VALOR_CODIGO_POSTAL",
                "valor":"$codigo"
              }
            ]
          },
          "nombreCatalogo":"CODIGO_POSTAL"
        }
      ]
    }
  };

  String bodyString = json.encode(codigoPostal);
  try {
    final response = await http.post(_appEnvironmentConfig.urlNotifierService+'/comunWeb/CatalogosWeb', body: bodyString, headers: {"apikey": _appEnvironmentConfig.apikeyCatalogo, "Content-Type":"application/json"});

    if (response != null) {
      if (response.statusCode == 200) {
        if (response.body != null) {
          //print("body");
          //  print(response.body);
          Map MapPaises = json.decode(response.body);

          List registroCodigo = MapPaises["consultarAnidadosCRMResponse"]["catalogos"];


          //   print("registroCodigo: $registroCodigo");

          Map addColonia = registroCodigo.firstWhere((user) => user["nombreCatalogo"] == "COLONIA", orElse: () => null);
          Map addCiudad = registroCodigo.firstWhere((user) => user["nombreCatalogo"] == "MUNICIPIO", orElse: () => null);
          Map addEstado = registroCodigo.firstWhere((user) => user["nombreCatalogo"] == "ESTADO_REPUBLICA", orElse: () => null);

          List listColonia;
          // print("dato:lista");
          //print(addColonia["listaElementos"].runtimeType);
          //print("lista:elementos:");
          //print(addColonia["listaElementos"]);
          try{


            if("${addColonia["listaElementos"].runtimeType}" == "_InternalLinkedHashMap<String, dynamic>"){
              listColonia = [addColonia["listaElementos"]];

            }else{
              listColonia = addColonia["listaElementos"];

            }}catch(e){print(e);}

          //print("lista:elementos:domicilio:listColonia");
          //print(listColonia);

          var domicilios = { "colonias": listColonia,
            "ciudad": addCiudad["listaElementos"],
            "estado": addEstado["listaElementos"]
          };


          //print("lista:elementos:domicilio:");
          // print(listColonia);


          return DomicilioModel.fromJson(domicilios);

        } else {
          var mensaje;
          bool status = await internetStatus();
          if(status){
            writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/comunWeb/CatalogosWeb", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
            mensaje = {
              'mensaje': "Se produjo un error al intentar recuperar tu información, intenta más tarde.",
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
          return null;
        }

      } else {
        writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/comunWeb/CatalogosWeb", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
        throw Exception('Failed to load post response');
      }
    } else {
      writeLoginBinnacle(datosUsuario.idparticipante, "${_appEnvironmentConfig.urlNotifierService}/comunWeb/CatalogosWeb", LogErrorType.serviceError, "(${response.statusCode}) ${response.body}");
      throw Exception('Failed to load post response');
    }

  } catch (e) {
    var mensaje;
    bool status = await internetStatus();
    if (status) {
      mensaje = {
        'mensaje': "Se produjo un error al intentar recuperar tu información, intenta más tarde.",
        'titulo': "",
        'success': false
      };
    } else {
      mensaje = {
        'mensaje': "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
        'titulo': "Error de conexión.",
        'success': false
      };
    }
    mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);
    return null;
  }

}

void getDivisas() async {
  DateTime sessionStartDate = DateTime.now();
  SharedPreferences _sharedPreferences= await SharedPreferences.getInstance();
  String _month = sessionStartDate.month.toString().length==1
      ?"0"+sessionStartDate.month.toString()
      :sessionStartDate.month.toString();
  String _day = sessionStartDate.day.toString().length==1
      ?"0"+sessionStartDate.day.toString()
      :sessionStartDate.day.toString();
  String consultDate = sessionStartDate.year.toString() + _month +_day;
  print("divisas sessionStartDate $sessionStartDate");
  print("divisas consultDate $consultDate");
  try {
    final response = await http.get("${_appEnvironmentConfig.urlTipoDeCambio}?fecha=$consultDate",
        headers: {"apikey": _appEnvironmentConfig.apiKeyTipoDeCambio});
    Map _bodyResponse = json.decode(response.body);
    List _listResponse = _bodyResponse["lista"];
    Map _bodyContent = _listResponse.elementAt(0);
    String _date = _bodyContent["fecha"].toString();
    String _change = _bodyContent["tipocamb"].toString();
    int decimals;
    decimals= _change .contains(".")?_change .substring(_change .indexOf(".")).length-1:-1;
    _change =decimals<0?_change+".0000":
    _change =decimals==0?_change +"0000":
    decimals==1?_change =_change +"000":
    decimals==2?_change =_change +"00":
    decimals==3?_change =_change +"0":
    decimals>=5?_change .substring(0,_change.indexOf(".")+5):_change;
    _date = _date+" 06:00:00.000";
    print("divisas _date $_date");
    DateTime _exchangesBMXDate = DateTime.parse(_date);
    String _encodeData = json.encode({"Fecha": _exchangesBMXDate.toString(), "Cambio": _change});
    _sharedPreferences.setString("divisas", _encodeData);
  } catch (e) {
    print("error de catch divisas: $e");
  }
}

Future<List> getUrlPAI() async {
  Completer<List> completer = new Completer<List>();
  _dataBaseReference = FirebaseDatabase.instance.reference();
  _dataBaseReference.child("PAI").once().then((DataSnapshot snapshot) async {
    Map values = snapshot.value;
    Map paiFirebase = values;
    try {
      ///Not erase this items
      /*
        final response = await http.get(paiFirebase["url"]);
        final Xml2Json myTransformer = Xml2Json();
        String paiContentString = response.body;
        myTransformer.parse(paiContentString);
        String jsonPAI = myTransformer.toBadgerfish();
        Map mapPAI = json.decode(jsonPAI);
        List listPAIContent =mapPAI["ListBucketResult"]["Contents"];
        */

      ///Not erase this items

      List listPAI = paiFirebase["Contents"];
      List listPAIContent = [];
      for (var i in listPAI) {
        if (i != null) {
          listPAIContent.add(i);
        }
      }
      List listYears = [];
      List listDocs = [];

      for (var i in listPAIContent) {
        //String dataI = i["Key"]["\$"].toString();
        String dataI = i.toString();
        if (dataI.contains(paiFirebase["pdfFolder"])) {
          dataI = dataI.substring(paiFirebase["pdfFolder"].toString().length);
          if (dataI.length > 5) {
            listDocs.add(dataI);
          } else if (dataI.length > 0) {
            listYears.add(dataI.substring(0, 4));
          }
        }
        if (dataI.contains(paiFirebase["iconFolder"])) {
          dataI =
              dataI.substring(paiFirebase["iconFolder"].toString().length);
        }
      }
      List yearData = [];
      for (var j in listYears) {
        String dataJ = j.toString();
        String yearDataString;
        yearDataString = "\"" + dataJ + "\":{";
        for (var i in listDocs) {
          String key;
          String value;
          String dataI = i.toString();
          if (dataI.contains(dataJ)) {
            key = dataI.substring(5, dataI.indexOf("."));
            value = dataI.substring(5);
            yearDataString =
                yearDataString + "\"" + key + "\":\"" + value + "\",";
          }
        }
        yearDataString = yearDataString + "}";
        yearData.add(yearDataString);
      }
      String dataNew = "{";
      for (var i in yearData) {
        dataNew = dataNew + i + ",";
      }
      dataNew = dataNew + "}";
      String dataEncode = jsonEncode(dataNew.toString());
      dataEncode = dataEncode.replaceAll("\\", "");
      dataEncode = dataEncode.replaceAll(",}", "}");
      dataEncode = dataEncode.substring(1, dataEncode.length - 1);
      Map dataYearsMap = jsonDecode(dataEncode);
      var encodeData = json.encode({
        "Anios": dataYearsMap,
        "Url": {
          "base": paiFirebase["url"],
          "pdfFolder": paiFirebase["pdfFolder"],
          "iconFolder": paiFirebase["iconFolder"] //+iconItem
        }
      });
      _sharedPreferences.setString("pai", encodeData);
    } catch (e) {
      print("error en getUrlPAI: $e");
    }
  });
  return completer.future;
}

Future<bool> updatePerfil(BuildContext context, String idParticipante, Map info) async {
  print("updatePerfil");
//  print("${info}");
  //print("${idParticipante}");
  var bodyInfo = json.encode(info);
  try {
    final response = await http.post(
        _appEnvironmentConfig.serviceBCA+'/app/actualizacion-app-agentes/'+idParticipante,
        body: bodyInfo,
        headers: {"x-api-key": _appEnvironmentConfig.apikeyBCA, "Content-Type":"application/json"});

    print(_appEnvironmentConfig.serviceBCA+'/app/actualizacion-app-agentes/'+idParticipante);
    //  print("body: $bodyInfo");

    if (response != null) {
      //  print("response: ${response.body}");
      if (response.statusCode == 200) {
        if (response.body != null) {
          Map mapIntermediario = json.decode(response.body);
          //   print(mapIntermediario);
          if (mapIntermediario != null) {
            if (mapIntermediario["success"] == false) {
              var mensaje = {
                'mensaje': "Se produjo un error al intentar guardar tu información, intenta más tarde.",
                'titulo': "",
                'success': false
              };
              mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);

              return false;
            } else {
              var mensaje = {
                'mensaje': "¡Gracias! Tus datos fueron actualizados exitosamente.",
                'titulo': "Datos actualizados.",
                'success': true
              };
              mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);

              return true;
            }
          }else{
            throw Exception('Failed to load post code ');
          }
        }else{
          throw Exception('Failed to load post code ');
        }
      }else{
        throw Exception('Failed to load post code ');
      }
    }else{
      throw Exception('Failed to load post code ');
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

Future<String> pathTemporalBucket(BuildContext context, String bucketName, String pathFile) async{
  print("pathTemporalBucket");
  print("bucketName $bucketName");
  print("pathFile $pathFile");
  var config = AppConfig.of(context);
  try{
    final response = await http.get(config.serviceBCA+"/app/obtiene-url-signed-app-agentes?filePath="+"$pathFile"+"&bucketName="+"$bucketName",
        headers: {"x-api-key": config.apikeyBCA});

    if(response != null){
      if(response.body != null && response.body.isNotEmpty){
        if(response.statusCode == 200){
          Map map2 = json.decode(response.body);
          return map2["url"];
        }
      }
    } else{
      return null;
    }
  } catch(e){
    print(e);
  }
}

/*
Future<String> base64BucketPrivado(BuildContext context,String name, String type,String bucketName, String pathFile) async{
  var config = AppConfig.of(context);
  try{
    final response = await http.get(config.bucket_Privado+"$bucketName"+"&filePath=$pathFile",headers: {"apiKey": config.apiKeybucketPrivado});
    print("response ${response.body}");
    if(response != null){
      if(response.body != null && response.body.isNotEmpty){
        if(response.statusCode == 200){
          Map map2 = json.decode(response.body);
          return map2["base64"];
        }
      }
    } else{

    }

  } catch(e){
    print("_base64toFile $e");
  }

}

*/

