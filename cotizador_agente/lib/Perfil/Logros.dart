import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/modelos/LoginModels.dart';

class LogrosTab extends StatefulWidget {
  @override
  LogrosTabState createState() => new LogrosTabState();
}

class LogrosTabState extends State<LogrosTab>{

  //String _currentCua;
  List<DropdownMenuItem<String>> _dropDownCUA;
  bool _loader ;
  String year="";

  void initState() {
   // sendTag("Perfil_Logros");
    // print("Logros" + datosPerfilador.intermediarios.toString());
    setState(() {
      _loader=false;
    });
   // _currentCua=datosPerfilador.intermediarios[0];
    _dropDownCUA = makeCUADropList();
    //_getData(_currentCua);
    _buildLogros();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _loader==true ? CircularProgressIndicator():

    Column(
      children: <Widget>[
        dropMenuCUA(),
        year == "" ? Container() : Container(
            margin: EdgeInsets.only(bottom: 32.0,top: 16.0) ,
            alignment: Alignment.center,
            child:  Text(year,style: Theme.TextStyles.DarkMedium18px)
        ),
        Expanded(
          child: _buildLogros(),
        )
      ],
    );
  }
  
  Widget dropMenuCUA(){
    return datosPerfilador.intermediarios.length > 1 ?
    Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          height: 72.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(Theme.Icons.cua,size: 16.0,),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Text("CUA", style: Theme.TextStyles.DarkGrayRegular14px
                      ),
                    )),
                Expanded(
                  flex: 6,
                  child:
                  Container(
                    padding: const EdgeInsets.only(left:24.0,right: 48.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: currentCuaLogros,
                      onChanged: (String selectedItem) {
                        if(selectedItem!=currentCuaLogros){
                          setState(() {
                              _loader =true;
                            //_getData(selectedItem);
                          });
                        }
                      },
                      items: _dropDownCUA,
                    ),
                  ),
                ),
              ],
            )
        ),
    ) : Container();
  }

  /*Future _getData(String newCUA) async {
    var response = await getPersonaMoral(newCUA,1);
    if(response!=null){
      currentCuaLogros = newCUA ;
      _buildLogros();
    }else{
      customAlert(AlertDialogType.mensajeGenericoError, context,
          "${mensajeStatus.title}", "${mensajeStatus.message}");
    }
    setState(() {
      _loader =false;
    });
  }*/

  List<DropdownMenuItem<String>> makeCUADropList() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in datosPerfilador.intermediarios) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i, style: Theme.TextStyles.DarkGrayRegular16px)));
    }
    return items;
  }


  Widget _buildLogros() {

    List<DatosLogros> logrosList = [];
    bool empty = false;

    if(datosMorales.logrosList.isNotEmpty) {
      for (DatosMoralesLogrosModel  i in  datosMorales.logrosList) {
        if (!i.congresoGanado.toString().contains('No se encontraron logros')) {
          String image = "";
          switch (i.congresoGanado) {
            case "AUTOS":
              image = "assets/img/logrosydesignaciones/logro_camp_autos.png";
              break;
            case "DESARROLLO":
              image =
              "assets/img/logrosydesignaciones/logro_camp_desarrollo.png";
              break;
            case "GMM":
              image = "assets/img/logrosydesignaciones/logro_camp_gmm.png";
              break;
            case "PYMES":
              image = "assets/img/logrosydesignaciones/logro_camp_pymes.png";
              break;
            case "VIDA":
              image = "assets/img/logrosydesignaciones/logro_camp_vida.png";
              break;
            case "CONSEJO":
              image = "assets/img/logrosydesignaciones/logro_consejo.png";
              break;
            case "DIAMANTE":
              image = "assets/img/logrosydesignaciones/logro_diamante.png";
              break;
            case "ORO":
              image = "assets/img/logrosydesignaciones/logro_oro.png";
              break;
            case "PLATINO":
              image = "assets/img/logrosydesignaciones/logro_platino.png";
              break;
            case "CAMPEON":
              if(i.ramo== "VIDA"){
                image = "assets/img/logrosydesignaciones/logro_camp_vida.png";
              }else if(i.ramo == "GM"){
                image = "assets/img/logrosydesignaciones/logro_camp_gmm.png";
              }else if(i.ramo == "PYMES"){
                image = "assets/img/logrosydesignaciones/logro_camp_pymes.png";
              }else if(i.ramo== "DESARROLLO"){
                image = "assets/img/logrosydesignaciones/logro_camp_desarrollo.png";
              }else if(i.ramo == "AUTOS"){
                image = "assets/img/logrosydesignaciones/logro_camp_autos.png";
              }else{
                image = "assets/img/logrosydesignaciones/logro_sin.png";
              }
              break;
          }
          logrosList.add(DatosLogros(image,
              i.congresoGanado,
              i.anio.toString(),
              i.ramo,
              i.competencia,
              i.lugar.toString()));
          year=i.anio.toString();
          
        } else {
          logrosList.add(DatosLogros("assets/img/logrosydesignaciones/logro_sin.png", "", "", "", "", ""));
        }
      }
    }else{
      empty=true;
      logrosList.add(DatosLogros("assets/img/logrosydesignaciones/logro_sin.png", "", "", "", "", ""));
    }
    return empty !=true  ? Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
          children:  logrosList.map<Widget>((DatosLogros logro) {
            return Container(
                child: LogrosItem(
                  logro: logro,
                ));
          }).toList()
      ),
    ):Center (child: Container(
      height: 216,
      width: 200,
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/logrosydesignaciones/logro_sin.png",),
            ),
          ),
          //margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.5 ),
      ),
    );

  }

}

class DatosLogros {
  DatosLogros(
      this.image, this.tier, this.year, this.title, this.event, this.place);

  String image;
  String tier;
  String year;
  String title;
  String event;
  String place;
}

class LogrosItem extends StatelessWidget {
  LogrosItem({Key key, @required this.logro})
      : assert(logro != null),
        super(key: key);
  final DatosLogros logro;

  @override
  Widget build(BuildContext context) {
    return  Column(
            children: <Widget>[
              Container(
                height: 66.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(logro.image),
                    fit: BoxFit.fill,
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.5 ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: logro.tier != "" && logro.tier != "CAMPEON"?
                  Text(
                      "Torneo "+logro.title, textAlign: TextAlign.center,
                      style: Theme.TextStyles.DarkGrayRegular12px)
                  : Container()
                )
              ),

            ],
          );
  }
}

























































