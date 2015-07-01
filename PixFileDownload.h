

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>


@interface PixFileDownload : PGPlugin {
	NSMutableArray* params;
}

-(void) downloadFile:(NSMutableArray*)paramArray withDict:(NSMutableDictionary*)options;
-(void) downloadComplete:(NSString *)filePath;
-(void) downloadFileFromUrlInBackgroundTask:(NSMutableArray*)paramArray;
-(void) downloadFileFromUrl:(NSMutableArray*)paramArray;
@end

