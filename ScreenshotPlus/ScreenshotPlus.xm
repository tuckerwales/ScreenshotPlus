
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#import <libactivator/libactivator.h>
#import "ScreenshotPlusManager.h"

ScreenshotPlusManager *screenshotPlusManager;

%hook SpringBoard

-(void)_handleMenuButtonEvent {
    
    if ([screenshotPlusManager isRunning]) {
        [screenshotPlusManager resign];
    }
    
    %orig;
    
}

-(void)handleMenuDoubleTap {
    
    if (![screenshotPlusManager isRunning]) {
        %orig;
    }
    
}

-(void)lockButtonWasHeld {
    
    [screenshotPlusManager resign];
    
    %orig;
    
}

%end

static void lockComplete(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    if ([screenshotPlusManager isRunning]) {
        [screenshotPlusManager resign];
    }
    
}

%ctor {
    NSLog(@"Screenshot+: Starting up!");
    screenshotPlusManager = [[ScreenshotPlusManager alloc] init];
    screenshotPlusManager.isRunning = NO;
    [LASharedActivator registerListener:screenshotPlusManager forName:@"wales.tucker.ScreenshotPlus"];
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, lockComplete, CFSTR("com.apple.springboard.lockcomplete"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
}
