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

@implementation QuickPauseHelper : NSObject

- (id)init {
  self = [super init];
  if (self) {
    [self setPlayer:[[BTHSpotifyInterface alloc] init]];
    [self setDefaultDeviceUID:[self getDefaultOutputDeviceUID]];
  }
  return self;
}

- (NSString*)getDefaultOutputDeviceUID {
	NSString *deviceUID = @"";
  AudioDeviceID outputDeviceID;
  UInt32 outputDeviceIDSize = sizeof (outputDeviceID);
  OSStatus status;
  AudioObjectPropertyAddress propertyAOPA;
  NSString *result;
  UInt32 propSize = sizeof(CFStringRef);
  propertyAOPA.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
  propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
  propertyAOPA.mElement = kAudioObjectPropertyElementMaster;

  status = AudioObjectGetPropertyData(
                                      kAudioObjectSystemObject,
                                      &propertyAOPA,
                                      0,
                                      NULL,
                                      &outputDeviceIDSize,
                                      &outputDeviceID);

	propertyAOPA.mSelector = kAudioDevicePropertyDeviceUID;
  OSStatus error = AudioObjectGetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, &propSize, &result);

	if (error == noErr) {
		deviceUID = result;
	}

  return deviceUID;
}


- (void) pauseIfDefaultDeviceChanged {
  NSString* uid = [self getDefaultOutputDeviceUID];

  if (![uid isEqualToString:self.defaultDeviceUID] &&
			[[self.player playerState] isEqualToString:@"Playing"]) { // if speaker has changed and music is playing
    [self.player pause];
    self.hasQuickPaused = YES;
  } else if ([uid isEqualToString:self.defaultDeviceUID] &&
						 [self hasQuickPaused] &&
						 [[self.player playerState] isEqualToString:@"Paused"]) {
    [self.player play];
    self.hasQuickPaused = NO;
  }

}
@end
