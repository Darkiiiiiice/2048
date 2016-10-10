//
//  Colors.m
//  2048
//
//  Created by Mario on 2016/10/9.
//  Copyright © 2016年 Mario. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Colors.h"

#define RED_MASK    0xFF000000;
#define GREEN_MASK  0xFF0000;
#define BLUE_MASK   0xFF00;
#define ALPHA_MASK  0xFF;
#define MASK        0xFF;


@implementation Colors

+(UIColor *)transColorWithHex:(NSInteger)hex{
    NSInteger _red = 0;
    NSInteger _green = 0;
    NSInteger _blue = 0;
    NSInteger _alpha = 0;
    
    _red = hex & RED_MASK;
    _red = _red >> 24;
    
    _green = hex & GREEN_MASK;
    _green = _green >> 16;
    
    _blue = hex & BLUE_MASK;
    _blue = _blue >> 8;
    
    _alpha = hex & ALPHA_MASK;
    
    CGFloat red = ((CGFloat)_red) / MASK;
    CGFloat green = ((CGFloat)_green) / MASK;
    CGFloat blue = ((CGFloat)_blue) / MASK;
    CGFloat alpha = ((CGFloat)_alpha) / MASK;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
}

@end
