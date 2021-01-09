    #import "ShareExtendPlugin.h"

    @implementation FLTShareExtendPlugin

    + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
        FlutterMethodChannel* shareChannel = [FlutterMethodChannel
                                              methodChannelWithName:@"custom_share_extend"
                                              binaryMessenger:[registrar messenger]];

        [shareChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            printf("share_objective");
            if ([@"share" isEqualToString:call.method]) {

            NSDictionary *arguments = [call arguments];
                        NSArray *array = arguments[@"list"];
                        NSString *shareType = arguments[@"type"];

                        if (array.count == 0) {
                            result(
                                   [FlutterError errorWithCode:@"error" message:@"Non-empty list expected" details:nil]);
                            return;
                        }

                        NSNumber *originX = arguments[@"originX"];
                        NSNumber *originY = arguments[@"originY"];
                        NSNumber *originWidth = arguments[@"originWidth"];
                        NSNumber *originHeight = arguments[@"originHeight"];

                        CGRect originRect;
                        if (originX != nil && originY != nil && originWidth != nil && originHeight != nil) {
                            originRect = CGRectMake([originX doubleValue], [originY doubleValue],
                                                    [originWidth doubleValue], [originHeight doubleValue]);
                        }

                        if ([shareType isEqualToString:@"text"]) {
                            [self share:array atSource:originRect];
                            result(nil);
                        }  else if ([shareType isEqualToString:@"image"]) {
                            NSMutableArray * imageArray = [[NSMutableArray alloc] init];
                            for (NSString * path in array) {
                                UIImage *image = [UIImage imageWithContentsOfFile:path];
                                [imageArray addObject:image];
                            }
                            [self share:imageArray atSource:originRect];
                        } else {
                            NSMutableArray * urlArray = [[NSMutableArray alloc] init];
                            for (NSString * path in array) {
                                NSURL *url = [NSURL fileURLWithPath:path];
                                [urlArray addObject:url];
                            }
                            [self share:urlArray atSource:originRect];
                            result(nil);
                        }

            } else if ([@"share_multi" isEqualToString:call.method]) {

                 NSDictionary *arguments = [call arguments];
                 NSString *shareText = arguments[@"text"];
                 NSString *shareType = arguments[@"type"];
                 NSArray *stringArray = [shareText componentsSeparatedByString:@","];
                 NSLog(@"%@", stringArray);

                printf("shareFileList:metodo");
                          NSArray *shareFileList = arguments[@"fileList"];

                          printf("shareFileList");
                          NSLog(@"%@shareFileList", shareFileList);


                   if (shareText.length == 0) {
                     result([FlutterError errorWithCode:@"error" message:@"Non-empty text expected" details:nil]);
                     return;
                   }
                   NSNumber *originX = arguments[@"originX"];
                   NSNumber *originY = arguments[@"originY"];
                   NSNumber *originWidth = arguments[@"originWidth"];
                   NSNumber *originHeight = arguments[@"originHeight"];

                   CGRect originRect;
                   if (originX != nil && originY != nil && originWidth != nil && originHeight != nil) {
                        originRect = CGRectMake([originX doubleValue], [originY doubleValue],
                        [originWidth doubleValue], [originHeight doubleValue]);
                   }
                   if ([shareType isEqualToString:@"text"]) {
                       [self share:shareText atSource:originRect];
                       result(nil);
                   }  else if ([shareType isEqualToString:@"image"]) {
                       //UIImage *image = [UIImage imageWithContentsOfFile:shareText];
                       NSMutableArray *stampList = [NSMutableArray array];
                        for(id imageArray in shareFileList){
                              printf("entro:cambio");
                            //  UIImage *image = [UIImage imageWithContentsOfFile:imageArray];
                               //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                            [stampList addObject:[UIImage imageWithContentsOfFile:imageArray]];

                           }
                             NSLog(@"%@stampList", stampList);

                           [self share:stampList atSource:originRect];

                   } else {
                       NSURL *url = [NSURL fileURLWithPath:shareText];
                       [self share:url atSource:originRect];
                       result(nil);
                   }
            }else if ([@"download_gallery_multi" isEqualToString:call.method]) {
                    NSDictionary *arguments = [call arguments];

                        printf("download_gallery_multi:shareFileList:metodo");
                                  NSArray *shareFileList = arguments[@"fileList"];

                                  printf("shareFileList");
                                  NSLog(@"%@shareFileList", shareFileList);


                        
                           NSNumber *originX = arguments[@"originX"];
                           NSNumber *originY = arguments[@"originY"];
                           NSNumber *originWidth = arguments[@"originWidth"];
                           NSNumber *originHeight = arguments[@"originHeight"];

                           CGRect originRect;
                           if (originX != nil && originY != nil && originWidth != nil && originHeight != nil) {
                                originRect = CGRectMake([originX doubleValue], [originY doubleValue],
                                [originWidth doubleValue], [originHeight doubleValue]);
                           }

                              
                        for(id imageArray in shareFileList){
                            printf("entro:cambio");
                            UIImage *image = [UIImage imageWithContentsOfFile:imageArray];
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                        }
                }else {
    result(FlutterMethodNotImplemented);
            }
        }];
    }

    + (void)share:(id)sharedItems atSource:(CGRect)origin {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];

        UIViewController *controller =[UIApplication sharedApplication].keyWindow.rootViewController;

        activityViewController.popoverPresentationController.sourceView = controller.view;
        if (!CGRectIsEmpty(origin)) {
            activityViewController.popoverPresentationController.sourceRect = origin;
        }
        [controller presentViewController:activityViewController animated:YES completion:nil];
    }

    @end
