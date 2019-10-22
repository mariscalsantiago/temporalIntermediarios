


import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';




class CotizacionVista extends StatefulWidget {
  @override
  _CotizacionVistaState createState() => _CotizacionVistaState();
}

class _CotizacionVistaState extends State<CotizacionVista> {

  List<Cotizacion2Campos> itemsValor = List<Cotizacion2Campos>();


  @override
  void initState() {

    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));
    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));
    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));
    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));
    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));
    itemsValor.add(Cotizacion2Campos(titulo: "Suma 1", valor: "100,000.00"));

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text("Cotización"),
    ),

    body:

    Column(

      children: <Widget>[

        Container(
          color: Utilidades.sombra,
          child: Row(

            children: <Widget>[

                  Expanded(
                    flex: 7,

                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        textColor: Utilidades.color_primario,
                        child: Text("COMPARAR PLAN"),
                        onPressed: () {},
                        borderSide: BorderSide(
                          color: Utilidades.color_primario, //Color of the border
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
                      child: (
                          PopupMenuButton(

                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Limpiar datos",
                                  style: TextStyle(
                                      color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text(
                                  "Imprimir",
                                  style: TextStyle(
                                      color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 4,
                                child: Text(
                                  "Material de apoyo",
                                  style: TextStyle(
                                      color: Utilidades.color_primario, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            initialValue: 2,
                            onCanceled: () {
                              print("You have canceled the menu.");
                            },
                            onSelected: (value) {
                              print("value:$value");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "MÁS",
                                  style: TextStyle(fontSize: 14.0, color: Utilidades.color_primario),
                                  textAlign: TextAlign.right,

                                ),
                                Icon(Icons.more_vert, color: Utilidades.color_primario,),
                              ],
                            ),
                          )

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
                  child: Divider( //002e71
                    thickness: 2,
                    color: Utilidades.color_titulo,

                    height: 0,
                  )),
            ),
          ],
        ),

        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ("Cotización"), maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0, color: Utilidades.color_titulo),
              ),
            ),
          ],
        ),

        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),

                    ],
                  ),
                )
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    textColor: Utilidades.color_primario,
                    disabledColor: Utilidades.color_primario,
                    disabledTextColor: Utilidades.color_primario,
                    // splashColor: Colors.blueAccent,
                    onPressed: () {
                      /*...*/
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Editar",
                        style: TextStyle(fontSize: 14.0),
                        textAlign: TextAlign.right,

                      ),
                    ),
                  ),

                ))
          ],
        ),



        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                width: 200.0,
                height: 100.0,
                color: Colors.transparent,
                child: Container(
                  width: 200.0,
                  height: 100.0,


                  color: Utilidades.color_primario,
                  child: Text('Anual'),
                ),
              ),

            ],

          ),
        ),

        Container(
          color: Utilidades.sombra,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ("Prima total"), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20.0, color: Utilidades.color_titulo),
                ),
              ),
            ],
          ),
        ),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder
            (
              itemCount: itemsValor.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RenglonTablaDoscolumna(titulo: itemsValor[index].titulo,valor:itemsValor[index].valor),

                );

              }

          ),
        ),

      ),

        Container(
          color: Utilidades.sombra,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ("Cobertura Basica"), maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20.0, color: Utilidades.color_titulo),
                ),
              ),
            ],
          ),
        ),

        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView.builder
                (
                  itemCount: itemsValor.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RenglonTablaDoscolumna(titulo: itemsValor[index].titulo,valor:itemsValor[index].valor),

                    );

                  }

              ),
            ),

        )




      ],
    )



    );



  }
}