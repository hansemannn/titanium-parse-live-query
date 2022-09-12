/**
 * Copyright (c) 2021-present by Hans Knöchel
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiLivequeryModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"19332cb9-2c77-4366-a65f-4e84894562a3";
}

- (NSString *)moduleId
{
  return @"ti.livequery";
}

#pragma Public APIs

- (void)initialize:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);

  NSString *applicationId = [args objectForKey:@"applicationId"];
  NSString *clientKey = [args objectForKey:@"clientKey"];
  NSString *server = [args objectForKey:@"server"];
  BOOL localDatastoreEnabled = [TiUtils boolValue:@"localDatastoreEnabled" properties:args def:NO];

  [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
    configuration.applicationId = applicationId;
    configuration.clientKey = clientKey;
    configuration.server = server;
    configuration.localDatastoreEnabled = localDatastoreEnabled;
  }]];
}

- (id)isInitialized:(id)unused
{
  return @([Parse currentConfiguration] != nil);
}

- (void)setLogLevel:(id)logLevel
{
  ENSURE_SINGLE_ARG(logLevel, NSNumber);

  [Parse setLogLevel:[TiUtils intValue:logLevel]];
}

// TODO: Move to TiLiveQueryObject instead
- (void)saveObject:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);

  NSString *className = [args objectForKey:@"className"];
  NSDictionary *parameters = [args objectForKey:@"parameters"];
  KrollCallback *callback = [args objectForKey:@"callback"];

  PFObject *poke = [PFObject objectWithClassName:className];

  for (NSString *key in [parameters allKeys]) {
    poke[key] = [parameters objectForKey:key];
  }

  [poke saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
    if (callback == nil) {
      return;
    }

    [callback call:@[ @{
      @"success" : @(succeeded),
      @"error" : error ? error.localizedDescription : [NSNull null]
    } ]
        thisObject:self];
  }];
}

- (void)clearAllCachedResults:(id)unused
{
  [PFQuery clearAllCachedResults];
}

- (TiLivequeryObjectProxy *)objectWithClassName:(id)name
{
  ENSURE_SINGLE_ARG(name, NSString);
  PFObject *object = [PFObject objectWithClassName:name];

  return [[TiLivequeryObjectProxy alloc] _initWithPageContext:self.pageContext andObject:object];
}

- (TiLivequeryGeoPointProxy *)geoPointFromLocation:(id)location
{
  ENSURE_SINGLE_ARG(location, NSDictionary);

  CLLocationDegrees latitude = [TiUtils doubleValue:@"latitude" properties:location];
  CLLocationDegrees longitude = [TiUtils doubleValue:@"longitude" properties:location];

  PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];

  return [[TiLivequeryGeoPointProxy alloc] _initWithPageContext:self.pageContext andGeoPoint:geoPoint];
}

- (void)geoPointForCurrentLocationInBackground:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
    if (error != nil) {
      [callback call:@[@{
        @"success": @(NO),
        @"error": error.localizedDescription
      }] thisObject:self];
      return;
    }

    [callback call:@[@{
      @"success": @(YES),
      @"geoPoint": [[TiLivequeryGeoPointProxy alloc] _initWithPageContext:self.pageContext andGeoPoint:geoPoint]
    }] thisObject:self];
  }];
}

- (TiLivequeryPolygonProxy *)polygonFromCoordinates:(id)coordinates
{
  ENSURE_SINGLE_ARG(coordinates, NSArray);

  NSMutableArray *nativeCoordinates = [NSMutableArray arrayWithCapacity:[(NSArray *)coordinates count]];

  [(NSArray *)coordinates enumerateObjectsUsingBlock:^(TiLivequeryGeoPointProxy *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [nativeCoordinates addObject:obj.geoPoint];
  }];
  
  PFPolygon *polygon = [PFPolygon polygonWithCoordinates:nativeCoordinates];
}

- (void)signUpInBackgroundWithBlock:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);
  
  NSString *username = [TiUtils stringValue:@"username" properties:args];
  NSString *password = [TiUtils stringValue:@"password" properties:args];
  NSString *email = [TiUtils stringValue:@"email" properties:args];
  KrollCallback *callback = (KrollCallback *)args[@"callback"];

  PFUser *user = [PFUser user];
  user.username = username;
  user.password = password;
  user.email = email;
  
  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    [callback call:@[@{ @"success": @(succeeded), @"error": error ? error.localizedDescription : NSNull.null }] thisObject:self];
  }];
}

- (void)logInWithUsernameInBackground:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);
  
  NSString *username = [TiUtils stringValue:@"username" properties:args];
  NSString *password = [TiUtils stringValue:@"password" properties:args];
  KrollCallback *callback = (KrollCallback *)args[@"callback"];

  [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
    if (user != nil) {
      [callback call:@[@{ @"success": @(YES), @"sessionToken": user.sessionToken }] thisObject:self];
    } else {
      [callback call:@[@{ @"success": @(NO), @"error": error.localizedDescription }] thisObject:self];
    }
  }];
}

- (void)logOutInBackground:(id)args
{
  ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
  
  KrollCallback *callback = (KrollCallback *)args[@"callback"];

  [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    if (callback != nil) {
      [callback call:@[@{ @"success": @(error == nil), @"error": error ? error.localizedDescription : NSNull.null }] thisObject:self];
    }
  }];
}

MAKE_SYSTEM_PROP(EVENT_TYPE_ENTERED, PFLiveQueryEventTypeEntered);
MAKE_SYSTEM_PROP(EVENT_TYPE_LEFT, PFLiveQueryEventTypeLeft);
MAKE_SYSTEM_PROP(EVENT_TYPE_CREATED, PFLiveQueryEventTypeCreated);
MAKE_SYSTEM_PROP(EVENT_TYPE_UPDATED, PFLiveQueryEventTypeUpdated);
MAKE_SYSTEM_PROP(EVENT_TYPE_DELETED, PFLiveQueryEventTypeDeleted);

@end
