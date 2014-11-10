//
//  SettingViewController.h
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (nonatomic, strong) AssetLibraryAccessor *assetLibraryAccessor;
@property (strong, nonatomic) MKImageGalleryScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;

@property ( nonatomic) NSInteger widthOfGapBtnColumnsInScrollView;
@property ( nonatomic) NSInteger widthOfGapBtnViewColumnsInScrollView ;
@property ( nonatomic) NSInteger heightOfGapBtnImageOfSameColumn;
@property ( nonatomic) NSInteger widthOfColumnInScrollView ;

@end
