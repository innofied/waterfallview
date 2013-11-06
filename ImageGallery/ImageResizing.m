//
//  ImageResizing.m
//  ImageGallery
//
//  Created by Sandip Saha on 18/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "ImageResizing.h"

@implementation ImageResizing

/*********************************************************************
 **         It return a image of a fixed width
 **
 *********************************************************************/
- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    //------------------------------------------
    // Task :
    // 1. calculate scaleFactor
    // 2. multiple with width and height
    // 3. resize the image with new width and height
    //------------------------------------------
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/*********************************************************************
 **        It return a image of a fixed height
 **           
 *********************************************************************/
- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    
    
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width* scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*********************************************************************
 **           Resize image
 **           according to any Size
 *********************************************************************/
- (UIImage*)imageWithImage:(UIImage*)sourceImage
              scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext( newSize );
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
