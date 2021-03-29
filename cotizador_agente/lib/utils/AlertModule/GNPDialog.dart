import 'package:cotizador_agente/ThemeGNP/NegativeButton.dart';
import 'package:cotizador_agente/ThemeGNP/PositiveButton.dart';
import 'package:cotizador_agente/utils/AlertModule/MyDialog.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:flutter/material.dart';

enum TipoDialogo { ADVERTENCIA, EXITO }

class GNPDialog extends StatelessWidget {
  final String title, description;
  TipoDialogo tipo;
  List<Widget> actions;
  String textButtonOk;
  Alignment alignment;

  GNPDialog(
      {this.title,
        this.description,
        @required this.actions,
        this.tipo, this.alignment, this.textButtonOk});

  @override
  Widget build(BuildContext context) {
    if (this.actions == null) {
      if(tipo == TipoDialogo.ADVERTENCIA){
        this.actions = [
          NegativeButton(
              title: textButtonOk != null ? textButtonOk :"CANCELAR",
              margin: EdgeInsets.fromLTRB(16, 24, 16, 24),
              onPressed: () {
                Navigator.pop(context,true);
              })
        ];
      }else{
        this.actions = [
          PositiveButton(
              title: textButtonOk != null ? textButtonOk :"Aceptar",
              margin: EdgeInsets.fromLTRB(16, 24, 16, 24),
              onPressed: () {
                Navigator.pop(context,true);
              })
        ];
      }

    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: MyDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: SafeArea(
            top: false,
            child: Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Visibility(
                        visible: tipo != null ? true : false,
                        child: Container(
                          margin: EdgeInsets.only(top: 32),
                          child: showIcon(),
                        )),
                    Visibility(
                        visible: (this.title == null) ? false : true,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Text(this.title ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 0.15,
                                  color: AppColors.azulGNP)),
                        )),
                    Visibility(
                        visible: (this.description == null) ? false : true,
                        child: Container(
                          alignment: alignment == null ? Alignment.centerLeft: alignment,
                          margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: Text(this.description ?? "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: AppColors.color_appBar)),
                        )),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: actions,
                    )
                  ]),
            )));
  }

  Widget showIcon() {
    if (tipo != null && tipo == TipoDialogo.ADVERTENCIA) {
      return Image.asset('assets/img/warning.png', width: 44.0, height: 38.0);
    } else if (tipo != null && tipo == TipoDialogo.EXITO) {
      return Image.asset('assets/img/verified.png', width: 44.0, height: 38.0);
    } else {
      return Icon(Icons.arrow_back);
    }
  }
}
