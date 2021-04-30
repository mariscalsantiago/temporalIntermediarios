class ConsultarPorIdParticipanteConsolidado{
  ConsultaPersonalIdParticipante consultarPorIdParticipanteConsolidadoResponse;

  ConsultarPorIdParticipanteConsolidado({this.consultarPorIdParticipanteConsolidadoResponse});

  factory ConsultarPorIdParticipanteConsolidado.fromJson(Map<dynamic, dynamic> data){
    return ConsultarPorIdParticipanteConsolidado(
      consultarPorIdParticipanteConsolidadoResponse: data["consultarPorIdParticipanteConsolidadoResponse"] != null
          ? ConsultaPersonalIdParticipante.fromJson(data["consultarPorIdParticipanteConsolidadoResponse"]): ConsultaPersonalIdParticipante(),
    );
  }

  toJson() {
    return{
      'consultarPorIdParticipanteConsolidadoResponse': consultarPorIdParticipanteConsolidadoResponse,
    };
  }

}

class ConsultaPersonalIdParticipante{
  PersonaConsulta personaConsulta;

  ConsultaPersonalIdParticipante({this.personaConsulta});

  factory ConsultaPersonalIdParticipante.fromJson(Map<dynamic, dynamic> data){
    return ConsultaPersonalIdParticipante(
      personaConsulta:   data["personaConsulta"] != null ? PersonaConsulta.fromJson(data["personaConsulta"]): PersonaConsulta(),
    );
  }

  toJson() {
    return{
      'personaConsulta': personaConsulta,
    };
  }

}

class PersonaConsulta{
  Persona persona;

  PersonaConsulta({this.persona});

  factory PersonaConsulta.fromJson(Map<dynamic, dynamic> data){
    return PersonaConsulta(
      persona:   data["persona"] != null ? Persona.fromJson(data["persona"]): Persona(),
    );
  }

  toJson() {
    return{
      'persona': persona,
    };
  }
}

class Persona{
  DatosGenerales datosGenerales;

  Persona({this.datosGenerales});

  factory Persona.fromJson(Map<dynamic, dynamic> data){
    return Persona(
      datosGenerales:   data["datosGenerales"] != null ? DatosGenerales.fromJson(data["datosGenerales"]): DatosGenerales(),
    );
  }

  toJson() {
    return{
      'datosGenerales': datosGenerales,
    };
  }
}

class DatosGenerales{
  String idParticipanteConsolidado;

  DatosGenerales({this.idParticipanteConsolidado});

  factory DatosGenerales.fromJson(Map<dynamic, dynamic> data){
    return DatosGenerales(
      idParticipanteConsolidado:   data["idParticipanteConsolidado"] ,
    );
  }

  toJson() {
    return{
      'idParticipanteConsolidado': idParticipanteConsolidado,
    };
  }

}