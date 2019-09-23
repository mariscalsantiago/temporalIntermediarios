
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';

import 'modelos_widgets.dart';
class SeccionDinamica extends StatefulWidget {
  SeccionDinamica({Key key, this.secc, this.i, this.end, this.cantidad_asegurados}) : super(key: key);

  final Seccion secc;
  final int end;
  final int i;
  final int cantidad_asegurados;

  @override
  _SeccionDinamicaState createState() => _SeccionDinamicaState();
}

class _SeccionDinamicaState extends State<SeccionDinamica> {

  final colorLetters = const Color(0xFF002E71);
  List <bool> _estadoAsegurados;

  @override
  Widget build(BuildContext context) {

    @override
    void initState(){

      for (int i = 0 ; i<widget.cantidad_asegurados; i++ ){
        _estadoAsegurados.add(false);
      }
    }


    aumentar(){
      setState(() {

      });

    }


    if(widget.i>=widget.end-1){

      return Row(
        children: <Widget>[

          Expanded(
            flex: 2,
            child: FloatingActionButton(onPressed: aumentar(),
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
            child: FloatingActionButton(onPressed: aumentar(),
              tooltip: "agrega beneficiario",
              child: const Icon(Icons.delete),
            ),
          )

        ],
      );






    }else{


      List <Widget> ultimaSecc = <Widget>[];

      for (int i= 0; i<widget.cantidad_asegurados; i++){
        ultimaSecc.add(
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
            )
        );
      }


      return Column(
        children: ultimaSecc,
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

