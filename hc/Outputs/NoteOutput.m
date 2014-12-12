//
// Created by Rob Warner on 12/11/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

@import AppKit;

#import "NoteOutput.h"
#import "Color.h"
#import "Response.h"

@implementation NoteOutput

- (void)output:(Response *)response {
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  CGSize size = CGSizeMake(128.0, 128.0);
  NSRect rect = NSRectFromCGRect(CGRectMake(0.0f, 0.0f, size.width, size.height));
  for (Color *color in response.colors) {
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [[NSColor colorWithDeviceRed:(color.red / 255.0f)
                           green:(color.green / 255.0f)
                            blue:(color.blue / 255.0f)
                           alpha:1.0f] set];
    NSRectFill(rect);
    [image unlockFocus];

    [self notify:color.hexCode
            text:[color description]
           image:image];
  }
  if (response.message != nil) {
    [self notify:@"hc"
            text:response.message
           image:nil];
  }
}

- (NSString *)summary {
  return @"Outputs as user notifications";
}

- (void)notify:(NSString *)title text:(NSString *)text image:(NSImage *)image {
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = title;
  notification.informativeText = text;
  notification.contentImage = image;
  [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
  return YES;
}

@end