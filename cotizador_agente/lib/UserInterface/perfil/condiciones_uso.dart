
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/loginActualizarContrasena.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:url_launcher/url_launcher.dart';

bool _checkedValue = false;


class CondicionesPage extends StatefulWidget {
  Responsive responsive;
  Function callback;
  CondicionesPage({Key key, this.responsive, this.callback}) : super(key: key);


  @override
  _CondicionesPageState createState() => _CondicionesPageState();
}

class _CondicionesPageState extends State<CondicionesPage> {


  @override
  void initState() {
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    _checkedValue = false;


  }
  @override
  dispose() {
    super.dispose();
  }

  void functionConnectivity() {
    setState(() {});
  }

  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {

    Responsive responsive = Responsive.of(context);
    return  SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon:Icon(Icons.close, color: Theme.Colors.GNP,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.Colors.White,
          ),
          body: Container(
            color: Theme.Colors.White,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: prefs.getBool("useMobileLayout") ? EdgeInsets.only(right: responsive.wp(14.5), left: responsive.wp(14.5)): EdgeInsets.only(right: responsive.wp(20), left: responsive.wp(20)),
                          width: (responsive.width - 100),

                          child: Text("Condiciones de uso", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: responsive.ip(2.2), color: Theme.Colors.Azul_2,),
                          ),
                        ),
                        Image.asset("assets/icon/splash/logo.png", fit:BoxFit.contain,height:responsive.ip(15), width: responsive.ip(15),),
                        Container(
                          height: responsive.hp(52.5),
                          margin: EdgeInsets.only(left: responsive.wp(2.5), right: responsive.wp(2.5)),
                          child: SingleChildScrollView(
                            child: Text.rich(
                                TextSpan(
                                    text: 'Anexo de Prevenci??n de Lavado de Dinero y Protecci??n de Datos \n \n',
                                    style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: 'Se agregan al Convenio de Comisi??n Mercantil celebrado con Usted, las siguientes Cl??usulas: \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Prevenci??n Lavado de Dinero. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Con motivo de las actividades objeto del presente documento, las Partes aceptan estar sujetas a lo dispuesto por la Ley '
                                            'Federal para la Prevenci??n e identificaci??n de Operanciones con Recursos de Procendecia il??cita, las Disposiciones de car??cter '
                                            'general a que se refiere el art??culo 492 de la Ley de Instituciones de Seguros y de Finanzas y/o dem??s disposiciones en materia de prevenci??n, detecci??n y reporte '
                                            'de operaciones vinculadas con los delitos de Operaciones con Recursos de Procedencia il??cita y de Terrorismo y su financiamiento '
                                            'por lo que ',
                                        style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'El Agente ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'acepta que es su obligaci??n: \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'a) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Aplicar las Pol??ticas de Identificaci??n y Conocimiento del Cliente que ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        text: 'La Instituci??n ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        text: 'pondr?? a su disposici??n (en adelante ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: '"Politica"',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: '). \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        text: 'b) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Recabar y actualizar toda la informaci??n y documentaci??n prevista en la Pol??tica y entregarla a la ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),

                                      TextSpan(
                                        text: 'La Instituci??n. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'c) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Reportar de inmediato al correo ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("gnp");
                                          launch('mailto:cumplimiento@gnp.com.mx');},
                                        text: 'cumplimiento@gnp.com.mx ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),
                                      TextSpan(
                                        text: 'y con atenci??n al Oficial de Cumplimiento, cualquier comportamiento u operaci??n en la que existan indicios o certeza de que los recursos utilizados o la persona involucrada pudiesen estar vinculados con alguna actividad il??cita, aportando para tales efectos toda la informaci??n, datos, circunstancias o hechos relacionados. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'd) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Comunicar y hacer cumplir las obligaciones de la presente cl??usula a sus ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Recursos ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'o personal que tenga a su cargo para dar cumplimiento a las actividades objeto del presente documento. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'La Instituci??n ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'podr?? realizar auditor??as o requerir informaci??n a ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'El Agente ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: ', previo aviso por escrito, que acredite el cumplimiento de las obligaciones antes mencionadas. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Protecci??n de datos Personales. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Las Partes aceptan que est??n sujetas a lo dispuesto por la Ley Federal de Protecci??n de Datos Personales en Posesi??n de los Particulares, su Reglamento, lineamientos y dem??s disposiciones que de aqu??lla emanen (en adelante y en su conjunto ???Legislaci??n???). \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'LAS PARTES transferir??n, en el ??mbito de sus respectivas obligaciones consignadas en ??ste instrumento, datos personales de los titulares oblig??ndose a: \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'a) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Poner a disposici??n del titular su Aviso de Privacidad. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'b) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Realizar la transferencia de los datos personales, garantizando las medidas de seguridad ??ptimas para proteger la informaci??n de los titulares. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'c) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Contar con medidas de seguridad, f??sicas, t??cnicas y administrativas suficientes para salvaguardar la confidencialidad e integridad de los datos personales transferidos entre s??. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'd) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Garantizar la privacidad y el derecho de la autodeterminaci??n informativa de los titulares de los Datos de conformidad con las disposiciones legales relacionadas con la Protecci??n de Datos Personales en Posesi??n de los Particulares. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'e) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Cumplir las solicitudes que ejerza cada Titular de Datos Personales, de conformidad con las acciones, recursos y/o derechos establecidos en la Legislaci??n. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'f) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Responder frente al titular de los Datos, la autoridad en materia de Protecci??n de Datos y las partes afectadas por el incumplimiento a las presentes obligaciones. \n \n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'g) ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Conocer  el contenido de la Legislaci??n y se obligan a cumplir con todas sus disposiciones. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Las partes se obligan a comunicarse cualquier vulneraci??n de seguridad de Datos Personales ocurridas en cualquier fase del tratamiento. En caso de una vulneraci??n tal como; fuga, robo, publicaci??n no autorizada o acceso no autorizado a los Datos Personales, ya sea sospecha de Incidente o un Incidente probado y/ o cualquier otra que ponga en riesgo la integridad y/o resguardo de datos personales, LA PARTE responsable de dicha vulneraci??n, deber?? hacer del conocimiento tal situaci??n, as?? como, las acciones de mitigaci??n, administrativa, legal y/o procesal que haya aplicado, lo antes posible, dentro de un plazo que no exceder?? de 72 horas posteriores al conocimiento de la vulneraci??n. Todas las notificaciones relacionadas con alg??n Incidente  de Datos Personales deber?? hacerse a los siguientes correos, y no se tendr?? por notificado en tanto no cuenten con la confirmaci??n de recibido: \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'GNP: A trav??s del ??rea de Contralor??a mediante el correo electr??nico ',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        recognizer: new TapGestureRecognizer()..onTap = () {
                                          print("gnp");
                                          launch('mailto:riesgo.operativo@gnp.com.mx');},
                                        text: 'riesgo.operativo@gnp.com.mx. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                      ),
                                      TextSpan(
                                        text: 'Todo intercambio de informaci??n digital v??a internet, deber?? realizarse mediante archivos protegidos con contrase??a, enviando la contrase??a correspondiente en correo diverso al que contenga dicho archivo. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'LA PARTE que haya sido responsable de cualquier afectaci??n,  asume la obligaci??n de indemnizar y mantener a salvo y sacar en paz a la parte afectada, sus accionistas, empleados, funcionarios, colaboradores, o representantes y a sus empresas subsidiarias y afiliadas de cualquier responsabilidad derivada de cualquier clase de queja, denuncia, reclamaci??n, acci??n, demanda, responsabilidad, p??rdida, da??o, costo, cargo, honorarios de abogados o de cualquier otra clase de gastos que pueda sufrir o incurrir en cualquier tiempo por raz??n ante cualquier autoridad competente, que resulte de cualquier incumplimiento, ya sea parcial o total, a cualquiera de sus obligaciones derivadas del presente documento o de la Legislaci??n vigente de Datos Personales. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Ambas partes se obligan a presentar el d??a de la firma del presente acuerdo, una p??liza de seguro que cubra cualquier incidencia sobre el tratamiento de los Datos Personales. \n\n',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                      ),
                                      TextSpan(
                                        text: 'Grupo Nacional Provincial S. A. B.',
                                        style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                      ),
                                    ]
                                )
                            ),
                          ),
                        ),
                        Container(
                          //color: Theme.Colors.Azul_2,
                          //margin: EdgeInsets.only(left: responsive.wp(40), right: responsive.wp(4), top: responsive.hp(2)),
                          child: Container(
                             margin:prefs.getBool("useMobileLayout") ? EdgeInsets.only(left: responsive.wp(2),right: responsive.wp(2)) : EdgeInsets.only(left: responsive.wp(18),right: responsive.wp(18)),
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0.0),
                              title: Text("ACEPTO LAS CL??USULAS ANEXAS",textAlign: TextAlign.start, style:TextStyle(color: Theme.Colors.Azul_2, fontSize: responsive.ip(1.8),),),
                              activeColor: Theme.Colors.GNP,
                              value: _checkedValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _checkedValue = value;
                                  prefs.setBool("aceptoTerminos", _checkedValue);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: responsive.hp(1), bottom: responsive.hp(1), right: responsive.wp(2.5), left: responsive.wp(2.5)),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: (_checkedValue) ?
                                  Theme.Colors.GNP : Theme.Colors.botonlogin ,
                                ),
                                padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
                                width: responsive.width,
                                child: Text("CONTINUAR", style: TextStyle(
                                  fontSize: responsive.ip(1.8),
                                  color:  (_checkedValue) ?
                                  Theme.Colors.backgroud : Theme.Colors.botonletra,
                                ),
                                    textAlign: TextAlign.center),
                              ),
                              onPressed: () async {
                                if(_checkedValue) {
                                  prefs.setBool("aceptoCondicionesDeUso", true);
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginActualizarContrasena(responsive: responsive,))).then((value) {
                                   // validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

                                  });
                                } else {
                                  prefs.setBool("aceptoCondicionesDeUso", false);
                                }

                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void funcionAlerta(){

  }
}
