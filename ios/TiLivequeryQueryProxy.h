/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <Parse/Parse.h>
#import <ParseLiveQuery/ParseLiveQuery-Swift.h>

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

- (void)clearCachedResult:(id)unused;

- (void)setLimit:(id)limit;

- (void)setSkip:(id)skip;

- (void)findObjectsInBackground:(id)callback;

- (void)getObjectInBackgroundWithId:(id)objectId;

@end
