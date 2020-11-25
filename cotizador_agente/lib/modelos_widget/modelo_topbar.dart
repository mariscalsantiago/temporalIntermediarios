import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/MisCotizaciones.dart';
import 'package:cotizador_agente/vistas/MaterialApoyo.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {


  final Function() recargarFormulario;
  final void Function(String) recargarFormularioConPlan;
  final  String plan;
  final Function() formatoComp;
  final GlobalKey<FormState> formKey;

  const TopBar({Key key, this.recargarFormulario, this.formKey, this.recargarFormularioConPlan, this.plan, this.formatoComp}) : super(key: key);




  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {


  List<PopupMenuItem> getMenuItems() {

    List<PopupMenuItem> listaitems = List<PopupMenuItem>();

    if(widget.recargarFormulario != null || widget.recargarFormularioConPlan != null){
      listaitems.add(PopupMenuItem(
        value: 1,
        child: Text("Limpiar datos",
          style: TextStyle(
              color: AppColors.primary700, fontWeight: FontWeight.w400),
        ),
      ));
    }
    bool comparativa_Activada = false;
    for(int i=0; i<Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos_configuracion.length; i++){

      if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos_configuracion[i].id == 2){
        comparativa_Activada = true;
        break;
      }

    }


    if( widget.formatoComp != null && comparativa_Activada && (Utilidades.cotizacionesApp.getCotizacionesCompletas() > 1)){
      listaitems.add(PopupMenuItem(
        enabled: widget.formatoComp != null,
        value: 2,
        child: Text(
          "Formato Comparativa",
          style: TextStyle(
              color: AppColors.primary700,
              fontWeight: FontWeight.w400),
        ),
      ),);
    }
    if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos.length > 0){
      listaitems.add(PopupMenuItem(
        value: 3,
        child: Text("Material de apoyo",
          style: TextStyle(color: AppColors.primary700,
              fontWeight: FontWeight.w400),
        ),));
    }

    return listaitems;

  }


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        color: AppColors.color_sombra,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  textColor: AppColors.color_primario,
                  child: Text("COTIZACIONES GUARDADAS"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MisCotizaciones(),
                        ));
                  },
                  borderSide: BorderSide(
                    color: AppColors.color_primario, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                child: PopupMenuButton(
                  offset: Offset(220, 120),
                  itemBuilder: (context) => getMenuItems(),
                 // initialValue: 1,
                  onCanceled: () {
                    print("You have canceled the menu.");
                  },
                  onSelected: (value) {
                    switch(value){
                      case 1:

                        Utilidades.mostrarAlertaCallback(Mensajes.titleLimpia, Mensajes.limpiaDatos, context, (){

                          Navigator.pop(context);

                        }, (){

                          if(widget.formKey != null){
                            widget.formKey.currentState.reset();
                            if(widget.recargarFormulario!=null){
                              widget.recargarFormulario();
                            }

                            if(widget.recargarFormularioConPlan!=null){
                              widget.recargarFormularioConPlan(widget.plan);
                            }

                            //Navigator.pop(context);
                          }else {

                            if(widget.recargarFormulario!=null){
                              print("RECARGA");
                            widget.recargarFormulario();

                            }

                            //Navigator.pop(context);
                          }

                        });

                        break;

                      case 2:

                        if(widget.formatoComp != null){
                          if(Utilidades.cotizacionesApp.getCotizacionesCompletas()>1){
                            widget.formatoComp();
                          }
                          else{
                            Utilidades.mostrarAlerta("", Mensajes.generaComparativa, context);
                          }

                        }

                        break;

                      case 3:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaterialApoyo(),
                            ));

                        break;



                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "MÁS",
                        style: TextStyle(
                            fontSize: 14.0, color: AppColors.color_primario),
                        textAlign: TextAlign.right,
                      ),
                      Icon(
                        Icons.more_vert,
                        color: AppColors.color_primario,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
                child: Divider(
              //002e71
              thickness: 2,
              color: AppColors.primary700,

              height: 0,
            )),
          ),
        ],
      ),
    ]);
  }
}
