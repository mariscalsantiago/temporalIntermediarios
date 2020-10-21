import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Widgets/CustomBodyTabPerfil.dart';
import 'package:cotizador_agente/Custom/Widgets/CustomCardPerfil.dart';
import 'package:cotizador_agente/Functions/Analytics.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/main.dart';

import 'edicion_datos_perfil.dart';


class Contacto extends StatefulWidget {
  Contacto({Key key}) : super(key: key);

  @override
  ContactoState createState() => new ContactoState();
}

List<DatosBodyPerfil> contactos = <DatosBodyPerfil>[];

String validateNotEmptyToString (dynamic variable){
  String data;
  variable==null?data="":data=variable.toString();
  return data;
}

loaderContacto (){
  contactos.clear();
  contactos = [DatosBodyPerfil(
      listbody: [
        DatosBodyPerfilItem(
            seccion: "Datos de contacto",
            item: [
              DatosCardPerfil(
                  list: [
                    DatosCardPerfilItem(
                        assetName: Theme.Icons.correo,
                        title: 'correo electrónico',
                        description: [
                          {'Desc' :  validateNotEmptyToString(datosFisicosContacto.email)}
                        ]
                    ),
                  ],
                  type: editType.correo,
                  edicion: true
              ),
              DatosCardPerfil(
                  list: [
                    DatosCardPerfilItem(
                        assetName: Theme.Icons.telefono,
                        title: 'teléfono celular',
                        description: [
                          {'Desc' : validateNotEmptyToString(datosFisicosContacto.telefonoMovil)}

                        ]
                    ),
                  ],
                  type: editType.telefono,
                  edicion: true
              ),
              DatosCardPerfil(
                  list: [
                    DatosCardPerfilItem(
                        assetName: Theme.Icons.domicilio_particular,
                        title: 'Domicilio particular',
                        description: [
                          {'Desc' : validateNotEmptyToString(datosFisicosContacto.domicilioParticular!=null ?datosFisicosContacto.domicilioParticular.direccionCompleta:"")}
                        ]
                    ),
                  ],
                  type: editType.direccion,
                  edicion: true
              ),
              DatosCardPerfil(
                  list: [
                    DatosCardPerfilItem(
                        assetName: Theme.Icons.domicilio_fiscal,
                        title: 'Domicilio fiscal',
                        description: [
                          {'Desc' : validateNotEmptyToString(datosFisicosContacto.domicilioFiscal)}
                        ]
                    ),
                  ],
                  type: editType.direccion,
                  edicion: false
              ),
            ]
        ),
        DatosBodyPerfilItem(
          seccion: "Contacto de emergencia",
          item: [
            DatosCardPerfil(
                list: [
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.persona,
                      title: 'Nombre y parentesto',
                      description: [
                        {'Desc' : datosFisicos.contactoEmergencia.nombre != null && datosFisicos.contactoEmergencia.nombre
                            != "" ? datosFisicos.contactoEmergencia.nombre : ""},
                        {'Desc' : datosFisicos.contactoEmergencia.parentesco != null && datosFisicos.contactoEmergencia.parentesco
                            != "" ? datosFisicos.contactoEmergencia.parentesco : ""},
                      ]
                  ),
                  DatosCardPerfilItem(
                      assetName: Theme.Icons.telefono,
                      title: 'Teléfono celular de contacto',
                      description: [
                        {'Desc' : datosFisicos.contactoEmergencia.telefono != null && datosFisicos.contactoEmergencia.telefono != "" ? datosFisicos.contactoEmergencia.telefono : ""},

                        // {'Desc' : validateNotEmptyToString(datosFisicos.contactoEmergencia.telefono)}
                      ]
                  )
                ],
                type: editType.contatoEmergencia,
                edicion: true
            ),
          ],
        )
      ]
  )];
}

class ContactoState extends State<Contacto>{
  void initState() {
    sendTag("Perfil_Contacto");
    loaderContacto();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
            children:  contactos.map<Widget>((DatosBodyPerfil item) {
              return Container(
                  child: CustomBodyTabPerfil(datosbody: item));
            }).toList()
        )

    );
  }
}