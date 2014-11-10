//
//  GalleryDisplayView.h
//  Locatr
//
//  Created by Milan Kamilya on 07/11/14.
//  Copyright (c) 2014 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKImageGalleryScrollView.h"
#import "RMGalleryView.h"


@protocol GalleryDisplayViewDelegate <NSObject>

-(void)closeButtonClicked:(UIButton *)sender;

@end

@interface GalleryDisplayView : UIView
@property (nonatomic) int countOfImages;
@property (nonatomic,weak) MKImageGalleryScrollView *imageGalleryScrollView;
@property (nonatomic,weak) UIButton *closeButton;

@property (nonatomic,strong) RMGalleryView *galleryView;
/**
 The gallery index.
 @discussion Typically, this will be used to set the initial gallery index and then to query the current index when needed.
 @discussion The gallery view delegate notifies index changes.
 */
@property (nonatomic, assign) NSUInteger galleryIndex;

@property (nonatomic, weak) id<GalleryDisplayViewDelegate> delegate;

/**
 The tap gesture recognizer. Toggles bars when the gallery view controller is inside a navigation view controller or dismisses the view controller when presented modally (without a navigation bar).
 @discussion Disable this gesture recognizer to disable the default tap behavior.
 */
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;



@end

