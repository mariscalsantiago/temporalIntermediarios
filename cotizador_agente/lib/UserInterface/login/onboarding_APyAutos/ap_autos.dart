import 'package:cotizador_agente/UserInterface/login/onboarding_APyAutos/CotizaTusNegocios.dart';
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
              children: [
                Container(
                    margin: EdgeInsets.only(top: responsive.hp(4)),
                    child: Image.asset('assets/images/ilustracion_es.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: responsive.height * 0.03),
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
                  margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/cuarto.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => CotizaTusNegocios_Onboarding(),
                                )
                            );
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