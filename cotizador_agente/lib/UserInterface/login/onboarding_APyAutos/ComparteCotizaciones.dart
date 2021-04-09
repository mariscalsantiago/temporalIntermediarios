import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class CoparteCotizaciones_Onboarding extends StatefulWidget {
  CoparteCotizaciones_Onboarding({Key key}) : super(key: key);


  @override
  _CoparteCotizaciones_Onboarding createState() => _CoparteCotizaciones_Onboarding();
}

class _CoparteCotizaciones_Onboarding extends State<CoparteCotizaciones_Onboarding> {

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
                  child: Image.asset('assets/images/señorade_traje.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Comparte fácilmente\n tus cotizaciones",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Descarga las cotizaciones y/o envíalas\n directamente a tu\n Cliente desde tu dispositivo.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/tercero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context,true);
                        },
                        child: Text(
                          "Omitir",
                          style: TextStyle(
                              color: Theme.Colors.GNP,
                              fontWeight: FontWeight.normal,
                              fontSize: responsive.ip(2.5)),
                        ),
                      ),

                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}