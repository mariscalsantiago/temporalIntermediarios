import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/Models/Splash/splashModel.dart';
import 'package:cotizador_agente/utils/MobileContainerPage.dart';
import 'package:cotizador_agente/utils/TabletContainerPage.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

bool useMobileLayout;
SharedPreferences prefs;

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    _checkBiometrics();
    super.initState();
  }
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    _getAvailableBiometrics();
  }
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();

    } on PlatformException catch (e) {
      print(e);
    }
    /*if(availableBiometrics.contains(BiometricType.fingerprint)&& availableBiometrics.contains(BiometricType.face)){
      is_available_face = true;
      is_available_finger = true;
    }
    else if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        is_available_face = true;
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        is_available_finger = true;
      }else{
        is_available_face = false;
        is_available_finger = false;
      }
    }else{
      if(availableBiometrics.contains(BiometricType.fingerprint)&& availableBiometrics.contains(BiometricType.face)){
        is_available_face = true;
        is_available_finger = true;
      }
      else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        is_available_finger = true;
      }else if (availableBiometrics.contains(BiometricType.face)) {
        is_available_face = true;
        // Face ID.
      }else{
        is_available_face = false;
        is_available_finger = false;
      }
    }*/
    if (Platform.isIOS) {
      if(availableBiometrics.contains(BiometricType.fingerprint)){
        is_available_finger = true;
      } else if(availableBiometrics.contains(BiometricType.face)){
        is_available_face = true;
      }
    } else {
      if(availableBiometrics.contains(BiometricType.fingerprint)){
        is_available_finger = true;
      }
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
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
            return defaultSplash(dSplash);
            break;
          case ConnectionState.waiting:
            return Container();
            break;
          default:
            if (snapshot.data != null) {
              return remoteSplash(snapshot.data);
            } else {
              return defaultSplash(dSplash);
            }
        }
      },
    );
  }

  Widget remoteSplash(SplashData splashData) {
    finishSplash(splashData);
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
    finishSplash(splashData);
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
    try {
      RemoteConfig remoteConfig = await RemoteConfig.instance;
      remoteConfig.setConfigSettings(RemoteConfigSettings());
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      String splash = remoteConfig.getString("splash_screen");
      var splashJson = jsonDecode(splash);
      var sData = SplashData.fromJson(splashJson);
      return sData;
    } catch (e) {
      return null;
    }
  }

  void finishSplash(SplashData splashData) async {
    prefs = await SharedPreferences.getInstance();
    Vistas tipoVista;
    if(prefs != null && prefs.getBool("activarBiometricos") != null && prefs.getBool("hacerLogin") != null){

      if(prefs.getBool("activarBiometricos") && prefs.getBool("hacerLogin")){
          tipoVista = Vistas.biometricos;
      } else {
          tipoVista = Vistas.login;
      }

    } else {
      tipoVista = Vistas.login;
    }
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    await Future.delayed(
        Duration(milliseconds: splashData.duracion),
            () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => useMobileLayout ?
            MobileContainerPage(ParentView: Responsive.of(context), vista: tipoVista)
                :  TabletContainerPage(ParentView: Responsive.of(context), vista: Vistas.login,)))
    );
  }
}
