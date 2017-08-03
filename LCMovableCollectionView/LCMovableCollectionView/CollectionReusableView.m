//
//  CollectionReusableView.m
//  DragCollectionView
//
//  Created by lc on 2017/8/1.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "CollectionReusableView.h"

@interface CollectionReusableView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor orangeColor];
            [self addSubview:label];
            label;
        });
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
