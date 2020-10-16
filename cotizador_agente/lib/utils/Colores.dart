import 'package:flutter/material.dart';

class AppColors {
  static HexColor color_sombra = HexColor("F3F4F5");
  static HexColor color_titulo = HexColor("002e71");
  static HexColor color_primario = HexColor("fc6c25");
  static HexColor color_texto = HexColor("000000");
  static HexColor color_filtro = HexColor("e4e4e4");
  static HexColor color_texto_filtro = HexColor("6c7480");
  static HexColor color_texto_campo = HexColor("343f61");
  static HexColor color_switch_apagado = HexColor("dcdcdc");
  static HexColor color_mail = HexColor("aac3ee");
}

class HexColor extends Color {

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}