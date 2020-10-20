import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Cartera/ConsultaPage.dart';

class CustomSectionCard extends StatefulWidget {
  final String title;
  final String navigation;
  final String icon;

  CustomSectionCard({Key key, this.title, this.navigation,this.icon}) : super(key: key);
  @override
  CustomSectionCardState createState() => new CustomSectionCardState();
}

class CustomSectionCardState extends State<CustomSectionCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(widget.navigation.contains("consultaClientes")){
          refreshTotalPolizasClientes();
        }
        Navigator.pushNamed(context,widget.navigation);
      },
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        margin : new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Image.asset(
                widget.icon,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title,style: Theme.TextStyles.DarkMedium16px),
              ],
            )
          ],
        ),
      ),
    );
  }
}