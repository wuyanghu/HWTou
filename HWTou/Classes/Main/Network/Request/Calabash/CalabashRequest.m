//
//  CalabashRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CalabashRequest.h"

typedef NS_ENUM(NSInteger, CalabashRequestType){
    
    CalabashRequestType_Courses,        // 热门课程列表获取
    CalabashRequestType_CoursesCreate,  // 课程报名接口
    CalabashRequestType_Teacher,        // 热门教师列表获取
    CalabashRequestType_Coterie,        // 圈子列表获取
    CalabashRequestType_CoterieCreate,  // 发布圈子-分享心情
    
};

#pragma mark - 请求参数
@implementation CalabashParam
@synthesize start_page,pages;



@end

@implementation CourseListParam
@synthesize now_type;
@synthesize title;



@end

@implementation CoursesEnrolmentParam
@synthesize c_id,stu_id,address_id;



@end

@implementation TeachersListParam



@end

@implementation MomentParam
@synthesize remark;
@synthesize imgs;


@end

#pragma mark - 请求响应 结果
@implementation CalabashResult
@synthesize total_pages;

@end

@implementation CalabashCourseResult
@synthesize list;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [CourseModel class]};
    
}

@end

@implementation CalabashTeachersResult
@synthesize list;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [TeacherModel class]};
    
}

@end

@implementation CalabashMomentResult
@synthesize list;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [MomentModel class]};
    
}

@end

#pragma mark - 请求响应
@implementation CalabashResponse



@end

@implementation CalabashCourseResponse
@synthesize data;



@end

@implementation CalabashTeachersResponse
@synthesize data;



@end

@implementation CalabashMomentResponse
@synthesize data;



@end

#pragma mark - 请求执行
@implementation CalabashRequest

static CalabashRequestType requestType;

+ (NSString *)requestApiPath{
    
    NSString *apiStr;
    
    switch (requestType) {
        case CalabashRequestType_Courses:{
            
            apiStr = @"courses/courses-api/index";
            
            break;}
        case CalabashRequestType_CoursesCreate:{
            
            apiStr = @"courses/enlist-api/create";
            
            break;}
        case CalabashRequestType_Teacher:{
            
            apiStr = @"teacher/teacher-api/index";
            

            break;}
        case CalabashRequestType_Coterie:{
            
            apiStr = @"coterie/coterie-api/index";
            

            break;}
        case CalabashRequestType_CoterieCreate:{
            
            apiStr = @"coterie/coterie-api/create";
            

            break;}
        default:
            break;
    }
    
    return apiStr;
    
}

// 热门课程列表
+ (void)obtainMostPopularCoursesListWithParam:(CourseListParam *)param
                                      success:(void (^)(CalabashCourseResponse *response))success
                                      failure:(void (^)(NSError *error))failure{

    requestType = CalabashRequestType_Courses;
    
    [super requestWithParam:param responseClass:[CalabashCourseResponse class]
                    success:success failure:failure];
    
}

// 课程报名
+ (void)coursesEnrolmentWithParam:(CoursesEnrolmentParam *)param
                          success:(void (^)(BaseResponse *response))success
                          failure:(void (^)(NSError *error))failure{

    requestType = CalabashRequestType_CoursesCreate;
    
    [super requestWithParam:param responseClass:[BaseResponse class]
                    success:success failure:failure];
    
}

// 热门教师列表
+ (void)obtainPopularTeacherListWithParam:(TeachersListParam *)param
                                  success:(void (^)(CalabashTeachersResponse *response))success
                                  failure:(void (^)(NSError *error))failure{

    requestType = CalabashRequestType_Teacher;
    
    [super requestWithParam:param responseClass:[CalabashTeachersResponse class]
                    success:success failure:failure];
    
}

// 圈子列表
+ (void)obtainMomentsListWithParam:(CalabashParam *)param
                           success:(void (^)(CalabashMomentResponse *response))success
                           failure:(void (^)(NSError *error))failure{

    requestType = CalabashRequestType_Coterie;
    
    [super requestWithParam:param responseClass:[CalabashMomentResponse class]
                    success:success failure:failure];
    
}

// 发布圈子-分享心情
+ (void)shareMomentsWithParam:(MomentParam *)param
                      success:(void (^)(BaseResponse *response))success
                      failure:(void (^)(NSError *error))failure{

    requestType = CalabashRequestType_CoterieCreate;
    
    [super requestWithParam:param responseClass:[BaseResponse class]
                    success:success failure:failure];
    
}

@end
