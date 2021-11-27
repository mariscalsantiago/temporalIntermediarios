import 'dart:convert';

import 'motor_dinamico_detalle_forma_pago.dart';




MotorDinamicoFormaPago motorDinamicoFormaPagoFromJson(String str) =>
    MotorDinamicoFormaPago.fromJson(json.decode(str));

String motorDinamicoFormaPagoToJson(MotorDinamicoFormaPago data) =>
    json.encode(data.toJson());

class MotorDinamicoFormaPago {
  MotorDinamicoFormaPago({
    this.idFormaPago,
    this.detalleFormaPago,
  });

  int idFormaPago;
  MotorDinamicoDetalleFormaPago detalleFormaPago;

  factory MotorDinamicoFormaPago.fromJson(Map<String, dynamic> json) =>
      MotorDinamicoFormaPago(
        idFormaPago: json["idFormaPago"],
        detalleFormaPago:
            MotorDinamicoDetalleFormaPago.fromJson(json["detalleFormaPago"]),
      );

  Map<String, dynamic> toJson() => {
        "idFormaPago": idFormaPago,
        "detalleFormaPago": detalleFormaPago.toJson(),
      };
}