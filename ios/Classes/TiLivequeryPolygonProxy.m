/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryPolygonProxy.h"

@implementation TiLivequeryPolygonProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andPolygon:(PFPolygon *)polygon
{
  if (self = [super _initWithPageContext:context]) {
    _polygon = polygon;
  }

  return self;
}

- (PFPolygon *)polygon
{
  return _polygon;
}

- (NSNumber *)containsPoint:(id)geoPoint
{
  ENSURE_SINGLE_ARG(geoPoint, TiLivequeryGeoPointProxy);
  return @([_polygon containsPoint:[(TiLivequeryGeoPointProxy *)geoPoint geoPoint]]);
}

@end
