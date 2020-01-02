//
//  main.m
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHSpotifyInterface.h"
#import "QuickPauseHelper.h"
@import AVFoundation;

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSLog(@"Welcome to quick-pause cli");
    QuickPauseHelper* helper = [[QuickPauseHelper alloc] init];

    NSDate *now = [[NSDate alloc] init];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
    interval:.01
    target:helper
    selector:@selector(pauseIfDefaultDeviceChanged)
    userInfo:nil
    repeats:YES];

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runLoop run];

  }
  return 0;
}
