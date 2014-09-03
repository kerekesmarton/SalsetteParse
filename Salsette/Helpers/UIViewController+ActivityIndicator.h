//
//  UIViewController+ActivityIndicator.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (ActivityIndicator) <MBProgressHUDDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) MBProgressHUD *HUD;

-(void)hideSpinner;
-(void)showSpinner;

@end
