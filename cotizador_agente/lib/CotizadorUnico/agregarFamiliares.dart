import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/CotizadorUnico/FormularioPaso1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgregarFamiliares extends StatefulWidget {
  Seccion secc;
  Function callbackFam;
  final void Function(String, String) agregarDicc;
  final void Function(String) actualizarSecciones;
  final Function actualizarCodigoPostalFamiliares;
  final bool Function() validarCodigoPostalFamiliares;
  Function actualizarVista;
  bool edicionDatos;
  String numFamiliar;

  AgregarFamiliares({Key key, this.secc, this.callbackFam, this.agregarDicc, this.actualizarSecciones, this.actualizarCodigoPostalFamiliares, this.validarCodigoPostalFamiliares, this.actualizarVista, this.edicionDatos, this.numFamiliar}) : super(key: key);
  @override
  _AgregarFamiliaresState createState() => _AgregarFamiliaresState();
}

class _AgregarFamiliaresState extends State<AgregarFamiliares> {

  final formKey = GlobalKey<FormState>();
  bool formularioValido;
  TextEditingController _controllerNombre;
  TextEditingController _controllerApellidoPaterno;
  TextEditingController _controllerApellidoMaterno;
  TextEditingController _controllerEdad;
  TextEditingController _controllerCP;
  String numeroFamiliar;

  @override
  void initState() {
    final mainHolder = Utilidades.buscaCampoPorID(
        Utilidades.titularSeccion, Utilidades.titularCampo, false);
    final mainHolderZip = mainHolder?.first?.valor ?? "";
    _controllerNombre = new TextEditingController();
    _controllerApellidoPaterno = new TextEditingController();
    _controllerApellidoMaterno = new TextEditingController();
    _controllerEdad = new TextEditingController();
    _controllerCP = new TextEditingController(text: mainHolderZip);
    formularioValido = false;

    if(!widget.edicionDatos){
      widget.secc.campos[4].valor = "1";
      widget.secc.campos[6].valor = null;
      widget.secc.campos[9].valor = "false";
      widget.secc.campos[10].valor = "false";
      int numCotizaciones = Utilidades.cotizacionesApp.getCurrentLengthLista();
      List<Seccion> secFamiliar = Utilidades.cotizacionesApp.getCotizacionElement(numCotizaciones-1).paso1.secciones[3].children_secc;
      numeroFamiliar = (secFamiliar.length +1).toString();
    } else{
      _controllerNombre.text = widget.secc.campos[1].valor;
      _controllerApellidoPaterno.text = widget.secc.campos[2].valor;
      _controllerApellidoMaterno.text = widget.secc.campos[3].valor;
      _controllerEdad.text = widget.secc.campos[5].valor;
      _controllerCP.text = widget.secc.campos[7].valor;
      numeroFamiliar = widget.numFamiliar;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Function actualizarCodigoPostalFamiliares = widget.actualizarCodigoPostalFamiliares;

    String codigoPostal = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Agregar familiar", style: TextStyle(
          color: ColorsCotizador.texto_tabla_comparativa,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500,
        )),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: ColorsCotizador.secondary900,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,

                color: ColorsCotizador.color_background,
                child: Container(
                  margin: EdgeInsets.only(left: 16, top: 32,bottom: 32),
                  child: Text( "Familiar ${numeroFamiliar}",
                    style: TextStyle(
                      letterSpacing: 0.15,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorsCotizador.color_titleAlert
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16, left: 16),
                child: ListView.builder(
                    itemCount: widget.secc.campos.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext ctxt, int index) {
                      if(index == 1){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.color_background_blanco,
                                    border: Border(
                                        bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                child: Visibility(
                                  visible: widget.secc.campos[index].visible,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        height: 50,
                                        child: new SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          reverse: true,
                                          child: TextFormField(
                                            controller: _controllerNombre,
                                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.secc.campos[index].reg_ex)), //[0-9]
                                              LengthLimitingTextInputFormatter(widget.secc.campos[index].dato_longitud!=null ? widget.secc.campos[index].dato_longitud.length == 2 ?  widget.secc.campos[index].dato_longitud[1] : widget.secc.campos[index].dato_longitud[0]: null ,)],
                                            enabled: true,
                                            maxLengthEnforced: true,
                                            keyboardType: TextInputType.text,
                                            validator:(value) {
                                              setState(() {
                                                print("validando"+ value);
                                                widget.secc.campos[index].isValid = widget.secc.campos[index].validaCampo(value);
                                              });
                                              return null;

                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),

                                              //labelStyle: TextStyle(color: AppColors.color_primario),
                                              labelText: widget.secc.campos[index].obligatorio == true ? widget.secc.campos[index].etiqueta + " *" : widget.secc.campos[index].etiqueta,
                                              labelStyle: TextStyle(
                                                  color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5,fontFamily: 'Roboto'),
                                              //labelText: widget.campo.etiqueta),
                                            ),
                                            onChanged: (valor) {

                                              print("onChanged-->${widget.secc.campos[index].nombre_campo}");
                                              //widget.secc.campos[index].valor = valor;

                                              if ( (widget.secc.campos[index].id_seccion == Utilidades.titularSeccion && widget.secc.campos[index].id_campo == Utilidades.titularCampo) ) {
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                                                  /*if (valor.length == 5) {
                                                    codigoPostal = valor;
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Aviso'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(Mensajes.cambioCP),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text('Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('Aceptar'),
                                                              onPressed: () {
                                                                Utilidades.actualizarCodigoPostalAdicional = true;
                                                                actualizarCodigoPostalFamiliares();
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),

                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }*/
                                                }
                                              }
                                              // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                                              if(widget.secc.campos[index].id_seccion == null && widget.secc.campos[index].id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal) {
                                                  if(widget.validarCodigoPostalFamiliares == null){
                                                    if (valor.length == 5) {
                                                      //codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                    }
                                                  }else if(widget.validarCodigoPostalFamiliares() == true){
                                                    /*if (valor.length == 5) {
                                                      codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(Mensajes.cambioCP),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Cancelar'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Aceptar'),
                                                                onPressed: () {
                                                                  Utilidades.actualizarCodigoPostalAdicional = true;
                                                                  actualizarCodigoPostalFamiliares();
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),

                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }*/
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.secc.campos[index].error != "" ? true : false,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    widget.secc.campos[index].error,
                                    style: TextStyle(color: ColorsCotizador.color_primario, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(index == 2){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.color_background_blanco,
                                    border: Border(
                                        bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                child: Visibility(
                                  visible: widget.secc.campos[index].visible,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        height: 50,
                                        child: new SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          reverse: true,
                                          child: TextFormField(
                                            controller: _controllerApellidoPaterno,
                                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.secc.campos[index].reg_ex)), //[0-9]
                                              LengthLimitingTextInputFormatter(widget.secc.campos[index].dato_longitud!=null ? widget.secc.campos[index].dato_longitud.length == 2 ?  widget.secc.campos[index].dato_longitud[1] : widget.secc.campos[index].dato_longitud[0]: null ,)],
                                            enabled: true,
                                            maxLengthEnforced: true,
                                            keyboardType: TextInputType.text,
                                            validator:(value) {
                                              setState(() {
                                                print("validando"+ value);
                                                widget.secc.campos[index].isValid = widget.secc.campos[index].validaCampo(value);
                                              });
                                              return null;

                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),

                                              //labelStyle: TextStyle(color: AppColors.color_primario),
                                              labelText: widget.secc.campos[index].obligatorio == true ? widget.secc.campos[index].etiqueta + " *" : widget.secc.campos[index].etiqueta,
                                              labelStyle: TextStyle(
                                                  color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5,fontFamily: 'Roboto'),
                                              //labelText: widget.campo.etiqueta),
                                            ),
                                            onChanged: (valor) {

                                              print("onChanged-->${widget.secc.campos[index].nombre_campo}");
                                              //widget.secc.campos[index].valor = valor;

                                              if ( (widget.secc.campos[index].id_seccion == Utilidades.titularSeccion && widget.secc.campos[index].id_campo == Utilidades.titularCampo) ) {
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                                                  /*if (valor.length == 5) {
                                                    codigoPostal = valor;
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Aviso'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(Mensajes.cambioCP),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text('Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('Aceptar'),
                                                              onPressed: () {
                                                                Utilidades.actualizarCodigoPostalAdicional = true;
                                                                actualizarCodigoPostalFamiliares();
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),

                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }*/
                                                }
                                              }
                                              // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                                              if(widget.secc.campos[index].id_seccion == null && widget.secc.campos[index].id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal) {
                                                  if(widget.validarCodigoPostalFamiliares == null){
                                                    if (valor.length == 5) {
                                                      //codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                    }
                                                  }else if(widget.validarCodigoPostalFamiliares() == true){
                                                    /*if (valor.length == 5) {
                                                      codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(Mensajes.cambioCP),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Cancelar'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Aceptar'),
                                                                onPressed: () {
                                                                  Utilidades.actualizarCodigoPostalAdicional = true;
                                                                  actualizarCodigoPostalFamiliares();
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),

                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }*/
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.secc.campos[index].error != "" ? true : false,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    widget.secc.campos[index].error,
                                    style: TextStyle(color: ColorsCotizador.color_primario, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else  if(index == 3){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.color_background_blanco,
                                    border: Border(
                                        bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                child: Visibility(
                                  visible: widget.secc.campos[index].visible,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        height: 50,
                                        child: new SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          reverse: true,
                                          child: TextFormField(
                                            controller: _controllerApellidoMaterno,
                                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.secc.campos[index].reg_ex)), //[0-9]
                                              LengthLimitingTextInputFormatter(widget.secc.campos[index].dato_longitud!=null ? widget.secc.campos[index].dato_longitud.length == 2 ?  widget.secc.campos[index].dato_longitud[1] : widget.secc.campos[index].dato_longitud[0]: null ,)],
                                            enabled: true,
                                            maxLengthEnforced: true,
                                            validator:(value) {
                                              setState(() {
                                                print("validando"+ value);
                                                widget.secc.campos[index].isValid = widget.secc.campos[index].validaCampo(value);
                                              });
                                              return null;

                                            },
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),

                                              //labelStyle: TextStyle(color: AppColors.color_primario),
                                              labelText: widget.secc.campos[index].obligatorio == true ? widget.secc.campos[index].etiqueta + " *" : widget.secc.campos[index].etiqueta,
                                              labelStyle: TextStyle(
                                                  color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5,fontFamily: 'Roboto'),
                                              //labelText: widget.campo.etiqueta),
                                            ),
                                            onChanged: (valor) {

                                              print("onChanged-->${widget.secc.campos[index].nombre_campo}");
                                              //widget.secc.campos[index].valor = valor;

                                              if ( (widget.secc.campos[index].id_seccion == Utilidades.titularSeccion && widget.secc.campos[index].id_campo == Utilidades.titularCampo) ) {
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                                                  /*if (valor.length == 5) {
                                                    codigoPostal = valor;
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Aviso'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(Mensajes.cambioCP),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text('Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('Aceptar'),
                                                              onPressed: () {
                                                                Utilidades.actualizarCodigoPostalAdicional = true;
                                                                actualizarCodigoPostalFamiliares();
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),

                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }*/
                                                }
                                              }
                                              // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                                              if(widget.secc.campos[index].id_seccion == null && widget.secc.campos[index].id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal) {
                                                  if(widget.validarCodigoPostalFamiliares == null){
                                                    if (valor.length == 5) {
                                                      //codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                    }
                                                  }else if(widget.validarCodigoPostalFamiliares() == true){
                                                    /*if (valor.length == 5) {
                                                      codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(Mensajes.cambioCP),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Cancelar'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Aceptar'),
                                                                onPressed: () {
                                                                  Utilidades.actualizarCodigoPostalAdicional = true;
                                                                  actualizarCodigoPostalFamiliares();
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),

                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }*/
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.secc.campos[index].error != "" ? true : false,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    widget.secc.campos[index].error,
                                    style: TextStyle(color: ColorsCotizador.color_primario, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(index == 5){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.color_background_blanco,
                                    border: Border(
                                        bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                child: Visibility(
                                  visible: widget.secc.campos[index].visible,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        height: 50,
                                        child: new SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          reverse: true,
                                          child: TextFormField(
                                            controller: _controllerEdad,
                                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.secc.campos[index].reg_ex)), //[0-9]
                                              LengthLimitingTextInputFormatter(widget.secc.campos[index].dato_longitud!=null ? widget.secc.campos[index].dato_longitud.length == 2 ?  widget.secc.campos[index].dato_longitud[1] : widget.secc.campos[index].dato_longitud[0]: null ,)],
                                            enabled: true,
                                            maxLengthEnforced: true,
                                            keyboardType: widget.secc.campos[index].tipo_dato=="integer" || widget.secc.campos[index].reg_ex == "[0-9]" ?TextInputType.number:TextInputType.text,
                                            validator:(value) {
                                              setState(() {
                                                print("validando"+ value);
                                                widget.secc.campos[index].isValid = widget.secc.campos[index].validaCampo(value);
                                              });
                                              return null;

                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),

                                              //labelStyle: TextStyle(color: AppColors.color_primario),
                                              labelText: widget.secc.campos[index].obligatorio == true ? widget.secc.campos[index].etiqueta + " *" : widget.secc.campos[index].etiqueta,
                                              labelStyle: TextStyle(
                                                  color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5,fontFamily: 'Roboto'),
                                              //labelText: widget.campo.etiqueta),
                                            ),
                                            onChanged: (valor) {

                                              print("onChanged-->${widget.secc.campos[index].nombre_campo}");
                                              //widget.secc.campos[index].valor = valor;

                                              if ( (widget.secc.campos[index].id_seccion == Utilidades.titularSeccion && widget.secc.campos[index].id_campo == Utilidades.titularCampo) ) {
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                                                  /*if (valor.length == 5) {
                                                    codigoPostal = valor;
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Aviso'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(Mensajes.cambioCP),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text('Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('Aceptar'),
                                                              onPressed: () {
                                                                Utilidades.actualizarCodigoPostalAdicional = true;
                                                                actualizarCodigoPostalFamiliares();
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),

                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }*/
                                                }
                                              }
                                              // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                                              if(widget.secc.campos[index].id_seccion == null && widget.secc.campos[index].id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal) {
                                                  if(widget.validarCodigoPostalFamiliares == null){
                                                    if (valor.length == 5) {
                                                      //codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                    }
                                                  }else if(widget.validarCodigoPostalFamiliares() == true){
                                                    /*if (valor.length == 5) {
                                                      codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(Mensajes.cambioCP),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Cancelar'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Aceptar'),
                                                                onPressed: () {
                                                                  Utilidades.actualizarCodigoPostalAdicional = true;
                                                                  actualizarCodigoPostalFamiliares();
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),

                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }*/
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.secc.campos[index].error != "" ? true : false,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    widget.secc.campos[index].error,
                                    style: TextStyle(color: ColorsCotizador.color_primario, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(index == 7){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: ColorsCotizador.color_background_blanco,
                                    border: Border(
                                        bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                child: Visibility(
                                  visible: widget.secc.campos[index].visible,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        height: 50,
                                        child: new SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          reverse: true,
                                          child: TextFormField(
                                            controller: _controllerCP,
                                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.secc.campos[index].reg_ex)), //[0-9]
                                              LengthLimitingTextInputFormatter(widget.secc.campos[index].dato_longitud!=null ? widget.secc.campos[index].dato_longitud.length == 2 ?  widget.secc.campos[index].dato_longitud[1] : widget.secc.campos[index].dato_longitud[0]: null ,)],
                                            enabled: true,
                                            maxLengthEnforced: true,
                                            keyboardType: TextInputType.number,
                                            validator:(value) {
                                              setState(() {
                                                print("validando"+ value);
                                                widget.secc.campos[index].isValid = widget.secc.campos[index].validaCampo(value);
                                              });
                                              return null;

                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.transparent)),

                                              //labelStyle: TextStyle(color: AppColors.color_primario),
                                              labelText: widget.secc.campos[index].obligatorio == true ? widget.secc.campos[index].etiqueta + " *" : widget.secc.campos[index].etiqueta,
                                              labelStyle: TextStyle(
                                                  color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5,fontFamily: 'Roboto'),
                                              //labelText: widget.campo.etiqueta),
                                            ),
                                            onSaved: (String value) {
                                              widget.secc.campos[index].valor = value;
                                              print("llegue al onsave " + widget.secc.campos[index].valor);
                                            },
                                            onChanged: (valor) {

                                              print("onChanged-->${widget.secc.campos[index].nombre_campo}");
                                              //widget.secc.campos[index].valor = valor;

                                              if ( (widget.secc.campos[index].id_seccion == Utilidades.titularSeccion && widget.secc.campos[index].id_campo == Utilidades.titularCampo) ) {
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                                                  /*if (valor.length == 5) {
                                                    codigoPostal = valor;
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Aviso'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(Mensajes.cambioCP),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text('Cancelar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('Aceptar'),
                                                              onPressed: () {
                                                                Utilidades.actualizarCodigoPostalAdicional = true;
                                                                actualizarCodigoPostalFamiliares();
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),

                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }*/
                                                }
                                              }
                                              // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                                              if(widget.secc.campos[index].id_seccion == null && widget.secc.campos[index].id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                                                //widget.secc.campos[index].valor = valor;
                                                if (valor != codigoPostal) {
                                                  if(widget.validarCodigoPostalFamiliares == null){
                                                    if (valor.length == 5) {
                                                      //codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                    }
                                                  }else if(widget.validarCodigoPostalFamiliares() == true){
                                                    /*if (valor.length == 5) {
                                                      codigoPostal = valor;
                                                      print("VALIDA cuando idsecc null: " + valor.toString());
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false, // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Aviso'),
                                                            content: SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(Mensajes.cambioCP),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Cancelar'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text('Aceptar'),
                                                                onPressed: () {
                                                                  Utilidades.actualizarCodigoPostalAdicional = true;
                                                                  actualizarCodigoPostalFamiliares();
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),

                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }*/
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.secc.campos[index].error != "" ? true : false,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    widget.secc.campos[index].error,
                                    style: TextStyle(color: ColorsCotizador.color_primario, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(index == 0){
                        return Container();
                      }
                      else if (index == 6){
                        return seRequiereAntiguedad ? new CampoDinamico(
                          campo: widget.secc.campos[index],
                          agregarDicc: widget.agregarDicc,
                          actualizarSecciones: widget.actualizarSecciones,
                          actualizarCodigoPostalFamiliares:
                          actualizarCodigoPostalFamiliares,
                          validarCodigoPostalFamiliares:
                          widget.validarCodigoPostalFamiliares,
                        ) : Container();
                      }
                      else if (index == 10){
                        return  seRequiereGarantiaCoaseguro ? new CampoDinamico(
                          campo: widget.secc.campos[index],
                          agregarDicc: widget.agregarDicc,
                          actualizarSecciones: widget.actualizarSecciones,
                          actualizarCodigoPostalFamiliares:
                          actualizarCodigoPostalFamiliares,
                          validarCodigoPostalFamiliares:
                          widget.validarCodigoPostalFamiliares,
                        ) : Container();
                      }
                      else {
                        return  new CampoDinamico(
                          campo: widget.secc.campos[index],
                          agregarDicc: widget.agregarDicc,
                          actualizarSecciones: widget.actualizarSecciones,
                          actualizarCodigoPostalFamiliares:
                          actualizarCodigoPostalFamiliares,
                          validarCodigoPostalFamiliares:
                          widget.validarCodigoPostalFamiliares,
                        );
                      }
                    }
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:(){
                  setState(() {
                    print("---> widget.callbackFam");

                    //formKey.currentState.save();

                    /*setState(() {

                      List<Campo> campos =  Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().obtenerSeccionesSimplificadas();


                      for(int i=0; (i < campos.length) && formularioValido; i++){

                        if(campos[i].isValid == false){
                          formularioValido = false;
                        }
                        //en paso1 no se valida la seccion 6 que corresponde a plan
                        if( (campos[i].obligatorio ? campos[i].valor == null && campos[i].id_seccion != 6 : false )  ){
                          formularioValido = false;
                        }
                      }

                    });*/

                    print("formularioValido ${formularioValido}");

                    if ((_controllerCP.text != "" && _controllerCP.text.length == 5 ) && ( _controllerEdad.text != "")) {
                      print("validar formulario");
                      widget.secc.campos[1].valor =  _controllerNombre.text;
                      widget.secc.campos[2].valor =  _controllerApellidoPaterno.text;
                      widget.secc.campos[3].valor =  _controllerApellidoMaterno.text;
                      widget.secc.campos[5].valor =  _controllerEdad.text;
                      widget.secc.campos[7].valor =  _controllerCP.text;
                      widget.callbackFam(
                          _controllerNombre.text,
                          _controllerApellidoPaterno.text,
                          _controllerApellidoMaterno.text,
                          widget.secc.campos[4].valor,
                          _controllerEdad.text,
                          _controllerCP.text,
                          widget.secc.campos[6].valor,
                          widget.secc.campos[9].valor,
                          widget.secc.campos[10].valor,
                      );


                        widget.agregarDicc("hola", "hola");
                        widget.actualizarSecciones(valorPlan);


                      Navigator.pop(context, true);

                      if(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON() != null){
                        print(Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().paso1.toJSON());
                      }else{
                        Navigator.pop(context);
                      }
                    } else {
                      print("invalid");
                      Utilidades.mostrarAlerta("Error", "Faltan datos obligatorios por capturar", context);

                    }
                  });

                },
                child: Container(
                    decoration: BoxDecoration(
                      color: ColorsCotizador.secondary900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),

                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text("Guardar", style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ), textAlign: TextAlign.center),
                    )),
              )
            ],
          ),
        )
      )
    );
  }
}
