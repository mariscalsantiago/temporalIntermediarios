
import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';

import 'modelos_widgets.dart';
class SeccionDinamica extends StatefulWidget {
  SeccionDinamica({Key key, this.secc}) : super(key: key);

  final Seccion secc;
  @override
  _SeccionDinamicaState createState() => _SeccionDinamicaState();
}

class _SeccionDinamicaState extends State<SeccionDinamica> {

  final colorLetters = const Color(0xFF002E71);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

    Text(
    widget.secc.seccion,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorLetters,
          fontSize: 16),
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
        return ComboBoxDinamico(valores: widget.campo.valores,);

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

