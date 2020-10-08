import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final Color backgroundColor;

  const CircleButton({Key key, this.onTap, this.iconData, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 20.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: new Icon(


          iconData,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}