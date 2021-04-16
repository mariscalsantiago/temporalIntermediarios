
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


FlutterWebviewPlugin _flutterWebViewPlugin;

class AutosPage extends StatefulWidget {
  AutosPage({Key key}) : super(key: key);

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
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    
    // TODO: implement initState

    _flutterWebViewPlugin = FlutterWebviewPlugin();

    _flutterWebViewPlugin.onStateChanged.listen((onData) async {


      String mUrl = onData.url.toString();

      print("mUrl: "+mUrl);
      // print("Eventos type: "+onData.type.toString());

          if (mUrl.contains(returnToApp)) {
            _flutterWebViewPlugin.close();
            _flutterWebViewPlugin.dispose();
            Navigator.pop(context,true);
          }
          
    });

    print(datosUsuario.idparticipante);
    print(datosPerfilador.intermediarios[0]);
    print('https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}",);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:  SafeArea(
        child: InAppWebView(
          key: webViewKey,
          // contextMenu: contextMenu,
          initialUrl: 'https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}", // initialFile: "assets/index.html",
          initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
             // this.url = url.toString();
              //urlController.text = this.url;
            });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.url;
            print(navigationAction);
            if (uri.contains(returnToApp)) {
              Navigator.pop(context,true);
              }
            },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
      ),
      /*WebviewScaffold(
          withZoom: false,
          enableAppScheme: false,
          displayZoomControls: false,
          withJavascript: true,
          url:'https://gnp-appcontratacionautos-qa.appspot.com/?jwt='+loginData.jwt+"&codigoIntermediario=${datosPerfilador.intermediarios[0]}",

        )*/
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