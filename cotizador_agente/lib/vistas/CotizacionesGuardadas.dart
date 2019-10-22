import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/reglonTabla.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/material.dart';

class CotizacionesGuardadas extends StatefulWidget {
  @override
  _CotizacionesGuardadasState createState() => _CotizacionesGuardadasState();
}

class _CotizacionesGuardadasState extends State<CotizacionesGuardadas> {





  //Dummy data
  List <Cotizacion> cotizaciones = List<Cotizacion>();

  @override
  void initState(){
    llenarTabla();

  }

  llenarTabla(){
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Eduardo Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Moises Lugo"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Edgar Moreno"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Ángel Schaufelberger"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Dunkin Donuts"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Gloria Trevi"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Alejandra Guzmán"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Rocío Durcal"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));
    cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Rodriguez Zavaleta"));


  }

  mostrarMas(){
    setState(() {
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Yair Eduardo Rodriguez Zavaleta"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Moises Lugo"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Edgar Moreno"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Ángel Schaufelberger"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Dunkin Donuts"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Gloria Trevi"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Alejandra Guzmán"));
      cotizaciones.add(Cotizacion(fecha: "30/09/2019", id: "09989", titular: "Rocío Durcal"));



    });

  }


  eliminarCotizacion(Cotizacion c){
    setState(() {
      if(cotizaciones.contains(c)){
        //invocar servicio de eleiminar del servidor
        // . . .

        //Loading en lo que se elimina del server
        //If sucess, then eliminar de la vista

        cotizaciones.remove(c); //Eliminar de la lista dinámica y actualizar vista
      }

    });
  }

  bool nombreAscendente = false;
  bool IDAscendente = false;
  bool FechaAscendente = false;

  IconData col_1_filter_icon = Icons.arrow_drop_down;
  IconData col_2_filter_icon = Icons.arrow_drop_down;
  IconData col_3_filter_icon = Icons.arrow_drop_down;

  ordenarPorNombre(){
    setState(() {
      if(!nombreAscendente){

        col_2_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto
      }else{
        col_2_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto

      }
      nombreAscendente = !nombreAscendente;
    });

  }

  ordenarPorID(){

    setState(() {
      if(!IDAscendente){

        col_3_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto
      }else{
        col_3_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto

      }
      IDAscendente = !IDAscendente;
    });

  }

  ordenarPorFecha(){

    setState(() {
      if(!FechaAscendente){

        col_1_filter_icon = Icons.arrow_drop_up;
        //LLamar al servicio ordenado distinto
      }else{
        col_1_filter_icon = Icons.arrow_drop_down;
        //llamar al servicio ordenado distinto

      }
      FechaAscendente = !FechaAscendente;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GNP"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Divider( //002e71
                      thickness: 2,
                      color: Utilidades.color_titulo,
                    )),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text("Cotizaciones Guardadas", style: TextStyle(fontSize: 22.0, color: Utilidades.color_titulo),
                  textAlign: TextAlign.left,),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 16, top: 32, bottom: 24),
                child: FloatingActionButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  heroTag: "btn1",
                  tooltip: "Cerrar",
                  backgroundColor: Utilidades.color_primario,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          Container(
            color: Utilidades.color_filtro,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                        children: <Widget>[
                          Text("Fecha", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Utilidades.color_texto_filtro),),
                          IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(col_1_filter_icon),
                            onPressed: () {
                              print("Pressed filter" );
                              //widget.eliminar(widget.cotizacion);
                              ordenarPorFecha();
                            },
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      child: Row(
                        children: <Widget>[
                          Text("Titular", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Utilidades.color_texto_filtro),),
                          IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(col_2_filter_icon),
                            onPressed: () {
                              print("Pressed filter" );
                              //widget.eliminar(widget.cotizacion);
                              ordenarPorNombre();
                            },
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Container(child: Text("No. Cotizacion", overflow: TextOverflow.clip, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Utilidades.color_texto_filtro), ))),
                          IconButton(
                            padding: const EdgeInsets.all(0.0),
                            icon: Icon(col_3_filter_icon),
                            onPressed: () {
                              ordenarPorID();
                              print("Pressed filter" );
                              //widget.eliminar(widget.cotizacion);
                            },
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder
              (
                itemCount: cotizaciones.length+1,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {

                  if(index==cotizaciones.length){



                    FlatButton boton;
                    boton = new FlatButton(
                      child: new Text("Mostrar más"),
                      onPressed: () {
                        //Navigator.of(context).pop();
                        setState(() {
                          //list.remove(boton);
                        });
                        mostrarMas();
                      },
                    );





                    return boton;
                  }



                  return Padding(

                    padding: const EdgeInsets.all(16.0),
                    child: RenglonTabla(cotizacion: cotizaciones[index], eliminar: eliminarCotizacion),

                  );

                }


            ),
          ),
        ],
      ),
    );
  }
}

