import 'dart:convert';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:mockito/mockito.dart';
import 'Mock_Rest_Services_Helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:cotizador_agente/utils/constants.dart' as Constants;
import 'modelo.dart';


class MockClientServices extends Mock implements http.Client{}

final String baseURL = 'https://gmm-cotizadores-qa.gnp.com.mx/';
final String negocios = 'https://us-central1-gnp-auttarifasgmm-qa.cloudfunctions.net/';
final client = MockClientServices();
String jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1qd3RAZ25wLWFjY2lkZW50ZXNwZXJzb25hbGVzLXFhLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2Utand0QGducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsImF1ZCI6Imh0dHBzOlwvXC9pZGVudGl0eXRvb2xraXQuZ29vZ2xlYXBpcy5jb21cL2dvb2dsZS5pZGVudGl0eS5pZGVudGl0eXRvb2xraXQudjEuSWRlbnRpdHlUb29sa2l0IiwiaWF0IjoxNjA4NjY0NTUyLCJleHAiOjE2MDg2NjYzNTIsInByb2plY3RpZCI6ImducC1hY2NpZGVudGVzcGVyc29uYWxlcy1xYSIsInVpZCI6Ik1NT05UQTMzMDM3NCIsImNsYWltcyI6eyJyb2wiOiJNb250YWx2byBSb2RyaWd1ZXoiLCJuZWdvY2lvc09wZXJhYmxlcyI6Ik1NT05UQTMzMDM3NCIsImlkcGFydGljaXBhbnRlIjoiTU1PTlRBMzMwMzc0IiwibWFpbCI6Im1hcmlvbW9udGFsdm9Ac2VndXJvc21vbnRhbHZvLmNvbSIsImFwZW1hdGVybm8iOiIiLCJnaXZlbm5hbWUiOiJNYXJpbyBNb250YWx2byBSb2RyaWd1ZXoiLCJhcGVwYXRlcm5vIjoiIiwiY3VlbnRhYmxvcXVlYWRhIjpmYWxzZSwidGlwb3VzdWFyaW8iOiJpbnRlcm1lZGlhcmlvcyIsImNlZHVsYSI6IiIsInJvbGVzIjpbIkFnZW50ZXMiLCJTZWd1cm8gTWFzaXZvIiwiU2VndXJvIFBlcnNvbmFzIiwiR00gV29yayBTaXRlIENvdGl6YSIsIkNvdGl6YSBBUCIsIkVtaXRlIEFQIl19fQ.G-Dlf9MaAst5tdvHbKEKuVP-7geHUb753XEu8DpKxn7F1JFf65pMavDtg4pwtfxINDvNrIgC2fZTzW4X8ZnTk5XdcRhlX-GiJdR2P0VwCAS07UHk5E-uSfb6ZuSlvg0JLu6mrFoPC2zwcBXP9j-fuZ5V5wGErDvg9KxOqs6tsVXFEbI-3crBdUYR95vq2gL_YUOS9NBb4V6TmKaXimGHOpjv9-lze2iehY2RY05m0WrvLPdwPG--ftyCrFHVg6TvSc6VC6F1KYhfJYjmc7xnX10uE2yHHS3y93-MYnzz871aEOCE0LZ8nxrakvNYvbZ9WRiuTTCoRU2zBlm8EbhZjQ";

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

    test('Validando si la petición para obtener negocios operables fue correcta', () async {
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
      "Authorization" : jwt
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

  group('Test Paso 1', (){
    print('Paso 1 --> ' + baseURL + Constants.FORMULARIO_PASO1 + "2616");

    var headers = {"Accept": "application/json"};

    test('Validando si Paso 1 fue correcto', () async {
      when(client.get(baseURL + Constants.FORMULARIO_PASO1 + "2616", headers: headers))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await getDataPaso1("2616"), isA<PasoFormulario>());
    });

    test('La petición fue fallida', () async {
      when(client.get(baseURL + Constants.FORMULARIO_PASO1 + "2616", headers: headers))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await getDataPaso1(null), throwsException);
    });
  });

  group("Test Paso 2", (){
    print('Paso 2 --> ' + baseURL + Constants.FORMULARIO_PASO2);

    Map<String, String> headers = {"Content-Type": "application/json"};
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

    test("Validando si Paso 2 fue correcto", () async {
      when(client.post(baseURL + Constants.FORMULARIO_PASO2, headers: headers, body: jsonEncode(body).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await getDataPaso2(body), isA<PasoFormulario>());
    });

    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.FORMULARIO_PASO2, headers: headers, body: jsonEncode(body).toString()))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await getDataPaso2(null), throwsException);
    });
  });

  group("Test Genera cotización", (){
    print('Generar cotización --> ' + baseURL + Constants.GENERA_COTIZACION);

    Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : jwt};
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

    test("Validando si la cotización fue correcta", () async {
      when(client.post(baseURL + Constants.GENERA_COTIZACION, headers: headers, body: jsonEncode(body).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await generarCotizacion(body), isA<Comparativa>());
    });

    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.GENERA_COTIZACION, headers: headers, body: jsonEncode(body).toString()))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await generarCotizacion(null), throwsException);
    });
  });

  group('Test Guardar formato', (){
    print('Guardar formato --> ' + baseURL + Constants.GUARDA_COTIZACION);
    int FORMATO_COTIZACION_AP = 5;
    int idformato = FORMATO_COTIZACION_AP;

    Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : jwt};

    var resumen = {"idParticipante":"MMONTA330374","nombreParticipante":"Mario Montalvo Rodriguez","parametroCotizador":2616,"seccion":[{"nombre":"general","valores":[{"etiqueta":"id_tipo_cartera","valor":1,"idCampo":18},{"etiqueta":"idNegocio","valor":1,"idCampo":17},{"etiqueta":"id_negocio_operable","valor":12,"idCampo":44}],"idSeccion":1},{"nombre":"titular","valores":[{"etiqueta":"nombre","valor":"","idCampo":1},{"etiqueta":"ape_paterno","valor":"","idCampo":2},{"etiqueta":"ape_materno","valor":"","idCampo":3},{"etiqueta":"edad","valor":24,"idCampo":4},{"etiqueta":"cp","valor":"53790","idCampo":5},{"etiqueta":"antiguedad_gnp","valor":"2020-12-22","idCampo":6},{"etiqueta":"sexo","valor":1,"idCampo":61}],"idPersona":"1","idSeccion":2},{"nombre":"asegurados","valores":[],"idSeccion":3},{"nombre":"planes","valores":[{"etiqueta":"id_plan","valor":"51","idCampo":23}],"idSeccion":6},{"nombre":"contratante","valores":[{"etiqueta":"contratante_diferente","valor":1,"idCampo":11}],"idSeccion":4},{"nombre":"planes","valores":[{"etiqueta":"coberturas_basicas","valor":"Reembolso Gastos Medicos AP","idCampo":0},{"etiqueta":"id_circulomedico","valor":"7","idCampo":24},{"etiqueta":"id_tipo_sumaasegurada","valor":1,"idCampo":25},{"etiqueta":"id_sumaasegurada","valor":442,"idCampo":26},{"etiqueta":"id_deducible","valor":"882","idCampo":27},{"etiqueta":"id_coaseguro","valor":"1","idCampo":29},{"etiqueta":"id_forma_pago","valor":0,"idCampo":33}],"idSeccion":6},{"nombre":"coberturas","valores":[],"idSeccion":7},{"nombre":"requestLabel","valores":[],"idSeccion":8},{"nombre":"descuentos","valores":[{"idPersona":"1","valores":[{"etiqueta":"riesgo_selecto","valor":false,"idCampo":8},{"etiqueta":"garantia_coaseguro","valor":false,"idCampo":9}],"idSeccion":11}],"idSeccion":11}]};
    var requestCotizacion = {"cotizacionGMMRequest":{"idAplicacion":2616,"planes":{"idCirculoMedico":"7","idTipoSumaAsegurada":1,"idSumaAsegurada":442,"idDeducible":"882","idCoaseguro":"1","idFormaPago":0},"descuentos":[{"banRiesgoSelecto":false,"banGarantiaCoaseguroCero":false,"idPersona":1}],"titular":{"fechaAntiguedadGnp":"2020-12-22","edad":24,"cp":"53790","sexo":1,"id":1},"contratante":{"banContratanteDifTitular":1},"general":{"idNegocio":1},"asegurados":[],"idPlan":"51","planesPrevios":[]}};

    var responseCotizacion = {"motorDinamicoResponse":{"versionMotor":"1.14","formasPago":[{"idFormaPago":0,"detalleFormaPago":{"asegurados":[{"primaBase":6210.0,"recargoPagoFraccionado":0.0,"derechoPoliza":50.0,"iva":1001.6,"primaTotal":7261.6,"idAsegurado":1,"edad":24,"genero":1,"codigoPostal":53790,"tipoAsegurado":1,"coberturas":[{"idCobertura":21,"nombreCobertura":"Basica GMM","primaCobertura":6210.0}],"primaComisionable":6210.0,"porcentajeComision":0.0,"comision":0.0}],"numeroPagos":1,"primaBase":6210.0,"iva":1001.6,"primaTotal":7261.6,"recargoPagoFraccionado":0.0,"primaComisionable":6210.0,"porcentajeComision":0.0,"comision":0.0,"parcialidad":7261.6,"derechoPoliza":50.0}}],"ejercicioFormatos":{"gastoTotalReclamacion":900000.0,"deducible":-9999.0,"saldoDespuesDeducible":890001.0,"porcentajeCoaseguro":0.0,"totalCoaseguro":0.0,"coaseguroPagar":0.0,"tuParticipacion":9999.0,"participacionGnp":890001.0}},"resumenCotizacion":{"banComparativa":1,"formasPago":[{"idFormaPago":0,"formaPago":"Única","primaTotal":"7,261.60","primaParcial":"\$7,261.60","parcialidades":"1 pago(s) de \$7,261.60","numPagos":"1"}],"secciones":[{"seccion":"Plan","elementos":[{"etiquetaElemento":"Plan","descElemento":"Accidentes Familiar"},{"etiquetaElemento":"Círculo Médico","descElemento":"Certum"},{"etiquetaElemento":"Suma Asegurada","descElemento":"300,000"},{"etiquetaElemento":"Deducible","descElemento":"0"},{"etiquetaElemento":"Coaseguro","descElemento":"0%"}]},{"seccion":"Cobertura Básica","elementos":[{"etiquetaElemento":"Reembolso Gastos Medicos AP","descElemento":"Amparada","idElemento":35}]},{"seccion":"Opcionales","elementos":[]}],"detalleAsegurados":[{"id":1,"primaBase":"\$6,210.00","primaTotal":"\$7,261.60"}]}};
    Map<String, dynamic> jsonMap = {
      "idUsuario": "MMONTA330374",
      "idAplicacion": "2616",
      "codIntermediario": "0060661001",
      "idPlan": "51",
      "idFormato": idformato,
      "titularCotizacion": "",
      "requestCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : jsonEncode(requestCotizacion),
      "responseCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : jsonEncode(responseCotizacion),
      "responseResumen": jsonEncode(resumen),
      "nombreCotizacion": idformato != Utilidades.FORMATO_COMPARATIVA ? "Test Formato" != null ? "Test Formato" : "Propuesta " + (0+1).toString() : "Prueba AP",
    };
    test('Validando si se genero el formato correcto', () async {
      when(client.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await guardarFormato(headers, jsonMap), isA<GuardaFormato>());
    });
    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await guardarFormato(null, null), throwsException);
    });
  });

  group('Test Genera comparativa', (){
    print('Guardar formato comparativa --> ' + baseURL + Constants.GUARDA_COTIZACION);
    int idformato = Utilidades.FORMATO_COMPARATIVA;

    Map<String, String> headers = {"Content-Type": "application/json", "Authorization" : jwt};

    var resumen = {"comparativas":[{"responseResumen":{"idParticipante":"MMONTA330374","nombreParticipante":"Mario Montalvo Rodriguez","parametroCotizador":2616,"seccion":[{"nombre":"general","valores":[{"etiqueta":"id_tipo_cartera","valor":1,"idCampo":18},{"etiqueta":"idNegocio","valor":1,"idCampo":17},{"etiqueta":"id_negocio_operable","valor":12,"idCampo":44}],"idSeccion":1},{"nombre":"titular","valores":[{"etiqueta":"nombre","valor":"","idCampo":1},{"etiqueta":"ape_paterno","valor":"","idCampo":2},{"etiqueta":"ape_materno","valor":"","idCampo":3},{"etiqueta":"edad","valor":24,"idCampo":4},{"etiqueta":"cp","valor":"53790","idCampo":5},{"etiqueta":"antiguedad_gnp","valor":"2020-12-22","idCampo":6},{"etiqueta":"sexo","valor":1,"idCampo":61}],"idPersona":"1","idSeccion":2},{"nombre":"asegurados","valores":[],"idSeccion":3},{"nombre":"planes","valores":[{"etiqueta":"id_plan","valor":"51","idCampo":23}],"idSeccion":6},{"nombre":"contratante","valores":[{"etiqueta":"contratante_diferente","valor":1,"idCampo":11}],"idSeccion":4},{"nombre":"planes","valores":[{"etiqueta":"coberturas_basicas","valor":"Reembolso Gastos Medicos AP","idCampo":0},{"etiqueta":"id_circulomedico","valor":"7","idCampo":24},{"etiqueta":"id_tipo_sumaasegurada","valor":1,"idCampo":25},{"etiqueta":"id_sumaasegurada","valor":442,"idCampo":26},{"etiqueta":"id_deducible","valor":"882","idCampo":27},{"etiqueta":"id_coaseguro","valor":"1","idCampo":29},{"etiqueta":"id_forma_pago","valor":0,"idCampo":33}],"idSeccion":6},{"nombre":"coberturas","valores":[],"idSeccion":7},{"nombre":"requestLabel","valores":[],"idSeccion":8},{"nombre":"descuentos","valores":[{"idPersona":"1","valores":[{"etiqueta":"riesgo_selecto","valor":false,"idCampo":8},{"etiqueta":"garantia_coaseguro","valor":false,"idCampo":9}],"idSeccion":11}],"idSeccion":11}]},"formasPago":[{"idFormaPago":0,"formaPago":"Única","primaTotal":"7,261.60","primaParcial":"\$7,261.60","parcialidades":"1 pago(s) de \$7,261.60","numPagos":"1"}],"secciones":[{"seccion":"Plan","elementos":[{"etiquetaElemento":"Plan","descElemento":"Accidentes Familiar"},{"etiquetaElemento":"Círculo Médico","descElemento":"Certum"},{"etiquetaElemento":"Suma Asegurada","descElemento":"300,000"},{"etiquetaElemento":"Deducible","descElemento":"0"},{"etiquetaElemento":"Coaseguro","descElemento":"0%"}]},{"seccion":"Cobertura Básica","elementos":[{"etiquetaElemento":"Reembolso Gastos Medicos AP","descElemento":"Amparada","idElemento":35}]},{"seccion":"Opcionales","elementos":[]}]},{"responseResumen":{"idParticipante":"MMONTA330374","nombreParticipante":"Mario Montalvo Rodriguez","parametroCotizador":2616,"seccion":[{"nombre":"general","valores":[{"etiqueta":"id_tipo_cartera","valor":1,"idCampo":18},{"etiqueta":"idNegocio","valor":1,"idCampo":17},{"etiqueta":"id_negocio_operable","valor":12,"idCampo":44}],"idSeccion":1},{"nombre":"titular","valores":[{"etiqueta":"nombre","valor":"","idCampo":1},{"etiqueta":"ape_paterno","valor":"","idCampo":2},{"etiqueta":"ape_materno","valor":"","idCampo":3},{"etiqueta":"edad","valor":26,"idCampo":4},{"etiqueta":"cp","valor":"21000","idCampo":5},{"etiqueta":"antiguedad_gnp","valor":"2020-12-22","idCampo":6},{"etiqueta":"sexo","valor":2,"idCampo":61}],"idPersona":"1","idSeccion":2},{"nombre":"asegurados","valores":[],"idSeccion":3},{"nombre":"planes","valores":[{"etiqueta":"id_plan","valor":"51","idCampo":23}],"idSeccion":6},{"nombre":"contratante","valores":[{"etiqueta":"contratante_diferente","valor":1,"idCampo":11}],"idSeccion":4},{"nombre":"planes","valores":[{"etiqueta":"coberturas_basicas","valor":"Reembolso Gastos Medicos AP","idCampo":0},{"etiqueta":"id_circulomedico","valor":"7","idCampo":24},{"etiqueta":"id_tipo_sumaasegurada","valor":1,"idCampo":25},{"etiqueta":"id_sumaasegurada","valor":442,"idCampo":26},{"etiqueta":"id_deducible","valor":"882","idCampo":27},{"etiqueta":"id_coaseguro","valor":"1","idCampo":29},{"etiqueta":"id_forma_pago","valor":0,"idCampo":33}],"idSeccion":6},{"nombre":"coberturas","valores":[],"idSeccion":7},{"nombre":"requestLabel","valores":[],"idSeccion":8},{"nombre":"descuentos","valores":[{"idPersona":"1","valores":[{"etiqueta":"riesgo_selecto","valor":false,"idCampo":8},{"etiqueta":"garantia_coaseguro","valor":false,"idCampo":9}],"idSeccion":11}],"idSeccion":11}]},"formasPago":[{"idFormaPago":0,"formaPago":"Única","primaTotal":"6,760.80","primaParcial":"\$6,760.80","parcialidades":"1 pago(s) de \$6,760.80","numPagos":"1"}],"secciones":[{"seccion":"Plan","elementos":[{"etiquetaElemento":"Plan","descElemento":"Accidentes Familiar"},{"etiquetaElemento":"Círculo Médico","descElemento":"Certum"},{"etiquetaElemento":"Suma Asegurada","descElemento":"300,000"},{"etiquetaElemento":"Deducible","descElemento":"0"},{"etiquetaElemento":"Coaseguro","descElemento":"0%"}]},{"seccion":"Cobertura Básica","elementos":[{"etiquetaElemento":"Reembolso Gastos Medicos AP","descElemento":"Amparada","idElemento":35}]},{"seccion":"Opcionales","elementos":[]}]}]};
    var requestCotizacion = {"cotizacionGMMRequest":{"idAplicacion":2616,"planes":{"idCirculoMedico":"7","idTipoSumaAsegurada":1,"idSumaAsegurada":442,"idDeducible":"882","idCoaseguro":"1","idFormaPago":0},"descuentos":[{"banRiesgoSelecto":false,"banGarantiaCoaseguroCero":false,"idPersona":1}],"titular":{"fechaAntiguedadGnp":"2020-12-22","edad":24,"cp":"53790","sexo":1,"id":1},"contratante":{"banContratanteDifTitular":1},"general":{"idNegocio":1},"asegurados":[],"idPlan":"51","planesPrevios":[]}};

    var responseCotizacion = {"motorDinamicoResponse":{"versionMotor":"1.14","formasPago":[{"idFormaPago":0,"detalleFormaPago":{"asegurados":[{"primaBase":6210.0,"recargoPagoFraccionado":0.0,"derechoPoliza":50.0,"iva":1001.6,"primaTotal":7261.6,"idAsegurado":1,"edad":24,"genero":1,"codigoPostal":53790,"tipoAsegurado":1,"coberturas":[{"idCobertura":21,"nombreCobertura":"Basica GMM","primaCobertura":6210.0}],"primaComisionable":6210.0,"porcentajeComision":0.0,"comision":0.0}],"numeroPagos":1,"primaBase":6210.0,"iva":1001.6,"primaTotal":7261.6,"recargoPagoFraccionado":0.0,"primaComisionable":6210.0,"porcentajeComision":0.0,"comision":0.0,"parcialidad":7261.6,"derechoPoliza":50.0}}],"ejercicioFormatos":{"gastoTotalReclamacion":900000.0,"deducible":-9999.0,"saldoDespuesDeducible":890001.0,"porcentajeCoaseguro":0.0,"totalCoaseguro":0.0,"coaseguroPagar":0.0,"tuParticipacion":9999.0,"participacionGnp":890001.0}},"resumenCotizacion":{"banComparativa":1,"formasPago":[{"idFormaPago":0,"formaPago":"Única","primaTotal":"7,261.60","primaParcial":"\$7,261.60","parcialidades":"1 pago(s) de \$7,261.60","numPagos":"1"}],"secciones":[{"seccion":"Plan","elementos":[{"etiquetaElemento":"Plan","descElemento":"Accidentes Familiar"},{"etiquetaElemento":"Círculo Médico","descElemento":"Certum"},{"etiquetaElemento":"Suma Asegurada","descElemento":"300,000"},{"etiquetaElemento":"Deducible","descElemento":"0"},{"etiquetaElemento":"Coaseguro","descElemento":"0%"}]},{"seccion":"Cobertura Básica","elementos":[{"etiquetaElemento":"Reembolso Gastos Medicos AP","descElemento":"Amparada","idElemento":35}]},{"seccion":"Opcionales","elementos":[]}],"detalleAsegurados":[{"id":1,"primaBase":"\$6,210.00","primaTotal":"\$7,261.60"}]}};
    Map<String, dynamic> jsonMap = {
      "idUsuario": "MMONTA330374",
      "idAplicacion": "2616",
      "codIntermediario": "0060661001",
      "idPlan": "51",
      "idFormato": idformato,
      "titularCotizacion": "",
      "requestCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : jsonEncode(requestCotizacion),
      "responseCotizacion": idformato == Utilidades.FORMATO_COMPARATIVA ? "{}" : jsonEncode(responseCotizacion),
      "responseResumen": jsonEncode(resumen),
      "nombreCotizacion": idformato != Utilidades.FORMATO_COMPARATIVA ? "Test Formato" != null ? "Test Formato" : "Propuesta " + (0+1).toString() : "Prueba AP",
    };

    test('Validando si se genero el formato comparativa', () async {
      when(client.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await guardarComparativa(headers, jsonMap), isA<GuardaFormato>());
    });
    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.GUARDA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('Failed!', 400));
      expect(await guardarComparativa(null, null), throwsException);
    });
  });

  group('Test Mis Cotizaciones', (){
    print('Mis Cotizaciones --> ' + baseURL + Constants.COTIZACIONES_GUARDADAS);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": jwt
    };

    Map<String, dynamic> jsonMap = {
      "idAplicacion": "2616",
      "pagina": 1,
      "idUsuario": "MMONTA330374"
    };

    test('Validando si se obtienen las cotizaciones guardadas', () async {
      when(client.post(baseURL + Constants.COTIZACIONES_GUARDADAS, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await getMisCotizaciones(headers, jsonMap), isA<List<Cotizacion>>());
    });
    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.COTIZACIONES_GUARDADAS, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('Invalid!', 400));
      expect(await getMisCotizaciones(null, null), throwsException);
    });
  });

  group('Test Eliminar cotización', (){
    print('Eliminar cotización --> ' + baseURL + Constants.BORRA_COTIZACION);

    Map<String, dynamic> jsonMap = {"folioCotizacion": "25004"};

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": jwt
    };

    test('Validando si se elimina la cotización correctamente', () async {
      when(client.post(baseURL + Constants.BORRA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await eliminarCotizacion(headers, jsonMap), isA<bool>());
    });

    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.BORRA_COTIZACION, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('Invalid!', 400));
      expect(await eliminarCotizacion(null, null), throwsException);
    });

  });

  group('Test Envía cotización', (){
    print('Enviar cotización --> ' + baseURL + Constants.ENVIA_EMAIL);

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization" : jwt
    };

    Map<String, dynamic> jsonMap = {
      "mail": ["bianca.rivera@gnp.com.mx"],
      "comentario": "Test enviar cotización",
      "idCotizacionGuardada": 24997,
      "idFormato": [Utilidades.FORMATO_COTIZACION_AP]
    };

    test('Validando si envía la cotización correctamente', () async {
      when(client.post(baseURL + Constants.ENVIA_EMAIL, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('[]', 200));
      expect(await enviarCotizacion(headers, jsonMap), isA<ResponseEnviaC>());
    });

    test('La petición fue fallida', () async {
      when(client.post(baseURL + Constants.ENVIA_EMAIL, headers: headers, body: jsonEncode(jsonMap).toString()))
          .thenAnswer((_) async => http.Response('Invalid!', 400));
      expect(await enviarCotizacion(null, null), throwsException);
    });

  });












}


