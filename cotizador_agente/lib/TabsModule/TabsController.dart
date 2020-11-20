import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsPresenter.dart';
import 'package:flutter/material.dart';

class TabsController extends StatefulWidget {
  TabsController({Key key, this.isSecondLevel}) : super(key: key);
  final bool isSecondLevel;

  @override
  TabsControllerState createState() => TabsControllerState(this.isSecondLevel);
}

class TabsControllerState extends State<TabsController> implements TabsView {
  TabsPresenter presenter;
  bool isSecondLevel;
  bool visibleFooter;

  TabsControllerState(bool isSecondLevel) {
    this.isSecondLevel = isSecondLevel;
    this.presenter = TabsPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TabsHelper.statusChanged(this.visibleFooter);
    });*/
  }

  @override
  Widget build(BuildContext context) {

  }
}