import 'dart:ui';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Mensajes.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:cotizador_agente/widgets/ImageSwitch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'modelo_seccion.dart';

////COMBOBOX
class ComboBoxDinamico extends StatefulWidget {
  ComboBoxDinamico({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones})
      : super(key: key);

  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;


  @override
  _ComboBoxDinamicoState createState() => _ComboBoxDinamicoState();
}

class _ComboBoxDinamicoState extends State<ComboBoxDinamico> {

  //String valorActual;
  bool isUnValor;


  void asignarValorDefault(){
    String valorDefecto;

    for(int i=0; i<widget.campo.valores.length; i++){ //Buscar si existe valorDefault
      if(widget.campo.valores[i].valor_default){

        if(widget.campo.valores[i].visible){//Asigna valor default si es visible
          valorDefecto = widget.campo.valores[i].id;
        }else{
          for(int j=0; j<widget.campo.valores.length; j++){
            if(widget.campo.valores[j].visible){ //Asigna primer valor visible
              valorDefecto = widget.campo.valores[j].id;
              break;
            }
          }
        }
      }

    }

    if(valorDefecto == null){
      for(int k=0; k<widget.campo.valores.length; k++){
        if(widget.campo.valores[k].visible){ //Asigna primer valor visible
          valorDefecto = widget.campo.valores[k].id;
          break;
        }
      }

    }
    widget.campo.valor = valorDefecto;
  }

  @override
  void initState() {


    /*if(widget.campo.esConsulta && Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan ==null){
      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan =  widget.campo.valores[0].id;
    }*/
    isUnValor = widget.campo.valores.length > 1 ? false : true;

    if(widget.campo.valor == null){ //SE INICIALIZA CAMPO

      asignarValorDefault();

      if (widget.campo.seccion_dependiente != null) {
        print("voy a filtrar la seccion"+ widget.campo.seccion_dependiente);
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
            int.parse(widget.campo.seccion_dependiente),
            int.parse(widget.campo.valores[0].id));
      }

      if(widget.campo.oculta){ //Probar con el 292
        ocultaCampos(widget.campo.valor);
        //ocultaCampos("292");
      }

    }else{//Trae Valor seleccionado

      bool seEncuentraValorEnLista = false;
      widget.campo.valores.forEach((valor){

        if(widget.campo.valor == valor.id && valor.visible){
          seEncuentraValorEnLista = true;
        }

      });

      if(!seEncuentraValorEnLista){

        asignarValorDefault();
      }

    }


    /*if (widget.campo.valor != null) {
      //valorActual = widget.campo.valor;

      if(widget.campo.esConsulta){

        bool seEncuentraValorEnLista = false;
        widget.campo.valores.forEach((valor){

          if(valor.id==Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan  && valor.visible){
            seEncuentraValorEnLista = true;
          }



        });

        if(seEncuentraValorEnLista){
           widget.campo.valor = Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan;


        }else{


          bool esValorNoVisible = true;
          String id_inicial;
          //Verificar que el valor inicial sea visible.
          for (int i = 0; i<widget.campo.valores.length && esValorNoVisible; i++){
            if(widget.campo.valores[i].visible){
              esValorNoVisible = false;
              id_inicial= widget.campo.valores[i].id;
            }


          }

          widget.campo.valor = id_inicial;

          Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = id_inicial;

        }

        //widget.actualizarSecciones(widget.campo.valor);

      }




    }else{

      bool esValorNoVisible = true;
      String id_inicial;
      //Verificar que el valor inicial sea visible.
      for (int i = 0; i<widget.campo.valores.length && esValorNoVisible; i++){
        if(widget.campo.valores[i].visible){
          esValorNoVisible = false;
          id_inicial= widget.campo.valores[i].id;
        }


      }

      widget.campo.valor = id_inicial;

      if (widget.campo.seccion_dependiente != null) {
        print("voy a filtrar la seccion"+ widget.campo.seccion_dependiente);
        Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
            int.parse(widget.campo.seccion_dependiente),
            int.parse(widget.campo.valores[0].id));
      }

      if(widget.campo.oculta){ //Probar con el 292
        ocultaCampos(widget.campo.valor);
        //ocultaCampos("292");
      }



    }*/


  }


  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 4),
      child: AbsorbPointer(
        absorbing: !widget.campo.enabled || (widget.campo.esConsulta? Utilidades.isloadingPlan: false),
        child: Visibility(
          visible: widget.campo.visible,
          child: Container(
            //color: AppColors.color_sombra,
            child: Column(
              children: <Widget>[
                Divider(
                  color: AppColors.color_Bordes, height: 1
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 8, top: 8),
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.campo.etiqueta == null
                        ? widget.campo.nombre_campo.toUpperCase()
                        : widget.campo.etiqueta.toUpperCase(),
                    style: widget.campo.enabled? TextStyle(color: AppColors.color_Etiqueta, fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'Roboto'): TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),
                  ),
                ),
                Container(
                  //height: 60,
                  decoration: BoxDecoration(
                    color: isUnValor ? AppColors.color_background : AppColors.color_background_blanco,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(color: AppColors.color_Bordes, style: BorderStyle.solid, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.color_background,
                            blurRadius: 1.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 1.5))
                      ]
                  ),
                  child: DropdownButtonFormField(
                    value:  widget.campo.valor,
                    items: getDropDownMenuItems(),
                    onChanged: isUnValor ? null : changedDropDownItem,
                    disabledHint: Text("  "+ widget.campo.valores[0].descripcion.toString(), style: TextStyle(color: AppColors.color_disable, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),),
                    /*decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:widget.campo.enabled?
                          BorderSide(color: AppColors.color_primario): BorderSide(color: Colors.grey )),
                    ),*/
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    widget.campo.valores.forEach((v){
      if(v.visible){
        items.add(new DropdownMenuItem(
            value: v.id,
            child: Container(
              padding: EdgeInsets.only(left: 8, bottom: 0),
              child: new Text(
                v.descripcion.toString(),
                style: widget.campo.enabled? TextStyle(color: AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto') : TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
              ),
            )));

      }

    });

    return items;
  }

  void changedDropDownItem(String valorSeleccionado) {
    print("VALOR SELECCIONADO: " + valorSeleccionado + " CAMPO: " + widget.campo.id_campo.toString());
    widget.campo.valor = valorSeleccionado;

    if(widget.campo.esConsulta){
      widget.actualizarSecciones(valorSeleccionado);
      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan = valorSeleccionado.toString();
      print("actualizo a plan"+ Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().idPlan);
    }


    if (widget.campo.seccion_dependiente != null) {
      print("voy a filtrar la seccion"+ widget.campo.seccion_dependiente);
      Utilidades.cotizacionesApp.getCurrentFormularioCotizacion().filtrarSeccion(
          int.parse(widget.campo.seccion_dependiente),
          int.parse(valorSeleccionado));
    }


    if(widget.campo.oculta){
      ocultaCampos(valorSeleccionado);
    }

    //Actualizar vista
    widget.agregarAlDiccionario(
        widget.campo.id_campo.toString(), widget.campo.valor);

  }

  void ocultaCampos(String valorSeleccionado){

    print("Es oculta");

    //Liberar campos modificados
    widget.campo.campos_modificados.forEach((referencia){
      print("Liberando campos modificados: "+ referencia.toString());
      List <Campo> campos  =  Utilidades.buscaCampoPorID(referencia.id_seccion, referencia.id_campo, true);
      if(campos!=null){
        campos.forEach((campo){
          campo.visible = true; //Se regresa a visible el campo en cuestión (Su estado original)
          //Se regresa el valor del campo padre a su estado original
          if(campo.parent_campo!=null){
            Campo campo_padre = Utilidades.buscaCampoPorID(campo.parent_campo.id_seccion, campo.parent_campo.id_campo, true)[0];
            print("Campo Padre es: "+referencia.toString());

            if(campo_padre.valores!=null){
              campo_padre.valores.forEach((valor){

                if(valor.id==campo.id_campo.toString()){
                  valor.visible= true;
                }
              });

            }

          }

          widget.agregarAlDiccionario("test", "test");



        });
      }else{
        print("No encontré el campo");
      }
    });

    //widget.campo.campos_modificados.clear();

    //ocultar campos
    widget.campo.valores.forEach((valor){
      if(valor.id == valorSeleccionado){
        if(valor.oculta_campos.length>0){
          print("Este valor:"+ valor.descripcion.toString()+ ", oculta campos");
          valor.oculta_campos.forEach((referencia){
            List <Campo> campos  =  Utilidades.buscaCampoPorID(referencia.id_seccion, referencia.id_campo, true);
            if(campos!=null){
              campos.forEach((campo){
                print("El campo a ocultar es: "+ campo.etiqueta.toString());


                //Se oculta el valor del campo padre
                if(campo.parent_campo!=null){
                  Campo campo_padre = Utilidades.buscaCampoPorID(campo.parent_campo.id_seccion, campo.parent_campo.id_campo, true)[0];
                  print("Campo Padre es: "+campo_padre.etiqueta);


                  if(campo_padre.valores!=null){
                    //campo_padre.filtrarHijos(campo.id_campo.toString());
                    if(campo_padre.valor == campo.id_campo.toString()){

                      bool esValorNoVisible = true;
                      String id_inicial;
                      //Verificar que el valor inicial sea visible.
                      for (int i = 0; i<campo_padre.valores.length && esValorNoVisible; i++){
                        if(campo_padre.valores[i].visible){
                          esValorNoVisible = false;
                          id_inicial= campo_padre.valores[i].id;
                        }
                      }
                      campo_padre.valor =  id_inicial;

                    }

                    campo_padre.valores.forEach((valor){

                      if(valor.id==campo.id_campo.toString()){
                        valor.visible= false;
                      }
                    });




                  }

                }else{
                  print("El campo padre es null");
                }

                //widget.agregarAlDiccionario("test", "test");


                //Se oculta el campo
                print("oculto el campo"+ campo.etiqueta);
                campo.visible = false;
                campo.visibleLocal = false;
                print("oculto el campo"+ campo.etiqueta+ campo.visible.toString());


                widget.campo.campos_modificados.add(referencia);
                print("Se agrego la referencia"+ referencia.id_campo.toString());


              });
            }
          });
        }
      }
    });


  }


}

////CHECKBOX


class CheckBoxDinamico extends StatefulWidget {
  CheckBoxDinamico({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones}) : super(key: key);
  final Campo campo;
  bool currentValue = false;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;





  @override
  _CheckBoxDinamicoState createState() => _CheckBoxDinamicoState();
}

class _CheckBoxDinamicoState extends State<CheckBoxDinamico> {

  @override
  void initState() {

    if(widget.campo.valor!=null){
      widget.currentValue = widget.campo.valor == "true" ? true : false;

    }else{

      if(widget.campo.checked){
        widget.currentValue = true;

      }else{
        widget.currentValue = false;
      }
    }


  }


  @override
  Widget build(BuildContext context) {

    if(widget.campo.valor!=null){
      widget.currentValue = widget.campo.valor == "true" ? true : false;
    }else{

      if(widget.campo.checked){
        widget.currentValue = true;

      }else{
        widget.currentValue = false;
      }
    }

    return Visibility(
      visible: widget.campo.visible,
      child: CheckboxListTile(
        title: Text(widget.campo.etiqueta),
        value: widget.currentValue,
        activeColor: AppColors.color_naranja_primario,
        onChanged: widget.campo.enabled ? (newValue) {
          setState(() {
            widget.currentValue = newValue;
            newValue? widget.campo.valor = "true": widget.campo.valor= "false";
          });

        }: null,
        controlAffinity: ListTileControlAffinity.leading,  //  <-- Checkbox al principio
      ),
    );
  }
}////CHECKBOX




////CHECKBOX Dependiente

class CheckBoxDinamicoDependiente extends StatefulWidget {
  CheckBoxDinamicoDependiente({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones}) : super(key: key);
  final Campo campo;
  bool currentValue = false;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;


  @override
  _CheckBoxDinamicoDependienteState createState() => _CheckBoxDinamicoDependienteState();
}

class _CheckBoxDinamicoDependienteState extends State<CheckBoxDinamicoDependiente> {

  @override
  void initState() {

    if(widget.campo.valor!=null){
      widget.currentValue = widget.campo.valor == "true" ? true : false;
      print("entro al initState");
      //widget.agregarAlDiccionario("", "");


    }else{

      if(widget.campo.checked){
        widget.currentValue = true;
        widget.campo.valor = "true";

      }else{
        widget.currentValue = false;
        widget.campo.valor = "false";

      }
    }


  }


  @override
  Widget build(BuildContext context) {

    if(widget.campo.valor!=null){
      widget.currentValue = widget.campo.valor == "true" ? true : false;
    }


    return Visibility(
      visible: widget.campo.visible,
      child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext ctxt, int index) {

            if(index==0){
              return CheckboxListTile(
                title: Text(widget.campo.etiqueta),
                value: widget.currentValue,
                activeColor: AppColors.color_primario,
                onChanged: widget.campo.enabled ? (newValue) {
                  setState(() {
                    widget.currentValue = newValue;
                    newValue? widget.campo.valor = "true": widget.campo.valor= "false";
                  });

                }: null,
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              );
            }else{





              return ListView.builder(
                  itemCount: widget.campo.valores.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int j) {


                    return Visibility(
                      visible: widget.campo.valor == "true" ? true : false,
                      child: ListView.builder(
                          itemCount: widget.campo.valores[j].children.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext ctxt, int k) {
                            return CampoDinamico(campo: widget.campo.valores[j].children[k], agregarDicc: widget.agregarAlDiccionario, actualizarSecciones: widget.actualizarSecciones,actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,);
                          }),
                    );

                  });
            }

          }),

    );
  }
}

//////

////CALENDARIO

class CalendarioDinamicoRange extends StatefulWidget {
  final Campo campo;

  const CalendarioDinamicoRange({Key key, this.campo}) : super(key: key);

  @override
  _CalendarioDinamicoRangeState createState() =>
      _CalendarioDinamicoRangeState();
}

class _CalendarioDinamicoRangeState extends State<CalendarioDinamicoRange> {

  Future<Null> _selectDate1(BuildContext context, DateTime selectedDate, DateTime firstDate, DateTime lastDate ) async {
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: selectedDate.year.toString(),
        locale: const Locale('es', 'MX'),
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        widget.campo.valor = Jiffy(picked).format("yyy-MM-dd").toString();
      });
  }



  var fecha = new DateTime.now().toString().substring(0,10);

  initState(){
    super.initState();

    DateTime fecha_1_init;
    if(widget.campo.rango.rango_inicio!=null){
      fecha_1_init = DateTime( int.parse(widget.campo.rango.rango_inicio.substring(6,10))  , int.parse(widget.campo.rango.rango_inicio.substring(3,5)) , int.parse(widget.campo.rango.rango_inicio.substring(0,2)) );


    }else{
      fecha_1_init = DateTime.now();

    }

    if(widget.campo.valor==null || widget.campo.valor==""){
      widget.campo.valor = Jiffy(fecha_1_init).format("yyy-MM-dd").toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
        absorbing: !widget.campo.enabled,
        child: Visibility(
            visible: widget.campo.visible,
            child: GestureDetector(
              onTap: (){
                DateTime now = DateTime.now();
                _selectDate1(context, DateTime.parse(widget.campo.valor),
                    widget.campo.rango.rango_inicio != null ? DateTime( int.parse(widget.campo.rango.rango_inicio.substring(6,10))  , int.parse(widget.campo.rango.rango_inicio.substring(3,5)) , int.parse(widget.campo.rango.rango_inicio.substring(0,2)) ) : DateTime(1900),
                    widget.campo.rango.rango_fin != null ? DateTime( int.parse(widget.campo.rango.rango_fin.substring(6,10))  , int.parse(widget.campo.rango.rango_fin.substring(3,5)) , int.parse(widget.campo.rango.rango_fin.substring(0,2)) ) : DateTime(now.year , now.month , now.day)
                );
              },
              child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                      color: AppColors.color_sombra,
                      border: Border(
                          bottom: BorderSide(color: AppColors.color_primario))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 8, top: 8),
                        child: Text(
                          widget.campo.etiqueta == null
                              ? widget.campo.nombre_campo
                              : widget.campo.etiqueta,
                          style: widget.campo.enabled? TextStyle(color: AppColors.color_primario, fontSize: 15): TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      Container(
                          height: 30,
                          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                          padding: EdgeInsets.only(bottom: 8),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Jiffy( DateTime.parse(widget.campo.valor)).format("dd-MM-yyyy").toString()
                              Text(Jiffy(widget.campo.valor).format("dd-MM-yyyy").toString(), style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,),
                              Icon(Icons.date_range, color: Colors.grey,)
                            ],
                          ))
                    ],
                  )
              ),
            )
        )
    );
  }
}



class CalendarioConRangoRelativo extends StatefulWidget {
  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;
  //El valor de este campo estará separado por comas (Así lo requiere el Backend, en String).
  const CalendarioConRangoRelativo({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones}) : super(key: key);

  @override
  _CalendarioConRangoRelativoState createState() => _CalendarioConRangoRelativoState();
}

class _CalendarioConRangoRelativoState extends State<CalendarioConRangoRelativo> {


  bool calcularValor(){
    //TODO: Verificar que sea con el campo de validacion, no sólo con un año.
    return Jiffy(DateTime.parse(widget.campo.valor.split(",")[0])).diff(DateTime.parse(widget.campo.valor.split(",")[0]),"y" ) >1;
  }


  Future<Null> _selectDate1(BuildContext context, DateTime selectedDate, DateTime firstDate, DateTime lastDate ) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('es', 'MX'),
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        DateTime fecha_2_init = Jiffy(picked).add(days:widget.campo.rangoRelativa[1].dia, months: widget.campo.rangoRelativa[1].mes, years:widget.campo.rangoRelativa[1].anio);
        //Asignar el valor de las dos fechas en el valor completo del campo
        widget.campo.valor = Jiffy(picked).format("yyy-MM-dd").toString() +","+ Jiffy(fecha_2_init).format("yyy-MM-dd").toString();

      });
  }


  Future<Null> _selectDate2(BuildContext context, DateTime selectedDate, DateTime firstDate, DateTime lastDate ) async {
    final DateTime picked = await showDatePicker(
      //locale: Locale("es","MX"),
        context: context,
        locale: const Locale('es', 'MX'),
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != selectedDate)



      setState(() {
        widget.campo.valor = widget.campo.valor.split(",")[0] +","+ Jiffy(picked).format("yyy-MM-dd").toString();




      });
  }


  @override
  void initState() {
    super.initState();

    DateTime fecha_1_init = DateTime( int.parse(widget.campo.rango.rango_inicio.substring(6,10))  , int.parse(widget.campo.rango.rango_inicio.substring(3,5)) , int.parse(widget.campo.rango.rango_inicio.substring(0,2)) );
    DateTime fecha_2_init = Jiffy(fecha_1_init).add(days:widget.campo.rangoRelativa[1].dia, months: widget.campo.rangoRelativa[1].mes, years:widget.campo.rangoRelativa[1].anio);

    if(widget.campo.valor==null || widget.campo.valor==""){
      widget.campo.valor = Jiffy(fecha_1_init).format("yyy-MM-dd").toString() +","+ Jiffy(fecha_2_init).format("yyy-MM-dd").toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext ctxt, int index) {

          switch(index){
          //Fecha 1
          //Eal valor de la fecha 1 lo vamos a guardar siempre antes de la primer coma.
          //El valor de la fecha 1 SIEMPRE actualiza el valor de la fecha 2
            case 0:
              return
                AbsorbPointer(
                    absorbing: !widget.campo.enabled,
                    child: Visibility(
                        visible: widget.campo.visible,
                        child: GestureDetector(
                          onTap: (){
                            DateTime now = DateTime.now();
                            _selectDate1(context, DateTime.parse(widget.campo.valor.split(",")[0]),
                                widget.campo.rango.rango_inicio != null ? DateTime( int.parse(widget.campo.rango.rango_inicio.substring(6,10))  , int.parse(widget.campo.rango.rango_inicio.substring(3,5)) , int.parse(widget.campo.rango.rango_inicio.substring(0,2)) ) : DateTime(1900),
                                widget.campo.rango.rango_fin != null ? DateTime( int.parse(widget.campo.rango.rango_fin.substring(6,10))  , int.parse(widget.campo.rango.rango_fin.substring(3,5)) , int.parse(widget.campo.rango.rango_fin.substring(0,2)) ) : DateTime(now.year , now.month , now.day)
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.color_sombra,
                                  border: Border(
                                      bottom: BorderSide(color: AppColors.color_primario))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 8, top: 8),
                                    child: Text(
                                      widget.campo.etiqueta == null
                                          ? widget.campo.nombre_campo
                                          : widget.campo.etiqueta + " inicial",
                                      style: widget.campo.enabled? TextStyle(color: AppColors.color_primario, fontSize: 15): TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                      height: 30,
                                      margin: EdgeInsets.only(left: 8, top: 8),
                                      padding: EdgeInsets.only(bottom: 8),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(Jiffy( DateTime.parse(widget.campo.valor.split(",")[0])).format("dd-MM-yyyy").toString(), style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                                          Icon(Icons.date_range, color: Colors.grey,)
                                        ],
                                      ))


                                ],
                              )
                          ),
                        )
                    )
                );


            case 1: //Facha 2: El campo se simula un textField, aunque no se muestra uno, en realidad se muestra un botón que llama a un modal de calendario.
            //El valor de la fecha 2 no actualiza ningún valor, pero su rango está controlado por el campo 1

              return
                AbsorbPointer(
                    absorbing: !widget.campo.enabled,
                    child: Visibility(
                        visible: widget.campo.visible,
                        child: GestureDetector(
                          onTap: (){
                            _selectDate2(context, DateTime.parse(widget.campo.valor.split(",")[1]),
                                Jiffy(DateTime.parse(widget.campo.valor.split(",")[0])).add(days:widget.campo.rangoRelativa[0].dia, months: widget.campo.rangoRelativa[0].mes, years:widget.campo.rangoRelativa[0].anio),
                                Jiffy(DateTime.parse(widget.campo.valor.split(",")[0])).add(days:widget.campo.rangoRelativa[1].dia, months: widget.campo.rangoRelativa[1].mes, years:widget.campo.rangoRelativa[1].anio));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.color_sombra,
                                  border: Border(
                                      bottom: BorderSide(color: AppColors.color_primario))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 8, top: 8),
                                    child: Text(
                                      widget.campo.etiqueta == null
                                          ? widget.campo.nombre_campo
                                          : widget.campo.etiqueta + " final",
                                      style: widget.campo.enabled? TextStyle(color: AppColors.color_primario, fontSize: 15): TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                      height: 30,
                                      margin: EdgeInsets.only(left: 8, top: 8),
                                      padding: EdgeInsets.only(bottom: 8),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(Jiffy( DateTime.parse(widget.campo.valor.split(",")[1])).format("dd-MM-yyyy").toString(), style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                                          Icon(Icons.date_range, color: Colors.grey,)
                                        ],
                                      ))
                                ],
                              )
                          ),
                        )
                    )
                );

            case 2: // Sus hijos

              if(Jiffy(DateTime.parse(widget.campo.valor.split(",")[1])).diff(DateTime.parse(widget.campo.valor.split(",")[0]),"y" ) >= 1 ){
                widget.campo.valores[0].children[0].visible = true;
                widget.campo.valores[1].children[0].visible = false;
              }else{
                widget.campo.valores[0].children[0].visible = false;
                widget.campo.valores[1].children[0].visible = true;


              }


              return Column(
                children: <Widget>[
                  Visibility(
                    visible: Jiffy(DateTime.parse(widget.campo.valor.split(",")[1])).diff(DateTime.parse(widget.campo.valor.split(",")[0]),"y" ) >= 1 ,
                    child: CampoDinamico(actualizarSecciones:widget.actualizarSecciones, agregarDicc: widget.agregarAlDiccionario, campo: widget.campo.valores[0].children[0], actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,),
                  ),
                  Visibility(
                    visible: Jiffy(DateTime.parse(widget.campo.valor.split(",")[1])).diff(DateTime.parse(widget.campo.valor.split(",")[0]),"y" ) < 1 ,
                    child: CampoDinamico(actualizarSecciones:widget.actualizarSecciones, agregarDicc: widget.agregarAlDiccionario, campo: widget.campo.valores[1].children[0], actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,),
                  )
                ],
              );

              break;


            default:
              return Container();

          }



        });
  }
}


////

////BOTON BORDE

class BotonDinamicoBorde extends StatefulWidget {
  BotonDinamicoBorde({Key key, this.titulo}) : super(key: key);
  final Campo titulo;

  @override
  _BotonDinamicoStateBorde createState() => _BotonDinamicoStateBorde();
}

class _BotonDinamicoStateBorde extends State<BotonDinamicoBorde> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OutlineButton(
        textColor: AppColors.color_primario,
        child: Text(widget.titulo.etiqueta,
          style: TextStyle(fontSize: 15),),
        onPressed: () {},
        borderSide: BorderSide(
          color: AppColors.color_primario, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 0.8, //width of the border
        ),
      ),
    );
  }
}

////

////BOTON SIN BORDE

class BotonDinamicoSinBorde extends StatefulWidget {
  BotonDinamicoSinBorde({Key key, this.titulo}) : super(key: key);
  final Campo titulo;

  @override
  _BotonDinamicoSinBordeState createState() => _BotonDinamicoSinBordeState();
}

class _BotonDinamicoSinBordeState extends State<BotonDinamicoSinBorde> {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: AppColors.color_primario,
      color: AppColors.color_primario,
      child: Text(widget.titulo.toString(),
        style: TextStyle(fontSize: 15),),
      onPressed: () {},
    );
  }
}

////Text

class TextoGenericoDinamico extends StatefulWidget {
  TextoGenericoDinamico({Key key, this.texto}) : super(key: key);
  final Campo texto;

  @override
  _TextoGenericoDinamicoState createState() => _TextoGenericoDinamicoState();
}

class _TextoGenericoDinamicoState extends State<TextoGenericoDinamico> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.texto.toString(),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          color: AppColors.color_primario,
          fontSize: 15),
    );
  }
}

/////

////TextField

class CustomTextField extends StatefulWidget {
  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;
  final void Function() actualizarCodigoPostalFamiliares;
  final bool Function() validarCodigoPostalFamiliares;

  const CustomTextField({
    Key key,
    this.campo,
    this.agregarAlDiccionario,
    this.actualizarSecciones,
    this.actualizarCodigoPostalFamiliares,
    this.validarCodigoPostalFamiliares,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String codigoPostal = '';

  void actualizarCodigoPostalFamiliares() {
    setState(() {
      widget.actualizarCodigoPostalFamiliares();
    });
  }

  @override
  Widget build(BuildContext context) {

    final GlobalCupertinoLocalizations localizations = CupertinoLocalizations.of(context);
    TextEditingController _controller;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8, left: 8),
            decoration: BoxDecoration(
                color: AppColors.color_background_blanco,
                border: Border(
                    bottom: BorderSide(color: AppColors.color_mail))),
            child: Visibility(
              visible: widget.campo.visible,
              child: Column(
                children: <Widget>[
                  /*Container(
                    color: AppColors.color_sombra,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8),
                    child: Text(widget.campo.obligatorio == true ? widget.campo.etiqueta + " *" : widget.campo.etiqueta,
                      style: TextStyle(color: AppColors.color_primario, fontSize: 15),
                    ),
                  ),*/
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 50,
                    child: new SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      reverse: true,
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(color: AppColors.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                        key: ValueKey('Key_' + widget.campo.hashCode.toString() + "_" + DateTime.now().millisecondsSinceEpoch.toString()),
                        inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(widget.campo.reg_ex)), //[0-9]
                          LengthLimitingTextInputFormatter(widget.campo.dato_longitud!=null ? widget.campo.dato_longitud.length == 2 ?  widget.campo.dato_longitud[1] : widget.campo.dato_longitud[0]: null ,)],
                        enabled: widget.campo.enabled,
                        maxLengthEnforced: true,
                        onSaved: (String value) {
                          widget.campo.valor = value;
                          print("llegue al onsave " + widget.campo.valor);
                        },
                        onChanged: (valor) {
                          widget.campo.valor = valor;
                          if ( (widget.campo.id_seccion == Utilidades.titularSeccion && widget.campo.id_campo == Utilidades.titularCampo) ) {
                            widget.campo.valor = valor;
                            if (valor != codigoPostal && widget.validarCodigoPostalFamiliares() == true) {
                              if (valor.length == 5) {
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
                              }
                            }
                          }
                          // Se agrega validación para cuando se edita una cotización y el adicional cambia CP
                          if(widget.campo.id_seccion == null && widget.campo.id_campo == Utilidades.titularCampo && Utilidades.actualizarCodigoPostalAdicional == false){
                            widget.campo.valor = valor;
                            if (valor != codigoPostal) {
                              if(widget.validarCodigoPostalFamiliares == null){
                                if (valor.length == 5) {
                                  codigoPostal = valor;
                                  print("VALIDA cuando idsecc null: " + valor.toString());
                                }
                              }else if(widget.validarCodigoPostalFamiliares() == true){
                                if (valor.length == 5) {
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
                                }
                              }
                            }
                          }
                        },
                        initialValue: widget.campo.valor,
                        validator:(value) {
                          setState(() {
                            print("validando"+ value);
                            widget.campo.isValid = widget.campo.validaCampo(value);
                          });
                          return null;

                        },
                        keyboardType: widget.campo.tipo_dato=="integer" || widget.campo.reg_ex == "[0-9]" ?TextInputType.number:TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent)),

                          //labelStyle: TextStyle(color: AppColors.color_primario),
                          labelText: widget.campo.etiqueta,
                          labelStyle: TextStyle(
                              color: AppColors.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                          //labelText: widget.campo.etiqueta),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.campo.error != "" ? true : false,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8),
              child: Text(
                widget.campo.error,
                style: TextStyle(color: AppColors.color_primario, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextFieldCotizacion extends StatefulWidget{
  CustomTextFieldCotizacion({Key key, this.campo, this.comparativa, this.index, this.cont}) : super(key: key);
  final Campo campo;
  final Comparativa comparativa;
  final int index;
  final int cont;

  @override
  _CustomTextFieldCotizacionState createState() => _CustomTextFieldCotizacionState();
}

class _CustomTextFieldCotizacionState extends State<CustomTextFieldCotizacion>{

  bool mostrarText = true;
  bool mostrarCampo = false;



  void ocultarTextField(){
    setState(() {
      if(widget.comparativa.nombre == null){
        widget.comparativa.nombre = "Propuesta" + ' ' + (widget.cont).toString();
        mostrarText = false;
        mostrarCampo = true;
        print("ENTRE TEXTFIELD");
      }else{
        mostrarText = false;
        mostrarCampo = true;
      }
    });
  }

  void ocultarText(){
    setState(() {
      // if(widget.comparativa.nombre == null)
      mostrarCampo = false;
      mostrarText = true;

      print("ENTRE TEXT");
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: mostrarCampo,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0),
              child: new TextFormField(
                initialValue: widget.comparativa.nombre,
                inputFormatters: [LengthLimitingTextInputFormatter(30), WhitelistingTextInputFormatter(RegExp("[A-Za-zÀ-ÿ\u00f1\u00d10-9 ]")),],
                maxLength: 30,
                maxLengthEnforced: true,
                decoration:
                InputDecoration(
                  hintText: "Nombre cotización",
                  fillColor: AppColors.color_primario,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                    borderSide: new BorderSide(
                        color: AppColors.color_primario
                    ),
                  ),
                  focusedBorder:  new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                    borderSide: new BorderSide(
                        color: AppColors.color_primario
                    ),
                  ),
                  suffixIcon:  IconButton(
                      icon: Icon(Icons.done, color: Colors.grey,),
                      onPressed: () {
                        setState(() {
                          ocultarText();
                        });
                      }),
                ),
                onChanged: (valor){
                  setState(() {
                    widget.comparativa.nombre = valor;
                  });
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
          Visibility(
            visible: mostrarText,
            child: Padding(

              padding: const EdgeInsets.only(right: 10.0, left: 10.0),

              child:  Align(
                alignment: Alignment.bottomCenter,
                child:  ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.comparativa.nombre == null ?
                    "Propuesta" + ' ' + (widget.cont).toString() : widget.comparativa.nombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.color_titulo, fontSize: 24, fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          ocultarTextField();
                        });

                      },
                      child: Container(
                        //padding: EdgeInsets.all(16.5),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.color_titulo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),),
        ],
      ),
    );
  }
}



////Card

class CardDinamico extends StatefulWidget {
  CardDinamico({Key key, this.campo}) : super(key: key);

  final List<Campo> campo;

  @override
  _CardDinamicoState createState() => _CardDinamicoState();
}

class _CardDinamicoState extends State<CardDinamico> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
      ),
    );
  }
}

class RenglonTablaDoscolumna extends StatefulWidget {
  final String titulo;
  final String valor;

  RenglonTablaDoscolumna({Key key, this.valor, this.titulo}) : super(key: key);

  @override
  _RenglonTablaDoscolumnaState createState() => _RenglonTablaDoscolumnaState();
}

class _RenglonTablaDoscolumnaState extends State<RenglonTablaDoscolumna> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.color_sombra,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 8.0,bottom: 16.0, left: 8.0),
                        child: Text(
                          widget.titulo,
                          style: TextStyle(
                              color: AppColors.color_texto,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0,bottom: 16.0),
                        child: Text(
                          widget.valor,
                          style: TextStyle(
                              color: AppColors.color_texto,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),

                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 16,right: 16),
                          child: Divider( //002e71
                            thickness: 0.5,
                            color: Colors.grey,
                            height: 0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


////////////////// Toggle

class ToggleConValores extends StatefulWidget {

  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;
  bool isSwitched = false;
  final void Function(String) actualizarSecciones;

  ToggleConValores({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones}) : super(key: key);
  @override
  _ToggleConValoresState createState() => _ToggleConValoresState();
}

class _ToggleConValoresState extends State<ToggleConValores> {

  @override
  void initState() {

    if(widget.campo.valor!=null){
      widget.isSwitched = widget.campo.valor == widget.campo.valores[1].id ? true : false;
      print("entro al initState");

    }else{

      if(widget.campo.checked){
        widget.isSwitched = true;
        widget.campo.valor = widget.campo.valores[1].id;

      }else{
        widget.isSwitched = false;
        widget.campo.valor = widget.campo.valores[0].id;

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.campo.valor!=null){
      widget.isSwitched = widget.campo.valor == widget.campo.valores[1].id ? true : false;
    }


    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext ctxt, int index) {



          if(index==0){
            return Row(
              children: <Widget>[
                Text(widget.campo.etiqueta, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.color_appBar, fontFamily: 'OpenSansRegular'),),
                Spacer(flex: 2,),
                Switch(
                  value: widget.isSwitched,
                  onChanged: (value) {
                    setState(() {
                      widget.isSwitched = value;
                      value? widget.campo.valor = widget.campo.valores[1].id: widget.campo.valor = widget.campo.valores[0].id;

                      print(widget.campo.valor);

                    });
                  },
                  activeTrackColor: AppColors.color_naranja_primario.withOpacity(0.38),
                  activeColor: AppColors.color_naranja_primario,
                  inactiveTrackColor: AppColors.color_switch_simple_apagado.withOpacity(0.38),
                  inactiveThumbColor: AppColors.color_switch_simple_apagado,
                ),
              ],
            );
          }else{

            print("imprimo sus hijos"+ widget.campo.valores.length.toString());


            return ListView.builder(
                itemCount: widget.campo.valores.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int j) {



                  return Visibility(
                    visible: widget.campo.valor == widget.campo.valores[1].id ? true : false,
                    child: ListView.builder(
                        itemCount: widget.campo.valores[j].children.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int k) {

                          return CampoDinamico(campo: widget.campo.valores[j].children[k], agregarDicc: widget.agregarAlDiccionario, actualizarSecciones: widget.actualizarSecciones,actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,);

                        }),
                  );


                });
          }

        });

  }
}

class ComboBoxDependiente extends StatefulWidget {

  final Campo campo;
  final void Function(String, String) agregarDicc;
  final void Function(String) actualizarSecciones;

  const ComboBoxDependiente({Key key, this.campo, this.agregarDicc, this.actualizarSecciones}) : super(key: key);


  @override
  _ComboBoxDependienteState createState() => _ComboBoxDependienteState();
}

class _ComboBoxDependienteState extends State<ComboBoxDependiente> {



  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: widget.campo.valores.length + 1,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext ctxt, int index) {

          if(index == 0){
            return ComboBoxDinamico(
              campo: widget.campo,
              agregarAlDiccionario: widget.agregarDicc,
              actualizarSecciones: widget.actualizarSecciones,

            );
          }

          if(widget.campo.valores[index -1].child!=null){
            return Visibility(
              visible: widget.campo.valor == widget.campo.valores[index - 1].id ? true : false,
              child: CampoDinamico(
                campo: widget.campo.valores[index -1].child,
                agregarDicc: widget.agregarDicc,
                actualizarSecciones: widget.actualizarSecciones,
                actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,
              ),
            );

          }else{
            return Visibility(
                visible: widget.campo.valor == widget.campo.valores[index - 1].id ? true : false,
                child: ListView.builder(
                    itemCount: widget.campo.valores[index -1].children.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext ctxt, int lista_hijos_cont) {

                      return CampoDinamico(
                        campo: widget.campo.valores[index -1].children[lista_hijos_cont],
                        agregarDicc: widget.agregarDicc,
                        actualizarSecciones: widget.actualizarSecciones,
                        actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,
                      );

                    })
            );
          }
        });
  }
}


class SwitchConImagen extends StatefulWidget {

  final Campo campo;

  const SwitchConImagen({Key key, this.campo}) : super(key: key);

  @override
  _SwitchConImagenState createState() => _SwitchConImagenState();
}

class _SwitchConImagenState extends State<SwitchConImagen> {

  Color colorIconoUno;
  Color colorIconoDos;
  int selected = 1;

  @override
  void initState() {

    if(widget.campo.valor==null || widget.campo.valor==""){
      widget.campo.valor = widget.campo.valores[0].id;
      selected = int.parse(widget.campo.valores[0].id);
    }

    if(widget.campo.valor!=null){
      selected = int.parse(widget.campo.valor);
    }
  }


  @override
  Widget build(BuildContext context) {


    if(widget.campo.valor!=null){
      selected = int.parse(widget.campo.valor);
    }

    var esMujer = (selected != null && selected == int.parse(widget.campo.valores[0].id));
    var esHombre = (selected != null && selected == int.parse(widget.campo.valores[1].id));


    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          Stack(
            children: <Widget>[
              Container(
                padding:  EdgeInsets.all(0),
                margin: EdgeInsets.only(left: 10),
                height: 66,
                width: 160,
                child: Ink(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white30, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 3,
                          offset: Offset(0,3)
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 180,
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: new BoxDecoration(
                          color: esMujer
                              ? AppColors.color_primario
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),

                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: IconButton(
                            icon: ImageSwitch(image: widget.campo.valores[0].icono, isOn: esMujer), //mujer
                            color: esMujer
                                ? Colors.white
                                : AppColors.color_switch_apagado,
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                selected = int.parse(widget.campo.valores[0].id);
                                widget.campo.valor = widget.campo.valores[0].id.toString();
                                print("sexo"+ widget.campo.valor);
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child:  Container(
                        decoration: new BoxDecoration(
                          color: esHombre
                              ? AppColors.color_primario
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: ImageSwitch(image: widget.campo.valores[1].icono, isOn: esHombre),//Icon(CotizadorUnicoApp.hombre),
                          color: esHombre
                              ? Colors.white
                              : AppColors.color_switch_apagado,
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              selected = int.parse(widget.campo.valores[1].id);
                              widget.campo.valor = widget.campo.valores[1].id.toString();
                              print("sexo"+ widget.campo.valor);
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(widget.campo.valores[0].descripcion, style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color_titulo,
                    ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(widget.campo.valores[1].descripcion, style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color_titulo),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class SwitchConImagenDependiente extends StatefulWidget {

  final Campo campo;
  final void Function(String, String) agregarAlDiccionario;
  final void Function(String) actualizarSecciones;

  const SwitchConImagenDependiente({Key key, this.campo, this.agregarAlDiccionario, this.actualizarSecciones}) : super(key: key);

  @override
  _SwitchConImagenDependienteState createState() => _SwitchConImagenDependienteState();
}

class _SwitchConImagenDependienteState extends State<SwitchConImagenDependiente> {


  Color colorIconoUno;
  Color colorIconoDos;
  int selected = 0;

  @override
  void initState() {
    // TODO: implement initState

    if(widget.campo.valor==null || widget.campo.valor==""){
      widget.campo.valor = widget.campo.valores[0].id;
      selected = int.parse(widget.campo.valores[0].id);
    }

    if(widget.campo.valor!=null){
      selected = int.parse(widget.campo.valor);
    }
  }


  @override
  Widget build(BuildContext context) {
    if(widget.campo.valor!=null){
      selected = int.parse(widget.campo.valor);
    }


    var esValor1 =  (selected != null && selected == int.parse(widget.campo.valores[0].id));
    var esValor2 =  (selected != null && selected == int.parse(widget.campo.valores[1].id));


    return Visibility(
      visible: widget.campo.visible,
      child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (BuildContext ctxt, int index) {

            if(index==0){
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    Stack(
                      children: <Widget>[
                        Container(
                          padding:  EdgeInsets.all(0),
                          margin: EdgeInsets.only(left: 10),
                          height: 66,
                          width: 160,
                          child: Ink(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white30, width: 0.0),
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 3,
                                    offset: Offset(0,3)
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: esValor1
                                        ? AppColors.color_primario
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),

                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: IconButton(

                                      icon: ImageSwitch(image: widget.campo.valores[0].icono, isOn: esValor1), //mujer
                                      color: esValor1

                                          ? Colors.white
                                          : AppColors.color_switch_apagado,
                                      iconSize: 50,
                                      onPressed: () {
                                        setState(() {
                                          selected = int.parse(widget.campo.valores[0].id);
                                          widget.campo.valor = widget.campo.valores[0].id.toString();
                                          print("sexo"+ widget.campo.valor);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 5,
                                child:  Container(
                                  decoration: new BoxDecoration(
                                    color: esValor2
                                        ? AppColors.color_primario
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: ImageSwitch(image: widget.campo.valores[1].icono, isOn: esValor2), //hombre
                                    color: esValor2
                                        ? Colors.white
                                        : AppColors.color_switch_apagado,
                                    iconSize: 50,
                                    onPressed: () {
                                      setState(() {
                                        selected = int.parse(widget.campo.valores[1].id);
                                        widget.campo.valor = widget.campo.valores[1].id.toString();
                                        print("sexo"+ widget.campo.valor);

                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(widget.campo.valores[0].descripcion, style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.color_titulo,
                              ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(widget.campo.valores[1].descripcion, style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.color_titulo),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else{

              return ListView.builder(
                  itemCount: widget.campo.valores.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int j) {


                    return Visibility(
                      visible: widget.campo.valor == widget.campo.valores[j].id ? true : false,
                      child: ListView.builder(
                          itemCount: widget.campo.valores[j].children.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext ctxt, int k) {

                            return CampoDinamico(campo: widget.campo.valores[j].children[k], agregarDicc: widget.agregarAlDiccionario, actualizarSecciones: widget.actualizarSecciones,actualizarCodigoPostalFamiliares: () {}, validarCodigoPostalFamiliares: ()=>false,);

                          }),
                    );

                  });
            }

          }),

    );
  }
}


class CardCoberturas extends StatefulWidget {

  final Campo campo;

  const CardCoberturas({Key key, this.campo}) : super(key: key);

  @override
  _CardCoberturasState createState() => _CardCoberturasState();
}

class _CardCoberturasState extends State<CardCoberturas> {

  @override
  void initState() {
    super.initState();

    if(widget.campo.valores.length >=1){
      String coberturas = widget.campo.valores[0].descripcion;
      for(int i = 1; i< widget.campo.valores.length; i++){

        coberturas = coberturas + "," + widget.campo.valores[i].descripcion;

      }
      widget.campo.valor = coberturas;
    }else{
      widget.campo.valor = "";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.campo.visible,
      child: Container(
        color: AppColors.color_sombra,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Text(widget.campo.etiqueta,
                style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w600, fontSize: 16),),
            ),

            ListView.builder(
                itemCount: widget.campo.valores.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index){

                  if(!widget.campo.valores[index].visible){
                    return Container(); //No mostrar espacio vacío
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Visibility(
                          visible: widget.campo.valores[index].visible,
                          child: Text("\u2022 " + widget.campo.valores[index].descripcion,
                            style: TextStyle(color: AppColors.color_titulo, fontWeight: FontWeight.w400, fontSize: 16),),
                        ),
                      ],
                    ),
                  );

                }),
          ],
        ),
      ),
    );
  }
}
