/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <Parse/Parse.h>
#import <ParseLiveQuery/ParseLiveQuery-Swift.h>

@interface TiLivequeryClientProxy : TiProxy<PFLiveQuerySubscriptionHandling> {
  PFLiveQueryClient *_client;
}

- (void)reconnect:(id)unused;

- (void)disconnect:(id)unused;

- (NSNumber *)isConnected:(id)unused;

@end
