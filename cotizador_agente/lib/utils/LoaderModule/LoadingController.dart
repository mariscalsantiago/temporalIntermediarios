
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:flutter/material.dart';

import '../responsive.dart';

class LoadingController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Stack(
      children: [
        Opacity(
          opacity: 0.6,
          child: GestureDetector(
            onTap: (){
              //Navigator.pop(context);
            },
            child: Container(
              height: responsive.height,
              width: responsive.width,
              color: Theme.Colors.Azul_gnp,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: responsive.width,
              child: Card(
                color: Theme.Colors.White,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: responsive.hp(3.5), bottom: responsive.hp(3)),
                        child: Text("Procesando información...",
                          style:
                          TextStyle(
                            fontSize: responsive.ip(2.3),
                          fontWeight: FontWeight.w600,
                          color:Theme.Colors.Encabezados,
                        ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(bottom: responsive.hp(3)),
                          child: SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Theme.Colors.GNP),
                              strokeWidth: 6.5,
                            ),
                          )),
                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
    /*return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: Container(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 5.0,
                ),
              )),
        ));
  }*/
}
