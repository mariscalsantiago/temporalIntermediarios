
import 'package:cotizador_agente/TabsModule/Entity/Secciones.dart';

class Footer {
  bool visibleEnSegundoNivel;
  List<Secciones> secciones;

  Footer({this.visibleEnSegundoNivel, this.secciones});

  Footer.fromJson(Map<String, dynamic> json) {
    visibleEnSegundoNivel = json['visibleEnSegundoNivel'];
    if (json['secciones'] != null) {
      secciones = new List<Secciones>();
      json['secciones'].forEach((v) {
        secciones.add(new Secciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visibleEnSegundoNivel'] = this.visibleEnSegundoNivel;
    if (this.secciones != null) {
      data['secciones'] = this.secciones.map((v) => v.toJson()).toList();
    }
    return data;
  }
}