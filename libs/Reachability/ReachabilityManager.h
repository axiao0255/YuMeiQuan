//
//  ReachabilityManager.h
//  GIS
//
//  Created by cooliceman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
/**
 网络状况管理器
 */
@interface ReachabilityManager : NSObject {
	Reachability *internetReachability;
	Reachability *wifiReachability;
	BOOL status;
	@private 
	BOOL internetReachable;
	BOOL wifiReachable;
}

@property  BOOL status;

+(ReachabilityManager *) sharedInstance;
-(void) startMonitor;
-(void) stopMonitor;
-(void) reachabilityChanged:(NSNotification *)notification;
@end
