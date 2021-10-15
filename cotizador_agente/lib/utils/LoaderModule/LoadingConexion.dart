import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import '../responsive.dart';

class LoadingConexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("LoadingConexion");
    Responsive responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: responsive.height * 0.03),
                        child: Center(
                          child: Icon(
                            Icons.wifi_off_outlined,
                            color: Theme.Colors.azul_apoyo,
                            size: 57,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: responsive.height * 0.05),
                        child: Center(
                          child: Text(
                            "Sin conexión a internet",
                            style: TextStyle(
                                color: Theme.Colors.Encabezados,
                                fontSize: responsive.ip(2.3)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: responsive.height * 0.05,
                          left: responsive.width * 0.04,
                          right: responsive.width * 0.04,
                          bottom: responsive.height * 0.05,
                        ),
                        child: Text(
                          "Comprueba que tienes acceso a una red Wi-Fi o que cuentas con datos móviles activados.",
                          style: TextStyle(
                              color: Theme.Colors.Funcional_Textos_Body,
                              fontSize: responsive.ip(2.0)),
                        ),
                      ),
                      /*Container(
                                margin: EdgeInsets.only(
                                    top: responsive.height * 0.06,
                                    bottom: responsive.height * 0.05),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,true);

                                    },
                                    child: Text(
                                      "CERRAR",
                                      style: TextStyle(
                                          color: Theme.Colors.GNP,
                                          fontSize: responsive.ip(2.2)),
                                    ),
                                  ),
                                ),
                              )*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
