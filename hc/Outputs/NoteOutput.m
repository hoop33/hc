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
  for (Color *color in response.colors) {
    [self notify:color.hexCode
            text:[color description]
           image:[color asImage:CGSizeMake(44.0f, 44.0f)]];
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