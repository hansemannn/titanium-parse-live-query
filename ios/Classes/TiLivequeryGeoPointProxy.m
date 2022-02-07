/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryGeoPointProxy.h"

@implementation TiLivequeryGeoPointProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andGeoPoint:(PFGeoPoint *)geoPoint
{
  if (self = [super _initWithPageContext:context]) {
    _geoPoint = geoPoint;
  }

  return self;
}

- (PFGeoPoint *)geoPoint
{
  return _geoPoint;
}

- (double)distanceInMilesTo:(id)geoPoint
{
  ENSURE_SINGLE_ARG(geoPoint, TiLivequeryGeoPointProxy);

  return [_geoPoint distanceInMilesTo:[(TiLivequeryGeoPointProxy *)geoPoint geoPoint]];
}

- (double)distanceInRadiansTo:(id)geoPoint
{
  ENSURE_SINGLE_ARG(geoPoint, TiLivequeryGeoPointProxy);

  return [_geoPoint distanceInRadiansTo:[(TiLivequeryGeoPointProxy *)geoPoint geoPoint]];
}

- (double)distanceInKilometersTo:(id)geoPoint
{
  ENSURE_SINGLE_ARG(geoPoint, TiLivequeryGeoPointProxy);

  return [_geoPoint distanceInKilometersTo:[(TiLivequeryGeoPointProxy *)geoPoint geoPoint]];
}

@end
