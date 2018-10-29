//
//  YJVoipManagerTool.m
//  VOIPIOSToos
//
//  Created by YYJ on 2018/10/29.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import "YJVoipManagerTool.h"
#import <PushKit/PushKit.h>
#import <UIKit/UIKit.h>
#import "YJVoipCall.h"


@interface YJVoipManagerTool()<PKPushRegistryDelegate>
{
    NSString *token;
}

@end

@implementation YJVoipManagerTool
+ (YJVoipManagerTool *)sharedTool {
    static YJVoipManagerTool *_sharedTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTool=[[YJVoipManagerTool alloc]init];
        
    });
    return _sharedTool;
}

-(id)init{
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
  // 注册推送
    [[YJVoipCall sharedCall] regsionPush];
    return self;
}

- (void)setDelegate:(id<YJVoipManagerToolDelegate>)delegate {
    
    self.mydelegate = delegate;
}
#pragma mark -pushkitDelegate

-(void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type{
    if([pushCredentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    //应用启动获取token，并上传服务器
    token = [[[[pushCredentials.token description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
              stringByReplacingOccurrencesOfString:@">" withString:@""]
             stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",token);
    
}

// 接受来自VOIP 推送的代理方法
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type{
    
    NSLog(@"%@",payload.dictionaryPayload);
   
    if ([self isUserNotificationEnable]) {  //允许推送
        
        BOOL isCalling = false;
        switch ([UIApplication sharedApplication].applicationState) {
                
                // 应用的状态  前台、杀死 、后台 根据自己的需求可自行设置
            case UIApplicationStateActive: {
                isCalling = false;
            }
                break;
            case UIApplicationStateInactive: {
                isCalling = false;
            }
                break;
            case UIApplicationStateBackground: {
                isCalling = true;
            }
                break;
            default:
                isCalling = true;
                break;
        }
        if (isCalling){
            
            //本地通知，实现响铃效果
            [self.mydelegate onCallRing:[NSString stringWithFormat:@"%@",@"您有一条新的消息"]];
        }
    }
}

- (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 获取tocken上传到服务器
-(void)uploadToken{
    
    NSLog(@"%@",token);
    
}

@end
