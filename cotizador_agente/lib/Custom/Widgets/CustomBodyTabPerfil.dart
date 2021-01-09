import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomCardPerfil.dart';

class CustomBodyTabPerfil extends StatefulWidget{
  CustomBodyTabPerfil({Key key, this.datosbody}): super(key: key);
  DatosBodyPerfil datosbody;

  @override
  CustomBodyTabPerfilState createState() => new CustomBodyTabPerfilState();
}

class CustomBodyTabPerfilState extends State<CustomBodyTabPerfil> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: ListView(
            children:  widget.datosbody.listbody.map<Widget>((DatosBodyPerfilItem item) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  item.seccion!=""
                      ? /// contenido del if
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 24.0),
                    child: Text(item.seccion, style: Theme.TextStyles.DarkRegular14px,),
                  ): Container (),
                  Column(
                      children:  item.item.map<Widget>((DatosCardPerfil item) {
                        return Container(
                            child: CustomCardPerfil(datoscard: item));
                      }).toList()
                  )
                ],
              );
            }).toList()
        )
    );

  }
}

class DatosBodyPerfil{
  DatosBodyPerfil({
    this.listbody,
  });
  List<DatosBodyPerfilItem> listbody = [];
}

class DatosBodyPerfilItem{
  DatosBodyPerfilItem({
    this.seccion,
    this.item,
  });


  String seccion;
  List<DatosCardPerfil> item = [];
}