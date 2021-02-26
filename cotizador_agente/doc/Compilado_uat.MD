**Compilación APP Intermediario GNP**

Instalación de Flutter

Descargar Flutter 1.22.0 de
https://flutter.dev/docs/development/tools/sdk/releases?tab=macos (para Mac)
https://flutter.dev/docs/development/tools/sdk/releases?tab=windows (para Windows)

Compilación del proyecto [](url)

# PASOS A SEGUIR PARA GENERAR APK

1.  Abrir Android Studio, abrir el proyecto.
2.  Desde la terminal de Android Studio ejecutar el comando para el ambiente:
    -  flutter build apk --debug --flavor uat --target lib/EnvironmentVariablesSetup/main_UAT.dart
3. Al finalizar la ejecución del comando, en la terminal el mensaje de que termino y nos da la ruta de donde esta el archivo generado:
 ✓ Built build/app/outputs/flutter-apk/


# PASOS A SEGUIR PARA GENERAR IPA PARA iOS (solo Mac)

#Ejecutar los siguientes comandos:
flutter clean
flutter pub cache repair
flutter pub get
cd ios/ pod install

# Verificar que el Podfile tenga las siguientes características:


# Uncomment this line to define a global platform for your project
# platform :ios, '11.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
 # use_frameworks!
 # use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end

#Verificar que el archivo main.dart que se encuentra en la carpeta de lib, esté apuntando al ambiente correspondiente.

1.  En la herramienta Xcode, abrir **Runner.xcworkspace** que se encuentra en la carpeta iOs de tu aplicación.
    
2.  Seleccionar **Product > Destination > Generic iOS Device**
    
3.  Seleccionar **Runner** en el navegador de proyectos de **Xcode**, seleccionar el target **Runner** en la barra lateral de la vista de configuración.
    
4.  Seleccionar **Product > Archive** para generar un archivo compilado.
    
5.  En la barra lateral de la ventana de **Xcode Organizer**, seleccionar la aplicación **iOS**, luego seleccionar el archivo compilado que se acaba de generar.
    
6.  Seleccionar el botón **Distribuir App > Development**.
    
7.  En la ventana de opciones de distribución de desarrollo **seleccionar > All compatible device variants**.
    
8.  Seleccionar la opción que se requiere para firmar la app **(Automatically manage signing)**.
    
9.  Finalmente, seleccionar la carpeta en donde se almacenará el IPA generado.

