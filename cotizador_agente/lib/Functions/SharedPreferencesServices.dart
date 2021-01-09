import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {

  Future<Map> getPreferences(String name) async {
    final SharedPreferences _preferencesInstance = await SharedPreferences.getInstance();
    Map data;
    try {
      data= json.decode(_preferencesInstance.getString(name));
    } catch (e) {
      print("$e");
    }
    print("===Preferences Read==="
        "\nName: $name"
        "\nData: $data");
    return data;
  }

  Future<void> writeData(String name , Map data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeData = json.encode(data);
    print("===Preferences Write==="
        "\nName: $name"
        "\nData: $data");
    prefs.setString(name, encodeData);
  }

  Future<void> deleteData(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("===Preferences Delete==="
        "\nName: $name");
    prefs.remove(name);
  }

}