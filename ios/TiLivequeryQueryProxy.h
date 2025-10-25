/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import <TitaniumKit/TitaniumKit.h>
#import "PFQuery.h"

@interface TiLivequeryQueryProxy : TiProxy {
  PFQuery *_query;
}

#pragma mark Private API's

- (id)_initWithPageContext:(id<TiEvaluator>)context andQuery:(PFQuery *)query;

- (id)_initWithPageContext:(id<TiEvaluator>)context args:(NSArray *)args;

- (PFQuery *)query;
  
#pragma mark Public API's
  
- (TiLivequeryQueryProxy *)whereKeyContainedIn:(id)args;

- (TiLivequeryQueryProxy *)whereKeyContainsAllObjectsInArray:(id)args;

- (TiLivequeryQueryProxy *)whereKeyNotContainedIn:(id)args;

- (TiLivequeryQueryProxy *)whereKeyEqualTo:(id)args;

- (TiLivequeryQueryProxy *)whereKeyNotEqualTo:(id)args;

- (TiLivequeryQueryProxy *)whereKeyLessThan:(id)args;

- (TiLivequeryQueryProxy *)whereKeyLessThanOrEqualTo:(id)args;

- (TiLivequeryQueryProxy *)whereKeyGreaterThan:(id)args;

- (TiLivequeryQueryProxy *)whereKeyGreaterThanOrEqualTo:(id)args;

- (TiLivequeryQueryProxy *)whereKeyExists:(id)args;

- (TiLivequeryQueryProxy *)whereKeyDoesNotExist:(id)args;

- (TiLivequeryQueryProxy *)includeKeys:(id)args;

- (TiLivequeryQueryProxy *)selectKeys:(id)args;

- (TiLivequeryQueryProxy *)orderByAscending:(id)key;

- (TiLivequeryQueryProxy *)orderByDescending:(id)key;

- (TiLivequeryQueryProxy *)fromLocalDatastore:(id)unused;

- (TiLivequeryQueryProxy *)fromPin:(id)unused;

- (TiLivequeryQueryProxy *)nearGeoPoint:(id)args;

- (TiLivequeryQueryProxy *)nearGeoPointWithinKilometers:(id)args;

- (TiLivequeryQueryProxy *)nearGeoPointWithinMiles:(id)args;

- (TiLivequeryQueryProxy *)nearGeoPointWithinRadians:(id)args;

- (TiLivequeryQueryProxy *)withinPolygon:(id)args;

- (void)clearCachedResult:(id)unused;

- (void)setLimit:(id)limit;

- (void)setSkip:(id)skip;

- (void)findObjectsInBackground:(id)callback;

- (void)objectInBackgroundWithId:(id)objectId;

@end
