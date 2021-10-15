
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EjemploPage extends StatefulWidget {
  EjemploPage({Key key}) : super(key: key);


  @override
  _EjemploPageState createState() => _EjemploPageState();
}

class _EjemploPageState extends State<EjemploPage> {

  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomMultiChild example'),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
          margin: EdgeInsets.only(top: height * 0.06,
          bottom: height * 0.05),
              child: Center(
                child: Image.asset("assets/ilustracion_es.png", fit:BoxFit.contain,height:responsive.hp(14), width: responsive.wp(14),),
              ),
            )
        ),

      ),
    );
  }
}
