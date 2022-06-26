/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <Parse/Parse.h>

@interface TiLivequeryObjectProxy : TiProxy {
  PFObject *_object;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andObject:(PFObject *)object;

- (PFObject *)object;

- (NSString *)parseClassName;

- (NSString *)objectId;

- (NSDate *)createdAt;

- (NSDate *)updatedAt;

- (NSArray<NSString *> *)allKeys;

- (id)objectForKey:(id)key;

- (void)add:(id)args;

- (void)remove:(id)key;

- (NSNumber *)deleteObject:(id)unused;

- (NSNumber *)saveObject:(id)unused;

- (void)saveInBackground:(id)unused;

- (void)fetchInBackground:(id)callback;

- (void)pinInBackground:(id)callback;

- (void)unpinInBackground:(id)callback;

- (void)fetchFromLocalDatastoreInBackground:(id)callback;

- (void)fetchIfNeededInBackgroundWithBlock:(id)callback;

- (void)saveEventually:(id)callback;

- (void)deleteEventually:(id)unused;

@end
