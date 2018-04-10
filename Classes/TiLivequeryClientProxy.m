/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryClientProxy.h"

@implementation TiLivequeryClientProxy

- (PFLiveQueryClient *)client
{
  if (_client == nil) {
    NSString *server = [self valueForKey:@"server"];
    NSString *applicationId = [self valueForKey:@"applicationId"];
    NSString *clientId = [self valueForKey:@"clientId"];

    _client = [[PFLiveQueryClient alloc] initWithServer:server
                                applicationId:applicationId
                                    clientKey:clientId];    
  }
  
  return _client;
}

- (void)reconnect:(id)unused
{
  [[self client] reconnect];
}

- (void)disconnect:(id)unused
{
  [[self client] disconnect];
}

- (NSNumber *)isConnected:(id)unused
{
  return @([[self client] userDisconnected] == NO);
}

@end
