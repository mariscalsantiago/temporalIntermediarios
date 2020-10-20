import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/Modelos/LoginModels.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

var _environmentVariables;
FlutterWebviewPlugin _flutterWebViewPlugin;
String _urlBase;
String _initialURL;
bool _loading;

class PrivacyAdvertisement extends StatefulWidget {
  final String email;
  PrivacyAdvertisement({Key key, this.email}) : super(key: key);

  @override
  _PrivacyAdvertisementStage createState() => new _PrivacyAdvertisementStage();
}

class _PrivacyAdvertisementStage extends State<PrivacyAdvertisement>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  @override
  void initState(){
    _runAsyncInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildInitialURL();
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              WebviewScaffold(
                  url: _initialURL,
                  withJavascript: true,
                  hidden: true,
                  withZoom: false,
                  withLocalStorage: true,
                  clearCache: true
              ),
              _loading?customLoaderModal():Container()
            ],
          )
        )
    );
  }

  void _runAsyncInit() {
    _loading = false;
    //_showAlert =false;
    _flutterWebViewPlugin = FlutterWebviewPlugin();
    _flutterWebViewPlugin.onStateChanged.listen((onData) async {
      if (onData.type.toString() == "WebViewState.startLoad") {
        String _exitID = "/exit";
        String _responseID = "consiente=";
        String _launchID = "/launch";
        String _urlID = "url=";
        String _url;
        if (onData.url.toString().contains(_exitID)) {
          _flutterWebViewPlugin.hide();
          String _status = onData.url.substring(onData.url.indexOf(_responseID)+_responseID.length);
          _flutterWebViewPlugin.stopLoading();
          _flutterWebViewPlugin.goBack();
          _setAdvertisementResponse(
              _status.toLowerCase()=="true",
              widget.email,
              context
          );
        }
        if (onData.url.toString().contains(_launchID)) {
          _flutterWebViewPlugin.hide();
          _url = onData.url.substring(onData.url.indexOf(_urlID)+_urlID.length);
          _launchURL(_url);
          _flutterWebViewPlugin.stopLoading();
          _flutterWebViewPlugin.goBack();
          _flutterWebViewPlugin.show();

        }
      }

    });
  }

  void _buildInitialURL(){
    _environmentVariables = AppConfig.of(context);
    _urlBase = _environmentVariables.privacyAdvertisement;
    _initialURL=_urlBase;
    print(_initialURL);
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch(error){

    }
  }

  _setAdvertisementResponse(bool status, String email, BuildContext context) async{
    String _participantID = datosUsuario.idparticipante;
    _loading=true;
    try {
      Map lMap = {
        "correo": email,
        "consentimiento": status
      };
      String jsonString = json.encode(lMap);
      final responsePost = await http.post(
          _environmentVariables.serviceBCA+'/app/privacidad/'+ _participantID,
          body: jsonString,
          headers: {
            "x-api-key":  _environmentVariables.apikeyBCA,
            "Content-Type": "application/json"
          });
      if(responsePost!=null) {
        if (responsePost.statusCode == 200) {
          Map postMap = json.decode(responsePost.body.toString());
          if (postMap['success'] == true) {
            Timer(new Duration(seconds: 3), () =>
                setState(() {
                  _loading = false;
                  _goToHome();
                }),
            );
          } else{
            final response = await http.put(
                _environmentVariables.serviceBCA+"/app/privacidad/" + _participantID,
                body: jsonString,
                headers: {
                  "x-api-key": _environmentVariables.apikeyBCA,
                  "Content-Type": "application/json"
                });
            if(response!=null) {
              if (response.statusCode == 200) {
                print("response: ${response.body}");
                Timer(new Duration(seconds: 3), () =>
                    setState(() {
                      _loading = false;
                      _goToHome();
                    }),
                );
              }
            }
          }
        }
      }
    }catch(e){
      Timer(new Duration(seconds: 3), () =>
          setState(() {
            _loading = false;
            _goToHome();
          }),
      );
    }
  }

  void _goToHome(){
    Navigator.pushNamed(context, '/home').then((val){
      Navigator.pop(context,true);

    });
  }

  Widget customLoaderModal(){
    return Stack(
      children: [
        new Opacity(
          opacity: 0.7,
          child: const ModalBarrier(dismissible: false, color: Theme.Colors.Dark),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
  }
}