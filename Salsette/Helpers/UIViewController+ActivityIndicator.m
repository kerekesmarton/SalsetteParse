//
//  UIViewController+ActivityIndicator.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "UIViewController+ActivityIndicator.h"
#import <objc/runtime.h>

static void *spinnerKey = @"spinnerKey";
static void *hudKey     = @"hudKey";

@implementation UIViewController (ActivityIndicator)

-(UIActivityIndicatorView *)spinner {
    
    UIActivityIndicatorView *spinner = objc_getAssociatedObject(self, &spinnerKey);
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = self.view.frame;
        [self.view addSubview:spinner];
        objc_setAssociatedObject(self, &spinnerKey, spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return spinner;
}

-(void)setSpinner:(UIActivityIndicatorView *)spinner {
    
    objc_setAssociatedObject(self, &spinnerKey, spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)hideSpinner {
    
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}

-(void)showSpinner {
    
    [self.spinner startAnimating];
    self.spinner.hidden = NO;
}

-(MBProgressHUD *)HUD {
    
    MBProgressHUD *hud = objc_getAssociatedObject(self, &hudKey);
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        [self.view addSubview:hud];
        
        // Register for HUD callbacks so we can remove it from the window at the right time
        hud.delegate = self;
        objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hud;
}

-(void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, &hudKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

@end
