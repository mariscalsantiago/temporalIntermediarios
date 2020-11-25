import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class EnabledButton extends StatelessWidget {

  final GestureTapCallback onPressed;
  final String title;
  bool enabled;
  EdgeInsets margin;

  EnabledButton({@required this.title, @required this.onPressed, @required this.enabled, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: this.margin ?? EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: FlatButton(
          splashColor: this.enabled ? AppColors.color_LongPress : Colors.transparent,
          disabledColor: AppColors.gnpbBackDisable2,
          color: this.enabled ? AppColors.secondary900 : AppColors.gnpbBackDisable2,
          textColor: Colors.white,
          onPressed: this.enabled ? this.onPressed : () {},
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

