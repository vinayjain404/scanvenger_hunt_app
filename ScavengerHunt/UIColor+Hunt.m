//
//  UIColor+Hunt.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/6/13.
//
//

#import "UIColor+Hunt.h"

static UIColor* mainBackgroundColor;
static UIColor* viewBackgroundColor;

@implementation UIColor (Hunt)

+ (UIColor*)mainBackgroundColor {
    if (!mainBackgroundColor) {
        mainBackgroundColor = [UIColor colorWithRed:.95f green:.95f blue:1.0f alpha:1.0f];
    }
    
    return mainBackgroundColor;
}

+ (UIColor*)viewBackgroundColor {
    if (!viewBackgroundColor) {
        viewBackgroundColor = [UIColor colorWithRed:.85f green:.85f blue:.9f alpha:1.0f];
    }
    
    return viewBackgroundColor;
}

@end
