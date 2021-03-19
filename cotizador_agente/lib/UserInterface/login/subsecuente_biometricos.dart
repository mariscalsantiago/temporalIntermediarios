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
              "Hola Nombre",
              style: TextStyle(color: Tema.Colors.Encabezados),
            )),
            separacion(widget.responsive, 8),
            Container(
                margin: EdgeInsets.only(
                    left: widget.responsive.wp(2),
                    right: widget.responsive.wp(2)),
                child: Icon(Tema.Icons.facial)),
            
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
