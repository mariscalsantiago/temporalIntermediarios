class MotorDinamicoCobertura {
  MotorDinamicoCobertura({
    this.idCobertura,
    this.nombreCobertura,
    this.primaCobertura,
  });

  int idCobertura;
  String nombreCobertura;
  double primaCobertura;

  factory MotorDinamicoCobertura.fromJson(Map<String, dynamic> json) =>
      MotorDinamicoCobertura(
        idCobertura: json["idCobertura"],
        nombreCobertura: json["nombreCobertura"],
        primaCobertura: json["primaCobertura"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "idCobertura": idCobertura,
    "nombreCobertura": nombreCobertura,
    "primaCobertura": primaCobertura,
  };
}