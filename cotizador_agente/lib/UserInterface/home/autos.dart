import 'dart:io';

import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;


FlutterWebviewPlugin _flutterWebViewPlugin;

class AutosPage extends StatefulWidget {
  AutosPage({Key key}) : super(key: key);

  @override
  _AutosPageState createState() => _AutosPageState();
}

class _AutosPageState extends State<AutosPage> {
  String retrunToApp = "returnApp";

  @override
  void initState() {
    // TODO: implement initState

    _flutterWebViewPlugin = FlutterWebviewPlugin();
    _flutterWebViewPlugin.onStateChanged.listen((onData) async {

      String mUrl = onData.url.toString();

      print("mUrl: "+mUrl);
      // print("Eventos type: "+onData.type.toString());
      if(Platform.isIOS) {
        if (onData.type.toString() == "WebViewState.shouldStart") {
          if (mUrl.contains(retrunToApp)) {
            _flutterWebViewPlugin.close();
            _flutterWebViewPlugin.dispose();
          }
        }
      }
      if(Platform.isAndroid) {
        if (onData.type.toString() == "WebViewState.finishLoad") {
          if (mUrl.contains(retrunToApp)) {
            _flutterWebViewPlugin.close();
            _flutterWebViewPlugin.dispose();
          }
        }
      }
    });
    print(datosUsuario.idparticipante);
    print(datosPerfilador.intermediarios[0]);
    print('https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}",);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon:Icon(Icons.arrow_back_outlined, color: Theme.Colors.GNP,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.Colors.White,
        ),
          url:'https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}",
      ),
    );

    _flutterWebViewPlugin.onDestroy.listen((Null n) {
      _flutterWebViewPlugin.dispose();
      _flutterWebViewPlugin.cleanCookies();
      _flutterWebViewPlugin.clearCache();
      _flutterWebViewPlugin.close();
    });
  }
}