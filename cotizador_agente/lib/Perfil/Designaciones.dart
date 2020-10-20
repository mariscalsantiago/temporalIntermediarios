import 'package:cotizador_agente/vistas/Inicio/LoginServices.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';

class Designaciones extends StatefulWidget {
  Designaciones({Key key}): super(key: key);

  @override
  DesignacionesState createState() => new DesignacionesState();
}

class DesignacionesState extends State<Designaciones>{

  //String _currentCua;
  List<DropdownMenuItem<String>> _dropDownCUA;
  bool _loader ;

  void initState() {
    sendTag("Perfil_Designaciones");
    setState(() {
      _loader=false;
    });
   // _currentCua=datosPerfilador.intermediarios[0];
    _dropDownCUA = makeCUADropList();
   // _buildData(_currentCua);
    _buildDesignacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loader==true ? CircularProgressIndicator():

    Column(
      children: <Widget>[
        dropMenuCUA(),
        Container(
            margin: EdgeInsets.only(top: 24.0) ,
            alignment: Alignment.center,
            child:  Text("Última",style: Theme.TextStyles.DarkMedium18px)
        ),
        Expanded(
          child:
          Container(
              child:_buildDesignacion()),
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
                    value: currentCuaDesignaciones,
                    onChanged: (String selectedItem) {
                      if(selectedItem!=currentCuaDesignaciones){
                        setState(() {
                          setState(() {
                            _loader =true;
                            _buildData(selectedItem);
                          });
                        }
                        );
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

  List<DropdownMenuItem<String>> makeCUADropList() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in datosPerfilador.intermediarios) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i, style: Theme.TextStyles.DarkGrayRegular16px)));
    }
    return items;
  }

  String last() {
    String Ruta = "";
    String designacion = "";
    var valor = datosMorales.designaciones.desginacinesList.firstWhere((l) => l.valor , orElse: () => null );

    if(valor != null){
      designacion = valor.designacion;
    }

    if(datosMorales.designaciones.desginacinesList != null && datosMorales.designaciones.desginacinesList.isNotEmpty){
      if(designacion != null && designacion != "") {
        switch (designacion) {
          case "APS":
            Ruta = "assets/img/logrosydesignaciones/aps.png";
            break;
          case "AISP":
            Ruta = "assets/img/logrosydesignaciones/aisp.png";
            break;
          case "APSS":
            Ruta = "assets/img/logrosydesignaciones/apss.png";
            break;
          case "MSP":
            Ruta = "assets/img/logrosydesignaciones/msp.png";
            break;
          case "MDRT":
            Ruta = "assets/img/logrosydesignaciones/mdrt.png";
            break;
          case "COT":
            Ruta = "assets/img/logrosydesignaciones/cot.png";
            break;
          case "TOT":
            Ruta = "assets/img/logrosydesignaciones/tot.png";
            break;
          case "CLI":
            Ruta = "assets/img/logrosydesignaciones/cli.png";
            break;
          case "FSS":
            Ruta = "assets/img/logrosydesignaciones/fss.png";
            break;
          case "LUTC":
            Ruta = "assets/img/logrosydesignaciones/lutc.png";
            break;
        }
      }
    }
    return Ruta;
  }

  Future _buildData(String newCUA) async{
    var response = await getPersonaMoral(newCUA,2);
    if(response!=null){
      currentCuaDesignaciones = newCUA ;
      _buildDesignacion();
    }else{
      customAlert(AlertDialogType.mensajeGenericoError, context,
          "${mensajeStatus.title}", "${mensajeStatus.message}");
    }

    setState(() {
      _loader =false;
    });
  }


  Widget _buildDesignacion() {

    List<Container> ListIdeas = List<Container>();
    List<Container> ListAmarican = List<Container>();
    List<Container> ListMdrt = List<Container>();
    if(datosMorales.designaciones.desginacinesList  != null && datosMorales.designaciones.desginacinesList.isNotEmpty){
      for(int i =0; i < datosMorales.designaciones.desginacinesList.length; i++ ){
        switch (datosMorales.designaciones.desginacinesList[i].designacion) {
          case "APS":
            if(datosMorales.designaciones.desginacinesList[i].valor ){
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/aps@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else{
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  //padding: const EdgeInsets.only(left: 20, top: 6),
                  //child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/aps_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "APSS":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/apss@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  //padding: const EdgeInsets.only(left: 20, top: 6),
                  //child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/apss_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "AISP":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/aisp@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  //padding: const EdgeInsets.only(left: 20, top: 6),
                  //child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/aisp_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "MSP":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/msp@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListIdeas.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
                width: 40, height: 40,
                child: Container(
                  //padding: const EdgeInsets.only(left: 20, top: 6),
                  //child: Icon(Theme.Icons.complete,size: 16, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/msp_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "CLI":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                  child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_cli@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  //padding: const EdgeInsets.only(left: 40, top: 15),
                  //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_cli_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "FSS":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                  child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_fss@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  //padding: const EdgeInsets.only(left: 40, top: 15),
                  //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_fss_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
          case "LUTC":
            if (datosMorales.designaciones.desginacinesList[i].valor) {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                  child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_lutc@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            else {
              ListAmarican.add(new Container(
                margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
                width: 50, height: 50,
                child: Container(
                  //padding: const EdgeInsets.only(left: 40, top: 15),
                  //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage("assets/img/logrosydesignaciones/ac_lutc_off@4x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ));
            }
            break;
        }

      }
      if(datosMorales.designaciones.mdtr!= null && datosMorales.designaciones.mdtr != ""){
        switch(datosMorales.designaciones.mdtr){
          case "MDRT":
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 19, bottom: 19),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
                padding: const EdgeInsets.only(left: 40, top: 15),
                child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/mdrt@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
                //padding: const EdgeInsets.only(left: 40, top: 15),
                //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_cot_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
                //padding: const EdgeInsets.only(left: 40, top: 15),
                //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_tot_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            break;
          case "COT":
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 19, bottom: 19),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_mdrt_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
                padding: const EdgeInsets.only(left: 40, top: 15),
                child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/cot@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_tot_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
           break;
          case "TOT":
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 19, bottom: 19),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_mdrt_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/m_cot_off@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            ListMdrt.add(new Container(
              margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
              width: 50, height: 50,
              child: Container(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/img/logrosydesignaciones/tot@4x.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ));
            break;
        }
      }
      else{
        //MDRT sin datos
        ListMdrt.add(new Container(
          margin: EdgeInsets.only(left: 8, right: 16, top: 19, bottom: 19),
          //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          width: 50, height: 50,
          child: Container(
            //padding: const EdgeInsets.only(left: 40, top: 15),
            //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/img/logrosydesignaciones/m_mdrt_off@4x.png"),
              fit: BoxFit.fill,
            ),
          ),
        ));
        ListMdrt.add(new Container(
          margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          width: 50, height: 50,
          child: Container(
            //padding: const EdgeInsets.only(left: 40, top: 15),
            //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/img/logrosydesignaciones/m_cot_off@4x.png"),
              fit: BoxFit.fill,
            ),
          ),
        ));
        ListMdrt.add(new Container(
          margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          width: 50, height: 50,
          child: Container(
            //padding: const EdgeInsets.only(left: 40, top: 15),
            //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/img/logrosydesignaciones/m_tot_off@4x.png"),
              fit: BoxFit.fill,
            ),
          ),
        ));
      }
    }
    else {
      ListIdeas.add(new Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
        child: Image.asset(
          "assets/img/logrosydesignaciones/aps_off@4x.png",
          width: 40,height: 40,),
      ));
      ListIdeas.add(new Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
        child: Image.asset(
          "assets/img/logrosydesignaciones/apss_off@4x.png",
          width: 40,height: 40,),
      ));
      ListIdeas.add(new Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
        child: Image.asset(
          "assets/img/logrosydesignaciones/aisp_off@4x.png",
          width: 40,height: 40,),
      ));
      ListIdeas.add(
          new Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
            child: Image.asset(
              "assets/img/logrosydesignaciones/msp_off@4x.png",
              width: 40,height: 40,),
          )
      );
      //MDRT
      ListMdrt.add(new Container(
          margin: EdgeInsets.only(left: 8, right: 16, top: 19, bottom: 19),
          //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
          width: 50, height: 50,
          child: Container(
            //padding: const EdgeInsets.only(left: 40, top: 15),
            //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/img/logrosydesignaciones/m_mdrt_off@4x.png"),
              fit: BoxFit.fill,
            ),
          ),
      ));
      ListMdrt.add(new Container(
        margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        width: 50, height: 50,
        child: Container(
          //padding: const EdgeInsets.only(left: 40, top: 15),
          //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/logrosydesignaciones/m_cot_off@4x.png"),
            fit: BoxFit.fill,
          ),
        ),
      ));
      ListMdrt.add(new Container(
        margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        width: 50, height: 50,
        child: Container(
          //padding: const EdgeInsets.only(left: 40, top: 15),
          //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/logrosydesignaciones/m_tot_off@4x.png"),
            fit: BoxFit.fill,
          ),
        ),
      ));


      //American
      ListAmarican.add(new Container(
        margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        width: 50, height: 50,
        child: Container(
          //padding: const EdgeInsets.only(left: 40, top: 15),
          //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/logrosydesignaciones/ac_cli_off@4x.png"),
            fit: BoxFit.fill,
          ),
        ),
      ));
      ListAmarican.add(new Container(
        margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        width: 50, height: 50,
        child: Container(
          //padding: const EdgeInsets.only(left: 40, top: 15),
          //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/logrosydesignaciones/ac_fss_off@4x.png"),
            fit: BoxFit.fill,
          ),
        ),
      ));
      ListAmarican.add(new Container(
        margin: EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        //padding: const EdgeInsets.only(left: 8, right: 16, top: 24, bottom: 24),
        width: 50, height: 50,
        child: Container(
          //padding: const EdgeInsets.only(left: 40, top: 15),
          //child: Icon(Theme.Icons.complete,size: 13, color: Theme.Colors.Complete,),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/logrosydesignaciones/ac_lutc_off@4x.png"),
            fit: BoxFit.fill,
          ),
        ),
      ));
    }

    return  ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        datosMorales.designaciones.desginacinesList  != null && datosMorales.designaciones.desginacinesList.isEmpty ? Container(
          margin: EdgeInsets.all(16.0),
          height: 72.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 25),
                child:  Text("Aquí verás tu próxima designación",
                  style: Theme.TextStyles.LightMedium13px, textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/img/designa/designacion_vacia.png'),
              fit: BoxFit.fill,
            ),
          ),
        ): last() != "" ? Container(
          margin: EdgeInsets.all(16.0),
          height: 72.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(last()),
              fit: BoxFit.fill,
            ),
          ),
        ): Container(
    margin: EdgeInsets.all(16.0),
    height: 72.0,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    Container(
    padding: const EdgeInsets.only(left: 25),
    child:  Text("Aquí verás tu próxima designación",
    style: Theme.TextStyles.LightMedium13px, textAlign: TextAlign.center,
    ),
    )
    ],
    ),
    decoration: BoxDecoration(
    image: DecorationImage(
    image: ExactAssetImage('assets/img/designa/designacion_vacia.png'),
    fit: BoxFit.fill,
    ),
    ),
    ),
        Card(
            elevation: 0,
            child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 24),
                    margin: EdgeInsets.only(right: 24.0),
                    child: Image.asset("assets/img/logrosydesignaciones/designa_ideas_logo.png", width: 50,height: 50,),
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Theme.Colors.LightGray))
                    ),
                  ),
                  Row(
                      children:  ListIdeas.map<Widget>((Container desig) {
                        return Container(
                            child: desig);
                      }).toList()
                  ),
                ]
            )
        ),
        Card(
            elevation: 0,
            child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 24),
                    margin: EdgeInsets.only(right: 24.0),
                    child: Image.asset("assets/img/logrosydesignaciones/designa_mdrt_logo.png", width: 50,height: 50,),
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Theme.Colors.LightGray))
                    ),
                  ),
                  Row(
                      children:  ListMdrt.map<Widget>((Container mdtr) {
                        return Container(
                            child: mdtr);
                      }).toList()
                  ),
                ]
            )
        ),
        Card(
            elevation: 0,
            child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 24),
                    margin: EdgeInsets.only(right: 24.0),
                    child: Image.asset("assets/img/logrosydesignaciones/designa_american_logo.png", width: 50,height: 50,),
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Theme.Colors.LightGray))
                    ),
                  ),
                  Row(
                      children:  ListAmarican.map<Widget>((Container ame) {
                        return Container(
                            child: ame);
                      }).toList()
                  ),
                ]
            )
        ),
      ],
    );

  }

}




