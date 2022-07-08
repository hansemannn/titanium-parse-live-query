/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryQueryProxy.h"
#import "TiLivequeryObjectProxy.h"
#import "TiLivequeryGeoPointProxy.h"
#import "TiLivequeryPolygonProxy.h"
#import "TiLivequeryRelationProxy.h"
#import "TiLivequeryUtils.h"

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

- (TiLivequeryQueryProxy *)whereKeyNotContainedIn:(id)args
{
  NSString *key = [args objectAtIndex:0];
  NSArray *containedIn = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key notContainedIn:containedIn];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyEqualTo:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id equalTo = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key equalTo:equalTo];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyNotEqualTo:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id equalTo = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key notEqualTo:equalTo];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyLessThan:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id object = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key lessThan:object];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyLessThanOrEqualTo:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id object = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key lessThanOrEqualTo:object];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyGreaterThan:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id object = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key greaterThan:object];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyGreaterThanOrEqualTo:(id)args
{
  NSString *key = [args objectAtIndex:0];
  id object = [args objectAtIndex:1];
  
  _query = [[self query] whereKey:key greaterThanOrEqualTo:object];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyExists:(id)args
{
  NSString *key = [args objectAtIndex:0];
  
  _query = [[self query] whereKeyExists:key];
  
  return self;
}

- (TiLivequeryQueryProxy *)whereKeyDoesNotExist:(id)args
{
  NSString *key = [args objectAtIndex:0];
  
  _query = [[self query] whereKeyDoesNotExist:key];
  
  return self;
}

- (TiLivequeryQueryProxy *)includeKeys:(id)args
{
  NSArray *keys = [args objectAtIndex:0];
  
  _query = [[self query] includeKeys:keys];
  
  return self;
}

- (TiLivequeryQueryProxy *)selectKeys:(id)args
{
  NSArray *keys = [args objectAtIndex:0];
  
  _query = [[self query] selectKeys:keys];
  
  return self;
}

- (TiLivequeryQueryProxy *)orderByAscending:(id)key
{
  ENSURE_SINGLE_ARG(key, NSString);
  
  _query = [[self query] orderByAscending:key];
  
  return self;
}

- (TiLivequeryQueryProxy *)orderByDescending:(id)key
{
  ENSURE_SINGLE_ARG(key, NSString);
  
  _query = [[self query] orderByDescending:key];
  
  return self;
}

- (TiLivequeryQueryProxy *)fromLocalDatastore:(id)unused
{
  _query = [[self query] fromLocalDatastore];

  return self;
}

- (TiLivequeryQueryProxy *)fromPin:(id)unused
{
  _query = [_query fromPin];

  return self;
}

- (TiLivequeryQueryProxy *)nearGeoPoint:(id)args
{
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  TiLivequeryGeoPointProxy *geoPoint = (TiLivequeryGeoPointProxy *)[args objectAtIndex:1];

  _query = [_query whereKey:key nearGeoPoint:geoPoint.geoPoint];

  return self;
}

- (TiLivequeryQueryProxy *)nearGeoPointWithinKilometers:(id)args
{
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  TiLivequeryGeoPointProxy *geoPoint = (TiLivequeryGeoPointProxy *)[args objectAtIndex:1];
  double kilometers = [TiUtils doubleValue:[args objectAtIndex:2]];

  _query = [_query whereKey:key nearGeoPoint:geoPoint.geoPoint withinKilometers:kilometers];

  return self;
}

- (TiLivequeryQueryProxy *)nearGeoPointWithinMiles:(id)args
{
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  TiLivequeryGeoPointProxy *geoPoint = (TiLivequeryGeoPointProxy *)[args objectAtIndex:1];
  double miles = [TiUtils doubleValue:[args objectAtIndex:2]];

  _query = [_query whereKey:key nearGeoPoint:geoPoint.geoPoint withinMiles:miles];

  return self;
}

- (TiLivequeryQueryProxy *)nearGeoPointWithinRadians:(id)args
{
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  TiLivequeryGeoPointProxy *geoPoint = (TiLivequeryGeoPointProxy *)[args objectAtIndex:1];
  double radians = [TiUtils doubleValue:[args objectAtIndex:2]];

  _query = [_query whereKey:key nearGeoPoint:geoPoint.geoPoint withinRadians:radians];

  return self;
}

- (TiLivequeryQueryProxy *)withinPolygon:(id)args
{
  NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
  TiLivequeryPolygonProxy *polygon = (TiLivequeryPolygonProxy *)[args objectAtIndex:1];

  _query = [_query whereKey:key withinPolygon:polygon.polygon.coordinates];

  return self;
}

- (void)clearCachedResult:(id)unused
{
  [_query clearCachedResult];
}

- (void)setLimit:(id)limit
{
  ENSURE_TYPE(limit, NSNumber);
  
  [_query setLimit:[TiUtils intValue:limit]];
}

- (void)setSkip:(id)skip
{
  ENSURE_TYPE(skip, NSNumber);
  
  [_query setSkip:[TiUtils intValue:skip]];
}

- (void)findObjectsInBackground:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  [_query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[@{ @"success": @NO, @"error": error.localizedDescription }] thisObject:self];
      return;
    }
    
    NSMutableArray<id> *result = [NSMutableArray arrayWithCapacity:objects.count];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [result addObject:[TiLivequeryUtils mappedObject:obj withPageContext:self.pageContext]];
    }];

    [callback call:@[@{ @"success": @YES, @"objects": result }] thisObject:self];
  }];
}

- (void)objectInBackgroundWithId:(id)objectId
{
  ENSURE_SINGLE_ARG(objectId, NSString);
  [_query getObjectInBackgroundWithId:objectId];
}

@end
