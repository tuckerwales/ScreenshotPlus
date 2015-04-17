//
//  ScreenshotPlusManager.m
//  ScreenshotPlus
//
//  Created by Joshua Lee Tucker on 17/04/2015.
//
//

#import "ScreenshotPlusManager.h"

@implementation ScreenshotPlusManager

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    
    NSLog(@"Screenshot+: Did receive activation event!");
    
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
    
    NSLog(@"Screenshot+: Did receive abort event!");
    
}

@end
