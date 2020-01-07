//
//  QuickPauseHelper.h
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#ifndef QuickPauseHelper_h
#define QuickPauseHelper_h
@import AVFoundation;
@interface QuickPauseHelper : NSObject
- (void) pauseIfDefaultDeviceChanged;

@property bool hasQuickPaused;
@property NSString* previousDeviceUID;
@property NSObject<BTHPlayerInterface> *player;
@property NSString* defaultDeviceUID;
@property NSString* previousPlayerState;

@end

#endif /* QuickPauseHelper_h */
