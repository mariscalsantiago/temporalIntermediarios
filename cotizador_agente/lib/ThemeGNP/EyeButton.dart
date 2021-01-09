import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

class EyeButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  bool enabled;

  EyeButton({@required this.onPressed, this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onPressed,
        child: Container(
            color: Colors.transparent,
            width: 24,
            height: 24,
            child: Icon(
              this.enabled ? Icons.visibility : Icons.visibility_off,
              color: AppColors.gnpTextSystem2,
            )));
  }
}
