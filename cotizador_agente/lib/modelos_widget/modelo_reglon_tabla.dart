import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
class RenglonTabla extends StatefulWidget {

  final Cotizacion cotizacion;
  final void Function(Cotizacion) eliminar;
  final void Function(Cotizacion) vistaprevia;
  final void Function(Cotizacion) editar;



  const RenglonTabla({Key key, this.cotizacion, this.eliminar, this.vistaprevia, this.editar}) : super(key: key);

  @override
  _RenglonTablaState createState() => _RenglonTablaState();
}

class _RenglonTablaState extends State<RenglonTabla> {

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          //child: Text(widget.cotizacion.id.toString(), style: TextStyle(fontSize: 15, color: AppColors.color_titulo)),
          child: Text(widget.cotizacion.nombreCotizacion, style: TextStyle(fontSize: 12, color: AppColors.color_titulo)),
        ),
        Expanded(
          flex: 3,
          child: Text(widget.cotizacion.titular, style: TextStyle(fontSize: 12, color: AppColors.color_titulo)),
        ),
        Expanded(
          flex: 3,
            child: Row(
              children: <Widget>[
                Spacer(flex: 8,),
                Text(widget.cotizacion.fecha, style: TextStyle(fontSize: 12, color: AppColors.color_titulo)),
                //Spacer(flex: 1,),
                widget.cotizacion.idFormato != Utilidades.FORMATO_COMPARATIVA ?
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: AppColors.color_primario,),
                  offset: Offset(220, 120),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Editar",
                        style: TextStyle(
                            color: AppColors.color_titulo,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        "Borrar",
                        style: TextStyle(
                            color: AppColors.color_titulo,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    PopupMenuItem(
                      value: 3,
                      child: Text(
                        "Vista previa",
                        style: TextStyle(
                            color: AppColors.color_titulo,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                  initialValue: 1,
                  onCanceled: () {
                    print("You have canceled the menu.");
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 1:

                        if(Utilidades.cotizacionesApp.getCotizacionesCompletas() < 3){
                          widget.editar(widget.cotizacion);
                        }else{
                          Utilidades.mostrarAlerta(Mensajes.titleAdver, Mensajes.limiteCotizacion, context);
                        }

                        print("EDITAR COTIZACION");
                        break;

                      case 2:
                        String nombreFormato = widget.cotizacion.idFormato == Utilidades.FORMATO_COTIZACION ? "cotización " :
                        (widget.cotizacion.idFormato == Utilidades.FORMATO_COMISION ? "comisión " : (widget.cotizacion.idFormato == Utilidades.FORMATO_COMPARATIVA ? "comparativa " : "cotización "));

                        Utilidades.mostrarAlertaCallback("¿Desea eliminar la " + nombreFormato + widget.cotizacion.id.toString() + "?", "Esta acción no se puede deshacer", context, (){

                          Navigator.of(context).pop();
                        }, (){
                          widget.eliminar(widget.cotizacion);
                          Navigator.of(context).pop();
                        });

                        break;

                      case 3:
                        widget.vistaprevia(widget.cotizacion);
                        break;
                    }
                  }
                ) : PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: AppColors.color_primario,),
                    offset: Offset(220, 120),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "Borrar",
                          style: TextStyle(
                              color: AppColors.color_titulo,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          "Vista previa",
                          style: TextStyle(
                              color: AppColors.color_titulo,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                    initialValue: 1,
                    onCanceled: () {
                      print("You have canceled the menu.");
                    },
                    onSelected: (value) {
                      switch (value) {


                        case 2:

                          String nombreFormato = widget.cotizacion.idFormato == Utilidades.FORMATO_COTIZACION ? "cotización " :
                          (widget.cotizacion.idFormato == Utilidades.FORMATO_COMISION ? "comisión " : (widget.cotizacion.idFormato == Utilidades.FORMATO_COMPARATIVA ? "comparativa " : "cotización "));

                          Utilidades.mostrarAlertaCallback("¿Desea eliminar la " + nombreFormato + widget.cotizacion.id.toString() + "?", "Esta acción no se puede deshacer", context, (){

                            Navigator.of(context).pop();
                          }, (){
                            widget.eliminar(widget.cotizacion);
                            Navigator.of(context).pop();
                          });

                          break;

                        case 3:
                          widget.vistaprevia(widget.cotizacion);
                          break;
                      }
                    }
                ),
              ],
            ),
        ),
      ],
    );
  }

}
