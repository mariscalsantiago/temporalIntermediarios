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
    service_perfilador: "https://app-inter-uat.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: "gnp-accidentespersonales-uat",
    // urlNotifierService:'https://api-uat.oscpuat.gnp.com.mx',
    //COTIZADOR UNICO
    urlNegociosOperables: 'https://app-inter-uat.gnp.com.mx/COT_CF_ConsultaNegocioCanal',
    urlBase: 'https://gmm-cotizadores-uat.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-1',

    serviceBCA: 'https://bca-ws-uat.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',

    //Preguntas Secretas
    apiKey: 'l7xx14f3730ee0e849f1a0108359030ee9fb',
    consultaPreguntasSecretas: 'https://app-inter-uat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://app-inter-uat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://app-inter-uat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://app-inter-uat.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://app-inter-uat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=',
    orquestadorOTPSinSesion:'https://app-inter-uat.gnp.com.mx/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://app-inter-uat.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://app-inter-uat.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://app-inter-uat.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://gnp-accidentespersonales-uat.uc.r.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://app-inter-uat.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-uat.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://app-inter-uat.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
    servicioNuevoDatosPerfil:"https://app-inter-uat.gnp.com.mx/app/datos-perfil/",

    child: new MyApp(),

  );
  runApp(configuredApp);

}