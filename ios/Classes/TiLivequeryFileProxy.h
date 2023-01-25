/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Parse/Parse.h>
#import "TiProxy.h"

@interface TiLivequeryFileProxy : TiProxy {
  PFFileObject *_file;
}

- (void)getDataInBackgroundWithBlock:(id)args;

- (void)saveDataInBackground:(NSArray *)args;

- (PFFileObject *)file;

@end