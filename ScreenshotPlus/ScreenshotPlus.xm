
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#import <libactivator/libactivator.h>
#import "ScreenshotPlusManager.h"

ScreenshotPlusManager *screenshotPlusManager;

%ctor {
    NSLog(@"Screenshot+: Starting up!");
    screenshotPlusManager = [[ScreenshotPlusManager alloc] init];
    [LASharedActivator registerListener:screenshotPlusManager forName:@"wales.tucker.ScreenshotPlus"];
}
