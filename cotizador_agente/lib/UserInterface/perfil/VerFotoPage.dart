import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cotizador_agente/Custom/CustomAlert.dart';
import 'package:cotizador_agente/Custom/Validate.dart';
import 'package:cotizador_agente/Functions/Inactivity.dart';
import 'package:cotizador_agente/Functions/Interactios.dart';
import 'package:cotizador_agente/Services/LoginServices.dart';
import 'package:cotizador_agente/UserInterface/login/Splash/Splash.dart';
import 'package:cotizador_agente/UserInterface/perfil/editarImagenPage.dart';
import 'package:cotizador_agente/modelos/LoginModels.dart';
import 'package:cotizador_agente/utils/LoaderModule/LoadingController.dart';
import 'package:cotizador_agente/utils/responsive.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Tema;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:cotizador_agente/Custom/skeleton_container.dart';

import '../../main.dart';

bool banderaTrans = false;

class VerFotoPage extends StatefulWidget {

  Function callback;
  Responsive responsive;
  VerFotoPage({Key key,this.responsive, this.callback}) : super(key: key);

  @override
  _VerFotoPageState createState() => _VerFotoPageState();
}


class _VerFotoPageState extends State<VerFotoPage> {
  double width = 300.0;
  double height = 150.0;
  bool _saving = false;
  bool _loading = false;
  Timer timerLoading;
  File imagePefil;
  bool _imagePefilSaving = false;

  Responsive _responsiveMainTablet;
  bool isPortrait = false;
  final PermissionHandler _permissionHandler = PermissionHandler();


  @override
  void initState() {
    validateIntenetstatus(context, widget.responsive, functionConnectivity, false);

    //updateFoto();
   // obtenerImagen();
    skeletonLoad();
    super.initState();
  }

  functionInactivity(){
    print("functionInactivity");
    Inactivity(context:context).initialInactivity(functionInactivity);
  }
  void functionConnectivity() {
    setState(() {});
  }


  @override
  dispose() {
    super.dispose();
  }


  Future<void>  skeletonLoad() async {
    setState(() {
      _loading = true;
    });
      timerLoading = Timer.periodic(Duration(seconds: 2), (timer) {
        cancelTimerLoading();
      });

  }

  void cancelTimerLoading(){
    if(timerLoading!=null&&timerLoading.isActive){
      timerLoading.cancel();
    }
    imagePefil = datosFisicos.personales.photoFile;
    setState(() {
      _loading = false;
    });
  }


  Future<void>  skeletonLoadDelete() async {
    setState(() {
      _loading = true;
    });
    bool resp = await fetchFotoDelete(context);
    if(resp != null && resp) {
      imagePefil = null;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return  GestureDetector(onTap: (){
      Inactivity(context:context).initialInactivity(functionInactivity);
    },
    child: SafeArea(
        bottom: false,
        child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            "Mi perfil",
            style: TextStyle(color: Tema.Colors.Azul_2),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Tema.Colors.GNP),
            onPressed: () {
              Inactivity(context:context).cancelInactivity();
              Navigator.pop(context,true);
              if(_imagePefilSaving)
                widget.callback(imagePefil);
            },
          ),
        ),
        body:  OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            _responsiveMainTablet = Responsive.of(context);
            isPortrait = true;
          } else {
            _responsiveMainTablet = Responsive.of(context);
            isPortrait = false;
          }
          return Container(
            color: Tema.Colors.White,
            child: Stack(
                children: builData(responsive)
            ),
          );})
        )));
  }

  List<Widget> builData(Responsive responsive){
    Widget data = Container();
    data = Column(
      children: [
        _loading ? new Container(
          margin: prefs.getBool("useMobileLayout") ? EdgeInsets.only(top: responsive.hp(15.5), left: responsive.wp(4), right: responsive.wp(4), bottom: responsive.hp(5)) :  isPortrait
              ? EdgeInsets.only(top: responsive.hp(15.5), left: responsive.wp(15), right: responsive.wp(15), bottom: responsive.hp(5)) : EdgeInsets.only(top: responsive.hp(15.5), left: responsive.wp(30), right: responsive.wp(30), bottom: responsive.hp(5)) ,
          child: new Skeleton(
            animationDuration: Duration(milliseconds: 500),
            textColor: Tema.Colors.gris_load1,
              height: responsive.hp(45),
              width: responsive.width,
              style: SkeletonStyle.box,
          ),
        )
        :
       new Container(
            margin:EdgeInsets.only(top: responsive.hp(13.5), left: responsive.wp(4), right: responsive.wp(4)),
            height: responsive.hp(52),
            width: responsive.width,
            child: imagePefil != null && imagePefil!= "" ?
              Image.file(imagePefil, fit: BoxFit.cover,): Container(
              margin: prefs.getBool("useMobileLayout") ? EdgeInsets.only(left: responsive.wp(1), right: responsive.wp(2), top: responsive.hp(10), bottom: responsive.hp(10)) : isPortrait ? EdgeInsets.only( left: responsive.wp(25), right: responsive.wp(25), top: responsive.hp(9), bottom: responsive.hp(9)) : EdgeInsets.only(left: responsive.wp(32), right: responsive.wp(32), top: responsive.hp(5), bottom: responsive.hp(5)),
              child: new Image.asset('assets/images/nopic.png',  height: responsive.hp(1), width: responsive.wp(1),),
            ),
          ),
        Container(
          margin:EdgeInsets.only(top: responsive.hp(9.4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: (){
                    _imagePefilSaving = true;
                    if(imagePefil != null ){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleCropRoute(responsive: widget.responsive,image: imagePefil, callback: editFoto,)),).then((value){
                        Inactivity(context:context).initialInactivity(functionInactivity);
                      });
                    }
                  },
                  child: Icon(Icons.create_outlined, color: imagePefil!=null?Tema.Colors.GNP:Tema.Colors.Light2,)),
              GestureDetector(
                  onTap: (){
                    _imagePefilSaving = true;
                    _showPicker(context);
                  },
                  child: Icon(Icons.camera_alt_outlined, color: Tema.Colors.GNP,)),
              GestureDetector(
                  onTap: () async{
                    _imagePefilSaving = true;
                    if(imagePefil!=null) {
                        skeletonLoadDelete();
                    }
                  },
                  child: Icon(Icons.delete_outlined, color: imagePefil!=null?Tema.Colors.GNP:Tema.Colors.Light2,)),
            ],
          ),
        )
      ],
    );

    var l = new List<Widget>();
    l.add(data);
    if (_saving) {
      var modal = Stack(
        children: [
          LoadingController(
          )
        ],
      );
      l.add(modal);
    }
    return l;
  }

  void _showPicker(context) {
    Responsive responsive = Responsive.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            bottom: false,
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(
                        'Galería',
                        style: TextStyle(fontSize: responsive.ip(1.5)),
                      ),
                      onTap: () {
                        _imgFromGallery(responsive);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.camera_alt_outlined),
                    title: new Text('Cámara',
                      style: TextStyle(fontSize: responsive.ip(1.5)),
                    ),
                    onTap: () {
                      _imgFromCamera(responsive);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera(Responsive responsive) async {
    File _image;
    final picker = ImagePicker();
    //TODO revisar doble intento y validacion de null
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //fetchFoto(context, _image, widget.callback);
        if (_image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SimpleCropRoute(
                      image: _image,
                      callback: editFoto,
                    )),
          ).then((value){
            Inactivity(context:context).initialInactivity(functionInactivity);
          });
        }
      }
      } catch (e) {
      print("_imgFromCamera_verFoto");
      customAlert(AlertDialogType.errorPermisosGeneric, context, "", "",
          responsive, (){});
      print(e);
   }
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var permissionStatus = await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestContactsPermission() async {
    return _requestPermission(PermissionGroup.photos);
  }

  _imgFromGallery(Responsive responsive) async {
      try {
        var release = "0";
        File _image;
        if(Platform.isIOS){
          var iosDataInfo = await DeviceInfoPlugin().iosInfo;
          release = iosDataInfo.systemVersion;
        }

          print("release: $release");

        if(Platform.isAndroid||(Platform.isIOS && !release.contains("14"))) {
          final picker = ImagePicker();
          final pickedFile = await picker.getImage(source: ImageSource.gallery);
          _image = File(pickedFile.path);
        }else {
         // if(await requestContactsPermission()) {
            final FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
            final platformFile = result.files.first;
            _image = File(platformFile.path);
          //}
        }

        //fetchFoto(context, _image, widget.callback);
        if (_image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SimpleCropRoute(
                      image: _image,
                      callback: editFoto,
                    )),
          ).then((value){
            Inactivity(context:context).initialInactivity(functionInactivity);

          });
        }
      } catch (e) {
        print("catch _imgFromGallery_verFoto");
        print("catch $e");
        customAlert(AlertDialogType.errorPermisosGeneric, context, "", "",
            responsive, (){});
      }


  }
  void imageSimilar(){
    skeletonLoad();
  }
  Future<void> editFoto(File sendFile) async {

    setState(() {
      _loading = true;
    });

    timerLoading = Timer.periodic(Duration(seconds: 2), (timer) {
      cancelTimerLoadingEdit(sendFile);
    });


  }

  void cancelTimerLoadingEdit(File image){
    if(timerLoading!=null&&timerLoading.isActive){
      timerLoading.cancel();
    }
    imagePefil = image;
    setState(() {
      _loading = false;
    });
  }
  void CallbackInactividad(){
    setState(() {
      focusContrasenaInactividad.hasFocus;
      showInactividad;
      //contrasenaInactividad = !contrasenaInactividad;
    });
  }

}
