//
//  GalleryDisplayView.m
//  Locatr
//
//  Created by Milan Kamilya on 07/11/14.
//  Copyright (c) 2014 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import "GalleryDisplayView.h"
#import "RMGalleryView.h"
#import "UIImage+RMGalleryDemo.h"

@interface GalleryDisplayView() <RMGalleryViewDataSource,RMGalleryViewDelegate>
{
    UILabel *titleLabel;
    NSString *title;
    UIView *containerView;
    BOOL isContainerViewShown;
}
@end

@implementation GalleryDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //automaticallyAdjustsScrollViewInsets = NO;
        _galleryView = [RMGalleryView new];
        _galleryView.frame = self.bounds;
        _galleryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_galleryView];
        
        // Set the gallery data source and delegate. Only the data source is required.
        _galleryView.galleryDataSource = self;
        _galleryView.galleryDelegate = self;
        
        
        // tab gesture recognizer to hide and show close button
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_tapGestureRecognizer requireGestureRecognizerToFail:self.galleryView.doubleTapGestureRecognizer];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)tapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (!isContainerViewShown) {
        [UIView animateWithDuration:0.25 animations:^{
            containerView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0f);
        }];
        isContainerViewShown = true;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            containerView.frame =  CGRectMake(0.0f, -60.0f, [UIScreen mainScreen].bounds.size.width, 60.0f);
        }];
        isContainerViewShown = false;
    }
}

-(void)setupCustomNavigationBar{
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    // container View
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 60.0f)];
    containerView.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:0.5];
    [self addSubview:containerView];
    
    // Title Label
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, containerView.frame.size.width, containerView.frame.size.height - 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    
    // Close Button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(screenFrame.size.width - 50, 22, 40, 40);
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -8);
    [closeButton setImage:[UIImage imageNamed:@"closeButtonWhite"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"closeButtonWhite"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    
    isContainerViewShown = YES;
}

- (void)closeButtonClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(closeButtonClicked:)])
    {
        [self.delegate closeButtonClicked:button];
    }
    
    
}

-(void) setGalleryIndex:(NSUInteger)galleryIndex{
    if (self.galleryView.galleryDataSource)
    {
        self.galleryView.galleryIndex = galleryIndex;
    }
    else
    {
        _galleryIndex = galleryIndex;
    }
    [self setTitleForIndex:galleryIndex];
    [self setupCustomNavigationBar];
}

#pragma mark RMGalleryViewDataSource

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock
{
    __weak typeof(self) weakSelf = self;
    // Typically images will be loaded asynchonously. To simulate this we resize the image in background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIImage *image = (UIImage *)[strongSelf.imageGalleryScrollView.dictionaryOfImages objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
        
        image = [image demo_imageByScalingByFactor:0.75];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView
{
    return _countOfImages;
}

#pragma mark RMGalleryViewDelegate

- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index
{
    [self setTitleForIndex:index];
}

#pragma mark Toolbar

- (void)barButtonAction:(UIBarButtonItem*)barButtonItem
{
    RMGalleryView *galleryView = self.galleryView;
    const NSUInteger index = galleryView.galleryIndex;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:index];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    
}

#pragma mark Utils

- (void)setTitleForIndex:(NSUInteger)index
{
    const NSUInteger count = [self numberOfImagesInGalleryView:self.galleryView];
    title = [NSString stringWithFormat:@"%ld of %ld", (long)index + 1, (long)count];
    titleLabel.text = title;
}


@end
