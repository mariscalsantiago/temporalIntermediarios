import 'package:cotizador_agente/Functions/Validate.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomBodyTabPerfil.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomCardPerfil.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/Modelos/LoginModels.dart';
import 'package:cotizador_agente/main.dart';




class Personales extends StatefulWidget {
  Personales({Key key}) : super(key: key);

  @override
  PersonalesState createState() => new PersonalesState();
}


String bornDate = validateNotEmptyToString(datosFisicos.personales.fechaNacimiento,"");
String age =  validateNotEmptyToString(datosFisicos.personales.edad,"")+" años";
String genre = validateNotEmptyToString(datosFisicos.personales.genero,"");

List<DatosBodyPerfil> personal = <DatosBodyPerfil>[];

loaderPersonales(){
  personal.clear();
  print("Test");
  print(genre);
  personal = [DatosBodyPerfil(
      listbody: [
        DatosBodyPerfilItem(
            seccion:"",
            item: [
              DatosCardPerfil(
                  list: [
                    DatosCardPerfilItem(
                        assetName: Theme.Icons.nationality,
                        title: 'Nacionalidad',
                        description: [
                          {'Desc' :  "${datosFisicos.personales.nacionalidad != null && datosFisicos.personales.nacionalidad != ""
                              ? datosFisicos.personales.nacionalidad:"" }"}
                        ]
                    ),

                    DatosCardPerfilItem(
                        assetName: Theme.Icons.man,
                        title:'Género' ,
                        description: [
                          {'Desc' : genre=="M"?"Masculino":genre=="F"?"Femenino":""}
                        ]
                    ),

                    DatosCardPerfilItem(
                        assetName: Theme.Icons.birthday,
                        title: 'Fecha de Nacimiento',
                        description: [
                          {'Desc' :  bornDate + " | " + age }

                        ]
                    ),

                    DatosCardPerfilItem(
                        assetName: Theme.Icons.rfc,
                        title: 'RFC',
                        description: [
                          {'Desc' : "${datosFisicos.personales.rfc != null && datosFisicos.personales.rfc != ""
                              ? datosFisicos.personales.rfc:""}"}
                        ]
                    ),

                    DatosCardPerfilItem(
                        assetName: Theme.Icons.curp,
                        title: 'CURP',
                        description: [
                          {'Desc' : "${datosFisicos.personales.curp != null && datosFisicos.personales.curp != ""
                              ? datosFisicos.personales.curp:""}"}

                        ]
                    ),

                    DatosCardPerfilItem(
                        assetName: Theme.Icons.ring,
                        title: 'Estado civil',
                        description: [
                          {'Desc' : "${datosFisicos.personales.estadoCivil != null && datosFisicos.personales.estadoCivil != ""
                              ? datosFisicos.personales.estadoCivil:""}"}

                        ]
                    ),

                  ],
                  type: editType.texto,
                  edicion: false
              ),

            ]
        ),
//        datosFisicos.escolaridad.area;
        DatosBodyPerfilItem(
          seccion: "Último grado de estudios",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.escolaridad,
                      title: 'grado de estudios',
                      description: [
                        {'Desc' : "${datosFisicos.escolaridad.institucion != null && datosFisicos.escolaridad.institucion != ""
                            ? datosFisicos.escolaridad.institucion: ""}"},

                        {'Desc' : "${datosFisicos.escolaridad.area != null && datosFisicos.escolaridad.area != ""
                            ? datosFisicos.escolaridad.area : ""}"}

                      ]
                  ),
                ],
                type: editType.estudios,
                edicion: true
            ),
          ],
        )
      ]
  ) ];
}

class PersonalesState extends State<Personales>{
  void initState() {
    sendTag("Perfil_Personales");
    loaderPersonales();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
            children:  personal.map<Widget>((DatosBodyPerfil item) {
              return Container(
                  child: CustomBodyTabPerfil(datosbody: item));
            }).toList()
        )

    );
  }
}
