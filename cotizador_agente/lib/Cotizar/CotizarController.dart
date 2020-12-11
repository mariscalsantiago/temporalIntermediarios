
import 'package:cotizador_agente/Cotizar/CotizarContract.dart';
import 'package:cotizador_agente/Cotizar/CotizarPresenter.dart';
import 'package:cotizador_agente/utils/AppColors.dart';
import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CotizarController extends StatefulWidget {
  CotizarController({Key key}) : super(key: key);


  @override
  CotizarControllerState createState() => CotizarControllerState();
}

class CotizarControllerState extends State<CotizarController> implements CotizarView{

  CotizarPresenter presenter;

  CotizarControllerState() {
    this.presenter = CotizarPresenter(this);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: getAppBar(context),
          backgroundColor: Colors.white,
          body: getBody(),
        ));
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      centerTitle: true,
      title: Image.asset("assets/icon/splash/logoGNP.png",
          height: 40, width: 105.7, fit: BoxFit.contain),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.orange, size: 30.0),
      leading: IconButton(
        icon: Icon(Icons.chevron_left, color: AppColors.secondary900, size: 28,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget getBody() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Card(
            elevation: 0,
            margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: ListTile(
              onTap: () {
                presenter.showSegurosMasivos();
                setState(() {
                  Utilidades.tabCotizarSelect = true;
                });
              },
              contentPadding: EdgeInsets.all(8),
              leading: Image.asset('assets/default_cotizador.png', ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('GMM Individual',
                    style: TextStyle(
                        fontFamily: 'OpenSansRegular',
                        fontSize: 16,
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15)),
              ),
              trailing: Icon(Icons.chevron_right, size: 35, color: AppColors.secondary900,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 0, left: 88),
            child: Divider(
              thickness: 1,
              color: AppColors.divider,
            ),
          ),
        ],
      ),
    );
  }
}