//
//  CouponColCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponColCell.h"

#import "PublicHeader.h"
#import "DateFormatTool.h"

@interface CouponColCell()

@property (nonatomic, strong) UIImageView *m_BgImgView;
@property (nonatomic, strong) UIImageView *m_MarkImgView;

@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UILabel *m_SubtitleLbl;
@property (nonatomic, strong) UILabel *m_DirectionsLbl;
@property (nonatomic, strong) UILabel *m_UsePeriodLbl;

@property (nonatomic, strong) CouponModel *m_Model;
@property (nonatomic, assign) NSIndexPath *m_IndexPath;

@end

@implementation CouponColCell
@synthesize m_BgImgView,m_MarkImgView;
@synthesize m_TitleLbl,m_SubtitleLbl,m_DirectionsLbl,m_UsePeriodLbl;

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addMainView];
        [self layoutUI];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{

    UIImageView *bgImgView = [BasisUITool getImageViewWithImage:COUPON_EFFECTIVE_BG withIsUserInteraction:NO];
    
    [bgImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_BgImgView:bgImgView];
    
    UIImageView *markImgView = [BasisUITool getImageViewWithImage:nil withIsUserInteraction:NO];

    [markImgView setHidden:YES];
    
    [self setM_MarkImgView:markImgView];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor whiteColor]
                                                          size:CLIENT_COMMON_FONT_TITLE_JUMBO_SIZE];
    
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    
    [self setM_TitleLbl:titleLbl];
    
    UILabel *subtitleLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0xde756a)
                                                             size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [self setM_SubtitleLbl:subtitleLbl];
    
    UILabel *directionsLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0x7f7f7f)
                                                               size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [self setM_DirectionsLbl:directionsLbl];
    
    UILabel *usePeriodLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0x7f7f7f)
                                                              size:CLIENT_COMMON_FONT_DETAILS_SIZE];

    [self setM_UsePeriodLbl:usePeriodLbl];
    
    [bgImgView addSubview:markImgView];
    [bgImgView addSubview:titleLbl];
    [bgImgView addSubview:subtitleLbl];
    [bgImgView addSubview:directionsLbl];
    [bgImgView addSubview:usePeriodLbl];
    
    [self.contentView addSubview:bgImgView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{
    
    [m_BgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-5.0f);
        make.leading.equalTo(self.contentView).offset(5.0f);
        
    }];
    
    [m_MarkImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_BgImgView).offset(6);
        make.right.equalTo(m_BgImgView).offset(-7);
        make.size.equalTo(CGSizeMake(61, 61));
        
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.top.equalTo(m_BgImgView).offset(34);
        make.left.equalTo(m_BgImgView).offset(CoordXSizeScale(4));
        make.width.equalTo(CoordXSizeScale(117));
        make.height.greaterThanOrEqualTo(@30);
        
    }];
    
    [m_SubtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(m_BgImgView).offset(27);
        make.left.equalTo(m_TitleLbl.mas_right).offset(10);
        make.right.equalTo(m_MarkImgView.mas_right);
        
    }];
    
    [m_DirectionsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(m_SubtitleLbl.mas_bottom).offset(17);
        make.left.equalTo(m_SubtitleLbl);
        make.right.equalTo(m_MarkImgView.mas_right);
        
    }];
    
    [m_UsePeriodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_DirectionsLbl.mas_bottom).offset(5);
        make.left.and.right.equalTo(m_DirectionsLbl);
        
    }];
    
}

- (void)setCouponColCellUpDataSource:(CouponModel *)model
               cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    NSString *title;
    NSString *directions;
    
    if (model.status) {// 已使用
        
        [m_MarkImgView setHidden:NO];
        [m_MarkImgView setImage:ImageNamed(COUPON_USED_ICO)];
        [m_BgImgView setImage:ImageNamed(COUPON_INVALID_BG)];
        
        [m_SubtitleLbl setTextColor:UIColorFromHex(0xe3e3e3)];
        
    }else{// 未使用
        
        [m_MarkImgView setHidden:YES];
        [m_MarkImgView setImage:nil];
        [m_BgImgView setImage:ImageNamed(COUPON_EFFECTIVE_BG)];
        
        [m_SubtitleLbl setTextColor:UIColorFromHex(0xde756a)];
        
    }
    
    switch (model.type) {
        case CouponType_Vouchers:{// 代金券
            
            title = [NSString stringWithFormat:@"¥%@",model.rule];
            directions = @"发耶商城";
            
            break;}
        case CouponType_Rates:{// 加息劵
            
            title = [NSString stringWithFormat:@"%@ %%",model.rule];
            directions = @"无";
            
            break;}
        case CouponType_Experience:{// 体验劵
            
            title = @"体验卷";
            directions = @"乐葫芦课程";
            
            break;}
        default:
            break;
    }
    
    NSString *usePeriod;
    
    if (IsStrEmpty(model.start_time) && IsStrEmpty(model.end_time)) {
        
        usePeriod = @"无";
        
    }else{
        
        if (!IsStrEmpty(model.start_time)) {
            
            NSDate *date = [DateFormatTool dateFormatFromString:model.start_time withFormat:nil];
            
            NSString *startTime = [DateFormatTool stringFormatFromDate:date withFormat:@"yyyy.MM.dd"];
            
            usePeriod = startTime;
            
        }
        if (!IsStrEmpty(model.end_time)) {
            
            NSDate *date = [DateFormatTool dateFormatFromString:model.end_time withFormat:nil];
            
            NSString *endTime = [DateFormatTool stringFormatFromDate:date withFormat:@"yyyy.MM.dd"];
            
            usePeriod = [NSString stringWithFormat:@"%@-%@",usePeriod,endTime];
            
            // 判断是否过期
            NSInteger results = [DateFormatTool compareDate:date withDate:[DateFormatTool obtainCurrentTime]];
            
            if (results > 0) {
                
                [m_MarkImgView setHidden:NO];
                [m_MarkImgView setImage:ImageNamed(COUPON_OVERDUE_ICO)];
                [m_BgImgView setImage:ImageNamed(COUPON_INVALID_BG)];
                
                [m_SubtitleLbl setTextColor:UIColorFromHex(0xe3e3e3)];
                
            }
            
        }
        
    }
    
    [m_TitleLbl  setText:title];
    [m_SubtitleLbl setText:model.name];
    [m_DirectionsLbl setText:[NSString stringWithFormat:@"使用条件:%@",directions]];
    [m_UsePeriodLbl setText:[NSString stringWithFormat:@"使用期限:%@",usePeriod]];
    
}

@end


@interface CouponColSelectCell ()
{
    UIImageView    *_imgvCheck;
}
@end

@implementation CouponColSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _imgvCheck = [[UIImageView alloc] init];
    [self addSubview:_imgvCheck];
    
    [_imgvCheck makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.m_BgImgView).offset(15);
        make.trailing.equalTo(self.m_BgImgView).offset(-15);
    }];
}

- (void)actionSelect:(UIButton *)button
{
    button.selected = !button.isSelected;
}

- (void)setDmCoupon:(CouponSelDM *)dmCoupon
{
    _dmCoupon = dmCoupon;
    [super setCouponColCellUpDataSource:dmCoupon cellForRowAtIndexPath:nil];
    
    if (dmCoupon.selected) {
        _imgvCheck.image = [UIImage imageNamed:@"shop_coupon_sel"];
    } else {
        _imgvCheck.image = [UIImage imageNamed:@"shop_coupon_nor"];
    }
}

@end
