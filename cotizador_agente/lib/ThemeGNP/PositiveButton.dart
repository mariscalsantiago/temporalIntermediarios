import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class PositiveButton extends StatelessWidget {

  final GestureTapCallback onPressed;
  final String title;
  EdgeInsets margin;

  PositiveButton({@required this.title, @required this.onPressed, this.margin});

  @override
  Widget build(BuildContext context) {
    if (this.margin == null) {
      this.margin = EdgeInsets.fromLTRB(16, 24, 16, 24);
    }
    return Container(
      height: 48,
      margin: this.margin,
      child: FlatButton(
          disabledColor: AppColors.gnpbBackDisable2,
          color: AppColors.secondary900,
          textColor: Colors.white,
          onPressed: this.onPressed,
          child: Text(this.title,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.25,
                  color: Colors.white,
                  fontSize: 16))),
    );
  }

}

