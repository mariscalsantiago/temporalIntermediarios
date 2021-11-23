
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class FiltrosCotizacionesGuardadas extends StatefulWidget {
  Function handleClick;
  Function(BuildContext) llenarTabla;
  Function (String, String, String, String, String, int ) changeValues;
  FiltrosCotizacionesGuardadas({Key key, this.handleClick, this.llenarTabla, this.changeValues}) : super(key: key);
  @override
  _FiltrosCotizacionesGuardadasState createState() => _FiltrosCotizacionesGuardadasState();
}

class _FiltrosCotizacionesGuardadasState extends State<FiltrosCotizacionesGuardadas> {

  final formKey = GlobalKey<FormState>();
  String nombreCotizacionFiltro = "";
  String nombreFiltro = "";
  String fechaInicioFiltro = null;
  String fechaFinFiltro = null;
  String filtro = "";
  int pagina = 1;

  @override
  void initState() {
    DateTime now = DateTime.now();
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    //fechaInicioFiltro = DateFormat('yyyy-MM-dd').format(now);
    //fechaFinFiltro = DateFormat('yyyy-MM-dd').format(now);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mis cotizaciones",
          style: TextStyle(
              color:ColorsCotizador.texto_tabla_comparativa,
              letterSpacing: 0.15,
              fontWeight: FontWeight.normal,
              fontSize: 20
          ),
        ),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios,
            color: Utilidades.color_primario,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Utilidades.color_primario),
        backgroundColor: Colors.white,
        actions:[
          /*IconButton(
            icon: new Icon(Icons.tune,
              color: Utilidades.color_primario,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => FiltrosCotizacionesGuardadas(
                        handleClick:  widget.handleClick
                    ),
                  )
              );
            },
          ),*/
          PopupMenuButton<String>(
            onSelected: widget.handleClick,
            itemBuilder: (BuildContext context) {
              return {'Nueva cotización'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: ColorsCotizador.color_Bordes),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text("ACCIONES", style: TextStyle(
                              color: ColorsCotizador.color_Etiqueta,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0,
                              letterSpacing: 0.15)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(


                                child: Text(choice, style: TextStyle(
                                    color: ColorsCotizador.color_appBar,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    letterSpacing: 0.15)
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 60),
                                  child: Image.asset("assets/icon/cotizador/guardar_Enabled.png", height: 25, width: 25)
                              ),

                            ],
                          ),
                        ),
                        Divider(color: ColorsCotizador.color_Bordes),
                      ],
                    )
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.87,
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: ColorsCotizador.inputUnderlineFiltros)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: ColorsCotizador.inputUnderlineFiltros)
                              ),
                              labelText: "Nombre cotización",
                              labelStyle: TextStyle(
                                  color: ColorsCotizador.gnpTextSytemt1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Roboto'
                              ),
                              //labelText: widget.campo.etiqueta),
                            ),
                            onSaved: (val){
                              setState(() {
                                nombreCotizacionFiltro = val;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35),
                          child: TextFormField(
                            style: TextStyle(color: ColorsCotizador.gnpTextUser, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: ColorsCotizador.inputUnderlineFiltros)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: ColorsCotizador.inputUnderlineFiltros)
                              ),
                              labelText: "Titular",
                              labelStyle: TextStyle(
                                  color: ColorsCotizador.gnpTextSytemt1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Roboto'
                              ),
                              //labelText: widget.campo.etiqueta),
                            ),
                            onSaved: (val){
                              setState(() {
                                nombreFiltro = val;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    DateTime now = DateTime.now();
                                    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                                    fechaInicioFiltro = DateFormat('yyyy-MM-dd').format(now);
                                    _selectDate1(context,
                                        DateTime.parse(fechaInicioFiltro),
                                        DateTime(1900),
                                        DateTime(now.year , now.month , now.day),
                                        true,
                                        false
                                    );
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 8, right: 10),
                                      decoration: BoxDecoration(
                                          color: ColorsCotizador.color_background_blanco,
                                          border: Border(
                                              bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                      child: Column(
                                        children: <Widget>[
                                          fechaInicioFiltro != null ? Container(
                                            width: 200,
                                            margin: EdgeInsets.only(left: 8, top: 8),
                                            child: Text("Del día",
                                              style:  TextStyle(color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            ),
                                          ): Container(),
                                          Container(
                                              height: 30,
                                              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                                              padding: EdgeInsets.only(bottom: 8),
                                              width: 200,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  //Jiffy( DateTime.parse(widget.campo.valor)).format("dd-MM-yyyy").toString()
                                                  Text(fechaInicioFiltro != null ? Jiffy(fechaInicioFiltro).format("dd-MM-yyyy").toString() : "Del día", style: TextStyle(color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                                                  Icon(Icons.date_range, color: Colors.grey,)
                                                ],
                                              ))
                                        ],
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    DateTime now = DateTime.now();
                                    fechaFinFiltro = DateFormat('yyyy-MM-dd').format(now);
                                    _selectDate1(context,
                                        DateTime.parse(fechaFinFiltro),
                                        DateTime(1900),
                                        DateTime(now.year , now.month , now.day),
                                        false,
                                        true
                                    );
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(top: 8, left: 10),
                                      decoration: BoxDecoration(
                                          color: ColorsCotizador.color_background_blanco,
                                          border: Border(
                                              bottom: BorderSide(color: ColorsCotizador.color_mail))),
                                      child: Column(
                                        children: <Widget>[
                                          fechaFinFiltro != null ? Container(
                                            width: 200,
                                            margin: EdgeInsets.only(left: 8, top: 8),
                                            child: Text("Al día",
                                              style:  TextStyle(color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                            ),
                                          ) : Container(),
                                          Container(
                                              height: 30,
                                              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                                              padding: EdgeInsets.only(bottom: 8),
                                              width: 200,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  //Jiffy( DateTime.parse(widget.campo.valor)).format("dd-MM-yyyy").toString()
                                                  Text(fechaFinFiltro != null ? Jiffy(fechaFinFiltro).format("dd-MM-yyyy").toString() : "Al día", style: TextStyle(color: ColorsCotizador.color_appBar, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Roboto'), textAlign: TextAlign.left,),
                                                  Icon(Icons.date_range, color: Colors.grey,)
                                                ],
                                              ))
                                        ],
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 22, bottom: 22),
                      child: FlatButton(
                        color: Utilidades.color_primario,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          formKey.currentState.save();


                            pagina = 1;
                            if(nombreCotizacionFiltro != ""){
                              setState(() {
                                filtro = "nombreCotizacion";
                              });

                            } else if(nombreFiltro != ""){
                              setState(() {
                                filtro = "nombre";
                              });

                            } else if(fechaInicioFiltro != null && fechaFinFiltro != null){
                              setState(() {
                                filtro = "fecha";
                              });

                            }
                            widget.changeValues(nombreFiltro, nombreCotizacionFiltro, fechaInicioFiltro, fechaFinFiltro, filtro, pagina);
                            widget.llenarTabla(context);
                            Navigator.pop(context);


                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "FILTRAR",
                            style: TextStyle(fontSize: 15.0, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate1(BuildContext context, DateTime selectedDate, DateTime firstDate, DateTime lastDate, bool fechaInicio, bool fechaFinal ) async {
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: selectedDate.year.toString(),
        locale: const Locale('es', 'MX'),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: ColorsCotizador.secondary900,
              accentColor: ColorsCotizador.secondary900,
              colorScheme: ColorScheme.light(primary: ColorsCotizador.secondary900),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        if(fechaInicio) {
          fechaInicioFiltro = Jiffy(picked).format("yyy-MM-dd").toString();
        } else  if(fechaFinal){
          fechaFinFiltro = Jiffy(picked).format("yyy-MM-dd").toString();
        }

      });
  }
}
