import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:introduction_screen/introduction_screen.dart';

List<PageViewModel> listPagesViewModel;

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    // TODO: implement initState
    biuldPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);

    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        // When done button is press
      },
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor:  Theme.Colors.gnpOrange,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
      showSkipButton: true,
      showNextButton : false,
      skip: const Text("Omitir"),
      done: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Theme.Colors.gnpOrange,
            ),
            padding: EdgeInsets.only(
                top: responsive.hp(2), bottom: responsive.hp(2)),
            width: responsive.width,
            child: Text("Continuar",
                style: TextStyle(
                  color: Theme.Colors.White,
                ),
                textAlign: TextAlign.center),
          ),
          onPressed: () {
            Navigator.pop(context,true);
          }),
    );
  }

  void biuldPages() {
    listPagesViewModel = [
      //AP_AUTOS
      PageViewModel(
        title:"¡Tu App Intermediario GNP\n te da la bienvenida!",
        body:"Cotiza tus negocios de Autos Individual,\n Motos, Micronegocio y Accidentes\n Personales.",
        image: Center(
            child:
                Image.asset("assets/images/ilustracion_es.png", height: 175.0)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Theme.Colors.Azul_gnp,  fontWeight: FontWeight.bold, fontSize: 20),
          bodyTextStyle: TextStyle( color: Theme.Colors.Azul_gnp,  fontSize: 15),
          pageColor: Colors.white,
        ),
      ),

      //Conoce las herramientas
      PageViewModel(
        title:"Conoce las herramientas para\n potencializar tus ventas",
        body:"Genera cotizaciones, guárdalas y\n recupéralas desde el portal o la App\n ¡y mucho más!",
        image: Center(child: Image.asset("assets/images/señorde_traje.png", height: 175.0)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Theme.Colors.Azul_gnp,  fontWeight: FontWeight.bold, fontSize: 20),
          bodyTextStyle: TextStyle( color: Theme.Colors.Azul_gnp,  fontSize: 15),
          pageColor: Colors.white,
        ),
      ),

      //Comparte fácilmente
      PageViewModel(
        title:"Comparte fácilmente\n tus cotizaciones",
        body:"Descarga las cotizaciones y/o envíalas\n directamente a tu\n Cliente desde tu dispositivo.",
        image: Center(child: Image.asset("assets/images/señorade_traje.png", height: 175.0)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Theme.Colors.Azul_gnp,  fontWeight: FontWeight.bold, fontSize: 20),
          bodyTextStyle: TextStyle( color: Theme.Colors.Azul_gnp,  fontSize: 15),
          pageColor: Colors.white,
        ),
      ),

      //ActualizaTuPerfil
      PageViewModel(
        title: "Actualiza tu perfil y\n personaliza tu App",
        body:"Agrega una foto y mantén siempre\n actualizados tus datos de contacto.",
        image: Center(child: Image.asset("assets/images/señora_telefono.png", height: 175.0)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Theme.Colors.Azul_gnp,  fontWeight: FontWeight.bold, fontSize: 20),
          bodyTextStyle: TextStyle( color: Theme.Colors.Azul_gnp,  fontSize: 15),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title:"Cotiza tus negocios al instante",
        body:"Cotiza de acuerdo al tipo de negocio de\n manera ágil desde tu celular o tablet.",
        image: Center(child: Image.asset("assets/images/señores_telefono.png", height: 175.0)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Theme.Colors.Azul_gnp,  fontWeight: FontWeight.bold, fontSize: 20),
          bodyTextStyle: TextStyle( color: Theme.Colors.Azul_gnp,  fontSize: 15),
          pageColor: Colors.white,
        ),
      ),
    ];
  }
}
