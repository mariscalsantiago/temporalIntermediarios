import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Models/Splash/splashModel.dart';
import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/OnBoardingApAutos.dart';
import 'package:cotizador_agente/utils/MobileContainerPage.dart';
import 'package:cotizador_agente/utils/TabletContainerPage.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

bool useMobileLayout;
SharedPreferences prefs;
bool showOnBoardingFirebase = false;
String RouteName;

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> {


  @override
  void initState() {
    showOnBoardingFirebase = false;
    isMessageMobileClose = true;
    validateBiometricstatus(callback);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: getSplash()
    );
  }

  Widget getSplash() {
    var dSplash = SplashData(
        imagen: "assets/images/logoGNP.png", duracion: 1000);
    return FutureBuilder<SplashData>(
      future: getSplashData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("ConnectionState.none");
            return defaultSplash(dSplash);
            break;
          case ConnectionState.waiting:
            print("ConnectionState.waiting");
            return Container();
            break;
          default:
            if (snapshot.data != null) {
              print("default if");
              return remoteSplash(snapshot.data);
            } else {
              print("default else");
              return defaultSplash(dSplash);
            }
        }
      },
    );
  }

  Widget remoteSplash(SplashData splashData) {
    print("remoteSplash ----");
    finishSplash(splashData);
    print("-----remoteSplash");
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: SizedBox(
                width: 200.0,
                height: 75.64,
                child: CachedNetworkImage(
                  imageUrl: splashData.imagen,
                  //placeholder: (context, url) => defaultSplash(),
                  //errorWidget: (context, url, error) => defaultSplash(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.61),
            child: Container(
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 170.0,
                  height: 24,
                  child: CachedNetworkImage(
                    imageUrl: splashData.imagen_pie,
                    //placeholder: (context, url) => defaultSplash(),
                    //errorWidget: (context, url, error) => defaultSplash(),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget defaultSplash(SplashData splashData) {
    print("defaultSplash ----");
    finishSplash(splashData);
    print("----defaultSplash");
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200.0,
                  height: 75.64,
                  child: Container(
                    child:
                    Image.asset('assets/icon/splash/logoGNP.png', fit: BoxFit.contain),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.61),
            child: Container(
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 180.0,
                  height: 24,
                  child: Container(
                    child:
                    Image.asset('assets/icon/splash/ViviresIncreible.png', fit: BoxFit.contain),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<SplashData> getSplashData() async {
    print("getSplashData");
    try {
      RemoteConfig remoteConfig = await RemoteConfig.instance;
      remoteConfig.setConfigSettings(RemoteConfigSettings());
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      await getAcceso();
      String splash = remoteConfig.getString("splash_screen");
      var splashJson = jsonDecode(splash);
      var sData = SplashData.fromJson(splashJson);
      return sData;
    } catch (e) {
      print("error getSplasData ${e}");
      return null;
    }
  }

  void getAcceso() async {
    print("getAcceso");
    Map onboarding;
    try{
      String devideID = await _getId();
      print("devideID ${devideID}");
      DatabaseReference _dataBaseReference = FirebaseDatabase.instance.reference();

      await _dataBaseReference.child("deviceUser").child(devideID).once().then((DataSnapshot _snapshot) {

        var jsoonn = json.encode(_snapshot.value);
        onboarding = json.decode(jsoonn);
        print("onboarding ---> ${onboarding}");
        if (onboarding != null && onboarding.isNotEmpty) {

          String valor = onboarding["version"];
          bool requiredUpdate = onboarding["requiredUpdate"];
          List<String> cadenaFirebase = valor.split(".");
          List<String> cadenaApp = Tema.StringsMX.appVersion.split(".");

          if(requiredUpdate){
            if(int.parse(cadenaApp[0])  > int.parse(cadenaFirebase[0])){
              setState(() {
                showOnBoardingFirebase = true;
              });
              Map<String, dynamic> mapa = {
                '${devideID}': {
                  'version': Tema.StringsMX.appVersion,
                  'requiredUpdate': true
                }
              };
              _dataBaseReference.child("deviceUser").update(mapa);

            } else if(int.parse(cadenaApp[0])  == int.parse(cadenaFirebase[0])){

              if(int.parse(cadenaApp[1])  > int.parse(cadenaFirebase[1])){
                setState(() {
                  showOnBoardingFirebase = true;
                });
                Map<String, dynamic> mapa = {
                  '${devideID}': {
                    'version': Tema.StringsMX.appVersion,
                    'requiredUpdate': true
                  }
                };
                _dataBaseReference.child("deviceUser").update(mapa);
              } else if(int.parse(cadenaApp[1])  == int.parse(cadenaFirebase[1])){
                if(int.parse(cadenaApp[2])  > int.parse(cadenaFirebase[2])){
                  setState(() {
                    showOnBoardingFirebase = true;
                  });
                  Map<String, dynamic> mapa = {
                    '${devideID}': {
                      'version': Tema.StringsMX.appVersion,
                      'requiredUpdate': true
                    }
                  };
                  _dataBaseReference.child("deviceUser").update(mapa);
                }
              }
            }
          }
          else{
            Map<String, dynamic> mapa = {
              '${devideID}': {
                'version': Tema.StringsMX.appVersion,
                'requiredUpdate': true
              }
            };
            _dataBaseReference.child("deviceUser").update(mapa);
          }
        } else{
          Map<String, dynamic> mapa = {
            '${devideID}': {
              'version': Tema.StringsMX.appVersion,
              'requiredUpdate': true
            }
          };
          setState(() {
            showOnBoardingFirebase = true;
          });

          _dataBaseReference.child("deviceUser").update(mapa);
        }
      });
    } catch(e){
      if (onboarding != null && onboarding.isNotEmpty){
        print("if catch getAcceso");
        setState(() {
          showOnBoardingFirebase = false;
        });
      } else{
        print("else catch getAcceso");
        setState(() {
          showOnBoardingFirebase = true;
        });
      }
      print("error firebase ${e}");
    }
  }

  Future<String> _getId() async {
    try{
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) { // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.androidId; // unique ID on Android
      }
    }catch(e){
      print(" deviceID error ${e}");
    }

  }

  void finishSplash(SplashData splashData) async {

    print("finishSplash");

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    prefs = await SharedPreferences.getInstance();
    Vistas tipoVista;
    prefs.setBool("useMobileLayout", useMobileLayout);
    prefs.setBool("esPerfil", false);
    prefs.setBool("actualizarContrasenaPerfil", false);
    prefs.setBool("esActualizarNumero", false);
    prefs.setBool("rolAutoscotizarActivo", false);
    prefs.setBool("showAP", false);

    if(prefs != null && prefs.getBool("activarBiometricos") != null && prefs.getBool("seHizoLogin") != null){

      if(prefs.getBool("activarBiometricos") && prefs.getBool("seHizoLogin") && (prefs.getBool("flujoCompletoLogin") != null && prefs.getBool("flujoCompletoLogin"))){
          tipoVista = Vistas.biometricos;
          RouteName = "Biometricos";
      } else {
          prefs.setBool("activarBiometricos", false);
          tipoVista = Vistas.login;
          RouteName = "Login";
      }

    } else {
      prefs.setBool("activarBiometricos", false);
      tipoVista = Vistas.login;
      RouteName = "Login";
    }

    try{
      int count  = prefs.getInt("localAuthCount");
      if(count>=0){}else{prefs.setInt("localAuthCount", 0);}
    }catch(e){
      prefs.setInt("localAuthCount", 0);
      print(e);
    }
    try{
     bool count = prefs.getBool("subSecuentaIngresoCorreo");
      if(count!= null){}else{prefs.setBool("subSecuentaIngresoCorreo", false);}
    }catch(e){
      prefs.setInt("localAuthCount", 0);
      print(e);
    }

    if(!showOnBoardingFirebase){
      print("if showOnBoardingFirebase ${showOnBoardingFirebase}");
      await Future.delayed(
          Duration(milliseconds: splashData.duracion),
              () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => useMobileLayout ?
              MobileContainerPage(ParentView: Responsive.of(context), vista: tipoVista)
                //:  Todo Tablet
                :  TabletContainerPage(ParentView: Responsive.of(context), vista: tipoVista,),settings: RouteSettings(name: RouteName)))
                 // :  MobileContainerPage(ParentView: Responsive.of(context), vista:tipoVista,)))
      );
    } else{
      print("else showOnBoardingFirebase ${showOnBoardingFirebase}");
      if(prefs!=null&&prefs.getBool("showAP")!=null)
        prefs.setBool("showAP", false);
      if(prefs!=null&&prefs.getBool("rolAutoscotizarActivo")!=null)
        prefs.setBool("rolAutoscotizarActivo", false);
      showOnboarding();
    }

  }

  showOnboarding() {
    Navigator.push(context,new MaterialPageRoute(builder: (_) => OnBoardingAppAutos()));
  }


}


