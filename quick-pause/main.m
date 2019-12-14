//
//  main.m
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHSpotifyInterface.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      NSLog(@"Welcome to quick-pause cli");
      NSObject<BTHPlayerInterface> *player = [[BTHSpotifyInterface alloc] init];
      NSLog(@"%@",[player currentTrack]);
  }
  return 0;
}
