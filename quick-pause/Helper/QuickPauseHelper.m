//
//  QuickPauseHelper.m
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHSpotifyInterface.h"
#import "QuickPauseHelper.h"
@import AVFoundation;

NSString *const kMacSpeakerUID = @"BuiltInSpeakerDevice";

@implementation QuickPauseHelper : NSObject

- (id)init {
  self = [super init];
  if (self) {
    [self setPlayer:[[BTHSpotifyInterface alloc] init]];
  }
  return self;
}

- (NSString *)getCurrentOutputDeviceUID
{
  NSString *deviceUID = @"";

  AudioObjectPropertyAddress aopa;
  aopa.mSelector = kAudioHardwarePropertyDevices;
  aopa.mScope = kAudioDevicePropertyScopeOutput;
  aopa.mElement = kAudioObjectPropertyElementMaster;

  UInt32 propSize;
  OSStatus error = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &aopa, 0, NULL, &propSize);
  if (error == noErr) {
    int deviceCount = propSize / sizeof(AudioDeviceID);
    AudioDeviceID *audioDevices = (AudioDeviceID *)malloc(propSize);
    error = AudioObjectGetPropertyData(kAudioObjectSystemObject, &aopa, 0, NULL, &propSize, audioDevices);
    if (error == noErr) {
      UInt32 propSize = sizeof(CFStringRef);
      for(int i = 1; i <= deviceCount; i++) {
        NSString *result;
        aopa.mSelector = kAudioDevicePropertyDeviceUID;
        error = AudioObjectGetPropertyData(audioDevices[i], &aopa, 0, NULL, &propSize, &result);
        if (error == noErr) {
          deviceUID = result;
          break;
        }
      }
    }
    free(audioDevices);
  }
  return deviceUID;
}
- (void) checkPlaybackDevices {
  NSString* uid = [self getCurrentOutputDeviceUID];

  if (![uid isEqualToString:[self previousDeviceUID]]) { // if speaker has changed
    if (![uid isEqualToString:kMacSpeakerUID]) { // if speaker is not mac speaker
      if ([self hasQuickPaused] && [[self.player playerState] isEqualToString:@"Paused"]) {
        [self.player play];
        self.hasQuickPaused = NO;
      }
    } else { // if speaker switched to mac speaker
      if ([[self.player playerState] isEqualToString:@"Playing"]) {
        [self.player pause];
        self.hasQuickPaused = YES;
      }
    }
  }

  [self setPreviousDeviceUID:uid];
}
@end
