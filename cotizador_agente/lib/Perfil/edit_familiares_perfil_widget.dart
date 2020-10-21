import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/main.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/CustomSwipePage.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/modelos/PerfilSaludModel.dart';
import 'package:cotizador_agente/Perfil/PerfilPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';


SharedPreferences prefs;
Map datosMapAgentes;
String idParticipante;

class EditFamiliaresPerfilWidget extends StatefulWidget {
  EditFamiliaresPerfilWidget({
    Key key,
  }) : super(key: key);

  @override
  _EditFamiliaresPerfilWidgetState createState() =>
      new _EditFamiliaresPerfilWidgetState();
}

class User {
  const User(this.name);

  final String name;
}

var nullArray = [" "];
List<DropdownMenuItem<String>> dropDownMenuFamiliaresItems;

class _EditFamiliaresPerfilWidgetState
    extends State<EditFamiliaresPerfilWidget> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List _parentesco = [
    "Esposa(o)",
    "Novia(o)",
    "Hija(o)",
    "Mascota",
    "Personalizado"
  ];

  bool _saving = false;
  final FocusNode myFocusNodeTallaPlayeraOtros = FocusNode();
  TextEditingController otrosTallaPlayeraController =
      new TextEditingController();

  var config;
  String jsonString;

  Future<PerfilSaludModel> fetchPost(BuildContext context) async {
  //  printLog("edit_familiares_perfil_page", "fetchPost");
    config = AppConfig.of(context);
    try {
      Map lMapJson = {};
      int idrealcionPersona = 0;
      int idrealcionMascota = 0;
      List fam = [];
      List masc = [];

      for (int i = 0; i < listFamiliaresEdit.length; i++) {
        if (listFamiliaresEdit.elementAt(i).parentesco != "Mascota") {
          listFamiliaresEdit.elementAt(i).idRelacion = idrealcionPersona;
          fam.add(listFamiliaresEdit.elementAt(i).toList());
          idrealcionPersona++;
        } else {
          listFamiliaresEdit.elementAt(i).idRelacion = idrealcionMascota;
          masc.add(listFamiliaresEdit.elementAt(i).toList());
          idrealcionMascota++;
        }
      }
      lMapJson["familiares"] = fam.toList();
      lMapJson["mascotas"] = masc.toList();
      //printLog("edit_familiares_perfil_page", "============================== mapa for Test:   " +   lMapJson.toString());

      jsonString = json.encode(lMapJson);
      print("el JSON***************" + jsonString);
      final responsePut = await http.put(
          config.serviceBCA + '/app/datos-familiares/' + idParticipante,
          body: jsonString,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": config.apikeyBCA
          });
    //  printLog("edit_familiares_perfil_page", "creacion del jsonString");

      if (responsePut != null) {
      //  printLog("edit_familiares_perfil_page", "responsePut");

       // printLog("Response.body => ", responsePut.body);
        if (responsePut.statusCode == 200) {
       //   printLog("edit_familiares_perfil_page", "responsePut 200");
         // printLog("edit_familiares_perfil_page", jsonString);
          Map putMap = json.decode(responsePut.body.toString());
          //printLog("edit_familiares_perfil_page", "putMap");
          //printLog("edit_familiares_perfil_page", putMap.toString());
          if (putMap['success'] == false) {
            //no existe usuario se guardara
            //printLog("edit_familiares_perfil_page", "if succes false");
            try {
              //printLog("edit_familiares_perfil_page", "if succes false try");
              final responsePost = await http.post(
                  config.serviceBCA + '/app/datos-familiares/' + idParticipante,
                  body: jsonString,
                  headers: {
                    "Content-Type": "application/json",
                    "x-api-key": config.apikeyBCA
                  });
              //printLog("edit_familiares_perfil_page", "responsePost");
              //printLog(    "edit_familiares_perfil_page", responsePost.body.toString());
              if (responsePost != null) {
               // printLog("edit_familiares_perfil_page", "responsePost null");
                if (responsePost.statusCode == 200) {
                 // printLog("edit_familiares_perfil_page", "responsePost 200");
                  Map postMap = json.decode(responsePost.body.toString());
                  //printLog("edit_familiares_perfil_page", "postMap");
                 // printLog("edit_familiares_perfil_page", postMap.toString());
                  if (postMap['success'] == true) {
                   // printLog("edit_familiares_perfil_page", "success postMap");
                    saveData();
                    setState(() {
                      _saving = false;
                    });
                    customAlert(
                        AlertDialogType.guardarExito, context, "", "");
                  } else {
                    //printLog(     "edit_familiares_perfil_page", "succes false 1224");
                    setState(() {
                      _saving = false;
                    });
                    customAlert(
                        AlertDialogType.guardarFallo, context, "", "");
                  }
                } else {
                  printLog(
                      "edit_familiares_perfil_page", "actualizar 1223 status");
                  setState(() {
                    _saving = false;
                  });
                  customAlert(AlertDialogType.guardarFallo, context, "", "");
                }
              } else {
                //null
                printLog("edit_familaires_perfil_page", "null actulizar 1222");
                setState(() {
                  _saving = false;
                });
                customAlert(AlertDialogType.guardarFallo, context, "", "");
              }
            } catch (e) {
              printLog("edit_familiares_perfil_page", "catch actualizar 1221");
              setState(() {
                _saving = false;
              });
              customAlert(AlertDialogType.guardarFallo, context, "", "");
            }
          } else {
            //actulización exitosa
            printLog("edit_familiares_perfil_page", "catch actualizar 1221");
            saveData();
            setState(() {
              _saving = false;
            });
            customAlert(AlertDialogType.guardarExito, context, "", "");
          }
        } else {
          //   !=200
          printLog("edit_familiares_perfil_page", "insertar 1213 status");
          setState(() {
            _saving = false;
          });
          customAlert(AlertDialogType.guardarFallo, context, "", "");
        }
      } else {
        //null
        printLog("edit_familiares_perfil_page", "null insertar 1212");
        setState(() {
          _saving = false;
        });
        customAlert(AlertDialogType.guardarFallo, context, "", "");
      }
    } catch (e) {
      printLog("edit_familiares_perfil_page", "catch");
      printLog("edit_familiares_perfil_page", "Error insertar: $e");
      setState(() {
        _saving = false;
      });
      customAlert(AlertDialogType.guardarFallo, context, "", "");

      return null;
    }
    return null;
  }

  Future<String> getIdParticipante() async {
    prefs = await SharedPreferences.getInstance();
    Map datos = json.decode(prefs.getString('datosSesion'));
    return datos['idParticipante'];
  }

  Future<Null> _refreshIdParticipante() {
    printLog("edit_familiares_perfil_page", "_refreshIdParticipante");
    return getIdParticipante().then((_idParticipante) {
      setState(
        () => idParticipante = _idParticipante,
      );
    });
  }

  void backTwo() {
    Navigator.pop(context, true);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    printLog("edit_familiares_perfil_page", "initState");
    _refreshIdParticipante();
    dropDownMenuFamiliaresItems = getDropDownMenuItems();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String parentesco in _parentesco) {
      items.add(
          new DropdownMenuItem(value: parentesco, child: new Text(parentesco)));
    }
    return items;
  }

  Future<bool> _onBackPress() {
    customAlert(AlertDialogType.backEdicionConDatos, context, "", "");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: _buildForm(context),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    print("buildForm trayectoria");
    Form form = new Form(
        key: _formKey,
        child: new Column(children: [
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  // color:  Colors.cyan,
                  margin: const EdgeInsets.only(right: 16.0, left: 24),
                  width: 24,
                  height: 24.0,
                  child: Image.asset(
                    'images/perfil/familiares/ic_perfil_familiares@4x.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Agregar Familiares',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Theme.Colors.gnpBlue,
                      fontSize: 18.0,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  // color:  Colors.cyan,
                  margin: const EdgeInsets.only(right: 24.0),
                  width: 24,
                  height: 24.0,
                  child: GestureDetector(
                    onTap: () {
                      handleUserInteraction();
                      setState(() {
                        addWidgetGlo(familiares.length + 1);
                      });
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: new Text("Agregado",
                                    style: TextStyle(
                                        color: Theme.Colors.gnpBlue,
                                        fontSize: 16.0,
                                        fontFamily: "Roboto")),
                                content: new Text("Se agrego un campo ",
                                    style: TextStyle(
                                        color: Theme.Colors.gnpBlue,
                                        fontSize: 12.0,
                                        fontFamily: "Roboto")),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text("ACEPTAR",
                                          style: TextStyle(
                                              color: Theme.Colors.Orange,
                                              fontSize: 16.0,
                                              fontFamily: "Roboto")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ],
                              ));
                    },
                    child: Image.asset(
                      'images/perfil/familiares/ic_agregar@4x.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ]),
            flex: 1,
          ),
          Expanded(
            flex: 6,
            child: MySwipePage(parentescos: _parentesco),
          ),
          Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        //width: 200.0,
                        margin: const EdgeInsets.only(top: 15),
                        child: RaisedButton(
                          onPressed: () {
                            handleUserInteraction();
                            _onBackPress();
                          },
                          color: Colors.deepOrange,
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 17.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        //width: 200.0,
                        margin: const EdgeInsets.only(top: 15),
                        child: RaisedButton(
                          onPressed: () {
                            handleUserInteraction();
                            // devolverá true si el formulario es válido, o falso si
                            // el formulario no es válido.
                            bool valid = false;
                            printLog("edit_familiares_perfil_page",
                                "%%%%% listFamiliaresEdit.tostring %%%%");
                            printLog("edit_familiares_perfil_page",
                                listFamiliaresEdit.toString());
                            //if (_formKey.currentState.validate()) {
                            listFamiliaresEdit.length < 1
                                ? valid = true
                                : valid = false;
                            for (int i = 0;
                                i < listFamiliaresEdit.length;
                                i++) {
                              if (listFamiliaresEdit.elementAt(i).parentesco !=
                                      "Mascota" &&
                                  listFamiliaresEdit
                                          .elementAt(i)
                                          .nameController
                                          .text !=
                                      "" &&
                                  listFamiliaresEdit
                                          .elementAt(i)
                                          .apellidoPatController
                                          .text !=
                                      "" &&
                                  listFamiliaresEdit
                                          .elementAt(i)
                                          .apellidoMatController
                                          .text !=
                                      "") {
                                print(
                                    "Seteando validación campos persona true");
                                valid = true;
                              } else if (listFamiliaresEdit
                                          .elementAt(i)
                                          .parentesco ==
                                      "Mascota" &&
                                  listFamiliaresEdit
                                          .elementAt(i)
                                          .nameController
                                          .text !=
                                      "") {
                                print(
                                    "Seteando validación campos mascota true");
                                valid = true;
                              } else {
                                print("Seteando false");
                                valid = false;
                              }
                            }
                            // Si el formulario es válido, queremos mostrar un Snackbar
                            if (valid) {
                              fetchPost(context);
                              setState(() {
                                _saving = true;
                              });
                            } else {
                              printLog("edit_familiares_perfil_page",
                                  "else => campos obligatorios");
                              customAlert(AlertDialogType.campoRequerido,
                                  context, "", "");
                              //_showFromOnlyValue();
                            }
                          },
                          color: Colors.deepOrange,
                          child: Text(
                            'GUARDAR',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 17.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ])),
        ]));
    var l = new List<Widget>();
    l.add(form);
    if (_saving) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.7,
            child: const ModalBarrier(dismissible: false, color: Colors.black),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }
    return l;
  }

  int getIdSangre(String tipo) {
    int id = 1;
    switch (tipo) {
      case "Esposa(o)":
        id = 1;
        break;
      case "Novia(o)":
        id = 2;
        break;
      case "Hija(o)":
        id = 3;
        break;
      case "Mascota":
        id = 4;
        break;
      case "Personalizado":
        id = 5;
        break;
      default:
        id = 1;
        break;
    }
    return id;
  }

  String getString(var datos) {
    var list = datos;
    String valueDatos;
    try {
      valueDatos = list.join(', ');
    } catch (Exception) {
      valueDatos = "";
    }
    return valueDatos;
  }

  void saveData() {
    try {
      printLog("edit_familiares_perfil_page", "saving data => jsonString");
      printLog("edit_familiares_perfil_page", jsonString);
      printLog("edita_familiales_perfil_page", prefs.getString('datosAgentes'));
      Map persist = json.decode(prefs.getString('datosAgentes'));
      var encodeData = json.decode(jsonString);
      persist['datosFamiliares'] = encodeData;
      print("+++++++++++++persist['datosFamiliares'] ======>");
      print(persist['datosFamiliares']);
      var mapaCodificado = json.encode(persist);
      prefs.setString('datosAgentes', mapaCodificado);
      printLog("edita_familiales_perfil_page", "datosFamiliares ======>");
      printLog("edita_familiales_perfil_page", encodeData.toString());
      printLog("edita_familiales_perfil_page", prefs.getString('datosAgentes'));
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }
}

removeWidgetGlo(int elemet) {
  familiares.removeAt(elemet);
}
