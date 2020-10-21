import 'dart:convert';

import 'package:cotizador_agente/ExternalCustomPackages/custom_circular_chart/flutter_circular_chart.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Strings.dart' as AppStrings;
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomsAppBars.dart'
    as AppBar;
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cotizador_agente/main.dart';


final GlobalKey<AnimatedCircularChartState> _chartKey =
    new GlobalKey<AnimatedCircularChartState>();


List<RamoItemChart> ramos = <RamoItemChart>[
];

List<CircularSegmentEntry> listTem = [];
List<CircularStackEntry> data;
SharedPreferences prefs;
int numPolizas=0;
int numClientes=0;


class ConsultationPage extends StatefulWidget {
  ConsultationPage({Key key}) : super(key: key);

  @override
  _ConsultationPageState createState() => new _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    listTem.clear();
    sendTag("ConsultaTusClientes_Page");
    refreshTotalPolizasClientes();
    for (int i = 0; ramos.length > i; i++) {
      setState(() {
        listTem.add(CircularSegmentEntry(
            ramos.elementAt(i).value + .0, ramos.elementAt(i).color,
            rankKey: ramos.elementAt(i).title));
      });
    }
    data = <CircularStackEntry>[
      new CircularStackEntry(
        listTem.toList(),
        rankKey: 'Total de polizas por ramo',
      ),
    ];
    if(mounted){
      setState(() {
        data;
      });
    }
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    String centerPolizas = " ";
    switch(numPolizas.toString().length){
      case 1 :
        centerPolizas = "\t\t\t"+numPolizas.toString();
        break;
      case 2 :
        centerPolizas = "\t\t"+numPolizas.toString();
        break;
      case 3 :
        centerPolizas = "\t"+numPolizas.toString();
        break;
      case 4 :
        centerPolizas = numPolizas.toString().substring(0,1)+","+numPolizas.toString().substring(1);
        break;
      case 5 :
      centerPolizas = numPolizas.toString().substring(0,2)+","+numPolizas.toString().substring(2);
      break;
      case 6 :
        centerPolizas = numPolizas.toString().substring(0,3)+","+numPolizas.toString().substring(3);
        break;
        case 7 :
        centerPolizas = numPolizas.toString().substring(0,1)+","+numPolizas.toString().substring(1,4)+","+numPolizas.toString().substring(4);;
        break;
        case 8 :
        centerPolizas = numPolizas.toString().substring(0,2)+","+numPolizas.toString().substring(2,5)+","+numPolizas.toString().substring(5);;
        break;
        case 9 :
        centerPolizas = numPolizas.toString().substring(0,3)+","+numPolizas.toString().substring(3,6)+","+numPolizas.toString().substring(6);;
        break;
      default:
        centerPolizas = numPolizas.toString();

    }
    return new SafeArea(
      child: Scaffold(
          appBar: AppBar.titleAndArrowBack(
              AppStrings.StringsMX.ConsultationTitle, context),
          body: Container(
            color: Theme.Colors.Background,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                MaterialButton(
                  color: Theme.Colors.White,
                  height: 48.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Theme.Icons.search,
                          size: 24,
                          color: Theme.Colors.Light,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.StringsMX.ConsultationSearchButton,
                          style: Theme.TextStyles.LightRegular14px,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/busquedaClientes");
                  },
                ),
                Container(child:AnimatedCircularChart(
                  key: _chartKey,
                  size: const Size(280.0, 280.0),
                  initialChartData: data,
                  holeRadius:120,
                  chartType: CircularChartType.Radial,
                  holeLabel: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: centerPolizas+'\n',
                        style: TextStyle(
                            color: Theme.Colors.Dark,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                      TextSpan(
                        text: '\t\tPólizas \n',
                        style: TextStyle(
                            color: Theme.Colors.DarkGray,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                      TextSpan(
                        text: numClientes.toString() +" Clientes",
                        style: TextStyle(
                            color: Theme.Colors.Light,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto"),
                      ),
                    ],
                  ),
                  //numPolizas.toString()+"  Pólizas \n"+ numClientes.toString() +" Clientes",
                  labelStyle: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ) ,
                margin: EdgeInsets.only(left: 72, right: 72),),
                Text(
                  "Total de pólizas por ramo",
                  style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: ramos.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return GetRamoItemChart(ramos.elementAt(index));
                      }),
                )
                // GetRamoItemChart(ramos.elementAt(3)),
              ],
            ),
          )),
    );
  }

  Widget GetRamoItemChart(RamoItemChart item) {
    return Container(
//      color: Colors.blue,
      child: Row(
       // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 14),
            width: 4,
            height: 20,
            color: item.color,
          ),
          Expanded(
            flex: 7,
            child: Text(item.title, style: Theme.TextStyles.DarkGrayRegular14px,),
          ),
          Expanded(
            flex: 3,
            child: Chip(
              backgroundColor: item.color,
              label: new Container(
                  width: 35,
                  child: Text(item.value.toString(),
                        style: Theme.TextStyles.WhiteMedium14px,
                      textAlign: TextAlign.center
              )),
            ),
          ),
        ],
      ),
    );
  }

}

class RamoItemChart {
  RamoItemChart({
    this.title,
    this.color,
    this.value,
  });

  String title;
  Color color;
  int value;
}

Future<Null> refreshTotalPolizasClientes() {
  printLog("Consulta_page","refresClientes");
  try{
    return
      getTotalPolizasClientes().then((_carrusel) {
        try{
          print("_carrusel");
          print(_carrusel);
          print(_carrusel["totalAgentes"].toString());
          print(_carrusel["total"].toString());
          print(_carrusel["gmm"].toString());
          print(_carrusel["vida"].toString());
          print(_carrusel["autos"].toString());
          print(_carrusel["danio"].toString());
          numClientes = _carrusel["totalAgentes"] !=null ? _carrusel["totalAgentes"]  : 0 ;
          numPolizas = _carrusel["total"] !=null ?  _carrusel["total"]  : 0;
          ramos.clear();
          ramos.add(new RamoItemChart(title: "Vida", color: Theme.Colors.VidaChart, value: _carrusel["vida"]!=null ? _carrusel["vida"] : 0 ));
          ramos.add(new RamoItemChart(title: "GMM", color: Theme.Colors.GmmChart, value: _carrusel[ "gmm"] !=null ? _carrusel[ "gmm"]:0 ));
          ramos.add(new RamoItemChart(title: "Autos", color: Theme.Colors.AutosChart, value: _carrusel["autos"] !=null ? _carrusel[ "autos"] : 0));
          ramos.add(new RamoItemChart(title: "Daños", color: Theme.Colors.DaniosChart, value: _carrusel["danio"] !=null ? _carrusel[ "danio"]: 0 ));
          //noClientes =_carrusel["totalAgentes"].toString();
          //noPolizas =_carrusel["numPolizas"].toString();

        } catch(e){
          print(e);
        }
      });
  }catch(e){
    print(e);
  }
}
Future<Map> getTotalPolizasClientes() async {
  prefs = await SharedPreferences.getInstance();
  Map datos = json.decode(prefs.getString('totalCientesPolizas'));
  print("getTotalPolizasClientes");
  print(datos);
  return datos;
}