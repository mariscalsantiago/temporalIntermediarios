
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';



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