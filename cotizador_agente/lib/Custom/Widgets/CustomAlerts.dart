import 'package:flutter/material.dart';
import 'package:cotizador_agente/Custom/Styles/Theme.dart' as Theme;
import 'package:cotizador_agente/Custom/Styles/Strings.dart' as Strings;
import 'package:flutter/material.dart' as prefix0;

var isShowAlert = false;

enum AlertDialogType {
  sinAcceso,
  loading,
  loadingActualiza,
  inactividad,
  infoBiometrico,
  eMailNoExiste,
  contrasenaIncorrecta,
  errorConexion,
  cancelOperacionGeneric,
  backEdicion,
  backEdicionConDatos,
  campoRequerido,
  guardarExito,
  guardarFallo,
  errorEnLaBase,
  errorUsuario,
  errorBuscarPorCliente,
  errorCampoVacio,
  errorCerrarDialog,
  errorFotografia,
  exitoFotografia,
  datosInsuficientes,
  errorNoResultados,
  salirBonos,
  errorBonos,
  sinBonos,
  salirEstadoCuenta,
  excepcionBonosLogin,
  errorSendEmail,
  correctSendEmail,
  errorSendEmailEmpty,
  cambioCuaBonosSalir,
  mensajeGenericoDataIncomplete,
  mensajeGenericoOk,
  mensajeGenericoError,
  mensajeEditPerfilBack,
  CarteraError,
  CarteraErrorGeneric,
  CarteraCorrecto,
  sinResultados,
}

void customAlert(
    AlertDialogType type, BuildContext context, String title, String message) {
  switch (type) {
    case AlertDialogType.errorBonos:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("$title",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("$message",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.mensajeGenericoOk:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("$title",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("$message",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  }),
            ],
          ));
      break;
    case AlertDialogType.mensajeGenericoError:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("$title",
                style: TextStyle(
                    color: Theme.Colors.gnpBlue,
                    fontSize: 18.0,
                    fontFamily: "Roboto")),
            content: new Text("$message",
                style: TextStyle(
                    color: Theme.Colors.gnpBlue,
                    fontSize: 14.0,
                    fontFamily: "Roboto", )),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.mensajeEditPerfilBack:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: new Text(
                Strings.StringsMX.editDatosPerfilTituloAlertBack,
                style: Theme.TextStyles.DarkRegular14px),
            actions: <Widget>[
              FlatButton(
                child: Text("Regresar",
                    style: Theme.TextStyles.DarkGrayMedium14px),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(
                        color: Theme.Colors.DarkGray, width: 1.4),
                    borderRadius: BorderRadius.circular(3.0)
                ),
              ),
              FlatButton(
                color: Theme.Colors.Orange,
                child: Text("Sí, salir",
                    style: Theme.TextStyles.WhiteMedium14px0ls),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
            ],
          ));
      break;
    case AlertDialogType.mensajeGenericoDataIncomplete:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: new Text(
                Strings.StringsMX.editDatosPerfilTituloAlertDataIncomplete,
                style: Theme.TextStyles.DarkRegular14px),
            actions: <Widget>[
              FlatButton(
                color: Theme.Colors.Orange,
                child: Text("Ok",
                    style: Theme.TextStyles.WhiteMedium14px0ls),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
            ],
          ));
      break;
    case AlertDialogType.cambioCuaBonosSalir:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Bonos",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "¿Si deseas cambiar de cua, deberas ingresar contraseña?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.sinBonos:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Bonos",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "El intermediario no cuenta con información para mostrar en el periodo",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.salirBonos:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Salir",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("¿Deseas salir de bonos?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.salirEstadoCuenta:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Salir",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("¿Deseas salir de detalle de ingresos?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.errorSendEmailEmpty:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Sin formatos adjuntos",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "No se seleccionó ningun formato de esta sección para enviar por correo"
                    "\n$message",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;

    case AlertDialogType.excepcionBonosLogin:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("$title",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("$message",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;

    case AlertDialogType.errorSendEmail:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Error",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "No se pudo enviar el correo, intentalo más tarde"
                    "\n$message",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.correctSendEmail:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Correo enviado",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("El correo fue enviado correctamente",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;

    case AlertDialogType.sinAcceso:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Sin acceso a la App de GNP Agentes",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Lo sentimos, verifica el acceso con tu Gerente",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.loading:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: new Text("Cargando",
                  style: TextStyle(
                      color: Theme.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new CircularProgressIndicator(),
                    ],
                  ))));
      break;
    case AlertDialogType.loadingActualiza:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: new Text("Actualizando Datos...",
                  style: TextStyle(
                      color: Theme.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new CircularProgressIndicator(),
                    ],
                  ))));
      break;
    case AlertDialogType.inactividad:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Cierre de sesión.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Su sesión ha expirado por "
                    "inactividad.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 12.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                  child: Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
      break;
    case AlertDialogType.infoBiometrico:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("¡Bienvenido! ",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Es tu primer visita, inicia sesión con tu correo electrónico y contraseña del Portal de Intermediarios. Posteriormente podrás utilizar tus datos biométricos.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.eMailNoExiste:
      break;
    case AlertDialogType.contrasenaIncorrecta:
      showDialog(
        context: context,
        builder: (BuildContext context) {
// return object of type Dialog
          return AlertDialog(
            title: new Text("",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Parece que la contraseña proporcionada es incorrecta. Verifica e intenta nuevamente.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorConexion:
      if (!isShowAlert) {
        isShowAlert = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error de conexión.",
                  style: TextStyle(
                      color: Theme.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              content: new Text(
                  "Se produjo un error en la red, verifica tu conexión e intenta nuevamente.",
                  style: TextStyle(
                      color: Theme.Colors.Blue,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("ACEPTAR",
                      style: TextStyle(
                          color: Theme.Colors.Orange,
                          fontSize: 16.0,
                          fontFamily: "Roboto")),
                  onPressed: () {
                    isShowAlert = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {}
      break;
    case AlertDialogType.backEdicion:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Información sin cambios",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("¿Deseas salir sin guardar los cambios?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));
      break;
    case AlertDialogType.cancelOperacionGeneric:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Cancelar Operación",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "¿Estas seguro que deseas salir de la operación?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));
      break;
    case AlertDialogType.backEdicionConDatos:
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text("Modificaste información",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("¿Deseas salir sin guardar los cambios?",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));
      break;
    case AlertDialogType.campoRequerido:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Campos obligatorios.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Todos los campos son obligatorios, favor de verificar.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.guardarExito:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Datos actualizados.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "¡Gracias! Tus datos fueron actualizados exitosamente.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.guardarFallo:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error de conexión",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "¡Algo pasó al guardar tus datos! Por favor inténtalo más tarde.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorEnLaBase:
      break;
    case AlertDialogType.errorUsuario:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Lo sentimos.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("Usuario no encontrado o inválido.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorBuscarPorCliente:
      break;
    case AlertDialogType.errorCampoVacio:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title,
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(message,
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR",
                    style: TextStyle(
                        color: Theme.Colors.Orange,
                        fontSize: 16.0,
                        fontFamily: "Roboto")),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorCerrarDialog:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title,
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(message,
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;

    case AlertDialogType.exitoFotografia:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Edición de fotografía",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "¡Gracias! Tus datos fueron actualizados exitosamente.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorFotografia:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Edición de fotografía",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Ocurrió un error al guardar tu fotografía. Inténtalo más tarde.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.datosInsuficientes:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Datos insuficientes.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text(
                "Debes escribir al menos 4 caracteres para realizar la búsqueda.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.errorNoResultados:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("No hay resultados.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            content: new Text("No hay resultados para esta búsqueda.",
                style: TextStyle(
                    color: Theme.Colors.Blue,
                    fontSize: 16.0,
                    fontFamily: "Roboto")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR")

                ,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
      break;
    case AlertDialogType.CarteraError:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("Lo sentimos",
              textAlign: TextAlign.center,
              style: TextStyle(
                    color: Theme.Colors.black_0_8,
                    fontSize: 18.0,
                )),
            content: new Text(" El servicio no se encuentra disponible.\n Por favor intenta más tarde. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.Colors.black_0_8,
                    fontSize: 14.0,
                    )),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
                color: Theme.Colors.Orange,
                textColor: Colors.white,
                  child: Text('Aceptar',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                    ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),

            ],
          ));
      break;

    case AlertDialogType.CarteraError:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("Lo sentimos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 18.0,
                )),
            content: new Text(" El servicio no se encuentra disponible.\n Por favor intenta más tarde. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 14.0,
                )),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
                color: Theme.Colors.Orange,
                textColor: Colors.white,
                child: Text('Aceptar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),

            ],
          ));
      break;

    case AlertDialogType.CarteraErrorGeneric:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("$title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 18.0,
                )),
            content: new Text("$message",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 14.0,
                )),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
                color: Theme.Colors.Orange,
                textColor: Colors.white,
                child: Text('Aceptar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),

            ],
          ));
      break;
    case AlertDialogType.CarteraCorrecto:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("Solicitud enviada",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.Colors.black_0_8
                ,
                  fontSize: 18.0,
                )),
            content: new Text("Tu solicitud está siendo procesada, en un lapso máximo de 2 días hábiles recibirás un correo con la respuesta.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 14.0,

                )
            ),
            actions: <Widget>[


              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
                color: Theme.Colors.Orange,
                textColor: Colors.white,
                child: Text('Aceptar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          ));
      break;
    case AlertDialogType.sinResultados:
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("No se encontraron resultados",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.Colors.black_0_8
                ,
                  fontSize: 18.0,
                )),
            content: new Text("Verifica que los datos ingresados estén correctos y vuelve a realizar tu búsqueda.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Theme.Colors.black_0_8,
                  fontSize: 14.0,

                )
            ),
            actions: <Widget>[
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
                color: Theme.Colors.Orange,
                textColor: Colors.white,
                child: Text('Entendido',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: new BorderSide(width: 0.4, color:Theme.Colors.Orange ),
                    borderRadius: BorderRadius.circular(3.0)),
              ),
              new FlatButton(
                child: new Text(""),
                onPressed: () {
                },
              ),
            ],
          ));
      break;
    default:

      break;
  }
}