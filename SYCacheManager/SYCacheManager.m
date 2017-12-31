//
//  SYCacheManager.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/12/30.
//  Copyright © 2015年 zhangshaoyu. All rights reserved.
//

#import "SYCacheManager.h"

// 类型定义
static NSString *userId = nil;
// 便于单例销毁控制
static SYCacheManager *sharedManager;
static dispatch_once_t onceToken;
//
static NSString *const dataName = @"SYFMDB.db";

@interface SYCacheManager ()

@property (nonatomic, strong) NSString *dataPath; // 数据库文件目录

// FMDB
@property (nonatomic, strong) FMDatabase *dataBase; // 是一个提供 SQLite 数据库的类，用于执行 SQL 语句。
//@property (nonatomic, strong) FMResultSet *dataResult; // 用在 FMDatabase 中执行查询的结果的类。
@property (nonatomic, strong) FMDatabaseQueue *dataQueue; // 在多线程下查询和更新数据库用到的类。


// LKDBHelper
@property (nonatomic, strong) LKDBHelper *dataHelper; // 数据库

@end

@implementation SYCacheManager

#pragma mark - 实例化

// 初始化数据库类型
+ (void)initializeWithType:(NSString *)userType
{
    userId = userType;
}

// 销毁单例
+ (void)releaseCache
{
    sharedManager = nil;
    onceToken=0l;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *documentDirectory = [paths objectAtIndex:0];
//        self.dataPath = [documentDirectory stringByAppendingPathComponent:dataName];
        
        // 区分每个类型数据库
        NSString *userType = (userId ? userId : @"");
        NSString *userDBName = [NSString stringWithFormat:@"%@%@", userType, dataName];
        self.dataHelper = [[LKDBHelper alloc] initWithDBName:userDBName];
    }
    
    return self;
}

- (void)dealloc
{
    self.dataPath = nil;
    self.dataHelper = nil;
}

/// 单例
+ (SYCacheManager *)shareCache
{
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        assert(sharedManager != nil);
    });
    
    return sharedManager;
}

#pragma mark - 存储路径

- (NSString *)dataPath
{
    if (_dataPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        _dataPath = [documentDirectory stringByAppendingPathComponent:dataName];
        
        NSLog(@"_dataPath = %@", _dataPath);
    }
    return _dataPath;
}

#pragma mark - FMDB操作

- (FMDatabase *)dataBase
{
    if (_dataBase == nil)
    {
        _dataBase = [FMDatabase databaseWithPath:self.dataPath];
    }
    return _dataBase;
}

- (FMDatabase *)fmdbManager
{
    return self.dataBase;
}

- (FMDatabaseQueue *)dataQueue
{
    if (_dataQueue == nil)
    {
        _dataQueue = [FMDatabaseQueue databaseQueueWithPath:self.dataPath];
    }
    return _dataQueue;
}

#pragma mark 创建表/删除表

/*
- (void)tableManager
{
    // 四种语句等价方法
    // 1. 直接使用完整的SQL更新语句
    [database executeUpdate:@"insert into mytable(num,name,sex) values(0,'liuting','m');"];

    2. 使用不完整的SQL更新语句，里面含有待定字符串"?"，需要后面的参数进行替代
    NSString *sql = @"insert into mytable(num,name,sex) values(?,?,?);";
    [database executeUpdate:sql,@0,@"liuting",@"m"];

    // 3. 使用不完整的SQL更新语句，里面含有待定字符串"?"，需要数组参数里面的参数进行替代
    [database executeUpdate:sql withArgumentsInArray:@[@0,@"liuting",@"m"]];

    // 4. SQL语句字符串可以使用字符串格式化，这种我们应该比较熟悉
    [database executeUpdateWithFormat:@"insert into mytable(num,name,sex) values(%d,%@,%@);",0,@"liuting","m"];



    // 创建表：CREATE TABLE IF NOTEXISTS 表名 (字段名 字段类型, ...,)
    if ([self.dataBase open])
    {
        NSString *createTabel = @"CREATE TABLE if not exists CompanyTable (departmentId text PRIMARY KEY, departmentNametext, departmentStatus text)";
        BOOL isResult = [self.dataBase executeUpdate:createTabel];
        NSLog(@"createTabel = %@", (isResult ? @"success" : @"error"));
        [self.dataBase close];
    }
    
    // 删除表：DROP TABLE 表名
    if ([self.dataBase open])
    {
        NSString *deleteTabel = @"DROP TABLE CompanyTable";
        BOOL isResult = [self.dataBase executeUpdate:deleteTabel];
        NSLog(@"deleteTabel = %@", (isResult ? @"success" : @"error"));
        [self.dataBase close];
    }
}
*/

#pragma mark 插入数据/删除数据/修改数据/读取数据

/*
- (void)dataManager
{
    // 插入数据：INSERT INTO 表名 (字段名, ... ) VALUES (?, ...)
    if ([self.dataBase open])
    {
        NSString *saveData = @"INSERT INTO CompanyTable (departmentId, departmentName, departmentStatus) VALUES (?,?,?)";
        BOOL isResult = [self.dataBase executeUpdate:saveData, @"168", @"互联网部门", @"禁用"];
        NSLog(@"saveData = %@", (isResult ? @"success" : @"error"));
        [self.dataBase close];
    }
    
    // 删除数据：DELETE FROM 表名 WHERE 字段名称 = 字段值
    if ([self.dataBase open])
    {
        NSString *deleteData = @"DELETE FROM CompanyTable";
        BOOL isResult = [self.dataBase executeUpdate:deleteData];
        NSLog(@"deleteData = %@", (isResult ? @"success" : @"error"));
        [self.dataBase close];
    }
    
    // 修改数据：UPDATE 表名 set 字段名称 = 字段值 WHERE 字段值 = 字段名称
    if ([self.dataBase open])
    {
        NSString *modifyData = @"UPDATE CompanyTable set departmentStatus = ? where departmentName = ?";
        BOOL isResult = [self.dataBase executeUpdate:modifyData, @"启用", @"互联网部门"];
        NSLog(@"modifyData = %@", (isResult ? @"success" : @"error"));
        [self.dataBase close];
    }
    
    // 读取数据：SELECT 字段名称 FROM 表名 WHERE 字段名称 = 字段值
    if ([self.dataBase open])
    {
        NSString *readData = @"SELECT * FROM CompanyTable WHERE departmentName = ?";
        FMResultSet *result = [self.dataBase executeQuery:readData, @"互联网部门"];
        // 单条数据
        if ([result next])
        {
             NSString *idStr = [result stringForColumn:@"departmentId"];
             NSString *nameStr = [result stringForColumn:@"departmentName"];
             NSString *statusStr = [result stringForColumn:@"departmentStatus"];
             
             NSLog(@"查找数据成功。\nid = %@, name = %@, status = %@", idStr, nameStr, statusStr);
        }
        // 全部数据
        while ([result next])
        {
            NSString *idStr = [result stringForColumn:@"departmentId"];
            NSString *nameStr = [result stringForColumn:@"departmentName"];
            NSString *statusStr = [result stringForColumn:@"departmentStatus"];
            
            NSLog(@"查找数据成功。\nid = %@, name = %@, status = %@", idStr, nameStr, statusStr);
        }
        [self.dataBase close];
    }
}
*/

#pragma mark - LKDB操作

//- (LKDBHelper *)dataHelper
//{
//    if (_dataHelper == nil)
//    {
//        _dataHelper = [[LKDBHelper alloc] initWithDBName:self.dataPath];
//    }
//    return _dataHelper;
//}

- (LKDBHelper *)lkdbManager
{
    return self.dataHelper;
}

#pragma mark 创建表

- (BOOL)newTableWithModel:(Class)class
{
    BOOL isResult = NO;
    if ([self.dataHelper isExistsWithTableName:NSStringFromClass(class) where:nil])
    {
        isResult = YES;
        NSLog(@"newTableWithModel = 已存在");
    }
    else
    {
        isResult = [self.dataHelper createTableWithModelClass:class];
    }
    NSLog(@"newTableWithModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

#pragma mark 删除表

- (void)deleteAllTableModel
{
    [self.dataHelper dropAllTable];
}

- (BOOL)deleteTableWithModel:(Class)class
{
    BOOL isResult = [self.dataHelper dropTableWithClass:class];
    NSLog(@"deleteTableWithModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

#pragma mark 插入数据

- (BOOL)saveModel:(id)model
{
    BOOL isResult = NO;

    if ([self.dataHelper isExistsModel:model])
    {
        // 已存在时，先删除，且删除成功再保存
        if ([self deleteModel:model])
        {
            isResult = [self.dataHelper insertWhenNotExists:model];
        }
    }
    else
    {
        // 不存在时，直接保存
        isResult = [self.dataHelper insertWhenNotExists:model];
    }
    
    NSLog(@"saveModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

- (void)saveModel:(id)model callback:(void (^)(BOOL result))callback
{
    if ([self.dataHelper isExistsModel:model])
    {
        // 已存在时，先删除，且删除成功再保存
        if ([self deleteModel:model])
        {
            [self.dataHelper insertToDB:model callback:^(BOOL result) {
                NSLog(@"saveModel = %@", (result ? @"success" : @"error"));
                if (callback)
                {
                    callback(result);
                }
            }];
        }
    }
    else
    {
        // 不存在时，直接保存
        [self.dataHelper insertToDB:model callback:^(BOOL result) {
            NSLog(@"saveModel = %@", (result ? @"success" : @"error"));
            if (callback)
            {
                callback(result);
            }
        }];
    }
}

#pragma mark 修改数据

- (BOOL)updateModel:(id)model
{
    BOOL isResult = [self.dataHelper updateToDB:model where:nil];
    NSLog(@"updateModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

- (void)updateModel:(id)model callback:(void (^)(BOOL result))callback
{
    [self.dataHelper updateToDB:model where:nil callback:^(BOOL result) {
        NSLog(@"updateModel = %@", (result ? @"success" : @"error"));
        if (callback)
        {
            callback(result);
        }
    }];
}

- (BOOL)updateModel:(Class)class value:(NSString *)value where:(id)where
{
    BOOL isResult = [self.dataHelper updateToDB:class set:value where:where];
    NSLog(@"updateModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

#pragma mark 删除数据

- (BOOL)deleteModel:(id)model
{
    [self.dataHelper deleteToDB:model callback:^(BOOL result) {
        
    }];
    BOOL isResult = [self.dataHelper deleteToDB:model];
    NSLog(@"deleteModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

- (void)deleteModel:(id)model callback:(void (^)(BOOL result))callback
{
    [self.dataHelper deleteToDB:model callback:^(BOOL result) {
        NSLog(@"deleteModel = %@", (result ? @"success" : @"error"));
        if (callback)
        {
            callback(result);
        }
    }];
}

- (BOOL)deleteModel:(Class)class where:(id)where
{
    BOOL isResult = [self.dataHelper deleteWithClass:class where:where];
    NSLog(@"deleteModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

- (void)deleteModel:(Class)class where:(id)where callback:(void (^)(BOOL result))callback
{
    [self.dataHelper deleteWithClass:class where:where callback:^(BOOL result) {
        NSLog(@"deleteModel = %@", (result ? @"success" : @"error"));
        if (callback)
        {
            callback(result);
        }
    }];
}

- (BOOL)deleteAllModel:(Class)class
{
//    [LKDBHelper clearTableData:class];
    BOOL isResult = [self.dataHelper deleteWithClass:class where:nil];
    NSLog(@"deleteModel = %@", (isResult ? @"success" : @"error"));
    return isResult;
}

#pragma mark 查找数据

- (NSArray *)readModel:(Class)class where:(id)where
{
    NSArray *array = [self readModel:class column:nil where:where orderBy:nil offset:0 count:0];
    return array;
}

- (void)readModel:(Class)class where:(id)where callback:(void (^)(NSMutableArray *array))callback
{
    [self readModel:class where:where orderBy:nil offset:0 count:0 callback:callback];
}

- (NSArray *)readModel:(Class)class column:(id)column where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count
{
    // 查找字段：@"字段1,字段2"
    
    // 查找条件：
    //  根据 and 条件 查询所有数据 NSString *conditions = @"age = 23 and name = '张三1'";
    //  根据 字典条件，查询所有数据 NSDictionary *conditions1 = @{@"age" : @23, @"name" : @"张三1"};
    //  根据 or 条件，查询所有数据 NSString *conditions2 = @"age = 23 or ID = 5";
    //  根据 in 条件，查询所有数据 NSString *conditions3 = @"age in (23, 24)";
    //  根据 字典 in 条件，查询所有数据 NSDictionary *conditions4 = @{@"age" : @[@23, @24]};
    //  查询符合条件的数据有多少条 NSString *conditions5 = @"age = 23 and name = '张三1'";
    
    // 排序查询：升序 "排序字段 asc"; 降序 "排序字段 desc"
    
    // 偏移量：10表示从第11个读取，23表示从第24个读取
    
    // 读取数量：10表示从数据库读10个
    
    NSArray *array = [self.dataHelper search:class column:column where:where orderBy:orderBy offset:offset count:count];
    return array;
}

- (void)readModel:(Class)class where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count callback:(void (^)(NSMutableArray *array))callback
{
    [self.dataHelper search:class where:where orderBy:orderBy offset:offset count:count callback:^(NSMutableArray *array) {
        if (callback)
        {
            callback(array);
        }
    }];
}

@end
