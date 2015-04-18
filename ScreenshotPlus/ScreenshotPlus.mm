#line 1 "/Users/jlt/Desktop/Projects/ScreenshotPlus/ScreenshotPlus/ScreenshotPlus.xm"




#import <libactivator/libactivator.h>
#import "ScreenshotPlusManager.h"

ScreenshotPlusManager *screenshotPlusManager;

#include <logos/logos.h>
#include <substrate.h>
@class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent)(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(SpringBoard*, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$handleMenuDoubleTap)(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$handleMenuDoubleTap(SpringBoard*, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$lockButtonWasHeld)(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$lockButtonWasHeld(SpringBoard*, SEL); 

#line 10 "/Users/jlt/Desktop/Projects/ScreenshotPlus/ScreenshotPlus/ScreenshotPlus.xm"


static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(SpringBoard* self, SEL _cmd) {
    
    if ([screenshotPlusManager isRunning]) {
        [screenshotPlusManager resign];
    }
    
    _logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent(self, _cmd);
    
}

static void _logos_method$_ungrouped$SpringBoard$handleMenuDoubleTap(SpringBoard* self, SEL _cmd) {
    
    if (![screenshotPlusManager isRunning]) {
        _logos_orig$_ungrouped$SpringBoard$handleMenuDoubleTap(self, _cmd);
    }
    
}

static void _logos_method$_ungrouped$SpringBoard$lockButtonWasHeld(SpringBoard* self, SEL _cmd) {
    
    [screenshotPlusManager resign];
    
    _logos_orig$_ungrouped$SpringBoard$lockButtonWasHeld(self, _cmd);
    
}



static __attribute__((constructor)) void _logosLocalCtor_60a62657() {
    NSLog(@"Screenshot+: Starting up!");
    screenshotPlusManager = [[ScreenshotPlusManager alloc] init];
    screenshotPlusManager.isRunning = NO;
    [LASharedActivator registerListener:screenshotPlusManager forName:@"wales.tucker.ScreenshotPlus"];
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handleMenuButtonEvent), (IMP)&_logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(handleMenuDoubleTap), (IMP)&_logos_method$_ungrouped$SpringBoard$handleMenuDoubleTap, (IMP*)&_logos_orig$_ungrouped$SpringBoard$handleMenuDoubleTap);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(lockButtonWasHeld), (IMP)&_logos_method$_ungrouped$SpringBoard$lockButtonWasHeld, (IMP*)&_logos_orig$_ungrouped$SpringBoard$lockButtonWasHeld);} }
#line 46 "/Users/jlt/Desktop/Projects/ScreenshotPlus/ScreenshotPlus/ScreenshotPlus.xm"
