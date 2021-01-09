import 'dart:convert';

class MaskedUser {
  String name;
  String uid;

  MaskedUser({this.name, this.uid});

  MaskedUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    if (name == null && uid == null) throw json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uid'] = this.uid;
    return data;
  }

  String toString() {
    return JsonEncoder().convert(this);
  }
}
