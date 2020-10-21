import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:flutter/material.dart';

AppBar titleOnly(String title , BuildContext context){
  return AppBar(
    backgroundColor: Theme.Colors.White,
    elevation: 2.0,
    title: Text('$title', textAlign: TextAlign.left, style: Theme.TextStyles.DarkMedium20px0ls),
  );
}

AppBar titleAndArrowBack(String title , BuildContext context){
  return AppBar(
    backgroundColor: Theme.Colors.White,
    elevation: 2.0,
    leading:
    new IconButton(
      icon: new Icon(Icons.arrow_back,
        color: Theme.Colors.Orange,
      ),
      onPressed: (){Navigator.of(context).pop();},
    ),
    title: Text('$title', textAlign: TextAlign.left, style: Theme.TextStyles.DarkMedium20px0ls),
  );
}

AppBar titleAndArrowCustomBack(String title , BuildContext context,Function function){
  return AppBar(
    backgroundColor: Theme.Colors.White,
    elevation: 2.0,
    leading:
    new IconButton(
      icon: new Icon(Icons.arrow_back,
        color: Theme.Colors.Orange,
      ),
      onPressed: function,
    ),
    title: Text('$title', textAlign: TextAlign.left, style: Theme.TextStyles.DarkMedium20px0ls),
  );
}

AppBar arrowBack(BuildContext context){
  return AppBar(
    backgroundColor: Theme.Colors.White,
    elevation: 2.0,
    leading:
    new IconButton(
      icon: new Icon(Icons.arrow_back,
        color: Theme.Colors.Orange,
      ),
      onPressed: (){Navigator.of(context).pop();},
    ),
  );
}