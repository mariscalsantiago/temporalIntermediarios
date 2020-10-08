
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';


class DropDownMaterialApoyoElement extends StatefulWidget {
  const DropDownMaterialApoyoElement({Key key, this.documento}) : super(key: key);

  @override
  _DropDownMaterialApoyoElementState createState() => _DropDownMaterialApoyoElementState();

  final Documento documento;

}

class _DropDownMaterialApoyoElementState extends State<DropDownMaterialApoyoElement> {


  //Inicializacion de pestaña
  bool estaAbierto = false;
  IconData icon = Icons.expand_more;




  //llamar para cerrar pestaña
  cerrar(){
    setState(() {
      estaAbierto = false;
      icon = Icons.expand_more;


    });

  }

  //llamar para abrir pestaña;
  abrir(){
    setState(() {
      estaAbierto = true;
      icon = Icons.expand_less;

    });

  }


  listener(){

    if(estaAbierto){
      cerrar();
    }else{
      abrir();
    }

  }

  _launchURL() async {
     String url = widget.documento.urlPDF;
    if (await canLaunch(url)) {
       launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[

        Row(

          children: <Widget>[

            Expanded(
              flex: 1,

              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(

                  children: <Widget>[
                    Expanded(
                      flex: 8,
                        child: Text(widget.documento.nombreDocumento, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Utilidades.color_primario),)),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        padding: EdgeInsets.all(20.0),
                        icon: Icon(icon, color: Utilidades.color_primario,),
                        onPressed: () {
                          listener();
                        },
                      ),
                    ),

                  ],
                ),
              ),

            ),

          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Divider( //002e71
                    thickness: 0.5,
                    color: Utilidades.color_titulo,
                    height: 0,
                  )),
            ),
          ],
        ),

        Visibility(
          visible: estaAbierto,
          child:Container(
            color: Utilidades.color_sombra,
            width: double.infinity,
            padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 8),
            child:  Text((widget.documento.descDocumento), maxLines: 10, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.0, color: Utilidades.color_titulo ), textAlign: TextAlign.left,),
          ),
        ),

        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Divider( //002e71
                    thickness: 0.5,
                    color: Utilidades.color_titulo,
                    height: 0,
                  )),
            ),
          ],
        ),

        Visibility(
          visible: estaAbierto,
          child:Container(
            color: Utilidades.color_sombra,
            width: double.infinity,
            padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 8),
            child:  Text((widget.documento.productos), maxLines: 10, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.0, color: Utilidades.color_titulo ), textAlign: TextAlign.left,),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Divider( //002e71
                    thickness: 0.5,
                    color: Utilidades.color_titulo,
                    height: 0,
                  )),
            ),
          ],
        ),

        Visibility(
          visible: estaAbierto,
          child:Container(
            color: Utilidades.color_sombra,
            width: double.infinity,
            padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 8),
            child: FlatButton(
              child: Text("Descargar documento"),
              onPressed: (){
                _launchURL();
              },
            )),
        ),

        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Divider( //002e71
                    thickness: 0.5,
                    color: Utilidades.color_titulo,
                    height: 0,
                  )),
            ),
          ],
        ),


      ],
    );







  }
}

