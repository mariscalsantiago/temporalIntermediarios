import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

class CustomWebIconCard extends StatefulWidget {
  final String title;
  final String navigation;
  final String iconPath;

  CustomWebIconCard({Key key, this.title, this.navigation,this.iconPath}) : super(key: key);
  @override
  CustomWebIconCardState createState() => new CustomWebIconCardState();
}

class CustomWebIconCardState extends State<CustomWebIconCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: CachedNetworkImage(
                imageUrl:widget.iconPath,
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
    );
  }
}