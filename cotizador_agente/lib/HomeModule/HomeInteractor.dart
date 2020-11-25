import 'package:cotizador_agente/HomeModule/HomeContract.dart';
import 'package:cotizador_agente/HomeModule/HomeController.dart';
import 'package:image_picker/image_picker.dart';

class HomeInteractor implements HomeUseCase {
  HomeInteractorOutput output;
  HomeControllerState view;
  final ImagePicker _picker = ImagePicker();

  HomeInteractor(HomeInteractorOutput output, HomeControllerState view) {
    this.output = output;
    this.view = view;
  }

}