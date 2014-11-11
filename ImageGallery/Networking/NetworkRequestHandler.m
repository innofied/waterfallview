//
//  NetworkRequestHandler.m
//  PasingTest
//
//  Created by Sandip Saha on 18/09/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//


#import "NetworkRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define BASE_SERVER_ADDRESS @"http://apps.innofied.com"
#define kDefaultTimeOutInterval 60.0

//to supress the incomplete implementation warning
#pragma clang diagnostic ignored "-Wincomplete-implementation"


@implementation NetworkRequestHandler


//Sysnthesizing properties for the the input data
@synthesize requestDataDictionary,baseURL,objectPathInURL;

//Sysnthesizing the own data properties
@synthesize responseData,responseStatusCode,responseStatusString,responseString,
getConnection,uploadProgressionFraction,totalBytesToBeDownloaded,
bytesDownloadedSoFar,downloadProgressionFraction,httpResponseHeaders,
timeOutInterval;


//**********************************************************************
//        The init method for simple data upload or download
//**********************************************************************
-(id)initWithBaseURLString:(NSString*)inputBaseURL
           objectPathInURL:(NSString*)inputObjectPath
      dataDictionaryToPost:(NSDictionary*)dataDictionary
{
    if(self=[super init])
    {
        if(!inputBaseURL)
        {
            self.baseURL=BASE_SERVER_ADDRESS;
            ////NSLog(@"NetworkRequestHandler WARNING:server base adderss is missing,defauly base address(http://apps.innofied.com) is setted");
        }
        else
        {
            self.baseURL=inputBaseURL;
        }
        
        if(!inputObjectPath && !inputBaseURL)
        {
            ////NSLog(@"NetworkRequestHandler ERROR:baseURL & objectpathInURL both can not be nil,returning nil object ");
            return nil;
        }
        else
        {
            self.objectPathInURL=inputObjectPath;
        }
        
        if(dataDictionary)
        {
            self.requestDataDictionary=dataDictionary;
            ////NSLog(@"NetworkRequestHandler REPORTS:request data dictionary is not nil,user wants a POST connection ");
        }
        else
        {
            ////NSLog(@"NetworkRequestHandler WARNING:request data dictionary is nil,user wants a GET connection ");
            
        }
        
        //allocating memory for the output properties
        
        self.responseStatusString =[[NSString alloc]init];
        self.responseData = [NSMutableData data];
        self.responseString=[[NSString alloc]init];
        
        //Setting the default timeout interval to 20 seconds
        self.timeOutInterval=kDefaultTimeOutInterval;
        
    }
    
    return self;
}


//***************************************************************************************************
//         This init method will be used for multipart data(only image) upload or download         //
//***************************************************************************************************

-(id)initToUpLoadDataWithBaseURLString:(NSString*)inputBaseURL
                       objectPathInURL:(NSString*)inputObjectPath
                  dataDictionaryToPost:(NSDictionary*)uploadDataDictionary
{
    if(self=[super init])
    {
        if(!inputBaseURL)
        {
            self.baseURL=BASE_SERVER_ADDRESS;
            ////NSLog(@"NetworkRequestHandler WARNING:server base adderss is missing,default base address(http://apps.innofied.com) is setted");
        }
        else
        {
            self.baseURL=inputBaseURL;
            
        }
        
        if(!inputObjectPath && !inputBaseURL)
        {
            ////NSLog(@"NetworkRequestHandler ERROR: inputBaseURL & objectpathInURL both can not be nil,returning nil object ");
            return nil;
        }
        else
        {
            self.objectPathInURL=inputObjectPath;
        }
        
        if(uploadDataDictionary)
        {
            self.requestDataDictionary=uploadDataDictionary;
        }
        else
        {
            ////NSLog(@"NetworkRequestHandler ERROR:request data dictionary is nil,OBJECT INITIALIZATION ERROR ,NOTHING TO UPLOAD ,returning nil");
            return nil;
        }
        
        //allocating memory for the output properties
        
        self.responseStatusString =[[NSString alloc]init];
        self.responseData = [NSMutableData data];
        self.responseString=[[NSString alloc]init];
        
        //Setting the default timeout interval to 20 seconds
        self.timeOutInterval=kDefaultTimeOutInterval;
        
    }
    
    return self;
    
    
}

//**************************************************************
//              START DOWNLOAD METHOD
//*************************************************************

-(void)startDownload
{
    if(self.requestDataDictionary)//initializing connection for POST method
    {
        NSURL *url = [NSURL URLWithString:self.baseURL];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.timeoutInterval=self.timeOutInterval;
        
        [httpClient postPath:self.objectPathInURL
                  parameters:self.requestDataDictionary
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //when request is successful then setting the output properties
             
             self.httpResponseHeaders=[operation.response allHeaderFields];
             self.responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             self.responseData=responseObject;
             self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)operation.response.statusCode ];
             
             //-----executing the block of code which is defined from the view
             //      controller/or from where the this Class instance is needed
             if (self.completionHandler)
                 self.completionHandler();
             
             ////NSLog(@"NetworkRequestHandler REPORTS:downloaad request successfull....");
             
         }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)//on failure this block is executed
         {
             
             self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)operation.response.statusCode];
             self.responseStatusString=[NSString stringWithString:error.localizedDescription];
             
             if (self.errorHandler)
                 self.errorHandler(error);
             
             
             ////NSLog(@"NetworkRequestHandler ERROR:%@", error.localizedDescription);
         }];
    }
    else//initializing connection for GET method
    {
        //=================================================
        //  1.Append Base and objectPath URL
        //  2.Set the delegate for this urlConnection
        
        NSString *getURLString;
        if(self.objectPathInURL)
        {
            getURLString=[self.baseURL stringByAppendingString:self.objectPathInURL];
        }
        else{
            getURLString=self.baseURL;
        }
        NSMutableURLRequest *getRequest=[[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:getURLString]];
        getRequest.timeoutInterval=self.timeOutInterval;
        self.getConnection=[[NSURLConnection alloc]initWithRequest:getRequest delegate:self];
    }
    
}



-(void)startDownloadWithAcessToken:(NSString *)token
{
    if(self.requestDataDictionary)//initializing connection for POST method
    {
        NSURL *url = [NSURL URLWithString:self.baseURL];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.timeoutInterval=self.timeOutInterval;
        
        [httpClient setAuthorizationHeaderWithToken:token];
        
        [httpClient putPath:self.objectPathInURL
                  parameters:self.requestDataDictionary
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //when request is successful then setting the output properties
             
             self.httpResponseHeaders=[operation.response allHeaderFields];
             self.responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             self.responseData=responseObject;
             self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)operation.response.statusCode ];
             
             //-----executing the block of code which is defined from the view
             //      controller/or from where the this Class instance is needed
             if (self.completionHandler)
                 self.completionHandler();
             
             ////NSLog(@"NetworkRequestHandler REPORTS:downloaad request successfull....");
             
         }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)//on failure this block is executed
         {
             
             self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)operation.response.statusCode];
             self.responseStatusString=[NSString stringWithString:error.localizedDescription];
             
             if (self.errorHandler)
                 self.errorHandler(error);
             
             
             ////NSLog(@"NetworkRequestHandler ERROR:%@", error.localizedDescription);
         }];
    }
    else//initializing connection for GET method
    {
        //=================================================
        //  1.Append Base and objectPath URL
        //  2.Set the delegate for this urlConnection
        
        NSString *getURLString;
        if(self.objectPathInURL)
        {
            getURLString=[self.baseURL stringByAppendingString:self.objectPathInURL];
        }
        else{
            getURLString=self.baseURL;
        }
        NSMutableURLRequest *getRequest=[[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:getURLString]];
        getRequest.timeoutInterval=self.timeOutInterval;
        self.getConnection=[[NSURLConnection alloc]initWithRequest:getRequest delegate:self];
    }
    
}

//**************************************************************
//              CANCEL DOWNLOAD METHOD
//*************************************************************

-(void)cancelDownload
{
    //=====================TASKS===================
    //  1.Cancel the connection
    //  2.Deallocate all the resources currently consuming memory
    
    self.responseData = nil;
    self.responseString=nil;
    self.requestDataDictionary=nil;
    self.getConnection=nil;
    
    
}




//**************************************************************
//              START UPLOAD METHOD
//**************************************************************

-(void)startUpload
{
    
    NSString *strServerURL = [self.baseURL stringByAppendingString:self.objectPathInURL];
    
    NSURL *URL = [NSURL URLWithString:strServerURL];
    __block AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    client.timeoutInterval=self.timeOutInterval;
    
    //-------------------------Configuring the NSMutable Request---------------------------
    
    __block NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                             path:@""
                                                                       parameters:nil
                                                        constructingBodyWithBlock:
                                            ^(id <AFMultipartFormData>formData)
                                            {
                                                
                                                //************************************************************
                                                //               Request Data Dictionary componemts
                                                //***********************************************************
                                                /*
                                                 requestDataDictionary{
                                                 "simpleDataDictionary":{
                                                 "key1":"value1", //key value pairs of simple data
                                                 "key2":"value2",
                                                 ....
                                                 },
                                                 "attachmentDataDictionary":{
                                                 
                                                 "key1":"file 1 url", //key value pairs of file data
                                                 "key2":"file 2 ulr"
                                                 ....
                                                 
                                                 }
                                                 }
                                                 
                                                 */
                                                
                                                NSDictionary *simpleDataDictionary=[requestDataDictionary objectForKey:@"simpleDataDictionary"];
                                                NSDictionary *attachmentDataDictionary=[requestDataDictionary objectForKey:@"attachmentDataDictionary"];
                                                
                                                
                                                if (!attachmentDataDictionary) {
                                                    ////NSLog(@"NetworkRequestHandler ERROR:No attachmentDataDictionary found,upload cancelled...");
                                                }
                                                else
                                                {
                                                    //Appending simple data to form data
                                                    if (!simpleDataDictionary) {
                                                        ////NSLog(@"NetworkRequestHandler WARNING:No simpleDataDictionary to post");
                                                    }
                                                    else
                                                    {
                                                        NSArray *simpleDataKeys=[simpleDataDictionary allKeys];
                                                        for (NSString *key in simpleDataKeys){
                                                            NSData *simpleData=[[simpleDataDictionary objectForKey:key]  dataUsingEncoding:NSUTF8StringEncoding];
                                                            [formData appendPartWithFormData:simpleData name:key];
                                                        }
                                                    }
                                                    
                                                    int fileCounter=0;
                                                    // Appending attachement data to form data
                                                    NSArray *attachementKeys=[attachmentDataDictionary allKeys];
                                                    for (NSString *key in attachementKeys){
                                                        
                                                        fileCounter++;
                                                        //------fetchin data from the disk-----------------
                                                        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[attachmentDataDictionary objectForKey:key]]];
                                                        NSString *fileName=[self fileNameFromFilePath:[attachmentDataDictionary objectForKey:key]];
                                                        NSString *fileMimeType=[self fileMimeTypeFromFilePath:[attachmentDataDictionary objectForKey:key]];
                                                        [formData appendPartWithFileData:fileData name:key fileName:fileName mimeType:fileMimeType];
                                                        ////NSLog(@"%d:%@  added successfuly to form to be uploaded",fileCounter,fileName);
                                                    }
                                                }
                                            }];
    
    [request setURL:URL];
    [request setTimeoutInterval:self.timeOutInterval];
    [request setHTTPMethod:@"POST"];
    //-----------------------------------------Configured the NSMUtable Request------------------------------------------------
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    
    //=============================Upload Progress Report Generation===========================
    
    [operation setUploadProgressBlock:
     ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         if (totalBytesExpectedToWrite == 0)
         {
             self.uploadProgressionFraction=0.0;
         }
         else
         {
             self.uploadProgressionFraction= totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
             
             //this block of code has been defined from View controller or the class where this object is used
             if(self.progressReporter)
                 self.progressReporter();
         }
     }
     ];
    //=============================Upload Progress Report Generation  ends===========================
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)operation.response.statusCode];
         self.httpResponseHeaders=[operation.response allHeaderFields];
         self.responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         self.responseData=responseObject;

         //-----executing the block of code which is defined from the view
         //      controller/or from where the this Class instance is needed
         if (self.completionHandler)
             self.completionHandler();
         ////NSLog(@"\nNetworkResourceDownloader REPORTS:Image Uploaded successfully.....Status code=%s",[self.responseStatusCode UTF8String]);
         
     }
                                     failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         ////NSLog(@"NetworkResourceDownloader ERROR: %@", error);
         self.responseStatusString=[error localizedDescription];
         ////NSLog(@"\nNetworkResourceDownloader ERROR:Image Upload failed due to %@",self.responseStatusString);
         operation=nil;
         request=nil;
         client=nil;
         
         if (self.errorHandler)
             self.errorHandler(error);
     }
     ];
    
    
    [client enqueueHTTPRequestOperation:operation];
    
}



//=====================================================
//              CANCEL UPLOAD METHOD
//=====================================================
-(void)cancelUpload
{
    ////NSLog(@"NetworkResourceDownloader WARNING:upload cancelled");
    
    self.requestDataDictionary=nil;
    self.completionHandler=nil;
    self.errorHandler=nil;
    self.progressReporter=nil;
    
    
}

-(NSString*)fileNameFromFilePath:(NSString*)filePath
{
    return [filePath lastPathComponent];
}

-(NSString*)fileMimeTypeFromFilePath:(NSString*)filePath
{
    
    NSString *fileExtention=[filePath pathExtension];
    NSString *mimeType=@"";
    
    //*******************************************
    //          HANDILING IMAGE FILES
    //*******************************************
    
    if([fileExtention isEqualToString:@"jpg"] ||
       [fileExtention isEqualToString:@"jpeg"]||
       [fileExtention isEqualToString:@"jpe"])  //JEPG,JPG,JPE
    {
        mimeType=@"image/jpg";
    }
    else if ([fileExtention isEqualToString:@"png"]) //PNG
    {
        mimeType=@"image/jpg";
    }
    else if([fileExtention isEqualToString:@"gif"])  //GIF
    {
        mimeType=@"image/gif";
    }
    
    
    
    //*******************************************
    //          HANDILING VIDEO FILES
    //*******************************************
    
    if ([fileExtention isEqualToString:@"3gp"]) {   //3GP
        mimeType=@"video/3gpp";
    }
    else if ([fileExtention isEqualToString:@"mp4"] ||
             [fileExtention isEqualToString:@"m4a"]) //MP4 ,M4A
    {
        mimeType=@"video/mp4";
    }
    else if ([fileExtention isEqualToString:@"mkv"])  //MKV
    {
        mimeType=@"video/x-matroska";
    }
    else if ([fileExtention isEqualToString:@"mov"])   //MOV
    {
        mimeType=@"video/quicktime";
    }
    else if ([fileExtention isEqualToString:@"avi"])   //AVI
    {
        mimeType=@"video/x-msvideo";
    }
    else if ([fileExtention isEqualToString:@"wmv"])   //WMV
    {
        mimeType=@"video/x-ms-wmv";
    }
    else if ([fileExtention isEqualToString:@"m3u8"])  //M3U8
    {
        mimeType=@"application/x-mpegURL";
    }
    
    
    
    //*******************************************
    //          HANDILING AUDIO FILES
    //*******************************************
    
    if ([fileExtention isEqualToString:@"aac"]) {
        mimeType=@"audio/aac";
    }
    else if ([fileExtention isEqualToString:@"mp1"] ||
             [fileExtention isEqualToString:@"mp2"] ||
             [fileExtention isEqualToString:@"mp3"] ||
             [fileExtention isEqualToString:@"mpg"] ||
             [fileExtention isEqualToString:@"mpeg"])   //MPx120
    {
        mimeType=@"audio/mpeg";
    }
    else if ([fileExtention isEqualToString:@"wav"])    //WAV
    {
        mimeType=@"audio/wav";
    }
    else if ([fileExtention isEqualToString:@"webm"])   //WEBM
    {
        mimeType=@"audio/webm";
    }
    //********************************************
    
    
    
    
    //********************************************
    //      HANDLING DOCUMENTS FILES
    //********************************************
    if ([fileExtention isEqualToString:@"txt"]) {
        mimeType=@"text/plain";                          //TXT
    }
    else if ([fileExtention isEqualToString:@"docx"] ||
             [fileExtention isEqualToString:@"doc"])     //WORD
    {
        mimeType=@"application/msword";
    }
    else if ([fileExtention isEqualToString:@"xlsx"] ||
             [fileExtention isEqualToString:@"xlsm"] ||
             [fileExtention isEqualToString:@"xlsb"] ||
             [fileExtention isEqualToString:@"xls"])     //EXCEL
    {
        mimeType=@"application/vnd.ms-excel";
    }
    else if ([fileExtention isEqualToString:@"ppt"]||
             [fileExtention isEqualToString:@"pptx"])    //PPT
    {
        mimeType=@"application/vnd.ms-powerpoint";
    }
    else if ([fileExtention isEqualToString:@"rar"])     //RAR
    {
        mimeType=@"application/x-rar-compressed";
    }
    else if ([fileExtention isEqualToString:@"zip"])     //ZIP
    {
        mimeType=@"application/zip";
    }
    else if ([fileExtention isEqualToString:@"pdf"])     //PDF
    {
        mimeType=@"application/pdf";
    }
    
    
    //REPORTING ERROR FOR NOT SUPPORTED FILE FORMATS
    if ([mimeType isEqualToString:@""])
    {
        ////NSLog(@"NetworkRequestHandler WARNING:File type(%@) not supported for upload,DEFAULT MIME-TYPE(application/octet-stream) taken",fileExtention);
        mimeType=@"application/octet-stream";
        
    }
    
    //******************JUST TRYING TO FIND-OUT MIME TYPE OF THE FILE FROM THE FILE EXTENTION*****************
    
    /*CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
     CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
     CFRelease(pathExtension);
     
     // The UTI can be converted to a mime type:
     
     = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
     */
    //***************************IS NOT WORKING PROPERLY*******************************************************
    
    return mimeType;
    
}



//*****************************SIMPLE GET CONNECTION IS BEING MANUPULATED BY NSURLConnectionDelegate METHODS****************

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.responseData appendData:data];
    self.bytesDownloadedSoFar=responseData.length;
    self.downloadProgressionFraction=self.bytesDownloadedSoFar*1.0 /self.totalBytesToBeDownloaded;
    
    if (totalBytesToBeDownloaded>=0) {
        if(self.progressReporter)
            self.progressReporter();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseStatusString=[error localizedDescription];
    self.responseStatusCode=@"404";
    [self cancelDownload];
    if (self.errorHandler)
        self.errorHandler(error);
    ////NSLog(@"\nNetworkResourceDownloader ERROR:Connection failed...All resources released...");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    self.responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    // calling our completion handler block
    if (self.completionHandler)
        self.completionHandler();
    
    [self cancelDownload];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    self.totalBytesToBeDownloaded=[response expectedContentLength];
    if (totalBytesToBeDownloaded<=0) {
        ////NSLog(@"\nNetworkRequestHandler ERROR:Download size not known,download progress can't be calculated");
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    self.httpResponseHeaders=[httpResponse allHeaderFields];
    self.responseStatusCode=[NSString stringWithFormat:@"%li",(long)[httpResponse statusCode]];
}


@end
