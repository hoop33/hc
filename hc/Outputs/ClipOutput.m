//
// Created by Rob Warner on 12/12/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

@import AppKit;

#import "ClipOutput.h"
#import "Color.h"
#import "Response.h"

@implementation ClipOutput

- (void)output:(Response *)response {
  NSMutableString *text = [NSMutableString string];
  for (Color *color in response.colors) {
    [text appendFormat:@"%@\n", [color description]];
  }
  if (response.message != nil) {
    [text appendString:response.message];
  }

  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
  [pasteboard clearContents];
  [pasteboard writeObjects:@[text]];
}

- (NSString *)description {
  return @"Outputs to the clipboard";
}

- (NSString *)help {
  return @"Copies the output as text to the clipboard.";
}

@end
