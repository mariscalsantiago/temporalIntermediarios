# **CONFIGURACIÓN DE FIREBASE**

Solicitamos el apoyo para la creación de la consola de firebase:
**GNP-AccidentesPersonales-PRO** del desarrollo de **Intermediario GNP**

Nombre de proyecto Firebase:
GNP-AccidentesPersonales-PRO

1. **REGISTRO DE APPS (ANDROID / IOS)**

- Desde la consola de firebase, en **Información general** seleccionar **Configuración del proyecto**

![](cotizador_agente/doc/imagenes/1.png)

- En la pestaña de **General**, ir al apartado de **Tus app** para agregar al proyecto las apps.

![](cotizador_agente/doc/imagenes/2.png)

![](cotizador_agente/doc/imagenes/3.png)

- Dar clic en el botón Agrega una app, y selecciona la plataforma; para este caso serán Android o iOS:

![](cotizador_agente/doc/imagenes/4.png)

- Al seleccionar la plataforma, solicitará el nombre del paquete, que son los siguientes.


Nombre del paquete de **Android**:  **mx.com.gnp.soysociognp**

![](cotizador_agente/doc/imagenes/5.png)

![](cotizador_agente/doc/imagenes/6.png)

![](cotizador_agente/doc/imagenes/7.png)

![](cotizador_agente/doc/imagenes/8.png)

![](cotizador_agente/doc/imagenes/9.png)

![](cotizador_agente/doc/imagenes/10.png)


ID del paquete de  **iOS**: **mx.com.gnp.soysociognpapp**

![](cotizador_agente/doc/imagenes/11.png)

![](cotizador_agente/doc/imagenes/12.png)

![](cotizador_agente/doc/imagenes/13.png)

![](cotizador_agente/doc/imagenes/14.png)

![](cotizador_agente/doc/imagenes/15.png)


Una vez registradas las apps Android/iOS, se deberán habilitar lo siguiente:

2. Habilitar Google Analytics

- Abrir consola Firebase e ir **Información general**
- Seleccionar la opción **Configuración del proyecto**
- Elegir la pestaña de **Integraciones**, para poder ver la tarjeta de **Google Analytics**
- Dar clic en **Vincular**.

![](cotizador_agente/doc/imagenes/16.png)

Una vez habilitado Analytics, seguir los siguientes pasos:

3. Crashlytics y Performance (ANDROID / IOS)

- Desde la consola de firebase, ir a la sección de Lanzamiento y
monitorización; seleccionar la opción de Crashlytics y Performance, a la
derecha de la ventana se mostrará la opción selecciona con las app
registradas para poder habilitarla desde el botón Habilitar Crashlytics
o Agregar SDK.

![](cotizador_agente/doc/imagenes/17.png)

![](cotizador_agente/doc/imagenes/18.png)


[https://firebase.google.com/docs/perf-mon/get-started-android](https://firebase.google.com/docs/perf-mon/get-started-android)

4. Almacenamiento de imágenes

- Abrir consola Firebase e ir a la sección Storage
- Crear una carpeta con el nombre **remote_config_icons**
- Dentro de la carpeta **remote_config_icons**, crear una nueva con el nombre **footer** Agregar las imágenes que se encuentran en el archivo zip, en la carpeta footer:


        cotizar.png  
        menu.png  
        emitir.png  
        pagar.png  
        renovar.png

- Dentro de la carpeta **remote_config_icons** crear una carpeta con el nombre **splash** e integrar las imágenes:

        imagen.png  
        imagen_pie.png

![](cotizador_agente/doc/imagenes/19.png)



# **Compilación APP Intermediario GNP**

**Instalación de Flutter**

Descargar Flutter 1.22.0 de  
[https://flutter.dev/docs/development/tools/sdk/releases?tab=macos](https://flutter.dev/docs/development/tools/sdk/releases?tab=macos) (para Mac)  
[https://flutter.dev/docs/development/tools/sdk/releases?tab=windows](https://flutter.dev/docs/development/tools/sdk/releases?tab=windows) (para Windows)

Compilación del proyecto [](url)

VERIFICAR QUE EL ARCHIVO main.dart QUE SE ENCUENTRA DENTRO DE LA CARPETA lib ESTE APUNTANDO AL AMBIENTE CORRECTO  
lib/main.dart
1. Validar que dentro de la variable configuredApp este apuntando al ambiente: Ambient.pro

![](cotizador_agente/doc/imagenes/mainpro.png)

2. Verificar que los archivos de pro se encuentren en la carpeta
   correcta.

![](cotizador_agente/doc/imagenes/google-services.png)

![](cotizador_agente/doc/imagenes/GoogleService-Info.png)

3. Validar que los archivos Google-Services.plist y google-services.json
   se encuentren apuntando al proyecto de producción.

# PASOS A SEGUIR PARA GENERAR APK

1.  Abrir Android Studio, abrir el proyecto.
2.  Desde la terminal de Android Studio ejecutar el comando para el ambiente:
    -  flutter build apk --release -t lib/EnvironmentVariablesSetup/main_PRO.dart --flavor pro
3. Al finalizar la ejecución del comando, en la terminal el mensaje de que termino y nos da la ruta de donde esta el archivo generado:
    ✓ Built build/app/outputs/flutter-apk/


# PASOS A SEGUIR PARA GENERAR IPA PARA iOS (solo Mac)

VALIDAR QUE SE TENGA INSTALADO XCODE VERSIÓN 11.4 A 11.7

Ejecutar los siguientes comandos:
- flutter clean
- flutter pub cache repair
- flutter pub get
- cd ios/ pod install

** Verificar que el Podfile tenga las siguientes características:**

![](cotizador_agente/doc/imagenes/podfile.png)


 VALIDAR QUE AL ABRIR EL PROYECTO EN LOS ESQUEMAS SE ENCUENTRE APUNTANDO AL ESQUEMA CORRECTO: **pro**

1.  En la herramienta Xcode, abrir **Runner.xcworkspace** que se encuentra en la carpeta iOS de tu aplicación.

2. Selecciona Product > Scheme > pro.

![](cotizador_agente/doc/imagenes/scheme.png)

3.  Seleccionar **Product > Destination > Generic iOS Device**

![](cotizador_agente/doc/imagenes/destination.png)

4.  Seleccionar **Runner** en el navegador de proyectos de **Xcode**, seleccionar el target **Runner** en la barra lateral de la vista de configuración.

5.  Seleccionar **Product > Archive** para generar un archivo compilado.

![](cotizador_agente/doc/imagenes/archive.png)

6.  En la barra lateral de la ventana de **Xcode Organizer**, seleccionar la aplicación **iOS**, luego seleccionar el archivo compilado que se acaba de generar.

7.  Seleccionar el botón **Distribuir App > Development**.

8.  En la ventana de opciones de distribución de desarrollo **seleccionar > All compatible device variants**.

9.  Seleccionar la opción que se requiere para firmar la app **(Automatically manage signing)**.

10.  Finalmente, seleccionar la carpeta en donde se almacenará el IPA generado.

