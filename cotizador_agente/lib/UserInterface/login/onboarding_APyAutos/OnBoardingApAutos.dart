import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
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
import 'dart:async';

bool useMobileLayout;
bool isPortrait = true;
class OnBoardingAppAutos extends StatefulWidget {
  @override
  _OnBoardingAppAutosState createState() => _OnBoardingAppAutosState();
}

class _OnBoardingAppAutosState extends State<OnBoardingAppAutos>  with SingleTickerProviderStateMixin {

  TabController _controller;
  int _selectedIndex;
  int _NumController;

  @override
  void initState() {
    print("auto ${prefs.getBool("rolAutoscotizarActivo")}");
    print("showAP ${prefs.getBool("showAP")}");
    if(prefs.getBool("showAP") != null && prefs.getBool("rolAutoscotizarActivo")!=null && prefs.getBool("showAP") && prefs.getBool("rolAutoscotizarActivo")) {
      _NumController = 5;
    }else if(prefs.getBool("showAP") != null && prefs.getBool("showAP")){
      _NumController = 4;
    }else{
      _NumController = 5;
    }
    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
      Inactivity(context:context).initialInactivity(functionInactivity);

    _controller = TabController(vsync: this, initialIndex: 0, length: _NumController);
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

  List<Widget> createControllerView() {
    List<Widget> view;


    if(prefs.getBool("showAP") != null && prefs.getBool("rolAutoscotizarActivo")!=null && prefs.getBool("showAP") && prefs.getBool("rolAutoscotizarActivo")){

      view = [
        APyAutosOnboarding(responsiveMainTablet),
        HerramientasVentas(responsiveMainTablet),
        CoparteCotizaciones_Onboarding(responsiveMainTablet),
        ActualizaTuPerfil_Onboarding(responsiveMainTablet),
        CotizaTusNegocios_Onboarding(responsiveMainTablet)
      ];

    }else if(prefs.getBool("showAP") != null  && prefs.getBool("showAP")){

      view =  [
        APOnboarding(responsiveMainTablet),
        APHerramientasOnboarding(responsiveMainTablet),
        APCotizacionesOnboarding(responsiveMainTablet),
        APCotizaTusNegociosOnboarding(responsiveMainTablet)

      ];
    }else{
      view = [
        APyAutosOnboarding(responsiveMainTablet),
        HerramientasVentas(responsiveMainTablet),
        CoparteCotizaciones_Onboarding(responsiveMainTablet),
        ActualizaTuPerfil_Onboarding(responsiveMainTablet),
        CotizaTusNegocios_Onboarding(responsiveMainTablet)
      ];

    }
    return view;
  }
  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

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
                        height: _NumController == 5 && _selectedIndex == 4 ? responsiveMainTablet.hp(100): _NumController == 4 && _selectedIndex == 3 ? responsiveMainTablet.hp(100) : responsiveMainTablet.hp(85),
                        color: Theme.Colors.White,
                        child: GestureDetector(
                                onTap: () {
                                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil"))
                                    Inactivity(context:context).initialInactivity(functionInactivity);
                          },child: DefaultTabController(
                          length: _NumController,
                          child: TabBarView(
                              controller: _controller,
                              children: createControllerView()
                          ),
                        )
                    )),
                   _NumController == 5 ? _selectedIndex != 4 ?  tabulador(responsiveMainTablet): Container(): _selectedIndex != 3 ?  tabuladorAP(responsiveMainTablet): Container(),
                  ],
                )
            ),
          ),
        );},
      ),
    ));
  }

  Widget tabulador(Responsive responsive){
    print("_NumController: $_NumController");
    if(_controller.index==0){
      return Container(
        margin: EdgeInsets.only(left: responsive.wp(7), right: responsive.wp(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/primero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }

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
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }
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
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }
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
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }
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
  Widget tabuladorAP(Responsive responsive){
    print("_NumController: $_NumController");
    if(_controller.index==0){
      return Container(
        margin: EdgeInsets.only( left: responsive.wp(8), right: responsive.wp(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/onboarding_ap_uno.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }

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
                child: Image.asset('assets/images/onboarding_ap_dos.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }
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
                child: Image.asset('assets/images/onboarding_ap_tres.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
            Container(
              child: GestureDetector(
                onTap: () async {
                  //TODO validar Dali
                  if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                    sendTag("appinter_perfil_onboarding_omitir");
                  }else{
                    sendTag("appinter_login_onboarding_omitir");
                  }
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
                  child: Text("¡Tu App Intermediario GNP\nte da la bienvenida!",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Cotiza y emite de acuerdo al tipo\nde negocio de manera ágil desde tu\ncelular o tablet.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.1) ),
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
                  child: Text("Conoce las herramientas para\npotencializar tus ventas",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Genera cotizaciones, guárdalas y\nrecupéralas desde el portal o la App,\ncompleta tu solicitud digital\n¡y mucho más!",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.1) ),
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
                  child: Text("Comparte fácilmente\ntus cotizaciones",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Descarga las cotizaciones y/o envíalas\ndirectamente a tu Cliente desde tu\ndispositivo.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.1) ),
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
                  child: Text("Actualiza tu perfil y\npersonaliza tu App",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03),
                child: Text("Agrega una foto y mantén siempre\nactualizados tus datos de contacto.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.1) ),
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
                  child: Text("Emite tus negocios al instante",
                    style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.7) ),
                    textAlign: TextAlign.center,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.height * 0.03, bottom: responsive.width * 0.08),
                child: Text("Encuentra la información de tus Clientes,\nemite cualquier cotización al\nmomento de acuerdo a tu tipo de\nnegocio.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.1) ),
                  textAlign: TextAlign.center,),
              ),
              _selectedIndex == 4 ? Container(
                height: responsive.hp(6.25),
                width: responsive.wp(90),
                margin: EdgeInsets.only(
                    top: prefs.getBool("useMobileLayout")
                        ? responsive.height * 0.12
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
                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                      sendTag("appinter_perfil_onboarding_continuar");
                    }else{
                      sendTag("appinter_login_onboarding_continuar");
                    }
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


  Widget APOnboarding(Responsive responsive){
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
                child: Text("Cotiza Accidentes Personales desde tu \ncelular o tablet.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.0) ),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget APHerramientasOnboarding(Responsive responsive){

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
                child: Text("Genera cotizaciones de Accidentes \nPersonales al instante de manera ágil.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget APCotizacionesOnboarding(Responsive responsive){

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
                child: Text("Descarga las cotizaciones y/o envíalas\n directamente a tu Cliente desde tu\ndispositivo.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget APCotizaTusNegociosOnboarding(Responsive responsive){
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
                child: Text("Genera cotizaciones de Accidentes \nPersonales y concreta tu negocios.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              _selectedIndex == 3 ? Container(
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
                    if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil")) {
                      sendTag("appinter_perfil_onboarding_continuar");
                    }else{
                      sendTag("appinter_login_onboarding_continuar");
                    }
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
                          MobileContainerPage(ParentView: Responsive.of(context), vista: tipoVista)
                          // Todo Tablet
                              : TabletContainerPage(ParentView: Responsive.of(context), vista: tipoVista,))

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
