import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';

class LoginEncabezadoLogin extends StatefulWidget {

  final Responsive responsive;
  const LoginEncabezadoLogin({Key key, this.responsive}) : super(key: key);
  @override
  _LoginEncabezadoLoginState createState() => _LoginEncabezadoLoginState();

}

class _LoginEncabezadoLoginState extends State<LoginEncabezadoLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.responsive.height * 0.08,
      child: Image.asset("assets/login/logoGNP.png",
          width:  widget.responsive.width*0.6,
          height: widget.responsive.height*0.4),
    );
  }
}


