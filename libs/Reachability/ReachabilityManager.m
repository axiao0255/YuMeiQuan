//
//  ReachabilityManager.m
//  GIS
//
//  Created by cooliceman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

@synthesize status;
static ReachabilityManager *_instance=nil;

-(void) initReachabilities{
	internetReachability=[[Reachability reachabilityForInternetConnection] retain];
	wifiReachability=[[Reachability reachabilityForLocalWiFi] retain];
	status=NO;
}
+(ReachabilityManager *) sharedInstance{
	if (_instance==nil) {
		_instance=[[ReachabilityManager alloc] init];
		[_instance initReachabilities];
	}
	return _instance;
}

-(void) updateNetStatusWithReachability:(Reachability *)curReach{
	NSLog(@"更新网络状态");
	NetworkStatus netStatus=[curReach currentReachabilityStatus];
	status=NO;
	
	if (curReach==internetReachability) {
		
		BOOL connectionRequired=[curReach connectionRequired];
		
		switch (netStatus) {
			case NotReachable:
				connectionRequired=NO;
				internetReachable=NO;
				break;
			default:
				internetReachable=YES;
				break;
		}
		if (connectionRequired) {
			NSLog(@"需要激活");
		}
		
	}else if (curReach==wifiReachability) {
		switch (netStatus) {
			case NotReachable:
				wifiReachable=NO;
				break;
			default:
				wifiReachable=YES;
				break;
		}
			
	}
    if (internetReachable||wifiReachable) {
        status=YES;
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reachUnable" object:nil];
    }
#ifdef DEBUG
    NSLog(@"网络状态:%@",status==YES?@"可用":@"不可用");
#endif
}
-(void) reachabilityChanged:(NSNotification *)notification{
	Reachability* curReach = [notification object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateNetStatusWithReachability: curReach];
		
}
-(void) startMonitor{
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) 
												 name: kReachabilityChangedNotification object: nil];
	[internetReachability startNotifier];
	[self updateNetStatusWithReachability:internetReachability];
	[wifiReachability startNotifier];
	[self updateNetStatusWithReachability:wifiReachability];
}
-(void) stopMonitor{
	[internetReachability stopNotifier];
	[wifiReachability stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification 
												  object:nil];
}

-(void) dealloc{
	[internetReachability release];
	[wifiReachability release];
	[super dealloc];
}
@end
