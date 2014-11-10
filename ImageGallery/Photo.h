//
//  Photo.h
//  Locatr
//
//  Created by Sauvik Dolui on 10/20/14.
//  Copyright (c) 2014 Innofied Solution Pvt. Ltd. All rights reserved.
//

@protocol Photo <NSObject>

@end


@interface Photo : NSObject
@property (assign,nonatomic) int height;
@property (assign,nonatomic) int width;
@property (strong,nonatomic) NSString *photo_reference;


// This is the format to get the url of the photo from photo reference
//https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CoQBegAAAFg5U0y-iQEtUVMfqw4KpXYe60QwJC-wl59NZlcaxSQZNgAhGrjmUKD2NkXatfQF1QRap-PQCx3kMfsKQCcxtkZqQ&key=AddYourOwnKeyHere

@property (strong,nonatomic) NSString *photoURL;

@end
