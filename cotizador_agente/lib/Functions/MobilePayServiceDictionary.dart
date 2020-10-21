String getErrorDescription(String errorCode){
  String errorDescription="";
  switch(errorCode){
    case "-1":
      errorDescription="Transacción aprobada";
      break;
    case "0":
      errorDescription="Exitoso, en proceso";
      break;
    case "1":
      errorDescription="Llame a su banco: No se permite la transacción (importe mayor a lo permitido, transacción con fallback, afiliación no registrada en el Banco)";
      break;
    case "2":
      errorDescription="Llame Ref.: La tarjeta está en estatus de \"Referenciada\" en el banco emisor";
      break;
    case "3":
      errorDescription="Negocio inválido: Verificar la Afiliación con el Ejecutivo de su banco";
      break;
    case "4":
      errorDescription="Retener Tarjeta: No es posible la autorización";
      break;
    case "5":
      errorDescription="Rechazar Tarjeta: Verificar que se este ingresando correctamente el código de seguridad y/o el Banco emisor no acepta la transacción";
      break;
    case "6":
      errorDescription="Error-Llame: No es posible la autorización";
      break;
    case "12":
      errorDescription="Transacción inválida: No es posible la autorización";
      break;
    case "13":
      errorDescription="Monto inválido: Monto inválido";
      break;
    case "14":
      errorDescription="Tarjeta inválida: No es posible la autorización";
      break;
    case "15":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "30":
      errorDescription="Error de Formato: Los datos obtenidos de la tarjeta no son correctos, Error en la lectura de datos.";
      break;
    case "31":
      errorDescription="Banco inválido: No es posible la autorización";
      break;
    case "33":
      errorDescription="Recoger Tarjeta Venc: Tarjeta Vencida";
      break;
    case "34":
      errorDescription="Recoger Tarjeta Venc: Tarjeta Vencida";
      break;
    case "35":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      break;
    case "36":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      break;
    case "37":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      break;
    case "41":
      errorDescription="Tarjeta Perdida: Tarjeta Perdida / Solicitar otra tarjeta";
      break;
    case "43":
      errorDescription="Tarjeta Perdida: Tarjeta Perdida / Solicitar otra tarjeta";
      break;
    case "51":
      errorDescription="Fondos Insuficientes: Fondos Insuficientes";
      break;
    case "52":
      errorDescription="Sin Cta.de Cheques: Solicitar otra tarjeta";
      break;
    case "53":
      errorDescription="Sin Cta.de Ahorros: Solicitar otra tarjeta";
      break;
    case "54":
      errorDescription="Tarjeta Vencida: Tarjeta Vencida";
      break;
    case "55":
      errorDescription="PIN Incorrecto: La información del PIN es incorrecta";
      break;
    case "56":
      errorDescription="Tarjeta sin registro: Tarjeta sin Registro";
      break;
    case "57":
      errorDescription="transacción inválida / Plan Plazo Erroneo: Verificar con el ejecutivo de Banamex que la afiliación este calificada para transaccionar a meses.";
      break;
    case "58":
      errorDescription="transacción no permitida por terminal: La transacción se está realizando con fallback y el banco la rechaza.";
      break;
    case "59":
      errorDescription="Trans.sospechosa: Solicitar otra tarjeta";
      break;
    case "61":
      errorDescription="Excede Límite Diario: No es posible la autorización";
      break;
    case "62":
      errorDescription="Tarjeta restringida: No es posible la autorización";
      break;
    case "65":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "70":
      errorDescription="Error descifrando track2: Verificar el firmware del pinpad sea el correspondiente y/o trama del mensaje";
      break;
    case "71":
      errorDescription="Debe inicializar llaves: La caja debe inicializar llaves del pinpad";
      break;
    case "72":
      errorDescription="Problema Inicializando Llaves: La petición de inicializando de llave fue rechazado por Eglobal. Verificar Firmware o trama";
      break;
    case "75":
      errorDescription="Intentos de PIN excedidos: No es posible la autorización";
      break;
    case "81":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "82":
      errorDescription="Rechazar Tarjeta: Verificar que se este ingresando codigo de seguridad. El Banco emisor no acepta la transacción.";
      break;
    case "83":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "84":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "87":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "88":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      break;
    case "90":
      errorDescription="Corte en Proceso: El Banco emisor está en proceso de corte, llamar a Subtech.";
      break;
    case "91":
      errorDescription="Emisor no disponible: El autorizador del Banco Emisor no está disponible para la autorización de Trns.";
      break;
    case "92":
      errorDescription="Llame al emisor: No es posible la autorización";
      break;
    case "94":
      errorDescription="Trans.Duplicada: No es posible la autorización";
      break;
    case "96":
      errorDescription="Login Incorrecto: El user id o password es incorrecto para realizar una transacción";
      break;
    case "110":
      errorDescription="Term.no pertenece a Com.: Existe error en la configuración de la terminal, llamar a Subtech";
      break;
    case "111":
      errorDescription="Term/Com. no Habilitado: No está habilitada el comercio o terminal por error en la mensajería o petición de baja";
      break;
    case "120":
      errorDescription="Terminal Inexistente: No existe terminal. Configuración errónea. Llame  a subtech";
      break;
    case "121":
      errorDescription="Terminal no Habilitada: No está habilitada el comercio o terminal por error en la mensajería o peticion de baja";
      break;
    case "122":
      errorDescription="Terminal inválida: Error en la configuración de la terminal. Llame a Subtech";
      break;
    case "130":
      errorDescription="Comercio Inexistente: No existe configuración de Comercio Interno. Llame a Subtech";
      break;
    case "131":
      errorDescription="Comercio no Habilitado: No está habilitada el comercio o terminal por error en la mensajería o peticion de baja";
      break;
    case "140":
      errorDescription="Prefijo Inexistente: No existe el número de Bin de la tarjeta, Verificar el tipo de tarjeta";
      break;
    case "141":
      errorDescription="Producto no configurado: Producto no configurado en la Interred o error en la mensajería. Llamar a Subtech";
      break;
    case "142":
      errorDescription="Tarjeta fuera de rango: Verificar tarjeta, 16 digitos. Llamar a Subtech.";
      break;
    case "143":
      errorDescription="Dígito verificador inválido: Dígito verificador inválido de la tarjeta.";
      break;
    case "146":
      errorDescription="Tarjeta no encontrada: Numero de bin no encontrado en la Interred. Llame a Subtech";
      break;
    case "147":
      errorDescription="Tarjeta Vencida: Tarjeta Vencida";
      break;
    case "148":
      errorDescription="Vencimiento inválido: Tarjeta Vencida";
      break;
    case "150":
      errorDescription="Transacción inválida: Transacción no permitida, verificar afiliación y modalidades de operación, venta normal y meses sin intereses, llame a Subtech.";
      break;
    case "151":
      errorDescription="Transacción no habilitada: No existe configuración para el tipo de transacción.  Llame a Subtech";
      break;
    case "155":
      errorDescription="Intente Nuevamente: Intentar la trn nuevamente, llame a Subtech ";
      break;
    case "156":
      errorDescription="Producto no Acepta Cuotas: Se está realizando una trn con tarjeta de Débito a meses sin intereses";
      break;
    case "161":
      errorDescription="No se encuentra lote: Error en la configuración de la terminal. Llame a Subtech";
      break;
    case "170":
      errorDescription="Trn.original no existe: La trn no existe o el número de seguimiento es incorrecto";
      break;
    case "171":
      errorDescription="La Trn. ya fue Anulada: La transacción ya fue cancelada";
      break;
    case "172":
      errorDescription="La Trn. fue Reversada: No se puede cancelar una trn de venta que ya fue reversada";
      break;
    case "173":
      errorDescription="La Trn. fue Cerrada: No se puede cancelar una trn de venta que ya fue procesada en el cierre automático";
      break;
    case "177":
      errorDescription="Cierre de lote en curso: Llamar a Subtech";
      break;
    case "183":
      errorDescription="Servidor sin comunicación: El banco emisor no responde, respuesta tardía, Incidencias en el Host del Banco emisor, llame a Subtech";
      break;
    case "200":
      errorDescription="Inoperative unable to authorice: El Banco emisor no está disponible para autorizar";
      break;
    case "208":
      errorDescription="Overfloor limit: Sobrepasa el Límite";
      break;
    case "410":
      errorDescription="Terminal-Comercio no Habilitado: Error en la configuración de la terminal. Llame a Subtech";
      break;
    case "420":
      errorDescription="Terminal no Habilitada: Llamar a Subtech";
      break;
    case "430":
      errorDescription="Comercio no Habilitado: Llamar a Subtech";
      break;
    case "441":
      errorDescription="Producto no Habilitado: Producto no configurado en la Interred o error en la mensajería. Llamar a Subtech";
      break;
    case "453":
      errorDescription="Sesión Expirada: Sesión expirada, verificar que se ingrese con el usuario sólo en una estación de trabajo.";
      break;
    case "456":
      errorDescription="Error en EZ: Error en la mensajería de la transacción. Llamar  a Subtech";
      break;
    case "501":
      errorDescription="Q1 - Invalid expiration date: Fecha de vencimiento errónea";
      break;
    case "802":
      errorDescription="T2 - Format error: Error de formato";
      break;
    case "803":
      errorDescription="T3 - No card record: No es posible la autorización";
      break;
    case "805":
      errorDescription="T5 - Caf status inact. or closed: No es posible la autorización";
      break;
    case "500":
      errorDescription="Ocurrió un error, favor de contactar a su figura de servicio.";
      break;
    case "700":
      errorDescription="El recibo no se encuentra en un estatus válido";
      break;
    default:
      errorCode != null ? errorDescription="Se produjo un error al intentar procesar el pago. Inténtalo más tarde ($errorCode)":
      errorDescription="Se produjo un error al intentar procesar el pago. Inténtalo más tarde";
      break;
  }
 return errorDescription;
}

String getErrorDescriptionGenerico(String errorCode){
  String errorDescription="";
  String errorDescriptionGenerico="";
  String mensaje1="Tarjeta Aprobada";
  String mensaje2="Intente nuevamente/servicio no disponible";
  String mensaje3="Tarjeta Invalida";
  String mensaje4="Tarjeta Rechazada";
  String mensaje5="Contacte al emisor de la tarjeta";

  switch(errorCode){
    case "-1":
      errorDescription="Transacción aprobada";
      errorDescriptionGenerico=mensaje1;
      break;
    case "0":
      errorDescription="Exitoso, en proceso";
      errorDescriptionGenerico=mensaje1;
      break;
    case "1":
      errorDescription="Llame a su banco: No se permite la transacción (importe mayor a lo permitido, transacción con fallback, afiliación no registrada en el Banco)";
      errorDescriptionGenerico=mensaje5;
      break;
    case "2":
      errorDescription="Llame Ref.: La tarjeta está en estatus de \"Referenciada\" en el banco emisor";
      errorDescriptionGenerico=mensaje5;
      break;
    case "3":
      errorDescription="Negocio inválido: Verificar la Afiliación con el Ejecutivo de su banco";
      errorDescriptionGenerico=mensaje2;
      break;
    case "4":
      errorDescription="Retener Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "5":
      errorDescription="Rechazar Tarjeta: Verificar que se este ingresando correctamente el código de seguridad y/o el Banco emisor no acepta la transacción";
      errorDescriptionGenerico=mensaje4;
      break;
    case "6":
      errorDescription="Error-Llame: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "12":
      errorDescription="Transacción inválida: No es posible la autorización";
      errorDescriptionGenerico=mensaje2;
      break;
    case "13":
      errorDescription="Monto inválido: Monto inválido";
      errorDescriptionGenerico=mensaje4;
      break;
    case "14":
      errorDescription="Tarjeta inválida: No es posible la autorización";
      errorDescriptionGenerico=mensaje3;
      break;
    case "15":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "30":
      errorDescription="Error de Formato: Los datos obtenidos de la tarjeta no son correctos, Error en la lectura de datos.";
      errorDescriptionGenerico=mensaje3;
      break;
    case "31":
      errorDescription="Banco inválido: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "33":
      errorDescription="Recoger Tarjeta Venc: Tarjeta Vencida";
      errorDescriptionGenerico=mensaje5;
      break;
    case "34":
      errorDescription="Recoger Tarjeta Venc: Tarjeta Vencida";
      errorDescriptionGenerico=mensaje5;
      break;
    case "35":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "36":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "37":
      errorDescription="Recoger Tarjeta: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "41":
      errorDescription="Tarjeta Perdida: Tarjeta Perdida / Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;

      break;
    case "43":
      errorDescription="Tarjeta Perdida: Tarjeta Perdida / Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "51":
      errorDescription="Fondos Insuficientes: Fondos Insuficientes";
      errorDescriptionGenerico=mensaje5;
      break;
    case "52":
      errorDescription="Sin Cta.de Cheques: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "53":
      errorDescription="Sin Cta.de Ahorros: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "54":
      errorDescription="Tarjeta Vencida: Tarjeta Vencida";
      errorDescriptionGenerico=mensaje3;
      break;
    case "55":
      errorDescription="PIN Incorrecto: La información del PIN es incorrecta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "56":
      errorDescription="Tarjeta sin registro: Tarjeta sin Registro";
      errorDescriptionGenerico=mensaje5;
      break;
    case "57":
      errorDescription="transacción inválida / Plan Plazo Erroneo: Verificar con el ejecutivo de Banamex que la afiliación este calificada para transaccionar a meses.";
      errorDescriptionGenerico=mensaje4;
      break;
    case "58":
      errorDescription="transacción no permitida por terminal: La transacción se está realizando con fallback y el banco la rechaza.";
      errorDescriptionGenerico=mensaje5;
      break;
    case "59":
      errorDescription="Trans.sospechosa: Solicitar otra tarjeta";
      errorDescriptionGenerico=mensaje5;
      break;
    case "61":
      errorDescription="Excede Límite Diario: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "62":
      errorDescription="Tarjeta restringida: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "65":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "70":
      errorDescription="Error descifrando track2: Verificar el firmware del pinpad sea el correspondiente y/o trama del mensaje";
      errorDescriptionGenerico=mensaje5;
      break;
    case "71":
      errorDescription="Debe inicializar llaves: La caja debe inicializar llaves del pinpad";
      errorDescriptionGenerico=mensaje5;
      break;
    case "72":
      errorDescription="Problema Inicializando Llaves: La petición de inicializando de llave fue rechazado por Eglobal. Verificar Firmware o trama";
      errorDescriptionGenerico=mensaje5;
      break;
    case "75":
      errorDescription="Intentos de PIN excedidos: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "81":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "82":
      errorDescription="Rechazar Tarjeta: Verificar que se este ingresando codigo de seguridad. El Banco emisor no acepta la transacción.";
      errorDescriptionGenerico=mensaje4;
      break;
    case "83":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "84":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "87":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "88":
      errorDescription="Rechazar Tarjeta: No es posible la autorización";
      errorDescriptionGenerico=mensaje4;
      break;
    case "90":
      errorDescription="Corte en Proceso: El Banco emisor está en proceso de corte, llamar a Subtech.";
      errorDescriptionGenerico=mensaje2;
      break;
    case "91":
      errorDescription="Emisor no disponible: El autorizador del Banco Emisor no está disponible para la autorización de Trns.";
      errorDescriptionGenerico=mensaje2;
      break;
    case "92":
      errorDescription="Llame al emisor: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "94":
      errorDescription="Trans.Duplicada: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "96":
      errorDescription="Login Incorrecto: El user id o password es incorrecto para realizar una transacción";
      errorDescriptionGenerico=mensaje3;
      break;
    case "110":
      errorDescription="Term.no pertenece a Com.: Existe error en la configuración de la terminal, llamar a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "111":
      errorDescription="Term/Com. no Habilitado: No está habilitada el comercio o terminal por error en la mensajería o petición de baja";
      errorDescriptionGenerico=mensaje5;
      break;
    case "120":
      errorDescription="Terminal Inexistente: No existe terminal. Configuración errónea. Llame  a subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "121":
      errorDescription="Terminal no Habilitada: No está habilitada el comercio o terminal por error en la mensajería o peticion de baja";
      errorDescriptionGenerico=mensaje5;
      break;
    case "122":
      errorDescription="Terminal inválida: Error en la configuración de la terminal. Llame a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "130":
      errorDescription="Comercio Inexistente: No existe configuración de Comercio Interno. Llame a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "131":
      errorDescription="Comercio no Habilitado: No está habilitada el comercio o terminal por error en la mensajería o peticion de baja";
      errorDescriptionGenerico=mensaje5;
      break;
    case "140":
      errorDescription="Prefijo Inexistente: No existe el número de Bin de la tarjeta, Verificar el tipo de tarjeta";
      errorDescriptionGenerico=mensaje4;
      break;
    case "141":
      errorDescription="Producto no configurado: Producto no configurado en la Interred o error en la mensajería. Llamar a Subtech";
      errorDescriptionGenerico=mensaje3;
      break;
    case "142":
      errorDescription="Tarjeta fuera de rango: Verificar tarjeta, 16 digitos. Llamar a Subtech.";
      errorDescriptionGenerico=mensaje4;
      break;
    case "143":
      errorDescription="Dígito verificador inválido: Dígito verificador inválido de la tarjeta.";
      errorDescriptionGenerico=mensaje3;
      break;
    case "146":
      errorDescription="Tarjeta no encontrada: Numero de bin no encontrado en la Interred. Llame a Subtech";
      errorDescriptionGenerico=mensaje3;
      break;
    case "147":
      errorDescription="Tarjeta Vencida: Tarjeta Vencida";
      errorDescriptionGenerico=mensaje3;
      break;
    case "148":
      errorDescription="Vencimiento inválido: Tarjeta Vencida";
      errorDescriptionGenerico=mensaje3;
      break;
    case "150":
      errorDescription="Transacción inválida: Transacción no permitida, verificar afiliación y modalidades de operación, venta normal y meses sin intereses, llame a Subtech.";
      errorDescriptionGenerico=mensaje4;
      break;
    case "151":
      errorDescription="Transacción no habilitada: No existe configuración para el tipo de transacción.  Llame a Subtech";
      errorDescriptionGenerico=mensaje4;
      break;
    case "155":
      errorDescription="Intente Nuevamente: Intentar la trn nuevamente, llame a Subtech ";
      errorDescriptionGenerico=mensaje3;
      break;
    case "156":
      errorDescription="Producto no Acepta Cuotas: Se está realizando una trn con tarjeta de Débito a meses sin intereses";
      errorDescriptionGenerico=mensaje4;
      break;
    case "161":
      errorDescription="No se encuentra lote: Error en la configuración de la terminal. Llame a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "170":
      errorDescription="Trn.original no existe: La trn no existe o el número de seguimiento es incorrecto";
      errorDescriptionGenerico=mensaje2;
      break;
    case "171":
      errorDescription="La Trn. ya fue Anulada: La transacción ya fue cancelada";
      errorDescriptionGenerico=mensaje2;
      break;
    case "172":
      errorDescription="La Trn. fue Reversada: No se puede cancelar una trn de venta que ya fue reversada";
      errorDescriptionGenerico=mensaje5;
      break;
    case "173":
      errorDescription="La Trn. fue Cerrada: No se puede cancelar una trn de venta que ya fue procesada en el cierre automático";
      errorDescriptionGenerico=mensaje2;
      break;
    case "177":
      errorDescription="Cierre de lote en curso: Llamar a Subtech";
      errorDescriptionGenerico=mensaje2;
      break;
    case "183":
      errorDescription="Servidor sin comunicación: El banco emisor no responde, respuesta tardía, Incidencias en el Host del Banco emisor, llame a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "200":
      errorDescription="Inoperative unable to authorice: El Banco emisor no está disponible para autorizar";
      errorDescriptionGenerico=mensaje2;
      break;
    case "208":
      errorDescription="Overfloor limit: Sobrepasa el Límite";
      errorDescriptionGenerico=mensaje5;
      break;
    case "410":
      errorDescription="Terminal-Comercio no Habilitado: Error en la configuración de la terminal. Llame a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "420":
      errorDescription="Terminal no Habilitada: Llamar a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "430":
      errorDescription="Comercio no Habilitado: Llamar a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "441":
      errorDescription="Producto no Habilitado: Producto no configurado en la Interred o error en la mensajería. Llamar a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "453":
      errorDescription="Sesión Expirada: Sesión expirada, verificar que se ingrese con el usuario sólo en una estación de trabajo.";
      errorDescriptionGenerico=mensaje4;
      break;
    case "456":
      errorDescription="Error en EZ: Error en la mensajería de la transacción. Llamar  a Subtech";
      errorDescriptionGenerico=mensaje5;
      break;
    case "501":
      errorDescription="Q1 - Invalid expiration date: Fecha de vencimiento errónea";
      errorDescriptionGenerico=mensaje3;
      break;
    case "802":
      errorDescription="T2 - Format error: Error de formato";
      errorDescriptionGenerico=mensaje3;
      break;
    case "803":
      errorDescription="T3 - No card record: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "805":
      errorDescription="T5 - Caf status inact. or closed: No es posible la autorización";
      errorDescriptionGenerico=mensaje5;
      break;
    case "500":
      errorDescription="Ocurrió un error, favor de contactar a su figura de servicio.";
      errorDescriptionGenerico="Ocurrió un error, favor de contactar a su figura de servicio.";
      break;
    case "700":
      errorDescription="El recibo no se encuentra en un estatus válido";
      errorDescriptionGenerico="El recibo no se encuentra en un estatus válido";
      break;
    default:
      errorCode != null ? errorDescription="Se produjo un error al intentar procesar el pago. Inténtalo más tarde ($errorCode)":
      errorDescription="Se produjo un error al intentar procesar el pago. Inténtalo más tarde";
      errorDescriptionGenerico="Se produjo un error al intentar procesar el pago. Inténtalo más tarde";
      break;
  }
  return errorDescriptionGenerico;
}