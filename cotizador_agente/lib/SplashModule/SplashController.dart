import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/SplashModule/Entity/SplashData.dart';
import 'package:cotizador_agente/SplashModule/SplashContract.dart';
import 'package:cotizador_agente/SplashModule/SplashPresenter.dart';
import 'package:flutter/material.dart';

class SplashController extends StatefulWidget {
  SplashController({Key key}) : super(key: key);

  @override
  SplashControllerState createState() => SplashControllerState();
}

class SplashControllerState extends State<SplashController>
    implements SplashView {

  SplashPresenter presenter;

  SplashControllerState() {
    this.presenter = SplashPresenter(this);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: getSplash());
  }

  Widget getSplash() {
    return FutureBuilder<SplashData>(
      future: presenter?.getSplashData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return defaultSplash(snapshot.data);
            break;
          case ConnectionState.waiting:
            return Container();
            break;
          default:
            /*if (snapshot.data != null) {
              return remoteSplash(snapshot.data);
            } else {
              var dSplash = SplashData(
                  imagen: "assets/images/logoGNP.png", duracion: 1500);
              return remoteSplash(dSplash);
            }*/
            return defaultSplash(snapshot.data);
        }
      },
    );
  }

  Widget remoteSplash(SplashData splashData) {
    presenter?.finishSplash(splashData);
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
                  errorWidget: (context, url, error) => defaultSplash(splashData),
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
                  width: 180.0,
                  height: 24,
                  child: CachedNetworkImage(
                    //imageUrl: splashData.imagen_pie,
                    //placeholder: (context, url) => defaultSplash(),
                    errorWidget: (context, url, error) => defaultSplash(splashData),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget defaultSplash(SplashData splashData) {
    presenter?.finishSplash(splashData);
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
}
