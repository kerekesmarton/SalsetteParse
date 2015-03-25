//
//  UIViewController+Navigation.m
//  Salsette
//
//  Created by Kerekes, Marton on 24/03/15.
//
//

#import "UIViewController+Navigation.h"

#import "TWTSideMenuViewController.h"

@implementation UIViewController (Navigation)

-(void)refreshBackButton {
    
    if (self.sideMenuViewController) {
        UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
        self.navigationItem.leftBarButtonItem = openItem;
    } else if (self.presentingViewController) {
        UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        self.navigationItem.leftBarButtonItem = openItem;
    }
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)openButtonPressed
{
    if (self.sideMenuViewController) {
        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
    } {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
