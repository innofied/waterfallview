//
//  SettingViewController.m
//  ImageGallery
//
//  Created by Sandip Saha on 10/10/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    CGFloat widthOfScreen ;
    CGFloat heightOfScreen ;
    UITapGestureRecognizer *recognizer;
}
@synthesize assetLibraryAccessor;
@synthesize scrollView;
@synthesize imageUrlArray;

@synthesize widthOfColumnInScrollView;
@synthesize widthOfGapBtnColumnsInScrollView;
@synthesize widthOfGapBtnViewColumnsInScrollView;
@synthesize heightOfGapBtnImageOfSameColumn;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    imageUrlArray = [[NSMutableArray alloc] initWithCapacity:1];
    CGRect frameOfScreen = [[UIScreen mainScreen] bounds];
    widthOfScreen = frameOfScreen.size.width;
    heightOfScreen = frameOfScreen.size.height;
    NSLog(@"widthOfScreen : %f heightOfscren %f",widthOfScreen,heightOfScreen);
    scrollView = [[MKImageGalleryScrollView alloc] initWithFrame:CGRectMake(0, 0, widthOfScreen   , heightOfScreen)];
    scrollView.widthOfColumnInScrollView           =100;
    scrollView.widthOfGapBtnColumnsInScrollView    =5;
    scrollView.widthOfGapBtnViewColumnsInScrollView=5;
    scrollView.heightOfGapBtnImageOfSameColumn     =5;
    
    scrollView.widthOfBorderSurroundedImage        =5;
    scrollView.colorOfBorderSurroundedImage        =[UIColor whiteColor];
    scrollView.cornerRadiusOfImage                 =5;
    scrollView.isMaskedTheCornerOfImage            =YES;
    
    scrollView.backgroundImage                     = [UIImage imageNamed:@"backGround.png"];
    [self.view addSubview:scrollView];
    
    
    //----------------
    // using image url
    //----------------
    [self addUrlToImageUrlArray];
    [self.scrollView addSubviewToScrollViewFromImageUrlStringArray:imageUrlArray OfColumnNo:3];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    //[self.scrollView.scrollViewOfImages addGestureRecognizer:recognizer];
    
     // get picture from asset library
     /*
     assetLibraryAccessor = [[AssetLibraryAccessor alloc] init];
     [assetLibraryAccessor getAllPictures]; 
     
    __unsafe_unretained typeof(self) weakSelf = self;
    [assetLibraryAccessor setCompletionHandler:^{
        
        NSArray *arrayOfImages = weakSelf.assetLibraryAccessor.imageArrayOfAssetLibraryAccessor;
        //[weakSelf.scrollView addSubviewToScrollViewFromUIImageOfColumnNo:3];
        
        
        weakSelf.widthOfColumnInScrollView           =100;
        weakSelf.widthOfGapBtnColumnsInScrollView    =5;
        weakSelf.widthOfGapBtnViewColumnsInScrollView=5;
        weakSelf.heightOfGapBtnImageOfSameColumn     =5;
        [weakSelf.scrollView addSubviewToScrollViewFromUIImageArray:arrayOfImages noOfColumn:3];
    }];
    */
    
}

- (void) tapGestureRecognized:(UITapGestureRecognizer*)gesture
{
        
    CGPoint tapLocation = [gesture locationInView:scrollView.scrollViewOfImages];
    
    
    int i = 0;
    for (UIView *view in self.scrollView.scrollViewOfImages.subviews) {
        
        if (CGRectContainsPoint(view.frame, tapLocation)) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"You have clicked on %li",(long)view.tag] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            break;
        }
        i++;
    }
    
    
}

- (void) addUrlToImageUrlArray
{
    [imageUrlArray addObject:@"http://www.whitegadget.com/attachments/pc-wallpapers/25222d1235656623-nature-photos-wallpapers-images-beautiful-pictures-nature-mountains-photo.jpg"];
    [imageUrlArray addObject:@"http://3.bp.blogspot.com/-YmEyAa4elTo/UDtaclzno9I/AAAAAAAAC-w/JsqwSuoj260/s1600/Beautiful-Nature.jpg"];
    [imageUrlArray addObject:@"http://www.wallsave.com/wallpapers/1920x1080/scenery-of-nature/658761/scenery-of-nature-background-658761.jpg"];
    [imageUrlArray addObject:@"http://www.wallcoo.net/1920x1200/1920x1200_widescreen_wallpaper_nature_01/images/wallcoo.com_1920x1200_Widescreen_Wallpaper_nature_01149_multnomahfalls_1920x1200.jpg"];
    [imageUrlArray addObject:@"http://www.funxone.com/files/2011/11/Best-Of-Nature-Photography-13.jpg"];
    [imageUrlArray addObject:@"http://www.colourbox.com/preview/2619803-244991-big-wild-african-giraffe-walking-in-savanna-game-drive-wildlife-safari-animals-in-natural-habitat-beauty-of-nature-kenya-travel-masai-mara.jpg"];
    [imageUrlArray addObject:@"http://cache.desktopnexus.com/thumbnails/1309401-bigthumbnail.jpg"];
    [imageUrlArray addObject:@"http://th04.deviantart.net/fs10/200H/i/2006/099/c/d/nature_portrait_8_by_blackbutterflypaku.jpg"];
    [imageUrlArray addObject:@"http://wallpaper.pickywallpapers.com/nokia-5233/preview/water-portrait.jpg"];
    [imageUrlArray addObject:@"http://www.wallsave.com/wallpapers/2560x1920/beauty-of-nature/545885/beauty-of-nature-field-sunflowers-beautiful-clouds-hi-545885.jpg"];
    [imageUrlArray addObject:@"http://datastore04.rediff.com/h1500-w1500/thumb/5A5A5B5B4F5C1E5255605568365E655A63672A606D6C/0upnd2vwarhp3y9i.D.0.Copy-of-Nature-Wallpapers-9.jpg"];
    [imageUrlArray addObject:@"http://wp.1920x1080.org/wp-content/uploads/2011/11/wallpapers-of-nature-546319448.jpg"];
    [imageUrlArray addObject:@"http://www.wallcoo.net/nature/amazing%20hd%20landscapes%20wallpapers/wallpapers/1600x1200/%5Bwallcoo_com%5D_Beautiful%20Nature%20%20HD%20Landscape%2020.jpg"];
    [imageUrlArray addObject:@"http://wp.1920x1080.org/wp-content/uploads/2011/11/wallpapers-of-nature-575376234.jpg"];
    [imageUrlArray addObject:@"http://www.bigpicture.in/wp-content/uploads/2010/07/LatestCollectionOfNaturePhotosByIustyn11.jpg"];
    [imageUrlArray addObject:@"http://img.tradeindia.com/fp/1/377/778.jpg"];
    [imageUrlArray addObject:@"http://behance.vo.llnwd.net/profiles17/1327451/projects/4862239/b3d14c57055cd37557105b6d0baebcfc.jpg"];
    [imageUrlArray addObject:@"http://3.bp.blogspot.com/-ls3LcSetQdw/TmUwikE1ljI/AAAAAAAAFtM/MU87FnNvXT4/s1600/mobile_wallpaper_nature%2B%25281%2529.jpg"];
    [imageUrlArray addObject:@"http://cache4.indulgy.net/j3/z4/b/0203a4b04dd7c1XL.jpg"];
    [imageUrlArray addObject:@"http://carlylove.files.wordpress.com/2011/07/016.jpg"];
    [imageUrlArray addObject:@"http://4.bp.blogspot.com/-uc1hO9wWYnY/T-3ir12mTVI/AAAAAAAAOy4/9mx0UP3Hq6A/s1600/Leonid+Andreyev++Vammasluu+At+Sunset.jpg"];
    [imageUrlArray addObject:@"http://lijiun.files.wordpress.com/2013/05/p1010003.jpg"];
    [imageUrlArray addObject:@"http://thefabweb.com/wp-content/uploads/2012/03/Sunny-Side-Up.jpg"];
    [imageUrlArray addObject:@"http://thefabweb.com/wp-content/uploads/2012/03/Cherry-Trees1.jpg"];
    [imageUrlArray addObject:@"http://browseideas.com/wp-content/uploads/2011/11/Inspiring-Examples-of-Nature-Photography-06.jpg"];
    [imageUrlArray addObject:@"http://viewfromnaturalflorida.files.wordpress.com/2013/03/saucer-magnolia-under-blue-sky-web.jpg"];
    [imageUrlArray addObject:@"http://www.wallsave.com/wallpapers/1280x800/new-love-nature/517518/new-love-nature-hd-staircase-stairs-of-related-517518.jpg"];
    [imageUrlArray addObject:@"http://thefabweb.com/wp-content/uploads/2012/06/1210.jpg"];
    [imageUrlArray addObject:@"http://thefabweb.com/wp-content/uploads/2012/06/88.jpg"];
    [imageUrlArray addObject:@"http://bookurgift.com/images/111.jpg"];
    [imageUrlArray addObject:@"http://images4.fanpop.com/image/photos/23800000/Pink-flowers-pink-color-23830799-1920-1233.jpg"];
    
    [imageUrlArray addObject:@"http://4.bp.blogspot.com/-ik3E8PBBf70/TwaZ9PMNbrI/AAAAAAAAAG0/kNrGnEbZ-WY/s640/flowers2.jpg"];
    
    
}


/*********************************************************************************
 Animate Rotation
 *********************************************************************************/
 
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.scrollView removeFromSuperview];
        scrollView = [[MKImageGalleryScrollView alloc] initWithFrame:CGRectMake(0, 0, heightOfScreen   , widthOfScreen)];
        
        scrollView.widthOfColumnInScrollView           =([UIScreen mainScreen].bounds.size.width - 30)/5;
        scrollView.widthOfGapBtnColumnsInScrollView    =5;
        scrollView.widthOfGapBtnViewColumnsInScrollView=5;
        scrollView.heightOfGapBtnImageOfSameColumn     =5;
        
        scrollView.widthOfBorderSurroundedImage        =5;
        scrollView.colorOfBorderSurroundedImage        =[UIColor whiteColor];
        scrollView.cornerRadiusOfImage                 =5;
        scrollView.isMaskedTheCornerOfImage            =YES;
        
        scrollView.backgroundImage                     = [UIImage imageNamed:@"backGround.png"];
        [self.view addSubview:scrollView];
        [self.scrollView addSubviewToScrollViewFromImageUrlStringArray:imageUrlArray OfColumnNo:5];
        [self.scrollView addGestureRecognizer:recognizer];
        NSLog(@"Change to custom UI for landscape");
        
        //scrollView.arrayOfUIImage = assetLibraryAccessor.imageArrayOfAssetLibraryAccessor;
        //[scrollView addSubviewToScrollViewFromUIImageOfColumnNo:5];
        
                
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
             toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self.scrollView removeFromSuperview];
        scrollView = [[MKImageGalleryScrollView alloc] initWithFrame:CGRectMake(0, 0, widthOfScreen   , heightOfScreen)];
        
        scrollView.widthOfColumnInScrollView           =([UIScreen mainScreen].bounds.size.width - 20)/5;
        scrollView.widthOfGapBtnColumnsInScrollView    =5;
        scrollView.widthOfGapBtnViewColumnsInScrollView=5;
        scrollView.heightOfGapBtnImageOfSameColumn     =5;
        
        scrollView.widthOfBorderSurroundedImage        =5;
        scrollView.colorOfBorderSurroundedImage        =[UIColor whiteColor];
        scrollView.cornerRadiusOfImage                 =5;
        scrollView.isMaskedTheCornerOfImage            =YES;
        
        scrollView.backgroundImage                     = [UIImage imageNamed:@"backGround.png"];
        [self.view addSubview:scrollView];
        [self.scrollView addSubviewToScrollViewFromImageUrlStringArray:imageUrlArray OfColumnNo:3];
        [self.scrollView addGestureRecognizer:recognizer];
        NSLog(@"Change to custom UI for portrait");
       
    }
}


@end
