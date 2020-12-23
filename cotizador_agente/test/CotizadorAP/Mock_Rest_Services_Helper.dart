import 'dart:convert';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/utils/constants.dart' as Constants;

import 'modelo.dart';

//Pruebas unitarias módulo Cotizador AP
//Endpoints para petición a servicios
final String baseURL = 'https://gmm-cotizadores-qa.gnp.com.mx/';
final String negocios = 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/';

//Obtener Negocios Operables
getNegociosOperables(http.Client client) async {

  Map<String, dynamic> jsonMap = {
    "consultaNegocio": {
      "idParticipante": "MMONTA330374",
    }
  };
  final response = await http.post(negocios + Constants.NEGOCIOS_OPERABLES,
    headers: {"Content-Type": "application/json"}, body: jsonEncode(jsonMap).toString());

  if(response.statusCode == 200){
    print("Negocios Operables -->" + response.body.toString());
    List<NegocioOperable> negociosOperables = new List<NegocioOperable>();
    var list = jsonDecode(response.body)['consultaPorParticipanteResponse']["consultaNegocios"]["participante"]["listaNegocioOperable"] as List;
    list.removeWhere((element) => element["idNegocioOperable"].toString() != "NOP0002010");
    negociosOperables = list.map((i) => NegocioOperable.fromJson(i)).toList();

    return negociosOperables;
  }else{
    throw Exception('Failed!');
  }
}

//Obtener Cotizadores en base al negocio operable
Future<List<Cotizadores>> getCotizadores(http.Client client, NegocioOperable negocioOperable) async {
   List<Cotizadores> listCotizadores = List<Cotizadores>();
   List<dynamic> list;

   var headers = {
     "Content-type": "application/json",
     "Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWFjY2lkZW50ZXNwZXJzb25hbGVzLXFhLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2Utand0QGducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imh0dHBzOlwvXC9pZGVudGl0eXRvb2xraXQuZ29vZ2xlYXBpcy5jb21cL2dvb2dsZS5pZGVudGl0eS5pZGVudGl0eXRvb2xraXQudjEuSWRlbnRpdHlUb29sa2l0IiwiaWF0IjoxNjA4NTkyMzMxLCJleHAiOjE2MDg1OTQxMzEsInByb2plY3RpZCI6ImducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYSIsInVpZCI6Ik1NT05UQTMzMDM3NCIsImNsYWltcyI6eyJyb2wiOiJNb250YWx2byBSb2RyaWd1ZXoiLCJuZWdvY2lvc09wZXJhYmxlcyI6Ik1NT05UQTMzMDM3NCIsImlkcGFydGljaXBhbnRlIjoiTU1PTlRBMzMwMzc0IiwibWFpbCI6Im1hcmlvbW9udGFsdm9Ac2VndXJvc21vbnRhbHZvLmNvbSIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJNYXJpbyBNb250YWx2byBSb2RyaWd1ZXoiLCJhcGVwYXRlcm5vIjoiIiwiY3VlbnRhYmxvcXVlYWRhIjpmYWxzZSwidGlwb3VzdWFyaW8iOiJpbnRlcm1lZGlhcmlvcyIsImNlZHVsYSI6IiIsInJvbGVzIjpbIkFnZW50ZXMiLCJTZWd1cm8gTWFzaXZvIiwiU2VndXJvIFBlcnNvbmFzIiwiR00gV29yayBTaXRlIENvdGl6YSIsIkNvdGl6YSBBUCIsIkVtaXRlIEFQIl19fQ.ZjqrTnINBMALu_AYQ6nzNR0uALjvgaSknj9i86rQHtdCztLyZHojmkjhlKZ-KcjJJUD0j5paYLLG4c8Ca7oJwXSDKeLCQ5G-M3NMJ4KtpxSV90j9akXi397vSEVOoxLX3lFq4ggwb_nzyPnGDFdZQVYng6cF70BIqf9DeQA4cPbCyRDiNuDiV8JjEU9kalnmceIvkYLgYk7EgNH3SiwFWgC7mmETaNAB0E_kS5eiYMXzpEYRsi7EL9Uo5Nc1fABFsJpdRjDkAyXEGuEq88754EFsPn0yTFkYZmY-uQtjAktLigWGrBnO5mxRdyeVpgKukktwewA09MTdOze_rMFJfg"
   };

   Map<String, dynamic> jsonMap = {
     "clave_negocio_operable": "NOP0002010",
     "correo": "mariomontalvo@segurosmontalvo.com",
   };

   final response = await http.post(baseURL + Constants.COTIZADORES, headers: headers, body: jsonEncode(jsonMap).toString());

   if(response.statusCode == 200){
     print("Cotizadores -->" + response.body.toString());
     list = jsonDecode(response.body)['cotizadores'];
     for(int i =0; i<list.length; i++){
       listCotizadores.add(Cotizadores.fromJson(list[i]));
     }
     return listCotizadores;
   }else{
     throw Exception('Failed!');
   }

 }

 //Obtener secciones de formulario paso 1
getDataPaso1(String idAplicacion) async {
  idAplicacion = "2616";
  final response = await http.get(baseURL + Constants.FORMULARIO_PASO1 + idAplicacion, headers: {"Accept": "application/json"});

  if(response.statusCode == 200){
    print("Paso 1 --> " + response.body.toString());
    FormularioCotizacion formularioCotizacion = FormularioCotizacion();
    PasoFormulario estePaso = PasoFormulario.fromJson(jsonDecode(response.body));
    formularioCotizacion.paso1=estePaso;

    return estePaso;
  }else{
    throw Exception('Failed!');
  }
}

//Obtener secciones de formulario paso 2
getDataPaso2(Map<String,dynamic> body) async{

  Map<String, dynamic> body = {
      "idAplicacion": "2616",
      "titular": {
        "fechaAntiguedadGnp": "2020-12-22",
        "edad": "24",
        "cp": "53790",
        "sexo": 1,
        "id": 1
      },
      "contratante": {
        "banContratanteDifTitular": 1
      }, "general": {
        "idNegocio": 1
        },
      "asegurados": [],
      "idPlan": 51 };

  final response = await http.post(baseURL + Constants.FORMULARIO_PASO2, headers: {"Content-Type": "application/json"}, body: jsonEncode(body).toString());

  if(response.statusCode == 200){
    print('Paso 2 --> ' + response.body.toString());
    PasoFormulario estePaso = PasoFormulario.fromJson(jsonDecode(response.body));
    return estePaso;
  }else{
    throw Exception('Failed!');
  }
}

//Generar cotización con datos de paso 1 y paso 2
generarCotizacion(Map<String, dynamic> body) async {

  Map<String, String> headers = {"Content-Type": "application/json",
    "Authorization" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWFjY2lkZW50ZXNwZXJzb25hbGVzLXFhLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2Utand0QGducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imh0dHBzOlwvXC9pZGVudGl0eXRvb2xraXQuZ29vZ2xlYXBpcy5jb21cL2dvb2dsZS5pZGVudGl0eS5pZGVudGl0eXRvb2xraXQudjEuSWRlbnRpdHlUb29sa2l0IiwiaWF0IjoxNjA4NjY0NTUyLCJleHAiOjE2MDg2NjYzNTIsInByb2plY3RpZCI6ImducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYSIsInVpZCI6Ik1NT05UQTMzMDM3NCIsImNsYWltcyI6eyJyb2wiOiJNb250YWx2byBSb2RyaWd1ZXoiLCJuZWdvY2lvc09wZXJhYmxlcyI6Ik1NT05UQTMzMDM3NCIsImlkcGFydGljaXBhbnRlIjoiTU1PTlRBMzMwMzc0IiwibWFpbCI6Im1hcmlvbW9udGFsdm9Ac2VndXJvc21vbnRhbHZvLmNvbSIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJNYXJpbyBNb250YWx2byBSb2RyaWd1ZXoiLCJhcGVwYXRlcm5vIjoiIiwiY3VlbnRhYmxvcXVlYWRhIjpmYWxzZSwidGlwb3VzdWFyaW8iOiJpbnRlcm1lZGlhcmlvcyIsImNlZHVsYSI6IiIsInJvbGVzIjpbIkFnZW50ZXMiLCJTZWd1cm8gTWFzaXZvIiwiU2VndXJvIFBlcnNvbmFzIiwiR00gV29yayBTaXRlIENvdGl6YSIsIkNvdGl6YSBBUCIsIkVtaXRlIEFQIl19fQ.G-Dlf9MaAst5tdvHbKEKuVP-7geHUb753XEu8DpKxn7F1JFf65pMavDtg4pwtfxINDvNrIgC2fZTzW4X8ZnTk5XdcRhlX-GiJdR2P0VwCAS07UHk5E-uSfb6ZuSlvg0JLu6mrFoPC2zwcBXP9j-fuZ5V5wGErDvg9KxOqs6tsVXFEbI-3crBdUYR95vq2gL_YUOS9NBb4V6TmKaXimGHOpjv9-lze2iehY2RY05m0WrvLPdwPG--ftyCrFHVg6TvSc6VC6F1KYhfJYjmc7xnX10uE2yHHS3y93-MYnzz871aEOCE0LZ8nxrakvNYvbZ9WRiuTTCoRU2zBlm8EbhZjQ"};
  Map<String,dynamic> body = {
    "cotizacionGMMRequest": {
      "idAplicacion":2616,
      "planes": {
        "idCirculoMedico":"7",
        "idTipoSumaAsegurada":1,
        "idSumaAsegurada":442,
        "idDeducible":"882",
        "idCoaseguro":"1",
        "idFormaPago":0
      },
      "descuentos":[{
        "banRiesgoSelecto":false,
        "banGarantiaCoaseguroCero":false,
        "idPersona":1
      }],
      "titular":{
        "fechaAntiguedadGnp":"2020-12-22",
        "edad":24,
        "cp":"53790",
        "sexo":1,
        "id":1
      },
      "contratante":{
        "banContratanteDifTitular":1
      },
      "general":{
        "idNegocio":1
      },
      "asegurados":[],
      "idPlan":"51",
      "planesPrevios":[]
    }
  };

  final response = await http.post(baseURL + Constants.GENERA_COTIZACION, headers: headers, body: jsonEncode(body).toString());

  if(response.statusCode == 200){
    print('Generar Cotización --> ' + response.body.toString());
    var comparativa = Comparativa.fromJson(jsonDecode(response.body));
    return comparativa;
  }else{
    throw Exception('Failed!');
  }
}

//Obtener folio dependiendo del id formato
guardarFormato(Map<String, String> headers, Map<String, dynamic> body) async{

  final response = await http.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(body).toString());
  if(response.statusCode == 200){
    print("Guardar formato -->" + response.body.toString());
    var res = GuardaFormato.fromJson(jsonDecode(response.body));
    return res;
  }else{
    throw Exception('Failed!');
  }
}

guardarComparativa(Map<String, String> headers, Map<String, dynamic> body) async{

  final response = await http.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(body).toString());

  if(response.statusCode == 200){
   // print("Guardar comparativa -->" + response.body.toString());
    var res = GuardaFormato.fromJson(jsonDecode(response.body));
    return res;
  }else{
    throw Exception('Failed!');
  }
}

getMisCotizaciones(Map<String, String> headers, Map<String, dynamic> body) async {
  List<Cotizacion> cotizaciones = List<Cotizacion>();

  final response = await http.post(baseURL + Constants.COTIZACIONES_GUARDADAS, headers: headers, body: jsonEncode(body).toString());
   if(response.statusCode == 200){
     print('Mis Cotizaciones --> ' + response.body.toString());
     var list = json.decode(response.body)['cotizaciones'] as List;
     List<Cotizacion> newcotizaciones = list.map((i) => Cotizacion.fromJson(i)).toList();
     cotizaciones.addAll(newcotizaciones);

     return cotizaciones;
   }else{
     throw Exception('Failed!');
   }
}

eliminarCotizacion(Map<String, String> headers, Map<String, dynamic> body) async {

  final response = await http.post(baseURL + Constants.BORRA_COTIZACION, headers: headers, body: jsonEncode(body).toString());
  if (response.statusCode == 200){
    print('Eliminar cotización --> ' + response.body.toString());
    var res = jsonDecode(response.body);
    return res;
  }else{
    throw Exception('Failed');
  }
}

enviarCotizacion(Map<String, String> headers, Map<String, dynamic> body) async {

  final response = await http.post(baseURL + Constants.ENVIA_EMAIL, headers: headers, body: jsonEncode(body).toString());

  if(response.statusCode == 200){
    print('Enviar Cotización --> ' + response.body.toString());
    var res = ResponseEnviaC.fromJson(jsonDecode(response.body));
    return res;

  }else{
    throw Exception('Failed');
  }
}

