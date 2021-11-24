import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.prod,
    serviceLogin: 'https://cuentas.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    service_perfilador: "https://app-inter.gnp.com.mx/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: 'gnp-accidentespersonales-pro',
    // urlNotifierService:'https://api.service.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://app-inter.gnp.com.mx/COT_CF_ConsultaNegocioCanal',
    urlBase: 'https://gmm-cotizadores.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-29272127-16',

    serviceBCA: 'https://bca-ws.gnp.com.mx',
    apikeyBCA: '9a780a70-c5fc-4bee-86cf-5650cce16516',

    //Preguntas Secretas
    apiKey: 'COLOCAR APIKEY GNP_Flutter_AppInter',
    consultaPreguntasSecretas: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://app-inter.gnp.com.mx/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=',
    orquestadorOTPSinSesion:'https://app-inter.gnp.com.mx/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://app-inter.gnp.com.mx/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://app-inter.gnp.com.mx/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://app-inter.gnp.com.mx/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://gnp-accidentespersonales-uat.uc.r.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://app-inter.gnp.com.mx/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-uat.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://app-inter.gnp.com.mx/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
    servicioNuevoDatosPerfil:"https://app-inter.gnp.com.mx/app/datos-perfil/",

    child: new MyApp(),

  );

  runApp(configuredApp);
}