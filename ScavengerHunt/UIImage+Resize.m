//
//  UIImage+Resize.m
//  ScavengerHunt
//
//  Created by Jeremy Lazarus on 4/7/13.
//
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, 0, -size.height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
