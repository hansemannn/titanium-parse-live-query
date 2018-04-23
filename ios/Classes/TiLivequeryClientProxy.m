/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryClientProxy.h"
#import "TiLivequeryObjectProxy.h"
#import "TiLivequeryQueryProxy.h"

@implementation TiLivequeryClientProxy

- (PFLiveQueryClient *)client
{
  if (_client == nil) {
    NSString *server = [self valueForKey:@"server"];
    NSString *applicationId = [self valueForKey:@"applicationId"];
    NSString *clientKey = [self valueForKey:@"clientKey"];

    _client = [[PFLiveQueryClient alloc] initWithServer:server
                                          applicationId:applicationId
                                              clientKey:clientKey];
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

- (void)subscribeToQuery:(id)query
{
  ENSURE_SINGLE_ARG(query, TiLivequeryQueryProxy);

  [[self client] subscribeToQuery:[(TiLivequeryQueryProxy *)query query] withHandler:self];
}

- (void)unsubscribeFromQuery:(id)query
{
  ENSURE_SINGLE_ARG(query, TiLivequeryQueryProxy);

  [[self client] unsubscribeFromQuery:[(TiLivequeryQueryProxy *)query query] withHandler:self];
}

#pragma mark Delegates

- (void)liveQuery:(PFQuery<PFObject *> *)query didSubscribeInClient:(PFLiveQueryClient *)client
{
  if ([self _hasListeners:@"subscribe"]) {
    [self fireEvent:@"subscribe" withObject:@{ @"query" : [[TiLivequeryQueryProxy alloc] _initWithPageContext:self.pageContext andQuery:query] }];
  }
}

- (void)liveQuery:(PFQuery<PFObject *> *)query didUnsubscribeInClient:(PFLiveQueryClient *)client
{
  if ([self _hasListeners:@"unsubscribe"]) {
    [self fireEvent:@"unsubscribe" withObject:@{ @"query" : [[TiLivequeryQueryProxy alloc] _initWithPageContext:self.pageContext andQuery:query] }];
  }
}

- (void)liveQuery:(PFQuery<PFObject *> *)query didRecieveEvent:(PFLiveQueryEvent *)event inClient:(PFLiveQueryClient *)client
{
  if ([self _hasListeners:@"event"]) {
    [self fireEvent:@"event"
         withObject:@{
           @"type" : @(event.type),
           @"object" : [[TiLivequeryObjectProxy alloc] _initWithPageContext:self.pageContext andObject:event.object],
           @"query" : [[TiLivequeryQueryProxy alloc] _initWithPageContext:self.pageContext andQuery:query]
         }];
  }
}

- (void)liveQuery:(PFQuery<PFObject *> *)query didEncounterError:(NSError *)error inClient:(PFLiveQueryClient *)client
{
  if ([self _hasListeners:@"error"]) {
    [self fireEvent:@"error"
         withObject:@{
           @"error" : error.localizedDescription,
           @"query" : [[TiLivequeryQueryProxy alloc] _initWithPageContext:self.pageContext andQuery:query]
         }];
  }
}

@end
