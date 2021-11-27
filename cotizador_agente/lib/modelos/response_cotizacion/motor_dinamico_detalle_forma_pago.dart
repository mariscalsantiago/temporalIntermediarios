import 'motor_dinamico_asegurado.dart';

class MotorDinamicoDetalleFormaPago {
  MotorDinamicoDetalleFormaPago({
    this.asegurados,
    this.numeroPagos,
    this.primaBase,
    this.iva,
    this.primaTotal,
    this.recargoPagoFraccionado,
    this.primaComisionable,
    this.porcentajeComision,
    this.comision,
    this.parcialidad,
    this.derechoPoliza,
  });

  List<MotorDinamicoAsegurado> asegurados;
  int numeroPagos;
  double primaBase;
  double iva;
  double primaTotal;
  double recargoPagoFraccionado;
  double primaComisionable;
  double porcentajeComision;
  double comision;
  double parcialidad;
  double derechoPoliza;

  factory MotorDinamicoDetalleFormaPago.fromJson(Map<String, dynamic> json) =>
      MotorDinamicoDetalleFormaPago(
        asegurados: List<MotorDinamicoAsegurado>.from(
            json["asegurados"].map((x) => MotorDinamicoAsegurado.fromJson(x))),
        numeroPagos: json["numeroPagos"],
        primaBase: json["primaBase"].toDouble(),
        iva: json["iva"].toDouble(),
        primaTotal: json["primaTotal"].toDouble(),
        recargoPagoFraccionado: json["recargoPagoFraccionado"].toDouble(),
        primaComisionable: json["primaComisionable"].toDouble(),
        porcentajeComision: json["porcentajeComision"].toDouble(),
        comision: json["comision"].toDouble(),
        parcialidad: json["parcialidad"].toDouble(),
        derechoPoliza: json["derechoPoliza"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "asegurados": List<dynamic>.from(asegurados.map((x) => x.toJson())),
    "numeroPagos": numeroPagos,
    "primaBase": primaBase,
    "iva": iva,
    "primaTotal": primaTotal,
    "recargoPagoFraccionado": recargoPagoFraccionado,
    "primaComisionable": primaComisionable,
    "porcentajeComision": porcentajeComision,
    "comision": comision,
    "parcialidad": parcialidad,
    "derechoPoliza": derechoPoliza,
  };
}
