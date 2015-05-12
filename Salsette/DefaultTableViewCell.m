//
//  DefaultTableViewCell.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 02/09/14.
//
//

#import "DefaultTableViewCell.h"

const CGRect DefaultTableViewCellTitleRect = { { 0.0f, 0.0f }, { 120.0f, 44.0f } };
const CGRect DefaultTableViewCellDetailRect = { { 130.0f, 0.0f }, { 165.0f, 44.0f } };
const CGFloat DefaultTableViewCellMinHeight = 44.0f;

@implementation DefaultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:DefaultTableViewCellTitleRect];
        titleLabel.tag = 1; // We use the tag to set it later
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:DefaultTableViewCellDetailRect];
        dataLabel.tag = 2; // We use the tag to set it later
        dataLabel.font = [UIFont systemFontOfSize:15.0f];
        dataLabel.backgroundColor = [UIColor clearColor];
        dataLabel.numberOfLines = 0;
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:dataLabel];
        
        // Cannot select these cells
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
   }
    return self;
}


-(UILabel *)titleLabel {
    return (UILabel *)[self viewWithTag:1];
}

-(UILabel *)detailLabel {
    return (UILabel *)[self viewWithTag:2];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
