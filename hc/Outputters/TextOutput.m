//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import "TextOutput.h"
#import "Response.h"
#import "App.h"
#import "Color.h"

@implementation TextOutput

- (void)output:(Response *)response {
  App *app = [App app];
  for (Color *color in response.colors) {
    [app out:color];
    [app out:@"\n\n"];
  }
  if (response.message != nil) {
    [app out:response.message];
  }
}

- (NSString *)summary {
  return @"Outputs as text to stdout";
}

@end