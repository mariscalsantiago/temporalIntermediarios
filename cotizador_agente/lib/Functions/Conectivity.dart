import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
bool isInternet;
bool hasInternetFirebase = true;

void internetStatus()  async {


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
    debuggable??print("Connectivity Type: ${connectivityStatus.type}""\nAvailable: ${connectivityStatus.available}""\n=> Connectivity <=");
    return connectivityStatus;
  }

  Future<bool> detectConnection() async {
    try {
      var res = await http.get("https://www.google.com");
      var code = res.statusCode;
      if (code != null) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      //SIN CONEXION
      return false;
    } catch (ex) {
      return false;
    }
  }

  Future<ConnectivityStatus> isInternet() async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    ConnectionType type;
    bool  available;

    if (connectivityResult == ConnectivityResult.mobile) {
      type=ConnectionType.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      type=ConnectionType.wifi;
    } else {
      type=ConnectionType.none;
    }
    available = await detectConnection();
    ConnectivityStatus connectivityStatus= new ConnectivityStatus(type: type ,available: available);
    print("Connectivity Type: ${connectivityStatus.type}""\nAvailable: ${connectivityStatus.available}""\n=> Connectivity <=");

    return connectivityStatus;
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


