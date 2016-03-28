//
//  CALayer+SAExtend.m
//  SAFoundationCategory
//
//  Created by 吴潮 on 16/3/25.
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import "CALayer+SAExtend.h"

@implementation CALayer (SAExtend)

-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .1f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
