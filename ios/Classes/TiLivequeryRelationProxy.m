/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryRelationProxy.h"

@implementation TiLivequeryRelationProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andRelation:(PFRelation *)relation
{
  if (self = [super _initWithPageContext:context]) {
    _relation = relation;
  }

  return self;
}

- (PFRelation *)relation
{
  return _relation;
}

- (NSString *)targetClass
{
  return _relation.targetClass;
}

- (TiLivequeryQueryProxy *)query
{
  return [[TiLivequeryQueryProxy alloc] _initWithPageContext:pageContext andQuery:_relation.query];
}

- (void)addObject:(TiLivequeryObjectProxy *)object
{
  [_relation addObject:object.object];
}

- (void)removeObject:(TiLivequeryObjectProxy *)object
{
  [_relation removeObject:object.object];
}

@end
