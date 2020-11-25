import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TabButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String title;
  final String icono;
  final Color color;
  final dynamic placeHolder;

  TabButton(
      {@required this.title,
        @required this.icono,
        @required this.color,
        @required this.placeHolder,
        @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FlatButton(
            splashColor: AppColors.secondary50,
            padding: EdgeInsets.all(0),
            onPressed: this.onPressed,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                      width: 24,
                      height: 24,
                      imageUrl: icono,
                      placeholder: (context, url) => skeletonIcon(),
                      errorWidget: (context, url, error) => this.placeHolder),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: this.color))
                ])));
  }

  Widget skeletonIcon() {
    return SizedBox(
        width: 24,
        height: 24,
        child: Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300, shape: BoxShape.circle),
            ),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade300));
  }
}
