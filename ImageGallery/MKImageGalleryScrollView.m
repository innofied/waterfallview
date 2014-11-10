//
//  ScrollView.m
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "MKImageGalleryScrollView.h"
#import "Photo.h"

@interface MKImageGalleryScrollView()
{
    UIImage *image ;
    int noOfImage;
    NSInteger arrayOfColumnHeight[10];
    ImageResizing *imageResizing;
    UIImageView   *backgroundImageview;
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
        
    }
    return self;
}


- (void) addSubviewToScrollViewFromUIImageArray:(NSArray *)arrayOfUIImageSource
                                     noOfColumn:(int)noOfColumn
{
    backgroundImageview.image = backgroundImage;
    
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
    backgroundImageview.image = backgroundImage;
    
    
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
    
    for (int i=0;i<[arrayOfImageUrlStringSource count];i++)
    {
        
        
        dispatch_queue_t imageFatcherQ = dispatch_queue_create("imageFatcher", nil);
        dispatch_async(imageFatcherQ, ^{
            
            noOfImage = i;
            //-----------------------------
            // Download image from internet
            //-----------------------------
            NSURL *imageUrl = [[NSURL alloc] initWithString:[arrayOfImageUrlStringSource objectAtIndex:i]];
            [imageUrl setTag:i];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
            
            image = [UIImage imageWithData:imageData];
            
            // If image downloaded
            if(image != nil){
                [image setTag:[imageUrl tag]];
                NSLog(@"#image tag %i %@",[image tag],image);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"##image tag %i %@",[image tag],image);
                    
                    int individual = [image tag];
                    //----------------
                    // resize image
                    //----------------
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
                    
                });
            }
            
           
        
        });
        
        
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
    //[self setBackground];
    
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
