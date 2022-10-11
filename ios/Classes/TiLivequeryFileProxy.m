/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryFileProxy.h"
#import "TiBlob.h"

@implementation TiLivequeryFileProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context args:(NSArray *)args
{
  NSDictionary *params = (NSDictionary *)args.firstObject;
  NSString *fileName = params[@"fileName"];
  TiBlob *fileData = params[@"fileData"];
  
  _file = [PFFileObject fileObjectWithName:fileName data:[fileData data]];
  
  return self;
}

- (void)saveDataInBackground:(NSArray *)args
{
  KrollCallback *saveCallback = args[0];
  KrollCallback *progressCallback = args[1];

  [_file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    NSDictionary *event = @{ @"success": @(succeeded), @"error": error ? error.localizedDescription : NSNull.null };
    [saveCallback call:@[event] thisObject:self];
  } progressBlock:^(int percentDone) {
    NSDictionary *event = @{ @"progress": @(percentDone) };
    [progressCallback call:@[event] thisObject:self];
  }];
}

@end
