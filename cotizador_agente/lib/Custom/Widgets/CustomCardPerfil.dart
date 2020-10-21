import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Perfil/edicion_datos_perfil.dart';
import 'package:flutter/material.dart' as prefix0;

import '../../main.dart';

class CustomCardPerfil extends StatefulWidget {
  final DatosCardPerfil datoscard;

  CustomCardPerfil({Key key, this.datoscard}) : super(key: key);

  @override
  CustomCardPerfilState createState() => new CustomCardPerfilState();
}

class CustomCardPerfilState extends State<CustomCardPerfil> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    int count2 = 0;
    List<DatosCardPerfilItem> listTemp = [];
    for(int i =0;    i< widget.datoscard.list.length; i++ ){
      for(int d =0;  d<widget.datoscard.list.elementAt(i).description.length ; d++)
      {
        if( widget.datoscard.list.elementAt(i).description[d]['Desc'].isNotEmpty){
        }else{
          count++;
        }
      }
      if(count == widget.datoscard.list.elementAt(i).description.length){
        count2++;
        count = 0;
      }
    }

    if(count2==widget.datoscard.list.length && widget.datoscard.list.length>=2 ){
      widget.datoscard.edicionMultiple=true;
      listTemp.add(DatosCardPerfilItem(
          title: widget.datoscard.list.elementAt(0).title,
          description: [
            {'Desc' : ""}
          ]
      ),);
      count2 = 0;
    }
    else{
      widget.datoscard.edicionMultiple=false;
      listTemp = widget.datoscard.list;
    }

    return Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: listTemp
                        .map<Widget>((DatosCardPerfilItem item) {
                      return Container(
                          //margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: CustomCardPerfilItem2(
                              item,
                              listTemp.length,
                              widget.datoscard
                                  .edicion, widget.datoscard.edicionMultiple, widget.datoscard.type ) /*CustomCardPerfilItem(datos: item, tamano: widget.datoscard.list.length, edit: widget.datoscard.edicion)*/);
                    }).toList())),
            widget.datoscard.edicion == true &&
                listTemp.length >= 2
                ? Container(
                    //margin: EdgeInsets.only(left: 100.0),
                    child: IconButton(
                        icon:widget.datoscard.edicionMultiple == true ?  Icon( Theme.Icons.add , size: 24, color: Theme.Colors.Orange,):Icon( Theme.Icons.edit , size: 24, color: Theme.Colors.Orange,) ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (_) => new EdicionDatosPerfil(
                                      type: widget.datoscard.type,
                                    )),
                          );
                        }),
                  )
                : Container(),
          ],
        )));
  }

  Widget CustomCardPerfilItem2(
      DatosCardPerfilItem item, int tamano, bool edicion, bool edicionMultiple,editType editTypeCard ) {
    String titleAdd =
        item.title.isEmpty  ? item.description[0]['Desc'] : item.title;
    List<Widget> ListaDesc = [];
    bool pintar = false;
    for (int i = 0; i < item.description.length; i++) {
      if (((item.description[i]['Desc'].isNotEmpty) || (edicion == false))) {
        pintar = true;
        ListaDesc.add(
            Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Text(
              item.description[i]['Desc'],
              style: Theme.TextStyles.DarkGrayBold14px,
              maxLines: 10,
              softWrap: true,
            )));
      }
    }

    return (tamano >= 2) || (pintar == true)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(8.0),
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        item.assetName,
                        size: 16.0,
                        color: Theme.Colors.Blue,
                      ),
                      Padding(padding: EdgeInsets.only(left: 12.0)),
                      Expanded(
                          child:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            item.title.isNotEmpty
                                ? Text(item.title,
                                    style: Theme.TextStyles.DarkGrayRegular14px)
                                : Text(item.description[0]['Desc'],
                                    style: Theme.TextStyles.DarkGrayBold14px),
                            item.title.isNotEmpty
                                ? Container(
                                    child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: ListaDesc,
                                  ))
                                : Container()
                          ]))
                    ],
                  ),
                )),
                tamano == 1 && edicion == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            IconButton(
                                icon: Icon(edicionMultiple==true ?
                                  Theme.Icons.add : Theme.Icons.edit ,
                                  size: 24,
                                  color: Theme.Colors.Orange,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new EdicionDatosPerfil(
                                              type: widget.datoscard.type,
                                            idAcopaniante: widget.datoscard.idComp
                                            )),
                                  );
                                }),
                          ])
                    : Container()
              ])
        :tamano == 1  ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child:
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                //titleAdd
                child: Text(
                  getTitleAddCard(titleAdd, editTypeCard) ,
                  //overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  softWrap: true,
                  style: Theme.TextStyles.DarkGrayMedium14px,
                ),
              ),),
                IconButton(
                    icon: Icon(
                      Theme.Icons.add,
                      size: 24,
                      color: Theme.Colors.Orange,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (_) => new EdicionDatosPerfil(
                                  type: widget.datoscard.type,
                                )),
                      );
                    }),
        ]):Container();
  }

  String getTitleAddCard(String title , editType type){
    switch(type){

      case editType.salud:
        return "Agregar tu tipo de sangre, alergias y enfermedades";
        // TODO: Handle this case.
        break;
      case editType.estudios:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.familiar:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.texto:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.correo:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.telefono:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.direccion:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.poliza:
        // TODO: Handle this case.
        return "Agregar tu "+title;
        break;
      case editType.contatoEmergencia:
        // TODO: Handle this case.
        return "Agrega tu contacto";
        break;
      case editType.nickname:
        // TODO: Handle this case.
        return "Agrega tu nickname";
        break;
      case editType.visa:
        // TODO: Handle this case.
        return "Agrega tu visa";
        break;
      case editType.pasaporte:
        // TODO: Handle this case.
        return "Agrega tu pasaporte";
        break;
      case editType.playera:
        // TODO: Handle this case.
        return "Agrega tu talla de playera";
        break;
      case editType.condiciones:
        // TODO: Handle this case.
        return "Agregar tus condiciones especiales y alimenticias";
        break;
      case editType.deportes:
        // TODO: Handle this case.
        return "Agrega deportes y si eres fumador";
        break;
      case editType.acompaniante:
        // TODO: Handle this case.
        return "Agrega a un acompañante";
        break;
    }

  }
}

class DatosCardPerfil {
  DatosCardPerfil({
    this.list,
    this.edicion,
    this.type,
    this.idComp,
    this.edicionMultiple
  });

  List<DatosCardPerfilItem> list = [];
  bool edicion;
  editType type;
  int idComp;
  bool edicionMultiple = false;
}

class DatosCardPerfilItem {
  DatosCardPerfilItem({
    this.assetName,
    this.title,
    this.description,
     this.edicionMultiple
  });
  IconData assetName;
  String title;
  List<Map> description;
  bool edicionMultiple;
}
