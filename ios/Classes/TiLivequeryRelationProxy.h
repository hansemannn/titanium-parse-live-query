/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import "TiLivequeryQueryProxy.h"
#import "TiLivequeryObjectProxy.h"

#import <Parse/Parse.h>

@interface TiLivequeryRelationProxy : TiProxy {
  PFRelation *_relation;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andRelation:(PFRelation *)relation;

- (PFRelation *)relation;

- (NSString *)targetClass;

- (TiLivequeryQueryProxy *)query;

- (void)addObject:(TiLivequeryObjectProxy *)object;

- (void)removeObject:(TiLivequeryObjectProxy *)object;

@end
