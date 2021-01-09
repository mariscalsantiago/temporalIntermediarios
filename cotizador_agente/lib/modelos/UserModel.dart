class UserModel {

  final String idParticipant;
  final String firstOpenDate;
  final String lastSession;
  final String name;
  final String email;
  final String emailApp;
  final String cua;
  final String da;
  final String plaza;
  final String bornDate;
  final String cedDate;
  final String mobilePhone;
  final String phone;
  final DeviceModel device;

  const UserModel({
    this.idParticipant,
    this.firstOpenDate,
    this.lastSession,
    this.name,
    this.email,
    this.emailApp,
    this.cua,
    this.da,
    this.plaza,
    this.bornDate,
    this.cedDate,
    this.mobilePhone,
    this.phone,
    this.device,
  });


  Map<String, dynamic> toJson() => {
    'idParticipant': idParticipant,
    'firstOpenDate': firstOpenDate,
    'lastSession': lastSession,
    'name': name,
    'email': email,
    'emailApp': emailApp,
    'cua': cua,
    'da': da,
    'plaza': plaza,
    'bornDate': bornDate,
    'cedDate': cedDate,
    'mobilePhone': mobilePhone,
    'mobilePhone': phone,
    'device': device.toJson(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idParticipant: json['correo'],
      firstOpenDate: json['firstOpenDate'],
      lastSession: json['lastSession'],
      name: json['name'],
      email: json['email'],
      emailApp: json['emailApp'],
      cua: json['cua'],
      da: json['da'],
      plaza: json['plaza'],
      bornDate: json['bornDate'],
      cedDate: json['cedDate'],
      mobilePhone: json['mobilePhone'],
      phone: json['phone'],
      device: DeviceModel.fromJson(json['device']),
    );
  }

}

class DeviceModel {
  //final String deviceId;
  final String deviceToken;
  final String os;

  const DeviceModel({
    //this.deviceId,
    this.deviceToken,
    this.os,
  });


  Map<String, dynamic> toJson() => {
    //'deviceId': deviceId,
    'deviceToken': deviceToken,
    'os': os,
  };

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      //deviceId: json['deviceId'],
      deviceToken: json['deviceToken'],
      os: json['os'],
    );
  }

}

