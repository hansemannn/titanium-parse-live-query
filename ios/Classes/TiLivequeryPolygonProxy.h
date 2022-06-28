/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <TitaniumKit/TitaniumKit.h>
#import <Parse/Parse.h>
#import "TiLivequeryGeoPointProxy.h"

@interface TiLivequeryPolygonProxy : TiProxy {
  PFPolygon *_polygon;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andPolygon:(PFPolygon *)polygon;

- (PFPolygon *)polygon;

- (NSNumber *)containsPoint:(id)geoPoint;

@end
