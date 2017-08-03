//
//  CollectionView.m
//  DragCollectionView
//
//  Created by lc on 2017/7/31.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            label;
        });
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
