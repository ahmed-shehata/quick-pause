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
		[self printCurrentFocusedDeviceName:[self getDefaultOutputDeviceName]];
  }
  return self;
}

- (void) printCurrentFocusedDeviceName:(NSString*) deviceName {
	NSLog(@"Currently focusing on: %@\n",deviceName);
	NSLog(@"When the default output device changes from %@, Spotify music will be paused and will resume when %@ is selected again.\n",deviceName,deviceName);

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

- (NSString*)getDefaultOutputDeviceName {
	NSString *deviceName = @"";
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

	propertyAOPA.mSelector = kAudioDevicePropertyDeviceNameCFString;
  OSStatus error = AudioObjectGetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, &propSize, &result);

	if (error == noErr) {
		deviceName = result;
	}

  return deviceName;
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
