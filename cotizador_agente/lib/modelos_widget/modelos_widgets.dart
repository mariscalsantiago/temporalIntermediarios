import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/utils/validadores.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

////COMBOBOX
class ComboBoxDinamico extends StatefulWidget {
  ComboBoxDinamico({Key key, this.campo, this.agregarAlDiccionario})
      : super(key: key);

  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;

  @override
  _ComboBoxDinamicoState createState() => _ComboBoxDinamicoState();
}

class _ComboBoxDinamicoState extends State<ComboBoxDinamico> {
  @override
  void initState() {
    if (currentCity != null) {
      currentCity = widget.campo.valor;
    }

    //_currentCity = widget.campo.valor;
  }

  String currentCity;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.campo.visible,
      child: DropdownButtonFormField(
        value: widget.campo.valor,
        items: getDropDownMenuItems(),
        onChanged: changedDropDownItem,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange))),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Valor v in widget.campo.valores) {
      items.add(new DropdownMenuItem(
          value: v.descripcion, child: new Text(v.descripcion.toString())));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      currentCity = selectedCity;
      widget.campo.valor = selectedCity;
      print(widget.campo.valor);
      widget.agregarAlDiccionario(
          widget.campo.ID.toString(), widget.campo.valor);
    });
  }

  String getValor() {
    return currentCity;
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
    return Visibility(
      visible: widget.campo.visible,
      child: CheckboxGroup(
          labels: <String>[
            widget.campo.etiqueta,
          ],
          checkColor: Colors.white,
          activeColor: Colors.orange,
          onSelected: (List<String> checked) => print(checked.toString())),
    );
  }
}

//////

////CALENDARIO

class CalendarioDinamicoRange extends StatefulWidget {
  @override
  _CalendarioDinamicoRangeState createState() =>
      _CalendarioDinamicoRangeState();
}

class _CalendarioDinamicoRangeState extends State<CalendarioDinamicoRange> {
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: MaterialButton(
            color: Utilidades.sombra,
            onPressed: () async {
              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: new DateTime.now(),
                  initialLastDate:
                      (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: new DateTime(2015),
                  lastDate: new DateTime(2020));
              if (picked != null && picked.length == 2) {
                print(picked);
              }
            },
            child: Column(
              children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextFormField(
                  enableInteractiveSelection: false,
                  onTap: () { FocusScope.of(context).requestFocus(new FocusNode()); },
                decoration: InputDecoration(
                    labelText: 'Antigüedad'
                  ),
                ),
              ),
            ),
              ],
            )),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OutlineButton(
        textColor: Colors.orange,
        child: Text(widget.titulo.etiqueta),
        onPressed: () {},
        borderSide: BorderSide(
          color: Colors.orange, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 0.8, //width of the border
        ),
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
          fontWeight: FontWeight.normal, color: Colors.orange, fontSize: 16),
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
    if (widget.titulo.obligatorio) {
      return Visibility(
        visible: widget.titulo.visible,
        child: TextFormField(
          onSaved: (String value) {
            widget.titulo.valor = value;

            print("llegue al onsave " + widget.titulo.valor);
          },
          onChanged: (valor) {
            widget.titulo.valor = valor;
            print(widget.titulo.valor);
          },
          validator: (value) {
            print(value);
            print("dato lenght" + value.length.toString());
            print("dato longitud" + widget.titulo.dato_longitud.toString());
            if (value.isEmpty) {
              return "El campo no debe estar vacío";
            } else {
              //if(widget.titulo.validaLongitud(value.length)){
              if (true) {
                print("en teoria, esta ok");

                return null;
              } else {
                print("en teoria, fuera de rango");

                return "Esta fuera de rango";
              }
            }
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              labelStyle: TextStyle(color: Colors.grey),
              hintText: widget.titulo.etiqueta,
              labelText: widget.titulo.etiqueta),
        ),
      );
    }

    if (widget.titulo.tipo_dato == "integer") {
      return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            labelStyle: TextStyle(color: Colors.grey),
            hintText: widget.titulo.etiqueta,
            labelText: widget.titulo.etiqueta),
      );
    } else {
      return TextFormField(
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            labelStyle: TextStyle(color: Colors.grey),
            hintText: widget.titulo.etiqueta,
            labelText: widget.titulo.etiqueta),
      );
    }
  }
}

/////

////TextField

class TextFieldConRangoDinamico extends StatefulWidget with Validadores {
  TextFieldConRangoDinamico({Key key, this.titulo, this.agregarAlDiccionario})
      : super(key: key);
  final Campo titulo;
  final void Function(String, String) agregarAlDiccionario;

  @override
  _TextFieldConRangoDinamicoState createState() =>
      _TextFieldConRangoDinamicoState();
}

class _TextFieldConRangoDinamicoState extends State<TextFieldConRangoDinamico> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.titulo.visible,
      child: TextFormField(
        decoration: InputDecoration(
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          labelStyle: TextStyle(color: Colors.grey),
          hintText: widget.titulo.etiqueta,
          labelText: widget.titulo.etiqueta,
        ),
        onSaved: (String value) {
          print("llegue al onsave " + value);
          widget.agregarAlDiccionario(widget.titulo.nombre_campo, value);
        },
        validator: (value) {
          print(value);

          if (value.isEmpty) {
            print("En teoria, vacio");
            return "El campo no debe estar vacío";
          } else {
            if (double.parse(value) >
                    double.parse(widget.titulo.rango.rango_inicio) &&
                double.parse(value) <
                    double.parse(widget.titulo.rango.rango_fin)) {
              print("en teoria, esta ok");

              return null;
            } else {
              print("en teoria, fuera de rango");

              return "Esta fuera de rango";
            }
          }
        },
      ),
    );
  }
}

/////

////Card

class CardDinamico extends StatefulWidget {
  CardDinamico({Key key, this.campo}) : super(key: key);

  final List<Campo> campo;

  @override
  _CardDinamicoState createState() => _CardDinamicoState();
}

class _CardDinamicoState extends State<CardDinamico> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
      ),
    );
  }
}


class RenglonTablaDoscolumna extends StatefulWidget {
  final String titulo;
  final String valor;
  RenglonTablaDoscolumna({Key key, this.valor, this.titulo}) : super(key: key);
  @override
  _RenglonTablaDoscolumnaState createState() => _RenglonTablaDoscolumnaState();
}

class _RenglonTablaDoscolumnaState extends State<RenglonTablaDoscolumna> {
  @override



  Widget build(BuildContext context) {
    return Container(

      color: Utilidades.sombra,
      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

        Expanded(
        flex: 1,
        child: Column(

          children: <Widget>[

            Row(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Text(widget.titulo,style: TextStyle(
                      color: Utilidades.color_texto, fontWeight: FontWeight.normal, fontSize: 16),),),

                Expanded(
                  flex: 1,
                  child: Text(widget.valor,style: TextStyle(
                      color: Utilidades.color_texto, fontWeight: FontWeight.normal, fontSize: 16),),
                ),
              ],
            ),
          ],
        ),
        )
        ],
      ),
    );
  }
}

