/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "PFFileObject.h"
#import "TiProxy.h"

@interface TiLivequeryFileProxy : TiProxy {
  PFFileObject *_file;
}

#pragma mark Internal Module APIs

- (id)_initWithPageContext:(id<TiEvaluator>)context args:(NSArray *)args;

- (id)_initWithPageContext:(id<TiEvaluator>)context andFile:(PFFileObject *)file;

- (PFFileObject *)file;

#pragma mark Public APIs

- (void)getDataInBackgroundWithBlock:(id)args;

- (void)saveDataInBackground:(NSArray *)args;

- (NSString *)name;

- (NSString *)url;

- (NSNumber *)dirty;

@end
