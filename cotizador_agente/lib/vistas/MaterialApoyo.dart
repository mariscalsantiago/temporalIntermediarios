
import 'package:cotizador_agente/modelos_widget/modelo_material_apoyo.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialApoyo extends StatefulWidget {

  @override
  _MaterialApoyoState createState() => _MaterialApoyoState();
}

class _MaterialApoyoState extends State<MaterialApoyo> {


  TextEditingController controller = new TextEditingController();
  String filter;

  initState(){
    controller.addListener((){
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.color_primario),
        backgroundColor: Colors.white,
        title: Text("Material de apoyo", style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 8,
                  child: Container(
                    child: Text("Material de apoyo para venta",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 20.0, color: AppColors.color_titulo),
                      textAlign: TextAlign.left,),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          heroTag: "btn1",
                          tooltip: "Cerrar",
                          backgroundColor: AppColors.color_primario,
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: new TextFormField(
                  controller: controller,
                  decoration:


                  InputDecoration(
                    hintText: "Buscar documento",
                    prefixIcon: Icon(Icons.search, color: Colors.grey,),

                    fillColor: AppColors.color_primario,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                      borderSide: new BorderSide(
                        color: AppColors.color_primario
                      ),
                    ),
                    focusedBorder:  new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(0.0),
                                          borderSide: new BorderSide(
                                          color: AppColors.color_primario
                                          ),
                                          ),
                    suffixIcon:  IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey,),
                        onPressed: () {
                          controller.clear();
                        }),
                  ),

                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: new Text(
                    "Nombre del documento",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.color_titulo,
                    fontSize: 16),
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
                      thickness: 0.5,
                      color: AppColors.color_titulo,

                      height: 0,
                    )),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos.length,
                //itemCount: 9,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {
                  //Para el primero
                  return filter==null || filter==""?
                  DropDownMaterialApoyoElement(documento: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos[index])
                      : Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos[index].nombreDocumento.toLowerCase().contains(filter.toLowerCase())?
                          DropDownMaterialApoyoElement(documento: Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.documentos[index])
                            : Container();
                }

            ),
          ),
        ],
      ),
    );
  }
}

