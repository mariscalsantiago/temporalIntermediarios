import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/theme.dart' as Theme;

Widget customLoaderModal(){
  return Stack(
    children: [
      new Opacity(
        opacity: 0.7,
        child: const ModalBarrier(dismissible: false, color: Theme.Colors.Dark),
      ),
      new Center(
        child: new CircularProgressIndicator(),
      ),
    ],
  );
}