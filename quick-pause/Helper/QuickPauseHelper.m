//
//  QuickPauseHelper.m
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickPauseHelper.h"
@import AVFoundation;

@implementation QuickPauseHelper : NSObject

+ (NSString *)getCurrentOutputDeviceUID
{
    NSString *deviceUID = @"";

    AudioObjectPropertyAddress aopa;
    aopa.mSelector = kAudioHardwarePropertyDevices;
    aopa.mScope = kAudioObjectPropertyScopeGlobal;
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
@end
