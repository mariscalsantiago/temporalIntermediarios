
import 'package:cotizador_agente/utils/Colores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SendEmail extends StatefulWidget {
  @override
  _SendEmailState createState() => _SendEmailState();

}

class _SendEmailState extends State<SendEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),

      ),
      body: Column(
        children: <Widget>[

        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text("Escoge la opción para \nenviar la cotización",  overflow: TextOverflow.clip, style: TextStyle(fontSize: 20.0, color: AppColors.color_titulo),
                textAlign: TextAlign.left,),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 32, bottom: 24),
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                heroTag: "btn1",
                tooltip: "Cerrar",
                backgroundColor: AppColors.color_primario,
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),

          Row(
            children: <Widget>[
             Padding(
               padding: EdgeInsets.only(right: 24, left: 24),
               child: new Text("Mail", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.color_titulo),),
             ),

            ],

          ),
           Padding(
             padding: EdgeInsets.only(right: 24, left: 24, top: 4),
             child: Row(

              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.5),
                  child: Icon(Icons.email, color: AppColors.color_titulo,),
                  decoration: BoxDecoration(
                      border: Border(
                        top:BorderSide(width: 1, color: AppColors.color_titulo),
                        bottom:BorderSide(width: 1, color: AppColors.color_titulo),
                        left:BorderSide(width: 1, color: AppColors.color_titulo),
                      )
                  ),
                ),
                 Flexible(
                   child: Padding(
                     padding: EdgeInsets.only(right: 0, left: 0),
                     child: new TextFormField(
                       decoration: new InputDecoration(
                         fillColor: AppColors.color_titulo,
                         border: new OutlineInputBorder(
                           borderRadius: new BorderRadius.circular(0.0),
                           borderSide: new BorderSide(
                           ),
                         ),
                       ),
                       validator: (val) {
                         if(val.length==0) {
                           return "Este no es un correo valido";
                         }else{
                           return null;
                         }
                       },
                       keyboardType: TextInputType.emailAddress,
                       style: new TextStyle(
                         fontFamily: "Poppins",
                       ),
                     ),
                   ),
                ),
              ],
            ),
           ),

          Row(
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(right: 24, left: 24, bottom: 4, top: 24),
                child: new Text("Comentario", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.color_titulo),),
              ),
            ],

          ),

          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 24, left: 24, bottom: 32),
                  child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 100,

                    decoration: new InputDecoration(
                      labelText: "Escribe tu mensaje",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),

            ],
          ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(right: 24, left: 24, bottom: 32),
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: AppColors.color_primario,
                    textColor: Colors.white,
                    disabledColor: AppColors.color_primario,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    splashColor: AppColors.color_titulo,
                    //onPressed: (),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ENVIAR",
                        style: TextStyle(fontSize: 16.0, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
