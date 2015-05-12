//
//  DefaultTableViewCell.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 02/09/14.
//
//

#import <UIKit/UIKit.h>
extern const CGFloat DefaultTableViewCellMinHeight;
extern const CGRect DefaultTableViewCellTitleRect;
extern const CGRect DefaultTableViewCellDetailRect;

@interface DefaultTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;

@end
