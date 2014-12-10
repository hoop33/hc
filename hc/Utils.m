//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <objc/objc-runtime.h>

#import "Utils.h"
#import "Command.h"

#define kCommandSuffix @"Command"

@implementation Utils

static NSArray *allCommands;

+ (void)initialize {
  NSMutableArray *array = [NSMutableArray array];
  Class *classes = NULL;
  int numClasses = objc_getClassList(NULL, 0);
  if (numClasses > 0) {
    classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * numClasses);
    for (int i = 0, n = objc_getClassList(classes, numClasses); i < n; i++) {
      Class cls = classes[i];
      NSString *className = @(class_getName(cls));
      if ([className hasSuffix:kCommandSuffix] &&
        [cls conformsToProtocol:@protocol(Command)]) {
        [array addObject:cls];
      }
    }
    free(classes);
  }
  allCommands = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSString *first = [(Class) a description];
    NSString *second = [(Class) b description];
    return [first compare:second];
  }];
}

+ (NSArray *)allCommands {
  return allCommands;
}

+ (NSString *)nameForCommand:(id <Command>)command {
  return [Utils nameForClass:[command class] suffix:kCommandSuffix];
}

+ (id)commandInstanceForName:(NSString *)name {
  return [Utils instanceForName:[name capitalizedString]
                         suffix:kCommandSuffix
                       protocol:@protocol(Command)];
}

#pragma mark - private methods

+ (NSString *)nameForClass:(Class)cls suffix:(NSString *)suffix {
  NSString *string = [[cls description] lowercaseString];
  return [string substringToIndex:(string.length - suffix.length)];
}

+ (id)instanceForName:(NSString *)name
               suffix:(NSString *)suffix
             protocol:(id)protocol {
  Class cls = NSClassFromString([NSString stringWithFormat:@"%@%@", name, suffix]);
  return (cls != nil && [cls conformsToProtocol:protocol]) ?
    [[cls alloc] init] : nil;
}

@end