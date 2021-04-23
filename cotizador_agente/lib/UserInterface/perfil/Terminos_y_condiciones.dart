
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';

bool checkedValue = false;

class TerminosYCondicionesPage extends StatefulWidget {
  Function callback;
  TerminosYCondicionesPage({Key key, this.callback}) : super(key: key);


  @override
  _TerminosYCondicionesPageState createState() => _TerminosYCondicionesPageState();
}

class _TerminosYCondicionesPageState extends State<TerminosYCondicionesPage> {


  @override
  void initState() {
    checkedValue = false;
  }

  double width = 300.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon:Icon(Icons.close, color: Theme.Colors.GNP,),
            onPressed: (){
              if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                prefs.setBool("activarBiometricos", false);
                widget.callback(false);
                Navigator.pop(context,true);
              } else {
                prefs.setBool("activarBiometricos", false);
                widget.callback(false);
                Navigator.pop(context,true);
                if(prefs.getBool("flujoCompletoLogin") != null && prefs.getBool("flujoCompletoLogin")){
                }else{
                  customAlert(AlertDialogType.verificaTuNumeroCelular, context, "",  "", responsive, widget.callback);
                }
              }
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
                        width: (responsive.width - 100),

                        child: Text("Términos y condiciones de uso",
                          style: TextStyle(fontSize: responsive.ip(3), color: Theme.Colors.Azul_2),
                        ),
                      ),
                      Image.asset("assets/icon/splash/logo.png", fit:BoxFit.contain,height:responsive.ip(15), width: responsive.ip(15),),
                      Container(
                        margin: EdgeInsets.only(left: responsive.wp(2.5), right: responsive.wp(2.5)),
                        child: Text.rich(
                            TextSpan(
                                text: 'Consentimiento para el tratamiento de uso de datos biométricos \n \n',
                                style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Grupo Nacional Provincial, S.A.B., ',
                                    style: TextStyle(fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold, color: Theme.Colors.letragris),
                                  ),
                                  TextSpan(
                                    text: 'con domicilio en Avenida Cerro de las Torres No. 395, Colonia Campestre Churubusco,'
                                        ' Código Postal 04200, Alcaldía Coyoacán, Ciudad de México, tratará sus datos personales'
                                        ' para que a través de su huella digital que previamente tenga configurada o disponible en el '
                                        'dispositivo electrónico que utilice, facilitar el acceso a determinadas aplicaciones o '
                                        'plataformas de GNP relacionadas con el desarrollo de sus actividades propias como agente,'
                                        ' sin que esto implique el resguardo o almacenamiento de este dato por parte de GNP. '
                                        'Puede consultar la versión integral del Aviso de Privacidad en ',
                                    style: TextStyle(fontSize: responsive.ip(1.65),fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),
                                  TextSpan(
                                    text: 'www.gnp.com.mx ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                  ),
                                  TextSpan(
                                    text: 'o en el teléfono ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),
                                  TextSpan(
                                    text: '(55) 5227 9000 ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                  ),
                                  TextSpan(
                                    text: 'a nivel nacional. \n \n',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),

                                  TextSpan(
                                    text: 'Al activar el uso de datos biométricos, reconozco que se ha puesto a mi disposición el ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),

                                  TextSpan(
                                    text: 'Aviso de Privacidad Integral de Grupo Nacional Provincial S. A. B. ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                  ),
                                  TextSpan(
                                    text: '(en adelante GNP), mismo que contiene y detalla las finalidades del tratamiento de los datos personales y'
                                        ' aceptó su tratamiento por parte de GNP. Asimismo se me informó que puedo consultar dicho aviso y sus actualizaciones'
                                        ' en cualquier momento en la página ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),
                                  TextSpan(
                                    text: 'www.gnp.com.mx ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                  ),

                                  TextSpan(
                                    text: 'o en el teléfono ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),
                                  TextSpan(
                                    text: '(55) 5227 9000 ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.GNP),
                                  ),

                                  TextSpan(
                                    text: 'a nivel nacional. En caso de haber proporcionado datos personales de otros titulares, reconozco haber cumplido con mi'
                                        ' obligación de informarles sobre su entrega, haber obtenido de forma previa el consentimiento de éstos para su tratamiento, '
                                        'así como haberles informado los lugares en los que se encuentra disponible el Aviso de Privacidad para su consulta. ',
                                    style: TextStyle(fontSize: responsive.ip(1.65), fontWeight: FontWeight.normal, color: Theme.Colors.letragris),
                                  ),
                                ]
                            )
                        ),
                      ),
                      Container(
                        //color: Theme.Colors.Azul_2,
                        //margin: EdgeInsets.only(left: responsive.wp(40), right: responsive.wp(4), top: responsive.hp(2)),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.all(0.0) ,
                          title: Text("Acepto los términos y condiciones de uso", style:TextStyle(color: Theme.Colors.Azul_2),),
                          activeColor: Theme.Colors.GNP,
                          value: checkedValue,
                          onChanged: (bool value) {
                            setState(() {
                              checkedValue = value;
                            });
                            prefs.setBool("aceptoTerminos", checkedValue);
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        ),
                      ),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            margin: EdgeInsets.only(top: responsive.hp(4), bottom: responsive.hp(3), right: responsive.wp(2.5), left: responsive.wp(2.5)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: (checkedValue) ?
                              Theme.Colors.GNP : Theme.Colors.botonlogin ,
                            ),
                            padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
                            width: responsive.width,
                            child: Text("Continuar", style: TextStyle(
                              color:  (checkedValue) ?
                              Theme.Colors.backgroud : Theme.Colors.botonletra,
                            ),
                                textAlign: TextAlign.center),
                          ),
                          onPressed: () async {
                            if(checkedValue){
                              Navigator.pop(context,true);
                              is_available_finger != false ?
                                customAlert(AlertDialogType.activacionExitosa_Huella, context, "", "", responsive, funcionAlerta) :
                                customAlert(AlertDialogType.activacionExitosa_Reconocimiento_facial, context, "", "", responsive, funcionAlerta);
                                setState(() {
                                  checkedValue = false;
                                });
                            }
                          }
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
