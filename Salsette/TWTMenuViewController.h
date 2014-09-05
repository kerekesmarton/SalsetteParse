//
//  TWTMenuViewController.h
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SideMenuItem;
@interface TWTMenuViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)reload;
- (void)addItem:(SideMenuItem *)item atSection:(NSInteger)section;
- (void)updateItem:(SideMenuItem *)item atSection:(NSInteger)section;

@end
