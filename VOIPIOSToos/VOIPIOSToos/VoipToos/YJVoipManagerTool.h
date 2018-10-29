//
//  YJVoipManagerTool.h
//  VOIPIOSToos
//
//  Created by YYJ on 2018/10/29.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YJVoipManagerToolDelegate<NSObject>
/**
 *  当APP收到呼叫、处于后台时调用、用来处理通知栏类型和铃声。
 *
 *  @param name 呼叫者的名字 (可自定义扩展)
 */
- (void)onCallRing:(NSString*)name;
/**
 *  呼叫取消调用、取消通知栏
 */
- (void)onCancelRing;

@end

@interface YJVoipManagerTool : NSObject
@property (nonatomic,weak)id<YJVoipManagerToolDelegate>mydelegate;

+ (YJVoipManagerTool *)sharedTool;
- (void)setDelegate:(id<YJVoipManagerToolDelegate>)delegate;
// 获取tocken上传到服务器
-(void)uploadToken;
@end

NS_ASSUME_NONNULL_END
