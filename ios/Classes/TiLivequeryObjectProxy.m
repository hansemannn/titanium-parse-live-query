/**
 * Copyright (c) 2021-present by Hans Knöchel
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

- (void)add:(id)args
{
  id key = [args objectAtIndex:0];
  id value = [args objectAtIndex:1];

  NSLog(@"[WARN] key = %@", key);
  NSLog(@"[WARN] value = %@", value);

  return [_object setObject:value forKey:key];
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

- (NSNumber *)saveObject:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    return @([_object save]);
  } else {
    [_object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      [callback call:@[ @{ @"success" : @(succeeded),
        @"error" : error ? error.localizedDescription : [NSNull null] } ]
          thisObject:self];
    }];
    return nil;
  }
}

- (void)fetchInBackground:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    [_object fetchInBackground];
  } else {
    [_object fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
      [callback call:@[ @{
        @"success" : @(error == nil),
        @"error" : error ? error.localizedDescription : [NSNull null],
        @"object": [[TiLivequeryObjectProxy alloc] _initWithPageContext:self.pageContext andObject:object]
      } ] thisObject:self];
    }];
  }
}

- (void)pinInBackground:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    [_object pinInBackground];
  } else {
    [_object pinInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
      [callback call:@[ @{
        @"success" : @(error == nil),
        @"error" : error ? error.localizedDescription : [NSNull null]
      } ] thisObject:self];
    }];
  }
}

- (void)unpinInBackground:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    [_object unpinInBackground];
  } else {
    [_object unpinInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
      [callback call:@[ @{
        @"success" : @(error == nil),
        @"error" : error ? error.localizedDescription : [NSNull null]
      } ] thisObject:self];
    }];
  }
}

- (void)fetchFromLocalDatastoreInBackground:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    [_object fetchFromLocalDatastoreInBackground];
  } else {
    [_object fetchFromLocalDatastoreInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
      [callback call:@[ @{
        @"success" : @(error == nil),
        @"error" : error ? error.localizedDescription : [NSNull null],
        @"object": [[TiLivequeryObjectProxy alloc] _initWithPageContext:self.pageContext andObject:object]
      } ] thisObject:self];
    }];
  }
}
- (void)saveEventually:(id)callback
{
  ENSURE_TYPE_OR_NIL(callback, KrollCallback);

  if (callback == nil) {
    [_object saveEventually];
  } else {
    [_object saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
      [callback call:@[ @{
        @"success" : @(error == nil),
        @"error" : error ? error.localizedDescription : [NSNull null]
      } ] thisObject:self];
    }];
  }
}

- (void)deleteEventually:(id)unused
{
  [_object deleteEventually];
}


@end
