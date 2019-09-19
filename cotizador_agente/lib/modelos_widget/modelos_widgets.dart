
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';



class ComboBoxDinamico extends StatefulWidget {

  ComboBoxDinamico({Key key, this.valores}) : super(key: key);

  final List <Valor>valores;



  @override
  _ComboBoxDinamicoState createState() => _ComboBoxDinamicoState();


}

class _ComboBoxDinamicoState extends State<ComboBoxDinamico> {

  String _currentCity;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: _currentCity,
      items: getDropDownMenuItems(),
      onChanged: changedDropDownItem,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange))),
    );



  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Valor v in widget.valores) {
      items.add(new DropdownMenuItem(
          value: v.id,
          child: new Text(v.descripcion.toString())
      ));
    }
    return items;
  }


  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }

  String getValor (){
    return _currentCity;
  }




}



