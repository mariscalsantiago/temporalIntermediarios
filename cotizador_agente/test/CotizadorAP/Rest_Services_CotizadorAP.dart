import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:mockito/mockito.dart';
import 'Mock_Rest_Services_Helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:cotizador_agente/utils/constants.dart' as Constants;


class MockClientServices extends Mock implements http.Client{}

final String baseURL = 'https://gmm-cotizadores-qa.gnp.com.mx/';
final String negocios = 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/';
final client = MockClientServices();

main(){

  group("Test Negocios Operables", () {
    print('NegociosOp --> ' + negocios + Constants.NEGOCIOS_OPERABLES);

    var headers = {
      "Content-Type": "application/json"
    };

    Map<String, dynamic> jsonMap = {
      "consultaNegocio": {
        "idParticipante": "MMONTA330374",
      }
    };

    test('Validando si la petición fue correcta', () async {
      when(client.post(negocios + Constants.NEGOCIOS_OPERABLES, headers: headers, body: jsonMap))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await getNegociosOperables(client), isA<List<NegocioOperable>>());
    });

    test('La petición fue fallida', () async {
      when(client.post(negocios + Constants.NEGOCIOS_OPERABLES, headers: headers, body: jsonMap))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await getNegociosOperables(null), throwsException);
    });
  });

  group('Test Cotizadores', (){
    print('Cotizadores --> ' + baseURL + Constants.COTIZADORES);

    var headers = {
      "Content-type": "application/json",
      "Authorization" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWFjY2lkZW50ZXNwZXJzb25hbGVzLXFhLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2Utand0QGducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imh0dHBzOlwvXC9pZGVudGl0eXRvb2xraXQuZ29vZ2xlYXBpcy5jb21cL2dvb2dsZS5pZGVudGl0eS5pZGVudGl0eXRvb2xraXQudjEuSWRlbnRpdHlUb29sa2l0IiwiaWF0IjoxNjA4NTkyMzMxLCJleHAiOjE2MDg1OTQxMzEsInByb2plY3RpZCI6ImducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYSIsInVpZCI6Ik1NT05UQTMzMDM3NCIsImNsYWltcyI6eyJyb2wiOiJNb250YWx2byBSb2RyaWd1ZXoiLCJuZWdvY2lvc09wZXJhYmxlcyI6Ik1NT05UQTMzMDM3NCIsImlkcGFydGljaXBhbnRlIjoiTU1PTlRBMzMwMzc0IiwibWFpbCI6Im1hcmlvbW9udGFsdm9Ac2VndXJvc21vbnRhbHZvLmNvbSIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJNYXJpbyBNb250YWx2byBSb2RyaWd1ZXoiLCJhcGVwYXRlcm5vIjoiIiwiY3VlbnRhYmxvcXVlYWRhIjpmYWxzZSwidGlwb3VzdWFyaW8iOiJpbnRlcm1lZGlhcmlvcyIsImNlZHVsYSI6IiIsInJvbGVzIjpbIkFnZW50ZXMiLCJTZWd1cm8gTWFzaXZvIiwiU2VndXJvIFBlcnNvbmFzIiwiR00gV29yayBTaXRlIENvdGl6YSIsIkNvdGl6YSBBUCIsIkVtaXRlIEFQIl19fQ.ZjqrTnINBMALu_AYQ6nzNR0uALjvgaSknj9i86rQHtdCztLyZHojmkjhlKZ-KcjJJUD0j5paYLLG4c8Ca7oJwXSDKeLCQ5G-M3NMJ4KtpxSV90j9akXi397vSEVOoxLX3lFq4ggwb_nzyPnGDFdZQVYng6cF70BIqf9DeQA4cPbCyRDiNuDiV8JjEU9kalnmceIvkYLgYk7EgNH3SiwFWgC7mmETaNAB0E_kS5eiYMXzpEYRsi7EL9Uo5Nc1fABFsJpdRjDkAyXEGuEq88754EFsPn0yTFkYZmY-uQtjAktLigWGrBnO5mxRdyeVpgKukktwewA09MTdOze_rMFJfg"
    };

    Map<String, dynamic> jsonMap = {
      "clave_negocio_operable": "NOP0002010",
      "correo": "mariomontalvo@segurosmontalvo.com",
    };

    NegocioOperable negocio = NegocioOperable(
      negocioOperable: "AP Worksite",
      idNegocioOperable: "NOP0002010",
      ramo: "G",
      idNegocioComercial: "NC000000AP",
      idUnidadNegocio: "SEM",
    );
    test('Validando si la petición fue correcta', () async {
      when(client.post(baseURL + Constants.COTIZADORES, headers: headers, body: jsonMap))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await getCotizadores(client, negocio), isA<List<Cotizadores>>());
    });

    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.COTIZADORES, headers: headers, body: jsonMap))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await getCotizadores(null,null), throwsException);
    });


  });













}


