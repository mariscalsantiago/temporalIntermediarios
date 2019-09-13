



import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(title: 'GNP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


void changeView() {
  print('hellow');
}



class _MyHomePageState extends State<MyHomePage> {
  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;
  List _cities =
  ["Cluj-Napoca", "Bucuresti", "Timisoara", "Brasov", "Constanta"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;


  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-90.0, 0.0), Offset(90.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: colorHex,
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.adjust,
                    size: 10.0,
                    color: Colors.transparent,
                  ),
                  OutlineButton(
                    textColor: Colors.orange,
                    child: Text('COTIZACIONES GUARDADAS'),
                    onPressed: () {},
                    borderSide: BorderSide(
                      color: Colors.orange, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                  ),
                  Icon(
                    Icons.adjust,
                    size: 25.0,
                    color: Colors.transparent,
                  ),
                  Icon(
                    Icons.adjust,
                    size: 25.0,
                    color: Colors.transparent,
                  ),
                  Text(
                    'MÁS',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.orange,
                        fontSize: 16),
                  ),
                  Icon(Icons.more_vert, color: Colors.orange, size: 35.0),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.adjust,
                    size: 10.0,
                    color: Colors.transparent,
                  ),
                  Text(
                    'COTIZACIÓN',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: colorLetters,
                        fontSize: 19),
                  ),
                ],
              ),
            ),
            Container(
              color: colorHex,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Datos personales',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorLetters,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Planes',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: colorHex,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorLetters,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: colorHex,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Paso 1',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorLetters,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Paso 2',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),

              color: colorHex,
              width: double.infinity,

              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value: _currentCity,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange))),
                ),
              ),


            ),

            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
              child: Row(

                children: <Widget>[
                  Text("Renovación"),
                  Checkbox(
                    value: reNew,
                    onChanged: (bool value) {
                      setState(() {
                        reNew = value;
                      });
                    },
                  ),
                ],
              ),
            ),


            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),

              child: Row(

                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: Text(
                      'Datos del titular',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: colorLetters,
                          fontSize: 19),
                    ),

                  ),







                ],
              ),
            ),

          /*  Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
              child: Row(

                children: <Widget>[



                  Container(
                    child: Row(

                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: Text(
                              'Imagen1'
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(
                              'Imagen2'

                          ),

                        ),
                      ],

                    ),
                  ),

                  Container(
                    child: Row(

                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: Text(
                            'Hombre',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: colorLetters,
                                fontSize: 19),

                          ),

                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Mujer',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: colorLetters,
                                fontSize: 19),

                          ),

                        ),
                      ],

                    ),

                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                    child: Row(

                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Nombre'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24, bottom: 0),
                    child: Row(

                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Apellidos'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),












                ],
              ),

            ),

*/

            Container(
              margin: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 24, bottom: 0),
              child: Row(

                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Edad'
                      ),

                    ),

                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'C.P'),

                    ),

                  ),
                ],

              ),

            ),




          ],
        ),

      ),
    );
  }
}


