//
//  ScreenshotPlusManager.m
//  ScreenshotPlus
//
//  Created by Joshua Lee Tucker on 17/04/2015.
//
//

#import "ScreenshotPlusManager.h"

#import "Screenshotter.h"

#define BundlePath @"/Library/MobileSubstrate/DynamicLibraries/ScreenshotPlus.bundle"


@implementation ScreenshotPlusManager

@synthesize window, composeWindow, isRunning;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [mailComposeVC dismissViewControllerAnimated:YES completion:^{
        [composeWindow setHidden:YES];
        self.window.windowLevel = INT_MAX;
        composeWindow = nil;
        composeVC = nil;
    }];
    
}

- (void)setupComposers {
    
    mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = self;
    
    socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [socialComposer setInitialText:@"Testing from Screenshot+!"];
    [socialComposer addImage:screenshotView.image];
    [socialComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
       
        [composeWindow setHidden:YES];
        self.window.windowLevel = INT_MAX;
        composeWindow = nil;
        composeVC = nil;
        
    }];

}

- (void)setupWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.windowLevel = INT_MAX;
    self.window.hidden = NO;
    self.window.backgroundColor = [UIColor blackColor];
    self.window.alpha = 0.9;
    [self.window makeKeyAndVisible];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(75.0, 50, 60.0, 60.0);
    button.layer.cornerRadius = button.frame.size.width / 2.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2.0f;
    button.layer.masksToBounds = YES;
    [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/twitter.png", BundlePath]] forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeCenter];
    button.center = CGPointMake((self.window.frame.size.width / 5), self.window.frame.size.height * 0.11);
    button.alpha = 0.0f;
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:button];
    [buttons addObject:button];
    
    UIButton *fbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbutton.backgroundColor = [UIColor clearColor];
    fbutton.frame = CGRectMake(75.0, 50, 60.0, 60.0);
    fbutton.layer.cornerRadius = button.frame.size.width / 2.0;
    fbutton.layer.borderColor = [UIColor whiteColor].CGColor;
    fbutton.layer.borderWidth = 2.0f;
    fbutton.layer.masksToBounds = YES;
    [fbutton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/facebook.png", BundlePath]] forState:UIControlStateNormal];
    [fbutton setContentMode:UIViewContentModeCenter];
    fbutton.center = CGPointMake((self.window.frame.size.width / 5) * 2, self.window.frame.size.height * 0.11);
    fbutton.alpha = 0.0f;
    [self.window addSubview:fbutton];
    [buttons addObject:fbutton];
    
    UIButton *sbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sbutton.backgroundColor = [UIColor clearColor];
    sbutton.frame = CGRectMake(75.0, 50, 60.0, 60.0);
    sbutton.layer.cornerRadius = button.frame.size.width / 2.0;
    sbutton.layer.borderColor = [UIColor whiteColor].CGColor;
    sbutton.layer.borderWidth = 2.0f;
    sbutton.layer.masksToBounds = YES;
    [sbutton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/sms.png", BundlePath]] forState:UIControlStateNormal];
    [sbutton setContentMode:UIViewContentModeCenter];
    sbutton.center = CGPointMake((self.window.frame.size.width / 5) * 3, self.window.frame.size.height * 0.11);
    sbutton.alpha = 0.0f;
    [self.window addSubview:sbutton];
    [buttons addObject:sbutton];
    
    UIButton *mbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    mbutton.backgroundColor = [UIColor clearColor];
    mbutton.frame = CGRectMake(75.0, 50, 60.0, 60.0);
    mbutton.layer.cornerRadius = button.frame.size.width / 2.0;
    mbutton.layer.borderColor = [UIColor whiteColor].CGColor;
    mbutton.layer.borderWidth = 2.0f;
    mbutton.layer.masksToBounds = YES;
    [mbutton setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/email.png", BundlePath]] forState:UIControlStateNormal];
    [mbutton setContentMode:UIViewContentModeCenter];
    mbutton.center = CGPointMake((self.window.frame.size.width / 5) * 4, self.window.frame.size.height * 0.11);
    mbutton.alpha = 0.0f;
    [self.window addSubview:mbutton];
    [buttons addObject:mbutton];
    
}

- (void)buttonPressed {
    
    [self setupComposers];
    
    composeWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
    composeWindow.windowLevel = UIWindowLevelAlert;
    composeWindow.hidden = NO;
    
    composeVC = [[UIViewController alloc] init];
    UIView *mailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, composeWindow.frame.size.width, composeWindow.frame.size.height)];
    composeVC.view = mailView;
    
    [composeWindow addSubview:composeVC.view];
    self.window.windowLevel = UIWindowLevelNormal;
    
    [composeWindow makeKeyAndVisible];
    
    //[composeVC presentViewController:mailComposeVC animated:YES completion:nil];
    [composeVC presentViewController:socialComposer animated:YES completion:nil];
    
}

- (void)invoke {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resign) name:@"ScreenshotPlusResign" object:nil];
    
    CGImageRef cgImage = [[Screenshotter sharedScreenshotter] getScreenshot];
    UIImage *screenshot = [UIImage imageWithCGImage:cgImage];
    
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    
    NSLog(@"Screenshot+: Successfully took screenshot.");
    
    buttons = [[NSMutableArray alloc] init];
    
    [self setupWindow];
    
    screenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    screenshotView.image = screenshot;
    screenshotView.layer.cornerRadius = 3.0f;
    screenshotView.layer.masksToBounds = YES;
    
    [self.window addSubview:screenshotView];
    
    CGPoint newPoint = self.window.center;
    newPoint.y += 50;
    
    [UIView animateWithDuration:0.2 delay:0.0 options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        screenshotView.center = newPoint;
        screenshotView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
           screenshotView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
            for (UIButton *btn in buttons) {
                btn.alpha = 1.0f;
            }
        }];
    }];
    
    self.isRunning = YES;
    
}

- (void)resign {
    
    self.isRunning = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        for (UIButton *btn in buttons) {
            btn.alpha = 0.0f;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        screenshotView.center = self.window.center;
        screenshotView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    } completion:^(BOOL finished) {
        [self.window setHidden:YES];
        if (composeWindow) {
            [composeWindow setHidden:YES];
        }
    }];
    
}

#pragma mark Activator Methods

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    
    NSLog(@"Screenshot+: Did receive activation event!");
    
    if (!isRunning) {
        [self invoke];
    } else {
        [self resign];
    }
    
    [event setHandled:YES];
    
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
    
    NSLog(@"Screenshot+: Did receive abort event!");
    
    [self resign];
    
    [event setHandled:YES];
    
}

@end
