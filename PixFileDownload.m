//
//  PixFileDownload.m
//  FileDownLoadApp
//
//  Created by Aaron Saunders on 9/8/10.
//

#import "PixFileDownload.h"


@implementation PixFileDownload



-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (PixFileDownload*)[super initWithWebView:theWebView];
    return self;
}



//
// entry point to  the javascript plugin for PhoneGap
//
-(void) downloadFile:(NSMutableArray*)paramArray withDict:(NSMutableDictionary*)options {
	
	NSLog(@"in PixFileDownload.downloadFile",nil);
	NSString * sourceUrl = [paramArray objectAtIndex:0];
	NSString * fileName = [paramArray objectAtIndex:1];
	//NSString * completionCallback = [paramArray objectAtIndex:2];
	
	params = [[NSMutableArray alloc] initWithCapacity:2];	
	[params addObject:sourceUrl];
	[params addObject:fileName];
	
	[self downloadFileFromUrl:params];
}

//
// call to excute the download in a background thread
//
-(void) downloadFileFromUrl:(NSMutableArray*)paramArray
{
	NSLog(@"in PixFileDownload.downloadFileFromUrl",nil);
	[self performSelectorInBackground: @selector( downloadFileFromUrlInBackgroundTask ) withObject: paramArray waitUntilDone:NO];
}

//
// downloads the file in the background and saves it to the local documents
// directory for the application
//
-(void) downloadFileFromUrlInBackgroundTask:(NSMutableArray*)paramArray
{
	NSLog(@"in PixFileDownload.downloadFileFromUrlInBackgroundTask",nil);
	NSString * sourceUrl = [paramArray objectAtIndex:0];
	NSString * fileName = [paramArray objectAtIndex:1];
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSData* theData = [NSData dataWithContentsOfURL: [NSURL URLWithString:sourceUrl] ];
	
	// save file in documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];	
	
	NSString *newFilePath = [documentsDirectory stringByAppendingString:fileName];
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSError *error=[[[NSError alloc]init] autorelease]; 
	
	BOOL response = [theData writeToFile:newFilePath options:NSDataWritingFileProtectionNone error:&error];
	
	NSLog(@"file save result %@", response);
	
    // send our results back to the main thread  
    [self performSelectorOnMainThread:@selector(downloadComplete:)  
						   withObject:nil waitUntilDone:NO];  	
	
	[pool drain];
}

//
// calls the predefined callback in the ui to indicate completion
//
-(void) downloadComplete:(NSString *)filePath 
{
	NSLog(@"in PixFileDownload.downloadComplete",nil);	
	NSString * jsCallBack = [NSString stringWithFormat:@"pixFileDownloadComplete('%@');",@"return message to ui"];    
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];	
}

- (void)dealloc
{
	if (params) {
		[params release];
	}
    [super dealloc];
}


@end