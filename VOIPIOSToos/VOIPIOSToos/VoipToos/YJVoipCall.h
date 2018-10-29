//
//  YJVoipCall.h
//  VOIPIOSToos
//
//  Created by YYJ on 2018/10/29.
//  Copyright © 2018年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJVoipCall : NSObject
+ (instancetype)sharedCall;
- (void)regsionPush;
@end

NS_ASSUME_NONNULL_END
