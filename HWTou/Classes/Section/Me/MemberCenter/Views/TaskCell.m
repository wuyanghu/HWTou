//
//  TaskCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TaskCell.h"

#import "PublicHeader.h"

@interface TaskCell()

@property (nonatomic, strong) UIImageView *m_ImgView;
@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UILabel *m_RemarkLbl;
@property (nonatomic, strong) UIButton *m_TaskBtn;
@property (nonatomic, strong) UIView *m_LineView;

@property (nonatomic, strong) TaskModel *m_TaskModel;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation TaskCell
@synthesize m_Delegate;

@synthesize m_ImgView;
@synthesize m_TitleLbl,m_RemarkLbl;
@synthesize m_TaskBtn;
@synthesize m_LineView;

@synthesize m_TaskModel;
@synthesize m_IndexPath;

#pragma mark - 初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addMainView];
        [self layoutUI];
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

#pragma mark - Add UI
- (void)addMainView{

    [self addViews];
    
}

- (void)addViews{

    UIImageView *imgView = [BasisUITool getImageViewWithImage:ME_IMG_ACTIVITY_DEFAULT
                                        withIsUserInteraction:NO];
    
    [self setM_ImgView:imgView];
    [self.contentView addSubview:imgView];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:TABLEVIEW_COMMON_FONT_TITLE_SIZE];
    
    [self setM_TitleLbl:titleLbl];
    [self.contentView addSubview:titleLbl];
    
    UILabel *remarkLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                           size:TABLEVIEW_COMMON_FONT_DETAILS_SIZE];
    
    [self setM_RemarkLbl:remarkLbl];
    [self.contentView addSubview:remarkLbl];
    
    UIButton *taskBtn = [BasisUITool getBtnWithTarget:self action:@selector(taskBtnClick:)];
    
    [taskBtn setBackgroundColor:[UIColor whiteColor]];
    [taskBtn setTitle:@"去完成" forState:UIControlStateNormal];
    [taskBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR) forState:UIControlStateNormal];
    
    [taskBtn.layer setBorderWidth:1];
    [taskBtn.layer setBorderColor:[UIColorFromHex(CLIENT_LINE_RED_BG) CGColor]];
    
    [self setM_TaskBtn:taskBtn];
    [self.contentView addSubview:taskBtn];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self setM_LineView:lineView];
    [self.contentView addSubview:lineView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{
    
    [m_ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.equalTo(CGSizeMake(60, 60));
        
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_ImgView.mas_top).offset(12.5);
        make.left.equalTo(m_ImgView.mas_right).offset(5);
        make.right.equalTo(m_TaskBtn.mas_left).offset(-10);
        make.bottom.equalTo(m_RemarkLbl.mas_top).offset(-8);
        
    }];
    
    [m_RemarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_TitleLbl.mas_bottom).offset(8);
        make.left.and.right.equalTo(m_TitleLbl);
        
    }];
    
    [m_TaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(m_ImgView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.equalTo(CGSizeMake(50, 30));
        
    }];
    
    [m_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.equalTo(0.5);
        
    }];
    
}

- (void)setTaskCellWithDataSource:(TaskModel *)model withIsEnd:(BOOL)isEnd
        withCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setM_TaskModel:model];
    [self setM_IndexPath:indexPath];

    [m_ImgView setImage:ImageNamed(model.m_ImgName)];
    [m_TitleLbl setText:model.m_Title];
    [m_RemarkLbl setText:model.m_Remark];
    [m_LineView setHidden:isEnd];
    
}

#pragma mark - Button Handlers
- (void)taskBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onSelTaskItem:cellForRowAtIndexPath:)]) {
        
        [m_Delegate onSelTaskItem:m_TaskModel cellForRowAtIndexPath:m_IndexPath];
        
    }
    
}

@end
