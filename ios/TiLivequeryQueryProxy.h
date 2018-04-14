/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <Parse/Parse.h>
#import <ParseLiveQuery/ParseLiveQuery-Swift.h>

@interface TiLivequeryQueryProxy : TiProxy {
  PFQuery *_query;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andQuery:(PFQuery *)query;

- (PFQuery *)query;

- (void)clearCachedResult:(id)unused;

@end
