import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;


Future<bool> internetStatus() async {
  bool isInternet;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isInternet = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isInternet = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      isInternet = false;
    }
  return isInternet;
}

class ConnectivityServices{

  Future <ConnectivityStatus> getConnectivityStatus([bool debuggable]) async {
    debuggable??print("== Connectivity ==");
    bool  available;
    ConnectionType type;
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      type=ConnectionType.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      type=ConnectionType.wifi;
    } else if (connectivityResult == ConnectivityResult.none) {
      type=ConnectionType.none;
    }
    available = await detectConnection();
    ConnectivityStatus connectivityStatus= new ConnectivityStatus(type: type ,available: available);
    debuggable??print("Connectivity Type: ${connectivityStatus.type}"
        "\nAvailable: ${connectivityStatus.available}"
        "\n=> Connectivity <=");
    return connectivityStatus;
  }

  Future<bool> detectConnection() async {
    bool _connectionAvailable=false;
    try{
      final _result = await http.get("https://www.google.com").catchError((_error){
        print("Error detectConnection: $_error");
      }).timeout(Duration(seconds: 2));
      if(_result!=null){
        _connectionAvailable=true;
      }
    }catch(e){}
    return _connectionAvailable;
  }
}

class ConnectivityStatus {
  final bool available;
  final ConnectionType type;

  ConnectivityStatus({this.available, this.type});

  Map<String, dynamic> toMap() {
    return {
      'available': available,
      'type': type,
    };
  }

  static ConnectivityStatus fromMap(Map<String, dynamic> map) {
    return ConnectivityStatus(
      available: map['available'],
      type: map['type'],
    );
  }
}

enum ConnectionType{
  mobile,
  wifi,
  none,
}

