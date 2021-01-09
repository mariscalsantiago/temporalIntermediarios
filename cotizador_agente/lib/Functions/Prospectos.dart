import 'package:cotizador_agente/modelos/ProspectosModelos.dart';

class Prospectos {

  //SharedPreferences models = await SharedPreferences.getInstance();
  //Future<SharedPreferences> _sprefs;

  saveProspectos(List<ProspectosModelos> cartRestaurantModel) {
    print("saveProspectos");

    //_sprefs = SharedPreferences.getInstance();
   // models =
   print(cartRestaurantModel.elementAt(0));
    print(cartRestaurantModel.elementAt(0).correo);
   // String valor = json.decode(cartRestaurantModel.toString());
print("saveProspectos");
   //
    // String json = JSON.encode(user);
   // models.setString("data", valor);



  }

}
