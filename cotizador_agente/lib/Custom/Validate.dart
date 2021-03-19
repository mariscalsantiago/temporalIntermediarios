String validateNotEmptyToString(dynamic data, String defaultData){
  data=data!=null?data.toString():defaultData;
  return data;
}

bool validateNotEmptyBool(bool variable){
  if(variable==null){
    variable=false;
  }
  return variable;
}

bool validateNotEmptyBoolFromDynamic(dynamic variable){
  if(variable==null){
    variable=false;
  }
  return variable;
}

bool validateNotEmptyBoolWhitDefault(dynamic _data, bool _default ){
  if(_data==null||_data.runtimeType!=bool){
    _data=false;
  }
  return _data;
}

