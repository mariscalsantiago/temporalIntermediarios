import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.uat,
    serviceLogin: 'https://cuentas-uat.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xx526ec2d1bd9140a39ad15f72e1964bca',
    service_perfilador: "https://api-uat.oscp.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: "gnp-accidentespersonales-uat",
    // urlNotifierService:'https://api-uat.oscpuat.gnp.com.mx',
    //COTIZADOR UNICO
    urlNegociosOperables: 'https://us-central1-gnp-auttarifasgmm-uat.cloudfunctions.net/',
    urlBase: 'https://gmm-cotizadores-uat.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-1',

    serviceBCA: 'https://bca-ws-uat.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',

    //Preguntas Secretas
    apiKey: 'l7xx14f3730ee0e849f1a0108359030ee9fb',
    consultaPreguntasSecretas: 'https://api-uat.oscpuat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://api-uat.oscpuat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://api-uat.oscpuat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://api-uat.oscpuat.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://api-uat.oscpuat.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    orquestadorOTPSinSesion:'https://app-inter-uat.gnp.com.mx/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://api-uat.oscpuat.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://api-uat.oscpuat.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://api-uat.oscpuat.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://gnp-accidentespersonales-uat.uc.r.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://api-uat.oscpuat.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-uat.appspot.com/",
    child: new MyApp(),

  );
  runApp(configuredApp);

}