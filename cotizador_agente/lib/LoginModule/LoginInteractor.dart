
import 'dart:convert';

import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/LoginModule/LoginContract.dart';
import 'package:cotizador_agente/LoginModule/LoginController.dart';
import 'package:cotizador_agente/RequestHandler/MyRequest.dart';
import 'package:cotizador_agente/RequestHandler/MyResponse.dart';
import 'package:cotizador_agente/RequestHandler/RequestHandler.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/ConnectionManager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  //UserJWT userJWT;
  final LocalAuthentication auth = LocalAuthentication();

  LoginInteractor(LoginInteractorOutput output, LoginControllerState view) {
    this.output = output;
    this.view = view;
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

    datosPerfilador = await getPerfiladorAcceso(datosUsuario.idparticipante);
    if(datosPerfilador == null){
      return null;
    }

    currentCuaGNP = datosPerfilador.intermediarios[0];
    currentCuaLogros = datosPerfilador.intermediarios[0];
    currentCuaDesignaciones = datosPerfilador.intermediarios[0];

    return datosUsuario;
  }

  Future<LoginDatosModel> logInPost(String emailApp, String password,String user) async {
    String _service = "Login";
    String _serviceID = "S1";
    print("Getting $_service");
    if (!await ConnectionManager.isConnected()) {
      //output.showAlertC('Conexión no disponible', Constants.ALERTA_NO_CONEXION);
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
    http.Response response = await http.post(config.serviceLogin,
        body: _loginJSONData,
        headers: headers);

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
          output.showHome();
          return _datosUsuario;
        }else{
          throw Exception(ErrorLoginMessageModel().statusErrorTextException);
        }
      }else{
        throw Exception(ErrorLoginMessageModel().statusErrorTextException);
      }
    }
  }
  Future<PerfiladorModel> getPerfiladorAcceso(String idParticipante) async {
    String _service = "Perfilador";
    String _serviceID = "S2";
    print("Getting $_service");

    if (!await ConnectionManager.isConnected()) {
      //output.showAlertC('Conexión no disponible', Constants.ALERTA_NO_CONEXION);
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
        return _datosPerfilador;
      }
    }else {
      throw Exception(ErrorLoginMessageModel().responseBodyErrorTextException);
    }
  }

  }