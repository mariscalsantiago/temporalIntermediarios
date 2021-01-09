import 'package:flutter/material.dart';
//import 'package:agentesgnp/UserInterfaces/edit_familiares_perfil_page.dart';
import 'package:cotizador_agente/Perfil/PerfilPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cotizador_agente/Custom//Styles/Theme.dart' as ThemeColors;

List<SwipeCardFamilyItem> listFamiliaresEdit = <SwipeCardFamilyItem>[];


class MySwipePage extends StatefulWidget {
  MySwipePage({Key key, this.parentescos}) : super(key: key);
  final List parentescos;
  @override
  _MySwipePageState createState() => new _MySwipePageState();
}

class _MySwipePageState extends State<MySwipePage> {
  SlidableController slidableController;

  @protected
  void initState() {
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    listFamiliaresEdit = <SwipeCardFamilyItem>[];

    for(int i=0; i<familiares.length; i++){
      listFamiliaresEdit.add(
          SwipeCardFamilyItem(
            idRelacion: i,
            parentesco: widget.parentescos.contains(familiares.elementAt(i).parentesco)?familiares.elementAt(i).parentesco:"Personalizado",
            cveParentesco: widget.parentescos.contains(familiares.elementAt(i).parentesco)?
            compara(familiares.elementAt(i).parentesco)
            :"PE",
            nombres: familiares.elementAt(i).nombres,
            apellidoPaterno: familiares.elementAt(i).apellidoPaterno,
            apellidoMaterno: familiares.elementAt(i).apellidoMaterno,
            nameController: familiares.elementAt(i).nameController,
            nameFocus: familiares.elementAt(i).nameFocus,
            apellidoPatController: familiares.elementAt(i).apellidoPatController,
            apellidoPatFocus: familiares.elementAt(i).apellidoPatFocus,
            apellidoMatController: familiares.elementAt(i).apellidoMatController,
            apellidoMatFocus: familiares.elementAt(i).apellidoMatFocus,
          )
      );
      listFamiliaresEdit.elementAt(i).nameController.text=listFamiliaresEdit.elementAt(i).nombres;
      listFamiliaresEdit.elementAt(i).apellidoPatController.text=listFamiliaresEdit.elementAt(i).apellidoPaterno;
      listFamiliaresEdit.elementAt(i).apellidoMatController.text=listFamiliaresEdit.elementAt(i).apellidoMaterno;

    }
    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new OrientationBuilder(
          builder: (context, orientation) => _buildList(
              context,Axis.vertical),
        ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return new ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection = Axis.horizontal;
        return _getSlidableWithDelegates(context, index, slidableDirection);
        //}
      },
      itemCount: listFamiliaresEdit.length,
    );
  }

  Widget _buildVerticalListItem(BuildContext context, int index) {
    final SwipeCardFamilyItem item = listFamiliaresEdit[index] as SwipeCardFamilyItem;
    return SwipeCardFamilyCard(
      item: item,
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    SwipeCardFamilyItem item = listFamiliaresEdit[index];
    return new Slidable.builder(
      key: new Key(item.hashCode.toString()),
      controller: slidableController,
      direction: direction,
      /*slideToDismissDelegate: new SlideToDismissDrawerDelegate(
        closeOnCanceled: true,
        onWillDismiss: (actionType) {
          if(actionType == SlideActionType.primary){
          }else {
            return showDialog<bool>(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  title: new Text('Eliminar Familiar'),
                  content:
                  new Text('Tu familiar sera elminado del registro'),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    new FlatButton(
                      child: new Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              },
            );
          }
        },
        onDismissed: (actionType) {
          if(actionType == SlideActionType.primary){
          }else{
            setState(() {
              listFamiliaresEdit.removeAt(index);
            });
          }
        },
      ),
      */
    /////delegate: _getDelegate(item.idRelacion),
      actionExtentRatio: 0.25,
      child: _buildVerticalListItem(context, index),
      secondaryActionDelegate: new SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return new IconSlideAction(
              caption: 'Eliminar',
              color: renderingMode == SlidableRenderingMode.slide
                  ? Colors.red.withOpacity(animation.value)
                  : (renderingMode == SlidableRenderingMode.dismiss
                  ? Colors.red
                  : Colors.deepOrange),
              icon: Icons.delete_forever,
              onTap: () async {
                var state = Slidable.of(context);
                state.dismiss();
              },
            );
          }),
    );
  }

  /*
  static SlidableDelegate _getDelegate(int index) {
    switch (index % 4) {
      case 0:
        return new SlidableBehindDelegate();
      case 1:
        return new SlidableStrechDelegate();
      case 2:
        return new SlidableScrollDelegate();
      case 3:
        return new SlidableDrawerDelegate();
      default:
        return null;
    }
  }
*/
}

class SwipeCardFamilyItem {
   SwipeCardFamilyItem({
    this.idRelacion,
    this.cveParentesco,
    this.parentesco,
    this.nombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.color,
    this.nameController,
    this.nameFocus,
    this.apellidoPatFocus,
    this.apellidoPatController,
     this.apellidoMatFocus,
    this.apellidoMatController
  });

   FocusNode nameFocus ;
   TextEditingController nameController;
   FocusNode apellidoPatFocus;
   TextEditingController apellidoPatController;
   FocusNode apellidoMatFocus;
   TextEditingController apellidoMatController;
   int idRelacion;
   String cveParentesco;
   String parentesco;
   String nombres;
   String apellidoPaterno;
   String apellidoMaterno;
   Color color;
   bool get isValid => idRelacion != null && parentesco != null && nombres != null;

  Map toList() {
    Map json = {};
    if(this.parentesco!="Mascota"){
      json["idRelacion"]=this.idRelacion;
      json["cveParentesco"]=this.cveParentesco;
      json["parentesco"]=this.parentesco;
      json["nombre"]=this.nameController.text;
      json["aPaterno"]=this.apellidoPatController.text;
      json["aMaterno"]=this.apellidoMatController.text;
    }
    else{
      json["idRelacion"]=this.idRelacion;
      json["cveParentesco"]=this.cveParentesco;
      json["parentesco"]=this.parentesco;
      json["nombre"]=this.nameController.text;
    }
    return json;
  }


}


class SwipeCardFamilyCard extends StatefulWidget {

  SwipeCardFamilyCard({Key key, @required this.item});
  final SwipeCardFamilyItem item;
  @override
  SwipeCardFamilyCardState createState() => new SwipeCardFamilyCardState();
}

class SwipeCardFamilyCardState extends State<SwipeCardFamilyCard> {
  double height;
  @override
  Widget build(BuildContext context) {
    if(widget.item.parentesco!="Mascota"){
      height=400.0;
    }else{
      height=240.0;
    }
    final ThemeData theme = Theme.of(context);
    //final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return SafeArea(
      top: true,
      bottom: true,
      child: Container(
        margin:
        const EdgeInsets.only(top: 10.0, left: 10, bottom: 0, right: 10),
        height: height,
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.transparent,
            blurRadius: 20.0,
          ),
        ]),
        child: Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black12, width: 0.3),
                borderRadius: BorderRadius.circular(5.0)),
            child:
            Container(
                margin: const EdgeInsets.only(
                    top: 8, left: 40.0, right: 30, bottom: 8),
                child:
                new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Parentesco',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ThemeColors.Colors.gnpBlue,
                                    fontSize: 17.0,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                // color:  Colors.cyan,
                                width: 24,
                                height: 24.0,
                                child: Image.asset(
                                  'images/perfil/familiares/ic_eliminar_swipe@4x.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]),

                      /*Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        width: MediaQuery.of(context).size.width,
                        child: new




                        DropdownButton(
                          isExpanded: true,
                          style: descriptionStyle.copyWith(
                              color: ThemeColors.Colors.gnpOrange),
                          //value: _currentTShirt,
                          value: widget.item.parentesco,
                          items: dropDownMenuFamiliaresItems,
                          onChanged: (String change) {
                            setState(() {
                              widget.item.parentesco =  change;
                              widget.item.cveParentesco = compara(change);
                            });
                          },
                        ),
                      ),*/

                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              'Nombres:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ThemeColors.Colors.gnpBlue,
                                fontSize: 17.0,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 30.0),
                          child: TextFormField(
                            focusNode:widget.item.nameFocus,
//                                      familiares.elementAt(item.index).nameFocus,
                            controller: widget.item.nameController,
//                                  familiares.elementAt(item.index).nameController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14.0,
                              color: ThemeColors.Colors.gnpOrange,
                            ),
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              // labelStyle: new TextStyle(color: const Color(0xFFFFFFFF)),
                              enabledBorder: const UnderlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: Colors.black12, width: 1.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: const BorderSide(
                                    color: Colors.black12, width: 1.0),
                              ),

                              fillColor: ThemeColors.Colors.gnpOrange,
                              //labelText: familiares.elementAt(i).description,
                              //hintText:widget.item.nombres,
//                                        familiares.elementAt(item.index).description,
                              hintStyle: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14.0,
                                  color: ThemeColors.Colors.gnpOrange),
                            ),
                            validator: (value) {},
                          ),
                        ),
                      ),
                      //Validación para ocultar apellido para mascotas
                      widget.item.parentesco!="Mascota"?
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Apellido Paterno:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ThemeColors.Colors.gnpBlue,
                                          fontSize: 17.0,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  focusNode:widget.item.apellidoPatFocus,
      //                                      familiares.elementAt(item.index).nameFocus,
                                  controller: widget.item.apellidoPatController,
      //                                  familiares.elementAt(item.index).nameController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 14.0,
                                    color: ThemeColors.Colors.gnpOrange,
                                  ),
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    // labelStyle: new TextStyle(color: const Color(0xFFFFFFFF)),
                                    enabledBorder: const UnderlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 1.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 1.0),
                                    ),

                                    fillColor: ThemeColors.Colors.gnpOrange,
                                    //labelText: familiares.elementAt(i).description,
                                    //hintText:widget.item.apellidoPaterno,
      //                                        familiares.elementAt(item.index).description,
                                    hintStyle: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14.0,
                                        color: ThemeColors.Colors.gnpOrange),
                                  ),
                                  validator: (value) {},
                                ),
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Apellido Materno:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ThemeColors.Colors.gnpBlue,
                                          fontSize: 17.0,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 30.0),
                                child: TextFormField(
                                  focusNode:widget.item.apellidoMatFocus,
                                  //                                      familiares.elementAt(item.index).nameFocus,
                                  controller: widget.item.apellidoMatController,
                                  //                                  familiares.elementAt(item.index).nameController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 14.0,
                                    color: ThemeColors.Colors.gnpOrange,
                                  ),
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    // labelStyle: new TextStyle(color: const Color(0xFFFFFFFF)),
                                    enabledBorder: const UnderlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 1.0),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 1.0),
                                    ),

                                    fillColor: ThemeColors.Colors.gnpOrange,
                                    //labelText: familiares.elementAt(i).description,
                                   // hintText:widget.item.apellidoMaterno,
                                    //                                        familiares.elementAt(item.index).description,
                                    hintStyle: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14.0,
                                        color: ThemeColors.Colors.gnpOrange),
                                  ),
                                  validator: (value) {},
                                ),
                              ),
                            )
                          ]))
                      :
                      Container(
                          //widget.item.apellidos = "";
                      ),
                    ])
            )
        ),
      ),
    );
  }
}

addWidgetGlo(int i){
  listFamiliaresEdit.add(SwipeCardFamilyItem(
    idRelacion: i,
    apellidoPaterno: "",
    apellidoMaterno: "",
    cveParentesco: "ES",
    parentesco: "Esposa(o)",
    nombres: "",
    nameController: new TextEditingController(),
    apellidoMatController: new TextEditingController(),
    apellidoPatController: new TextEditingController(),
    nameFocus: new FocusNode(),
  ));

}

String compara(String parentesco) {
  switch (parentesco) {
    case "Esposa(o)":
      return "ES";
      break;
    case "Novia(o)":
      return "NO";
      break;
    case "Hija(o)":
      return "HI";
      break;
    case "Mascota":
      return "MA";
      break;
    default:
      return "PE";
      break;
  }
}