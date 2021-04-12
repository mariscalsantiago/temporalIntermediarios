
import 'dart:convert';
import 'dart:io';

import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/CustomAlert_tablet.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/ConnectionManager.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/utils/Constants.dart' as Constants;
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

import '../main.dart';

  SharedPreferences _sharedPreferences;
  String uPhone;
  int errorTimes = 0;
  var temporalCVE;
  String uMail;
  String uPass;
  AppConfig _appEnvironmentConfig;
  Responsive _responsive;


  Future<LoginDatosModel> logInServices(BuildContext context, String mail, String password, String user, Responsive responsive) async {
    _responsive = responsive;
    print("== Log In Interactor==");
    //prefs=await SharedPreferences.getInstance();
    try{
    datosUsuario = await logInPost(context,mail, password, user);

    if(datosUsuario == null){
      return null;
    }
    }catch(e){
      print(e);
      throw Exception(ErrorLoginMessageModel().statusErrorTextException);
    }
    Map<String, dynamic> datos = {
      'nombre': datosUsuario.givenname,
      'email': datosUsuario.mail,
      'contraseña': password,
      'savedMailApp':mail,
    };

    var encodeData = json.encode(datos);
    _sharedPreferences.setString('datosHuella', encodeData);

    datosPerfilador = await getPerfiladorAcceso(context, datosUsuario.idparticipante);
    print("datosPerfilador ${datosPerfilador}");

    if(datosPerfilador == null){
      customAlert(AlertDialogType.errorServicio,context,"","", responsive);
      return null;
    }

    print("datosPerfilador ${datosPerfilador}");

    if(datosPerfilador.intermediarios.isNotEmpty && datosPerfilador.intermediarios.length > 0 ){
      currentCuaGNP = datosPerfilador.intermediarios[0];
      currentCuaLogros = datosPerfilador.intermediarios[0];
    } else{
      currentCuaGNP = "0";
      currentCuaLogros = "0";
    }

    print("Datos fisicos");
    datosFisicos = await getPersonaFisica(context, datosUsuario.idparticipante, false);
    print("Datos fisicos ${datosFisicos}");

    if (datosFisicos == null) {
      bool responseImporta = await getImporta(datosUsuario.idparticipante);
      if (responseImporta) {
        datosFisicos = await getPersonaFisica(context, datosUsuario.idparticipante, true);
        if (datosFisicos == null) {
          return null;
        }
      } else {
        return null;
      }
    }

    return datosUsuario;
  }

  Future<LoginDatosModel> logInPost(BuildContext context ,String emailApp, String password,String user) async {
    String _service = "Login";
    String _serviceID = "S1";
    print("Getting $_service");
    if (!await ConnectionManager.isConnected()) {
      //output.showAlert('Conexión no disponible', Constants.ALERTA_NO_CONEXION, null, null);
      if (deviceType == ScreenType.phone) {
        customAlert(AlertDialogType.errorConexion, context, "",  "", _responsive);
      }
      else{
        customAlertTablet(AlertDialogTypeTablet.errorConexion, context, "",  "", _responsive);
      }
    }
    emailSession = emailApp;
    var config = AppConfig.of(context);
    _sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "mail": user,
      "password": password,
      "projectid": config.proyectId,
      "tipousuario": "intermediarios"
    };
    var headers = {
      "Content-Type": "application/json"
    };
    String _loginJSONData = json.encode(body);

    //output?.showLoader();
    http.Response response = await http.post(config.serviceLogin,
        body: _loginJSONData,
        headers: headers).timeout(const Duration(seconds: 10));

    print("response ${response.body}");
    print("response ${response.statusCode}");
    if(response != null){
      if(response.body != null && response.body.isNotEmpty){
        if (response.statusCode == 200) {
          Map map2 = json.decode(response.body);
          //output?.hideLoader();
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
          emailSesion = _datosUsuario.emaillogin;

          if(emailSesion==_datosUsuario.emaillogin){
            _datosUsuario.iscurrentUser = false;
          }else{
            _datosUsuario.iscurrentUser = true;
          }
          print("emailSesion: $emailSesion datos: ${_datosUsuario.emaillogin} ");
          print("emailSesion: ${_datosUsuario.iscurrentUser} ");
          emailSesion = _datosUsuario.emaillogin;
          //output.showHome();
          return _datosUsuario;
        }
        else if (response.statusCode == 401) {
          //output?.hideLoader();
          if (deviceType == ScreenType.phone) {
            customAlert(AlertDialogType.Correo_electronico_o_contrasena_no_coinciden, context, "",  "", _responsive);
          }
          else{
            customAlertTablet(AlertDialogTypeTablet.Correo_electronico_o_contrasena_no_coinciden, context, "",  "", _responsive);
          }

          //output.showAlert(Constants.tlt_nocoinciden, Constants.ms_nocoinciden, TipoDialogo.ADVERTENCIA, "CERRAR");
          return null;
        }
        else if (response.statusCode == 404) {
          if (deviceType == ScreenType.phone) {
            customAlert(AlertDialogType.Correo_no_registrado, context, "",  "", _responsive);
          }
          else{
            customAlertTablet(AlertDialogTypeTablet.Correo_no_registrado, context, "",  "", _responsive);
          }
          return null;
        }
        else{
          //output?.hideLoader();
          //throw Exception(ErrorLoginMessageModel().statusErrorTextException);
          return null;
        }
      }else{
        //output?.hideLoader();
        //throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        return  null;
      }
    }
  }

  Future<PerfiladorModel> getPerfiladorAcceso(BuildContext context ,String idParticipante) async {
    String _service = "Perfilador";
    String _serviceID = "S2";
    print("Getting $_service");

    if (!await ConnectionManager.isConnected()) {
      //output.showAlert('Conexión no disponible', Constants.ALERTA_NO_CONEXION, null, null);
    }

    var config = AppConfig.of(context);

    var request = MyRequest(
      baseUrl: config.service_perfilador,
      path: '?idInteresado=' + idParticipante,
      method: Method.GET,
      body: null,
      headers: {"apikey": config.apikeyAppAgentes},
    );

    MyResponse response = await RequestHandler.httpRequest(request); //.timeout(const Duration (seconds:6),onTimeout :  _onTimeout(context, _responsive));


    print("response--- ${response.success}");
    try{
      if (response.success) {
        mapPerfilador = response.response;
        PerfiladorModel _datosPerfilador = PerfiladorModel.fromJson(mapPerfilador);
        print("datosPerfilador/// ${_datosPerfilador}");
        if (_datosPerfilador.agenteInteresadoList.isNotEmpty ||
            _datosPerfilador.daList.isNotEmpty ||
            _datosPerfilador.intermediarios.isNotEmpty) {
          print("if _datosPerfilador");
          for (var list in _datosPerfilador.agenteInteresadoList) {
            String moral = list.cveTipoInteres;
            if (moral == "INF") {
              idParticipanteMoral = list.idAgente;
            } else if (moral == "INT") {
              idParticipanteMoral = list.idAgente;
            }
          }
          return _datosPerfilador;
        }
      }else {
        //customAlertTablet(AlertDialogTypeTablet.opciones_de_inicio_de_sesion,context,"","", _responsive);
        throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);

      }
    }catch(e){
      /*writeLoginBinnacle(datosUsuario.idparticipante,
          "${config.service_perfilador}",
          LogErrorType.serviceError,
          response!= null?"(${!response.success}) ${response.response}":"null"
      );*/
      ErrorLoginMessageModel().serviceErrorAlert("$_serviceID - ${response!=null?!response.success:"null"}");
      print("==$e==\n$_serviceID - ${response!=null?!response.success:"null"}\n=>$e<=");
      return null;
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
    /*showDialog(
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
    );*/
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: AppColors.color_titleAlert.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => AnimatedPadding(
        duration: Duration(milliseconds: 0),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 192,
          padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
          decoration : new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
              )
          ),
          child:  Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:0.0),
                    child:Center(child: new Text(Constants.titleNVersion, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.color_titleAlert),)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child:SingleChildScrollView(child: new Text(Constants.msgNVersion, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'OpenSansRegular', color: AppColors.color_appBar),)),
                  ),
                  ButtonTheme(
                    minWidth: 340.0,
                    height: 40.0,
                    buttonColor: AppColors.secondary900,
                    child: RaisedButton(
                      onPressed: (){
                        _launchURL();
                      },
                      child: Text(Constants.descarga,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _showDialogoUpdateApplication(BuildContext context) {
    print("update");
    /*showDialog(
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
    );*/
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: AppColors.color_titleAlert.withOpacity(0.6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => AnimatedPadding(
        duration: Duration(milliseconds: 0),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 288,
          padding: EdgeInsets.only(top:16.0, right: 16.0, left: 16.0, bottom: 16),
          decoration : new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
              )
          ),
          child:  Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
                    child:Center(child: new Text(Constants.titleNVersion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.color_titleAlert,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.15))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 12.0, right: 12.0),
                    child:SingleChildScrollView(child: new Text(Constants.msgNVersion,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: AppColors.color_appBar,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: ButtonTheme(
                      minWidth: 340.0,
                      height: 40.0,
                      buttonColor: AppColors.secondary900,
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text(Constants.despues,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 340.0,
                    height: 40.0,
                    buttonColor: AppColors.secondary900,
                    child: RaisedButton(
                      onPressed: (){
                        _launchURL();
                      },
                      child: Text(Constants.descarga,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
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


 _onTimeout(BuildContext context, Responsive responsive){
    customAlert(AlertDialogType.timeOut, context, "",  "", responsive);
    return null;
  }

  Future<String> fetchFoto(BuildContext context, File url) async {
    print("fetchFoto");
    _appEnvironmentConfig = AppConfig.of(context);

    try {
      var postUri = Uri.parse(_appEnvironmentConfig.serviceBCA +
          "/app/foto/${datosUsuario.idparticipante}");
      var responsePost = new http.MultipartRequest("POST", postUri);
      responsePost.headers['x-api-key'] = _appEnvironmentConfig.apikeyBCA;
      responsePost.files.add(await http.MultipartFile.fromPath('file', url.path));

      responsePost.send().then((responseDataPost) {
        if (responseDataPost != null && responseDataPost.statusCode == 200) {
          responseDataPost.stream.transform(utf8.decoder).listen((value) {

            Map postMap = json.decode(value);
            //  print("response : $postMap");
            if (postMap["success"] == true) {
              var mensaje = {
                'mensaje':
                "¡Gracias! Tus datos fueron actualizados exitosamente.",
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
          });
        } else {
          throw Exception('Failed to load post response');
        }
      }).catchError((error) => throw Exception('Failed to load post response'));
    } catch (e) {
      return null;
    }
  }

  Future<bool> fetchFotoDelete(BuildContext context) async {
    print("fetchFotoDelete");

    _appEnvironmentConfig = AppConfig.of(context);
    Navigator.of(context).pop();

    try {
      final responsePost = await http.delete(
          _appEnvironmentConfig.serviceBCA +
              "/app/foto/${datosUsuario.idparticipante}",
          headers: {
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
      /*bool status = await internetStatus();
      if (status) {
        mensaje = {
          'mensaje':
          "Se produjo un error al intentar eliminar tu fotografía, intenta más tarde.",
          'titulo': "",
          'success': false
        };
      } else {
        mensaje = {
          'mensaje':
          "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
          'titulo': "Error de conexión.",
          'success': false
        };
      }
      mensajeStatus = ErrorLoginMessageModel.fromJson(mensaje);*/
      return false;
    }
  }

  Future<DatosFisicosModel> getPersonaFisica(BuildContext context, String idParticipante, bool isImport) async {

    var config = AppConfig.of(context);
    String _service = isImport ? "Persona fisica import" : "Persona fisica";
    String _serviceID = isImport ? "S5" : "S3";
    print("Getting $_service");
      http.Response _response;
      try {
        print(config.serviceBCA + '/app/datos-perfil/' + idParticipante);
        _response = await http.get(config.serviceBCA + '/app/datos-perfil/' + idParticipante,
            headers: {"x-api-key": config.apikeyBCA});

        if (_response != null) {
          if (_response.statusCode == 200) {
            if (_response.body != null && _response.body.isNotEmpty) {
              Map mapAgentes = json.decode(_response.body);
              if (mapAgentes != null && mapAgentes.isNotEmpty) {
                if (mapAgentes["success"] == false) {
                  //throw Exception(ErrorLoginMessageModel().responseNotBodyErrorTextException);
                } else {
                  datosFisicos = DatosFisicosModel.fromJson(mapAgentes);
                  return datosFisicos;
                }
              } else {
                //throw Exception(ErrorLoginMessageModel().responseNotBodyErrorTextException);
              }
            } else {
              //throw Exception(ErrorLoginMessageModel().responseNotBodyErrorTextException);
            }
          } else {
            throw Exception(ErrorLoginMessageModel().statusErrorTextException);
          }
        } else {
          throw Exception(
              ErrorLoginMessageModel().responseNullErrorTextException);
        }
      } catch (e) {
        ErrorLoginMessageModel().serviceErrorAlert(
            "$_serviceID - ${_response != null ? _response.statusCode : "null"}");
        print(
            "==$e==\n$_serviceID - ${_response != null ? _response.statusCode : "null"}\n=>$e<=");
        return null;
      }

}

  Future<bool> getImporta(String idParticipante) async {
  String _service = "Importar Persona Fisica";
  String _serviceID = "S4";
  print("Getting $_service");
  ConnectivityStatus _connectivityStatus =
  await ConnectivityServices().getConnectivityStatus(false);
  if (_connectivityStatus.available) {
    http.Response _response;
    try {
      print(
          "${config.serviceBCA}/app/importa-persona-bup-bca/$idParticipante");
      final response = await http.post(
          config.serviceBCA +
              '/app/importa-persona-bup-bca/' +
              idParticipante,
          headers: {"x-api-key": config.apikeyBCA});
      if (response != null) {
        Map mapAgentes = json.decode(response.body.toString());
        if (mapAgentes != null && mapAgentes.isNotEmpty) {
          if (mapAgentes.containsKey("success") &&
              mapAgentes["success"] == true) {
            return true;
          } else {
            //throw Exception(ErrorLoginMessageModel().responseNotBodyErrorTextException);
          }
        } else {
          //throw Exception(ErrorLoginMessageModel().responseNotBodyErrorTextException);
        }
      } else {
        throw Exception(
            ErrorLoginMessageModel().responseNullErrorTextException);
      }
    } catch (e) {
      ErrorLoginMessageModel().serviceErrorAlert(
          "$_serviceID - ${_response != null ? _response.statusCode : "null"}");
      print(
          "==$e==\n$_serviceID - ${_response != null ? _response.statusCode : "null"}\n=>$e<=");
      return false;
    }
  } else {
    ErrorLoginMessageModel().connectionErrorAlert();
    return false;
  }
}