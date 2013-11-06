//
//  UIImage+Tag.h
//  ImageGallery
//
//  Created by Sandip Saha on 05/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TagAndResize)
-(void)setTag:(int)tag;
-(int) tag;
- (UIImage*)imageScaledToWidth: (float) i_width;

- (UIImage*)imageScaledToHeight: (float) i_height;

- (UIImage*)imageScaledToSize:(CGSize)newSize;
@end
