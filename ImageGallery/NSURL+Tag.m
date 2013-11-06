//
//  NSURL+Tag.m
//  ImageGallery
//
//  Created by Sandip Saha on 06/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "NSURL+Tag.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";
@implementation NSURL (Tag)

-(void)setTag:(int)tag
{
    objc_setAssociatedObject(self, ObjectTagKey, [NSNumber numberWithInt:tag], OBJC_ASSOCIATION_RETAIN);
}

-(int) tag
{
    return [objc_getAssociatedObject(self, ObjectTagKey) integerValue];
}
@end
