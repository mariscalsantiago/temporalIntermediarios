
import 'dart:convert';

import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Database.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/AlertModule/GNPDialog.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/ConnectionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/utils/Constants.dart' as Constants;
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class LoginInteractor implements LoginUseCase {
  LoginInteractorOutput output;
  LoginControllerState view;
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _sharedPreferences;
  String uPhone;
  int errorTimes = 0;
  var temporalCVE;
  String uMail;
  String uPass;
  AppConfig _appEnvironmentConfig;
  //UserJWT userJWT;
 // final LocalAuthentication auth = LocalAuthentication();

  LoginInteractor(LoginInteractorOutput output, LoginControllerState view) {
    this.output = output;
    this.view = view;
  }

  Future<bool> FunctionLoginPerfilador()async{

    datosPerfilador = await getPerfiladorAcceso(datosUsuario.idparticipante);
    if(datosPerfilador == null){
      return false;
    }

    return true;
  }

  Future<LoginDatosModel> logInServices(String mail, String password, String user) async {
    print("== Log In Interactor==");
    prefs=await SharedPreferences.getInstance();
    datosUsuario = await logInPost(mail, password, user);
    if(datosUsuario == null){
      return null;
    }

    Map<String, dynamic> datos = {
      'nombre': datosUsuario.givenname,
      'email': datosUsuario.mail,
      'contraseña': password,
      'savedMailApp':mail,
    };

    var encodeData = json.encode(datos);
    _sharedPreferences.setString('datosHuella', encodeData);

    if(!await FunctionLoginPerfilador()){
      return null;
    }

    currentCuaGNP = datosPerfilador.intermediarios[0];
    currentCuaLogros = datosPerfilador.intermediarios[0];
   // currentCuaDesignaciones = datosPerfilador.intermediarios[0];

    return datosUsuario;
  }

  Future<LoginDatosModel> logInPost(String emailApp, String password,String user) async {
    String _service = "Login";
    String _serviceID = "S1";
    print("Getting $_service");
    bool inWhiteList = false;
    var correos = new List<String>();
    correos.add("mariomontalvo@segurosmontalvo.com");
    correos.add("ap.uat@uat.com");
    if(correos.length > 0){
      if(correos.contains(emailApp)){
        print("existe");
        inWhiteList = true;
      }
    }else{
      print("sin elementos");
      inWhiteList = true;
    }
    if (!await ConnectionManager.isConnected()) {
      output.showAlert('Conexión no disponible', Constants.ALERTA_NO_CONEXION, null, null);
    }
    emailSession = emailApp;
    var config = AppConfig.of(view.context);
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

    output?.showLoader();

    if(inWhiteList){
      http.Response response = await http.post(config.serviceLogin,
          body: _loginJSONData,
          headers: headers).timeout(const Duration(seconds: 10));

      if(response != null){
        if(response.body != null && response.body.isNotEmpty){
          if (response.statusCode == 200) {
            Map map2 = json.decode(response.body);
            output?.hideLoader();
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

            return _datosUsuario;
          }else if (response.statusCode == 401) {
            output?.hideLoader();
            output.showAlert(Constants.tlt_nocoinciden, Constants.ms_nocoinciden, TipoDialogo.ADVERTENCIA, "CERRAR");
            return null;
          }else if (response.statusCode == 404) {
            output?.hideLoader();
            output.showAlert(Constants.tlt_noregistrado, Constants.ms_noregistrado, TipoDialogo.ADVERTENCIA, "CERRAR");
            return null;
          } else{
            output?.hideLoader();
            throw Exception(ErrorLoginMessageModel().statusErrorTextException);
          }
        }else{
          output?.hideLoader();
          throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        }
      }
    }else{
      output?.hideLoader();
      output.showAlert(Constants.tlt_noregistrado, Constants.ms_noregistrado, TipoDialogo.ADVERTENCIA, "CERRAR");
    }
  }
  Future<PerfiladorModel> getPerfiladorAcceso(String idParticipante) async {
    String _service = "Perfilador";
    String _serviceID = "S2";
    print("Getting $_service");

    if (!await ConnectionManager.isConnected()) {
      output.showAlert('Conexión no disponible', Constants.ALERTA_NO_CONEXION, null, null);
    }

    var config = AppConfig.of(view.context);

    var request = MyRequest(
      baseUrl: config.service_perfilador,
      path: '?idInteresado=' + idParticipante,
      method: Method.GET,
      body: null,
      headers: {"apikey": config.apikeyAppAgentes},
    );

    MyResponse response = await RequestHandler.httpRequest(request);
    try{
    if (response.success) {
      mapPerfilador = response.response;
      PerfiladorModel _datosPerfilador = PerfiladorModel.fromJson(
          mapPerfilador);
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
        output?.hideLoader();
        output.showHome();
        return _datosPerfilador;
      }else{
        output?.hideLoader();
        output.showAlert(Constants.tlt_noregistrado, Constants.ms_noregistrado, TipoDialogo.ADVERTENCIA, "CERRAR");
        return null;
      }
    }else {
      throw Exception(ErrorLoginMessageModel().responseNullErrorTextException);
    }
    }catch(e){
      writeLoginBinnacle(datosUsuario.idparticipante,
          "${config.service_perfilador}",
          LogErrorType.serviceError,
          response!= null?"(${!response.success}) ${response.response}":"null"
      );
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

  }