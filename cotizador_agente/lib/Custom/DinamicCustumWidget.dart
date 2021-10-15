import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;


class DinamicCustumWidget {
  BuildContext context;

  DinamicCustumWidget({@required this.context});

  void referenceCustomLoader() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            WillPopScope(
                onWillPop: () => Future.value(false),
                child: SafeArea(
                  child: Scaffold(
                      backgroundColor: Theme.Colors.Black.withOpacity(0.1),
                      appBar: null,
                      body: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.Colors.gnpOrange)
                        ),
                      )
                  ),
                )
            )
    );
  }

  Future<void> customAlertFooter(String title, String message, GestureTapCallback onPressed, String titleButton, onPressedBack, String titleButtonNo) async {
    await showDialog(
        context: context, barrierDismissible: false, builder: (context) {
        Responsive responsive = Responsive.of(context);
      return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: responsive.height,
                    width: responsive.width,
                    color: Theme.Colors.Azul_gnp,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    margin:
                                    EdgeInsets.only(top: responsive.hp(3)),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.red,
                                      size: responsive.ip(5),
                                    ))),
                            Container(
                              margin: EdgeInsets.only(top: responsive.hp(5)),
                              child: Center(
                                child: Text(title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.Colors.Encabezados,
                                      fontSize: responsive.ip(2.3)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: responsive.height * 0.04,
                                left: responsive.width * 0.04,
                                right: responsive.width * 0.04,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: responsive.width * 0.04,
                                ),
                                child: Center(
                                  child: Text(message,style: TextStyle(
                                        color:
                                        Theme.Colors.Funcional_Textos_Body,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.Colors.GNP,
                                  onPressed: onPressed,
                                  child: Text(titleButton,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.White,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: responsive.hp(6.25),
                                width: responsive.wp(90),
                                margin: EdgeInsets.only(
                                  bottom: responsive.height * 0.02,
                                  top: responsive.height * 0.02,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Theme.Colors.GNP, width: 2),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  elevation: 0,
                                  color: Theme.Colors.White,
                                  onPressed: onPressedBack,
                                  child: Text(titleButtonNo,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.Colors.GNP,
                                        fontSize: responsive.ip(1.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          );
        });
  }

  void loadinGif(){
    Responsive responsive = Responsive.of(context);
  Stack(
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

}