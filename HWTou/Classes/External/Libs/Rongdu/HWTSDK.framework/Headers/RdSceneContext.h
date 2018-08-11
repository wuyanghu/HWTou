//
//  RdSceneContext.h
//  demoapp
//
//  Created by Yosef Lin on 2/15/16.
//  Copyright © 2016 RongDu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 会话状态。会话可用于保存跨ViewController的短生命周期状态。
 */
@interface RdSceneContext : NSObject

#pragma mark Properties

/**
 * 会话ID
 */
@property(nonatomic,strong)NSString*    contextId;

#pragma mark Class Methods

/**
 * 创建或获取一个上下文实例，若上下文已存在，则返回已存在的上下文
 *
 * @param contextId 上下文标识  使用场景:controller 以跳转的class name命名
 * @return 返回场景上下文实例
 */
+(RdSceneContext*)contextWithId:(NSString*)contextId;

/**
 * 获取一个上下文实例，若上下文不存在，则返回nil
 *
 * @param contextId 上下文标识
 * @return 返回场景上下文实例
 */
+(RdSceneContext*)findContextWithId:(NSString*)contextId;

#pragma mark Instance Methods
/**
 * 关闭并删除会话
 */
- (void)close;

//------------------------------------------------------
- (BOOL)booleanForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (float)floatForKey:(id)key;
- (NSString*)stringForKey:(id)key;
- (id)objectForKey:(id)key;

- (void)setBoolean:(BOOL)value forKey:(id)key;
- (void)setInteger:(NSInteger)value forKey:(id)key;
- (void)setFloat:(float)value forKey:(id)key;
- (void)setString:(NSString*)value forKey:(id)key;
- (void)setObject:(id)value forKey:(id)key;

@end
