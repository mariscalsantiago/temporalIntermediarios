
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:frideos_core/frideos_core.dart';



class ComboBox {
  final int ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Valor>valores;
  String _currentCity;
  String currentState;




  ComboBox({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});


  Widget getWidget(){

    DropdownButtonFormField(
      value: getDropDownMenuItems()[0],
      items: getDropDownMenuItems(),
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange))),
    );

  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Valor v in this.valores) {
      items.add(new DropdownMenuItem(
          value: v.id,
          child: new Text(v.descripcion.toString())
      ));
    }
    return items;
  }


  void changedDropDownItem(String selectedCity) {
      _currentCity = selectedCity;

  }



}

class TextBox{


  final int ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Campo>valores;
  String _textLbChng;


  TextBox({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});



  Widget prettyTextBox(){
    getText();
    TextFormField(
        decoration: InputDecoration(
        labelText: _textLbChng

      ),
    );

  }

  void changeHoldName(String textLabel){

    _textLbChng = textLabel;
  }

  getText(){

    for (Campo v in this.valores) {

      changeHoldName(v.nombre_campo);
    }
  }
}

class Calendar{
  final int ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Campo>valores;
  String _textLbChng;


  Calendar({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});
}

class Select{

  final int ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Campo>valores;
  String _textLbChng;


  Select({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});
}

class CheckBox{

  final int ID;
  final String etiqueta;
  final bool obligatorio;
  final String nombre_campo;
  final String tipo_dato;
  final String tipo_componente;
  final bool visible;
  final String regla;
  final List <Campo>valores;
  String _textLbChng;
  bool reNew = false;

  CheckBox({this.ID, this.etiqueta, this.obligatorio, this.nombre_campo,
    this.tipo_dato, this.tipo_componente, this.visible, this.regla,
    this.valores});


  Widget prettyCheckBox(){

    /*
    Checkbox(
    value: reNew,
    onChanged: (bool value) {
    setState(() {
    reNew = value;
        });
      },
    );
*/
  }
}




