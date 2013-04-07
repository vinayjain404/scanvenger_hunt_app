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
static UIColor* navColor;
static UIColor* cellColor;
static UIColor* innerCellColor;

@implementation UIColor (Hunt)

+ (UIColor*)mainBackgroundColor {
    if (!mainBackgroundColor) {
        mainBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    }
    
    return mainBackgroundColor;
}

+ (UIColor*)viewBackgroundColor {
    if (!viewBackgroundColor) {
        viewBackgroundColor = [UIColor colorWithRed:.85f green:.85f blue:.9f alpha:1.0f];
    }
    
    return viewBackgroundColor;
}

+ (UIColor*)navColor {
    if (!navColor) {
        navColor = [UIColor colorWithRed:.153f green:.768f blue:.824f alpha:1.0f];
    }
    
    return navColor;
}

+ (UIColor*)cellColor {
    if (!cellColor) {
        cellColor = [UIColor colorWithRed:.67f green:.875f blue:.902f alpha:1.0f];
    }
    
    return cellColor;
}

+ (UIColor*)innerCellColor {
    if (!innerCellColor) {
        innerCellColor = [UIColor colorWithRed:.67f green:.875f blue:.902f alpha:1.0f];
    }
    
    return innerCellColor;
}

@end
