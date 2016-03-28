//
//  UIView+SAExtend.m
//  SAFoundationCategory
//
//  Created by 吴潮 on 16/3/25.
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import "UIView+SAExtend.h"

@implementation UIView (SAExtend)

-(UIImage *)imageForCutScreen{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(BOOL)isExistFirstResponder{
    if (self.isFirstResponder) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isExistFirstResponder]) {
            return YES;
        }
    }
    return NO;
}

- (void)setBorderWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)lineFromTop:(float)top left:(float)left toRight:(float)right lineColor:(UIColor *)color {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = color.CGColor;
    layer.frame = CGRectMake(left, top, self.bounds.size.width - left - right, 0.5);
    [self.layer addSublayer:layer];
}
@end
