import 'dart:async';
import 'dart:io';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  Future<void> initSmsListener() async {

    print("Sms star");
    String commingSms;
    try {
      commingSms = await AltSmsAutofill().listenForSms;
      print("recive Sms ${commingSms}");
    } catch(e) {
      print("Sms Failed to get Sms. ${e}");
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initSmsListener();
    // TODO: implement initState
    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState codigo $state");
    if(state == AppLifecycleState.resumed){
      print("resumed");

      if(Platform.isAndroid){
        AltSmsAutofill().unregisterListener();
        //initSmsListener();
      }
    }
    else if(state == AppLifecycleState.inactive){
      // app is inactive
      print("inactive");

      AltSmsAutofill().unregisterListener();
    }
    else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
      print("paused");
      //Navigator.pop(context);
      //Navigator.pop(context);
      AltSmsAutofill().unregisterListener();
      //initSmsListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronômetro'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text("Prueba",
              style: TextStyle(fontSize: 72),
            ),
          ),
        ),

      ],
    );
  }
}