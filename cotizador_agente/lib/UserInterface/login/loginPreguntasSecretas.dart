import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/SeleccionarPreguntas.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/login/login_codigo_verificacion.dart';
import 'package:cotizador_agente/flujoLoginModel/consultaPreguntasSecretasModel.dart';
import 'package:cotizador_agente/flujoLoginModel/orquestadorOTPModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
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

TextEditingController controllerPreguntaUno;
TextEditingController controllerPreguntaDos;
TextEditingController controllerRespuestaUno;
TextEditingController controllerRespuestaDos;

class _PreguntasSecretasState extends State<PreguntasSecretas> {

  bool _saving;
  bool respuestaUno;
  bool respuestaDos;
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusPreguntaUno.dispose();
    focusRespuestaUno.dispose();
    focusPreguntaDos.dispose();
    focusRespuestaDos.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

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
    data = new Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                  RespuestaSeguridadDos(responsive),
                  separacion(responsive, 5),
                  enviar(responsive)
                ]
            ),
          )
      ),
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


  Widget PreguntaSeguridadUno(Responsive responsive){
    return CupertinoButton(
      onPressed: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive, )),);
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
                borderSide: BorderSide(color: Tema.Colors.Rectangle_PA),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: controllerPreguntaUno.text != "" ? BorderSide(color: Tema.Colors.Rectangle_PA) :
                BorderSide(color: Tema.Colors.inputlinea),
              ),
              labelText: "Pregunta de seguridad",
              labelStyle: focusPreguntaUno.hasFocus || controllerPreguntaUno.text != "" ?
              TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color:  Tema.Colors.Rectangle_PA,
                  letterSpacing: 0.16
              ):
              TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                  fontSize: responsive.ip(2),
                  color:  Tema.Colors.Azul_2,
                  letterSpacing: 0.16
              ),
              suffixIcon: IconButton(
                  icon: focusPreguntaUno.hasFocus || controllerPreguntaUno.text != "" ? Image.asset("assets/login/preguntasIconoFlecha.png", color: Tema.Colors.Rectangle_PA,):  Image.asset("assets/login/preguntasIconoFlecha.png"),
                  color:  Tema.Colors.VLMX_Navy_40,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive, typeResponse: tipoDePregunta.respuestaUno,)),);
                  },
              ),
          ),
          validator: (value) {
            print("PreguntaSeguridadUno ${value}");
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
            icon: respuestaUno == false || controllerRespuestaUno.text == "" ?
            Image.asset("assets/login/vercontrasena.png") : Image.asset("assets/login/novercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                respuestaUno = !respuestaUno;
              });
            },
          )
      ),
      validator: (value) {
        print("RespuestaSeguridadUno ${value}");
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
            borderSide: BorderSide(color: Tema.Colors.Rectangle_PA),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: controllerPreguntaDos.text != "" ? BorderSide(color: Tema.Colors.Rectangle_PA) :
            BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Pregunta de seguridad",
          labelStyle: focusPreguntaDos.hasFocus || controllerPreguntaDos.text != "" ?
          TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color:  Tema.Colors.Rectangle_PA,
              letterSpacing: 0.16
          ):
          TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color:  Tema.Colors.Azul_2,
              letterSpacing: 0.16
          ),
          suffixIcon: IconButton(
            icon: focusPreguntaDos.hasFocus || controllerPreguntaDos.text != "" ?
            Image.asset("assets/login/preguntasIconoFlecha.png", color: Tema.Colors.Rectangle_PA,):  Image.asset("assets/login/preguntasIconoFlecha.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: widget.responsive, typeResponse: tipoDePregunta.respuestaDos,)),);
            },
          )
      ),
      validator: (value) {
        print("PreguntaSeguridadDos ${value}");
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
      onTap: (){
        setState(() {
          focusPreguntaDos.hasFocus;
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
            icon: respuestaDos == false || controllerRespuestaDos.text == "" ? Image.asset("assets/login/vercontrasena.png") : Image.asset("assets/login/novercontrasena.png") ,
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                respuestaDos = !respuestaDos;
              });
            },
          )
      ),
      validator: (value) {
        print("ResouestaSeguridadDos ${value}");
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

  Widget enviar(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          color: controllerPreguntaUno .text != "" && controllerPreguntaDos.text != "" && controllerRespuestaUno.text != "" && controllerRespuestaDos.text != "" ?
          Tema.Colors.GNP : Tema.Colors.botonlogin,
          margin: EdgeInsets.only(top: responsive.hp(12), bottom: responsive.hp(3)),
          width: responsive.width,
          child: Container(
            margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
            child: Text( "ACTUALIZAR", style: TextStyle(
                color: controllerPreguntaUno .text != "" && controllerPreguntaDos.text != "" && controllerRespuestaUno.text != "" && controllerRespuestaDos.text != ""
                    ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async {
          if(_formKey.currentState.validate()){
            setState(() {
              _saving = true;
            });
            consultaPreguntasSecretasModel  actualizarPreguntas = await actualizarPreguntaSecretaServicio(context, datosUsuario.idparticipante, prefs.getString("contraenaActualizada"), controllerPreguntaUno.text,controllerRespuestaUno.text ,controllerPreguntaDos.text, controllerRespuestaDos.text);

            if(actualizarPreguntas != null){

              setState(() {
                _saving = false;
              });
              if(actualizarPreguntas.requestStatus == "SUCCEEDED" ){

                customAlert(AlertDialogType.preguntasSecretasActualizadas, context, "",  "", responsive, funcionAlertaCodVerificacion);
              } else {
                customAlert(AlertDialogType.errorServicio, context, "",  "", responsive, funcionAlerta);
              }
            } else {

              setState(() {
                _saving = false;
              });

            }
          }
        }
    );
  }

  void funcionAlerta(){

  }

  void funcionAlertaCodVerificacion (Responsive responsive) async{

    setState(() {
      _saving=true;
    });
    OrquestadorOTPModel optRespuesta = await  orquestadorOTPServicio(context, prefs.getString("correoUsuario"), prefs.getString("medioContactoTelefono"), false);

    setState(() {
      _saving = false;
    });

    if(optRespuesta != null){
      if(optRespuesta.error == "" && optRespuesta.idError == "") {
        prefs.setString("idOperacion", optRespuesta.idOperacion);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginCodigoVerificaion(
                      responsive: responsive,
                      isNumero: false,
                    )
            )
        );
      } else{

        customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
      }
    } else{
      customAlert(AlertDialogType.errorServicio, context, "",  "", responsive,funcionAlerta);
    }

  }

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

}
