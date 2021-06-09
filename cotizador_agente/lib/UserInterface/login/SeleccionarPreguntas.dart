import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/UserInterface/login/loginPreguntasSecretas.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;


List <String> preguntas = [
  "¿Cuál es el apodo de tu mejor amigo?",
  "¿Cuál fue el nombre de tu primera mascota?",
  "¿Cuál es el nombre de tu escuela primaria?",
  "¿De qué marca fue tu primer auto?",
  "¿Cuál es tu deporte favorito?",
  "¿Cuál es tu país favorito?",
  "¿Cuál es el nombre de tu primer novio (a)?",
  "¿Cuál es tu canción favorita?",
  "¿Cuál es el nombre de tu comida favorita?",
  "¿Cuál fue tu primer viaje al extranjero?",
  "¿Cuál es tu fecha de aniversario de bodas?",
  "¿Cuál es tu héroe favorito de la infancia?",
  "¿Cuál es el nombre de tu mejor amigo (a)?",
  "¿Cuál es el nombre de tu artista favorito?",
  "¿Cuál es tu color favorito?",
  "¿Cuál es tu sabor de helado favorito?",
  "¿Cuál es tu equipo favorito de futbol?",
  "¿Cuál es tu marca favorita de autos?",
  "¿Cuál es el nombre de tu restaurante favorito?",
 "¿Cuál es tu película favorita?",
];


class SeleccionarPreguntas extends StatefulWidget {
  final tipoDePregunta typeResponse;
  final Responsive responsive;
  final Function callback;
  const SeleccionarPreguntas({Key key, this.responsive, this.typeResponse, this.callback}) : super(key: key);
  @override
  _SeleccionarPreguntasState createState() => _SeleccionarPreguntasState();
}

class _SeleccionarPreguntasState extends State<SeleccionarPreguntas> {

  bool _saving;
  int _character = 99999;

  @override
  void initState() {
    _character = 99999;
    _saving = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar:_saving  ? null : AppBar(
            backgroundColor: Tema.Colors.backgroud,
            elevation: 0,
            title: Text('Pregunta de seguridad', style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontWeight: FontWeight.normal,
                fontSize: widget.responsive.ip(2.5)
            ),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close ,
                color: Tema.Colors.GNP,),
              onPressed: () {
                Navigator.pop(context);
                widget.callback();
                widget.callback();
              },
            ),
          ),
          body: Stack(
              children: builData(widget.responsive)
          )
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    ScrollController scrollController =  new ScrollController();
    Widget data = Container();
    Form form;
    data =  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: responsive.wp(8), top: responsive.hp(4), bottom: responsive.hp(2)),
              child: Text("Selecciona una opción", style: TextStyle(
                 fontWeight: FontWeight.normal,
                 fontSize: responsive.ip(2.4),
                 color:  Tema.Colors.fecha_1,
                 letterSpacing: 0.5
                ),
              ),
            ),
             Container(
               height: widget.responsive.hp(64),
                margin: EdgeInsets.only(left: responsive.wp(2), right: responsive.wp(5)),
                child: SingleChildScrollView(
                    controller: scrollController,
                    child:ListView.separated(
                  controller:scrollController,
                  scrollDirection:  Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, posicion) {
                    return PreguntaUno(responsive,preguntas.elementAt(posicion),posicion);
                  },
                  separatorBuilder: (context, posicion) {
                    return separacion(responsive,1);
                  },
                  itemCount: preguntas.length,
                )
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), bottom:responsive.hp(2), top:responsive.hp(2)  ),
                child: botonSeleccionarPregunta(responsive)),
          ],
        );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          LoadingController(

          )
        ],
      );
      l.add(modal);
    }
    return l;
  }

  Widget PreguntaUno(Responsive responsive, String pregunta, int posicion){
    return  ListTile(
      title:  GestureDetector(
        onTap: (){
          setState(() {
            _character = posicion;
          });
        },
        child: Text(pregunta,
          style: TextStyle(
              letterSpacing: 0.16,
              fontWeight: FontWeight.normal,
              color: Tema.Colors.Azul_2,
              fontSize: responsive.ip(2)
          ),
        ),
      ),
      leading: Transform.scale(
        scale: 1.5,
        child: Radio<int>(
          value: posicion,
          activeColor: Tema.Colors.Rectangle_PA,
          groupValue: _character,
          onChanged: (int value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ),
    );
  }


  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }


  Widget botonSeleccionarPregunta(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: (_character != 99999) ?
            Tema.Colors.GNP : Tema.Colors.botonlogin ,
          ),
          padding: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
          width: responsive.width,
          child: Text("SELECCIONAR", style: TextStyle(
            color:  (_character != 99999) ?
            Tema.Colors.backgroud : Tema.Colors.botonletra,
          ),
              textAlign: TextAlign.center),
        ),
        onPressed: () async {
          if(_character != 99999){
            if( widget.typeResponse == tipoDePregunta.respuestaUno ){
              controllerPreguntaUno.text = preguntas[_character];
            } else{
              controllerPreguntaDos.text = preguntas[_character];
            }
            Navigator.pop(context);
            widget.callback();
          }
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: responsive,)),);
        }
    );
  }
}
