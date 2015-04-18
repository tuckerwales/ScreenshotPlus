//
//  ScreenshotPlusManager.m
//  ScreenshotPlus
//
//  Created by Joshua Lee Tucker on 17/04/2015.
//
//

#import "ScreenshotPlusManager.h"

#import "Screenshotter.h"

#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/ScreenshotPlus.bundle"
#define kSettingsPath @"/var/mobile/Library/Preferences/wales.tucker.ScreenshotPlus.plist"

@implementation ScreenshotPlusManager

@synthesize window, composeWindow, isRunning;

- (void)loadPrefs {
    
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:kSettingsPath];
    
    email = YES;
    mms = YES;
    twitter = YES;
    facebook = YES;
    
    saveToPhotos = YES;
    
    email = [[settings valueForKey:@"EmailSwitch"] boolValue];
    mms = [[settings valueForKey:@"MMSSwitch"] boolValue];
    twitter = [[settings valueForKey:@"TwitterSwitch"] boolValue];
    facebook = [[settings valueForKey:@"FacebookSwitch"] boolValue];
    
    saveToPhotos = [[settings valueForKey:@"SaveScreenshot"] boolValue];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [messageComposeVC dismissViewControllerAnimated:YES completion:^{
       
        [composeWindow setHidden:YES];
        self.window.windowLevel = INT_MAX;
        composeWindow = nil;
        composeVC = nil;
        
    }];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [mailComposeVC dismissViewControllerAnimated:YES completion:^{
        
        [composeWindow setHidden:YES];
        self.window.windowLevel = INT_MAX;
        composeWindow = nil;
        composeVC = nil;
        
    }];
    
}

- (void)setupComposers {
    
    composers = [[NSMutableArray alloc] init];
    
    if ([MFMailComposeViewController canSendMail] && email == YES) {
        mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC addAttachmentData:UIImagePNGRepresentation(screenshot) mimeType:@"image/png" fileName:@"image.png"];
        [composers addObject:mailComposeVC];
    }
    
    if ([MFMessageComposeViewController canSendAttachments] && mms == YES) {
        messageComposeVC = [[MFMessageComposeViewController alloc] init];
        messageComposeVC.messageComposeDelegate = self;
        [messageComposeVC addAttachmentData:UIImagePNGRepresentation(screenshot) typeIdentifier:@"kUTTypePNG" filename:@"image.png"];
        [composers addObject:messageComposeVC];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && twitter == YES) {
        twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterComposer setInitialText:@""];
        [twitterComposer addImage:screenshot];
        [twitterComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            [composeWindow setHidden:YES];
            self.window.windowLevel = INT_MAX;
            composeWindow = nil;
            composeVC = nil;
            
        }];
        [composers addObject:twitterComposer];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] && facebook == YES) {
        facebookComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookComposer setInitialText:@""];
        [facebookComposer addImage:screenshot];
        [facebookComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            [composeWindow setHidden:YES];
            self.window.windowLevel = INT_MAX;
            composeWindow = nil;
            composeVC = nil;
            
        }];
        [composers addObject:facebookComposer];
    }

}

- (void)addButtons {
    
    [self setupComposers];
    
    NSLog(@"Composers: %@", composers);
    
    for (id item in composers) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, 0, 60.0, 60.0);
        button.layer.cornerRadius = button.frame.size.width / 2.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 2.0f;
        button.layer.masksToBounds = YES;
        
        if (item == twitterComposer) {
            [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/twitter.png", kBundlePath]] forState:UIControlStateNormal];
        } else if (item == facebookComposer) {
            [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/facebook.png", kBundlePath]] forState:UIControlStateNormal];
        } else if (item == mailComposeVC) {
            [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/email.png", kBundlePath]] forState:UIControlStateNormal];
        } else if (item == messageComposeVC) {
            [button setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/sms.png", kBundlePath]] forState:UIControlStateNormal];
        }
        
        button.contentMode = UIViewContentModeCenter;
        button.center = CGPointMake((self.window.frame.size.width / ([composers count] + 1)) * ([composers indexOfObject:item] + 1), self.window.frame.size.height * 0.11);
        button.alpha = 0.0f;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:button];
        [buttons addObject:button];
        
    }
    
}

- (void)setupWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.windowLevel = INT_MAX;
    self.window.hidden = NO;
    self.window.backgroundColor = [UIColor blackColor];
    self.window.alpha = 0.9;
    [self.window makeKeyAndVisible];
    
    [self addButtons];
    
}

- (void)buttonPressed:(id)sender {
    
    composeWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
    composeWindow.windowLevel = UIWindowLevelAlert;
    composeWindow.hidden = NO;
    
    composeVC = [[UIViewController alloc] init];
    UIView *mailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, composeWindow.frame.size.width, composeWindow.frame.size.height)];
    composeVC.view = mailView;
    
    [composeWindow addSubview:composeVC.view];
    self.window.windowLevel = UIWindowLevelStatusBar;
    
    [composeWindow makeKeyAndVisible];
    
    id composeController = [composers objectAtIndex:[buttons indexOfObject:sender]];
    
    [composeVC presentViewController:composeController animated:YES completion:nil];
    
}

- (void)invoke {
    
    [self loadPrefs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resign) name:@"ScreenshotPlusResign" object:nil];
    
    CGImageRef cgImage = [[Screenshotter sharedScreenshotter] getScreenshot];
    screenshot = [UIImage imageWithCGImage:cgImage];
    
    if (saveToPhotos) {
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    }
    
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
