//
// Created by Rob Warner on 12/9/14.
// Copyright (c) 2014 Rob Warner. All rights reserved.
//

#import <objc/objc-runtime.h>

#import "Utils.h"
#import "Command.h"
#import "Output.h"
#import "Option.h"

#define kCommandSuffix @"Command"
#define kOutputSuffix @"Output"
#define kOptionSuffix @"Option"

@implementation Utils

static NSArray *allCommands;
static NSArray *allOutputs;
static NSArray *allOptions;

+ (void)initialize {
  NSMutableArray *commands = [NSMutableArray array];
  NSMutableArray *outputs = [NSMutableArray array];
  NSMutableArray *options = [NSMutableArray array];

  Class *classes = NULL;
  int numClasses = objc_getClassList(NULL, 0);
  if (numClasses > 0) {
    classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * numClasses);
    for (int i = 0, n = objc_getClassList(classes, numClasses); i < n; i++) {
      Class cls = classes[i];
      NSString *className = @(class_getName(cls));
      if ([className hasSuffix:kCommandSuffix] &&
        [cls conformsToProtocol:@protocol(Command)]) {
        [commands addObject:cls];
      } else if ([className hasSuffix:kOutputSuffix] &&
        [cls conformsToProtocol:@protocol(Output)]) {
        [outputs addObject:cls];
      } else if ([className hasSuffix:kOptionSuffix] &&
        [cls conformsToProtocol:@protocol(Option)]) {
        [options addObject:cls];
      }
    }
    free(classes);
  }
  NSComparator alphabetic = ^(id a, id b) {
    NSString *first = [(Class) a description];
    NSString *second = [(Class) b description];
    return [first compare:second];
  };
  allCommands = [commands sortedArrayUsingComparator:alphabetic];
  allOutputs = [outputs sortedArrayUsingComparator:alphabetic];
  allOptions = [options sortedArrayUsingComparator:alphabetic];
}

+ (NSArray *)allCommands {
  return allCommands;
}

+ (NSArray *)allOutputs {
  return allOutputs;
}

+ (NSArray *)allOptions {
  return allOptions;
}

+ (NSString *)nameForCommand:(id <Command>)command {
  return [Utils nameForClass:[command class] suffix:kCommandSuffix];
}

+ (id)commandInstanceForName:(NSString *)name {
  return [Utils instanceForName:[name capitalizedString]
                         suffix:kCommandSuffix
                       protocol:@protocol(Command)];
}

+ (NSString *)nameForOutput:(id <Output>)output {
  return [Utils nameForClass:[output class] suffix:kOutputSuffix];
}

+ (id)outputInstanceForName:(NSString *)name {
  return [Utils instanceForName:[name capitalizedString]
                         suffix:kOutputSuffix
                       protocol:@protocol(Output)];
}

+ (NSString *)nameForOption:(id <Option>)option {
  return [Utils nameForClass:[option class] suffix:kOptionSuffix];
}

+ (id)optionInstanceForName:(NSString *)name {
  return [Utils instanceForName:[name capitalizedString]
                         suffix:kOptionSuffix
                       protocol:@protocol(Option)];
}

+ (id)optionInstanceForShortName:(NSString *)name {
  for (Class cls in allOptions) {
    id <Option> option = [[cls alloc] init];
    if ([[option shortName] isEqualToString:name]) {
      return option;
    }
  }
  return nil;
}

+ (id)optionInstanceForNameOrShortName:(NSString *)name {
  id <Option> option = nil;
  switch (name.length) {
    case 0:
      break;
    case 1:
      option = [Utils optionInstanceForShortName:name];
      break;
    default:
      option = [Utils optionInstanceForName:name];
      break;
  }
  return option;
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