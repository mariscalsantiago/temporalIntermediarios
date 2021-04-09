import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class HerramientasVentas extends StatefulWidget {
  HerramientasVentas({Key key}) : super(key: key);


  @override
  _HerramientasVentas createState() => _HerramientasVentas();
}

class _HerramientasVentas extends State<HerramientasVentas> {

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
                  child: Image.asset('assets/images/señorde_traje.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Conoce las herramientas para\n potencializar tus ventas",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Genera cotizaciones, guárdalas y\n recupéralas desde el portal o la App\n ¡y mucho más!",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/segundo.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
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