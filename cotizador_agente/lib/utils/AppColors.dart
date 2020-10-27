import 'package:flutter/material.dart';

class AppColors {
  static HexColor color_sombra = HexColor("F3F4F5");
  static HexColor color_titulo = HexColor("002E71");
  static HexColor color_primario = HexColor("fc6c25");
  static HexColor color_texto = HexColor("000000");
  static HexColor color_filtro = HexColor("e4e4e4");
  static HexColor color_texto_filtro = HexColor("6c7480");
  static HexColor color_texto_campo = HexColor("343f61");
  static HexColor color_switch_apagado = HexColor("dcdcdc");
  static HexColor color_mail = HexColor("aac3ee");
  static HexColor color_appBar = HexColor("#33445F");
  static HexColor color_background = HexColor("#F6F9FD");
  static HexColor color_backgroundApp = HexColor("#F4F4F4");
  static HexColor color_borde = HexColor("E8EEF8");
  static HexColor color_encabezado_guardados = HexColor("6c7480");
  static HexColor color_Etiqueta = HexColor("647085");
  static HexColor color_Bordes = HexColor("CED8E8");
  static HexColor color_TextAppBar = HexColor("404040");
  static HexColor color_Text = HexColor("647085");
  static HexColor color_TextActive = HexColor("FF6B0B");
  static HexColor primary200 = HexColor("AAC3EE");
  static HexColor gnpTextUser = HexColor("0C2040");
  static HexColor color_background_blanco = HexColor("FEFEFE");
  static HexColor color_switch_simple_apagado = HexColor("595959");
  static HexColor color_naranja_primario = HexColor("FF6B0B");
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