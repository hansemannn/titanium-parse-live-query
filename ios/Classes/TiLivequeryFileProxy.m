/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiLivequeryFileProxy.h"
#import "TiBlob.h"
#import "TiBase.h"
#import "TiLivequeryUtils.h"

@implementation TiLivequeryFileProxy

#pragma mark Internal Module APIs

- (PFFileObject *)file
{
  return _file;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context args:(NSArray *)args
{
  if (self = [super _initWithPageContext:context]) {
    
    NSDictionary *params = (NSDictionary *)args.firstObject;
    NSString *fileName = params[@"fileName"];
    TiBlob *fileData = params[@"fileData"];
    
    _file = [PFFileObject fileObjectWithName:fileName data:[fileData data]];
  }

  return self;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andFile:(PFFileObject *)file
{
  if (self = [super _initWithPageContext:context]) {
    _file = file;
  }
  
  return self;
}

#pragma mark Public APIs

- (void)getDataInBackgroundWithBlock:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  [_file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
    NSDictionary *event = @{
      @"success": @(error == nil),
      @"file": [[TiBlob alloc] initWithData:data mimetype:[TiLivequeryUtils mimeTypeForData:data]],
      @"error": error ? error.localizedDescription : NSNull.null
    };

    [callback call:@[event] thisObject:self];
  }];
}

- (void)saveDataInBackground:(NSArray *)args
{
  KrollCallback *saveCallback = args[0];
  KrollCallback *progressCallback = nil;
  
  if (args.count > 1) {
    progressCallback = args[1];
  }

  [_file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    NSDictionary *event = @{
      @"success": @(succeeded),
      @"file": self,
      @"error": error ? error.localizedDescription : NSNull.null
    };

    [saveCallback call:@[event] thisObject:self];
  } progressBlock:^(int percentDone) {
    NSDictionary *event = @{
      @"progress": @(percentDone)
    };
    
    if (progressCallback != nil) {
      [progressCallback call:@[event] thisObject:self];
    }
  }];
}

- (NSString *)name
{
  return _file.name;
}

- (NSString *)url
{
  return NULL_IF_NIL(_file.url);
}

- (NSNumber *)dirty
{
  return @(_file.isDirty);
}

@end
