//
//  LibraryAPI.m
//  ImageGallery
//
//  Created by Sandip Saha on 22/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "LibraryAPI.h"

@implementation LibraryAPI

{
    PersistencyManager *persistencyManager;
    
    BOOL isOnline;
}
-(LibraryAPI*)init
{
    self = [super init];
    if (self) {
        // write code
        
    }
    return self;
}

+ (LibraryAPI*)sharedInstance
{
    // 1
    static LibraryAPI *singleInstance ;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        singleInstance = [[LibraryAPI alloc] init];
    });
    return singleInstance;

    
}
@end
