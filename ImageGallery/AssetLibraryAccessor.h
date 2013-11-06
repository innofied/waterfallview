//
//  AssetLibraryAccessor.h
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AssetLibraryAccessor : NSObject

{
    ALAssetsLibrary *library;
    NSArray *imageArray;
    NSMutableArray *mutableArray;
}

@property (nonatomic, strong) NSArray *imageArrayOfAssetLibraryAccessor;
@property (nonatomic, copy)   void(^completionHandler)(void);

- (void) allPhotosCollected:(NSArray*)imgArray;
- (void) getAllPictures;

@end
