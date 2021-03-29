import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class APyAutosOnboarding extends StatefulWidget {
  APyAutosOnboarding({Key key}) : super(key: key);


  @override
  _APyAutosOnboarding createState() => _APyAutosOnboarding();
}

class _APyAutosOnboarding extends State<APyAutosOnboarding> {

  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
     body: Center(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [Image.asset('assets/images/ilustracion_es.png', fit:BoxFit.contain, height:responsive.hp(60), width: responsive.wp(70),),

            Center(
            child: Container(
              margin: EdgeInsets.only(top: responsive.height * 0.00),
                  child: Text("¡Tu App Intermediario GNP\n te da la bienvenida!",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                  textAlign: TextAlign.center,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Cotiza tus negocios de Autos Individual,\n Motos, Micronegocio y Accidentes\n Personales.",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.0) ),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: responsive.height * 0.11,
                  left: responsive.wp(64)),
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