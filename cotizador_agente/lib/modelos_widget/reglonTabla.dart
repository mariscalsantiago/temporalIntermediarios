import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Colores.dart';
import 'package:flutter/material.dart';
class RenglonTabla extends StatefulWidget {

  final Cotizacion cotizacion;
  final void Function(Cotizacion) eliminar;


  const RenglonTabla({Key key, this.cotizacion, this.eliminar}) : super(key: key);

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
          child: Text(widget.cotizacion.fecha),
        ),
        Expanded(
          flex: 3,
          child: Text(widget.cotizacion.titular),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: <Widget>[
              Text(widget.cotizacion.id.toString()),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete, color: AppColors.color_primario,),
                onPressed: () {
                  print("Pressed" + widget.cotizacion.id.toString());
                  widget.eliminar(widget.cotizacion);
                },
              ),
            ],
          ),
        ),


      ],
    );
  }
}
