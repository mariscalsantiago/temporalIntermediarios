import 'package:cotizador_agente/vistas/Inicio/LoginServices.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomAlerts.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomBodyTabPerfil.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomCardPerfil.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Modelos/LoginModels.dart';
import 'package:cotizador_agente/main.dart';

class Mignp extends StatefulWidget {
  Mignp({Key key}) : super(key: key);

  @override
  MignpState createState() => new MignpState();
}

//datosMorales.datosIntermediario.generacion = 'G3';


String Tipo = "${datosMorales.datosIntermediario.cedula.tipo != null && datosMorales.datosIntermediario.cedula.tipo != "" ? "Tipo "+datosMorales.datosIntermediario.cedula.tipo : ""}";
String generacion  = "${datosMorales.datosIntermediario.generacion != null && datosMorales.datosIntermediario.generacion != "" ? "Generación "+datosMorales.datosIntermediario.generacion : ""}";
String Vence = "${datosMorales.datosIntermediario.cedula.vencimiento != null && datosMorales.datosIntermediario.cedula.vencimiento != "" ? "Vence "+ datosMorales.datosIntermediario.cedula.vencimiento : ""}";
String PolizaInicio = "${datosFisicos.personales.polizaRC.vigenciaInicial != null && datosFisicos.personales.polizaRC.vigenciaInicial != "" ? "Inicio "+ datosFisicos.personales.polizaRC.vigenciaInicial : ""}";
String PolizaFin = "${datosFisicos.personales.polizaRC.vigenciaFin != null && datosFisicos.personales.polizaRC.vigenciaFin != "" ? " - Fin "+datosFisicos.personales.polizaRC.vigenciaFin: ""}";

List<DatosBodyPerfil> mignp = <DatosBodyPerfil>[];


List<Map<dynamic, dynamic>> _listCed() {
  List<Map<dynamic, dynamic>>_list=[];

  if(generacion != "") {
    _list= [
      {'Desc' :  validateNotEmptyToString(datosMorales.datosIntermediario.cedula.numero)},
      {'Desc' :  Tipo + " | " +  generacion },
      {'Desc' :  Vence}
      ];
  } else {
    _list= [
      {'Desc' :  validateNotEmptyToString(datosMorales.datosIntermediario.cedula.numero)},
      {'Desc' :  Tipo + " | " + Vence }
    ];
  }
  return _list;
}

String validateNotEmptyToString (dynamic variable){
  String data;
  variable==null?data="":data=variable.toString();
  return data;
}

class MignpState extends State<Mignp>{

  //String _currentCua;
  List<DropdownMenuItem<String>> _dropDownCUA;
  bool _loader ;



  @override
  Widget build(BuildContext context) {

    return _loader==true ? CircularProgressIndicator():

    Column(
      children: <Widget>[
        dropMenuCUA(),
        Expanded(
          child: _bodyMyGNP(),
        )
      ],
    );

  }


  void initState() {
    sendTag("Perfil_MiGNP");
    setState(() {
      _loader=false;
    });
   // _currentCua=datosPerfilador.intermediarios[0];
    _dropDownCUA = makeCUADropList();
    buildDataMiGnp();
  // _buildData(_currentCua);
    super.initState();
  }

  Widget _bodyMyGNP(){
    return Container(
        child: Stack(
            children:  mignp.map<Widget>((DatosBodyPerfil item) {
              return Container(
                  child: CustomBodyTabPerfil(datosbody: item));
            }).toList()
        )
    );
  }

  Widget dropMenuCUA(){
    return datosPerfilador.intermediarios.length > 1 ?
    Card(
      elevation: 0,
      color: Colors.white,
      child: Container(
          height: 72.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Theme.Icons.cua,size: 16.0,),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Text("CUA", style: Theme.TextStyles.DarkGrayRegular14px
                    ),
                  )),
              Expanded(
                flex: 6,
                child:
                Container(
                  padding: const EdgeInsets.only(left:24.0,right: 48.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentCuaGNP,
                    onChanged: (String selectedItem) {
                      if(selectedItem!=currentCuaGNP){
                        setState(() {
                          _loader =true;
                          _buildData(selectedItem);
                        });
                      }
                    },
                    items: _dropDownCUA,
                  ),
                ),
              ),
            ],
          )
      ),
    ) : Container();
  }

  Future _buildData(String newCUA) async {
    mignp.clear();
    var response = await getPersonaMoral(newCUA,3);
    if(response!=null){
      currentCuaGNP = newCUA ;
     mignp = [
        DatosBodyPerfil(
            listbody: [
              DatosBodyPerfilItem(
                  seccion: "",
                  item: [
                    DatosCardPerfil(
                        list: [


                          DatosCardPerfilItem(
                              assetName: Theme.Icons.cua,
                              title: 'CUA',
                              description: [
                                {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.cua)}
                              ]
                          ),

                          DatosCardPerfilItem(
                              assetName: Theme.Icons.cedula,
                              title: 'Cédula',
                              description: _listCed()
                          ),
                        ],
                        edicion: false
                    ),
                  ]
              ),
              DatosBodyPerfilItem(
                seccion: "Póliza de responsabilidad civil",
                item: [
                  DatosCardPerfil(
                      list: [
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.passport,
                            title: 'Número de póliza',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosFisicos.personales.polizaRC.numero)},

                            ]
                        ),
                      ],
                      type: editType.poliza,

                      edicion: true
                  ),
                ],
              ),
              DatosBodyPerfilItem(
                seccion: "",
                item: [
                  DatosCardPerfil(
                      list: [
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.da,
                            title: 'DA',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.direccionAgencia)}
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.equipo,
                            title: 'Equipo',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.equipo)}
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.plaza,
                            title: 'Plaza',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.plaza)}
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.dir_regional,
                            title: 'Dirección regional',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.direccionRegional)}
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.director,
                            title: 'Director regional',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.directorRegional)}
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.funcionario,
                            title: 'Funcionario de plaza',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.responsablePlaza)}
                            ]
                        )
                      ],
                      edicion: false
                  ),
                ],
              ),
              DatosBodyPerfilItem(
                seccion: "",
                item: [
                  DatosCardPerfil(
                      list: [
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.conexion,
                            title: 'Año de conexión',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.fConexion).substring(5) }
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.antiguedad,
                            title: 'Antigüedad',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.antiguedad) }
                            ]
                        ),
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.lealtad,
                            title: 'Lealtad (Quinquenio)',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.lealtad) }
                            ]
                        ),
                      ],
                      edicion: false
                  ),
                ],
              )
            ]
        )
      ];
      _bodyMyGNP();
    }else{
      customAlert(AlertDialogType.mensajeGenericoError, context,
          "${mensajeStatus.title}", "${mensajeStatus.message}");
    }
    setState(() {
      _loader =false;
    });
  }

  List<DropdownMenuItem<String>> makeCUADropList() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in datosPerfilador.intermediarios) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i, style: Theme.TextStyles.DarkGrayRegular16px)));
    }
    return items;
  }
}

buildDataMiGnp() {

  PolizaInicio = "${datosFisicos.personales.polizaRC.vigenciaInicial != null ? "Inicio "+ datosFisicos.personales.polizaRC.vigenciaInicial: "Inicio "}";
  PolizaFin = "${datosFisicos.personales.polizaRC.vigenciaFin != null ? "- Fin "+datosFisicos.personales.polizaRC.vigenciaFin: "- Fin "}";

  mignp.clear();
    mignp = [
      DatosBodyPerfil(
          listbody: [
            DatosBodyPerfilItem(
                seccion: "",
                item: [
                  DatosCardPerfil(
                      list: [
                        DatosCardPerfilItem(
                            assetName: Theme.Icons.cua,
                            title: 'CUA',
                            description: [
                              {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.cua)}
                            ]
                        ),

                        DatosCardPerfilItem(
                            assetName: Theme.Icons.cedula,
                            title: 'Cédula',
                            description: _listCed()
                        ),
                      ],
                      edicion: false
                  ),
                ]
            ),
            DatosBodyPerfilItem(
              seccion: "Póliza de responsabilidad civil",
              item: [
                DatosCardPerfil(
                    list: [
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.passport,
                          title: 'número de póliza',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosFisicos.personales.polizaRC.numero)},

                          ]
                      ),
                    ],
                    type: editType.poliza,

                    edicion: true
                ),
              ],
            ),
            DatosBodyPerfilItem(
              seccion: "",
              item: [
                DatosCardPerfil(
                    list: [
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.da,
                          title: 'DA',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.direccionAgencia)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.equipo,
                          title: 'Equipo',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.equipo)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.plaza,
                          title: 'Plaza',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.plaza)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.dir_regional,
                          title: 'Dirección regional',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.direccionRegional)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.director,
                          title: 'Director regional',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.directorRegional)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.funcionario,
                          title: 'Funcionario de plaza',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.folioLider.responsablePlaza)}
                          ]
                      )
                    ],
                    edicion: false
                ),
              ],
            ),
            DatosBodyPerfilItem(
              seccion: "",
              item: [
                DatosCardPerfil(
                    list: [
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.conexion,
                          title: 'Año de conexión',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.fConexion)}
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.antiguedad,
                          title: 'Antigüedad',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.antiguedad) }
                          ]
                      ),
                      DatosCardPerfilItem(
                          assetName: Theme.Icons.lealtad,
                          title: 'Lealtad (Quinquenio)',
                          description: [
                            {'Desc' : validateNotEmptyToString(datosMorales.datosIntermediario.lealtad) }
                          ]
                      ),
                    ],
                    edicion: false
                ),
              ],
            )
          ]
      )
    ];

}