
class UserModel {

  final String idParticipant;
  final String firstOpenDate;
  final String lastSession;
  final String name;
  final String email;
  final String emailApp;
  final String cua;
  final String cuaLider;
  final String da;
  final String plaza;
  final String bornDate;
  final String cedDate;
  final String mobilePhone;
  final String phone;
  final DeviceInformation device;
  int intentos;


   UserModel({
    this.idParticipant,
    this.firstOpenDate,
    this.lastSession,
    this.name,
    this.email,
    this.emailApp,
    this.cua,
    this.cuaLider,
    this.da,
    this.plaza,
    this.bornDate,
    this.cedDate,
    this.mobilePhone,
    this.phone,
    this.device,
    this.intentos,

  });


  Map<String, dynamic> toJson() => {
    'idParticipant': idParticipant,
    'firstOpenDate': firstOpenDate,
    'lastSession': lastSession,
    'name': name,
    'email': email,
    'emailApp': emailApp,
    'cua': cua,
    'cuaLider': cuaLider,
    'da': da,
    'plaza': plaza,
    'bornDate': bornDate,
    'cedDate': cedDate,
    'mobilePhone': mobilePhone,
    'mobilePhone': phone,
    'device': device.toJson(),
    'intentos': intentos,
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
      cuaLider: json['cuaLider'],
      da: json['da'],
      plaza: json['plaza'],
      bornDate: json['bornDate'],
      cedDate: json['cedDate'],
      mobilePhone: json['mobilePhone'],
      phone: json['phone'],
      device: DeviceInformation.fromJson(json['device']),
      intentos: json['intentos'],
    );
  }

}

class DeviceInformation {
  //final String deviceId;
  final String deviceToken;
  final String os;

  const DeviceInformation({
    //this.deviceId,
    this.deviceToken,
    this.os,
  });


  Map<String, dynamic> toJson() => {
    //'deviceId': deviceId,
    'deviceToken': deviceToken,
    'os': os,
  };

  factory DeviceInformation.fromJson(Map<String, dynamic> json) {
    return DeviceInformation(
      //deviceId: json['deviceId'],
      deviceToken: json['deviceToken'],
      os: json['os'],
    );
  }

}