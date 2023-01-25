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
    PFRelation *relation = (PFRelation *)obj;
    return [[TiLivequeryRelationProxy alloc] _initWithPageContext:pageContext andRelation:relation];
  } else if ([obj isKindOfClass:[PFGeoPoint class]]) {
    PFGeoPoint *geoPoint = (PFGeoPoint *)obj;
    return [[TiLivequeryGeoPointProxy alloc] _initWithPageContext:pageContext andGeoPoint:geoPoint];
  } else if ([obj isKindOfClass:[PFObject class]]) {
    PFObject *pfObject = (PFObject *)obj;
    return [[TiLivequeryObjectProxy alloc] _initWithPageContext:pageContext andObject:pfObject];
  } else if ([obj isKindOfClass:[NSString class]]) {
    return obj;
  } else if ([obj isKindOfClass:[NSDictionary class]]) {
    return obj;
  } else if ([obj isKindOfClass:[PFRole class]]) {
    PFRole *role = (PFRole *)obj;
    return role.name;
  } else if ([obj isKindOfClass:[PFACL class]]) {
    PFACL *acl = (PFACL *)obj;
    return @{ @"publicWriteAccess": @([acl getPublicWriteAccess]), @"publicReadAccess": @([acl getPublicReadAccess]) };
  } else if ([obj isKindOfClass:[PFFileObject class]]) {
    PFFileObject *fileObject = (PFFileObject *)obj;
    return @{
      @"name": fileObject.name,
      @"url": NULL_IF_NIL(fileObject.url),
      @"dirty": @(fileObject.dirty)
    };
  } else if ([obj isKindOfClass:[PFPolygon class]]) {
    PFPolygon *polygon = (PFPolygon *)obj;
    NSMutableArray<id> *coordinates = [NSMutableArray arrayWithCapacity:polygon.coordinates.count];
    [polygon.coordinates enumerateObjectsUsingBlock:^(id  _Nonnull coordinate, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([coordinate isKindOfClass:[PFGeoPoint class]]) {
        [coordinates addObject:[[TiLivequeryGeoPointProxy alloc] _initWithPageContext:pageContext andGeoPoint:coordinate]];
      } else if ([coordinate isKindOfClass:[CLLocation class]]) {
        CLLocation *location = (CLLocation *)coordinate;
        [coordinates addObject:@{
          @"latitude": @(location.coordinate.latitude),
          @"longitude": @(location.coordinate.longitude)
        }];
      }
    }];
    return @{ @"coordinates": coordinates };
  } else if ([obj isKindOfClass:[PFProduct class]]) {
    PFProduct *product = (PFProduct *)obj;
    return @{
      @"title": NULL_IF_NIL(product.title),
      @"subtitle": NULL_IF_NIL(product.subtitle),
      @"productIdentifier": NULL_IF_NIL(product.productIdentifier)
      
    };
  } else {
    NSLog(@"[DEBUG] Unhandled data type detected: %@", NSStringFromClass([obj class]));
    return obj;
  }
}

// CREDITS: https://stackoverflow.com/a/32765708/5537752
+ (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];

    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}


@end
