//
//  LCMovableCollectionView.m
//  DragCollectionView
//
//  Created by lc on 2017/7/31.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "LCMovableCollectionView.h"

@interface LCMovableCollectionView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *panView; //临时view，用于拖动
@property (strong, nonatomic) UIPanGestureRecognizer *panGes; //拖动手势
@property (copy  , nonatomic) LCMovableCollectionViewMoveCallBack moveCallBack; //移动cell之后的回调

@end

@implementation LCMovableCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                 moveCallBack:(LCMovableCollectionViewMoveCallBack)moveCallBack {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _maxMargin = 10.0f;
        
        if (moveCallBack) _moveCallBack = [moveCallBack copy];
        
        //添加拖动手势
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGes.delegate = self;
        [self addGestureRecognizer:_panGes];
    }
    return self;
}

#pragma mark 🍀🍀 Gesture

static CGPoint startPoint; //起点
static NSIndexPath *movingIndexPath; //拖动中的cell的indexPath

- (void)pan:(UIPanGestureRecognizer *)panGes {
    if (!_movable) return;
    
    CGPoint point = [panGes locationInView:panGes.view];
    
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            startPoint = [panGes locationInView:panGes.view];
            movingIndexPath = [self indexPathForItemAtPoint:startPoint];
            if (!movingIndexPath) return;
            
            //当前cell是否可以移动
            for (NSNumber *unmovableSection in self.unmovableSections) {
                if (unmovableSection.integerValue == movingIndexPath.section) return;
            }
            for (NSIndexPath *unmovableIndexPath in self.unmovableIndexPaths) {
                if ([movingIndexPath compare:unmovableIndexPath] == NSOrderedSame) return;
            }
            
            //复制被拖动的cell并添加到collectionView上
            NSData * tempData = [NSKeyedArchiver archivedDataWithRootObject:[self cellForItemAtIndexPath:movingIndexPath]];
            _panView = (UIView *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
            [self addSubview:_panView];
            
            //隐藏被拖动的cell
            [self cellForItemAtIndexPath:movingIndexPath].hidden = YES;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (!_panView) return;
            
            //改变临时view的frame
            CGRect frame = _panView.frame;
            frame.origin.x += point.x - startPoint.x;
            frame.origin.y += point.y - startPoint.y;
            _panView.frame = frame;
            
            //重置起点
            startPoint = point;
            
            if ([self canMoveCell]) {
                NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
                if (_moveCallBack) _moveCallBack(movingIndexPath, indexPath);
                [self moveItemAtIndexPath:movingIndexPath toIndexPath:indexPath];
                movingIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        {
            if (!_panView) return;
            
            //将临时view移除并置空
            [_panView removeFromSuperview];
            _panView = nil;
            
            //显示被隐藏的cell
            [self cellForItemAtIndexPath:movingIndexPath].hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 🍀🍀 是否可以移动cell
- (BOOL)canMoveCell {
    //获取临时view中心点
    CGPoint currentPoint = CGPointMake(CGRectGetMidX(_panView.frame), CGRectGetMidY(_panView.frame));
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:currentPoint];
    if (!indexPath || [indexPath compare:movingIndexPath] == NSOrderedSame) return NO;
    
    //当前cell是否可以移动
    for (NSNumber *unmovableSection in self.unmovableSections) {
        if (unmovableSection.integerValue == indexPath.section) return NO;
    }
    for (NSIndexPath *unmovableIndexPath in self.unmovableIndexPaths) {
        if ([indexPath compare:unmovableIndexPath] == NSOrderedSame) return NO;
    }
    
    //如果正在拖动的cell和目标cell不是同一组，则不允许移动
    if (movingIndexPath.section != indexPath.section) return NO;
    
    //获取目标cell中心点
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    CGPoint cellPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    //临时view中心点距目标cell中心点不大于_maxMargin时可以移动
    return fabs(cellPoint.x - currentPoint.x) <= _maxMargin && fabs(cellPoint.y - currentPoint.y) <= _maxMargin;
}

#pragma mark 🍀🍀 UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:_panGes]) {
        return _movable;
    }
    return YES;
}

@end

@implementation NSMutableArray (LCD_Move)

- (void)moveObjectAtIndex:(NSUInteger)idx1 toIndex:(NSUInteger)idx2 {
    NSAssert(idx1 < self.count && idx2 < self.count, @"数组越界");
    
    id data = [self objectAtIndex:idx1];
    [self removeObjectAtIndex:idx1];
    [self insertObject:data atIndex:idx2];
}

@end
