import 'package:flutter/services.dart';

import 'app_config.dart';
import '../main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = new AppConfig(
    ambient: Ambient.qa,
    serviceLogin: 'https://cuentas-qa.gnp.com.mx/auth/login',
    apikeyAppAgentes: 'l7xxfb568d77704046d0b5a80256fe00f829',
    service_perfilador: "https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/Consulta-Agentes/consulta-perfil-app-int",
    proyectId: 'gnp-accidentespersonales-qa',
    //urlNotifierService:'https://api-qa.oscp.gnp.com.mx',

    //COTIZADOR UNICO
    urlNegociosOperables: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/',
    urlBase: 'https://gmm-cotizadores-qa.gnp.com.mx/',
    urlSendAnalytics: 'https://www.google-analytics.com/',
    idContenedorAnalytics: 'UA-146126625-2',

    serviceBCA: 'https://bca-ws-qa.gnp.com.mx',
    apikeyBCA: 'd41d8cd98f00b204e9800998ecf8427e',

    //Preguntas Secretas
    apiKey: 'l7xx2fea6d294a6641438cde5681449e16dc',
    consultaPreguntasSecretas: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamientoProvee/intermediario/preguntas/',
    actualizarEstablecerPreguntasSecretas: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamientoProvee/intermediario/preguntas',
    cambioContrasenaPerfil: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamientoProvee/intermediario/password/',
    reestablecerContrasena: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamiento/admonUsuarios',
    consultaUsuarioPorCorreo: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=',
    orquestadorOTPSinSesion:'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/intermediario/enviarOtp/sinSesion',
    validaOTP: 'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/apr/otpLocalService/validateOtp/',
    consultarMedioContactosAgentes :'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/crm-personas/consulta-medios-contacto-agt-id?idAgente=',
    altaMediosContactoAgentes:'https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/crm-personas/alta-medios-contacto-evo',
    orquestadorOtpJwt:'https://gnp-accidentespersonales-uat.uc.r.appspot.com/intermediario/enviarOtp/me',
    consultaPersonaIdParticipante:"https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/CRM/ConsultaPersonaIdParticipante",
    cotizadorAutos: "https://gnp-appcontratacionautos-uat.uc.r.appspot.com/",
    servicioNuevoConsultaPorCorreo:"https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/aprAprovisionamientoProvee/intermediario/app/consulta-usuario-correo?email=",
    servicioNuevoDatosPerfil:"https://orquestador-otp-dot-gnp-accidentespersonales-qa.appspot.com/app/datos-perfil/",


    child: new MyApp(),
  );

  runApp(configuredApp);

}