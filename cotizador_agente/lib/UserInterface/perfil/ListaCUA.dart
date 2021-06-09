import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;


class listaCUA extends StatefulWidget {
  final Function callback;
  final Responsive responsive;
  final List<String> list;
  final bool isDA;


  const listaCUA({Key key, this.responsive, this.list, this.isDA, this.callback}) : super(key: key);
  @override
  _listaCUAState createState() => _listaCUAState();
}

class _listaCUAState extends State<listaCUA> {

  bool _saving;
  int _character = 99999;

  @override
  void initState() {
    _saving = false;
    // TODO: implement initState
    if(widget.isDA){
      if(posicionDA!= null && posicionDA>=0)
      {
        _character = prefs!=null && prefs.getString("currentDA")!=null?widget.list.indexOf(prefs.getString("currentDA")):widget.list[0];
      }
    }else{
      if(posicionCUA!= null && posicionCUA>=0)
      {
        _character = prefs!=null && prefs.getString("currentCUA")!=null?widget.list.indexOf(prefs.getString("currentCUA")):widget.list[0];
      }
    }
    print(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.Colors.backgroud,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Tema.Colors.backgroud,
        elevation: 0,
        title: Text(widget.isDA ? 'DA' :'CUA', style: TextStyle(
            color: Tema.Colors.Azul_2,
            fontWeight: FontWeight.normal,
            fontSize: widget.responsive.ip(2.5)
        ),),
        leading: IconButton(
          icon: Icon(Icons.clear,
            color: Tema.Colors.GNP,),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
      ),
      body: Stack(
          children: builData(widget.responsive)
      ),
    );
  }

  List<Widget> builData(Responsive responsive){
    ScrollController scrollController =  new ScrollController();
    Widget data = Container();
    Form form;
    data = Container(
          height: responsive.height*0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  separacion(responsive,2),
                  Container(
                      margin: EdgeInsets.only(left: responsive.wp(7)),
                      child: Text("Selecciona una opción", style: TextStyle(
                          fontSize: responsive.ip(2.3),
                          fontWeight: FontWeight.normal,
                          color: Tema.Colors.fecha_1
                      ))
                  ),
                  separacion(responsive,6),
                   Container(
                     height: responsive.hp(67),
                        margin: EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(5)),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child:ListView.separated(
                          controller:scrollController,
                          scrollDirection:  Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, posicion) {
                            //return PreguntaUno(responsive,widget.list, datosPerfilador.agenteInteresadoList.elementAt(posicion).nombres,datosPerfilador.agenteInteresadoList.elementAt(posicion).apellidoPaterno ,posicion);
                            print(widget.list.elementAt(posicion));
                            return PreguntaUno(responsive,widget.list.elementAt(posicion),posicion);
                          },
                          separatorBuilder: (context, posicion) {
                            return separacion(responsive,1);
                          },
                          itemCount: widget.list.length,
                        )
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), bottom:responsive.hp(0)),
                  child: botonSeleccionarPregunta(responsive)),
            ],
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

  Widget PreguntaUno(Responsive responsive, String cua,int posicion){
    return  ListTile(
      //title:  Text("${cua} - ${nombre} ${apellido}",
      title:  GestureDetector(
        onTap: (){
          setState(() {
            print(posicion);
            _character = posicion;
            if(widget.isDA){
              posicionDA = posicion;
              valorDA = widget.list.elementAt(posicion);
            }else{
              posicionCUA = posicion;
              valorCUA = cua;
            }
          });
        },
        child: Text("${cua}",
          style: TextStyle(
              letterSpacing: 0.16,
              fontWeight: FontWeight.normal,
              color: Tema.Colors.Azul_2
          ),
        ),
      ),
      leading: Radio<int>(
        value: posicion,
        activeColor: Tema.Colors.Rectangle_PA,
        hoverColor: Tema.Colors.primary,
        groupValue: _character,
        onChanged: (int value) {
          setState(() {
            _character = value;
            if(widget.isDA){
              posicionDA = value;
              valorDA = widget.list.elementAt(value);

            }else{
              posicionCUA = value;
              valorCUA = cua;
            }
            print("_character ${_character}");
          });
        },
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
            setState(() {
            if(widget.isDA){
              valorDA = widget.list.elementAt(_character);
              prefs.setString("currentDA", widget.list.elementAt(_character));
              widget.callback(_character);
            } else {
              posicionCUA = _character;
              valorCUA = datosPerfilador.intermediarios[_character];
              prefs.setString("currentCUA",  widget.list.elementAt(_character).substring(0, widget.list.elementAt(_character).indexOf('-')));
              widget.callback();
            }
            });

            Navigator.pop(context,true);
          }

          //  Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: responsive,)),);
        }
    );
  }

}
