//
//  TiLivequeryUtils.m
//  titanium-parse-live-query
//
//  Created by Hans Knöchel on 28.06.22.
//

#import "TiLivequeryUtils.h"
#import "TiLivequeryRelationProxy.h"
#import "TiLivequeryGeoPointProxy.h"
#import "TiLivequeryObjectProxy.h"

@implementation TiLivequeryUtils

+ (id)mappedObject:(id)obj withPageContext:(id<TiEvaluator>)pageContext
{
  if ([obj isKindOfClass:[PFRelation class]]) {
    NSLog(@"[DEBUG] Detected PFRelation - mapping …");
    PFRelation *relation = (PFRelation *)obj;
    return [[TiLivequeryRelationProxy alloc] _initWithPageContext:pageContext andRelation:relation];
  } else if ([obj isKindOfClass:[PFGeoPoint class]]) {
    NSLog(@"[DEBUG] Detected PFGeoPoint - mapping …");
    PFGeoPoint *geoPoint = (PFGeoPoint *)obj;
    return [[TiLivequeryGeoPointProxy alloc] _initWithPageContext:pageContext andGeoPoint:geoPoint];
  } else if ([obj isKindOfClass:[PFObject class]]) {
    NSLog(@"[DEBUG] Detected PFObject - mapping …");
    PFObject *pfObject = (PFObject *)obj;
    return [[TiLivequeryObjectProxy alloc] _initWithPageContext:pageContext andObject:pfObject];
  } else if ([obj isKindOfClass:[NSString class]]) {
    NSLog(@"[DEBUG] Detected String - returning directly …");
    return obj;
  } else if ([obj isKindOfClass:[NSDictionary class]]) {
    NSLog(@"[DEBUG] Detected Object - returning directly …");
    return obj;
  } else if ([obj isKindOfClass:[NSString class]]) {
    NSLog(@"[DEBUG] Detected String - returning directly …");
    return obj;
  } else if ([obj isKindOfClass:[PFFileObject class]]) {
    NSLog(@"[DEBUG] Detected PFObject - mapping (url and name only??) …");
    PFFileObject *fileObject = (PFFileObject *)obj;
    return @{ @"name": fileObject.name, @"url": NULL_IF_NIL(fileObject.url), @"dirty": @(fileObject.dirty) };
  } else {
    NSLog(@"[ERROR] Unhandled data type detected: %@", NSStringFromClass([obj class]));
    return obj;
  }
}

@end
