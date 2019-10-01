
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/modelo_asegurados.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';

import 'modelos_widgets.dart';
class SeccionDinamica extends StatefulWidget {
  SeccionDinamica({Key key, this.notifyParent, this.secc, this.i, this.end, this.cantidad_asegurados}) : super(key: key);

  final Seccion secc;
  final int end;
  final int i;
  final int cantidad_asegurados;
  final Function() notifyParent;


  @override
  _SeccionDinamicaState createState() => _SeccionDinamicaState();
}

class _SeccionDinamicaState extends State<SeccionDinamica> {

  final colorLetters = const Color(0xFF002E71);

  static List <Widget> _aseguradosList = <Widget>[];

  static int contador =0;



  @override
  void initState(){

  }



  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Solo es posible agregar "+ widget.cantidad_asegurados.toString() +" asegurados"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    void _decrementar(){
      setState(() {

          _aseguradosList.removeLast();
          widget.notifyParent();
      });
    }

    void _aumentar(){
      setState(() {
        if(_aseguradosList.length<=widget.cantidad_asegurados-1){
          _aseguradosList.add(
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Container(
                    width: double.infinity,
                    child: Text(
                      widget.secc.seccion,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorLetters,
                          fontSize: 16),
                    ),
                  ),


                  ListView.builder
                    (
                      itemCount: widget.secc.campos.length,
                      shrinkWrap: true,

                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new CampoDinamico(campo: widget.secc.campos[index]);
                      }
                  ),





                ]
            ),
          );
          widget.notifyParent();

        }else{
           _showDialog();
        }


      });
    }



    if(widget.i==2){

      if(_aseguradosList.isEmpty){
        _aseguradosList.add(
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  width: double.infinity,
                  child: Text(
                    widget.secc.seccion,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorLetters,
                        fontSize: 16),
                  ),
                ),


                ListView.builder
                  (
                    itemCount: widget.secc.campos.length,
                    shrinkWrap: true,

                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new CampoDinamico(campo: widget.secc.campos[index]);
                    }
                ),





              ]
          ),
        );

      }



      return Column(
        children: <Widget>[
        ListView.builder
      (
      itemCount: _aseguradosList.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext ctxt, int index) {
            return _aseguradosList[index];
          }
      ),


      Row(
            children: <Widget>[




              Expanded(
                flex: 2,
                child: FloatingActionButton(onPressed: _aumentar,
                  tooltip: "agrega beneficiario",
                  child: const Icon(Icons.add),


                ),
              ),
              Expanded(
                  flex: 6,
                  child: Text("Agregar Familiar")
              ),
              Expanded(
                flex: 2,
                child: FloatingActionButton(onPressed: _decrementar,
                  tooltip: "agrega beneficiario",
                  child: const Icon(Icons.delete),

                ),
              )

              //TODO: AQUI AGREGAR EL SEND

            ],
          ),
        ],
      );



    }else{
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(
              width: double.infinity,
              child: Text(
                widget.secc.seccion,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorLetters,
                    fontSize: 16),
              ),
            ),


            ListView.builder
              (
                itemCount: widget.secc.campos.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {
                  return new CampoDinamico(campo: widget.secc.campos[index]);
                }
            ),

          ]
      );

    }

  }
}

class CampoDinamico extends StatefulWidget {
  CampoDinamico({Key key, this.campo}) : super(key: key);

  final Campo campo;

  @override
  _CampoDinamicoState createState() => _CampoDinamicoState();
}

class _CampoDinamicoState extends State<CampoDinamico> {

  @override
  Widget build(BuildContext context) {

    switch (widget.campo.tipo_componente){
      case "select": {
        // statements;
        return ComboBoxDinamico(campo: widget.campo,);

      }

      case "textbox": {
        //statements;
        return TextFieldDinamico(titulo: widget.campo);

      }

      case "input": {
        //statements;
        return TextFieldDinamico(titulo: widget.campo);

      }

      case "checkbox": {
        //statements;
        return CheckBoxDinamico(campo: widget.campo);

      }

      case "calendar": {
        //statements;
        return CalendarioDinamicoRange();

      }

      case "button": {
        //statements;
        return BotonDinamicoBorde(titulo: widget.campo,);

      }

      default: {
        //statements;
        return Container();

      }
    }


  }
}

