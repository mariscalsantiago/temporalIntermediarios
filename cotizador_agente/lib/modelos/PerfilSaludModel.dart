class PerfilSaludModel {
  final String Nickname;
  final int tipoSangre;
  final String enfermedades;
  final String condicionesEspeciales;
  final String condicionesAlimenticias;
  final String deportes;
  final bool fumador;


  PerfilSaludModel({ this.Nickname, this.tipoSangre, this.enfermedades, this.condicionesEspeciales, this.condicionesAlimenticias, this.deportes, this.fumador,});

  factory PerfilSaludModel.fromJson(Map<String, dynamic> json) {
    return PerfilSaludModel(
      Nickname: json['Nickname'],

      tipoSangre: json['tipoSangre'],
      enfermedades: json['enfermedades'],
      condicionesEspeciales: json['condicionesEspeciales'],
      condicionesAlimenticias: json['condicionesAlimenticias'],
      deportes: json['deportes'],
      fumador: json['fumador'],
    );
  }
}