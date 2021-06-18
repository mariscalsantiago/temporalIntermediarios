# cotizador_agente

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Configuracion en libreria de biometricos de huella digital en iphone que evitará que haga crash la aplicacion.


Linea # 6
    ==== Se reemplaza ====
        #import "LocalAuthPlugin.h"
    ==== POR ====
       #import "FLTLocalAuthPlugin.h"
    =============


Linea # 8
    ==== Se agrega ====
        @interface FLTLocalAuthPlugin ()
        @property(copy, nullable) NSDictionary<NSString *, NSNumber *> *lastCallArgs;
        @property(nullable) FlutterResult lastResult;
        // For unit tests to inject dummy LAContext instances that will be used when a new context would
        // normally be created. Each call to createAuthContext will remove the current first element from
        // the array.
        - (void)setAuthContextOverrides:(NSArray<LAContext *> *)authContexts;
        @end
    =============


Linea # 18
    ==== Se reemplaza ====
    NSDictionary *lastCallArgs;
      FlutterResult lastResult;
    ==== POR ====
      NSMutableArray<LAContext *> *_authContextOverrides;
    =====================


Linea # 42
  ==== Se agrega =======

     - (void)setAuthContextOverrides:(NSArray<LAContext *> *)authContexts {
       _authContextOverrides = [authContexts mutableCopy];
     }

     - (LAContext *)createAuthContext {
       if ([_authContextOverrides count] > 0) {
         LAContext *context = [_authContextOverrides firstObject];
         [_authContextOverrides removeObjectAtIndex:0];
         return context;
       }
       return [[LAContext alloc] init];
     }
  =====================

Linea # 90 y 114
  ==== Se reemplaza =======
    LAContext *context = [[LAContext alloc] init];
  ==== Por =======
    LAContext *context = self.createAuthContext;
  =====================

Linea # 116
    ==== Se reemplaza =======
       lastCallArgs = nil;
       lastResult = nil;
    ==== Por =======
     self.lastCallArgs = nil;
     self.lastResult = nil;
    =====================


Linea # 125
    ==== Se agrega =======
                                dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self handleAuthReplyWithSuccess:success
                                                                              error:error
                                                                   flutterArguments:arguments
                                                                      flutterResult:result];
                                                 });
                                               }];
          } else {
            [self handleErrors:authError flutterArguments:arguments withFlutterResult:result];
          }
        }

        - (void)handleAuthReplyWithSuccess:(BOOL)success
                                     error:(NSError *)error
                          flutterArguments:(NSDictionary *)arguments
                             flutterResult:(FlutterResult)result {
          NSAssert([NSThread isMainThread], @"Response handling must be done on the main thread.");

  ==============================

Linea # 154 y 155
    ==== Se reemplaza =======
        lastCallArgs = arguments;
        lastResult = result;
    ==== Por =======
       self->_lastCallArgs = arguments;
       self->_lastResult = result;


   ========================

  Linea # 194 y 195

    ==== Se reemplaza =======
        if (lastCallArgs != nil && lastResult != nil) {
            [self authenticateWithBiometrics:lastCallArgs withFlutterResult:lastResult];

    ==== Por =======
        if (self.lastCallArgs != nil && self.lastResult != nil) {
           [self authenticateWithBiometrics:_lastCallArgs withFlutterResult:self.lastResult];
