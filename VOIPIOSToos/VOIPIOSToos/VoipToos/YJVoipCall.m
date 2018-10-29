//
//  YJVoipCall.m
//  VOIPIOSToos
//
//  Created by YYJ on 2018/10/29.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import "YJVoipCall.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "YJVoipManagerTool.h"



@interface YJVoipCall()<YJVoipManagerToolDelegate>

{
    UILocalNotification *callNotification;
    UNNotificationRequest *request;//ios 10
}

@end

@implementation YJVoipCall


+ (YJVoipCall *)sharedCall {
    static YJVoipCall *_sharedCall = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCall=[[YJVoipCall alloc]init];
    });
    return _sharedCall;
}

- (void)regsionPush {
    
    
    // 收到voip消息后 需要做一个 通知栏(采用本地的)   根据业务需求定
    
    // 注册授权 (推送)
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge  | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];}
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // iOS8以后 本地通知必须注册(获取权限)
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
}

#pragma mark-VideoCallbackDelegate

- (void)onCallRing:(NSString *)CallerName {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        // 设置一些本地通知的属性  根据自己的业务来定
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body =[NSString localizedUserNotificationStringForKey:[NSString
                                                                       stringWithFormat:@"%@", CallerName] arguments:nil];;
        //  UNNotificationSound *customSound = [UNNotificationSound soundNamed:@"voip_call.caf"];
        // content.sound = customSound;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:1 repeats:NO];
        request = [UNNotificationRequest requestWithIdentifier:@"Voip_Push"
                                                       content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else {
        
        callNotification = [[UILocalNotification alloc] init];
        callNotification.alertBody = [NSString
                                      stringWithFormat:@"%@", CallerName];
        [[UIApplication sharedApplication] scheduleLocalNotification:callNotification];
        
    }
    
}

- (void)onCancelRing {
    //取消通知栏
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        NSMutableArray *arraylist = [[NSMutableArray alloc]init];
        [arraylist addObject:@"Voip_Push"];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:arraylist];
    }else {
        [[UIApplication sharedApplication] cancelLocalNotification:callNotification];
    }
    
}

@end
