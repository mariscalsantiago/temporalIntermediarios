
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/utils/validadores.dart';
import 'package:flutter/material.dart';
import 'modelos_widgets.dart';

class SeccionDinamica extends StatefulWidget {
  SeccionDinamica(
      {Key key,
        this.agregarDicc,
        this.notifyParent,
        this.secc,
        this.i,
        this.end,
        this.cantidad_asegurados,
        this.formKey, this.formulario, this.actualizarSecciones,
        this.actualizarCodigoPostalFamiliares,
        this.validarCodigoPostalFamiliares,
        this.borrarAdicional,
      })
      : super(key: key);

  final Seccion secc;
  final int end;
  final int i;
  final int cantidad_asegurados;
  final Function() notifyParent;
  final void Function(String, String) agregarDicc;
  final void Function(String) actualizarSecciones;
  final GlobalKey<FormState> formKey;
  final bool Function() formulario;
  final Function actualizarCodigoPostalFamiliares;
  final bool Function() validarCodigoPostalFamiliares;
  final void Function(int) borrarAdicional;

  @override
  _SeccionDinamicaState createState() => _SeccionDinamicaState();
}

class _SeccionDinamicaState extends State<SeccionDinamica> with Validadores {
  TextEditingController textFieldController = TextEditingController();

  final colorLetters = const Color(0xFF002E71);

  static List<Widget> _aseguradosList = <Widget>[];

  String botonAgregarEtiqueta(int _seccion) {
    switch (_seccion) {
      case Utilidades.familiarSeccion:
        return 'Agregar Familiar';
      case Utilidades.descuentoSeccion:
        return 'Agregar Descuento';
      default:
        return 'Agregar';
    }
  }

  @override
  void initState() {

  }

  void filtrarSeccion(int ){

  }



  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Solo es posible agregar " +
              (widget.secc.multiplicador).toString() +" "+
              widget.secc.seccion),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Function actualizarCodigoPostalFamiliares =
        widget.actualizarCodigoPostalFamiliares;

    bool _camposVisibles(List<Campo> campos) {
      return campos.where((c) => c.visible==true).toList().length > 0;
    }

    void _decrementar() {
      setState(() {
        widget.secc.removeLastChild();
      });
    }

    void _borrarSeccion(var hashCode) {
      setState(() {
        widget.borrarAdicional(hashCode);
      });
    }

    void _aumentar() {
      setState(() {
        if(widget.secc.children_secc.length <= widget.secc.multiplicador){
          widget.secc.addChild();
        }else{
          _showDialog();
        }
        if (widget.secc.id_seccion == Utilidades.familiarSeccion) {
          widget.actualizarCodigoPostalFamiliares();
        }

      });
    }

    //TODO: Pedir a los de Backend que pongan una bandera de combo tipo consulta
    if(widget.secc.id_seccion== 6 && widget.secc.campos[0].etiqueta=="Plan"){
      widget.secc.campos[0].esConsulta = true;
    }

    /*if(widget.secc.id_seccion == 11){
      return Container();
    }*/


    //El primero
    if(widget.i==0){

      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
                itemCount: widget.secc.campos.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {
                  return Visibility(
                    visible: widget.secc.campos[index].visible,
                    child: CampoDinamico(
                      key: ValueKey(
                          widget.secc.campos[index].id_seccion.toString() +
                              '_' +
                              widget.secc.campos[index].id_campo.toString() +
                              '_' +
                              DateTime.now().millisecondsSinceEpoch.toString()),
                      campo: widget.secc.campos[index],
                      agregarDicc: widget.agregarDicc,
                      actualizarSecciones: widget.actualizarSecciones,
                      actualizarCodigoPostalFamiliares:
                      actualizarCodigoPostalFamiliares,
                      validarCodigoPostalFamiliares:
                      widget.validarCodigoPostalFamiliares,
                    ),
                  );
                }),


          ]);

    }

    if (widget.secc.multiplicador>0) { //Para sección multiplicable, agregar botonera

      if(widget.secc.filtrable){

        if(!widget.secc.existeUnCampoVisible()){
          return Container();
        }
        return Column( children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              widget.secc.seccion,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: AppColors.color_titulo,
                  fontSize: 20),
            ),
          ),
          ListView.builder(
              itemCount: widget.secc.children_secc.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int seccindex) {
                var _seccion = widget.secc.children_secc[seccindex];
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _camposVisibles(_seccion.campos) ? Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        width: double.infinity,
                        child: Text(
                          _seccion.seccion,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: AppColors.color_titulo,
                              fontSize: 20),
                        ),
                      ): Container(),
                      ListView.builder(
                          itemCount: _seccion.campos.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Visibility(
                              visible: _seccion.campos[index].visible,
                              child: CampoDinamico(
                                key: ValueKey(
                                    _seccion.campos[index].id_seccion.toString() +
                                        '_' +
                                        _seccion.campos[index].id_campo.toString() +
                                        '_' +
                                        DateTime.now().millisecondsSinceEpoch.toString()),
                                campo: _seccion.campos[index],
                                agregarDicc: widget.agregarDicc,
                                actualizarSecciones: widget.actualizarSecciones,
                                actualizarCodigoPostalFamiliares:
                                actualizarCodigoPostalFamiliares,
                                validarCodigoPostalFamiliares:
                                widget.validarCodigoPostalFamiliares,
                              ),
                            );
                          }),
                    ]);
              }),
        ], );

        /*return Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.secc.seccion,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Utilidades.color_titulo,
                      fontSize: 20),
                ),
              ),
            ListView.builder(
                itemCount: widget.secc.children_secc.length,
                //itemCount: _aseguradosList.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {


                  if(!widget.secc.children_secc[index].existeUnCampoVisible()){
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SeccionDinamica(secc: widget.secc.children_secc[index],agregarDicc: widget.agregarDicc, actualizarSecciones: widget.actualizarSecciones, borrarAdicional: widget.borrarAdicional,),
                  );
                  //return _aseguradosList[index];
                }),
          ],
        );*/

      } else {
        return Column(
          children: <Widget>[
            ListView.builder(
                itemCount: widget.secc.children_secc.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: SeccionDinamica(secc: widget.secc.children_secc[index],agregarDicc: widget.agregarDicc, actualizarSecciones: widget.actualizarSecciones, borrarAdicional: widget.borrarAdicional,),
                  );
                  //return _aseguradosList[index];
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: widget.secc.multiplicador>=1,
                child: Visibility(
                  visible: widget.secc.children_secc.length <= widget.secc.multiplicador-1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: _aumentar,
                              heroTag: "btn1",
                              tooltip: "Agregar "+ widget.secc.seccion,
                              child: const Icon(Icons.add, color: Colors.white,),
                              backgroundColor: AppColors.color_primario,
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 6, child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(botonAgregarEtiqueta(widget.secc.id_seccion), style: TextStyle(color:AppColors.color_primario, fontSize: 16),),
                      )),
                      Visibility(
                        visible: widget.secc.children_secc.isNotEmpty,
                        child: Expanded(
                          flex: 2,
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Container(),/* FittedBox(
                              child: FloatingActionButton(
                                onPressed: _decrementar,
                                heroTag: "btn2",
                                tooltip: "Eliminar",
                                child: Icon(Icons.delete, color: Utilidades.color_primario,),
                                backgroundColor: Colors.white,
                                elevation: 0.5,
                              ),
                            ), */
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      }

    } else {

      if(widget.secc.campos.length>0){
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                  flex: 3,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.secc.seccion,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: AppColors.color_titulo,
                            fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _borrarSeccion(widget.secc.hashCode);
                          });

                        },
                        child: widget.secc.id_seccion == Utilidades.familiarSeccion ? Center(
                          child: Ink(
                            child: IconButton(
                              icon: Icon(Icons.delete_outline),
                              color: AppColors.color_primario,
                              onPressed: () {
                                _borrarSeccion(widget.secc.hashCode);
                              },
                            ),
                          ),
                        ): Container(),
                      ),
                    ],
                  ),
                ),


              ],),
              ListView.builder(
                  itemCount: widget.secc.campos.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new CampoDinamico(
                      campo: widget.secc.campos[index],
                      agregarDicc: widget.agregarDicc,
                      actualizarSecciones: widget.actualizarSecciones,
                      actualizarCodigoPostalFamiliares:
                      actualizarCodigoPostalFamiliares,
                      validarCodigoPostalFamiliares:
                      widget.validarCodigoPostalFamiliares,
                    );
                  }),
            ]);

      }else{
        return Container();
      }

    }
  }
}

class CampoDinamico extends StatefulWidget {
  CampoDinamico({Key key, this.campo, this.agregarDicc, this.actualizarSecciones,
    this.actualizarCodigoPostalFamiliares,
    this.validarCodigoPostalFamiliares,
  }) : super(key: key);

  final Campo campo;
  final void Function(String, String) agregarDicc;
  final void Function(String) actualizarSecciones;
  final void Function() actualizarCodigoPostalFamiliares;
  final bool Function() validarCodigoPostalFamiliares;


  @override
  _CampoDinamicoState createState() => _CampoDinamicoState();
}

class _CampoDinamicoState extends State<CampoDinamico> {
  @override
  Widget build(BuildContext context) {
    switch (widget.campo.tipo_componente) {
      case "select":
        {
          if (widget.campo.valores.isNotEmpty) {

            bool bandera = true;
            for (int i =0 ; i<widget.campo.valores.length && bandera; i++){
              if(widget.campo.valores[i].children.length>0){
                bandera = false;
              }
            }

            if(!bandera){
              return ComboBoxDependiente(
                campo: widget.campo,
                agregarDicc: widget.agregarDicc,
                actualizarSecciones: widget.actualizarSecciones,
              );
            }else{
              return ComboBoxDinamico(
                campo: widget.campo,
                agregarAlDiccionario: widget.agregarDicc,
                actualizarSecciones: widget.actualizarSecciones,
              );
            }

          }else{
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Error: El campo select "+ widget.campo.id_campo.toString() + " no contiene valores"),
            );
          }
          break;

        }

      case "textbox":
        {
          return CustomTextField(campo: widget.campo,
            actualizarCodigoPostalFamiliares:
            widget.actualizarCodigoPostalFamiliares,
            validarCodigoPostalFamiliares: widget.validarCodigoPostalFamiliares,
          );
        }

      case "input":
        {
          return CustomTextField(campo: widget.campo,
            actualizarCodigoPostalFamiliares:
            widget.actualizarCodigoPostalFamiliares,
            validarCodigoPostalFamiliares: widget.validarCodigoPostalFamiliares,
          );
        }

      case "checkbox":
        {

          if(widget.campo.valores!=null){
            if(widget.campo.valores.length > 0){
              if(widget.campo.valores[0].children != null && widget.campo.valores[0].children.length>0){
                return CheckBoxDinamicoDependiente(campo: widget.campo, agregarAlDiccionario: widget.agregarDicc, actualizarSecciones: widget.actualizarSecciones,);

              }
            }

          }


          return CheckBoxDinamico(campo: widget.campo, actualizarSecciones: widget.actualizarSecciones, agregarAlDiccionario: widget.agregarDicc,);
        }

      case "calendar":
        {
          return CalendarioDinamicoRange(campo: widget.campo);
        }

      case "date_relativa":
        {
          return CalendarioConRangoRelativo(campo: widget.campo, actualizarSecciones: widget.actualizarSecciones, agregarAlDiccionario: widget.agregarDicc,);
        }

      case "button":
        {
          return BotonDinamicoBorde(
            titulo: widget.campo,
          );
        }


      case "label":
        {
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Visibility(

                visible: widget.campo.visible,
                child: Text(widget.campo.etiqueta ,style: TextStyle(color: AppColors.color_primario, fontWeight: FontWeight.w400, fontSize: 16))),
          );
        }

      case "switch":
        {


          if(widget.campo.valores[0].children.length>0){
            return SwitchConImagenDependiente(
              campo: widget.campo,
              agregarAlDiccionario: widget.agregarDicc,
              actualizarSecciones: widget.actualizarSecciones,
            );
          }
          return SwitchConImagen(
            campo: widget.campo,
          );
        }

      case "toggle":
        {
          // return CheckBoxDinamicoDependiente(campo: widget.campo, actualizarSecciones: widget.actualizarSecciones, agregarAlDiccionario: widget.agregarDicc,);
          return ToggleConValores(campo: widget.campo, actualizarSecciones: widget.actualizarSecciones, agregarAlDiccionario: widget.agregarDicc,);
        }

      case "select_con_post":
        {

          return ComboBoxDinamico(campo: widget.campo,);
        }

      case "card":
        {

          return CardCoberturas(campo: widget.campo,);

        }


      default:
        {
          return Container(child:
          Text(widget.campo.nombre_campo),);
        }
    }
  }
}
