import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    Key key,
  }) : super(key: key);

  const SkeletonContainer.square({
    double width,
    double height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded({
    double width,
    double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  const SkeletonContainer.circular({
    double width,
    double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(80)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
    //gradientColor: Colors.orange,
    //shimmerColor: Colors.red,
    curve: Curves.easeInCirc,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient:LinearGradient(
          begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops:[0.3, 0.8] ,
            colors: [Tema.Colors.gris_load1, Tema.Colors.gris_load2]
        ),
        borderRadius: borderRadius,
      )
    ),
  );
}