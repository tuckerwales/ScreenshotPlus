//
//  ScreenshotPlusManager.h
//  ScreenshotPlus
//
//  Created by Joshua Lee Tucker on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <libactivator/libactivator.h>

@interface ScreenshotPlusManager : NSObject <LAListener, MFMailComposeViewControllerDelegate> {
    UIWindow *window;
    UIWindow *composeWindow;
    UIImageView *screenshotView;
    NSMutableArray *buttons;
    
    UIViewController *composeVC;
    SLComposeViewController *socialComposer;
    MFMailComposeViewController *mailComposeVC;
    
}

- (void)resign;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIWindow *composeWindow;

@property (nonatomic) BOOL isRunning;

@end
