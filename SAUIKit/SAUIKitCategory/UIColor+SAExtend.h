//
//  UIColor+SAExtend.h
//  SAFoundationCategory
//
//  Created by 吴潮 on 16/3/25.
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SAExtend)

/**
 *  生成指定颜色的image
 *
 *  @return 生成的图片
 */
- (UIImage *)imageForConvert;

/**
 *  16进制获取颜色 含有alpha
 *
 *  @param color 6位16进制字符串
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/**
 *  获取颜色
 *
 *  @param color 6位16进制字符串
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
