//
//  MKViewController.h
//  WaterfallView
//
//  Created by Sandip Saha on 06/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKWaterfallView.h"
@interface MKViewController : UIViewController
@property (strong, nonatomic) MKWaterfallView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;


@end
