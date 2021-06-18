
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
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
  ContextMenu contextMenu;
  String url = "";
  String codigoIntermediario = prefs.getString("currentCUA");
  String DA = prefs.getString("currentDA");
  double progress = 0;
  final urlController = TextEditingController();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: false,),
      android: AndroidInAppWebViewOptions(allowContentAccess: true),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true,
      ));


  @override
  void initState() {
    Inactivity(context:context).initialInactivity(functionInactivity);
    validateIntenetstatus(context,widget.responsive,functionConnectivity);
    doReturn = true;
    super.initState();
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    appEnvironmentConfig = AppConfig.of(context);
    return  GestureDetector(
        onTap: (){
          Inactivity(context:context).initialInactivity(functionInactivity);
        },child:WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding:false,
            resizeToAvoidBottomInset:true,
            body: InAppWebView(
              key: webViewKey,
              initialUrl: appEnvironmentConfig.cotizadorAutos+'?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDA=${DA}",
              initialOptions: options,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                print("onLoadStart ${url}");
                Inactivity(context:context).initialInactivity(functionInactivity);
              },
              onLoadStop: (controller, url) {
                print("onLoadStop ${url}");
                Inactivity(context:context).initialInactivity(functionInactivity);
              },
              onPrint:(controller, url){
                Inactivity(context:context).initialInactivity(functionInactivity);
                print("---mUrl---");
                String strWithDig =url;
                String submUrl=strWithDig.replaceAll(RegExp(r'+'), '');
                String submUrlSpace=submUrl.replaceAll(RegExp(r' '), '');
                launch(submUrlSpace);
              } ,
              onScrollChanged: ( controller, x, y){
                Inactivity(context:context).initialInactivity(functionInactivity);
                print("onPrint ${x}");
                print("onPrint ${y}");
                //handleUserInteraction(context,CallbackInactividad);
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                print("URL: ${shouldOverrideUrlLoadingRequest.url}");
                if (shouldOverrideUrlLoadingRequest.url.contains(returnToApp)) {
                  Inactivity(context:context).cancelInactivity();
                  Navigator.pop(context,true);
                }
                if (shouldOverrideUrlLoadingRequest.url.contains("tel")) {
                  print("===mUrl======");
                  Inactivity(context:context).initialInactivity(functionInactivity);
                  String submUrlSpace=shouldOverrideUrlLoadingRequest.url.replaceAll(RegExp(r' '), '');
                  print(submUrlSpace);
                  launch(submUrlSpace);
                }
                return ShouldOverrideUrlLoadingAction.ALLOW;
              },
              onConsoleMessage: (controller, consoleMessage) {
                Inactivity(context:context).initialInactivity(functionInactivity);
                //handleUserInteraction(context,CallbackInactividad);
                print("consoleMessage");
                print(consoleMessage);
              },
            ),
          ),
        )));
  }
}