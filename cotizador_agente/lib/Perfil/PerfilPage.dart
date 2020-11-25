import 'dart:async';
import 'package:cotizador_agente/vistas/Inicio/LoginServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:flutter/foundation.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Perfil/Contacto.dart';
import 'package:cotizador_agente/Perfil/Logros.dart';
import 'package:cotizador_agente/Perfil/Mignp.dart';
import 'package:cotizador_agente/Perfil/Personales.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cotizador_agente/Perfil/Eventos.dart';
import 'package:cotizador_agente/Perfil/Designaciones.dart';

List<DatosFamiliares> familiares = <DatosFamiliares>[];
bool _saving = false;

class DatosFamiliares {
  DatosFamiliares({
    this.parentesco,
    this.nombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.edicion,
  });

  FocusNode nameFocus = new FocusNode();
  TextEditingController nameController = new TextEditingController();
  FocusNode apellidoPatFocus = new FocusNode();
  TextEditingController apellidoPatController = new TextEditingController();
  FocusNode apellidoMatFocus = new FocusNode();
  TextEditingController apellidoMatController = new TextEditingController();
  String parentesco;
  String nombres;
  String apellidoPaterno;
  String apellidoMaterno;
  String edicion;

  bool get isValid =>
      parentesco != null && nombres != null && apellidoPaterno != null;
}



class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() => new _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {





  Future getImage() async {

    String foto;
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      fetchFoto(context, image);
      Navigator.of(context).pop();
      setState(() {
        _saving = true;
      });


      Timer(new Duration(seconds: 10), () =>
          setState(() {

            _saving = false;
          }),
      );

    }

  }
  Future getImageGallery() async {
    String foto;

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fetchFoto(context, image);
      Navigator.of(context).pop();
      setState(() {
        _saving = true;
      });

      Timer(new Duration(seconds: 10), () =>
          setState(() {
            _saving = false;
          }),
      );

    }
  }



  void deleteImagen() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Eliminar foto de perfil",
              style: TextStyle(
                  color: Theme.Colors.gnpBlue,
                  fontSize: 16.0,
                  fontFamily: "Roboto")),
          content: new Text("¿Estas seguro que deseas eliminar tu fotografía?",
              style: TextStyle(
                  color: Theme.Colors.gnpBlue,
                  fontSize: 16.0,
                  fontFamily: "Roboto")),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("ACEPTAR",
                  style: TextStyle(
                      color: Theme.Colors.Orange,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              onPressed: () async {
                setState(() {
                  _saving = true;
                });
                bool resp = await fetchFotoDelete(context);

                if(resp){
                  setState(() {
                    _saving = false;
                    datosFisicos.personales.foto = null;
                  });
                }else{

                  setState(() {
                    _saving = false;
                  });
                  customAlert(AlertDialogType.errorBonos, context,
                      "Opps", "Ocurrió un error al intentar cambiar tu fotografía.");

                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(child: Stack(children:_buildArea(context)));
  }

  List<Widget> _buildArea(BuildContext context) {
    var top = 0.0;
    print("test");
    print(datosFisicos.personales.foto);
    Widget area = Scaffold(

        body: DefaultTabController(
            length: 6,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.orange,
                        ),
                      ),
                      backgroundColor: Theme.Colors.White,
                      expandedHeight: 180.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            // print('constraints=' + constraints.toString());
                            top = constraints.biggest.height;

                            return FlexibleSpaceBar(
                                centerTitle: true,
                                titlePadding:EdgeInsetsDirectional.only(start: 0, bottom: 16),
                                title:  top == 56.0 ? Text("${datosFisicos.personales.nombre + " " + datosFisicos.personales.aPaterno + " " + datosFisicos.personales.aMaterno}", style: TextStyle(color: Theme.Colors.Back, fontSize: 16.0,)):Container(),
                                background: Center(
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                                child: new Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            new GestureDetector(
                                                              onTap: () {
                                                                // handleUserInteraction();
                                                                _showEditPhoto();
                                                              },
                                                              child: Column(
                                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    datosFisicos != null &&
                                                                        datosFisicos.personales.foto !=
                                                                            null&&
                                                                        datosFisicos.personales.foto != ""
                                                                        ? new Container(
                                                                      width: 90.0,
                                                                      height: 90.0,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right: 30.0,
                                                                          left: 15.0),
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0.0),
                                                                      child: ClipOval(
                                                                        child:
                                                                        new Container(
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                          CachedNetworkImage(
                                                                            imageUrl:
                                                                            datosFisicos.personales.foto,
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                        : new Container(
                                                                      width: 90.0,
                                                                      height: 90.0,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right: 30.0,
                                                                          left: 15.0),
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0.0),
                                                                      child: ClipOval(
                                                                        child:
                                                                        new Container(
                                                                            color: Colors
                                                                                .white,
                                                                            child: Image.asset('assets/img/userpictureEmpty.png')
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    new Container(
                                                                      width: 90,
                                                                      height:0.0,
                                                                      //color: Colors.red,
                                                                      child: new Container(
                                                                          decoration: new BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: new BorderRadius.all(const  Radius.circular(40.0))),
                                                                          width: 30,
                                                                          height: 30.0,
                                                                          transform: Matrix4
                                                                              .translationValues(
                                                                              0.0,
                                                                              -20.0,
                                                                              0.0),
                                                                          margin:
                                                                          const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                              60.0),
                                                                          child:
                                                                          Icon(
                                                                            Theme.Icons.camera,
                                                                            color: Theme.Colors.Orange,
                                                                          )),
                                                                    )
                                                                  ]),
                                                            ), //column
                                                            Expanded(
                                                                child: new Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: <Widget>[
                                                                      new Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left: 10.0,
                                                                            right: 20),
                                                                        child: Text(
                                                                          "${datosFisicos.personales.nombre + " " + datosFisicos.personales.aPaterno + " " + datosFisicos.personales.aMaterno}",
                                                                          textAlign:
                                                                          TextAlign.left,
                                                                          style: TextStyle(
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 16.0,
                                                                              fontFamily:
                                                                              "Roboto"),
                                                                        ),
                                                                      ),
                                                                      /*
                                                                      new Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left: 10.0,
                                                                            right: 20),
                                                                        child: Text(
                                                                          "${datosFisicos.personales.nickname != null ? datosFisicos.personales.nickname : ""}",
                                                                          textAlign:
                                                                          TextAlign.left,
                                                                          style: TextStyle(
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 15.0,
                                                                              fontFamily:
                                                                              "Roboto"),
                                                                        ),
                                                                      ),
                                                                      */
                                                                    ]))
                                                          ]),
                                                    ]))),
                                      ],
                                    ))
                            );
                          })),//Aqui
                  SliverPersistentHeader(
                    delegate: SliverAppBarDelegate(
                      TabBar(
                        labelColor: Theme.Colors.Dark,
                        isScrollable: true,
                        unselectedLabelColor: Theme.Colors.Light,
                        tabs: [
                          Tab(
                            //icon: Icon(Icons.info),
                              text: "Personales"),
                          Tab(
                            //icon: Icon(Icons.lightbulb_outline),
                              text: "Mi GNP"),
                          Tab(
                            //icon: Icon(Icons.lightbulb_outline),
                              text: "Logros"),
                          Tab(
                            //icon: Icon(Icons.lightbulb_outline),
                              text: "Designaciones"),
                          Tab(
                            //icon: Icon(Icons.lightbulb_outline),
                              text: "Contacto"),
                          Tab(
                            //icon: Icon(Icons.lightbulb_outline),
                              text: "Eventos"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: Container(
                child: new TabBarView(
                  children: [
                    Center(child: _buildPersonales()),
                    Center(child: _buildMignp()),
                    Center(child: _buildLogros()),
                    Center(child: _buildDesignaciones()),
                    Center(child: _buildContacto()),
                    Center(child: _buildEventos()),
                  ],
                ),
              ),
            )));


    var l = new List<Widget>();
    l.add(area);
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

  Widget _buildPersonales(){
    return Personales();
  }

  Widget _buildMignp(){
    return Mignp();
  }
  Widget _buildLogros(){
    return LogrosTab();
  }
  Widget _buildDesignaciones(){
    return Designaciones();
  }
  Widget _buildContacto(){
    return Contacto();
  }
  Widget _buildEventos(){
    return Eventos ();
  }


  void _showEditPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( "Editar foto de perfil",
              style: TextStyle(
                  color: Theme.Colors.gnpBlue,
                  fontSize: 16.0,
                  fontFamily: "Roboto")),
          content: new Container(
            //color: Colors.cyan,
            height: 175,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new GestureDetector(
                      onTap: () {
                        //handleUserInteraction();
                        getImageGallery();
                      },
                      child: new Container(
                          padding:
                          const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                width: 30.0,
                                height: 30.0,
                                child: Image.asset(
                                  'images/ic_galeria@4x.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 7.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black12),
                                  ),
                                  //color: Color(0xFFBFBFBF),
                                ),
                                child: Text(
                                  'Galería',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.Colors.DarkGray,
                                    fontSize: 17.0,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                            ),
                          ]))),
                  new GestureDetector(
                      onTap: () {
                        //       handleUserInteraction();
                        getImage();
                      },
                      child: new Container(
                          padding:const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10.0),

                                width: 30,
                                height: 30.0,
                                child: Image.asset(
                                  'images/ic_pm_camara@4x.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 7.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black12),
                                  ),
                                  //color: Color(0xFFBFBFBF),
                                ),
                                child: Text(
                                  'Cámara',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.Colors.gnpBlue,
                                    fontSize: 17.0,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                            ),
                          ]))),
                  new GestureDetector(
                      onTap: () {
                        // handleUserInteraction();
                        deleteImagen();
                      },
                      child: new Container(
                          padding:
                          const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Row(children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                width: 30,
                                height: 30.0,
                                child: Image.asset(
                                  'images/ic_eliminar@4x.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 7.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black12),
                                  ),
                                  //color: Color(0xFFBFBFBF),
                                ),
                                child: Text(
                                  'Eliminar',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.Colors.gnpBlue,
                                    fontSize: 17.0,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                            ),
                          ])))
                ]),
          ),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCELAR",
                  style: TextStyle(
                    color: Theme.Colors.Orange,
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  )),
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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
   // sendTag("Perfil_Page");
    // print(datosFisicosContacto.telefonoFijo);
    super.initState();
  }
/*
  Future<bool> validacionConectividad() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternet = true;
      });
    } else {
      setState(() {
        isInternet = false;
      });
    }
    return isInternet;
  }*/
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.Colors.White,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}