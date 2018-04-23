/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryQueryProxy.h"
#import "TiLivequeryObjectProxy.h"

@implementation TiLivequeryQueryProxy

#pragma mark Private API's

- (id)_initWithPageContext:(id<TiEvaluator>)context andQuery:(PFQuery *)query
{
  if (self = [super _initWithPageContext:context]) {
    _query = query;
  }
  
  return self;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context args:(NSArray *)args
{
  if (self = [super _initWithPageContext:context args:args]) {
    NSDictionary *params = [args objectAtIndex:0];
    NSString *className = [params objectForKey:@"className"];
    NSString *predicate = [params objectForKey:@"predicate"];
    id predicateArguments = [params objectForKey:@"predicateArguments"];
    
    if (predicate == nil) {
      _query = [PFQuery queryWithClassName:className];
    } else {
      _query = [PFQuery queryWithClassName:className predicate:[NSPredicate predicateWithFormat:predicate, predicateArguments]];
    }
  }
  
  return self;
}

- (PFQuery *)query
{
  return _query;
}
  
#pragma mark Public API's
  
- (TiLivequeryQueryProxy *)whereKeyContainedIn:(id)args
{
  NSString *key = [args objectAtIndex:0];
  NSArray *containedIn = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key containedIn:containedIn];
  
  return self;
}
  
- (TiLivequeryQueryProxy *)whereKeyContainsAllObjectsInArray:(id)args
{
  NSString *key = [args objectAtIndex:0];
  NSArray *containedIn = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key containsAllObjectsInArray:containedIn];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyEqualTo:(id)args
  {
    NSString *key = [args objectAtIndex:0];
    id equalTo = [args objectAtIndex:1];
    
    _query = [[self query] whereKey:key equalTo:equalTo];
    
    return self;
  }

  - (TiLivequeryQueryProxy *)includeKeys:(id)args
  {
    NSArray *keys = [args objectAtIndex:0];
    
    _query = [[self query] includeKeys:keys];
    
    return self;
  }

- (TiLivequeryQueryProxy *)whereKeyExists:(id)args
{
  NSString *key = [args objectAtIndex:0];
  
  _query = [[self query] whereKeyExists:key];
  
  return self;
}

- (void)clearCachedResult:(id)unused
{
  [_query clearCachedResult];
}

- (void)findObjectsInBackground:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  [_query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[@{ @"success": @NO, @"error": error.localizedDescription }] thisObject:self];
      return;
    }
    
    NSMutableArray<TiLivequeryObjectProxy *> *result = [NSMutableArray arrayWithCapacity:objects.count];
    
    for (PFObject *object in objects) {
      [result addObject:[[TiLivequeryObjectProxy alloc] _initWithPageContext:self.pageContext andObject:object]];
    }
    
    [callback call:@[@{ @"success": @YES, @"objects": result }] thisObject:self];
  }];
}

@end
