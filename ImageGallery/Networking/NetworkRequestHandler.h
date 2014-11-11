//
//  NetworkRequestHandler.h
//  PasingTest
//
//  Created by Sandip Saha on 18/09/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface NetworkRequestHandler : NSObject

@property(nonatomic)                        int     tag;
//----------------Input Values which will be assigned to the following properties---------------
@property(strong,nonatomic)            NSString     *baseURL;               //the base URL,or the URL of the file to be downloaded,
                                                                            //if not given default will be set
@property(strong,nonatomic)            NSString     *objectPathInURL;       //object specfic path
@property(strong,nonatomic)        NSDictionary     *requestDataDictionary; //values which is to be sent over the network is to
                                                                            //be kept in this dictionaryusing key value pair

//------------------------Own Property-------------------
@property(strong,nonatomic)       NSMutableData     *responseData;         //the data which is to be downloaded
@property(strong,nonatomic)            NSString     *responseString;       //the downloaded data as string
@property(strong,nonatomic)            NSString     *responseStatusCode;   //the response-status code of the request
@property(strong,nonatomic)            NSString     *responseStatusString; //incase of error it cointains the domain specific ERROR  Code
@property(strong,nonatomic)     NSURLConnection     *getConnection;        //will make a GET connection to fetch JSON
@property(strong,nonatomic)        NSDictionary     *httpResponseHeaders;       //will save all the HTTP header key value pairs 



@property                                 float     uploadProgressionFraction;
@property                                 float     downloadProgressionFraction;
@property                             long long     totalBytesToBeDownloaded;
@property                             long long     bytesDownloadedSoFar;
@property                                 float     timeOutInterval;


//***********************************************************************
//      The dedicated init method to POST user's simple data to the server/or to download a file from a server
//***********************************************************************
-(id)initWithBaseURLString:(NSString*)inputBaseURL
           objectPathInURL:(NSString*)inputObjectPath
               dataDictionaryToPost:(NSDictionary*)dataDictionary;



//***********************************************************************
//      The dedicated init method to POST user's binary data to the server
//***********************************************************************
-(id)initToUpLoadDataWithBaseURLString:(NSString*)inputBaseURL
                         objectPathInURL:(NSString*)inputObjectPath
                    dataDictionaryToPost:(NSDictionary*)uploadDataDictionary;




//-------------Methods to handel download data---------
-(void)startDownload;//  Starts the download procedure
-(void)startDownloadWithAcessToken:(NSString *)token;
-(void)calcelDownload;//Cancels the download


//-------------Method to upload binary Raw data----------
-(void)startUpload;
-(void)cancelUpload;

//------------Methods to find file name and  file MIME type from file path
-(NSString*)fileNameFromFilePath:(NSString*)filePath;
-(NSString*)fileMimeTypeFromFilePath:(NSString*)filePath;




//  This completion block will be set from the area  where this downloader/uploader
//  is required and this block will be executed after successfully upload/download
@property(nonatomic,copy)void(^completionHandler)(void);


//  This progressReporter block will be set from the area  where this downloader/uploader
//  is required and this block will be executed to show the upload/download progess
@property(nonatomic,copy)void(^progressReporter)(void);


//  This errorHandler block will be set from the area  where this downloader/uploader
//  is required and this block will be executed to inform network activity failue
@property(nonatomic,copy)void(^errorHandler)(NSError *error);



@end
