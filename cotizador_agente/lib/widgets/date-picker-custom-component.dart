import 'package:flutter/material.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:intl/intl.dart';

class DatePickerCustomComponent extends StatefulWidget {
  final String label;
  DateTime initialDate;
  final Future<DateTime> Function(BuildContext, DateTime) onShowPicker;
  final void Function(DateTime) onChanged;
  final void Function() onRemove;
  final String format;
  final Color primaryColor;

  DatePickerCustomComponent({
    @required this.label,
    @required this.initialDate,
    @required this.onShowPicker,
    @required this.onChanged,
    @required this.onRemove,
    this.format = 'dd-MM-yyyy',
    this.primaryColor,
  });

  @override
  _DatePickerCustomComponentState createState() =>
      _DatePickerCustomComponentState();
}

class _DatePickerCustomComponentState extends State<DatePickerCustomComponent> {
  Map<int, Color> materialColorMap;
  MaterialColor materialColor;


  @override
  void initState() {
    materialColorMap = {
        50: getPrimaryColor(widget.primaryColor, 0.1),
        100: getPrimaryColor(widget.primaryColor, 0.2),
        200: getPrimaryColor(widget.primaryColor, 0.3),
        300: getPrimaryColor(widget.primaryColor, 0.4),
        400: getPrimaryColor(widget.primaryColor, 0.5),
        500: getPrimaryColor(widget.primaryColor, 0.6),
        600: getPrimaryColor(widget.primaryColor, 0.7),
        700: getPrimaryColor(widget.primaryColor, 0.8),
        800: getPrimaryColor(widget.primaryColor, 0.9),
        900: getPrimaryColor(widget.primaryColor, 1)
      };

    materialColor = MaterialColor(widget.primaryColor.value, materialColorMap);

    super.initState();
  }

  Color getPrimaryColor(Color color, double opacity) {
     Color _color = color;
     //Color _color = color.withOpacity(opacity);
     return _color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: widget.initialDate != null
          ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                DateFormat(widget.format).format(widget.initialDate),
                style: TextStyle(
                    fontSize: 15, color: AppColors.color_texto_campo),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.all(0),
                width: 30,
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      widget.initialDate = null;
                      widget.onRemove();
                    });
                  },
                ),
              ),
            ])
          :  Column(children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: ThemeData(primarySwatch: materialColor),
                      child: new Builder(
                      builder: (context2) => new  FlatButton(
                        onPressed: () {
                          widget.onShowPicker(
                                context2,
                                widget.initialDate != null
                                    ? widget.initialDate
                                    : DateTime.now())
                            .then((DateTime context) {
                          setState(() {
                            widget.initialDate = context;
                            widget.onChanged(context);
                          });
                         });
                        },
                         child: Container(
                          height: 39,
                          child: Center(
                            child: Text(
                              widget.label,
                              style: TextStyle(fontSize: 15, color: widget.primaryColor),
                            ),
                          ),
                        ),
                      ),),
                    ),
                  ),
                ],
              ),
      decoration: BoxDecoration(
        border: Border.all(color: widget.primaryColor),
      ),
    );
  }
}
