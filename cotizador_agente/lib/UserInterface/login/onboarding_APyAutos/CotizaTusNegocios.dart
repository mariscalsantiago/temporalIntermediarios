import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class CotizaTusNegocios_Onboarding extends StatefulWidget {
  CotizaTusNegocios_Onboarding({Key key}) : super(key: key);


  @override
  _CotizaTusNegocios_Onboarding createState() => _CotizaTusNegocios_Onboarding();
}

class _CotizaTusNegocios_Onboarding extends State<CotizaTusNegocios_Onboarding> {

  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(0.00),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/señores_telefono.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Cotiza tus negocios al instante",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03, bottom: responsive.width * 0.08),
                child: Text("Cotiza de acuerdo al tipo de negocio de\n manera ágil desde tu celular o tablet.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              Container(
                height: responsive.hp(6.25),
                width: responsive.wp(90),
                margin: EdgeInsets.only(
                    top: responsive.height * 0.15,
                    left: responsive.wp(4.4),
                    right: responsive.wp(4.4)),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  color: Theme.Colors.GNP,
                  onPressed: () {
                    Navigator.pop(context,true);

                  },
                  child: Text(
                    "CONTINUAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.Colors.White,
                      fontSize: responsive.ip(2.0),
                    ),
                  ),
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}