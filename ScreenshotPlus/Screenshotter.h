//
//  Screenshotter.h
//  ScreenshotPlus
//
//  Created by Joshua Lee Tucker on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Screenshotter : NSObject

+ (id)sharedScreenshotter;

- (CGImageRef)getScreenshot;

@end
