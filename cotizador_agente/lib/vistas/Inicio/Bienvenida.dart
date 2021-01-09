import 'dart:convert';
import 'package:cotizador_agente/Functions/Conectivity.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;

WelcomeObject welcomeObject;
bool loading;
String lastUpdate;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() => Future.value(false),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body:
          loading== true ?
          Center(child: CircularProgressIndicator(),):
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Image.asset(
                    'assets/img/logotype.png',
                    width: 220,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      child:Text(welcomeObject.title,
                        textAlign: TextAlign.center,
                        style: Theme.TextStyles.DarkMedium18px,
                      ),
                    )
                ),
                /*Expanded(
                    flex: 5,
                    child: FutureBuilder(
                      future: pathTemporalBucket(context,welcomeObject.bucketName, welcomeObject.pathFile ),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if(snapshot.hasData){
                          return CachedNetworkImage(
                              placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                              fadeInDuration: Duration(milliseconds: 10),
                              imageUrl: snapshot.data
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                ),*/
                Expanded(
                    flex: 4,
                    child: Container(
                      width: 248,
                      alignment: Alignment.center,
                      child: Text(welcomeObject.description,
                        textAlign: TextAlign.center,
                        style: Theme.TextStyles.DarkGrayRegular14px,
                      ),
                    )
                ),
                Container(
                  width: 232.0,
                  height: 48.0,
                  color: Theme.Colors.DarkGray,
                  child:
                  MaterialButton(
                    color: Theme.Colors.Orange,
                    height: 48.0 ,
                    child: Text(
                      welcomeObject.btnTxt,
                      textAlign: TextAlign.center,
                      style: Theme.TextStyles.WhiteMedium14px0ls,
                    ),
                    onPressed: () {
                      _writeData();
                      Navigator.pushNamed(context, '/login', );
                    },
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Container(),
                ),
              ]
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loading =true;
    _getPreferences();
    super.initState();
  }

  Future _getPreferences() async {
    print("== Getting Preferences ==");
    print("welcomeData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Map dataPrefs = json.decode(prefs.getString('welcomeData'));
      lastUpdate = dataPrefs["lastUptate"];
      print("Success getting welcomeData");
    }catch(e) {
      lastUpdate = "2019-01-01";
      print("Error welcome prefs: $e");
    }
    print("=> Getting Preferences <=");

    ConnectivityStatus _connectivityStatus = await ConnectivityServices().getConnectivityStatus();
    if(_connectivityStatus.available){
      /*try{
        Map dataFireBase;
        DatabaseReference db = FirebaseDatabase.instance.reference().child("Contenidos/Bienvenida");
        db.once().then((DataSnapshot snapshot) {
          dataFireBase = snapshot.value;
          DateTime lastUpdateDate;
          String verifyData = !dataFireBase.containsKey("lastUpdate")?"2000-00-00":dataFireBase["lastUpdate"].toString();
          lastUpdateDate = DateTime.parse(verifyData);
          DateTime lastUpdateSaved =DateTime.parse(lastUpdate);
          Duration difference = lastUpdateSaved.difference(lastUpdateDate);
          if(difference.isNegative){
            lastUpdate=dataFireBase["lastUpdate"];
            welcomeObject=new WelcomeObject(
              btnTxt: dataFireBase["btnTxt"],
              bucketName: dataFireBase["bucketName"],
              pathFile: dataFireBase["filePath"],
              title: dataFireBase["title"],
              iconPath: dataFireBase["url"],
              description: dataFireBase["description"],
            );
            setState(() {
              loading=false;
            });
          }else{
            Navigator.pushNamed(context, '/login', );
          }
        }, onError: (error) {
          Navigator.pushNamed(context, '/login',);
        });

      }catch(e) {
        Navigator.pushNamed(context, '/login', );
        print("Error welcome prefs: $e");
      }*/
    }
    else{
      Navigator.pushNamed(context, '/login', );
    }
  }

  Future _writeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data =  {"lastUptate": lastUpdate};
    print(data);
    String encodeData = json.encode(data);
    prefs.setString('welcomeData', encodeData);
  }
}

class WelcomeObject {
  String btnTxt;
  String bucketName;
  String pathFile;
  String description;
  String title;
  String iconPath;
  WelcomeObject({this.btnTxt,this.bucketName, this.pathFile, this.description,this.title,this.iconPath});
}