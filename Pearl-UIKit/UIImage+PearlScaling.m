/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  UIImage+PearlScaling.m
//  Pearl
//
//  Created by Maarten Billemont on 30/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//
//  http://stackoverflow.com/questions/603907/uiimage-resize-then-crop/605385#605385
//

#import "UIImage+PearlScaling.h"

@implementation UIImage(PearlScaling)

+ (UIImage *)imageNamed:(NSString *)imageName inSquareScalingHeight:(CGFloat)height {

    return [[self imageNamed:imageName] imageInSquareScalingHeight:height];
}

+ (UIImage *)imageNamed:(NSString *)imageName inSquareScalingWidth:(CGFloat)width {

    return [[self imageNamed:imageName] imageInSquareScalingWidth:width];
}

+ (UIImage *)imageNamed:(NSString *)imageName inSizeScalingHeight:(CGSize)size {

    return [[self imageNamed:imageName] imageInSizeScalingHeight:size];
}

+ (UIImage *)imageNamed:(NSString *)imageName inSizeScalingWidth:(CGSize)size {

    return [[self imageNamed:imageName] imageInSizeScalingWidth:size];
}

+ (UIImage *)imageNamed:(NSString *)imageName scaleInto:(CGSize)scaleSize cropTo:(CGSize)cropSize {

    return [[self imageNamed:imageName] imageScaledInto:scaleSize cropTo:cropSize];
}

- (UIImage *)imageInSquareScalingHeight:(CGFloat)height {

    return [self imageInSizeScalingHeight:CGSizeMake( height, height )];
}

- (UIImage *)imageInSquareScalingWidth:(CGFloat)width {

    return [self imageInSizeScalingWidth:CGSizeMake( width, width )];
}

- (UIImage *)imageInSizeScalingHeight:(CGSize)size {

    return [self imageScaledInto:CGSizeMake( CGFLOAT_MAX, size.height ) cropTo:size];
}

- (UIImage *)imageInSizeScalingWidth:(CGSize)size {

    return [self imageScaledInto:CGSizeMake( size.width, CGFLOAT_MAX ) cropTo:size];
}

- (UIImage *)imageScaledInto:(CGSize)scaleSize cropTo:(CGSize)cropSize {

    static NSCache *imageCache = nil;
    @synchronized (self) {
        if (!imageCache)
            imageCache = [NSCache new];
    }

    NSString *imageSourceKey = [[(__bridge_transfer NSData *)CGDataProviderCopyData( CGImageGetDataProvider( self.CGImage ) )
            hashWith:PearlHashMD4] encodeBase64];
    NSString *imageKey = strf( @"%@_%@_%@", imageSourceKey, NSStringFromCGSize( scaleSize ), NSStringFromCGSize( cropSize ) );
    UIImage *image = [imageCache objectForKey:imageKey];
    if (!image)
        [imageCache setObject:image = [[self imageByScalingAndFittingInSize:scaleSize] imageByScalingAndCroppingToSize:cropSize]
                       forKey:imageKey];

    return image;
}

- (UIImage *)imageByScalingAndFittingInSize:(CGSize)targetSize {

    return [self imageByScalingAndFittingInSize:targetSize forceSize:NO];
}

- (UIImage *)imageByScalingAndFittingInSize:(CGSize)targetSize forceSize:(BOOL)forceSize {

    if (CGSizeEqualToSize( self.size, targetSize ))
        return self;

    CGFloat widthFactor = targetSize.width / self.size.width;
    CGFloat heightFactor = targetSize.height / self.size.height;

    CGFloat scaleFactor = MIN( widthFactor, heightFactor );
    CGSize scaledSize = CGSizeMake( self.size.width * scaleFactor, self.size.height * scaleFactor );
    UIGraphicsBeginImageContextWithOptions( forceSize? targetSize: scaledSize, NO, self.scale );

    CGRect thumbnailRect = { .origin = CGPointZero, .size = scaledSize };
    if (forceSize)
        thumbnailRect.origin = CGPointMake((targetSize.width - scaledSize.width) / 2,
                                           (targetSize.height - scaledSize.height) / 2);

    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (newImage == nil)
        Throw( @"Couldn't scale image: %@ to size: %@", self, NSStringFromCGSize( targetSize ) );

    return newImage;
}

- (UIImage *)imageByScalingAndCroppingToSize:(CGSize)cropSize {

    CGSize targetSize = CGSizeMake( MIN( self.size.width, cropSize.width ), MIN( self.size.height, cropSize.height ) );
    if (CGSizeEqualToSize( self.size, targetSize ))
        return self;

    CGFloat widthFactor = targetSize.width / self.size.width;
    CGFloat heightFactor = targetSize.height / self.size.height;

    CGFloat scaleFactor = MAX( widthFactor, heightFactor );
    CGSize scaledSize = CGSizeMake( self.size.width * scaleFactor, self.size.height * scaleFactor );

    // center the image
    CGPoint thumbnailPoint = CGPointZero;
    if (widthFactor > heightFactor)
        thumbnailPoint.y = (targetSize.height - scaledSize.height) / 2;
    else if (widthFactor < heightFactor)
        thumbnailPoint.x = (targetSize.width - scaledSize.width) / 2;

    UIGraphicsBeginImageContextWithOptions( targetSize, NO, self.scale ); // this will crop

    CGRect thumbnailRect;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size = scaledSize;

    [self drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (newImage == nil)
        Throw( @"Couldn't scale image: %@ to size: %@", self, NSStringFromCGSize( targetSize ) );

    return newImage;
}

@end
