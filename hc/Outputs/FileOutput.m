//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

@import AppKit;

#import "FileOutput.h"
#import "Response.h"
#import "Color.h"

@implementation FileOutput

- (void)output:(Response *)response {
  CGSize size = CGSizeMake(128.0, 128.0);
  NSRect rect = NSRectFromCGRect(CGRectMake(0.0f, 0.0f, size.width, size.height));
  for (Color *color in response.colors) {
    NSImage *image = [color asImage:size];

    [image lockFocus];
    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:rect];
    [image unlockFocus];

    NSData *imageData = [bitmapImageRep representationUsingType:NSPNGFileType
                                                     properties:nil];
    [imageData writeToFile:[NSString stringWithFormat:@"%@.png", [color.hexCode substringFromIndex:1]]
                atomically:NO];
  }
  if (response.message != nil) {
    [response.message writeToFile:@"message.txt"
                       atomically:NO
                         encoding:NSUTF8StringEncoding
                            error:nil];
  }
}

- (NSString *)description {
  return @"Outputs as files";
}

- (NSString *)help {
  return @"Creates PNG files in the current directory with the color's hex code as the file name. The color #f00, for example, creates the file ff0000.png";
}

@end
