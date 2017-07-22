# SYCacheManager
缓存数据管理
使用FMDB、LKDBHelper进行二次封装使用。

# 效果图

![FMDB](./FMDB.gif)

![LKDBHelper](./LKDBHelper.gif)

# 使用示例
~~~ javascript
#import "SYCacheManager.h"
~~~

~~~ javascript
// 创建表
[[SYCacheManager shareCache] newTableWithModel:[LKDBModel class]];
~~~

~~~ javascript
// 删除表
[[SYCacheManager shareCache] deleteTableWithModel:[LKDBModel class]];
~~~ 

~~~ javascript
// 保存
LKDBModel *model = [LKDBModel new];
model.name = @"devZhang";
model.age = @"30";
model.company = @"VSTECS";

[[SYCacheManager shareCache] saveModel:model];
~~~

~~~ javascript
// 删除
NSString *company = ((UITextField *)[self.editView viewWithTag:1002]).text;
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
[[SYCacheManager shareCache] deleteModel:[LKDBModel class] where:where];
~~~ 

~~~ javascript
// 修改
[[SYCacheManager shareCache] updateModel:self.model];
~~~ 

~~~ javascript
// 查找
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
where = ((company && 0 < company.length) ? where : nil);
NSArray *array = [[SYCacheManager shareCache] readModel:[LKDBModel class] where:where];
for (LKDBModel *model in array)
{

}
~~~ 

~~~ javascript
// 删除
NSString *company = ((UITextField *)[self.editView viewWithTag:1002]).text;
NSString *where = [NSString stringWithFormat:@"company = '%@'", company];
[[SYCacheManager shareCache] deleteModel:[LKDBModel class] where:where];
~~~ 


