import 'package:cotizador_agente/UserInterface/login/SeleccionarPreguntas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import '../../utils/responsive.dart';

enum tipoDePregunta {respuestaUno, respuestaDos}

class PreguntasSecretas extends StatefulWidget {

  final Responsive responsive;
  const PreguntasSecretas({Key key, this.responsive}) : super(key: key);
  @override
  _PreguntasSecretasState createState() => _PreguntasSecretasState();
}


TextEditingController controllerRespuestaUno;
TextEditingController controllerRespuestaDos;

class _PreguntasSecretasState extends State<PreguntasSecretas> {

  bool _saving;
  bool respuestaUno;
  bool respuestaDos;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerPreguntaUno;
  TextEditingController controllerPreguntaDos;
  FocusNode focusPreguntaUno;
  FocusNode focusRespuestaUno;
  FocusNode focusPreguntaDos;
  FocusNode focusRespuestaDos;
  @override
  void initState() {
    _saving = false;
    respuestaUno = false;
    respuestaDos = false;
    controllerPreguntaUno = new TextEditingController();
    controllerRespuestaUno = new TextEditingController();
    controllerPreguntaDos = new TextEditingController();
    controllerRespuestaDos = new TextEditingController();
    focusPreguntaUno = new FocusNode();
    focusRespuestaUno = new FocusNode();
    focusPreguntaDos = new FocusNode();
    focusRespuestaDos = new FocusNode();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.Colors.backgroud,
        appBar: AppBar(
          backgroundColor: Tema.Colors.backgroud,
          elevation: 0,
          title: Text('Actualizar preguntas', style: TextStyle(
              color: Tema.Colors.Azul_2,
              fontWeight: FontWeight.normal,
              fontSize: widget.responsive.ip(2.5)
          ),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined,
              color: Tema.Colors.GNP,),
            onPressed: () {
              Navigator.pop(context,true);
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
    Widget data = Container();
    Form form;
    data = SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                separacion(responsive, 5),
                PreguntaSeguridadUno(responsive),
                separacion(responsive, 5),
                RespuestaSeguridadUno(responsive),
                separacion(responsive, 5),
                PreguntaSeguridadDos(responsive),
                separacion(responsive, 5),
                RespuestaSeguridadDos(responsive)
              ]
          ),
        )
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          Container(
            height: responsive.height,
            child: Opacity(
              opacity: 0.7,
              child: const ModalBarrier(dismissible: false, color: Tema.Colors.primary),
            ),
          ),
          new Center(
            child: Container(
                height: responsive.height*0.1,
                width: responsive.width* 0.2,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Tema.Colors.tituloTextoDrop),
                  child:   new CircularProgressIndicator(),
                )
            ),
          ),
        ],
      );
      l.add(modal);
    }
    return l;
  }

  Widget PreguntaSeguridadUno(Responsive responsive){
    return CupertinoButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive)),);
      },
      padding: EdgeInsets.zero,
      child: Container(

        child: TextFormField(
          enableInteractiveSelection: false,
          controller: controllerPreguntaUno,
          focusNode: focusPreguntaUno,
          obscureText: false,
          cursorColor: Tema.Colors.GNP,

          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.inputlinea),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Tema.Colors.inputlinea),
              ),
              labelText: "Pregunta de seguridad",
              labelStyle: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color: Tema.Colors.Azul_2,
                  letterSpacing: 0.16
              ),
              suffixIcon: IconButton(
                icon: Image.asset("assets/login/preguntasIconoFlecha.png"),
                color: Tema.Colors.VLMX_Navy_40,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive, typeResponse: tipoDePregunta.respuestaUno,)),);
                },
              )
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Este campo es requerido';
            } else {
              return null;
            }
          },
          onChanged: (value){
            setState(() {
              focusPreguntaUno.hasFocus;
              controllerPreguntaUno.text;
            });
          },
        ),
      ),
    );
  }

  Widget RespuestaSeguridadUno(Responsive responsive){
    return TextFormField(
      controller: controllerRespuestaUno,
      focusNode: focusRespuestaUno,
      obscureText: respuestaUno,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Respuesta",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2,
              letterSpacing: 0.16
          ),
          suffixIcon: IconButton(
            icon: respuestaUno == false || controllerRespuestaUno.text == "" ? Image.asset("assets/login/novercontrasena.png") : Image.asset("assets/login/vercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                respuestaUno = !respuestaUno;
              });
            },
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusRespuestaUno.hasFocus;
          controllerRespuestaUno.text;
        });
      },
    );
  }

  Widget PreguntaSeguridadDos(Responsive responsive){
    return TextFormField(
      controller: controllerPreguntaDos,
      focusNode: focusPreguntaDos,
      obscureText: false,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Pregunta de seguridad",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2,
              letterSpacing: 0.16
          ),
          suffixIcon: IconButton(
            icon: Image.asset("assets/login/preguntasIconoFlecha.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive, typeResponse: tipoDePregunta.respuestaDos,)),);
            },
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        } else {
          return null;
        }
      },
      onChanged: (value){
        setState(() {
          focusPreguntaDos.hasFocus;
          controllerPreguntaDos.text;
        });
      },
    );
  }

  Widget  RespuestaSeguridadDos(Responsive responsive){
    return TextFormField(
      controller: controllerRespuestaDos,
      focusNode: focusRespuestaDos,
      obscureText: respuestaDos,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Respuesta",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: Tema.Colors.Azul_2,
              letterSpacing: 0.16
          ),
          suffixIcon: IconButton(
            icon: respuestaDos == false || controllerRespuestaDos.text == "" ? Image.asset("assets/login/novercontrasena.png") : Image.asset("assets/login/vercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                respuestaDos = !respuestaDos;
              });
            },
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusRespuestaDos.hasFocus;
          controllerRespuestaDos.text;
        });
      },
    );
  }

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

}
