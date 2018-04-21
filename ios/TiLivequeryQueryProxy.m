/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryQueryProxy.h"
#import "TiLivequeryObjectProxy.h"

@implementation TiLivequeryQueryProxy

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
    NSString *predicateArguments = [params objectForKey:@"predicateArguments"];

    NSString *predicateFormat = [NSString stringWithFormat:predicate, predicateArguments];
    
    _query = [PFQuery queryWithClassName:className predicate:predicate ? [NSPredicate predicateWithFormat:predicateFormat] : nil];
  }
  
  return self;
}

- (PFQuery *)query
{
  return _query;
}

#pragma mark Public API's

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
