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

/**
 *  修改数据
 *
 *  @param model model
 *
 *  @return BOOL
 */
- (BOOL)updateModel:(id)model;

/**
 *  修改指定条件的数据
 *
 *  @param class model
 *  @param value 修改值，如：@"name = 'devZhang'"
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
/**
 *  删除指定条件的数据
 *
 *  @param class model
 *  @param where 条件，如：@"name = 'devZhang'"
 *
 *  @return BOOL
 */
- (BOOL)deleteModel:(Class)class where:(id)where;

/**
 *  查找数据
 *
 *  @param class model
 *  @param where 条件，如：@"name = 'devZhang'"
 *
 *  @return NSArray
 */
- (NSArray *)readModel:(Class)class where:(id)where;


@end