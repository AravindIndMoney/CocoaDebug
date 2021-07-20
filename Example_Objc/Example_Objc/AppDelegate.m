//
//  AppDelegate.m
//  Example_Objc
//
//  Created by man on 8/11/20.
//  Copyright © 2020 man. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"

#ifdef DEBUG
@import CocoaDebug;
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef DEBUG
    //    [self customCocoaDebug];
#endif
    
    return YES;
}

- (void)customCocoaDebug {
    //--- If Want to Custom CocoaDebug Settings ---
    CocoaDebug.serverURL = @"google.com";
    CocoaDebug.ignoredURLs = @[@"aaa.com", @"bbb.com"];
    CocoaDebug.onlyURLs = @[@"ccc.com", @"ddd.com"];
    CocoaDebug.ignoredPrefixLogs = @[@"aaa", @"bbb"];
    CocoaDebug.onlyPrefixLogs = @[@"ccc", @"ddd"];
    CocoaDebug.logMaxCount = 1000;
    CocoaDebug.emailToRecipients = @[@"aaa@gmail.com", @"bbb@gmail.com"];
    CocoaDebug.emailCcRecipients = @[@"ccc@gmail.com", @"ddd@gmail.com"];
    CocoaDebug.mainColor = @"#fd9727";
    CocoaDebug.additionalViewController = [TestViewController new];
    
    //--- If Use Google's Protocol buffers ---
    CocoaDebug.protobufTransferMap = @{
        @"your_api_keywords_1": @[@"your_protobuf_className_1"],
        @"your_api_keywords_2": @[@"your_protobuf_className_2"],
        @"your_api_keywords_3": @[@"your_protobuf_className_3"]
    };
    
    //--- If Want to Manual enable App logs ---
    CocoaDebugSettings.shared.enableLogMonitoring = YES;
    
    //--- If Custom, Must Manual enable CocoaDebug ---
    [CocoaDebug enable];
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
}

@end
