import 'package:flutter/material.dart';

class ImageSwitch extends StatelessWidget {
  bool isOn;
  String image;

  ImageSwitch({@required this.isOn, @required this.image });

  @override
  Widget build(BuildContext context) {
    return  Image.network(image, color: (isOn ? Colors.white : Colors.grey[300]),); //Load network
  }
}