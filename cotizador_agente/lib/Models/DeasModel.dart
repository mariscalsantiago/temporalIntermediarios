class ServiceGetDeasModel {
  String agenteInteresado;
  List<DeasModel> deas;
  ServiceGetDeasModel({this.agenteInteresado, this.deas});

  ServiceGetDeasModel.fromJson(Map<String, dynamic> json) {
    agenteInteresado = json['agenteInteresado'];
    deas = json['da'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['da'] = this.deas;
    data['agenteInteresado'] = this.agenteInteresado;
    return data;
  }
}


class DeasModel {
  String cveDa, codIntermediario;

  DeasModel({this.cveDa, this.codIntermediario});

  DeasModel.fromJson(Map<String, dynamic> json) {
    cveDa = json['cveDa'];
    codIntermediario = json['codIntermediario'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cveDa'] = this.cveDa;
    data['codIntermediario'] = this.codIntermediario;
    return data;
  }
}