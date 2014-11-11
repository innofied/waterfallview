//
//  ScrollView.m
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "MKImageGalleryScrollView.h"
#import "Photo.h"
#import "NetworkRequestHandler.h"
#import "DisplayImageInFullScreenView.h"

static CGRect RMCGRectAspectFit(CGSize sourceSize, CGSize size)
{
    const CGFloat targetAspect = size.width / size.height;
    const CGFloat sourceAspect = sourceSize.width / sourceSize.height;
    CGRect rect = CGRectZero;
    
    if (targetAspect > sourceAspect)
    {
        rect.size.height = size.height;
        rect.size.width = rect.size.height * sourceAspect;
        rect.origin.x = (size.width - rect.size.width) * 0.5;
    }
    else
    {
        rect.size.width = size.width;
        rect.size.height = rect.size.width / sourceAspect;
        rect.origin.y = (size.height - rect.size.height) * 0.5;
    }
    return CGRectIntegral(rect);
}

@interface MKImageGalleryScrollView() <GalleryDisplayViewDelegate>
{
    UIImage *image ;
    int noOfImage;
    NSInteger arrayOfColumnHeight[10];
    ImageResizing *imageResizing;
    UIImageView   *backgroundImageview;
    UITapGestureRecognizer *tapGestureRecognizer;
    DisplayImageInFullScreenView *gallery;
}
@end

@implementation MKImageGalleryScrollView

@synthesize scrollViewOfImages;
@synthesize dictionaryOfImages;
@synthesize dictionaryOfImageViews;

@synthesize widthOfColumnInScrollView;
@synthesize widthOfGapBtnColumnsInScrollView;
@synthesize widthOfGapBtnViewColumnsInScrollView;
@synthesize heightOfGapBtnImageOfSameColumn;

@synthesize widthOfBorderSurroundedImage;
@synthesize colorOfBorderSurroundedImage;
@synthesize cornerRadiusOfImage;
@synthesize isMaskedTheCornerOfImage;

@synthesize backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Create scroll view and add with view
        scrollViewOfImages  = [[UIScrollView alloc] initWithFrame:frame];
        backgroundImageview = [[UIImageView alloc] initWithFrame:frame];
        
        [self addSubview:backgroundImageview];
        [self addSubview:scrollViewOfImages];
        
        for (int i=0; i< 10; i++) {
            arrayOfColumnHeight[i] = 5;
        }
        
        imageResizing = [[ImageResizing alloc] init];
        
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.scrollViewOfImages addGestureRecognizer:tapGestureRecognizer];
        
        dictionaryOfImageViews = [[ NSMutableDictionary alloc] init];
        dictionaryOfImages = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void)tapGestureRecognized:(UITapGestureRecognizer*)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.scrollViewOfImages];
    
    
    int i = 0;
    for (UIView *view in self.scrollViewOfImages.subviews) {
        
        if (CGRectContainsPoint(view.frame, tapLocation)) {
            
            image = [dictionaryOfImages objectForKey:[NSString stringWithFormat:@"%li",(long)view.tag]];
            NSLog(@"View tapped at %li",(long)view.tag);
            if (image == nil) {
                break;
            }
            
            gallery = [[DisplayImageInFullScreenView alloc] initWithFrame:self.bounds];
            gallery.imageGalleryScrollView = self;
            gallery.countOfImages = (int)[dictionaryOfImageViews count];
            gallery.galleryIndex = view.tag;
            gallery.hidden = YES;
            gallery.delegate = self;
            [self addSubview:gallery];
            
            
            //------------------------------
            // Start Animation
            //------------------------------
            UIView *containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self addSubview:containerView];
            
            UIImage *transitionImage = (UIImage *)[dictionaryOfImages objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)gallery.galleryView.galleryIndex]];
            UIImageView *transitionView = [[UIImageView alloc] initWithImage:transitionImage];
            transitionView.contentMode = UIViewContentModeScaleAspectFill;
            transitionView.clipsToBounds = YES;
            
            
            UIView *fromView = self;
            UIImageView *imageView = (UIImageView *)[dictionaryOfImageViews objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)gallery.galleryView.galleryIndex]];
            const CGRect referenceRect = view ? [fromView convertRect:view.bounds fromView:view] : CGRectZero;
            transitionView.frame = [containerView convertRect:referenceRect fromView:fromView];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
            backgroundView.backgroundColor = [UIColor blackColor];
            backgroundView.alpha = 0;
            [containerView addSubview:backgroundView];
            
            [containerView addSubview:transitionView];
            
            const NSTimeInterval duration = 0.5;
            
            const CGSize thumbnailSize = imageView.image.size;
            
            // In this example the final images are about 25 times bigger than the thumbnail
            const CGSize estimatedImageSize = CGSizeMake(thumbnailSize.width * 25, thumbnailSize.height * 25);
            
           
            
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 backgroundView.alpha = 1;
                                 
                                 const CGRect transitionViewFinalFrame = RMCGRectAspectFit(estimatedImageSize, containerView.bounds.size);
                                 transitionView.frame = transitionViewFinalFrame;
                             }
                             completion:^(BOOL finished) {
                                 [backgroundView removeFromSuperview];
                                 //[coverView removeFromSuperview];
                                 [transitionView removeFromSuperview];
                                 
                                 [containerView addSubview:gallery];
                                 
                                 
                                 RMGalleryView *galleryView = gallery.galleryView;
                                 RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:gallery.galleryIndex];
                                 if (!galleryCell.image)
                                 { // Only set image if it wasn't already set in layoutIfNeeded
                                     [galleryCell setImage:transitionImage inSize:estimatedImageSize];
                                 }
                                 gallery.hidden = NO;
                                 [self addSubview:gallery];
                                 [containerView removeFromSuperview];
                                 
                             }];
            
            
            break;
        }
        i++;
    }
}

#pragma mark galleryDisplayView delegate

- (void)closeButtonClicked:(UIButton *)button{
    [gallery removeFromSuperview];
    
    UIView *blackViewIllution = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blackViewIllution.backgroundColor = [UIColor blackColor];
    [self addSubview:blackViewIllution];
    
    UIView *containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:containerView];
    
    
    const NSUInteger galleryIndex = gallery.galleryView.galleryIndex;
    RMGalleryView *galleryView = gallery.galleryView;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:galleryIndex];
    UIImageView *fromImageView = galleryCell.imageView;
    
    
    CGRect transitionViewInitialFrame = RMCGRectAspectFit(fromImageView.image.size, fromImageView.bounds.size);
    transitionViewInitialFrame = [containerView convertRect:transitionViewInitialFrame fromView:fromImageView];
    CGSize rectifiedSize = transitionViewInitialFrame.size;
    
    CGFloat factor = [UIScreen mainScreen].bounds.size.width/rectifiedSize.width;
    
    rectifiedSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, factor*rectifiedSize.height);
    
    transitionViewInitialFrame.size = rectifiedSize;
    
    
    UIImageView *imageView = (UIImageView *)[dictionaryOfImageViews objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)gallery.galleryView.galleryIndex]];
    const CGRect referenceRect = imageView ? [self convertRect:imageView.bounds fromView:imageView] : CGRectZero;
    const CGRect transitionViewFinalFrame = [containerView convertRect:referenceRect fromView:self];
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:fromImageView.image];
    transitionView.contentMode = UIViewContentModeScaleAspectFill;
    transitionView.clipsToBounds = YES;
    transitionView.frame = transitionViewInitialFrame;
    transitionView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [containerView addSubview:transitionView];
    //[fromViewController.view removeFromSuperview];
    
    NSTimeInterval duration = 0.25;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         blackViewIllution.alpha = 0;
                         transitionView.frame = transitionViewFinalFrame;
                     } completion:^(BOOL finished) {
                         [containerView removeFromSuperview];
                         [blackViewIllution removeFromSuperview];
                     }];
    
}


- (void) addSubviewToScrollViewFromUIImageArray:(NSArray *)arrayOfUIImageSource
                                     noOfColumn:(int)noOfColumn
{
    [self setBackground];
    
    // Check if user set arrayOfUIImageSource or not
    if (arrayOfUIImageSource == nil ||[arrayOfUIImageSource count] == 0) {
        
        UIAlertView *alertMessageOnEmptyarrayOfImageUrlStringSource = [[UIAlertView alloc]
                                                                 initWithTitle:@"Alert Message"
                                                                 message:@"Please send a proper array"
                                                                 delegate:self
                                                                 cancelButtonTitle:@"ok"
                                                                 otherButtonTitles: nil];
        [alertMessageOnEmptyarrayOfImageUrlStringSource show];
        return;
    }
    
    
    for (int i=0;i<[arrayOfUIImageSource count];i++)
    {
        noOfImage = i;
        //------------------------------------------------------------------
        //   Draw these images on the scroll view of this view controller
        //------------------------------------------------------------------
        
        int minimumHeightColumnIndex = 0; // first column index 0
        int minimumHeight=20000;
        int maximumHeight=0;
        int minimumHeightX;
        
        
        for (int j=0; j < noOfColumn; j++) {
            
            if (minimumHeight > arrayOfColumnHeight[j])
            {
                minimumHeight = (int)arrayOfColumnHeight[j];
                minimumHeightColumnIndex = j;
            }
            
        }
        
        minimumHeightX = widthOfGapBtnViewColumnsInScrollView + minimumHeightColumnIndex*( widthOfGapBtnColumnsInScrollView + widthOfColumnInScrollView );
                
                
        image = [arrayOfUIImageSource objectAtIndex:i];
        
        //----------------
        // resize image
        //----------------
        image = [imageResizing imageWithImage:image scaledToWidth:widthOfColumnInScrollView];
        
        
        
        CGRect imageFrame = CGRectMake(minimumHeightX, minimumHeight, image.size.width, image.size.height);
        minimumHeight=imageFrame.origin.y+image.size.height+heightOfGapBtnImageOfSameColumn;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageFrame];
        
        
        imageView.image = image;
        imageView.layer.borderWidth   = widthOfBorderSurroundedImage;
        imageView.layer.borderColor   = colorOfBorderSurroundedImage.CGColor;
        imageView.layer.cornerRadius  = cornerRadiusOfImage;
        imageView.layer.masksToBounds = isMaskedTheCornerOfImage;
        [self.scrollViewOfImages addSubview:imageView];
        
        
        arrayOfColumnHeight[minimumHeightColumnIndex] = minimumHeight;
        
        
        
        for (int j=0; j < noOfColumn; j++)
        {
            if (maximumHeight < arrayOfColumnHeight[j])
            {
                maximumHeight = (int)arrayOfColumnHeight[j];
            }
        }
        
       
        
        self.scrollViewOfImages.contentSize=CGSizeMake(self.scrollViewOfImages.frame.size.width,maximumHeight);
        
    }
    NSLog(@"****************************************");
    NSLog(@"#      ScrollView.m console o/p        #");
    NSLog(@"#      NO of Image :: %i              #",noOfImage);
    NSLog(@"****************************************");
}



- (void) addSubviewToScrollViewFromImageUrlStringArray:(NSArray *)arrayOfImageUrlStringSource
                                            OfColumnNo:(int)noOfColumn
{
    [self setBackground];
    
    
    // Check if user set arrayOfImageUrlStringSource or not
    if (arrayOfImageUrlStringSource == nil ||[arrayOfImageUrlStringSource count] == 0) {
        
        UIAlertView *alertMessageOnEmptyarrayOfImageUrlStringSource = [[UIAlertView alloc]
                                                                 initWithTitle:@"Alert Message"
                                                                 message:@"Please send a proper array"
                                                                 delegate:self
                                                                 cancelButtonTitle:@"ok"
                                                                 otherButtonTitles: nil];
        [alertMessageOnEmptyarrayOfImageUrlStringSource show];
        return;
        
    }
    
    static int indexOfImage = 0;
    
    for (int i=0;i<[arrayOfImageUrlStringSource count];i++)
    {
        __block NSURL *imageUrl;
        
        NetworkRequestHandler *netRequest = [[NetworkRequestHandler alloc] initWithBaseURLString:[arrayOfImageUrlStringSource objectAtIndex:i] objectPathInURL:nil dataDictionaryToPost:nil];
        netRequest.tag = i;
        __weak typeof (NetworkRequestHandler) *weakNetRequest = netRequest;
        [netRequest setCompletionHandler:^{
           
            // Do something that takes a while
            noOfImage = i;
            //-----------------------------
            // Download image from internet
            //-----------------------------
            
            NSData *imageData = weakNetRequest.responseData;
            
            image = [UIImage imageWithData:imageData];
            
            // If image downloaded
            if(image != nil){
                
                [image setTag:[imageUrl tag]];
                NSLog(@"#image tag %i %@",[image tag],image);
                NSLog(@"##image tag %i %@",[image tag],image);
                
                int individual = indexOfImage;
                indexOfImage++;
                //----------------
                // resize image
                //----------------
                [dictionaryOfImages setObject:image forKey:[NSString stringWithFormat:@"%li",(long)individual]];
                image = [imageResizing imageWithImage:image scaledToWidth:widthOfColumnInScrollView];
                
                
                
                //------------------------------------------------------------------
                //   Draw these images on the scroll view of this view controller
                //------------------------------------------------------------------
                
                int minimumHeightColumnIndex = 0; // first column index 0
                int minimumHeight=20000;
                int maximumHeight=0;
                int minimumHeightX;
                
                
                for (int j=0; j < noOfColumn; j++) {
                    
                    if (minimumHeight > arrayOfColumnHeight[j])
                    {
                        minimumHeight = (int)arrayOfColumnHeight[j];
                        minimumHeightColumnIndex = j;
                    }
                    
                }
                
                minimumHeightX = widthOfGapBtnViewColumnsInScrollView + minimumHeightColumnIndex*( widthOfGapBtnColumnsInScrollView + widthOfColumnInScrollView );
                
                
                CGRect imageFrame = CGRectMake(minimumHeightX, minimumHeight, image.size.width, image.size.height);
                minimumHeight=imageFrame.origin.y+image.size.height+heightOfGapBtnImageOfSameColumn;
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageFrame];
                
                
                imageView.image = image;
                imageView.layer.borderWidth   = widthOfBorderSurroundedImage;
                imageView.layer.borderColor   = colorOfBorderSurroundedImage.CGColor;
                imageView.layer.cornerRadius  = cornerRadiusOfImage;
                imageView.layer.masksToBounds = isMaskedTheCornerOfImage;
                imageView.tag =individual;
                NSLog(@"###image tag %i",individual);
                [scrollViewOfImages addSubview:imageView];
                [dictionaryOfImageViews setObject:imageView forKey:[NSString stringWithFormat:@"%li",(long)imageView.tag]];
                
                
                arrayOfColumnHeight[minimumHeightColumnIndex] = minimumHeight;
                
                
                
                for (int j=0; j < noOfColumn; j++)
                {
                    if (maximumHeight < arrayOfColumnHeight[j])
                    {
                        maximumHeight = (int)arrayOfColumnHeight[j];
                    }
                }
                
                self.scrollViewOfImages.contentSize=CGSizeMake(self.scrollViewOfImages.frame.size.width,maximumHeight);
                
            }
        }];
        
        [netRequest startDownload];
        
    }
    
    NSLog(@"****************************************");
    NSLog(@"#      ScrollView.m console o/p        #");
    NSLog(@"#      NO of Image :: %lu              #",(unsigned long)[arrayOfImageUrlStringSource count]);
    NSLog(@"****************************************");
}


- (void) addSubviewToScrollViewFromPhotoArray:(NSArray *)arrayOfPhoto
                                   OfColumnNo:(int)noOfColumn
                           withKnownImageSize:(BOOL)isImageSizeKnown
{
    [self setBackground];
    
    // Check if user set arrayOfImageUrlStringSource or not
    if (arrayOfPhoto == nil ||[arrayOfPhoto count] == 0) {
        
        UIAlertView *alertMessageOnEmptyarrayOfImageUrlStringSource = [[UIAlertView alloc]
                                                                       initWithTitle:@"Alert Message"
                                                                       message:@"No image found"
                                                                       delegate:self
                                                                       cancelButtonTitle:@"ok"
                                                                       otherButtonTitles: nil];
        [alertMessageOnEmptyarrayOfImageUrlStringSource show];
        return;
        
    }
    
    for (int i=0;i<[arrayOfPhoto count];i++)
    {
        
        
        
        Photo *photo = (Photo*)[arrayOfPhoto objectAtIndex:i ];
        
        float heightOfPhoto = photo.height*(widthOfColumnInScrollView/photo.width);
        
        
        //----------------
        // resize image
        //----------------
        //image = [imageResizing imageWithImage:image scaledToWidth:widthOfColumnInScrollView];
        
        
        
        //------------------------------------------------------------------
        //   Draw these images on the scroll view of this view controller
        //------------------------------------------------------------------
        
        int minimumHeightColumnIndex = 0; // first column index 0
        int minimumHeight=20000;
        int maximumHeight=0;
        int minimumHeightX;
        
        
        for (int j=0; j < noOfColumn; j++) {
            
            if (minimumHeight > arrayOfColumnHeight[j])
            {
                minimumHeight = (int)arrayOfColumnHeight[j];
                minimumHeightColumnIndex = j;
            }
            
        }
        
        minimumHeightX = widthOfGapBtnViewColumnsInScrollView + minimumHeightColumnIndex*( widthOfGapBtnColumnsInScrollView + widthOfColumnInScrollView );
        
        
        CGRect imageFrame = CGRectMake(minimumHeightX, minimumHeight, widthOfColumnInScrollView, heightOfPhoto);
        minimumHeight=imageFrame.origin.y+heightOfPhoto+heightOfGapBtnImageOfSameColumn;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageFrame];
        
        UIActivityIndicatorView *activityIndicator = [[ UIActivityIndicatorView alloc] init];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setCenter:CGPointMake(imageFrame.size.width/2, imageFrame.size.height/2)];
        [activityIndicator startAnimating];
        [imageView addSubview:activityIndicator];
        
        imageView.backgroundColor  = [UIColor grayColor];
        imageView.image = nil;
        imageView.layer.borderWidth   = widthOfBorderSurroundedImage;
        imageView.layer.borderColor   = colorOfBorderSurroundedImage.CGColor;
        imageView.layer.cornerRadius  = cornerRadiusOfImage;
        imageView.layer.masksToBounds = isMaskedTheCornerOfImage;
        imageView.tag =i;
        ////NSLog(@"###image tag %i",i);
        [self.scrollViewOfImages addSubview:imageView];
        [dictionaryOfImageViews setObject:imageView forKey:[NSString stringWithFormat:@"%i",i]];
        
        arrayOfColumnHeight[minimumHeightColumnIndex] = minimumHeight;
        
        
        for (int j=0; j < noOfColumn; j++)
        {
            if (maximumHeight < arrayOfColumnHeight[j])
            {
                maximumHeight = (int)arrayOfColumnHeight[j];
            }
        }
        
        self.scrollViewOfImages.contentSize = CGSizeMake(self.scrollViewOfImages.frame.size.width,maximumHeight);
        
        dispatch_queue_t imageFatcherQ = dispatch_queue_create("imageFatcher", nil);
        dispatch_async(imageFatcherQ, ^{
            
            noOfImage = i;
            //-----------------------------
            // Download image from internet
            //-----------------------------
            NSURL *imageUrl = [[NSURL alloc] initWithString:photo.photoURL];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
            
            image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self.dictionaryOfImages setObject:image forKey:[NSString stringWithFormat:@"%li",(long)imageView.tag]];
                
                if (image == nil) {
                    image =  [UIImage imageNamed:@"no_image"];
                } else {
                    image = [imageResizing imageWithImage:image scaledToWidth:widthOfColumnInScrollView];
                    imageView.image = image;
                    ////NSLog(@"ImageView tag :: %li, nrh :: %i",(long)imageView.tag,weakDownloader.tag);
                }
                //////NSLog(@"Image set to %@",photo.photoURL);
                [activityIndicator removeFromSuperview];
                
            
            });
        });
        
        
    }
    
    ////NSLog(@"****************************************");
    ////NSLog(@"#      ScrollView.m console o/p        #");
    ////NSLog(@"#      NO of Image :: %lu              #",(unsigned long)[arrayOfImageUrlStringSource count]);
    ////NSLog(@"****************************************");
}

//---------------
// Set Background
//---------------
- (void) setBackground{
    
    if (backgroundImage == nil) {
        self.backgroundColor = [UIColor clearColor];
        backgroundImageview.backgroundColor = [UIColor clearColor];
        scrollViewOfImages.backgroundColor = [UIColor clearColor];
        
    } else {
        backgroundImageview.image = backgroundImage;
    }
}


@end
