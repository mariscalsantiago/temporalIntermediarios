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
            children: [Image.asset('assets/images/señorde_traje.png', fit:BoxFit.contain, height:responsive.hp(66), width: responsive.wp(70),),

              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.01),
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
                margin: EdgeInsets.only(
                    top: responsive.height * 0.06,
                    left: responsive.wp(67)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context,true);
                  },
                  child: Text(
                    "Omitir",
                    style: TextStyle(
                        color: Theme.Colors.GNP,
                        fontSize: responsive.ip(2.0)),
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