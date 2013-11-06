//
//  UIImage+Tag.m
//  ImageGallery
//
//  Created by Sandip Saha on 05/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "UIImage+TagAndResize.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";
@implementation UIImage (TagAndResize)

-(void)setTag:(int)tag
{
    objc_setAssociatedObject(self, ObjectTagKey, [NSNumber numberWithInt:tag], OBJC_ASSOCIATION_RETAIN);
}

-(int) tag
{
    return [objc_getAssociatedObject(self, ObjectTagKey) intValue];
}


/*********************************************************************
 **         It return a image of a fixed width
 **
 *********************************************************************/
- (UIImage*)imageScaledToWidth: (float) i_width
{
    //------------------------------------------
    // Task :
    // 1. calculate scaleFactor
    // 2. multiple with width and height
    // 3. resize the image with new width and height
    //------------------------------------------
    
    float oldWidth = self.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/*********************************************************************
 **        It return a image of a fixed height
 **
 *********************************************************************/
- (UIImage*)imageScaledToHeight: (float) i_height
{
    
    float oldHeight = self.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = self.size.width* scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*********************************************************************
 **           Resize image
 **           according to any Size
 *********************************************************************/
- (UIImage*)imageScaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end
