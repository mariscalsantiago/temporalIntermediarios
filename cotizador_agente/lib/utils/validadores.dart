class Validadores {
  String validaRangos (int min, int max, int val) {

    if(val>min && val<max){
      return null;

    }else{
      return "Valor fuera de rango";
    }

  }
}