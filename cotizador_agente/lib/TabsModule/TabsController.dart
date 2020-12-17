import 'package:cotizador_agente/TabsModule/Entity/Footer.dart';
import 'package:cotizador_agente/TabsModule/Entity/Secciones.dart';
import 'package:cotizador_agente/TabsModule/TabsContract.dart';
import 'package:cotizador_agente/TabsModule/TabsPresenter.dart';
import 'package:cotizador_agente/ThemeGNP/TabButton.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Utils.dart';
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
  String tabselect = "";

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
    return FutureBuilder<Footer>(
        future: presenter.getFooterConfiguration(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container(height: 0);
            case ConnectionState.waiting:
              return Container(height: 0);
            default:
              return remoteFooter(snapshot.data);
          }
        });
  }

  void _selectedTab(String accion) {
    presenter?.navigateToRoute(accion);
  }

  Widget remoteFooter(Footer remoteFooter) {
    this.visibleFooter = true;
    if (isSecondLevel) {
      this.visibleFooter = remoteFooter.visibleEnSegundoNivel;
    }
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Stack(alignment: Alignment.bottomCenter, children: [
      SafeArea(
          child: Visibility(
              visible: this.visibleFooter,
              child: Container(
                  height: 65,
                  child: BottomAppBar(
                    color: Colors.white,
                    elevation: 15,
                    shape: CircularNotchedRectangle(),
                    notchMargin: 8.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildTabs(remoteFooter.secciones),
                    ),
                  )))),
      Container(
        color: Colors.white,
        height: bottomPadding,
        alignment: Alignment.bottomCenter,
      )
    ]);
  }

  List<Widget> buildTabs(List<Secciones> tabs) {
    tabs.sort((a, b) => a.posicion.compareTo(b.posicion));
    tabs.insert(2, null);
    List<Widget> newTabs = [];
    for (var i = 0; i < tabs.length; i++) {
      var currentTab = tabs[i];
      if (currentTab == null) {
        //newTabs.add(Container(width: 60, color: Colors.transparent));
      } else {
        var color = currentTab.titulo!=tabselect ? AppColors.color_appBar : AppColors.secondary900;
        var placeHolder = (currentTab.localIcon != null)
            ? Image.asset(currentTab.localIcon,
            width: 24, height: 24, color: color)
            : Icon(Icons.broken_image, color: color);
        newTabs.add(TabButton(
            title: currentTab.titulo,
            icono: currentTab.icono,
            color: color,
            placeHolder: placeHolder,
            onPressed: () {
              if(currentTab.titulo!=tabselect){
                setState(() {
                  tabselect = currentTab.titulo;
                });
              }
              if(currentTab.titulo=="Cotizar"){
                setState(() {
                  Utilidades.tabCotizarSelect = true;
                });
              }
              if (currentTab.habilitado) {
                _selectedTab(currentTab.accion);
              } else {
                presenter?.showAlertNoHabilitado(currentTab.titulo);
              }
            }));
      }
    }
    return newTabs;
  }
}