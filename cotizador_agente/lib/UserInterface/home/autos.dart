
import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Functions/Conectivity.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:share_extend/share_extend.dart';

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
import 'package:share/share.dart';



bool doReturn = true;
Timer _timerMessageWifi;

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
  bool hasAutosError = false;
  String hasAutosErrorUrl;


  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        clearCache:true,
        verticalScrollBarEnabled: true,
        disableVerticalScroll:false,
        debuggingEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        preferredContentMode: UserPreferredContentMode.DESKTOP,
        supportZoom: false,),
      android: AndroidInAppWebViewOptions(
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          overScrollMode:AndroidOverScrollMode.OVER_SCROLL_ALWAYS,
          allowContentAccess: true,
          clearSessionCache:true,
          saveFormData:true,
          thirdPartyCookiesEnabled:true,
          hardwareAcceleration:true,
          supportMultipleWindows:true,
          useWideViewPort: true
      ),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true,
      ));


  @override
  void initState() {
    print("cotizadorAutos");
    Inactivity(context:context).initialInactivity(functionInactivity);
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    doReturn = true;


    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);

  }
  void functionConnectivity() {
    print("functionConnectivity reload");

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
          bottom: false,
          child: Scaffold(
            resizeToAvoidBottomPadding:true,
            resizeToAvoidBottomInset:true,
            body: InAppWebView(
              key: webViewKey,
              initialUrl: appEnvironmentConfig.cotizadorAutos+'?jwt='+loginData.jwt+"&codigoIntermediario=${codigoIntermediario}&cveDa=$DA&cveHerramienta=APP",
              initialOptions: options,
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (url.contains(returnToApp) || url.contains("ReturnToApp") || url.contains("returntoApp") || url.contains("returntoapp") ) {
                  Inactivity(context:context).cancelInactivity();
                  Navigator.pop(context,true);
                }
                print("onLoadStart ${url}");
                Inactivity(context:context).initialInactivity(functionInactivity);
              },
              onLoadError: (controller, url, code, message) {
                print("onLoadError: $url, $code, $message");
                if(code!=null) {
                  if ("$code" == "-1004") {
                    hasInternetFirebase = false;
                    hasAutosError = true;
                    hasAutosErrorUrl = url;
                    if (!isMessageWifi) {
                      isMessageWifi = true;
                      customAlert(AlertDialogType.Sin_acceso_wifi, navigatorKey.currentContext, "", "", widget.responsive, funcionAlertaWifi);
                    }
                    Future.delayed(const Duration(seconds: 5), () {
                      Inactivity(context:context).cancelInactivity();
                      if(isMessageWifi) {
                        if(dialogConnectivityContext!=null) {
                          isMessageWifi = false;
                          Navigator.pop(navigatorKey.currentContext);
                        }
                      }
                      Navigator.pop(context,true);
                      return ShouldOverrideUrlLoadingAction.ALLOW;
                    });

                  }
                }



              },
              onLoadHttpError: (InAppWebViewController controller, String url, int i, String s) async {
                print('CUSTOM_HANDLER: $i, $s');
                /** instead of printing the console message i want to render a static page or display static message **/
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
                /// launch(submUrlSpace);

              } ,
              onScrollChanged: ( controller, x, y){
                Inactivity(context:context).initialInactivity(functionInactivity);
                print("onPrint ${x}");
                print("onPrint ${y}");
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                print("URL: ${shouldOverrideUrlLoadingRequest.url}");
                if (shouldOverrideUrlLoadingRequest.url.contains(returnToApp) || shouldOverrideUrlLoadingRequest.url.contains("ReturnToApp") || shouldOverrideUrlLoadingRequest.url.contains("returntoApp") || shouldOverrideUrlLoadingRequest.url.contains("returntoapp") ) {
                  Inactivity(context:context).cancelInactivity();
                  Navigator.pop(context,true);
                }
                return ShouldOverrideUrlLoadingAction.ALLOW;
              },
              onConsoleMessage: (controller, consoleMessage) {
                Inactivity(context:context).initialInactivity(functionInactivity);
                print("consoleMessage");
                print(consoleMessage);
                print("#COMPARTIR_FORMATO#");
                if(consoleMessage.message.contains("COMPARTIR_FORMATO")){
                  print("#COMPARTIR_FORMATO#");
                  String strWithDig =consoleMessage.message;
                  String submUrl=strWithDig.substring(19);
                  print("COMPARTIR_FORMATO : ${submUrl}");
                  ShareFileBase64(submUrl,"Cotizacion");
                }
                if(consoleMessage.message.contains("ENLACE_LLAMADA")){
                  print("#ENLACE_LLAMADA#");
                  String strWithDig =consoleMessage.message;
                  String submUrl=strWithDig.substring(16);
                  print("ENLACE_LLAMADA : ${submUrl}");
                  launch("tel:${submUrl.trim()}");
                }
                //downloadAndShowPDFB64(submUrl,"test");
              },
            ),
          ),
        )));
  }
  Future<void> downloadAndShowPDFB64(String dataB64, String title) async {
    Uint8List bytes = base64.decode(dataB64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + "$title"+".pdf");
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
  void ShareFileBase64(String dataB64, String title) async {
    List<String> listaFiles = [];
    Uint8List bytes = base64.decode(dataB64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + "$title"+".pdf");
    await file.writeAsBytes(bytes);
    listaFiles.add(file.path);
    if(listaFiles.isEmpty) {
      //customAlert(AlertDialogType.mensajeGenericoError, context, "Error", "Se ha producido un error al cargar el documento PDF.");
    } else {
      await Share.shareFiles(listaFiles);
    }
  }
}