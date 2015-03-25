//
//  UIViewController+CoverImage.h
//  Salsette
//
//  Created by Kerekes, Marton on 25/03/15.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (CoverImage)

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGSize initialSize;

-(void)scaleImageView:(UIScrollView *)scrollView;

@end
