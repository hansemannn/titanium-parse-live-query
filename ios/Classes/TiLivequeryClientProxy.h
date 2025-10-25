/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <TitaniumKit/TitaniumKit.h>
@import ParseLiveQuery;

@interface TiLivequeryClientProxy : TiProxy <PFLiveQuerySubscriptionHandling> {
  PFLiveQueryClient *_client;
}

- (void)reconnect:(id)unused;

- (void)disconnect:(id)unused;

- (NSNumber *)isConnected:(id)unused;

@end
