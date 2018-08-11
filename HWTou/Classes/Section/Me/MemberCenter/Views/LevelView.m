//
//  LevelView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LevelView.h"

#import "PublicHeader.h"

#define LevelViewItemWidth          (35)
#define LevelViewHeight             (64)
#define LevelViewspacingWidth       (30)
#define LevelViewspacingHeight      (10)

#define LevelImageSelectedWidth     (35)
#define LevelImageNormalWidth       (27.5)

#define LevelViewBottomViewHeight   (16)

#define ColorTmpYellow ([UIColor colorWithRed:255.0/255.0 green:201/255.0 blue:69/255.0 alpha:1])

@interface LevelView ()

@property (nonatomic, strong) NSArray *nameList;
@property (nonatomic, strong) NSMutableArray *lbList;

@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) NSMutableArray *imgList;

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, strong) UIImageView *triangleV;
@property (nonatomic, assign) NSInteger tmpSelectedIndex;

@end


@implementation LevelView

- (instancetype) initWithFrame:(CGRect) frame Names:(NSArray<NSString*>*) names icons:(NSArray<NSString*>*) icons {
    self = [super initWithFrame:frame];
    if (self) {
        if (names == nil || names.count <= 0) {
            _nameList = @[];
        } else {
            _nameList = [names copy];
        }
        
        if (icons == nil || icons.count <= 0) {
            _iconList = @[];
        } else {
            _iconList = [icons copy];
        }
        
        CGFloat width = names.count * LevelViewItemWidth + names.count * LevelViewspacingWidth - LevelViewspacingWidth;
        if (width <= 0) {
            width = LevelViewItemWidth;
        }
        
        if (_iconList.count != names.count) {
            _iconList = @[];
            _nameList = @[];
        }
        
        _lbList = [NSMutableArray arrayWithCapacity:0];
        _imgList = [NSMutableArray arrayWithCapacity:0];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, LevelViewHeight);
        
        [self loadComponents];
    }
    
    return self;
}

- (void) loadComponents {
    if (_bottomV != nil) {
        return;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    _topV = [[UIView alloc] init];
    _topV.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), LevelImageSelectedWidth);
    _topV.backgroundColor = [UIColor clearColor];
    [self addSubview:_topV];
    
    _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, LevelViewHeight - LevelViewBottomViewHeight, CGRectGetWidth(self.frame), LevelViewBottomViewHeight)];
    _bottomV.backgroundColor = ColorTmpYellow;
    _bottomV.layer.borderColor = [UIColor whiteColor].CGColor;
    _bottomV.layer.borderWidth = 0.1;
    _bottomV.layer.cornerRadius = 6;
    _bottomV.layer.shadowRadius = 2.0;
    _bottomV.layer.shadowOffset = CGSizeMake(1, 1);
    _bottomV.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _bottomV.layer.shadowOpacity = 0.2;
    [self addSubview:_bottomV];
    
    NSInteger index = 0;
    NSInteger count = _nameList.count;
    if (count <= 0) {
        count = 1;
    }
    
    for (NSString* name in _nameList) {
        CGFloat tmpWidth = CGRectGetWidth(_bottomV.frame) / count;
        CGFloat x = index * tmpWidth;
        
        UILabel *nameLb = [self nameLabelWithName:name];
        nameLb.frame = CGRectMake(x, 0, tmpWidth, CGRectGetHeight(_bottomV.frame));
        [_bottomV addSubview:nameLb];
        
        [_lbList addObject:nameLb];
        
        index++;
    }
    
    index = 0;
    CGFloat firstX = 0;
    for (NSString *imgName in _iconList) {
        UILabel *tmpLb = [_lbList objectAtIndex:index];
        
        CGFloat centerY = LevelImageSelectedWidth / 2.0;
        CGFloat centerX = tmpLb.center.x;
        
        if (index == 0) {
            firstX = centerX;
        }
        
        UIImageView *imgV = [self levelImageView:imgName];
        
        if (index == 0) {
            imgV.frame = CGRectMake(0, 0, LevelImageSelectedWidth, LevelImageSelectedWidth);
        } else {
            imgV.frame = CGRectMake(0, 0, LevelImageNormalWidth, LevelImageNormalWidth);
        }
        
        imgV.center = CGPointMake(centerX, centerY);
        
        [_topV addSubview:imgV];
        
        [_imgList addObject:imgV];
        
        index++;
    }
    
    _triangleV = [[UIImageView alloc] init];
    _triangleV.image = [UIImage imageNamed:ME_IMG_TRIANGLE_YELLOW_ICO];
    _triangleV.frame = CGRectMake(0, 0, 10, 8);
    [self addSubview:_triangleV];
    
    _triangleV.center = CGPointMake(firstX, _bottomV.frame.origin.y - 2);
    
    _tmpSelectedIndex = 0;
}

- (UILabel*) nameLabelWithName:(NSString*) name {
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor whiteColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:12];
    lb.text = [name copy];
    
    return lb;
    
}

- (UIImageView*) levelImageView:(NSString*) imgName {
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:imgName];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    
    return imgV;
    
}

- (void) updateSelectLevel:(NSString *)levelName {
    NSInteger index = 0;
    for (; index < _nameList.count; index++) {
        NSString *tmpName = [_nameList objectAtIndex:index];
        if ([tmpName isEqualToString:levelName]) {
            break;
        }
    }
    
    NSInteger tmpIndex = 0;
    for (; tmpIndex < _imgList.count; tmpIndex++) {
        UIImageView *imgV = [_imgList objectAtIndex:tmpIndex];
        CGPoint center = imgV.center;
        
        if (tmpIndex == index) {
            imgV.frame = CGRectMake(0, 0, LevelImageSelectedWidth, LevelImageSelectedWidth);
            
            CGFloat oldCenterY = _triangleV.center.y;
            _triangleV.center = CGPointMake(center.x, oldCenterY);
        } else {
            imgV.frame = CGRectMake(0, 0, LevelImageNormalWidth, LevelImageNormalWidth);
        }
        
        imgV.center = center;
    }
    
    _tmpSelectedIndex = index;
}

- (NSInteger) selectedIndex {
    return _tmpSelectedIndex;
}

@end
