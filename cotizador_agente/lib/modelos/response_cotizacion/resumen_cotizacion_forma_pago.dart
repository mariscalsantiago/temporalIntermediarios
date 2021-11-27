import 'dart:convert';

ResumenCotizacionFormaPago resumenCotizacionFormaPagoFromJson(String str) =>
    ResumenCotizacionFormaPago.fromJson(json.decode(str));

String resumenCotizacionFormaPagoToJson(ResumenCotizacionFormaPago data) =>
    json.encode(data.toJson());

class ResumenCotizacionFormaPago {
  ResumenCotizacionFormaPago({
    this.idFormaPago,
    this.formaPago,
    this.primaTotal,
    this.primaParcial,
    this.parcialidades,
    this.numPagos,
  });

  int idFormaPago;
  String formaPago;
  String primaTotal;
  String primaParcial;
  String parcialidades;
  String numPagos;

  factory ResumenCotizacionFormaPago.fromJson(Map<String, dynamic> json) =>
      ResumenCotizacionFormaPago(
        idFormaPago: json["idFormaPago"],
        formaPago: json["formaPago"],
        primaTotal: json["primaTotal"],
        primaParcial: json["primaParcial"],
        parcialidades: json["parcialidades"],
        numPagos: json["numPagos"],
      );

  Map<String, dynamic> toJson() => {
        "idFormaPago": idFormaPago,
        "formaPago": formaPago,
        "primaTotal": primaTotal,
        "primaParcial": primaParcial,
        "parcialidades": parcialidades,
        "numPagos": numPagos,
      };
}
