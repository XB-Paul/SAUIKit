//
//  UIView+SAExtend.h
//  SAFoundationCategory
//
//  Created by 吴潮 on 16/3/25.
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SAExtend)
/****截屏****/
-(UIImage *)imageForCutScreen;

/****是否存在第一响应****/
-(BOOL)isExistFirstResponder;

/****设置边框****/
- (void)setBorderWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

/****画线****/
- (void)lineFromTop:(float)top left:(float)left toRight:(float)right lineColor:(UIColor *)color;
@end
