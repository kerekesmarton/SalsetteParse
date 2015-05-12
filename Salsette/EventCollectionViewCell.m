//
//  EventCollectionViewCell.m
//  Salsette
//
//  Created by Kerekes, Marton on 29/04/15.
//
//

#import "EventCollectionViewCell.h"

@implementation EventCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.textView.selectable = NO;
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = NO;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.backgroundColor = [UIColor lightGrayColor];
}

//-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    
//    return [self.textView.text sizeWithAttributes:[NSDictionary dictionary]];
//}

@end
