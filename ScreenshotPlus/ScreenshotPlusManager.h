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

@interface ScreenshotPlusManager : NSObject <LAListener, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    UIWindow *window;
    UIWindow *composeWindow;
    UIImageView *screenshotView;
    NSMutableArray *buttons;
    
    BOOL email;
    BOOL mms;
    BOOL twitter;
    BOOL facebook;
    
    BOOL saveToPhotos;
    
    UIImage *screenshot;
    
    NSMutableArray *composers;
    UIViewController *composeVC;
    SLComposeViewController *twitterComposer;
    SLComposeViewController *facebookComposer;
    MFMailComposeViewController *mailComposeVC;
    MFMessageComposeViewController *messageComposeVC;
    
}

- (void)resign;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIWindow *composeWindow;

@property (nonatomic) BOOL isRunning;

@end
