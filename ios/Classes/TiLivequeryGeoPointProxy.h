/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"
#import <Parse/Parse.h>

@interface TiLivequeryGeoPointProxy : TiProxy {
  PFGeoPoint *_geoPoint;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andGeoPoint:(PFGeoPoint *)geoPoint;

- (PFGeoPoint *)geoPoint;

- (double)distanceInMilesTo:(id)geoPoint;

- (double)distanceInRadiansTo:(id)geoPoint;

- (double)distanceInKilometersTo:(id)geoPoint;

@end
