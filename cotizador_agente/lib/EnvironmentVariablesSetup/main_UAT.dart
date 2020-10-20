import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var configuredApp = new AppConfig(
    apikeyPagoLinea: 'l7xx3ecf012faeb4498995715f536c717be8',
    apikeyCampanias: 'l7xx3ecf012faeb4498995715f536c717be8',
    serviceEndPointCuentas: "",
    serviceEventos: "",
    serviceEndPoint: 'http://150.23.58.197/AppCobros/rest/',
    ambient: Ambient.uat,
    serviceLogin: 'https://cuentas-uat.gnp.com.mx/auth/login',
    serviceBCA: 'https://bca-ws-uat.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',
    apikeyBCABonos: '04985d13-d1d4-4032-9fe6-faa14c18d464',
    serviceBonosLogin:'https://api-uat.oscp.gnp.com.mx/bca-bonos/BCABonosSegundoPwd',
    apikeyBCABusqueda: '81dbb7d6-9d28-4058-941f-0942113e0f16',
    apikeyAppAgentes: 'l7xx526ec2d1bd9140a39ad15f72e1964bca',
    serviceSolicitud: 'https://solicituddigital-uat.gnp.com.mx',
    serviceHerramientasGM: 'https://perfilador-uat-dot-gnp-pymesgmm-prod.appspot.com',
    serviceHerramientasRC: 'https://pruebarc-uat-dot-gnp-mirc-2019.appspot.com',
    servicePolizasClientesCards:"https://appagentes-uat.gnp.com.mx",
    service_Consulta_Cartera_Poliza:"https://api-uat.oscpuat.gnp.com.mx/crm-agente/consulta-cartera-poliza",
    service_Consulta_Cartera_Nombre:"https://api-uat.oscpuat.gnp.com.mx/crm-agente/consulta-cartera-nombre",
    service_perfilador: "https://api-uat.oscp.gnp.com.mx/cmn-intermediario/consulta-perfil-app",
    serviceConteoPolizas: "https://api-uat.oscp.gnp.com.mx/crm-agentes/conteo-polizas",
    serviceConteoClientes: "https://api-uat.oscp.gnp.com.mx/crm-agentes/conteo-clientes",
    apiKeyTipoDeCambio:'l7xx63f313ab37be41ecacb2301c7bbcad92',
    urlTipoDeCambio: 'http://api.service.gnp.com.mx/sce/cut/recuperarTipoCambio',
    agentCod: "EHERNA978487",
    proyectId: 'gnp-appagentes-uat',
    urlCampaniasService:'http://bca-ws-uat.gnp.com.mx',
    apiKeyCampaniasService:"d41d8cd98f00b204e9800998ecf8427e",
    urlNotifierService:'https://api-uat.oscpuat.gnp.com.mx',
    apikeyCatalogo: 'l7xxd86ae243cffa4490b700c38693fa5418',
    serviceConsolidar:'https://us-central1-gnp-baseunicaagentes-uat.cloudfunctions.net',
    urlVersatileHome: 'https://hogarversatil-uat.gnp.com.mx',
    pagoEnLinea:'https://api-dev.oscp.gnp.com.mx',
    liferayUrl:'http://35.209.236.248/menu-noticias',
    liferayUrlEventos:'http://35.239.6.76/web/eventosgnp',
    liferayUrlBonos:'http://35.239.6.76/',
    repairFollow :'https://seguimientosiniestrosautos-uat.gnp.com.mx',
    privacyAdvertisement :'http://35.209.236.248/aviso',
    formatsService :'https://us-central1-gnp-appagentes-uat.cloudfunctions.net/formatos-consulta-contenido',
    formatsServiceKey :'3c9aa012daed41448e6659e80b105f69',
    negocioProtegido :'https://negocioprotegido-uat.gnp.com.mx/agentes/',
    servicioDeEncriptado :'https://negocioprotegido-uat.gnp.com.mx/service/validation/v1/encriptarDatosCotizador',
    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-uat.cloudfunctions.net/COT_CF_ConsultaNegocioCanal',
    urlCotizadores:'https://gmm-cotizadores-uat.gnp.com.mx/cotizador/negocio',
    urlGeneraCotizacion: 'https://gmm-cotizadores-uat.gnp.com.mx/orquestador-cotizador/generar-cotizacion',
    urlBorraCotizacion: 'http://gmm-cotizadores-uat.gnp.com.mx/cotizacion/borrarCotizacion',
    urlFormatoPDF: 'http://gmm-cotizadores-uat.gnp.com.mx/cotizacion/formato',
    urlCotizacionesGuardadas: 'http://gmm-cotizadores-uat.gnp.com.mx/cotizacion/cotizaciones',
    urlFormularioPaso1: 'https://gmm-cotizadores-uat.gnp.com.mx/cotizador/aplicacion?idAplicacion=',
    urlFormularioPaso2: 'https://gmm-cotizadores-uat.gnp.com.mx/cotizador/aplicacion/',
    urlGuardaCotizacion: 'https://gmm-cotizadores-uat.gnp.com.mx/persisteCotizaciones/guardaCotizacion',
    urlEnviaEmail: 'https://gmm-cotizadores-uat.gnp.com.mx/cotizacion/correo',
    urlAnalytics: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=vistaPreviaMovil&dataLayer=',
    urlAccionDescarga: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=descargarMovil&dataLayer=',
    urlAccionEnviaCot: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=cotizacionMovil&dataLayer=',
    urlAccionEnviaMail: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=envioMovil&dataLayer=',
    urlAccionComparativa: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=comparativaMovil&dataLayer=',
    urlAccionIngreso: 'https://gmm-cotizadores-uat.gnp.com.mx/?esMobile=true&accion=ingresoMovil&dataLayer=',

    child: new MyApp(),

  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(configuredApp);
  });
  //runApp(configuredApp); 145436591
}