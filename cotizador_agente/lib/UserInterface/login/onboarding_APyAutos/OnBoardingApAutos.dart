import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/utils/MobileContainerPage.dart';
import 'package:cotizador_agente/utils/TabletContainerPage.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

import '../../../main.dart';

bool useMobileLayout;
bool isPortrait = true;
class OnBoardingAppAutos extends StatefulWidget {
  @override
  _OnBoardingAppAutosState createState() => _OnBoardingAppAutosState();
}

class _OnBoardingAppAutosState extends State<OnBoardingAppAutos>  with SingleTickerProviderStateMixin {

  TabController _controller;
  int _selectedIndex;

  @override
  void initState() {
    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
      Inactivity(context:context).initialInactivity(functionInactivity);

    _controller = TabController(vsync: this, initialIndex: 0, length: 5);
    _controller.addListener(() {
      if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
        Inactivity(context:context).initialInactivity(functionInactivity);

      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
    // TODO: implement initState
    super.initState();
  }
  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return GestureDetector(
        onTap: () {
          if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
            Inactivity(context:context).initialInactivity(functionInactivity);
        },child:WillPopScope(
      onWillPop: () async => false,
      child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          responsiveMainTablet = Responsive.of(context);
          isPortrait = true;
        } else {
          responsiveMainTablet = Responsive.of(context);
          isPortrait = false;
        }
        return Container(
          child: Scaffold(
            backgroundColor: Theme.Colors.White,
            body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: _selectedIndex == 4 ? responsiveMainTablet.hp(95): responsiveMainTablet.hp(85),
                        color: Theme.Colors.White,
                        child: GestureDetector(
                                onTap: () {
                                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
                                    Inactivity(context:context).initialInactivity(functionInactivity);
                          },child: DefaultTabController(
                          length: 5,
                          child: TabBarView(
                              controller: _controller,
                              children: [
                                APyAutosOnboarding(responsiveMainTablet),
                                HerramientasVentas(responsiveMainTablet),
                                CoparteCotizaciones_Onboarding(responsiveMainTablet),
                                ActualizaTuPerfil_Onboarding(responsiveMainTablet),
                                CotizaTusNegocios_Onboarding(responsiveMainTablet)
                              ]
                          ),
                        )
                    )),
                    _selectedIndex != 4 ?  tabulador(responsiveMainTablet): Container(),
                  ],
                )
            ),
          ),
        );},
      ),
    ));
  }

  Widget tabulador(Responsive responsive){
    if(_controller.index==0){
      return Container(
        margin: EdgeInsets.only( left: responsive.wp(8), right: responsive.wp(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/primero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  sendTag("appinter_login_onboarding_omitir");

                  //TODO validar Dali
                  Vistas tipoVista;

                  tipoVista = Vistas.login;

                  Navigator.pop(context,true);
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  useMobileLayout = shortestSide < 600;

                  //prefs.setBool("userRegister", false);

                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){

                      Inactivity(context:context).cancelInactivity();

                  } else {
                    prefs.clear();

                    prefs.setBool("useMobileLayout", useMobileLayout);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                        useMobileLayout ?
                        MobileContainerPage(ParentView: Responsive.of(context),
                            vista: tipoVista)
                        // Todo Tablet
                            : TabletContainerPage(ParentView: Responsive.of(
                            context), vista: tipoVista,))

                    );
                  }

                },
                child: Text(
                  "Omitir",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.Colors.GNP,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.5)),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if(_controller.index==1){
      return Container(
        margin: EdgeInsets.only(left: responsive.wp(8), right: responsive.wp(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: Image.asset('assets/images/segundo.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  sendTag("appinter_login_onboarding_omitir");
                  Vistas tipoVista;
                  tipoVista = Vistas.login;

                  Navigator.pop(context,true);
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  useMobileLayout = shortestSide < 600;

                  //prefs.setBool("userRegister", false);

                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){

                  } else {
                    prefs.clear();

                    prefs.setBool("useMobileLayout", useMobileLayout);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                        useMobileLayout ?
                        MobileContainerPage(ParentView: Responsive.of(context),
                            vista: tipoVista)
                        // Todo Tablet
                            : TabletContainerPage(ParentView: Responsive.of(context),
                          vista: tipoVista,))

                    );
                  }

                },
                child: Text(
                  "Omitir",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.Colors.GNP,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.5)),
                ),
              ),

            )
          ],
        ),
      );
    }
    else if(_controller.index==2){
      return Container(
        margin: EdgeInsets.only(left: responsive.wp(8), right: responsive.wp(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: Image.asset('assets/images/tercero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  sendTag("appinter_login_onboarding_omitir");
                  Vistas tipoVista;
                  tipoVista = Vistas.login;

                  Navigator.pop(context,true);
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  useMobileLayout = shortestSide < 600;

                  //prefs.setBool("userRegister", false);

                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){

                  } else {
                    prefs.clear();

                    prefs.setBool("useMobileLayout", useMobileLayout);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                        useMobileLayout ?
                        MobileContainerPage(ParentView: Responsive.of(context),
                            vista: tipoVista)
                        // Todo Tablet
                            : TabletContainerPage(ParentView: Responsive.of(context),
                          vista: tipoVista,))

                    );
                  }

                },
                child: Text(
                  "Omitir",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.Colors.GNP,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.5)),
                ),
              ),

            )
          ],
        ),
      );
    }
    else if(_controller.index==3){
      return Container(
        margin: EdgeInsets.only(left: responsive.wp(8), right: responsive.wp(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: Image.asset('assets/images/cuarto.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  sendTag("appinter_login_onboarding_omitir");
                  Vistas tipoVista;
                  tipoVista = Vistas.login;

                  Navigator.pop(context,true);
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  useMobileLayout = shortestSide < 600;

                  //prefs.setBool("userRegister", false);

                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){

                  } else{
                    prefs.clear();

                    prefs.setBool("useMobileLayout", useMobileLayout);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => useMobileLayout ?
                        MobileContainerPage(ParentView: Responsive.of(context), vista: tipoVista)
                        // Todo Tablet
                            :  TabletContainerPage(ParentView: Responsive.of(context), vista: tipoVista,))

                    );
                  }



                },
                child: Text(
                  "Omitir",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.Colors.GNP,
                      fontWeight: FontWeight.normal,
                      fontSize: responsive.ip(2.5)),
                ),
              ),

            )
          ],
        ),
      );
    }
  }

  Widget APyAutosOnboarding(Responsive responsive){
    return  Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/ilustracion_es_2.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("¡Tu App Intermediario GNP\n te da la bienvenida!",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Cotiza tus negocios de Autos Individual,\n Motos, Micronegocio y Accidentes\n Personales.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.0) ),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget HerramientasVentas(Responsive responsive){

    return Container(
      color: Theme.Colors.White,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/senorde_traje_2.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Conoce las herramientas para\n potencializar tus ventas",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Genera cotizaciones, guárdalas y\n recupéralas desde el portal o la App\n ¡y mucho más!",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CoparteCotizaciones_Onboarding(Responsive responsive){

    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0.00),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/senorade_traje_2.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Comparte fácilmente\n tus cotizaciones",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Descarga las cotizaciones y/o envíalas\n directamente a tu Cliente desde tu dispositivo.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget ActualizaTuPerfil_Onboarding(Responsive responsive){

    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0.00),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/senora_telefono_2.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Actualiza tu perfil y\n personaliza tu App",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Agrega una foto y mantén siempre\n actualizados tus datos de contacto.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CotizaTusNegocios_Onboarding (Responsive responsive){
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(0.00),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: responsive.hp(4)),
                  child: Image.asset('assets/images/senores_telefono_2.png', fit:BoxFit.contain, height:responsive.hp(46), width: responsive.wp(90),)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: responsive.height * 0.03),
                  child: Text("Cotiza tus negocios al instante",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03, bottom: responsive.width * 0.08),
                child: Text("Cotiza de acuerdo al tipo de negocio de\n manera ágil desde tu celular o tablet.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              _selectedIndex == 4 ? Container(
                height: responsive.hp(6.25),
                width: responsive.wp(90),
                margin: EdgeInsets.only(
                    top: prefs.getBool("useMobileLayout")
                        ? responsive.height * 0.15
                        : isPortrait ? responsive.height * 0.15 :responsive.height * 0.05,
                    left: responsive.wp(4.4),
                    right: responsive.wp(4.4)),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  color: Theme.Colors.GNP,
                  onPressed: () async {
                    //TODO validar Dali
                    sendTag("appinter_login_onboarding_continuar");
                    Vistas tipoVista;
                    tipoVista = Vistas.login;

                    Navigator.pop(context,true);
                    var shortestSide = MediaQuery.of(context).size.shortestSide;
                    useMobileLayout = shortestSide < 600;
                    prefs.setBool("useMobileLayout", useMobileLayout);

                    //prefs.setBool("userRegister", false);

                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")){
                        Inactivity(context:context).cancelInactivity();

                    } else {
                      prefs.clear();

                      prefs.setBool("useMobileLayout", useMobileLayout);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                          useMobileLayout ?
                          MobileContainerPage(
                              ParentView: Responsive.of(context), vista: tipoVista)
                          // Todo Tablet
                              : TabletContainerPage(
                            ParentView: Responsive.of(context), vista: tipoVista,))
                
                      );
                    }


                  },
                  child: Text(
                    "CONTINUAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.Colors.White,
                      fontSize: responsive.ip(2.0),
                    ),
                  ),
                ),

              ): Container()
            ],
          ),
        ),
      ),
    );
  }

}
