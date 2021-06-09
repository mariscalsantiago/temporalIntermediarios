
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';


AppConfig _appEnvironmentConfig;

FlutterWebviewPlugin _flutterWebViewPlugin;
String _initialURL="";
bool doReturn = true;

class AutosPage extends StatefulWidget {
  Responsive responsive;
  AutosPage({Key key,this.responsive}) : super(key: key);

  @override
  _AutosPageState createState() => _AutosPageState();
}

class _AutosPageState extends State<AutosPage> {
  String returnToApp = "/returnApp";
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;


  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(

      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: false,
      ),
      android: AndroidInAppWebViewOptions(
          allowContentAccess: true,),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));


  //PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;
  String url = "";
  String codigoIntermediario = prefs.getString("currentCUA");
  String DA = prefs.getString("currentDA");
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {

    // TODO: implement initState
   // _initialURL = _appEnvironmentConfig.cotizadorAutos+'?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDA=${DA}";
    doReturn = true;
    _flutterWebViewPlugin = FlutterWebviewPlugin();
    //_flutterWebViewPlugin.stopLoading();

    _flutterWebViewPlugin.onStateChanged.listen((onData) async {
      String mUrl = onData.url.toString();
      print("mUrl: "+mUrl);
      // print("Eventos type: "+onData.type.toString());
      if (mUrl.contains(returnToApp)) {
            print(onData.url);
            print(onData.type);
            print(onData.navigationType);
            _flutterWebViewPlugin.close();
            _flutterWebViewPlugin.dispose();
            doReturn = false;
            Navigator.pop(context,true);

          }
      if (mUrl.contains("tel")) {
        print("===mUrl======");
        String strWithDig =mUrl;
        String submUrl=strWithDig.replaceAll(RegExp(r'+'), '');
        print(submUrl);
        String submUrlSpace=submUrl.replaceAll(RegExp(r' '), '');
        print(submUrlSpace);
        launch(submUrlSpace);
      }
    });
    _flutterWebViewPlugin.onHttpError.listen((event) {
      print("ERROR Listener" + event.toString());
      Navigator.pop(context,true);
    });
    print(datosUsuario.idparticipante);
    print(codigoIntermediario);
    //print(datosPerfilador.intermediarios[0]);
    print('https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDA=${DA}",);
    validateIntenetstatus(context, widget.responsive,CallbackInactividad);
    handleUserInteraction(this.context,CallbackInactividad);
    //print('https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}",);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appEnvironmentConfig = AppConfig.of(context);

    print("showInactividad ${showInactividad}");
    Responsive responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child:/*  showInactividad? Container(
        height: responsive.height,
        color: Theme.Colors.White,
      ):*/SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding:false,
          resizeToAvoidBottomInset:true,
          body: InAppWebView(
            key: webViewKey,
            initialUrl:_appEnvironmentConfig.cotizadorAutos+'?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDA=${DA}",
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              print("onLoadStart ${url}");
              handleUserInteraction(context,CallbackInactividad);
            },
            onPrint:(controller, url){
              print("---mUrl---");
              String strWithDig =url;
              String submUrl=strWithDig.replaceAll(RegExp(r'+'), '');
              print(submUrl);
              String submUrlSpace=submUrl.replaceAll(RegExp(r' '), '');
              print(submUrlSpace);
              launch(submUrlSpace);
              print("onPrint ${url}");
              handleUserInteraction(context,CallbackInactividad);
            } ,
            onJsAlert: (controller, jsAlertRequest){
              print("onJsAlert ${jsAlertRequest}");
              handleUserInteraction(context,CallbackInactividad);
            },
            onScrollChanged: ( controller, x, y){
              print("onPrint ${x}");
              print("onPrint ${y}");
              handleUserInteraction(context,CallbackInactividad);
            },
            onJsConfirm: (controller,jsConfirm ){
              handleUserInteraction(context,CallbackInactividad);
              print("onJsConfirm ${jsConfirm}");
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.url;
              print("navigationAction");
              print(navigationAction);
              print(navigationAction.url);
              if (uri.contains(returnToApp)) {
                Navigator.pop(context,true);
              }
              if (navigationAction.url.contains("tel")) {
                print("===mUrl======");
                String submUrlSpace=navigationAction.url.replaceAll(RegExp(r' '), '');
                print(submUrlSpace);
                launch(submUrlSpace);
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              handleUserInteraction(context,CallbackInactividad);
              print("consoleMessage");
              print(consoleMessage);
            },
          ),
/*
          WebviewScaffold(
            url:_appEnvironmentConfig.cotizadorAutos+'?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDA=${DA}",
            primary: false,
            withJavascript: true,
            withZoom: false,
            displayZoomControls: false,
            withLocalStorage: true,
            hidden:false,
            clearCache: true,
    initialChild: Container()
          ),
          */
        ),
      ));
  }

  /*
          onHorizontalDragStart:(d){
            handleUserInteraction(context,CallbackInactividad);
          },
          onVerticalDragStart:(d){
            handleUserInteraction(context,CallbackInactividad);
          },

           */

  void CallbackInactividad(){
    //setState(() {
      print("CallbackInactividad Autos");
      focusContrasenaInactividad.hasFocus;
      //showInactividad;
      _flutterWebViewPlugin = FlutterWebviewPlugin();
      _flutterWebViewPlugin.onStateChanged.listen((onData) async {
        print("CallbackInactividad Autos");
        String mUrl = onData.url.toString();
        print("mUrl: "+mUrl);
        // print("Eventos type: "+onData.type.toString());
        if (mUrl.contains(returnToApp)) {
          print(onData.url);
          print(onData.type);
          print(onData.navigationType);
          _flutterWebViewPlugin.close();
          _flutterWebViewPlugin.dispose();

          if(doReturn){
          Navigator.pop(context,true);
          doReturn = false;
          }
        }
        if (mUrl.contains("tel")) {
          print("***mUrl***");
          print(mUrl);
          String strWithDig =mUrl;
          String submUrl=strWithDig.replaceAll(RegExp(r'+'), '');
          print(submUrl);
          launch(submUrl);
        }
      });
      handleUserInteraction(context,CallbackInactividad);
      //contrasenaInactividad = !contrasenaInactividad;
    //});
  }
}