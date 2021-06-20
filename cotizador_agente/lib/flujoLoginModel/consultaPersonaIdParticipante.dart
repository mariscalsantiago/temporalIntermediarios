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
  SistemasOrigen sistemasOrigen;

  Persona({this.datosGenerales, this.sistemasOrigen});

  factory Persona.fromJson(Map<dynamic, dynamic> data){
    return Persona(
      datosGenerales:   data["datosGenerales"] != null ? DatosGenerales.fromJson(data["datosGenerales"]): DatosGenerales(),
      sistemasOrigen:   data["sistemasOrigen"] != null ? SistemasOrigen.fromJson(data["sistemasOrigen"]): SistemasOrigen(),
    );
  }

  toJson() {
    return{
      'datosGenerales': datosGenerales,
    };
  }
}

class SistemasOrigen{

  sistemaOrigenNodo sistemaOrigen;

  SistemasOrigen({this.sistemaOrigen});

  factory SistemasOrigen.fromJson(Map<dynamic, dynamic> data){
    return SistemasOrigen(
        sistemaOrigen:   data["sistemaOrigen"] != null ? sistemaOrigenNodo.fromJson(data["sistemaOrigen"]): sistemaOrigenNodo()
    );
  }

  toJson() {
    return{
      'sistemaOrigen': sistemaOrigen,
    };
  }
}

class sistemaOrigenNodo{
  ValorSistemaOrigen valorSistemaOrigen;
  List<ValorSistemaOrigen> valorSistemaOrigenList;

  sistemaOrigenNodo({this.valorSistemaOrigen,this.valorSistemaOrigenList});

  factory sistemaOrigenNodo.fromJson(Map<dynamic, dynamic> data){
    Map<dynamic, dynamic> datat;
    List<dynamic> lista;
    try {
      lista = data["valorSistemaOrigen"] as List;
      print("valorSistemaOrigen --> ${data["valorSistemaOrigen"]}");
      print("lista ${lista}");
    } catch(e){
      datat = data["valorSistemaOrigen"];
      print("sistemaOrigenNodo e ${e}");
    }
    try{
      if(datat == null /*&& !datat.containsKey("valor")*/){
        return sistemaOrigenNodo(
            valorSistemaOrigenList : lista.length > 0 ? lista.map((value) => new ValorSistemaOrigen.fromJson(value)).toList() : null,
            valorSistemaOrigen: ValorSistemaOrigen()
        );
      }
      else{
        return sistemaOrigenNodo(
            valorSistemaOrigen:   data["valorSistemaOrigen"] != null ? ValorSistemaOrigen.fromJson(data["valorSistemaOrigen"]): ValorSistemaOrigen(),
            valorSistemaOrigenList: []
        );
      }
    }catch(e){
      print("sistemaOrigenNodo");
      print(e);
    }
  }

  toJson() {
    return{
      'valorSistemaOrigen': valorSistemaOrigen,
    };
  }
}

class ValorSistemaOrigen{
  String valor;
  bool banPadre;

  ValorSistemaOrigen({this.valor, this.banPadre});

  factory ValorSistemaOrigen.fromJson(Map<dynamic, dynamic> data){
    return ValorSistemaOrigen(
        valor:   data["valor"],
        banPadre: data["banPadre"]
    );
  }

  toJson() {
    return{
      'valor': valor,
      'banPadre' : banPadre
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