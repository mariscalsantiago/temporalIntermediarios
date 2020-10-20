import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomBodyTabPerfil.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomCardPerfil.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Modelos/LoginModels.dart';
import 'package:cotizador_agente/main.dart';
import 'edicion_datos_perfil.dart';

class Eventos extends StatefulWidget {
  Eventos({Key key}) : super(key: key);

  @override
  EventosState createState() => new EventosState();
}

List<DatosCardPerfil> createList(){
  List<DatosCardPerfil> listAcompania= new List<DatosCardPerfil>();
  if(datosFisicos.compania != null && datosFisicos.compania.isNotEmpty) {
    for (int i = 0; i < datosFisicos.compania.length; i++) {
    //  print("datosFisicos.compania  " + datosFisicos.compania.toString());
      listAcompania.add(
        DatosCardPerfil(
            list: [
              DatosCardPerfilItem(
                  assetName: Theme.Icons.persona,
                  title: 'Nombre y Parentesco ',
                  description: [

                    {
                      'Desc': datosFisicos.compania[i].nombre != null &&
                          datosFisicos.compania[i].nombre.isNotEmpty
                          ? datosFisicos.compania[i].nombre : ""
                    },
                    {
                      'Desc': datosFisicos.compania[i].parentesco != null &&
                          datosFisicos.compania[i].parentesco.isNotEmpty
                          ? datosFisicos.compania[i].parentesco : ""
                    },
                  ]
              ),

            ],
            type: editType.acompaniante,
            edicion: true,
            idComp: i
        ),
      );
    }
  }
  listAcompania.add(
      DatosCardPerfil(
          list: [
            DatosCardPerfilItem(
              assetName: Theme.Icons.persona,
              title: "acompañante",
              description: [
                {'Desc' : ""}
              ],
            ),


          ],
          type: editType.acompaniante,
          edicion: true
      )
  );
  return listAcompania;
}

String Lista(){
  String valor;
  if (datosFisicos.salud.alergias != null && datosFisicos.salud.alergias.isNotEmpty ) {
    for(int i =0; i < datosFisicos.salud.alergias.length; i++){
      valor = datosFisicos.salud.alergias[i];
    }
    return valor;
  }
  else{
    return "";
  }
}

String Enfermedades(){
  String enf;
  if(datosFisicos.salud.enfermedades != null && datosFisicos.salud.enfermedades.isNotEmpty ) {
    for (int j = 0; j < datosFisicos.salud.enfermedades.length; j++) {
      enf = datosFisicos.salud.enfermedades[j];
    }
    return enf;
  }
  else{

    return"";

  }
}

String Condiciones(){
  String especiales;
  if(datosFisicos.salud.condicionesEspeciales != null && datosFisicos.salud.condicionesEspeciales.isNotEmpty ) {
    for (int j = 0; j < datosFisicos.salud.condicionesEspeciales.length; j++) {
      especiales = datosFisicos.salud.condicionesEspeciales[j];
    }
    return especiales;
  }
  else{
    return"";
  }
}

String CondicionesA(){
  String alimenticias;
  if(datosFisicos.salud.condicionesAlimenticias != null && datosFisicos.salud.condicionesAlimenticias.isNotEmpty ) {
    for (int j = 0; j < datosFisicos.salud.condicionesAlimenticias.length; j++) {
      alimenticias = datosFisicos.salud.condicionesAlimenticias[j];
    }
    return alimenticias;
  }
  else{
    return"";
  }
}

String Deportes(){
  String deportes;



 if(datosFisicos.salud.deportes != null && datosFisicos.salud.deportes.isNotEmpty ){
  for (int j=0; j< datosFisicos.salud.deportes.length; j++){
    deportes = datosFisicos.salud.deportes[j];
  }
  return deportes;
  }
 else{
   return "";
 }
}


List<DatosBodyPerfil> evento = <DatosBodyPerfil>[];
loaderEventos (){
  evento.clear();
  evento = [DatosBodyPerfil(
      listbody: [
        DatosBodyPerfilItem(
          seccion: "Nickname",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(assetName: Theme.Icons.nickname,
                      title: "nickname",
                      description: [
                        {'Desc' : "${datosFisicos.personales.nickname != null && datosFisicos.personales.nickname != "" ? datosFisicos.personales.nickname : ""}"}
                      ]
                  ),
                ],
                type: editType.nickname,
                edicion: true
            ),
          ],
        ),
        DatosBodyPerfilItem(
          seccion: "Viaje",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.passport,
                      title: " pasaporte",
                      description: [
                        {'Desc' : "${datosFisicos.personales.pasaporte.numero != null && datosFisicos.personales.pasaporte.numero != ""
                            ? datosFisicos.personales.pasaporte.numero: ""}"},
                        {'Desc' : "${datosFisicos.personales.pasaporte.vigencia != null && datosFisicos.personales.pasaporte.vigencia != ""
                            ? "Vigencia: "+datosFisicos.personales.pasaporte.vigencia:""}"}
                      ]
                  ),
                ],
                type: editType.pasaporte,
                edicion: true
            ),
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.visa,
                      title: "visa",
                      description: [
                        {'Desc' : "${datosFisicos.personales.visa.numero != null && datosFisicos.personales.visa.numero != ""
                            ? datosFisicos.personales.visa.numero:""}"},
                        {'Desc' : "${datosFisicos.personales.visa.vigencia !=null && datosFisicos.personales.visa.vigencia != ""
                            ? "Vigencia: "+datosFisicos.personales.visa.vigencia:""}"}
                      ]
                  ),
                ],
                type: editType.visa,
                edicion: true
            ),
          ],
        ),


        DatosBodyPerfilItem(
          seccion: " Talla de Playera",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.talla,
                      title: "talla de playera",
                      description: [
                        {'Desc' : "${datosFisicos.personales.talla != null && datosFisicos.personales.talla != ""
                            ? datosFisicos.personales.talla:""}"}
                      ]
                  ),
                ],
                type: editType.playera,
                edicion: true
            ),
          ],

        ),

        DatosBodyPerfilItem(
          seccion: " Salud",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.sangre,
                      title: "Tipo de Sangre",
                      description: [
                        {'Desc' : "${datosFisicos.salud.tipoSangre != null && datosFisicos.salud.tipoSangre != ""
                            ? datosFisicos.salud.tipoSangre:""}"}
                      ]
                  ),
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.alergias,
                      title: "Alergias",
                      description: [
                        {'Desc': Lista()}
                      ]
                  ),
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.enfermedades,
                      title: "Enfermedades",
                      description: [
                        {'Desc' : Enfermedades()}
                      ]
                  ),

                ],
                type: editType.salud,
                edicion: true
            ),
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.especiales,
                      title: "Condiciones Especiales",
                      description: [
                        {'Desc' : Condiciones()}
                      ]
                  ),

                  DatosCardPerfilItem(
                      assetName: Theme.Icons.alimenticios,
                      title: "Condiciones Alimenticias",
                      description: [
                        {'Desc' : CondicionesA()}
                      ]
                  ),

                ],
                type: editType.condiciones,
                edicion: true
            ),

            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.deportes,
                      title: "Deportes",
                      description: [
                        {'Desc' : Deportes()}
                      ]
                  ),
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.fumar,
                      title: "Fumador",
                      description: [
                        {'Desc' : "${datosFisicos.salud.fumador != null
                            ? datosFisicos.salud.fumador==true ?"Si":"No":""}"}
                      ]
                  ),

                ],
                type: editType.deportes,
                edicion: true
            ),
          ],
        ),
        DatosBodyPerfilItem(
          seccion: " Acompañante",
          item: createList(),
        ),
      ]
  )];
}


class EventosState extends State<Eventos>{
  void initState() {
    sendTag("Perfil_Eventos");
    loaderEventos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
              children:  evento.map<Widget>((DatosBodyPerfil item) {
                return Container(
                    child: CustomBodyTabPerfil(datosbody: item));
              }).toList()
          )
      ),
    );

  }
}



