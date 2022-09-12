/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import <Parse/Parse.h>
#import <ParseLiveQuery/ParseLiveQuery-Swift.h>

#import "TiLivequeryObjectProxy.h"
#import "TiLivequeryGeoPointProxy.h"
#import "TiLivequeryPolygonProxy.h"

@interface TiLivequeryModule : TiModule {
}

- (void)initialize:(id)args;

- (id)isInitialized:(id)unused;

- (void)setLogLevel:(id)logLevel;

- (void)saveObject:(id)args;

- (void)clearAllCachedResults:(id)unused;

- (TiLivequeryObjectProxy *)objectWithClassName:(id)name;

- (TiLivequeryGeoPointProxy *)geoPointFromLocation:(id)location;

- (void)geoPointForCurrentLocationInBackground:(id)callback;

- (TiLivequeryPolygonProxy *)polygonFromCoordinates:(id)coordinates;

- (void)signUpInBackgroundWithBlock:(id)args;

- (void)logInWithUsernameInBackground:(id)args;

- (void)logOutInBackground:(id)args;

@end
