import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
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
      this.cantidad_asegurados, this.actualizarSecciones,
      this.formKey})
      : super(key: key);

  final Seccion secc;
  final int end;
  final int i;
  final int cantidad_asegurados;
  final void Function(String) actualizarSecciones;
  final Function() notifyParent;
  final void Function(String, String) agregarDicc;
  final GlobalKey<FormState> formKey;

  @override
  _SeccionDinamicaState createState() => _SeccionDinamicaState();
}

class _SeccionDinamicaState extends State<SeccionDinamica> with Validadores {
  TextEditingController textFieldController = TextEditingController();

  final colorLetters = const Color(0xFF002E71);

  static List<Widget> _aseguradosList = <Widget>[];

  @override
  void initState() {}

  void _sendDataToSecondScreen(BuildContext context) {
    //String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormularioPaso2(
            text: "test",
          ),
        ));
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
              widget.cantidad_asegurados.toString() +
              " asegurados"),
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
    void _decrementar() {
      setState(() {
        _aseguradosList.removeLast();
        widget.notifyParent();
      });
    }
    void _aumentar() {
      setState(() {
        if (_aseguradosList.length <= widget.cantidad_asegurados - 1) {
          _aseguradosList.add(
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text(
                      widget.secc.seccion,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorLetters,
                          fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                      itemCount: widget.secc.campos.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new CampoDinamico(
                            campo: widget.secc.campos[index],
                            agregarDicc: widget.agregarDicc);
                      }),
                ]),
          );
          widget.notifyParent();
        } else {
          _showDialog();
        }
      });
    }

    if (widget.secc.multiplicador>0) {
      if (_aseguradosList.isEmpty) {
        _aseguradosList.add(
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                widget.secc.seccion,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorLetters,
                    fontSize: 16),
              ),
            ),
            ListView.builder(
                itemCount: widget.secc.campos.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {
                  return new CampoDinamico(campo: widget.secc.campos[index]);
                }),
          ]),
        );
      }

      return Column(
        children: <Widget>[
          ListView.builder(
              itemCount: _aseguradosList.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _aseguradosList[index];
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FloatingActionButton(
                    onPressed: _aumentar,
                    heroTag: "btn1",
                    tooltip: "agrega beneficiario",
                    child: const Icon(Icons.add, color: Colors.white,),
                    backgroundColor: Utilidades.color_primario,

                  ),
                ),
                Expanded(flex: 6, child: Text("Agregar Familiar")),
                Expanded(
                  flex: 2,
                  child: FloatingActionButton(
                    onPressed: _decrementar,
                    heroTag: "btn2",
                    tooltip: "agrega beneficiario",
                    child: const Icon(Icons.delete, color: Colors.white,),
                    backgroundColor: Utilidades.color_primario,
                  ),
                )
              ],
            ),
          ),
          /* Row(
            children: <Widget>[

              Expanded(
                flex: 1,
                child:   RaisedButton(
                  child: Text(
                    'Paso 2',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {

                    _sendDataToSecondScreen(context);
                  },
                )
              ),

            ],
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FlatButton(
                  color: Utilidades.color_primario,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Utilidades.color_titulo,
                  onPressed: () {
                    final bool v = widget.formKey.currentState.validate();
                    if (v) {
                      widget.formKey.currentState.save();
                      _sendDataToSecondScreen(context);
                      print('valida');
                    } else {
                      print("invalid");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CONTINUAR",
                      style: TextStyle(fontSize: 16.0, letterSpacing: 1),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                widget.secc.seccion,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorLetters,
                    fontSize: 16),
              ),
            ),
            ListView.builder(
                itemCount: widget.secc.campos.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {
                  return new CampoDinamico(
                    campo: widget.secc.campos[index],
                    agregarDicc: widget.agregarDicc,
                  );
                }),
          ]);
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
                child: Text(widget.campo.etiqueta ,style: TextStyle(color: Utilidades.color_primario, fontWeight: FontWeight.w400, fontSize: 16))),
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
