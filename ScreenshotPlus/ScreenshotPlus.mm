#line 1 "/Users/jlt/Desktop/Projects/ScreenshotPlus/ScreenshotPlus/ScreenshotPlus.xm"




#import <libactivator/libactivator.h>
#import "ScreenshotPlusManager.h"

ScreenshotPlusManager *screenshotPlusManager;

static __attribute__((constructor)) void _logosLocalCtor_03738126() {
    NSLog(@"Screenshot+: Starting up!");
    screenshotPlusManager = [[ScreenshotPlusManager alloc] init];
    [LASharedActivator registerListener:screenshotPlusManager forName:@"wales.tucker.ScreenshotPlus"];
}
