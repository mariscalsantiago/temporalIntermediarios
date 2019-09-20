
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';


////COMBOBOX
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


////CHECKBOX

class CheckBoxDinamico extends StatefulWidget {

  CheckBoxDinamico({Key key, this.campo}) : super(key: key);
  final Campo campo;

  @override
  _CheckBoxDinamicoState createState() => _CheckBoxDinamicoState();
}


class _CheckBoxDinamicoState extends State<CheckBoxDinamico> {



  @override
  Widget build(BuildContext context) {

    if (widget.campo.visible == true){

      return  CheckboxGroup(
          labels: <String>[
            widget.campo.etiqueta,

          ],

          checkColor: Colors.white,
          activeColor: Colors.orange,
          onSelected: (List<String> checked) => print(checked.toString())


      );

    }else{

      return null;

    }
  }
}

//////


////CALENDARIO

class CalendarioDinamicoRange extends StatefulWidget {
  @override
  _CalendarioDinamicoRangeState createState() => _CalendarioDinamicoRangeState();
}

class _CalendarioDinamicoRangeState extends State<CalendarioDinamicoRange> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(

        color: Colors.deepOrangeAccent,
        onPressed: () async {
          final List<DateTime> picked = await DateRagePicker.showDatePicker(
              context: context,
              initialFirstDate: new DateTime.now(),
              initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
              firstDate: new DateTime(2015),
              lastDate: new DateTime(2020)
          );
          if (picked != null && picked.length == 2) {
            print(picked);
          }
        },
        child:  TextFormField(
        decoration: InputDecoration(
        labelText: 'Input JSON'
      ),
    );
  }


}


////


////BOTON BORDE

class BotonDinamicoBorde extends StatefulWidget {

  BotonDinamicoBorde({Key key, this.titulo}) : super(key: key);
  final Campo titulo;

  @override
  _BotonDinamicoStateBorde createState() => _BotonDinamicoStateBorde();
}

class _BotonDinamicoStateBorde extends State<BotonDinamicoBorde> {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: Colors.orange,
      child: Text(widget.titulo.toString()),
      onPressed: () {},
      borderSide: BorderSide(
        color: Colors.orange, //Color of the border
        style: BorderStyle.solid, //Style of the border
        width: 0.8, //width of the border
      ),
    );
  }
}

////

////BOTON SIN BORDE

class BotonDinamicoSinBorde extends StatefulWidget {
  BotonDinamicoSinBorde({Key key, this.titulo}) : super(key: key);
  final Campo titulo;
  @override
  _BotonDinamicoSinBordeState createState() => _BotonDinamicoSinBordeState();
}

class _BotonDinamicoSinBordeState extends State<BotonDinamicoSinBorde> {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: Colors.orange,
      color: Colors.orange,
      child: Text(widget.titulo.toString()),
      onPressed: () {},
    );
  }
}


////Text

class TextoGenericoDinamico extends StatefulWidget {
  TextoGenericoDinamico({Key key, this.texto}) : super(key: key);
  final Campo texto;
  @override
  _TextoGenericoDinamicoState createState() => _TextoGenericoDinamicoState();
}

class _TextoGenericoDinamicoState extends State<TextoGenericoDinamico> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.texto.toString(),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.orange,
          fontSize: 16),
    );
  }
}

/////

////TextField


class TextFieldDinamico extends StatefulWidget {
  TextFieldDinamico({Key key, this.titulo}) : super(key: key);
  final Campo titulo;
  @override
  _TextFieldDinamicoState createState() => _TextFieldDinamicoState();
}

class _TextFieldDinamicoState extends State<TextFieldDinamico> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: widget.titulo.toString()
      ),
    );
  }
}


/////

////Card

class CardDinamico extends StatefulWidget {

  CardDinamico({Key key, this.campo}) : super(key: key);

  final List <Campo>campo;
  @override
  _CardDinamicoState createState() => _CardDinamicoState();
}

class _CardDinamicoState extends State<CardDinamico> {
  @override
  Widget build(BuildContext context) {
    return  Card(
        child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
    onTap: () {
    print('Card tapped.');
    },
    ),
    );
}
