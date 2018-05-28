# SYCacheManager
缓存数据管理
使用FMDB、LKDBHelper进行二次封装使用。

# 效果图

![FMDB](./FMDB.gif)

![LKDBHelper](./LKDBHelper.gif)

# 使用示例

### 导入头文件
~~~ javascript
#import "SYCacheManager.h"
~~~

### 创建表
~~~ javascript
[[SYCacheManager shareCache] newTableWithModel:[LKDBModel class]];
~~~

### 删除表
~~~ javascript
[[SYCacheManager shareCache] deleteTableWithModel:[LKDBModel class]];
~~~ 

### 保存
~~~ javascript
LKDBModel *model = [LKDBModel new];
model.name = @"devZhang";
model.age = @"30";
model.company = @"VSTECS";

[[SYCacheManager shareCache] saveModel:model];
~~~

### 删除
~~~ javascript
// 方法1
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
[[SYCacheManager shareCache] deleteModel:[LKDBModel class] where:where];
~~~

~~~ javascript
// 方法2
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[self.cacheManager deleteModel:model];
~~~

~~~ javascript
// 方法3
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[self.cacheManager deleteModel:model callback:^(BOOL result) {

}];
~~~ 

### 修改
~~~ javascript
// 方法1
NSString *name = @"devZhang";
NSString *where = [NSString stringWithFormat:@"name = '%@'", name];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[[SYCacheManager shareCache] updateModel:model];
~~~

~~~ javascript
// 方法2
[self.cacheManager updateModel:[LKDBModel class] value:@"age = 1, company = 'company:1'" where:where];
~~~

~~~ javascript
// 方法3 条件更新回调
NSString *name = @"devZhang";
NSString *where = [NSString stringWithFormat:@"name = '%@'", name];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[self.cacheManager updateModel:model callback:^(BOOL result) {

}];
~~~ 

### 查找
~~~ javascript
// 方法1 查找符合条件的所有数据
NSString *age = @"30";
NSString *where = [NSString stringWithFormat:@"age > '%d'", age];
NSArray *array = [[SYCacheManager shareCache] readModel:[LKDBModel class] where:where];
~~~

~~~ javascript
// 方法2 查找符合条件的，按年龄升序的，第11个数据开始的10个数据，且只要姓名和年龄信息
NSString *age = @"30";
NSString *where = [NSString stringWithFormat:@"age > '%d'", age];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] column:@"name,age" where:where orderBy:@"age asc" offset:10 count:10];
~~~

~~~ javascript
// 方法3 条件查找回调
NSString *age = @"30";
NSString *where = [NSString stringWithFormat:@"age > '%d'", age];
[self.cacheManager readModel:[LKDBModel class] where:where callback:^(NSMutableArray *array) {

}];
~~~ 

### 删除
~~~ javascript
// 方法1 条件删除
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
[[SYCacheManager shareCache] deleteModel:[LKDBModel class] where:where];
~~~

~~~ javascript
// 方法2 条件删除
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[self.cacheManager deleteModel:model];
~~~

~~~ javascript
// 方法3 删除所有数据
[self.cacheManager deleteAllModel:[LKDBModel class]];
~~~

~~~ javascript
// 方法4 条件删除回调方法
NSString *company = @"VSTECS";
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
NSArray *array = [self.cacheManager readModel:[LKDBModel class] where:where];
LKDBModel *model = array.firstObject;
[self.cacheManager deleteModel:model callback:^(BOOL result) {

}];
~~~

~~~ javascript
// 销毁单例
[SYCacheManager releaseCache];

// 重置单例数据库类型别名
NSString *userType = [NSString stringWithFormat:@"%@", @(arc4random() % 1000 + 1)];
[SYCacheManager initializeWithType:userType];
~~~ 

# 修改说明
* 版本号：1.1.1
  * 修改时间：20180528
  * 添加功能类`SYFMDBManager`
  
* 版本号：1.1.0
  * 修改时间：20171231
  * 新增单例销毁方法
  * 新增单例重置数据库类型别名

* 版本号：1.0.2
  * 修改时间：20171222
  * 修改内容：
    * 添加回调处理方法
      * 插入数据方法回调
      * 更新数据方法回调
      * 删除数据方法回调
      * 读取数据方法回调
  * 添加读取方法
    * 多条件读取数据方法：查询条件、查询偏移量、查询条数、查询字段、查询排序字段


