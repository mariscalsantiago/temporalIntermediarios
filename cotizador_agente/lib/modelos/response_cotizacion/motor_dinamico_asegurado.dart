import 'motor_dinamico_cobertura.dart';

class MotorDinamicoAsegurado {
  MotorDinamicoAsegurado({
    this.primaBase,
    this.recargoPagoFraccionado,
    this.derechoPoliza,
    this.iva,
    this.primaTotal,
    this.idAsegurado,
    this.edad,
    this.genero,
    this.codigoPostal,
    this.tipoAsegurado,
    this.coberturas,
    this.primaComisionable,
    this.porcentajeComision,
    this.comision,
  });

  double primaBase;
  double recargoPagoFraccionado;
  double derechoPoliza;
  double iva;
  double primaTotal;
  int idAsegurado;
  int edad;
  int genero;
  int codigoPostal;
  int tipoAsegurado;
  List<MotorDinamicoCobertura> coberturas;
  double primaComisionable;
  double porcentajeComision;
  double comision;

  factory MotorDinamicoAsegurado.fromJson(Map<String, dynamic> json) =>
      MotorDinamicoAsegurado(
        primaBase: json["primaBase"].toDouble(),
        recargoPagoFraccionado: json["recargoPagoFraccionado"].toDouble(),
        derechoPoliza: json["derechoPoliza"].toDouble(),
        iva: json["iva"].toDouble(),
        primaTotal: json["primaTotal"].toDouble(),
        idAsegurado: json["idAsegurado"],
        edad: json["edad"],
        genero: json["genero"],
        codigoPostal: json["codigoPostal"],
        tipoAsegurado: json["tipoAsegurado"],
        coberturas: List<MotorDinamicoCobertura>.from(
            json["coberturas"].map((x) => MotorDinamicoCobertura.fromJson(x))),
        primaComisionable: json["primaComisionable"].toDouble(),
        porcentajeComision: json["porcentajeComision"].toDouble(),
        comision: json["comision"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "primaBase": primaBase,
    "recargoPagoFraccionado": recargoPagoFraccionado,
    "derechoPoliza": derechoPoliza,
    "iva": iva,
    "primaTotal": primaTotal,
    "idAsegurado": idAsegurado,
    "edad": edad,
    "genero": genero,
    "codigoPostal": codigoPostal,
    "tipoAsegurado": tipoAsegurado,
    "coberturas": List<dynamic>.from(coberturas.map((x) => x.toJson())),
    "primaComisionable": primaComisionable,
    "porcentajeComision": porcentajeComision,
    "comision": comision,
  };
}