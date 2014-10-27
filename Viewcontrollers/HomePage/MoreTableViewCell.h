//
//  MoreTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreTableViewCellHideInterface <NSObject>
@optional
-(void)hideScrollview;
@end

@protocol MoreTableCellClickInterface <NSObject>
@optional
- (void)didClickedButtonWithTag:(NSInteger)index withMark:(NSInteger)markTag;

@end

@interface MoreTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UIImageView     *imgView;
@property(nonatomic,strong)UIImageView     *moreImg;
@property(nonatomic,strong)UIScrollView    *contentScroll;
@property(nonatomic ,strong)UILabel        *moreLab;

@property(nonatomic,assign)NSInteger       marked;  //标识使用者;

@property(nonatomic,strong) NSMutableArray *textIconArr;
@property(nonatomic,assign) BOOL           useLoadMore;
@property(nonatomic,assign) id<MoreTableViewCellHideInterface> hideDelegate;
@property(nonatomic,assign) id<MoreTableCellClickInterface> clickDelegate;

-(id)initScrollView:(NSArray*)withScrollData reuseIdentifier:(NSString *)reuseIdentifier :(BOOL)isneedRect;
@end
