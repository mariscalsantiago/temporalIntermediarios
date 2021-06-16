import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;

class ListaRamosPage extends StatefulWidget {
  Responsive responsive;
  List<String> lista;
  Function callback;
  ListaRamosPage({Key key, this.responsive, this.lista, this.callback}) : super(key: key);
  @override
  _ListaRamosPageState createState() => _ListaRamosPageState();
}

class _ListaRamosPageState extends State<ListaRamosPage> {
  int _character = 99999;
  bool _saving;

  @override
  void initState() {
    Inactivity(context:context).initialInactivity(functionInactivity);
    validateIntenetstatus(context,widget.responsive,functionConnectivity);
    _saving = false;
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
  Widget build(BuildContext context) {
    return   GestureDetector(
        onTap: (){
      Inactivity(context:context).initialInactivity(functionInactivity);
    },child:WillPopScope(
    onWillPop: () async => false,
    child: SafeArea(
      child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar: AppBar(
            backgroundColor: Tema.Colors.backgroud,
            elevation: 0,
            title: Text('Ramo', style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontWeight: FontWeight.normal,
                fontSize: widget.responsive.ip(2.5)
            ),),
            leading: IconButton(
              icon: Icon(Icons.close ,
                color: Tema.Colors.GNP,),
              onPressed: () {
                Inactivity(context:context).cancelInactivity();
                // handleUserInteraction(context,CallbackInactividad);
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
              children: builData(widget.responsive)
          )
      ),
    )));
  }

  List<Widget> builData(Responsive responsive){
    ScrollController scrollController =  new ScrollController();
    Widget data = Container();
    Form form;
    data = Column(
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
        SingleChildScrollView(
          controller: scrollController,
          child: Container(
            height: responsive.hp(64),
              margin: EdgeInsets.only(left: responsive.wp(2), right: responsive.wp(5)),
              child: ListView.separated(
                controller:scrollController,
                scrollDirection:  Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.lista.length,
                itemBuilder: (context, posicion) {
                  return ramos(responsive, widget.lista.elementAt(posicion),posicion);
                },
                separatorBuilder: (context, posicion) {
                  return separacion(responsive,1);
                },

              )
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), bottom:responsive.hp(1) , top: responsive.hp(4)),
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

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  Widget ramos(Responsive responsive, String pregunta, int posicion){
    return  ListTile(
      title:  GestureDetector(
        onTap: (){
          setState(() {
            _character=posicion;
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
            //handleUserInteraction(context,CallbackInactividad);
            setState(() {
              _character = value;
            });
          },
        ),
      ),
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
          //handleUserInteraction(context,CallbackInactividad);
          if(_character != 99999){
            print("lista -> ${widget.lista[_character]}");
            print("indice ${_character}");
            Navigator.pop(context);
            widget.callback(_character);
          }
        }
    );
  }

  void CallbackInactividad(){
    setState(() {
      print("CallbackInactividad listaRamosPage");
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //handleUserInteraction(context,CallbackInactividad);
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }
}
