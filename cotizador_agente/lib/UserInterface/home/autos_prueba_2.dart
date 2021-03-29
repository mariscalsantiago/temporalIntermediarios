/*import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
@override
_InAppWebViewExampleScreenState createState() =>
new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {

final GlobalKey webViewKey = GlobalKey();

InAppWebViewController? webViewController;
InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
crossPlatform: InAppWebViewOptions(
useShouldOverrideUrlLoading: true,
mediaPlaybackRequiresUserGesture: false,
),
android: AndroidInAppWebViewOptions(
useHybridComposition: true,
),
ios: IOSInAppWebViewOptions(
allowsInlineMediaPlayback: true,
));

late PullToRefreshController pullToRefreshController;
late ContextMenu contextMenu;
String url = "";
double progress = 0;
final urlController = TextEditingController();

@override
void initState() {
super.initState();

contextMenu = ContextMenu(
menuItems: [
ContextMenuItem(
androidId: 1,
iosId: "1",
title: "Special",
action: () async {
print("Menu item Special clicked!");
print(await webViewController?.getSelectedText());
await webViewController?.clearFocus();
})
],
options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
onCreateContextMenu: (hitTestResult) async {
print("onCreateContextMenu");
print(hitTestResult.extra);
print(await webViewController?.getSelectedText());
},
onHideContextMenu: () {
print("onHideContextMenu");
},
onContextMenuActionItemClicked: (contextMenuItemClicked) async {
var id = (Platform.isAndroid)
? contextMenuItemClicked.androidId
    : contextMenuItemClicked.iosId;
print("onContextMenuActionItemClicked: " +
id.toString() +
" " +
contextMenuItemClicked.title);
});

pullToRefreshController = PullToRefreshController(
options: PullToRefreshOptions(
color: Colors.blue,
),
onRefresh: () async {
if (Platform.isAndroid) {
webViewController?.reload();
} else if (Platform.isIOS) {
webViewController?.loadUrl(
urlRequest: URLRequest(url: await webViewController?.getUrl()));
}
},
);
}

@override
void dispose() {
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text("Prueba App Contratación")),
drawer: myDrawer(context: context),
body: SafeArea(
child: Column(children: <Widget>[
TextField(
decoration: InputDecoration(
prefixIcon: Icon(Icons.search)
),
controller: urlController,
keyboardType: TextInputType.url,
onSubmitted: (value) {
var url = Uri.parse(value);
if (url.scheme.isEmpty) {
url = Uri.parse("https://www.google.com/search?q=" + value);
}
webViewController?.loadUrl(
urlRequest: URLRequest(url: url));
},
),
Expanded(
child: Stack(
children: [
InAppWebView(
key: webViewKey,
// contextMenu: contextMenu,
initialUrlRequest:
URLRequest(url: Uri.parse("https://gnp-appcontratacionautos-qa.appspot.com?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWF1dGguaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1qd3RAZ25wLWF1dGguaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJhdWQiOiJodHRwczpcL1wvaWRlbnRpdHl0b29sa2l0Lmdvb2dsZWFwaXMuY29tXC9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImlhdCI6MTYxNDgyMTQzNywiZXhwIjo0NzY4NDIxNDM3LCJ1aWQiOiJUU1VBVVQiLCJwcm9qZWN0aWQiOiJnbnAtYWNjaWRlbnRlc3BlcnNvbmFsZXMtcWEiLCJtb2JpbGUiOmZhbHNlLCJjbGFpbXMiOnsicm9sIjoiU1VQRVJWSVNPUiBBVVRPUyIsIm5lZ29jaW9zT3BlcmFibGVzIjoiVFNVQVVUIiwiaWRwYXJ0aWNpcGFudGUiOiJUU1VBVVQiLCJtYWlsIjoidGVzdC5zdXBlcnZpc29yYXV0b3NAZ25wLmNvbS5teCIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJURVNUIiwiYXBlcGF0ZXJubyI6IiIsImN1ZW50YWJsb3F1ZWFkYSI6ZmFsc2UsInRpcG91c3VhcmlvIjoiZW1wbGVhZG9zIiwiY2VkdWxhIjoiIiwicm9sZXMiOlsiU3VzY3JpcHRvciBBZG12byIsIlN1cGVydmlzb3IiLCJBZG1pbmlzdHJhZG9yIEF1dG9zIiwiQXJtYWRvciIsIkFkbWluaXN0cmFkb3IgVXN1YXJpb3MiLCJPcGVyYWRvciBXb3Jrc2l0ZSIsIkRlc2NhcmdhIE1hc2l2YSBQb2xpemFzIiwiQWdydXBhciBSb2xlcyIsIk9wZXJhciBVc3VhcmlvcyBFbXBsZWFkb3MiLCJBZG1pbiBCYWphcyBJbnRlcm1lZGlhcmlvcyIsIk9wZXJhciBVc3VhcmlvcyBJbnRlcm1lZGlhcmlvcyIsIkdlcmVudGVfR0EiLCJQaWxvdG8gQWdlbnRlcyIsIkFVVF9JVkFfZGlzY3JpbWluYWRvIl19fQ.iPVgDJEDoOiV4w4127LeQvGgrTGeslPuaiNCKMnOCXdfBpDzU5lxhT47uKk70-O9x2zlrJUD9J9jOXr8F7B11C4OFmKmVuqqKdGxH3Vgay3RdEMQqtgCG2f_UsyUbT2FaeLG1Be_JRpJFmwpk7pmmwZPeCpSZtPsiPm-GM8-t6mkfzpvcjimP4px6D4ksHvX0xSiY420XCoaQjsSO99SHO_BvAEHLBKQnGtleikg23jfOfMo0Q0v-GBZtZ3KJV5W17KzEHe-h83R7pCR96K4DsvMENPMPUGeBnf-LeLHj0RQWWsrATByxUAkGJrxTH0WYFAxfMeV1M9ghDG2J-PJRA")),
// initialFile: "assets/index.html",
initialUserScripts: UnmodifiableListView<UserScript>([]),
initialOptions: options,
pullToRefreshController: pullToRefreshController,
onWebViewCreated: (controller) {
webViewController = controller;
},
onLoadStart: (controller, url) {
setState(() {
this.url = url.toString();
urlController.text = this.url;
});
},
androidOnPermissionRequest: (controller, origin, resources) async {
return PermissionRequestResponse(
resources: resources,
action: PermissionRequestResponseAction.GRANT);
},
shouldOverrideUrlLoading: (controller, navigationAction) async {
var uri = navigationAction.request.url!;

if (![
"http",
"https",
"file",
"chrome",
"data",
"javascript",
"about"
].contains(uri.scheme)) {
if (await canLaunch(url)) {
// Launch the App
await launch(
url,
);
// and cancel the request
return NavigationActionPolicy.CANCEL;
}
}

return NavigationActionPolicy.ALLOW;
},
onLoadStop: (controller, url) async {
pullToRefreshController.endRefreshing();
setState(() {
this.url = url.toString();
urlController.text = this.url;
});
},
onLoadError: (controller, url, code, message) {
pullToRefreshController.endRefreshing();
},
onProgressChanged: (controller, progress) {
if (progress == 100) {
pullToRefreshController.endRefreshing();
}
setState(() {
this.progress = progress / 100;
urlController.text = this.url;
print("URL QA: " +this.url);
});
},
onUpdateVisitedHistory: (controller, url, androidIsReload) {
setState(() {
this.url = url.toString();
urlController.text = this.url;
});
},
onConsoleMessage: (controller, consoleMessage) {
print(consoleMessage);
},
),
progress < 1.0
? LinearProgressIndicator(value: progress)
    : Container(),
],
),
),
])));
}
}

*/