/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2018 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import <Parse/Parse.h>
#import <ParseLiveQuery/ParseLiveQuery-Swift.h>

@interface TiLivequeryModule : TiModule {

}

- (void)initialize:(id)args;

- (void)saveObject:(id)args;

@end
