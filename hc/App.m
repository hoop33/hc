//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "App.h"

@implementation App

+ (App *)app {
  static App *app;

  @synchronized (self) {
    if (!app) app = [[App alloc] init];
  }
  return app;
}

- (void)out:(NSObject *)output {
  printf("%s\n", [[output description] UTF8String]);
}

- (NSString *)version {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (NSString *)errorDomain {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
}

@end