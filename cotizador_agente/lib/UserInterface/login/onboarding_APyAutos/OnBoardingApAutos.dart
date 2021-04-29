import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;


class OnBoardingAppAutos extends StatefulWidget {
  @override
  _OnBoardingAppAutosState createState() => _OnBoardingAppAutosState();
}

class _OnBoardingAppAutosState extends State<OnBoardingAppAutos>  with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, initialIndex: 0, length: 5);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              height: responsive.height,
              color: Theme.Colors.None,
              child: DefaultTabController(
                length: 5,
                child: TabBarView(
                    controller: _controller,
                    children: [
                      APyAutosOnboarding(responsive),
                      HerramientasVentas(responsive),
                      CoparteCotizaciones_Onboarding(responsive),
                      ActualizaTuPerfil_Onboarding(responsive),
                      CotizaTusNegocios_Onboarding(responsive)
                    ]
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget APyAutosOnboarding(Responsive responsive){
    return  Scaffold(
      body: Center(
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
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/primero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateTo((4) );
                          setState(() {
                            _controller.index;
                          });

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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget HerramientasVentas(Responsive responsive){
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(0.00),
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
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/segundo.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateTo((4) );
                          setState(() {
                            _controller.index;
                          });
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CoparteCotizaciones_Onboarding(Responsive responsive){
    return Scaffold(
      body: Center(
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
                child: Text("Descarga las cotizaciones y/o envíalas\n directamente a tu\n Cliente desde tu dispositivo.",
                  style: TextStyle( color: Theme.Colors.Encabezados, fontSize: responsive.ip(2.2) ),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/tercero.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateTo((4) );
                          setState(() {
                            _controller.index;
                          });
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ActualizaTuPerfil_Onboarding(Responsive responsive){
    return Scaffold(
      body: Center(
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
              Container(
                margin: EdgeInsets.only(top: responsive.hp(9), left: responsive.wp(8), right: responsive.wp(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Image.asset('assets/images/cuarto.png', fit:BoxFit.contain, height:responsive.hp(10), width: responsive.wp(16),)),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateTo((4) );
                          setState(() {
                            _controller.index;
                          });
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
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget CotizaTusNegocios_Onboarding (Responsive responsive){
    return Scaffold(
      body: Center(
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
              Container(
                height: responsive.hp(6.25),
                width: responsive.wp(90),
                margin: EdgeInsets.only(
                    top: responsive.height * 0.15,
                    left: responsive.wp(4.4),
                    right: responsive.wp(4.4)),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  color: Theme.Colors.GNP,
                  onPressed: () {
                    Navigator.pop(context,true);

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

              )
            ],
          ),
        ),
      ),
    );
  }

}
