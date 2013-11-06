//
//  ImageResizing.h
//  ImageGallery
//
//  Created by Sandip Saha on 18/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResizing : NSObject

- (UIImage*)imageWithImage: (UIImage*) sourceImage
             scaledToWidth: (float) i_width;

- (UIImage*)imageWithImage: (UIImage*) sourceImage
            scaledToHeight: (float) i_height;

- (UIImage*)imageWithImage:(UIImage*)sourceImage
              scaledToSize:(CGSize)newSize;

@end
