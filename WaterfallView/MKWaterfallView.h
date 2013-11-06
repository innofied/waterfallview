//
//  ScrollView.h
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURL+Tag.h"
#import "UIImage+TagAndResize.h"

@interface MKWaterfallView : UIView


@property (strong, nonatomic)   UIScrollView    *scrollViewOfImages;

//-----------------------------------------------------------------
//  Following property must be set by the user before method call
//-----------------------------------------------------------------
@property ( nonatomic) float widthOfGapBtnColumnsInScrollView;
@property ( nonatomic) float widthOfGapBtnViewColumnsInScrollView ;
@property ( nonatomic) float heightOfGapBtnImageOfSameColumn;
@property ( nonatomic) float widthOfColumnInScrollView ;

//-----------------------------------------------------------------
//  Following property need to be set as requirement
//-----------------------------------------------------------------
@property ( nonatomic) NSInteger widthOfBorderSurroundedImage;
@property ( nonatomic) UIColor  *colorOfBorderSurroundedImage;
@property ( nonatomic) NSInteger cornerRadiusOfImage;
@property ( nonatomic) BOOL      isMaskedTheCornerOfImage;

//-----------------------------------------------------------------
//  Following property need to be set as requirement
//-----------------------------------------------------------------
@property ( nonatomic) UIImage  *backgroundImage;



//-----------------------------------------------------------------
//  If you display images from iphone "photoes" then call the below
//  method to show them in a waterfall view
//-----------------------------------------------------------------
- (void) addSubviewToScrollViewFromUIImageArray:(NSArray *)arrayOfUIImageSource
                                     noOfColumn:(int)noOfColumn;

//-----------------------------------------------------------------
//  If you have several image URL and need show them in waterfall
//  view then use the below method
//-----------------------------------------------------------------
- (void) addSubviewToScrollViewFromImageUrlStringArray:(NSArray *)arrayOfImageUrlStringSource
                                            OfColumnNo:(int)noOfColumn;


@end
