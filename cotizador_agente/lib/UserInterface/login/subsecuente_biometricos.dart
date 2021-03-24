
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/UserInterface/login/loginRestablecerContrasena.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/cupertino.dart';
import 'logoEncabezadoLogin.dart';


class BiometricosPage extends StatefulWidget {
  BiometricosPage({Key key, this.responsive}) : super(key: key);
  final Responsive responsive;

  @override
  _BiometricosPage createState() => _BiometricosPage();
}

class _BiometricosPage extends State<BiometricosPage> {
  bool face = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            separacion(widget.responsive, 8),
            LoginEncabezadoLogin(responsive: widget.responsive),
            separacion(widget.responsive, 8),
            Center(
                child: Text(
              "¡Hola Nombre!",
              style: TextStyle(color: Tema.Colors.Encabezados, fontSize: widget.responsive.ip(3)),
            )),
            separacion(widget.responsive, 8),
            Container(
                margin: EdgeInsets.only(
                    left: widget.responsive.wp(2),
                    right: widget.responsive.wp(2)),
                child: Icon(face != false ? Tema.Icons.facial : Icons.fingerprint, size: widget.responsive.ip(9), color: Tema.Colors.GNP,)),
            Container(
              margin: EdgeInsets.only(top: widget.responsive.hp(3), bottom: widget.responsive.hp(4), left: widget.responsive.wp(30), right: widget.responsive.wp(30)),
              child:
                  Text(face != false ?"Mira fijamente a la cámara de tu dispositivo": "Coloca tu huella en el lector de tu dispositivo",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Tema.Colors.Funcional_Textos_Body, fontSize: widget.responsive.ip(1.5)),

                  ),
            ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
            ),
            padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
            width: widget.responsive.width,
            child: Text(face != false ?"INGRESAR CON LECTOR DE HUELLA": "INGRESAR CON RECONOCIMIENTO FACIAL", style: TextStyle(
              color: Tema.Colors.gnpOrange,
            ),
                textAlign: TextAlign.center),
          ),
          onPressed: () {
            setState(() {
              if (face) {
                face=false;
              }
              else {
                face=true;
              }
            });

          }
      ),


            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
                  width: widget.responsive.width,
                  child: Text("INGRESAR CON CONTRASEÑA", style: TextStyle(
                    color: Tema.Colors.gnpOrange,
                  ),
                      textAlign: TextAlign.center),
                ),
                onPressed: () async {
                }
            ),


            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  margin: EdgeInsets.only(bottom: widget.responsive.hp(2)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: EdgeInsets.only(top: widget.responsive.hp(2), bottom: widget.responsive.hp(2)),
                  width: widget.responsive.width,
                  child: Text("INGRESAR CON OTRO USUARIO", style: TextStyle(
                    color: Tema.Colors.gnpOrange,
                  ),
                      textAlign: TextAlign.center),
                ),
                onPressed: () async {
                }
            ),
        Container(
          margin: EdgeInsets.only(left:widget.responsive.wp(0), top: widget.responsive.hp(9)),
          child: Text("Versión 2.0",
            style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontSize: widget.responsive.ip(1.5),
                fontWeight: FontWeight.normal,

            ),
            textAlign: TextAlign.center,
          ),
        ),





          ],
        ),
      ),
    );
  }

  Widget separacion(Responsive responsive, double tamano) {
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

}
