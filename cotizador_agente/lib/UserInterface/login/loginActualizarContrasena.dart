import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Services/flujoValidacionLoginServicio.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/flujoLoginModel/cambioContrasenaModel.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:flutter/services.dart';

class LoginActualizarContrasena extends StatefulWidget {
  final Responsive responsive;
  const LoginActualizarContrasena({Key key, this.responsive}) : super(key: key);
  @override                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  _LoginActualizarContrasenaState createState() => _LoginActualizarContrasenaState();
}

class _LoginActualizarContrasenaState extends State<LoginActualizarContrasena> {

  bool machPass=false;
  bool validPass=false;
  bool lentPass = false;
  bool hasMayusPass = false;
  bool hasNumPass = false;
  bool hasGNPPass = true;
  bool hasEspacePass = true;
  bool hasConsecutiveIgualesPass = false;
  bool hasConsecutivosPass = false;
  TextEditingController controllerNuevaContrasena;
  FocusNode focusNuevaContrasena;
  TextEditingController controllerConfirmarContrasena;
  FocusNode focusConfirmarContrasena;
  TextEditingController controllerActualContrasena;
  FocusNode focusActualContrasena;
  //RegExp reConsecutive = RegExp('^(?!.*([A-Za-z0-9])\1{2})(?=.*[az])(?=.*\d)[A-Za-z0-9]+\$');
  RegExp reConsecutive = RegExp('(.)\\1{2}'); // 111 aaa
  RegExp reConsecutive2 = RegExp('(123|234|345|456|567|678|789|987|876|654|543|432|321|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)');// 123 abcd;// 123 abcd
  final _formKey = GlobalKey<FormState>();
  bool _saving;
  bool actualContrasena;
  bool nuevaContrasena;
  bool confirmarnuevaContrasena;

  @override
  void initState() {
    _saving = false;
    actualContrasena = true;
    nuevaContrasena = true;
    confirmarnuevaContrasena = true;
    controllerNuevaContrasena = new TextEditingController();
    controllerConfirmarContrasena = new TextEditingController();
    controllerActualContrasena = new TextEditingController();
    focusActualContrasena = new FocusNode();
    focusNuevaContrasena = new FocusNode();
    focusConfirmarContrasena = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          backgroundColor: Tema.Colors.backgroud,
          appBar: AppBar(
            backgroundColor: Tema.Colors.backgroud,
            elevation: 0,
            title: Text('Actualizar contraseña', style: TextStyle(
                color: Tema.Colors.Azul_2,
                fontWeight: FontWeight.normal,
                fontSize: widget.responsive.ip(2.5)
            ),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                color: Tema.Colors.GNP,),
              onPressed: () {
                if(prefs.getBool("esPerfil") != null && prefs.getBool("esPerfil") && prefs.getBool("actualizarContrasenaPerfil")){
                  Navigator.pop(context,true);
                  Navigator.pop(context,true);
                } else{
                  Navigator.pop(context,true);
                }

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
            margin: EdgeInsets.only(
                left: responsive.wp(6), right: responsive.wp(6)),
            child: form = new Form(
              key: _formKey,
              child: Column(
                children: [
                  separacion(responsive, 3),
                  inputTextActualContrasena(responsive),
                  separacion(responsive, 3),
                  cuadroDialogo(responsive),
                  separacion(responsive, 3),
                  inputTextNuevaContrasena(responsive),
                  focusNuevaContrasena.hasFocus ? validacionesContrasena(responsive):Container(),
                  separacion(responsive, 3),
                  inputTextConfirmarContrasena(responsive),
                  focusNuevaContrasena.hasFocus == true || focusConfirmarContrasena.hasFocus ? Container(): separacion(responsive, 25),
                  enviar(responsive)
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
          LoadingController(

          )
        ],
      );
      l.add(modal);
    }
    return l;
  }

  Widget inputTextActualContrasena(Responsive responsive){
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[/\\ ]')),
        LengthLimitingTextInputFormatter(24),
      ],
      controller: controllerActualContrasena,
      focusNode: focusActualContrasena,
      obscureText: actualContrasena,
      cursorColor: Tema.Colors.GNP,
      onFieldSubmitted: (S){FocusScope.of(context).requestFocus(focusNuevaContrasena);},
      decoration: new InputDecoration(
        focusColor: Tema.Colors.gnpOrange,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Contraseña actual",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusActualContrasena.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
          ),
          suffixIcon: IconButton(
            icon: !actualContrasena ? Image.asset("assets/login/vercontrasena.png")  : Image.asset("assets/login/novercontrasena.png"),
            color: Tema.Colors.VLMX_Navy_40,
            onPressed: (){
              setState(() {
                actualContrasena = !actualContrasena;
              });
            },
          )
      ),
      validator: (value) {

        if (value.isEmpty || value.isEmpty) {
          return 'Este campo es requerido';
        }else if( value.contains(" ")){
          return 'No debe contener espacion en blanco';
        }
        
        return null;
      },
      onChanged: (value){
        setState(() {
          print("value Giiii");
          print(value);
          print("reConsecutive : ");
          print("reConsecutive : " + reConsecutive.hasMatch(value).toString());
          controllerActualContrasena.text;
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
          if(value.contains("GNP") || value.contains("Gnp") || value.contains("gnp") || value.contains("GNp")){
            hasGNPPass = true;
          } else {
            hasGNPPass =false;
          }
          if(value.contains(" ")){
            hasEspacePass = true;
          }else{
            hasEspacePass=false;
          }

          // aaaa 1111

          if(reConsecutive.hasMatch(value) ){
            hasConsecutiveIgualesPass = false;
          } else {
            hasConsecutiveIgualesPass =true;
          }//123 abc
          if(reConsecutive2.hasMatch(value)){
            hasConsecutivosPass = false;
          } else {
            hasConsecutivosPass =true;
          }

          try{
            if(controllerActualContrasena.text.isNotEmpty && controllerActualContrasena.text.length >= 24){
              String tem = controllerActualContrasena.text;
              controllerActualContrasena.text = tem.substring(0,23);
              FocusScope.of(context).requestFocus(focusNuevaContrasena);
            }
          }catch(e){
            print(e);
          }

        });
      },
    );
  }

  Widget inputTextNuevaContrasena(Responsive responsive){
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[/\\ ]')),
        LengthLimitingTextInputFormatter(24),
      ],
      controller: controllerNuevaContrasena,
      focusNode: focusNuevaContrasena,
      cursorColor: Tema.Colors.GNP,
      obscureText: nuevaContrasena,
      onFieldSubmitted: (S){FocusScope.of(context).requestFocus(focusConfirmarContrasena);},
      decoration: new InputDecoration(
        focusColor: Tema.Colors.gnpOrange,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Tema.Colors.inputlinea),
          ),
          labelText: "Nueva contraseña",
          labelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: responsive.ip(2),
              color: focusNuevaContrasena.hasFocus ? Tema.Colors.GNP : Tema.Colors.inputcorreo,
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
          // aaaa 1111
          if(reConsecutive.hasMatch(value) ){
            hasConsecutiveIgualesPass = true;
          } else {
            hasConsecutiveIgualesPass =false;
          }//123 abc
          if(reConsecutive2.hasMatch(value)){
            hasConsecutivosPass = true;
          } else {
            hasConsecutivosPass =false;
          }

          try{
            if(controllerNuevaContrasena.text.isNotEmpty && controllerNuevaContrasena.text.length >= 24){
              String tem = controllerNuevaContrasena.text;
              controllerNuevaContrasena.text = tem.substring(0,23);
              FocusScope.of(context).requestFocus(focusConfirmarContrasena);
            }
          }catch(e){
            print(e);
          }

        });
      },
    );
  }

  Widget inputTextConfirmarContrasena(Responsive responsive){
    return TextFormField(

      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[/\\ ]')),
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
          try{
            if(controllerConfirmarContrasena.text.isNotEmpty && controllerConfirmarContrasena.text.length >= 24){
              String tem = controllerConfirmarContrasena.text;
              controllerConfirmarContrasena.text = tem.substring(0,23);
              focusConfirmarContrasena.unfocus();
            }
          }catch(e){
            print(e);
          }
        });
      },
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
                      child:Image.asset("assets/login/radioContrasena.png", color: Tema.Colors.togglegris, width: 22, height: 22)
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

  Widget enviar(Responsive responsive){
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(9), bottom: responsive.hp(8)),
      child: CupertinoButton(
        color: Colors.amber,
          padding: EdgeInsets.zero,
          child: Container(
            color: controllerActualContrasena.text != "" && controllerNuevaContrasena.text != "" && controllerConfirmarContrasena.text != "" ? Tema.Colors.GNP : Tema.Colors.botonlogin,
            width: responsive.width,
            child: Container(
              margin: EdgeInsets.only(top: responsive.hp(2), bottom: responsive.hp(2)),
              child: Text( "ACTUALIZAR", style: TextStyle(
                  color: controllerActualContrasena.text != "" && controllerNuevaContrasena.text != "" && controllerConfirmarContrasena.text != "" ? Tema.Colors.backgroud : Tema.Colors.botonletra,
                  fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onPressed: () async {
            focusActualContrasena.unfocus();
            focusNuevaContrasena.unfocus();
            focusConfirmarContrasena.unfocus();
            if(_formKey.currentState.validate()){
              setState(() {
                _saving = true;
              });
              cambioContrasenaModel  cambiocontrasena = await cambioContrasenaServicio(context, controllerActualContrasena.text, controllerNuevaContrasena.text, datosUsuario.idparticipante);

              if(cambiocontrasena != null){

                setState(() {
                  _saving = false;
                });
                  if(cambiocontrasena.requestStatus == "FAILED" && cambiocontrasena.error != ""){

                    customAlert(AlertDialogType.Sesionafinalizada_por_contrasena_debeserdiferente,context,"","", responsive, funcionAlerta);
                  } else if(cambiocontrasena.error == ""){
                    prefs.setString("contraenaActualizada", controllerNuevaContrasena.text);
                    customAlert(AlertDialogType.contrasena_actualiza_correctamente,context,"","", responsive, funcionAlerta);
                  }
              } else {

                setState(() {
                  _saving = false;
                });

              }
            }
          }
      ),
    );
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

  void funcionAlerta(){

  }

}
