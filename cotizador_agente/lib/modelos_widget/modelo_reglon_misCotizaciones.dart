import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/Custom/Styles/Strings.dart' as AppStrings;

class RenglonMisCotizaciones extends StatefulWidget {

  final Cotizacion cotizacion;
  final void Function(Cotizacion) eliminar;
  final void Function(Cotizacion) vistaprevia;
  final void Function(Cotizacion) editar;



  const RenglonMisCotizaciones({Key key, this.cotizacion, this.eliminar, this.vistaprevia, this.editar}) : super(key: key);

  @override
  _RenglonMisCotizacionesState createState() => _RenglonMisCotizacionesState();
}

class _RenglonMisCotizacionesState extends State<RenglonMisCotizaciones> {

  @override
  Widget build(BuildContext context) {

    return Card(
      shadowColor: AppColors.color_borde.withOpacity(0.6),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(widget.cotizacion.fecha, textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal,color: AppColors.color_appBar)),
              ),
              Spacer(flex: 1,),
              widget.cotizacion.idFormato != Utilidades.FORMATO_COMPARATIVA ?
              PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: AppColors.color_primario,),
                  offset: Offset(100, 100),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        AppStrings.StringsMX.edicion,
                        style: TextStyle(
                            color: AppColors.color_titulo,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        AppStrings.StringsMX.eliminar,
                        style: TextStyle(
                            color: AppColors.color_titulo,
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    PopupMenuItem(
                      value: 3,
                      child: Text(
                        AppStrings.StringsMX.descarga,
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
              ) : Padding(
                padding: const EdgeInsets.only(right: 2.0, left: 265.0),
                child: PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: AppColors.color_primario,),
                    offset: Offset(220, 120),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          AppStrings.StringsMX.eliminar,
                          style: TextStyle(
                              color: AppColors.color_titulo,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          AppStrings.StringsMX.descarga,
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
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0,),
                child: Text(widget.cotizacion.nombreCotizacion, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.color_appBar)),
              ),
              Spacer(flex: 1,),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                child: Text(widget.cotizacion.titular, textAlign: TextAlign.left, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.color_Text)),
              ),
              Spacer(flex: 1,),
            ],
          ),
        ],
      ),
    );

  }

}
