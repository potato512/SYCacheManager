//
//  SYCacheManager.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/12/30.
//  Copyright © 2015年 zhangshaoyu. All rights reserved.
//  数据库操作管理

/*
 https://github.com/potato512/SYCacheManager
 https://github.com/ccgus/fmdb/
 https://github.com/li6185377/LKDBHelper-SQLite-ORM
 
 使用说明
 1 关联第三方库
 1-1 FMDB
 1-2 LKDBHelper
 
 注意：
 不同用户不同文件；
 不同版本不同文件；
 
 
*/

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>

@interface SYCacheManager : NSObject

/// 数据库类型别名
+ (void)initializeWithType:(NSString *)userType;
/// 销毁单例
+ (void)releaseCache;

/// 单例
+ (SYCacheManager *)shareCache;


#pragma mark - FMDBDatabase操作

/// 创建表、删除表、保存数据、读取数据、修改数据、删除数据
@property (nonatomic, strong, readonly) FMDatabase *fmdbManager;

#pragma mark - LKDBHelper操作

@property (nonatomic, strong, readonly) LKDBHelper *lkdbManager;

/**
 *  创建表
 *
 *  @param class model
 *
 *  @return BOOL
 */
- (BOOL)newTableWithModel:(Class)class;

/**
 *  删除所有表
 */
- (void)deleteAllTableModel;
/**
 *  删除指定表
 *
 *  @param class model
 *
 *  @return BOOL
 */
- (BOOL)deleteTableWithModel:(Class)class;

/**
 *  插入数据
 *
 *  @param model 数据
 *
 *  @return BOOL
 */
- (BOOL)saveModel:(id)model;
/// 插入数据
- (void)saveModel:(id)model callback:(void (^)(BOOL result))callback;

/**
 *  修改数据
 *
 *  @param model model
 *
 *  @return BOOL
 */
- (BOOL)updateModel:(id)model;
/// 修改数据
- (void)updateModel:(id)model callback:(void (^)(BOOL result))callback;

/**
 *  修改指定条件的数据
 *
 *  @param class model
 *  @param value 修改值，如，修改名字：@"name = 'devZhang'"，或修改名字和年龄：@"name = 'devZhang', age = 10"
 *  @param where 条件，如：@"company = 'VSTECS'"
 *
 *  @return BOOL
 */
- (BOOL)updateModel:(Class)class value:(NSString *)value where:(id)where;

/**
 *  删除指定数据
 *
 *  @param model model
 *
 *  @return BOOL
 */
- (BOOL)deleteModel:(id)model;
/// 删除指定数据
- (void)deleteModel:(id)model callback:(void (^)(BOOL result))callback;
/**
 *  删除指定条件的数据
 *
 *  @param class model
 *  @param where 条件，如：@"name = 'devZhang'"，或@{@"name":"devZhang"}
 *
 *  @return BOOL
 */
- (BOOL)deleteModel:(Class)class where:(id)where;
/// 删除指定条件的数据
- (void)deleteModel:(Class)class where:(id)where callback:(void (^)(BOOL result))callback;
/**
 *  删除所有的数据
 *
 *  @param class model
 *
 *  @return
 */
- (BOOL)deleteAllModel:(Class)class;

/**
 *  查找数据
 *
 *  @param class model
 *  @param where 条件，如：@"name = 'devZhang'"，或@{@"name":"devZhang"}
 *
 *  @return NSArray
 */
- (NSArray *)readModel:(Class)class where:(id)where;
/// 查找数据
- (void)readModel:(Class)class where:(id)where callback:(void (^)(NSMutableArray *array))callback;

/**
 *  查找数据
 *
 *  @param class model
 *  @param column 查找字段，如，只查找名称、年龄：@"name,age"
 *  @param where 条件，如：@"name = 'devZhang'"，或@{@"name":"devZhang"}
 *  @param orderBy 排序，如，年龄降序、升序：@"age desc", @"age asc"
 *  @param offset 偏移，如，从第11个查找：10；从第30个查找：29
 *  @param count 查找数量，如，查找10个：10
 *
 *  @return NSArray
 */
- (NSArray *)readModel:(Class)class column:(id)column where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count;
/// 查找数据
- (void)readModel:(Class)class where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count callback:(void (^)(NSMutableArray *array))callback;

@end
