/**
 * iAdAttributes
 *
 * Created by Your Name
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "ComGaurangIadattributesModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <iAd/iAd.h>

@implementation ComGaurangIadattributesModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"2762016e-1a30-4f8d-b7f5-e648df2f48d1";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.gaurang.iadattributes";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

- (void)getAnaliticsDataWithBlockNew {
    
    if (![[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        //callback([[NSString alloc]initWithFormat:@"{message : \"API is too older\"}"]);
        [self fireEvent:@"analyticsInfo" withObject:@{@"message" : @"API is too older"}];
        
        return;
    }
    
    [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *details, NSError *error) {
        if (error) {
            NSLog(@"requestAttributionDetailsWithBlock returned error: %@", error);
            //            callback([[NSString alloc]initWithFormat:@"{message : \"%@\"}",error.localizedDescription]);
            [self fireEvent:@"analyticsInfo" withObject:@{@"message" : error.localizedDescription}];
            return;
        }
        
        NSDictionary *attributionInfo = details[@"Version3.1"];
        if (!attributionInfo) {
            NSLog(@"no details for version 3.1: %@", details);
            
            //            callback([[NSString alloc]initWithFormat:@"{message : \"No details for version 3.1: %@\"}",details]);
            [self fireEvent:@"analyticsInfo" withObject:@{@"message" : details}];
            
            return;
        }
        
        NSDictionary *attributionContext = @{
                                             @"campaign" : @{
                                                     @"iad-attribution" : @"iad-attribution",
                                                     @"iad-click-date" : attributionInfo[@"iad-click-date"] ?: @"unknown",
                                                     @"iad-conversion-date" : attributionInfo[@"iad-conversion-date"] ?: @"unknown",
                                                     @"iad-org-name" : attributionInfo[@"iad-org-name"] ?: @"unknown",
                                                     @"iad-campaign-id" : attributionInfo[@"iad-campaign-id"] ?: @"unknown",
                                                     @"iad-campaign-name" : attributionInfo[@"iad-campaign-name"] ?: @"unknown",
                                                     @"iad-adgroup-id" : attributionInfo[@"iad-adgroup-id"] ?: @"unknown",
                                                     @"iad-adgroup-name" : attributionInfo[@"iad-adgroup-name"] ?: @"unknown",
                                                     @"iad-keyword" : attributionInfo[@"iad-keyword"] ?: @"unknown"
                                                     }
                                             };
        
        NSMutableDictionary *mergedContext = [NSMutableDictionary dictionaryWithCapacity:attributionContext.count];
        [mergedContext addEntriesFromDictionary:attributionContext];
        NSLog(@"=== >> %@", mergedContext);
        
        NSError *errorJson;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mergedContext
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&errorJson];
        NSString * string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (errorJson != nil){
            //            callback([[NSString alloc]initWithFormat:@"{message : \"%@\"}",errorJson.localizedDescription]);
            [self fireEvent:@"analyticsInfo" withObject:@{@"message" : errorJson.localizedDescription}];
        }
        else if (errorJson == nil && string != nil) {
            //            callback(string);
            [self fireEvent:@"analyticsInfo" withObject:@{@"message" : string}];
        }else {
            //            callback([[NSString alloc]initWithFormat:@"{message : \"Invalid Access\"}"]);
            [self fireEvent:@"analyticsInfo" withObject:@{@"message" : @"Invalid Access"}];
        }
    }];
    
    
}


-(id)example:(id)args
{
	// example method
    [self getAnaliticsDataWithBlockNew];
//    [self fireEvent:@"testevent" withObject:@{@"name": @"foo"}];
	return @"hello world";
    
}
-(id)getAttribution:(id)args
{
    [self getAnaliticsDataWithBlockNew];
    return @"Calling Attribution API";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
