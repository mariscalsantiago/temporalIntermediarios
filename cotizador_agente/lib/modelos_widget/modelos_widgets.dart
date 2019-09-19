
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


////CALENDAR SIN RANGE

class CalendarioDinamico extends StatefulWidget {

  CalendarioDinamico({Key key, this.antiguedad}) : super(key: key);
  final Campo antiguedad;
  @override
  _CalendarioDinamicoState createState() => _CalendarioDinamicoState();
}

class _CalendarioDinamicoState extends State<CalendarioDinamico> {

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );



  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2019, 2, 10): [
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );



  @override
  Widget build(BuildContext context) {
    DateTime _currentDate = DateTime(2019, 2, 3);

    return Container(

      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);
        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
        customDayBuilder: (   /// you can provide your own build function to make custom day containers
            bool isSelectable,
            int index,
            bool isSelectedDay,
            bool isToday,
            bool isPrevMonthDay,
            TextStyle textStyle,
            bool isNextMonthDay,
            bool isThisMonthDay,
            DateTime day,
            ) {
          /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
          /// This way you can build custom containers for specific days only, leaving rest as default.

          // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
          if (day.day == 15) {
            return Center(
              child: Icon(Icons.local_airport),
            );
          } else {
            return null;
          }
        },
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );

  }

  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2019, 2, 25),
        new Event(
          date: new DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));
    super.initState();
  }


}



////CALENDARIO CON RANGE

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
        child: new Text("Pick date range")
    );
  }


}
