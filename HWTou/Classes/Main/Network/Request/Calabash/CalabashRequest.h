//
//  CalabashRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "CourseModel.h"
#import "MomentModel.h"

typedef NS_ENUM(NSInteger,  CourseType){

    CourseType_All = 0, // 所有课程
    CourseType_New,     // 最新课程
    
};

#pragma mark - 请求参数
@interface CalabashParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;     // 分页当前页码（从0开始）
@property (nonatomic, assign) NSInteger pages;          // 分页每页数量 (建议20以内)

@end

// 课程列表
@interface CourseListParam : CalabashParam

@property (nonatomic, assign) CourseType now_type;
@property (nonatomic, strong) NSString *title;          // 关键字查询 （可以不填）

@end

// 课程报名
@interface CoursesEnrolmentParam : BaseParam

@property (nonatomic, assign) NSInteger c_id;           // 课程 ID
@property (nonatomic, assign) NSInteger stu_id;         // 学号 ID
@property (nonatomic, assign) NSInteger address_id;     // 地址 ID

@end

// 教师列表
@interface TeachersListParam : CalabashParam



@end

@interface MomentParam : BaseParam

@property (nonatomic, strong) NSString *remark;             // 分享内容（图片不为空时，改值可以为空）
@property (nonatomic, strong) NSArray<NSString *> *imgs;    // 图片列表（分享内容不为空时，改列表可以为空）

@end

#pragma mark - 请求响应 结果
@interface CalabashResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;            // 总数

@end

// 课程
@interface CalabashCourseResult : CalabashResult

@property (nonatomic, strong) NSArray<CourseModel *> *list;     // 课程列表数据

@end

// 教师
@interface CalabashTeachersResult : CalabashResult

@property (nonatomic, strong) NSArray<TeacherModel *> *list;    // 教师列表数据

@end

// 圈子
@interface CalabashMomentResult : CalabashResult

@property (nonatomic, strong) NSArray<MomentModel *> *list;     // 圈子列表

@end

#pragma mark - 请求响应
@interface CalabashResponse : BaseResponse



@end

@interface CalabashCourseResponse : CalabashResponse

@property (nonatomic, strong) CalabashCourseResult *data;

@end

@interface CalabashTeachersResponse : CalabashResponse

@property (nonatomic, strong) CalabashTeachersResult *data;

@end

@interface CalabashMomentResponse : CalabashResponse

@property (nonatomic, strong) CalabashMomentResult *data;

@end

#pragma mark - 请求执行
@interface CalabashRequest : SessionRequest

/**
 *  @brief 热门课程列表
 *
 *  @param param    CourseListParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainMostPopularCoursesListWithParam:(CourseListParam *)param
                                      success:(void (^)(CalabashCourseResponse *response))success
                                      failure:(void (^)(NSError *error))failure;

/**
 *  @brief 课程报名
 *
 *  @param param    CoursesEnrolmentParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)coursesEnrolmentWithParam:(CoursesEnrolmentParam *)param
                          success:(void (^)(BaseResponse *response))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  @brief 热门教师列表
 *
 *  @param param    TeachersListParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainPopularTeacherListWithParam:(TeachersListParam *)param
                                  success:(void (^)(CalabashTeachersResponse *response))success
                                  failure:(void (^)(NSError *error))failure;

/**
 *  @brief 圈子列表
 *
 *  @param param    CalabashParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainMomentsListWithParam:(CalabashParam *)param
                           success:(void (^)(CalabashMomentResponse *response))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  @brief 发布圈子-分享心情
 *
 *  @param param    MomentParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)shareMomentsWithParam:(MomentParam *)param
                      success:(void (^)(BaseResponse *response))success
                      failure:(void (^)(NSError *error))failure;

@end
