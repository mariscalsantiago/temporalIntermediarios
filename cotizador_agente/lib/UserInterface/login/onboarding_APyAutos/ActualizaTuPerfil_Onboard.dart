import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class ActualizaTuPerfil_Onboarding extends StatefulWidget {
  ActualizaTuPerfil_Onboarding({Key key}) : super(key: key);


  @override
  _ActualizaTuPerfil_Onboarding createState() => _ActualizaTuPerfil_Onboarding();
}

class _ActualizaTuPerfil_Onboarding extends State<ActualizaTuPerfil_Onboarding> {

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
                  child: Image.asset('assets/images/señora_telefono.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Actualiza tu perfil y\n personaliza tu App",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Agrega una foto y mantén siempre\n actualizados tus datos de contacto.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/cuarto.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
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