//
//  SAProgressHUD.m
//  SAUIKitTool
//
//  Created by 吴潮 on 16/3/25.author by 学宝
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import "SAProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

static const NSTimeInterval delayInterval = 0.7f;

@implementation SAProgressHUD
+ (SAProgressHUD *)shareProgressHUDInstance{
    static SAProgressHUD *messageHud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageHud = [[SAProgressHUD alloc] init];
    });
    return messageHud;
}

+ (void)showMessage:(NSString *)message {
    [[SAProgressHUD shareProgressHUDInstance] showMessage:message addedToView:[UIApplication sharedApplication].keyWindow hideAfterDelay:delayInterval];
}

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view {
    [[SAProgressHUD shareProgressHUDInstance] showMessage:message addedToView:view hideAfterDelay:delayInterval];
}

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay{
    [[SAProgressHUD shareProgressHUDInstance] showMessage:message addedToView:view hideAfterDelay:delayInterval];
}

- (void)showMessage:(NSString *)message addedToView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay{
    if (!message||!view) {
        return;
    }
    NSDictionary *paramDict = @{@"view" : view, @"message" : message, @"delay" : [NSNumber numberWithDouble:delay]};
    [self performSelector:@selector(performShowMessageHUDWithDictionary:) withObject:paramDict afterDelay:0.5f];
}

- (void)performShowMessageHUDWithDictionary:(NSDictionary *)dictionary{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:dictionary[@"view"] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = dictionary[@"message"];
    hud.detailsLabelFont = [UIFont systemFontOfSize:17.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:[dictionary[@"delay"] doubleValue]];
}
@end

