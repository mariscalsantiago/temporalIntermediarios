import 'package:cotizador_agente/main.dart';
import 'package:cotizador_agente/vistas/Inicio/LoginServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomRadioItem.dart';

import 'package:cotizador_agente/Modelos/LoginModels.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Styles/Strings.dart' as AppStrings;
import 'Contacto.dart';
import 'Eventos.dart';
import 'Mignp.dart';
import 'Personales.dart';
import 'edit_familiares_perfil_widget.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';

final _formKey = GlobalKey<FormState>();

//Playera
String _currentTShirt;
String lasnumber = "";
int _currentTShirtID;
List<DropdownMenuItem<String>> _dropDownMenuItemsPlayera;
List _playera = [
  "(XS) Extra Chica",
  "(S) Chica",
  "(M) Mediana",
  "(L) Grande",
  "(XL) Extra Grande",
  "(XXL) Extra Extra Grande",
  "(3XL) 3XL Grande"
];

//save
bool _saving = false;

//Codigo postal
DomicilioModel domicilio;

//Acompañante
final FocusNode myFocusNodeAcompanante = FocusNode();
TextEditingController myTextEditControllerAcompanante =
    new TextEditingController();
final FocusNode myFocusNodeAcompaniaParentesco = FocusNode();
TextEditingController myTextEditControllerAcompaniaParentesco =
    new TextEditingController();

//Contacto de emergencia
final FocusNode myFocusNodeContactoEmergenciaNombre = FocusNode();
final FocusNode myFocusNodeContactoEmergenciaNumero = FocusNode();
final FocusNode myFocusNodeContactoEmergenciaParentesco = FocusNode();
TextEditingController myTextEditControllerContactoEmergenciaNombre =
    new TextEditingController();
TextEditingController myTextEditControllerContactoEmergenciaNumero =
    new TextEditingController();
TextEditingController myTextEditControllerContactoEmergenciaParentesco =
    new TextEditingController();

//Edit correo
final FocusNode myFocusNodeEmail = FocusNode();
TextEditingController myTextEditControllerEmail = new TextEditingController();

//Edit universidad
final FocusNode myFocusNodeUniversity = FocusNode();
final FocusNode myFocusNodeCareer = FocusNode();
TextEditingController myTextEditControllerUniversity =
    new TextEditingController();
TextEditingController myTextEditControllerCareer = new TextEditingController();
//Edit telefono
final FocusNode myFocusNodePhone = FocusNode();
TextEditingController myTextEditControllerPhone = new TextEditingController();
//Edit poliza
final FocusNode myFocusNodePolicyNumber = FocusNode();
final FocusNode myFocusNodePolicyStart = FocusNode();
final FocusNode myFocusNodePolicyEnd = FocusNode();
TextEditingController myTextEditControllerPolicyNumber =
    new TextEditingController();
TextEditingController myTextEditControllerPolicyStart =
    new TextEditingController();
TextEditingController myTextEditControllerPolicyEnd =
    new TextEditingController();
//Edit nicname
final FocusNode myFocusNodenNickname = FocusNode();
TextEditingController myTextEditControllerNickname =
    new TextEditingController();
//Edit Pasaporte
final FocusNode myFocusNodenPasaporte = FocusNode();
TextEditingController myTextEditControllerPasaporte =
    new TextEditingController();
final FocusNode myFocusNodenVigenciaPasaporte = FocusNode();
TextEditingController myTextEditControllerVigenciaPasaporte =
    new TextEditingController();
//Edit Deportes y Fumador
final FocusNode myFocusNodenDeportes = FocusNode();
TextEditingController myTextEditControllerDeportes =
    new TextEditingController();
final FocusNode myFocusNodenVigenciaFumador = FocusNode();
TextEditingController myTextEditControllerVigenciaFumador =
    new TextEditingController();
//Edit Condiciones Especiales y Alimenticias
final FocusNode myFocusNodeCondiciones = FocusNode();
TextEditingController myTextEditControllerCondiciones =
    new TextEditingController();
final FocusNode myFocusNodeAlimenticias = FocusNode();
TextEditingController myTextEditControllerAlimenticias =
    new TextEditingController();
//Edit Direccion
final FocusNode myFocusNodeCalle = FocusNode();
final FocusNode myFocusNodeNoExt = FocusNode();
final FocusNode myFocusNodeNoInt = FocusNode();
final FocusNode myFocusNodeCP = FocusNode();
final FocusNode myFocusNodeCiudad = FocusNode();
final FocusNode myFocusNodeEstado = FocusNode();
final FocusNode myFocusNodePais = FocusNode();
TextEditingController myTextEditControllerCalle = new TextEditingController();
TextEditingController myTextEditControllerNoExt = new TextEditingController();
TextEditingController myTextEditControllerNoInt = new TextEditingController();
TextEditingController myTextEditControllerCP = new TextEditingController();
TextEditingController myTextEditControllerCiudad = new TextEditingController();
TextEditingController myTextEditControllerEstado = new TextEditingController();
TextEditingController myTextEditControllerPais = new TextEditingController();

//otros
TextEditingController myTextEditController = new TextEditingController();
TextEditingController alergiasControl = new TextEditingController();
TextEditingController enfermedadesControl = new TextEditingController();

List _blood = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
List<DropdownMenuItem<String>> _dropDownMenuItems;
String radiovalueAlergias;
String radiovalueEnfermedades;
List<RadioModel> colABlod = new List<RadioModel>();
List<RadioModel> colBBlod = new List<RadioModel>();

// tipo de sangre
int radioValueTipoDeSangre = 0;
int radioValueAlergias = 3;
int radioValueEnfermedades = 3;
int radioValueDeportes = 3;
int radioValueFumador = 3;
int radioValueCondiciones = 3;
int radioValueAlimenticias = 3;

//Visa
final FocusNode myFocusNoVisa = FocusNode();
final FocusNode myFocusVigenciaVisa = FocusNode();
TextEditingController myTextEditControllerNoVisa = new TextEditingController();
TextEditingController myTextEditControllerVigenciaVisa =
    new TextEditingController();

//parentesco
String _currentParentesco;
List _parentesco = ["Esposa(o)", "Novia(o)", "Hija(o)", "Personalizado"];
List<DropdownMenuItem<String>> _dropDownMenuItemsParentesco;

String _currentColonia;
List<DropdownMenuItem<String>> _dropDownMenuItemsColonia;

class EdicionDatosPerfil extends StatefulWidget {
  EdicionDatosPerfil({
    Key key,
    this.type,
    this.idAcopaniante,
  }) : super(key: key);
  final editType type;
  final int idAcopaniante;

  @override
  EdicionDatosPerfilState createState() => new EdicionDatosPerfilState();
}

class EdicionDatosPerfilState extends State<EdicionDatosPerfil>
    with SingleTickerProviderStateMixin {
  EdicionDatosPerfilState() {
    myTextEditControllerCP.addListener(() async {
    //  print("addListener");

      int lastZise = 0;
  //    print(myTextEditControllerCP.text.length);
      if (myTextEditControllerCP.text.length == 5) {
        if (lasnumber != myTextEditControllerCP.text) {
          lasnumber = myTextEditControllerCP.text;
          domicilio = (await getCodigoPostal(myTextEditControllerCP.text)) as DomicilioModel;
          if (domicilio != null) {
          //  print("domicilio");
            myTextEditControllerCiudad.text = domicilio.ciudad.descripcionValor;
            myTextEditControllerEstado.text = domicilio.estado.descripcionValor;
            myTextEditControllerPais.text = "Mexico";
            _dropDownMenuItemsColonia = getDropDownMenuItemsColonia();

            try{
            setState(() {
              domicilio = domicilio;
              _dropDownMenuItemsColonia = getDropDownMenuItemsColonia();
          //    print("drop colonias"+_dropDownMenuItemsColonia.toString());
            //  print("drop colonias"+_dropDownMenuItemsColonia.length.toString());
            });}catch(e){print(e);}
          } else {
            setState(() {
              myTextEditControllerCiudad.clear();
              myTextEditControllerEstado.clear();
              myTextEditControllerPais.clear();
            });
          }
        }
      } else {
        try {
          setState(() {
            lasnumber = "";
            myTextEditControllerCiudad.clear();
            myTextEditControllerEstado.clear();
            myTextEditControllerPais.clear();
            domicilio = null;
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void initState() {
    _saving = false;
    // correo
    myTextEditControllerEmail.text = datosFisicosContacto.email;
    // TODO: implement initState
    _dropDownMenuItems = getDropDownMenuItems();
    _dropDownMenuItemsPlayera = getDropDownMenuItemsPlayera();
    //

    lasnumber = "";
    _dropDownMenuItemsParentesco = getDropDownMenuItemsParentesco();

    _dropDownMenuItemsColonia = getDropDownMenuItemsColonia();

    colABlod.add(new RadioModel(false, 'A+', ''));
    colABlod.add(new RadioModel(false, 'A-', ''));
    colABlod.add(new RadioModel(false, 'B+', ''));
    colABlod.add(new RadioModel(false, 'B-', ''));
    //
    colBBlod.add(new RadioModel(false, 'AB+', ''));
    colBBlod.add(new RadioModel(false, 'AB-', ''));
    colBBlod.add(new RadioModel(false, 'O+', ''));
    colBBlod.add(new RadioModel(false, 'O-', ''));

    //alergias

    if (widget.type == editType.salud) {
      radioValueTipoDeSangre = getBloodID(datosFisicos.salud.tipoSangre != null
          ? datosFisicos.salud.tipoSangre
          : "");
      //datosFisicos.salud.tipoSangre = getBloodType(radioValueTipoDeSangre);
      if (datosFisicos.salud.alergias != null &&
          datosFisicos.salud.alergias.isNotEmpty) {
        alergiasControl.text =
            datosFisicos.salud.alergias.elementAt(0).toString();
        radioValueAlergias = alergiasControl.text != null
            ? alergiasControl.text != "" ? 0 : 1
            : 1;
      }
      if (datosFisicos.salud.enfermedades != null &&
          datosFisicos.salud.enfermedades.isNotEmpty) {
        enfermedadesControl.text =
            datosFisicos.salud.enfermedades.elementAt(0).toString();
        radioValueEnfermedades = enfermedadesControl.text != null
            ? enfermedadesControl.text != "" ? 0 : 1
            : 1;
      }
    }

    //telefono
    if (widget.type == editType.telefono) {
      myTextEditControllerPhone.text =
          datosFisicosContacto.telefonoMovil != null
              ? datosFisicosContacto.telefonoMovil
              : "";
    }

    //Estudios
    if (widget.type == editType.estudios) {
      myTextEditControllerUniversity.text =
          datosFisicos.escolaridad.institucion != null
              ? datosFisicos.escolaridad.institucion
              : "";
      myTextEditControllerCareer.text = datosFisicos.escolaridad.area != null
          ? datosFisicos.escolaridad.area
          : "";
    }

    //Poliza
    if (widget.type == editType.poliza) {
      myTextEditControllerPolicyNumber.text =
          datosFisicos.personales.polizaRC.numero != null
              ? datosFisicos.personales.polizaRC.numero
              : "";
      myTextEditControllerPolicyStart.text =
          datosFisicos.personales.polizaRC.vigenciaInicial != null
              ? datosFisicos.personales.polizaRC.vigenciaInicial
              : "";
      myTextEditControllerPolicyEnd.text =
          datosFisicos.personales.polizaRC.vigenciaFin != null
              ? datosFisicos.personales.polizaRC.vigenciaFin
              : "";
    }

    //Visa
    if (widget.type == editType.visa) {
      myTextEditControllerNoVisa.text =
          datosFisicos.personales.visa.numero != null
              ? datosFisicos.personales.visa.numero
              : "";
      myTextEditControllerVigenciaVisa.text =
          datosFisicos.personales.visa.vigencia != null
              ? datosFisicos.personales.visa.vigencia
              : "";
    }

    //nickname
    if (widget.type == editType.nickname) {
      myTextEditControllerNickname.text =
          datosFisicos.personales.nickname != null
              ? datosFisicos.personales.nickname
              : "";
    }

    //passaporte
    if (widget.type == editType.pasaporte) {
      myTextEditControllerPasaporte.text =
          datosFisicos.personales.pasaporte.numero != null
              ? datosFisicos.personales.pasaporte.numero
              : "";
      myTextEditControllerVigenciaPasaporte.text =
          datosFisicos.personales.pasaporte.vigencia != null
              ? datosFisicos.personales.pasaporte.vigencia
              : "";
    }

    //playera
    if (widget.type == editType.playera) {
      _currentTShirt = datosFisicos.personales.talla != null
          ? getPlayeraFromID(datosFisicos.personales.talla)
          : "(S) Chica";
    }

    //deportes
    if (widget.type == editType.deportes) {
      if (datosFisicos.salud.deportes != null &&
          datosFisicos.salud.deportes.isNotEmpty) {
        myTextEditControllerDeportes.text =
            datosFisicos.salud.deportes[0] != null
                ? datosFisicos.salud.deportes[0]
                : "";
        radioValueDeportes = datosFisicos.salud.deportes[0] != null
            ? datosFisicos.salud.deportes[0] != "" ? 0 : 1
            : 1;
      }

      radioValueFumador = datosFisicos.salud.fumador == true ? 0 : 1;
    }

    //condiciones especiales
    if (widget.type == editType.condiciones) {
      if (datosFisicos.salud.condicionesEspeciales != null &&
          datosFisicos.salud.condicionesEspeciales.isNotEmpty) {
        myTextEditControllerCondiciones.text =
            datosFisicos.salud.condicionesEspeciales[0] != null
                ? datosFisicos.salud.condicionesEspeciales[0]
                : "";
        radioValueCondiciones =
            datosFisicos.salud.condicionesEspeciales[0] != null
                ? datosFisicos.salud.condicionesEspeciales[0] != "" ? 0 : 1
                : 1;
      }
      if (datosFisicos.salud.condicionesAlimenticias != null &&
          datosFisicos.salud.condicionesAlimenticias.isNotEmpty) {
        myTextEditControllerAlimenticias.text =
            datosFisicos.salud.condicionesAlimenticias[0] != null
                ? datosFisicos.salud.condicionesAlimenticias[0]
                : "";
        radioValueAlimenticias =
            datosFisicos.salud.condicionesAlimenticias[0] != null
                ? datosFisicos.salud.condicionesAlimenticias[0] != "" ? 0 : 1
                : 1;
        ;
      }
    }

    //Contacto de emergencia
    if (widget.type == editType.contatoEmergencia) {
      myTextEditControllerContactoEmergenciaNombre.text =
          datosFisicos.contactoEmergencia.nombre != null
              ? datosFisicos.contactoEmergencia.nombre
              : "";
      myTextEditControllerContactoEmergenciaNumero.text =
          datosFisicos.contactoEmergencia.telefono != null
              ? datosFisicos.contactoEmergencia.telefono
              : "";
      _currentParentesco =
          getParentecoFromAny(datosFisicos.contactoEmergencia.parentesco);
      myTextEditControllerContactoEmergenciaParentesco.text =
          datosFisicos.contactoEmergencia.parentesco;
    }
    //Acompañante

    if (widget.idAcopaniante != null && widget.type == editType.acompaniante) {
      myTextEditControllerAcompanante.text =
          datosFisicos.compania[widget.idAcopaniante].nombre;
      //datosFisicos.compania[widget.idAcopaniante].telefono=;
      myTextEditControllerAcompaniaParentesco.text =
          datosFisicos.compania[widget.idAcopaniante].parentesco;
      _currentParentesco =
          getParentecoFromAny(datosFisicos.contactoEmergencia.parentesco);
      myTextEditControllerAcompaniaParentesco.text =
          datosFisicos.compania[widget.idAcopaniante].parentesco;
    }

    //Domicilio
    if (widget.type == editType.direccion &&
        datosFisicosContacto != null &&
        datosFisicosContacto.domicilioParticular != null) {
      if (datosFisicosContacto.domicilioParticular.calle != null) {
        myTextEditControllerCalle.text =
            datosFisicosContacto.domicilioParticular.calle;
      }
      if (datosFisicosContacto.domicilioParticular.numeroIn != null) {
        myTextEditControllerNoInt.text =
            datosFisicosContacto.domicilioParticular.numeroIn;
      }
      if (datosFisicosContacto.domicilioParticular.numeroEx != null) {
        myTextEditControllerNoExt.text =
            datosFisicosContacto.domicilioParticular.numeroEx;
      }
      /*
        if (datosFisicosContacto.domicilioParticular.colonia!=null) {
          colonia = "${dom.descripcion},";
        }*/
      if (datosFisicosContacto.domicilioParticular.codigoPostal != null) {
        myTextEditControllerCP.text =
            datosFisicosContacto.domicilioParticular.codigoPostal;
      }
    }

    super.initState();
  }

/*

  */
  @override
  void dispose() {
    myTextEditControllerCP.removeListener(() {});
    lasnumber = "";
    // correo
    if (widget.type == editType.deportes) {
      myTextEditControllerEmail.clear();
    }
    //alergias
    if (widget.type == editType.deportes) {
      alergiasControl.clear();
      enfermedadesControl.clear();
    }
    //telefono
    if (widget.type == editType.telefono) {
      myTextEditControllerPhone.clear();
    }
    //Estudios
    if (widget.type == editType.estudios) {
      myTextEditControllerUniversity.clear();
      myTextEditControllerCareer.clear();
    }
    //Poliza
    if (widget.type == editType.poliza) {
      myTextEditControllerPolicyNumber.clear();
      myTextEditControllerPolicyStart.clear();
      myTextEditControllerPolicyEnd.clear();
    }
    if (widget.type == editType.visa) {
      //Visa
      myTextEditControllerNoVisa.clear();
      myTextEditControllerVigenciaVisa.clear();
    }
    //nickname
    if (widget.type == editType.nickname) {
      myTextEditControllerNickname.clear();
    }
    //passaporte
    if (widget.type == editType.pasaporte) {
      myTextEditControllerPasaporte.clear();
      myTextEditControllerVigenciaPasaporte.clear();
    }
    //deportes
    if (widget.type == editType.deportes) {
      myTextEditControllerDeportes.clear();
    }

    //condiciones especiales
    if (widget.type == editType.condiciones) {
      myTextEditControllerCondiciones.clear();
      myTextEditControllerAlimenticias.clear();
    }

    //Contacto de emergencia
    if (widget.type == editType.contatoEmergencia) {
      myTextEditControllerContactoEmergenciaNombre.clear();
      myTextEditControllerContactoEmergenciaNumero.clear();
    }

    //Domicilio
    if (widget.type == editType.direccion) {
      myTextEditControllerCalle.clear();
      myTextEditControllerNoInt.clear();
      myTextEditControllerNoExt.clear();
      myTextEditControllerCP.clear();
    }

    //acompaniante
    if (widget.type == editType.acompaniante) {
      myTextEditControllerAcompaniaParentesco.clear();
      myTextEditControllerAcompanante.clear();
    }

    radioValueTipoDeSangre = 0;
    radioValueAlergias = 3;
    radioValueEnfermedades = 3;
    radioValueDeportes = 3;
    radioValueFumador = 3;
    radioValueCondiciones = 3;
    radioValueAlimenticias = 3;

    super.dispose();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsParentesco() {
    List<DropdownMenuItem<String>> items = new List();
    for (String parentesco in _parentesco) {
      items.add(
          new DropdownMenuItem(value: parentesco, child: new Text(parentesco)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsColonia() {
   // print("getDropDownMenuItemsColonia");
    List<DropdownMenuItem<String>> items = new List();
    if (domicilio != null && domicilio.colonias != null) {
      items.clear();
      for (DomicilioColoniaModel colonia in domicilio.colonias) {

         // print(colonia);
          items.add(new DropdownMenuItem(
              value: colonia.idDescripcion,
              child: new Text(
                colonia.descripcion,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16.0,
                  color: Theme.Colors.Light,
                ),
              )));
      }
      //setState(() {
      if (datosFisicosContacto.domicilioParticular.colonia != null &&
          domicilio != null) {
        for (int i = 0; i < domicilio.colonias.length; i++) {
          if (datosFisicosContacto.domicilioParticular.colonia ==
              domicilio.colonias[i].descripcion) {
            _currentColonia = domicilio.colonias[i].idDescripcion;
            return items;
          } else {
            _currentColonia = domicilio.colonias[0].idDescripcion;
          }
        }
      }

      //});
    } else {
      //setState(() {
      items.add(new DropdownMenuItem(value: "", child: new Text("")));
      _currentColonia = "";
      //});
    }

    return items;
  }

  void changedDropDownItemParentesco(String value) {
    setState(() {
      _currentParentesco = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.Colors.White,
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.Colors.Dark,
              ),
              onPressed: () {
                customAlert(
                    AlertDialogType.mensajeEditPerfilBack, context, "", "");
              }),
          title: Text(
            getTitle(widget.type),
            style: TextStyle(color: Theme.Colors.Back),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Theme.Icons.check,
                  color: Theme.Colors.Orange,
                ),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      if (widget.type == editType.direccion) {
                        if (myTextEditControllerCalle.text != null &&
                            myTextEditControllerCalle.text != "" &&
                            myTextEditControllerCP.text != null &&
                            myTextEditControllerCP.text != "" &&
                            myTextEditControllerCiudad.text != null &&
                            myTextEditControllerCiudad.text != "" &&
                            myTextEditControllerEstado.text != null &&
                            myTextEditControllerEstado.text != "" &&
                            myTextEditControllerPais.text != null &&
                            myTextEditControllerPais.text != "") {
                          _saving = true;
                          saveGeneric(widget.type);
                        } else {
                          customAlert(
                              AlertDialogType.mensajeGenericoDataIncomplete,
                              context,
                              "",
                              "");
                        }
                      } else {
                        _saving = true;
                        saveGeneric(widget.type);
                      }
                    }
                  });
                })
          ],
        ),
        body: Stack(
          children: getScreen(widget.type),
        ),
      ),
    );
  }

  List<Widget> getScreen(editType type) {
    List<Widget> list = new List<Widget>();
    switch (type) {
      /////
      case editType.correo:
        list.add(edicionCorreo());
        break;
      case editType.salud:
        list.add(edicionSalud());
        break;
      case editType.estudios:
        list.add(edicionEstudios());
        break;
      case editType.familiar:
        list.add(EditFamiliaresPerfilWidget());
        break;
      case editType.telefono:
        list.add(edicionTelefono());
        break;
      case editType.poliza:
        list.add(edicionPoliza());
        //funcionarioDePlazaonPoliza());
        break;
      case editType.direccion:
        list.add(edicionDireccion());
        // TODO: Handle this case.
        break;
      case editType.texto:
        // TODO: Handle this case.
        break;
      case editType.contatoEmergencia:
        list.add(editContatoEmergencia());
        // TODO: Handle this case.
        break;
      case editType.nickname:
        list.add(editNickname());
        // TODO: Handle this case.
        break;
      case editType.visa:
        list.add(editVisa());
        // TODO: Handle this case.
        break;
      case editType.pasaporte:
        list.add(editPasaporte());
        // TODO: Handle this case.
        break;
      case editType.playera:
        list.add(editPlayera());
        // TODO: Handle this case.
        break;
      case editType.condiciones:
        list.add(editCondiciones());
        // TODO: Handle this case.
        break;
      case editType.deportes:
        list.add(editDeportes());
        // TODO: Handle this case.
        break;
      case editType.acompaniante:
        list.add(editAcompaniante());
        // TODO: Handle this case.
        break;
    }
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
      list.add(modal);
    }
    return list;
  }

  Widget edicionCorreo() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  focusNode: myFocusNodeEmail,
                  onFieldSubmitted: (S) {
                    if (_formKey.currentState.validate()) {
                      _saving = true;
                      saveGeneric(editType.correo);
                    }
                  },
                  controller: myTextEditControllerEmail,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(
                        "ÁÃÀÄÂÉËÈÊÍÏÌÎÓÖÒÔÚÜÙÛÑÇáãàäâéëèêíïìîóöòôúüùûñç")),
                    WhitelistingTextInputFormatter(
                        RegExp("[0-9 a-zA-Z . @ - _]")),
                    //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 35,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText: AppStrings.StringsMX.loginEmail,
                    labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                  ),
                  validator: (value) {
                    String p =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(p);
                    if (value.isEmpty) {
                      return 'Introduzca un correo electrónico';
                    } else if (regExp.hasMatch(value)) {
                      return null;
                    } else {
                      return 'Introduzca un correo válido';
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Widget edicionEstudios() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //Titulo
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: Text(
                  AppStrings.StringsMX.editDatosPerfilUnivesidad,
                  style: Theme.TextStyles.DarkGrayMedium14px,
                ),
              ),
            ),
            //Nombre de la universidad
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  focusNode: myFocusNodeUniversity,
                  maxLength: 20,
                  onFieldSubmitted: (S) {
                    FocusScope.of(context).requestFocus(myFocusNodeCareer);
                  },
                  controller: myTextEditControllerUniversity,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText:
                        AppStrings.StringsMX.editDatosPerfilNombreUnivesidad,
                    labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Introduce el nombre de la universidad valido";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            //Nombre de la carrera
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  focusNode: myFocusNodeCareer,
                  maxLength: 20,
                  controller: myTextEditControllerCareer,
                  onFieldSubmitted: (S) {
                    if (_formKey.currentState.validate()) {
                      _saving = true;
                      saveGeneric(editType.estudios);
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText:
                        AppStrings.StringsMX.editDatosPerfilNombreCarrera,
                    labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Introduce el nombre de la carrera";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Widget edicionTelefono() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  focusNode: myFocusNodePhone,
                  maxLength: 10,
                  controller: myTextEditControllerPhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  ],
                  style: Theme.TextStyles.DarkGrayRegular16px,
                  onFieldSubmitted: (S) {
                    if (_formKey.currentState.validate()) {
                      _saving = true;
                      saveGeneric(editType.telefono);
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText:
                        AppStrings.StringsMX.editDatosPerfilNumeroTelefono,
                    labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Introduzca un numero de telefono';
                    } else if (value.length == 10) {
                      return null;
                    } else {
                      return 'Introduzca un numero de telefono válido a 10 digitos';
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Widget edicionPoliza() {

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //Numero de poliza
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  autofocus: true,
                  maxLength: 30,
                  enableInteractiveSelection: true,
                  autovalidate: true,
                  inputFormatters: [
                    // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                    WhitelistingTextInputFormatter(RegExp("[0-9 a-zA-Z]")),
                    //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                  ],
                  onFieldSubmitted: (S) {
                    FocusScope.of(context).requestFocus(myFocusNodePolicyStart);
                  },
                  cursorColor: Theme.Colors.Orange,
                  //focusNode: myFocusNodePolicyStart,
                  controller: myTextEditControllerPolicyNumber,
                  keyboardType: TextInputType.number,
                  style: Theme.TextStyles.DarkGrayRegular16px,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText: AppStrings.StringsMX.editDatosPerfilNumeroPoliza,
                    labelStyle: Theme.TextStyles.LightRegular12px,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "introduce un número de poliza";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            //Inicio vigencia
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  focusNode: myFocusNodePolicyStart,
                  maxLength: 10,
                  inputFormatters: [
                    // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                    WhitelistingTextInputFormatter(RegExp("[0-9 /\]")),
                    //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                  ],
                  onFieldSubmitted: (S) {
                    FocusScope.of(context).requestFocus(myFocusNodePolicyEnd);
                  },
                  controller: myTextEditControllerPolicyStart,
                  keyboardType: TextInputType.datetime,
                  style: Theme.TextStyles.DarkGrayRegular16px,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText: AppStrings.StringsMX.editDatosPerfilInicioPoliza,
                    labelStyle: Theme.TextStyles.LightRegular12px,
                  ),
                  validator: (value) {
                    String p = "[0-9]{2}\/[0-9]{2}\/[0-9]{4}";
                    RegExp regExp = new RegExp(p);
                    if (value.isEmpty) {
                      return "Introduce la fecha de vigencia";
                    } else if (value.length < 10) {
                      return "Formato invalido DD/MM/YYYY";
                    } else if (regExp.hasMatch(value)) {
                      return null;
                    } else {
                      return "Formato invalido DD/MM/YYYY";
                    }
                  },
                ),
              ),
            ),
            //Fin vigencia
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                child: TextFormField(
                  cursorColor: Theme.Colors.Orange,
                  maxLength: 10,
                  inputFormatters: [
                    // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                    WhitelistingTextInputFormatter(RegExp("[0-9 /\]")),
                    //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                  ],
                  focusNode: myFocusNodePolicyEnd,
                  onFieldSubmitted: (S) {
                    if (_formKey.currentState.validate()) {
                      _saving = true;
                      saveGeneric(editType.poliza);
                    }
                  },
                  controller: myTextEditControllerPolicyEnd,
                  keyboardType: TextInputType.datetime,
                  style: Theme.TextStyles.DarkGrayRegular16px,
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Light, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Theme.Colors.Orange, width: 1.0),
                    ),
                    labelText: AppStrings.StringsMX.editDatosPerfilFinPoliza,
                    labelStyle: Theme.TextStyles.LightRegular12px,
                  ),
                  validator: (value) {
                    String p = "[0-9]{2}\/[0-9]{2}\/[0-9]{4}";
                    RegExp regExp = new RegExp(p);
                    if (value.isEmpty) {
                      return "Introduce la fecha de vigencia";
                    } else if (value.length < 10) {
                      return "Formato invalido DD/MM/YYYY";
                    } else if (regExp.hasMatch(value)) {
                      return null;
                    } else {
                      return "Formato invalido DD/MM/YYYY";
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Widget edicionDireccion() {
    return Form(
        key: _formKey,
        child: Container(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            //Calle
            Container(
              margin: EdgeInsets.only(top: 16, left: 24, right: 24),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeCalle,
                controller: myTextEditControllerCalle,
                keyboardType: TextInputType.text,
                maxLength: 40,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z , . 0-9]")),
                ],
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16.0,
                  color: Theme.Colors.Light,
                ),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilCalle,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce la calle";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            //No. interior
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Numero de Exterior
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeNoExt,
                      controller: myTextEditControllerNoExt,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                      inputFormatters: [
                        // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                        WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z 0-9 -]")),
                      ],
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          color: Theme.Colors.Light),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText:
                            AppStrings.StringsMX.editDatosPerfilNoExterior,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      validator: (value) {},
                    ),
                  )),
                  //Numero de Interior
                  Expanded(
                    // margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeNoInt,
                      controller: myTextEditControllerNoInt,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
                      inputFormatters: [
                        // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                        WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z 0-9 -]")),
                      ],
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText:
                            AppStrings.StringsMX.editDatosPerfilNoInterior,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      //validator: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            //Codigo Postal
            Container(
              margin: EdgeInsets.only(top: 16, left: 24, right: 24),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeCP,
                controller: myTextEditControllerCP,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                maxLength: 5,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9]")),
                ],
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16.0,
                  color: Theme.Colors.Light,
                ),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilCodigoPostal,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce la código postal";
                  }
                  if (value.length < 5) {
                    return "Ingresa tu código postal a 5 dígitos";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            //Colonia
            domicilio != null
                ? Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: new DropdownButton(
                      isExpanded: true,
                      value: _currentColonia,
                      items: _dropDownMenuItemsColonia,
                      onChanged: changedDropDownItemColonia,
                    ),
                  )
                : Container(
                    child: myTextEditControllerCP.text != null
                        ? myTextEditControllerCP.text.length == 5
                            ? Center(
                                child: Text("Codigo postal no encontrado"),
                              )
                            : Container()
                        : Container(),
                  ),
            //Ciudad
            domicilio != null
                ? Container(
                    margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeCiudad,
                      controller: myTextEditControllerCiudad,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      inputFormatters: [
                        // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                        WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z , . 0-9]")),
                      ],
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings.StringsMX.editDatosPerfilCiudad,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      validator: (value) {},
                    ),
                  )
                : Container(),
            //Estado
            domicilio != null
                ? Container(
                    margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeEstado,
                      controller: myTextEditControllerEstado,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      inputFormatters: [
                        // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                        WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z , . 0-9]")),
                      ],
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings.StringsMX.editDatosPerfilEstado,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      //validator: (value) {},
                    ),
                  )
                : Container(),
            domicilio != null
                ?
                //Pais
                Container(
                    margin: EdgeInsets.only(top: 16, left: 24, right: 24),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodePais,
                      controller: myTextEditControllerPais,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      inputFormatters: [
                        // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                        WhitelistingTextInputFormatter(
                            RegExp("[a-zA-Z , . 0-9]")),
                      ],
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings.StringsMX.editDatosPerfilPais,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      //validator: (value) {},
                    ),
                  )
                : Container(),
          ],
        ))));
  }

  Widget edicionSalud() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              //Tipo de sangre
              Container(
                margin: EdgeInsets.only(left: 16, top: 24, bottom: 8),
                child: Text(
                  "Tipo de sangre",
                  style: Theme.TextStyles.DarkGrayMedium14px,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 4,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("A+"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 3,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("A-"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 6,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("B+"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 5,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("B-"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 8,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("AB+"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 7,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("AB-"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 2,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("O+"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 1,
                              groupValue: radioValueTipoDeSangre,
                              onChanged: handleRadioValueChangedBlood,
                            ),
                            Text("O-"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //alergias
              Container(
                margin: EdgeInsets.only(left: 16, top: 24, bottom: 8),
                child: Text(
                  "Alergias",
                  style: Theme.TextStyles.DarkGrayMedium14px,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: 0,
                          groupValue: radioValueAlergias,
                          onChanged: handleRadioValueChangedAllergies,
                        ),
                        Text("Si"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: 1,
                          groupValue: radioValueAlergias,
                          onChanged: handleRadioValueChangedAllergies,
                        ),
                        Text("No"),
                      ],
                    ),
                  ),
                ],
              ),
              //show or not Allergies
              radioValueAlergias == 0
                  ? Container(
                      margin: EdgeInsets.only(left: 24.0, top: 8, right: 24),
                      child: new TextFormField(
                        cursorColor: Theme.Colors.gnpOrange,
                        controller: alergiasControl,
                        textAlign: TextAlign.left,
                        enabled: radiovalueAlergias == "No" ? false : true,
                        keyboardType: TextInputType.text,
                        maxLength: 50,
                        style: Theme.TextStyles.DarkGrayMedium14px,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Light, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Orange, width: 1.0),
                          ),
                          labelText:
                              AppStrings.StringsMX.editDatosPerfilSaludAlergias,
                          labelStyle: Theme.TextStyles.LightRegular14px0ls,
                        ),
                        validator: (value) {
                          if (radioValueAlergias == 0) {
                            if (value.isEmpty) {
                              return "introduce tus alergias";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  : Container(),

              //Enfermedades
              Container(
                margin: EdgeInsets.only(left: 16, top: 24, bottom: 8),
                child: Text(
                  "Enfermedades",
                  style: Theme.TextStyles.DarkGrayMedium14px,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: 0,
                          groupValue: radioValueEnfermedades,
                          onChanged: handleRadioValueChangedDisease,
                        ),
                        Text("Si"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<int>(
                          value: 1,
                          groupValue: radioValueEnfermedades,
                          onChanged: handleRadioValueChangedDisease,
                        ),
                        Text("No"),
                      ],
                    ),
                  ),
                ],
              ),
              //show or not Desease
              radioValueEnfermedades == 0
                  ? Container(
                      margin: EdgeInsets.only(left: 24.0, top: 8, right: 24),
                      child: new TextFormField(
                        cursorColor: Theme.Colors.gnpOrange,
                        controller: enfermedadesControl,
                        textAlign: TextAlign.left,
                        enabled: radiovalueAlergias == "No" ? false : true,
                        keyboardType: TextInputType.text,
                        maxLength: 50,
                        style: Theme.TextStyles.DarkGrayMedium14px,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Light, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Theme.Colors.Orange, width: 1.0),
                          ),
                          labelText: AppStrings
                              .StringsMX.editDatosPerfilSaludEnfermedades,
                          labelStyle: Theme.TextStyles.LightRegular14px0ls,
                        ),
                        validator: (value) {
                          if (radioValueEnfermedades == 0) {
                            if (value.isEmpty) {
                              return "introduce tus enfermedades";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  : Container(),
            ])));
  }

  Widget editContatoEmergencia() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            child: new DropdownButton(
              isExpanded: true,
              value: getParentecoFromAny(_currentParentesco),
              items: _dropDownMenuItemsParentesco,
              onChanged: changedDropDownItemParentesco,
            ),
          ),
          getParentecoFromAny(_currentParentesco) == "Personalizado"
              ? Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
                  child: TextFormField(
                    cursorColor: Theme.Colors.Orange,
                    focusNode: myFocusNodeContactoEmergenciaParentesco,
                    controller:
                        myTextEditControllerContactoEmergenciaParentesco,
                    keyboardType: TextInputType.text,
                    maxLength: 35,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Theme.Colors.Light, width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Theme.Colors.Orange, width: 1.0),
                      ),
                      labelText: AppStrings.StringsMX
                          .editDatosPerfilContactoEmergenciaParentesco,
                      labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Introduce el nombre de tu contacto";
                      } else {
                        return null;
                      }
                    },
                  ))
              : Container(),
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeContactoEmergenciaNombre,
                controller: myTextEditControllerContactoEmergenciaNombre,
                keyboardType: TextInputType.text,
                maxLength: 35,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings
                      .StringsMX.editDatosPerfilContactoEmergenciaNombre,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce el nombre de tu contacto";
                  } else {
                    return null;
                  }
                },
              )),
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeContactoEmergenciaNumero,
                controller: myTextEditControllerContactoEmergenciaNumero,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9]")),
                ],
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings
                      .StringsMX.editDatosPerfilContactoEmergenciaNumero,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Introduce el numero de tu contacto';
                  } else if (value.length == 10) {
                    return null;
                  } else {
                    return 'Introduzca un numero de telefono válido a 10 digitos';
                  }
                },
              )),
        ])));
  }

  Widget editNickname() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodenNickname,
                controller: myTextEditControllerNickname,
                keyboardType: TextInputType.text,
                maxLength: 15,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9 a-zA-Z]")),
                ],
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilNickname,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce Tu nick name";
                  } else {
                    return null;
                  }
                },
              )),
        ])));
  }

  Widget editPasaporte() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodenPasaporte,
                controller: myTextEditControllerPasaporte,
                maxLength: 20,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9 a-zA-Z -]")),
                  //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                ],
                keyboardType: TextInputType.text,
                onFieldSubmitted: (S) {
                  FocusScope.of(context)
                      .requestFocus(myFocusNodenVigenciaPasaporte);
                },
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilNoPasaporte,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce tu numero de pasaporte";
                  } else {
                    return null;
                  }
                },
              )),
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodenVigenciaPasaporte,
                controller: myTextEditControllerVigenciaPasaporte,
                keyboardType: TextInputType.datetime,
                maxLength: 10,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9 /\]")),
                ],
                onFieldSubmitted: (S) {
                  if (_formKey.currentState.validate()) {
                    _saving = true;
                    saveGeneric(editType.pasaporte);
                  }
                },
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText:
                      AppStrings.StringsMX.editDatosPerfilVigenciaPasaporte,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  String p = "[0-9]{2}\/[0-9]{2}\/[0-9]{4}";
                  RegExp regExp = new RegExp(p);
                  if (value.isEmpty) {
                    return "Introduce la fecha de vigencia";
                  } else if (value.length < 10) {
                    return "Formato invalido DD/MM/YYYY";
                  } else if (regExp.hasMatch(value)) {
                    return null;
                  } else {
                    return "Formato invalido DD/MM/YYYY";
                  }
                },
              )),
        ])));
  }

  Widget editPlayera() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width,
            child: new DropdownButton(
              isExpanded: true,
              style: TextStyle(color: Theme.Colors.Dark),
              value: _currentTShirt,
              items: _dropDownMenuItemsPlayera,
              onChanged: changedDropDownItemPlayera,
            ),
          ),
        ])));
  }

  Widget editCondiciones() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //condiciones Especiales
            Container(
              margin: EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppStrings.StringsMX.editDatosPerfilCondicionesEspeciales,
                style: Theme.TextStyles.DarkGrayMedium14px,
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 0,
                            groupValue: radioValueCondiciones,
                            onChanged: handleRadioValueChangedConditions,
                          ),
                          Text("Si"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 1,
                            groupValue: radioValueCondiciones,
                            onChanged: handleRadioValueChangedConditions,
                          ),
                          Text("No"),
                        ],
                      ),
                    )
                  ]),
            ),
            //condiciones Editar Especiales
            radioValueCondiciones == 0
                ? Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeCondiciones,
                      controller: myTextEditControllerCondiciones,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          color: Theme.Colors.Light),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings
                            .StringsMX.editDatosPerfilCondicionesDescripcion,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      validator: (value) {
                        if (radioValueCondiciones == 0) {
                          if (value.isEmpty) {
                            return "introduce tus Condicones";
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ))
                : Container(),

            //condiciones Alimenticias
            Container(
              margin: EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppStrings.StringsMX.editDatosPerfilCondicionesAlimenticias,
                style: Theme.TextStyles.DarkGrayMedium14px,
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 0,
                            groupValue: radioValueAlimenticias,
                            onChanged: handleRadioValueChangedFeed,
                          ),
                          Text("Si"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 1,
                            groupValue: radioValueAlimenticias,
                            onChanged: handleRadioValueChangedFeed,
                          ),
                          Text("No"),
                        ],
                      ),
                    )
                  ]),
            ),
            //condiciones editar Alimenticias

            radioValueAlimenticias == 0
                ? Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodeAlimenticias,
                      controller: myTextEditControllerAlimenticias,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          color: Theme.Colors.Light),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings
                            .StringsMX.editDatosPerfilCondicionesDescripcion,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      validator: (value) {
                        if (radioValueAlimenticias == 0) {
                          if (value.isEmpty) {
                            return "introduce tus Condicones alimenticias";
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ))
                : Container(),
          ],
        )));
  }

  Widget editDeportes() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //condiciones Deportes
            Container(
              margin: EdgeInsets.only(left: 16, top: 30, bottom: 8),
              child: Text(
                AppStrings.StringsMX.editDatosPerfilDeportes,
                style: Theme.TextStyles.DarkGrayMedium14px,
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 0,
                            groupValue: radioValueDeportes,
                            onChanged: handleRadioValueChangedSports,
                          ),
                          Text("Si"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 1,
                            groupValue: radioValueDeportes,
                            onChanged: handleRadioValueChangedSports,
                          ),
                          Text("No"),
                        ],
                      ),
                    )
                  ]),
            ),
            //Deportes
            radioValueDeportes == 0
                ? Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      cursorColor: Theme.Colors.Orange,
                      focusNode: myFocusNodenDeportes,
                      controller: myTextEditControllerDeportes,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16.0,
                          color: Theme.Colors.Light),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Light, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Theme.Colors.Orange, width: 1.0),
                        ),
                        labelText: AppStrings
                            .StringsMX.editDatosPerfilDeportesDescripcion,
                        labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                      ),
                      validator: (value) {
                        if (radioValueDeportes == 0) {
                          if (value.isEmpty) {
                            return "introduce tus deportes";
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ))
                : Container(),

            //Fumador
            Container(
              margin: EdgeInsets.only(left: 16, top: 35, bottom: 8),
              child: Text(
                AppStrings.StringsMX.editDatosPerfilFumador,
                style: Theme.TextStyles.DarkGrayMedium14px,
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 0,
                            groupValue: radioValueFumador,
                            onChanged: handleRadioValueChangedSmoker,
                          ),
                          Text("Si"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Radio<int>(
                            value: 1,
                            groupValue: radioValueFumador,
                            onChanged: handleRadioValueChangedSmoker,
                          ),
                          Text("No"),
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        )));
  }

  Widget editAcompaniante() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            child: new DropdownButton(
              isExpanded: true,
              value: getParentecoFromAny(_currentParentesco),
              items: _dropDownMenuItemsParentesco,
              onChanged: changedDropDownItemParentesco,
            ),
          ),
          getParentecoFromAny(_currentParentesco) == "Personalizado"
              ? Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
                  child: TextFormField(
                    cursorColor: Theme.Colors.Orange,
                    focusNode: myFocusNodeAcompaniaParentesco,
                    controller: myTextEditControllerAcompaniaParentesco,
                    keyboardType: TextInputType.text,
                    maxLength: 35,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16.0,
                        color: Theme.Colors.Light),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Theme.Colors.Light, width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Theme.Colors.Orange, width: 1.0),
                      ),
                      labelText: AppStrings.StringsMX
                          .editDatosPerfilContactoEmergenciaParentesco,
                      labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Introduce el nombre de tu contacto";
                      } else {
                        return null;
                      }
                    },
                  ))
              : Container(),
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeAcompanante,
                controller: myTextEditControllerAcompanante,
                keyboardType: TextInputType.text,
                maxLength: 35,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilAcompaniante,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "introduce el nombre";
                  } else {
                    return null;
                  }
                },
              )),
        ])));
  }

  Widget editVisa() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusNodeNoExt,
                controller: myTextEditControllerNoVisa,
                keyboardType: TextInputType.text,
                maxLength: 20,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9 a-zA-Z -]")),
                  //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                ],
                onFieldSubmitted: (S) {
                  FocusScope.of(context).requestFocus(myFocusVigenciaVisa);
                },
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilNoVisa,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "introduce el numero de visa";
                  } else {
                    return null;
                  }
                },
              )),
          Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
              child: TextFormField(
                cursorColor: Theme.Colors.Orange,
                focusNode: myFocusVigenciaVisa,
                maxLength: 10,
                inputFormatters: [
                  // BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  WhitelistingTextInputFormatter(RegExp("[0-9 /\]")),
                  //WhitelistingTextInputFormatter(RegExp("[/\\\\]")),
                ],
                controller: myTextEditControllerVigenciaVisa,
                keyboardType: TextInputType.datetime,
                onFieldSubmitted: (S) {
                  if (_formKey.currentState.validate()) {
                    _saving = true;
                    saveGeneric(editType.visa);
                  }
                },
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16.0,
                    color: Theme.Colors.Light),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Theme.Colors.Light, width: 1.0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Theme.Colors.Orange, width: 1.0),
                  ),
                  labelText: AppStrings.StringsMX.editDatosPerfilVigenciaVisa,
                  labelStyle: Theme.TextStyles.DarkGrayRegular16px,
                ),
                validator: (value) {
                  String p = "[0-9]{2}\/[0-9]{2}\/[0-9]{4}";
                  RegExp regExp = new RegExp(p);
                  if (value.isEmpty) {
                    return "Introduce la fecha de vigencia";
                  } else if (value.length < 10) {
                    return "Formato invalido DD/MM/YYYY";
                  } else if (regExp.hasMatch(value)) {
                    return null;
                  } else {
                    return "Formato invalido DD/MM/YYYY";
                  }
                },
              )),
        ])));
  }

  String getTitle(editType type) {
    String editOrAdd = "Agregar";
    switch (type) {
      case editType.salud:
        if (radioValueTipoDeSangre < 8) {
          editOrAdd = "Editar";
        }
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloSalud;
        break;
      case editType.estudios:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloEstudios;
        break;
      case editType.familiar:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloFamiliar;
        break;
      case editType.texto:
        // TODO: Handle this case.
        return editOrAdd;
        break;
      case editType.correo:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloCorreo;
        break;
      case editType.telefono:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloTelefono;
        break;
      case editType.direccion:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloDireccion;
        break;
      case editType.poliza:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloPoliza;
        break;
      case editType.contatoEmergencia:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloContatoEmergencia;
        break;
      case editType.nickname:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloNickname;
        break;
      case editType.visa:
        // TODO: Handle this case.
        return editOrAdd + " " + AppStrings.StringsMX.editDatosPerfilTituloVisa;
        break;
      case editType.pasaporte:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloPasaporte;
        break;
      case editType.playera:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloPlayera;
        break;
      case editType.condiciones:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloCondiciones;
        break;
      case editType.deportes:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloDeportes;
        break;
      case editType.acompaniante:
        // TODO: Handle this case.
        return editOrAdd +
            " " +
            AppStrings.StringsMX.editDatosPerfilTituloAcompanante;
        break;
    }
  }

  String getBloodType(int value) {
    switch (value) {
      case 4:
        return "A+";
        break;
      case 3:
        return "A-";
        break;
      case 6:
        return "B+";
        break;
      case 5:
        return "B-";
        break;
      case 8:
        return "AB+";
        break;
      case 7:
        return "AB-";
        break;
      case 2:
        return "O+";
        break;
      case 1:
        return "O-";
        break;
      default:
        return "";
    }
  }

  int getBloodID(String value) {
    switch (value) {
      case "A+":
        return 4;
        break;
      case "A-":
        return 3;
        break;
      case "B+":
        return 6;
        break;
      case "B-":
        return 5;
        break;
      case "AB+":
        return 8;
        break;
      case "AB-":
        return 7;
        break;
      case "O+":
        return 2;
        break;
      case "O-":
        return 1;
        break;
      case "":
        return 0;
        break;
      default:
        return 0;
    }
  }

  String getYesOrNot(int value) {
    switch (value) {
      case 0:
        return "Si";
        break;
      case 1:
        return "No";
        break;
      default:
        return "";
    }
  }

  void handleRadioValueChangedBlood(int value) {
    setState(() {
      radioValueTipoDeSangre = value;
    });
  }

  void handleRadioValueChangedAllergies(int value) {
    setState(() {
      radioValueAlergias = value;
    });
  }

  void handleRadioValueChangedDisease(int value) {
    setState(() {
      radioValueEnfermedades = value;
    });
  }

  void handleRadioValueChangedSports(int value) {
    setState(() {
      radioValueDeportes = value;
    });
  }

  void handleRadioValueChangedSmoker(int value) {
    setState(() {
      radioValueFumador = value;
    });
  }

  void handleRadioValueChangedConditions(int value) {
    setState(() {
      radioValueCondiciones = value;
    });
  }

  void handleRadioValueChangedFeed(int value) {
    setState(() {
      radioValueAlimenticias = value;
    });
  }

  void changedDropDownItemPlayera(String selectedPlayera) {
    setState(() {
      _currentTShirt = selectedPlayera;
      //  printLog("edit_perfil_page", selectedPlayera);
      //otrosTallaPlayeraController.value = TextEditingValue(text: selectedPlayera);
      //_currentTShirtID = getIdPlayera(_currentTShirt);
    });
  }

  void changedDropDownItemColonia(String colonia) {
    setState(() {
      _currentColonia = colonia;
      //print("colonia");
     // print(colonia);
    });
  }

  int getIdPlayera(String tipo) {
    int id = 1;
    switch (tipo) {
      case "(XS) Extra Chica":
        id = 1;
        break;
      case "(S) Chica":
        id = 2;
        break;
      case "(M) Mediana":
        id = 3;
        break;
      case "(L) Grande":
        id = 4;
        break;
      case "(XL) Extra Grande":
        id = 5;
        break;
      case "(XXL) Extra extra Grande":
        id = 6;
        break;
      case "(3XL) 3XL Grande":
        id = 7;
        break;
      case "":
        //    printLog("edit_perfil_page", "case nada");
        id = 1;
        break;
      default:
        id = 1;
        break;
    }
    return id;
  }

  String getPlayeraFromID(String id) {
    String tipo = "(S) Chica";
    switch (id) {
      case "1":
      case "XS":
      case "(XS) Extra Chica":
        tipo = "(XS) Extra Chica";
        break;
      case "2":
      case "S":
      case "(S) Chica":
        tipo = "(S) Chica";
        break;
      case "3":
      case "M":
      case "(M) Mediana":
        tipo = "(M) Mediana";
        break;
      case "4":
      case "L":
      case "(L) Grande":
        tipo = "(L) Grande";
        break;
      case "5":
      case "XL":
      case "(XL) Extra Grande":
        tipo = "(XL) Extra Grande";
        break;
      case "6":
      case "XXL":
      case "(XXL) Extra extra Grande":
        tipo = "(XXL) Extra Extra Grande";
        break;
      case "7":
      case "3XL":
      case "(3XL) 3XL Grande":
        tipo = "(3XL) 3XL Grande";
        break;
      case "":
        tipo = "(S) Chica";
        break;
      default:
        tipo = id;
        break;
    }
    return tipo;
  }

  String getParentecoFromAny(String id) {
    String tipo = "Esposa(o)";
    switch (id) {
      case "Esposa(o)":
        tipo = "Esposa(o)";
        break;
      case "Novia(o)":
        tipo = "Novia(o)";
        break;
      case "Hija(o)":
        tipo = "Hija(o)";
        break;
      case "Personalizado":
        tipo = "Personalizado";
        break;
      default:
        tipo = "Personalizado";
        break;
    }
    return tipo;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsPlayera() {
    List<DropdownMenuItem<String>> items = new List();
    for (String playera in _playera) {
      items.add(new DropdownMenuItem(value: playera, child: new Text(playera)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String blood in _blood) {
      items.add(new DropdownMenuItem(value: blood, child: new Text(blood)));
    }
    return items;
  }

  setRadioValueAler(String value, int id) {
    setState(() {
      switch (id) {
        case 1:
          radiovalueAlergias = value;
          break;
        case 2:
          radiovalueEnfermedades = value;
          break;
      }
    });
  }

  Future saveGeneric(editType type) async {
    bool responce;
    switch (type) {
      case editType.correo:
        responce = await updateCorreo(myTextEditControllerEmail.text);
        if (responce) {
          setState(() {
            datosFisicosContacto.email = myTextEditControllerEmail.text;
          });
          loaderContacto();
        }
        loaderContacto();
        break;
      case editType.poliza:
        if (myTextEditControllerPolicyNumber.text != null &&
            myTextEditControllerPolicyNumber.text != "" &&
            myTextEditControllerPolicyStart.text != null &&
            myTextEditControllerPolicyStart.text != "" &&
            myTextEditControllerPolicyEnd.text != null &&
            myTextEditControllerPolicyEnd.text != "") {
          Map info = {
            "polizaRc": {
              "numero": "" + myTextEditControllerPolicyNumber.text,
              "vigenciaInicial": "" + myTextEditControllerPolicyStart.text,
              "vigenciaFinal": "" + myTextEditControllerPolicyEnd.text
            },
          };
          responce =
              await updatePerfil(context, datosUsuario.idparticipante, info);
          if (responce) {
            setState(() {
              datosFisicos.personales.polizaRC.numero =
                  myTextEditControllerPolicyNumber.text;
              datosFisicos.personales.polizaRC.vigenciaInicial =
                  myTextEditControllerPolicyStart.text;
              datosFisicos.personales.polizaRC.vigenciaFin =
                  myTextEditControllerPolicyEnd.text;
            });
            buildDataMiGnp();
          }
        } else {
          setState(() {
            _saving = false;
          });
          customAlert(
              AlertDialogType.mensajeGenericoDataIncomplete, context, "", "");
        }
        //Todo Set datos: datosFisicos.polizaRC.numero =
        break;
      case editType.salud:
        Map info = {
          "salud": {
            "tipoSangre": radioValueTipoDeSangre.toString(),
            "alergias": [
              radioValueAlergias == 0
                  ? alergiasControl.text != null ? alergiasControl.text : ""
                  : ""
            ],
            "enfermedades": [
              radioValueEnfermedades == 0
                  ? enfermedadesControl.text != null
                      ? enfermedadesControl.text
                      : ""
                  : ""
            ]
          }
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        //Todo Set datos:
        if (responce) {
          setState(() {
            //TODO list
            datosFisicos.salud.tipoSangre =
                getBloodType(radioValueTipoDeSangre);
            datosFisicos.salud.alergias.clear();
            datosFisicos.salud.alergias
                .add(radioValueAlergias == 0 ? alergiasControl.text : "");
            datosFisicos.salud.enfermedades.clear();
            datosFisicos.salud.enfermedades.add(
                radioValueEnfermedades == 0 ? enfermedadesControl.text : "");
          });
          loaderEventos();
        }
        break;
      case editType.estudios:
        Map info = {
          "escolaridad": {
            "nivel": "Universidad",
            "area": myTextEditControllerCareer.text != null
                ? myTextEditControllerCareer.text
                : "",
            "institucion": myTextEditControllerUniversity.text != null
                ? myTextEditControllerUniversity.text
                : ""
          },
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          setState(() {
            datosFisicos.escolaridad.institucion =
                myTextEditControllerUniversity.text;
            datosFisicos.escolaridad.area = myTextEditControllerCareer.text;
            loaderPersonales();
          });
        }
        //Todo Set datos:
        break;
      case editType.visa:
        Map info = {
          "visa": {
            "numero": myTextEditControllerNoVisa.text,
            "vigencia": myTextEditControllerVigenciaVisa.text
          },
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);

        //Todo Set datos:
        if (responce) {
          setState(() {
            datosFisicos.personales.visa.numero =
                myTextEditControllerNoVisa.text;
            datosFisicos.personales.visa.vigencia =
                myTextEditControllerVigenciaVisa.text;
          });
          loaderEventos();
        }
        //Todo Set datos:
        break;
      case editType.telefono:
        String numero = myTextEditControllerPhone.text;
        if (numero.substring(0, 1) == "55" || numero.substring(0, 1) == "56")
          responce =
              await updateMovil(numero.substring(1), numero.substring(0, 1));
        else
          responce =
              await updateMovil(numero.substring(2), numero.substring(0, 2));
        // TODO: Handle this case.
        if (responce) {
          setState(() {
            datosFisicosContacto.telefonoMovil = myTextEditControllerPhone.text;
            loaderContacto();
          });
        }
        break;
      case editType.nickname:
        Map info = {
          "nickname": myTextEditControllerNickname.text != null
              ? myTextEditControllerNickname.text
              : "",
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          setState(() {
            datosFisicos.personales.nickname =
                myTextEditControllerNickname.text;
          });
          loaderEventos();
        }
        break;
      case editType.pasaporte:
        Map info = {
          "pasaporte": {
            "numero": myTextEditControllerPasaporte.text != null
                ? myTextEditControllerPasaporte.text
                : "",
            "vigencia": myTextEditControllerVigenciaPasaporte.text != null
                ? myTextEditControllerVigenciaPasaporte.text
                : ""
          },
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        // TODO: Handle this case.
        if (responce) {
          setState(() {
            datosFisicos.personales.pasaporte.numero =
                myTextEditControllerPasaporte.text;
            datosFisicos.personales.pasaporte.vigencia =
                myTextEditControllerVigenciaPasaporte.text;
          });
          loaderEventos();
        }
        break;
      case editType.deportes:
        Map info = {
          "salud": {
            "deportes": [
              radioValueDeportes == 0
                  ? myTextEditControllerDeportes.text != null
                      ? myTextEditControllerDeportes.text
                      : ""
                  : ""
            ],
            "fumador": radioValueFumador == 0 ? true : false,
          }
        };
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        // TODO: Handle this case.
        //Todo Set datos:
        if (responce) {
          setState(() {
            datosFisicos.salud.deportes[0] = radioValueDeportes == 0
                ? myTextEditControllerDeportes.text
                : "";
            datosFisicos.salud.fumador = radioValueFumador == 0 ? true : false;
          });
          loaderEventos();
        }
        break;
      case editType.playera:
        Map info = {"tallaPlayera": "${getIdPlayera(_currentTShirt)}"};
      //  print("${info}");
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          setState(() {
            datosFisicos.personales.talla = _currentTShirt;
          });
          loaderEventos();
        }
        break;
      case editType.condiciones:
        Map info = {
          "salud": {
            "condicionesEspeciales": [
              radioValueCondiciones == 0
                  ? myTextEditControllerCondiciones.text != null
                      ? myTextEditControllerCondiciones.text
                      : ""
                  : ""
            ],
            "condicionesAlimenticias": [
              radioValueAlimenticias == 0
                  ? myTextEditControllerAlimenticias.text != null
                      ? myTextEditControllerAlimenticias.text
                      : ""
                  : ""
            ]
          }
        };
      //  print("${info}");
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          setState(() {
            datosFisicos.salud.condicionesEspeciales[0] =
                radioValueCondiciones == 0
                    ? myTextEditControllerCondiciones.text
                    : "";
            datosFisicos.salud.condicionesAlimenticias[0] =
                radioValueAlimenticias == 0
                    ? myTextEditControllerAlimenticias.text
                    : "";
          });
          loaderEventos();
        }
        //Todo Set datos:
        //datosFisicos.personales.talla=_currentTShirt;
        break;
      case editType.acompaniante:
        List<Map> datosAcompaniante = List<Map>();

        if (datosFisicos.compania != null && datosFisicos.compania.isNotEmpty) {
          if (widget.idAcopaniante != null) {
            for (int j = 0; j < datosFisicos.compania.length; j++) {
              if (widget.idAcopaniante == j) {
                datosAcompaniante.add({
                  "nombre": myTextEditControllerAcompanante.text != null
                      ? myTextEditControllerAcompanante.text
                      : "",
                  "parentesco":
                      getParentecoFromAny(_currentParentesco) == "Personalizado"
                          ? myTextEditControllerAcompaniaParentesco.text != null
                              ? myTextEditControllerAcompaniaParentesco.text
                              : ""
                          : _currentParentesco,
                  "cveEvento": "",
                });
              } else {
                datosAcompaniante.add({
                  "nombre": datosFisicos.compania[j].nombre,
                  "parentesco": datosFisicos.compania[j].parentesco,
                  "cveEvento": "",
                });
              }
            }
          } else {
            for (int j = 0; j < datosFisicos.compania.length; j++) {
              datosAcompaniante.add({
                "nombre": datosFisicos.compania[j].nombre,
                "parentesco": datosFisicos.compania[j].parentesco,
                "cveEvento": "",
              });
            }
            datosAcompaniante.add({
              "nombre": myTextEditControllerAcompanante.text != null
                  ? myTextEditControllerAcompanante.text
                  : "",
              "parentesco":
                  getParentecoFromAny(_currentParentesco) == "Personalizado"
                      ? myTextEditControllerAcompaniaParentesco.text != null
                          ? myTextEditControllerAcompaniaParentesco.text
                          : ""
                      : _currentParentesco,
              "cveEvento": "",
            });
          }
        } else {
          datosAcompaniante.add({
            "nombre": myTextEditControllerAcompanante.text != null
                ? myTextEditControllerAcompanante.text
                : "",
            "parentesco":
                getParentecoFromAny(_currentParentesco) == "Personalizado"
                    ? myTextEditControllerAcompaniaParentesco.text != null
                        ? myTextEditControllerAcompaniaParentesco.text
                        : ""
                    : _currentParentesco,
            "cveEvento": "",
          });
        }
        Map info = {"acompaniante": datosAcompaniante};
       // print("datosAcompaniante: ${datosAcompaniante}");
       // print("info");
       // print(info);
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          datosFisicos.compania.clear();
          for (int j = 0; j < datosAcompaniante.length; j++) {
            datosFisicos.compania.add(DatosFisicosAcompaModel.fromJson(
                datosAcompaniante.elementAt(j)));
          }
          myTextEditControllerAcompaniaParentesco.clear();
          myTextEditControllerAcompanante.clear();
        }
        loaderEventos();
        //Todo Set datos:
        break;
      case editType.contatoEmergencia:
        // TODO: Handle this case.
        Map info = {
          "contactoEmergencia": {
            "nombre": myTextEditControllerContactoEmergenciaNombre.text != null
                ? myTextEditControllerContactoEmergenciaNombre.text
                : "",
            "parentesco": getParentecoFromAny(_currentParentesco) ==
                    "Personalizado"
                ? myTextEditControllerContactoEmergenciaParentesco.text != null
                    ? myTextEditControllerContactoEmergenciaParentesco.text
                    : ""
                : _currentParentesco,
            "telefono":
                myTextEditControllerContactoEmergenciaNumero.text != null
                    ? myTextEditControllerContactoEmergenciaNumero.text
                    : "",
          },
        };
       // print("${info}");
        responce =
            await updatePerfil(context, datosUsuario.idparticipante, info);
        if (responce) {
          setState(() {
            datosFisicos.contactoEmergencia.nombre =
                myTextEditControllerContactoEmergenciaNombre.text;
            datosFisicos.contactoEmergencia.parentesco =
                getParentecoFromAny(_currentParentesco) == "Personalizado"
                    ? myTextEditControllerContactoEmergenciaParentesco.text !=
                            null
                        ? myTextEditControllerContactoEmergenciaParentesco.text
                        : ""
                    : _currentParentesco;
            datosFisicos.contactoEmergencia.telefono =
                myTextEditControllerContactoEmergenciaNumero.text;
          });
        }
        loaderContacto();
        break;
      case editType.direccion:
        DomicilioColoniaModel dom = domicilio.colonias.firstWhere(
            (user) => user.idDescripcion == _currentColonia,
            orElse: () => null);

        Map info = {
          "codFiliacion": "${datosFisicosContacto.codFiliacion}",
          "idParticipante": "${datosUsuario.idparticipante}",
          "cveTipoVia": "CL",
          "calle": "${myTextEditControllerCalle.text}",
          "numeroExterior": "${myTextEditControllerNoExt.text}",
          "puntoReferencia": "",
          "cveMunicipio": "${domicilio.ciudad.idValor}",
          "cveEstado": "${domicilio.estado.idValor}",
          "codPostal": "${myTextEditControllerCP.text}",
          "codPais": "MEX",
          "cveTipoDomicilio": "CS",
          "cveTipoAsentamiento": "",
          "cveColonia": "${dom.idDescripcion}",
          "descripcionColonia": "",
          "numeroInterior": "${myTextEditControllerNoInt.text} ",
          "propositosContacto": [
            {"id": "CAA", "operacion": "AL"}
          ],
          "usuarioAudit": "crm_prueba"
        };
       // print("${info}");
        responce = await updateDomicilio(info);

        if (responce) {
          setState(() {
            var calle = "";
            var numInt = "";
            var numExt = "";
            var municipio = "";
            var cp = "";
            var colonia = "";
            var estado = "";
            var pais = "";

            if (myTextEditControllerCalle.text != null) {
              calle = myTextEditControllerCalle.text;
            }
            if (myTextEditControllerNoInt.text != null) {
              numInt = "${myTextEditControllerNoInt.text}";
            }
            if (myTextEditControllerNoExt.text != null) {
              numExt = "${myTextEditControllerNoExt.text}";
            }
            if (dom.descripcion != null) {
              colonia = "${dom.descripcion}";
            }
            if (myTextEditControllerCP.text != null) {
              cp = "${myTextEditControllerCP.text}";
            }
            if (myTextEditControllerCiudad.text != null) {
              municipio = "${myTextEditControllerCiudad.text}";
            }
            if (myTextEditControllerEstado.text != null) {
              estado = "${myTextEditControllerEstado.text}";
            }
            if (myTextEditControllerPais.text != null) {
              pais = "${myTextEditControllerPais.text}";
            }

            lasnumber = "";
            datosFisicosContacto.domicilioParticular = DomicilioParticularModel(
                calle: calle,
                municipio: municipio,
                pais: pais,
                numeroEx: numExt,
                numeroIn: numInt,
                estado: estado,
                colonia: colonia,
                codigoPostal: cp,
                direccionCompleta:
                    "$calle, $numExt,$numInt, $colonia, $municipio, $estado, $cp, $pais");
          });
          loaderContacto();
        }
        // TODO: Handle this case.
        break;
      case editType.texto:
        // TODO: Handle this case.
        break;
      case editType.familiar:
        // TODO: Handle this case.
        break;
    }
    setState(() {
      _saving = false;
      if (responce) {
        customAlert(AlertDialogType.mensajeGenericoOk, context,
            "${mensajeStatus.title}", "${mensajeStatus.message}");
      } else {
        customAlert(AlertDialogType.mensajeGenericoError, context,
            "${mensajeStatus.title}", "${mensajeStatus.message}");
      }
    });
  }
}
