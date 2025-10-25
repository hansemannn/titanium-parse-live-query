//
//  TiLivequeryUtils.m
//  titanium-parse-live-query
//
//  Created by Hans Knöchel on 28.06.22.
//

#import <Foundation/Foundation.h>
#import <TitaniumKit/TitaniumKit.h>

@interface TiLivequeryUtils : NSObject

+ (id)mappedObject:(id)obj withPageContext:(id<TiEvaluator>)pageContext;

+ (NSString *)mimeTypeForData:(NSData *)data;

@end
