/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <Parse/Parse.h>

@interface TiLivequeryObjectProxy : TiProxy {
  PFObject *_object;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andObject:(PFObject *)object;

- (NSString *)parseClassName;

- (NSString *)objectId;

- (NSDate *)createdAt;

- (NSDate *)updatedAt;

- (NSArray<NSString *> *)allKeys;

- (id)objectForKey:(id)key;

- (void)setObjectForKey:(id)args;

- (void)removeObjectForKey:(id)key;

- (NSNumber *)deleteObject:(id)unused;

- (NSNumber *)saveObject:(id)unused;

@end
