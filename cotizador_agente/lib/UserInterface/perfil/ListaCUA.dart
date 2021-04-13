import 'package:cotizador_agente/UserInterface/perfil/perfiles.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
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
    print(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.Colors.backgroud,
      appBar: AppBar(
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
    data = SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            separacion(responsive,2),
            Text("Selecciona una opción", style: Tema.TextStyles.Funcional_Textos_Texto_sistema,),
            separacion(responsive,2),
            Container(
                margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5)),
                child: ListView.separated(
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
            separacion(responsive,10),
            Container(
                margin: EdgeInsets.only(left: responsive.wp(5), right: responsive.wp(5), bottom:responsive.hp(4) ),
                child: botonSeleccionarPregunta(responsive)),
          ],
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

  Widget PreguntaUno(Responsive responsive, String cua,int posicion){
    return  ListTile(
      //title:  Text("${cua} - ${nombre} ${apellido}",
      title:  Text("${cua}",
        style: TextStyle(
            letterSpacing: 0.16,
            fontWeight: FontWeight.normal,
            color: Tema.Colors.Azul_2
        ),
      ),
      leading: Radio<int>(
        value: posicion,
        focusColor: Tema.Colors.Azul_gnp,
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
            });
            if(widget.isDA){
              valorDA = widget.list.elementAt(_character);
              widget.callback(valorDA,widget.isDA);
            }else{
              posicionCUA = _character;
              valorCUA = datosPerfilador.intermediarios[_character];
              widget.callback(valorCUA,widget.isDA);
            }
            setState(() {
            });

            Navigator.pop(context,true);
          }

          //  Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarPreguntas(responsive: responsive,)),);
        }
    );
  }

}
