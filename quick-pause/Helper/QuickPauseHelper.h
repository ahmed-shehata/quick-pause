//
//  QuickPauseHelper.h
//  quick-pause
//
//  Created by Ahmed Shehata on 12/14/19.
//  Copyright © 2019 Ahmed Shehata. All rights reserved.
//

#ifndef QuickPauseHelper_h
#define QuickPauseHelper_h
@interface QuickPauseHelper : NSObject
- (NSString *)getCurrentOutputDeviceUID;
- (void) checkPlaybackDevices;

@property bool hasQuickPaused;
@property NSString* previousDeviceUID;
@property NSObject<BTHPlayerInterface> *player;

@end

#endif /* QuickPauseHelper_h */