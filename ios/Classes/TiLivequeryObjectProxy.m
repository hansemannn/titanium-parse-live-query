/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryObjectProxy.h"

@implementation TiLivequeryObjectProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andObject:(PFObject *)object
{
  if (self = [super _initWithPageContext:context]) {
    _object = object;
  }

  return self;
}

- (NSString *)parseClassName
{
  return [_object parseClassName];
}

- (NSString *)objectId
{
  return [_object objectId];
}

- (NSDate *)createdAt
{
  return [_object createdAt];
}

- (NSDate *)updatedAt
{
  return [_object updatedAt];
}

- (NSArray<NSString *> *)allKeys
{
  return [_object allKeys];
}

- (id)objectForKey:(id)key
{
  ENSURE_SINGLE_ARG(key, NSObject);
  return [_object objectForKey:key];
}

- (void)setObjectForKey:(id)args
{
  id object = [args objectAtIndex:0];
  id key = [args objectAtIndex:1];

  return [_object setObject:object forKey:key];
}

- (void)removeObjectForKey:(id)key
{
  ENSURE_SINGLE_ARG(key, NSObject);
  return [_object removeObjectForKey:key];
}

- (NSNumber *)deleteObject:(id)value
{
  ENSURE_TYPE_OR_NIL(value, KrollCallback);

  if (value == nil) {
    return @([_object delete]);
  } else {
    [_object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [value call:@[ @{ @"success" : @(succeeded),
        @"error" : error ? error.localizedDescription : [NSNull null] } ]
          thisObject:self];
    }];
    return nil;
  }
}

- (NSNumber *)saveObject:(id)value
{
  ENSURE_TYPE_OR_NIL(value, KrollCallback);

  if (value == nil) {
    return @([_object save]);
  } else {
    [_object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [value call:@[ @{ @"success" : @(succeeded),
        @"error" : error ? error.localizedDescription : [NSNull null] } ]
          thisObject:self];
    }];
    return nil;
  }
}

@end
