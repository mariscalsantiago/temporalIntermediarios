import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/UserInterface/login/principal_form_login.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';

class LoginRestablecerContrasena extends StatefulWidget {
  final Responsive responsive;
  const LoginRestablecerContrasena({Key key, this.responsive}) : super(key: key);
  @override                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  _LoginRestablecerContrasenaState createState() => _LoginRestablecerContrasenaState();
}

class _LoginRestablecerContrasenaState extends State<LoginRestablecerContrasena> {

  bool machPass=false;
  bool validPass=false;
  bool lentPass = false;
  bool hasMayusPass = false;
  bool hasNumPass = false;
  bool hasGNPPass = true;
  bool hasEspacePass = true;
  bool hasConsecutiveIgualesPass = false;
  bool hasConsecutivosPass = false;
  bool _saving;
  bool nuevaContrasena;
  bool confirmarnuevaContrasena;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNuevaContrasena;
  FocusNode focusNuevaContrasena;
  TextEditingController controllerConfirmarContrasena;
  FocusNode focusConfirmarContrasena;
  RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
  RegExp reConsecutive2 = RegExp('(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)');// 123 abcd
  //abcdefghijklmnñopqrstuvwxyz

  @override
  void initState() {
    _saving = false;
    nuevaContrasena = true;
    confirmarnuevaContrasena = true;
    controllerNuevaContrasena = new TextEditingController();
    controllerConfirmarContrasena = new TextEditingController();
    focusNuevaContrasena = new FocusNode();
    focusConfirmarContrasena = new FocusNode();
    //validateIntenetstatus(context, widget.responsive);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor:Tema.Colors.backgroud,
          appBar: AppBar(
            backgroundColor: Tema.Colors.backgroud,
            elevation: 0,
            title: Text('Reestablecer contraseña', style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontWeight: FontWeight.normal,
                fontSize: widget.responsive.ip(2.5)
            ),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close,
                color: Tema.Colors.GNP,),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
          ),
          body: Stack(
              children: builData(widget.responsive)
          )
      ),
    );
  }

  List<Widget> builData(Responsive responsive) {
    Widget data = Container();
    Form form;

    data = SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(left: responsive.wp(6), right: responsive.wp(6)),
            child: form = new Form(
              key: _formKey,
              child: Column(
                children: [
                  separacion(responsive, 3),
                  cuadroDialogo(responsive),
                  separacion(responsive, 3),
                  inputTextNuevaContrasena(responsive),
                  focusNuevaContrasena.hasFocus ? validacionesContrasena(responsive):Container(),
                  separacion(responsive, 3),
                  inputTextConfirmarContrasena(responsive),
                  //focusConfirmarContrasena.hasFocus ? validacionesContrasena(responsive):Container(),
                  focusNuevaContrasena.hasFocus == true || focusConfirmarContrasena.hasFocus ? Container():separacion(responsive, 25),
                  validarCodigo(responsive)
                ],
              ),
            )
        )
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          LoadingController()
        ],
      );
      l.add(modal);
    }
    return l;
  }

  Widget cuadroDialogo(Responsive responsive){
    return Container(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2), horizontal: responsive.wp(4)),
      color: Tema.Colors.rellenodialogo,
      child: Text("Tu nueva contraseña debe ser diferente a las 3 contraseñas anteriores.", style: TextStyle(
          color: Tema.Colors.Azul_2,
          fontWeight: FontWeight.normal,
          fontSize: responsive.ip(2)
      ),),
    );
  }

  Widget inputTextNuevaContrasena(Responsive responsive){
    return TextFormField(
      autofocus: true,
      maxLength: 24,
      autocorrect: true,
      inputFormatters: [LengthLimitingTextInputFormatter(24)],
      controller: controllerNuevaContrasena,
      focusNode: focusNuevaContrasena,
      obscureText: nuevaContrasena,
      cursorColor: Tema.Colors.GNP,
      onFieldSubmitted: (S){FocusScope.of(context).requestFocus(focusConfirmarContrasena);
      focusNuevaContrasena.nextFocus();
      focusNuevaContrasena.unfocus();},
      decoration: new InputDecoration(

          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Nueva contraseña",
          labelStyle: TextStyle(
              color: focusNuevaContrasena.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),

          ),
          suffixIcon: IconButton(
            icon: !nuevaContrasena ? Image.asset("assets/login/vercontrasena.png")  : Image.asset("assets/login/novercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                nuevaContrasena = !nuevaContrasena;
              });
            },
          )

      ),

      validator: (value) {

        if(!lentPass){
          return 'Este campo es requerido';
        }
        if(!hasMayusPass){
          return 'La contraseña no contiene mayusculas';
        }
        if(!hasNumPass){
          return 'La contraseña no contiene numeros';
        }
        if(hasGNPPass){
          return 'La contraseña contiene GNP';
        }
        if(hasConsecutiveIgualesPass){
          return 'La contraseña contiene numeros consecutivos iguales';
        }
        if(hasConsecutivosPass){
          return 'La contraseña contiene numeros consecutivos';
        }
        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          print("value");
          print(value);
          controllerNuevaContrasena.text;
          if(value.length<8){
            lentPass = false;
          } else{
            lentPass = true;
          }
          if(value.contains("A")||value.contains("B")||value.contains("C")||value.contains("D")||value.contains("E")||value.contains("F")||value.contains("G")||value.contains("H")||value.contains("I")||value.contains("J")||value.contains("K")||value.contains("L")||value.contains("M")||value.contains("N")||value.contains("O")||value.contains("P")||value.contains("Q")||value.contains("R")||value.contains("S")||value.contains("T")||value.contains("U")||value.contains("V")||value.contains("W")||value.contains("X")||value.contains("Y")||value.contains("Z")){
            hasMayusPass = true;
          } else {
            hasMayusPass =false;
          }
          if(value.contains("1") || value.contains("2") || value.contains("3") || value.contains("4") || value.contains("5") || value.contains("6") || value.contains("7") || value.contains("8") || value.contains("9") || value.contains("0")){
            hasNumPass = true;
          } else {
            hasNumPass = false;
          }
          if(value.contains("GNP") || value.contains("Gnp") || value.contains("gnp") || value.contains("GNp") || value.contains("gNp") || value.contains("gnP")|| value.contains("GnP") || value.contains("gNP")){
            hasGNPPass = true;
          } else {
            hasGNPPass =false;
          }
          if(value.contains(" ")){
            hasEspacePass = true;
          }else{
            hasEspacePass=false;
          }
          if(reConsecutive.hasMatch(value)){
            hasConsecutiveIgualesPass = true;
          } else {
            hasConsecutiveIgualesPass = false;
          }
          if(reConsecutive2.hasMatch(value)){
            print(reConsecutive2.hasMatch(value));
            hasConsecutivosPass = true;
          } else {
            print(reConsecutive2.hasMatch(value));
            hasConsecutivosPass =false;
          }

        });
      },
    );
  }

  Widget inputTextConfirmarContrasena(Responsive responsive){
    return TextFormField(
      inputFormatters: [
        //FilteringTextInputFormatter.deny(RegExp(r'[/\\ ]')),
        LengthLimitingTextInputFormatter(24),
      ],
      controller: controllerConfirmarContrasena,
      focusNode: focusConfirmarContrasena,
      obscureText: confirmarnuevaContrasena,
      cursorColor: Tema.Colors.GNP,
      decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Confirmar nueva contraseña",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusConfirmarContrasena.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          ),
          suffixIcon: IconButton(
            icon: !confirmarnuevaContrasena ? Image.asset("assets/login/vercontrasena.png")  : Image.asset("assets/login/novercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                confirmarnuevaContrasena = !confirmarnuevaContrasena;
              });
            },
          )
      ),
      validator: (value) {
        if(!lentPass){
          return 'Este campo es requerido';
        }
        if(!hasMayusPass){
          return 'La contraseña no contiene mayusculas';
        }
        if(!hasNumPass){
          return 'La contraseña no contiene numeros';
        }
        if(hasGNPPass){
          return 'La contraseña contiene GNP';
        }
        if(hasConsecutiveIgualesPass){
          return 'La contraseña contiene numeros consecutivos iguales';
        }
        if(hasConsecutivosPass){
          return 'La contraseña contiene numeros consecutivos';
        }

        if (value!= controllerNuevaContrasena.text)
          return 'La contraseña no coincide';

        if (value.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          focusConfirmarContrasena.hasFocus;
          controllerConfirmarContrasena.text;
          controllerNuevaContrasena.text;
        });
      },
    );
  }

  Widget validarCodigo(Responsive responsive){
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          color: controllerNuevaContrasena.text != "" && controllerConfirmarContrasena.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
          margin: EdgeInsets.only(top: responsive.hp(12), bottom: responsive.hp(3)),
          width: responsive.width,
          child: Container(
            margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
            child: Text( "ACTUALIZAR", style: TextStyle(
                color: controllerNuevaContrasena.text != "" && controllerConfirmarContrasena.text != "" ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onPressed: () async {
          if(_formKey.currentState.validate()) {
            setState(() {
              _saving = true;
            });

            ReestablecerContrasenaModel restablecerContrasena = await reestablecerContrasenaServicio(context, idParticipanteValidaPorCorre, controllerNuevaContrasena.text);

            print("restablecerContrasena     ${restablecerContrasena}");

            if(restablecerContrasena != null){
              setState(() {
                _saving = false;
              });
              if(restablecerContrasena.cambioContrasenaResponse != null && restablecerContrasena.cambioContrasenaResponse.retorno == "SUCCEEDED"){

                customAlert(AlertDialogType.contrasena_actualiza_correctamente,context,"","", responsive, funcionAlerta);
              } else {
                customAlert(AlertDialogType.Sesionafinalizada_por_contrasena_debeserdiferente,context,"","", responsive, funcionAlerta);
              }

            } else {
              setState(() {
                _saving = false;
              });

            }
          }else{

          }

        }
    );
  }

  Widget separacion( Responsive responsive, double tamano ){
    return SizedBox(
      height: responsive.hp(tamano),
    );
  }

  Widget validacionesContrasena(Responsive responsive){
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical:responsive.hp(3), horizontal:responsive.wp(2), ),
        child: Column(
          children: <Widget>[
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(lentPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png",color: lentPass ? Colors.green : Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))
                  ),
                  Expanded(child: Text("Debe de ser al menos de 8 caracteres.", style: TextStyle(fontSize: responsive.ip(1.8), color:lentPass?Colors.green:Colors.red,),))
                ],
              ),
            ) : Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("Debe de ser al menos de 8 caracteres.", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(hasMayusPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png" ,color: hasMayusPass ? Colors.green:Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))
                  ),
                  Expanded(child: Text("Debe de contener al menos una mayúscula.", style: TextStyle(fontSize: responsive.ip(1.8), color:hasMayusPass?Colors.green:Colors.red,),))
                ],
              ),
            ): Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("Debe de contener al menos una mayúscula.", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(hasNumPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png" ,
                          color: hasNumPass ? Colors.green:Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))
                  ),
                  Expanded(child: Text("Debe de contener al menos un número.", style: TextStyle(fontSize: responsive.ip(1.8), color:hasNumPass?Colors.green:Colors.red,),))
                ],
              ),
            ): Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("Debe de contener al menos un número.", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(!hasGNPPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png" ,color: !hasGNPPass?Colors.green:Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))
                  ),
                  Expanded(child: Text("No debe de contener GNP.", style: TextStyle(fontSize: responsive.ip(1.8), color:!hasGNPPass?Colors.green:Colors.red,),))
                ],
              ),
            ) : Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("No debe de contener GNP.", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
            //hasConsecutiveIgualesPass
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(!hasConsecutiveIgualesPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png",color: !hasConsecutiveIgualesPass?Colors.green:Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))),
                  Expanded(child: Text("No debe contener más de dos caracteres consecutivos iguales (p.e. 222, eee).", style: TextStyle(fontSize: responsive.ip(1.8), color:!hasConsecutiveIgualesPass?Colors.green:Colors.red,),))
                ],
              ),
            ) : Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("No debe contener más de dos caracteres consecutivos iguales (p.e. 222, eee).", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
            //hasConsecutivosPass
            controllerNuevaContrasena.text != ""  || controllerConfirmarContrasena.text != "" ? Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset(!hasConsecutivosPass ? "assets/login/checkcircle.png": "assets/login/checkfail.png" ,color: !hasConsecutivosPass?Colors.green:Colors.red, width: responsive.wp(2.3), height: responsive.hp(2.3))),
                  Expanded(child: Text("No debe contener más de dos caracteres consecutivos (p.e. 123, abc).", style: TextStyle(fontSize: responsive.ip(1.8), color:!hasConsecutivosPass?Colors.green:Colors.red,),))
                ],
              ),
            ) : Container(
              margin: EdgeInsets.only(bottom: responsive.hp(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: responsive.width * 0.02),
                      child: Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
                  ),
                  Expanded(child: Text("No debe contener más de dos caracteres consecutivos (p.e. 123, abc).", style: TextStyle(fontSize: responsive.ip(1.8), color:Tema.Colors.letragris),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void funcionAlerta(){

  }

}
