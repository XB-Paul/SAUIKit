//
//  SAProgressHUD.h
//  SAUIKitTool
//
//  Created by 吴潮 on 16/3/25.author by 学宝
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SAProgressHUD : NSObject

+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view;

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

@end
