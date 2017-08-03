//
//  LCMovableCollectionView.h
//  DragCollectionView
//
//  Created by lc on 2017/7/31.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LCMovableCollectionViewMoveCallBack)(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath);


/**
 能够拖动排序的collectionView（仅支持同组之间拖动）
 */
@interface LCMovableCollectionView : UICollectionView

- (instancetype)init __attribute__((deprecated("use initWithFrame:collectionViewLayout:callBack: method instead")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((deprecated("use initWithFrame:collectionViewLayout:callBack: method instead")));
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout __attribute__((deprecated("use initWithFrame:collectionViewLayout:callBack: method instead")));


/**
 实例化方法

 @param frame <#frame description#>
 @param layout <#layout description#>
 @param moveCallBack 移动后的回调（在此回调中更新数据）
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                 moveCallBack:(LCMovableCollectionViewMoveCallBack)moveCallBack;

/** 是否可以移动 */
@property (assign, nonatomic) BOOL movable;

/** 当前位置距目标cell中心点x、y值的小于该值时可以移动cell（默认是10） */
@property (assign, nonatomic) CGFloat maxMargin;

/** 不可以移动的cell的indexPath（每组的前几个） */
@property (strong, nonatomic) NSArray<NSIndexPath *> *unmovableIndexPaths;

/** 不可以移动的section */
@property (strong, nonatomic) NSArray<NSNumber *> *unmovableSections;

@end

@interface NSMutableArray (LCD_Move)


/** 移动数组中的元素 */
- (void)moveObjectAtIndex:(NSUInteger)idx1 toIndex:(NSUInteger)idx2;

@end
