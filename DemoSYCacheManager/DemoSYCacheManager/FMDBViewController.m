//
//  FMDBViewController.m
//  DemoSYCacheManager
//
//  Created by zhangshaoyu on 2017/7/22.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "FMDBViewController.h"
#import "SYCacheManager.h"

@interface FMDBViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) SYCacheManager *cacheManager;

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"FMDB缓存管理";
    
    self.array = @[@"存数据", @"取数据", @"删除数据", @"修改数据", @"创建表", @"删除表"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row)
    {
        // 存数据
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *saveData = @"INSERT INTO CompanyTable (departmentId, departmentName, departmentStatus) VALUES (?,?,?)";
            BOOL isResult = [self.cacheManager.fmdbManager executeUpdate:saveData, @"168", @"互联网部门", @"禁用"];
            NSLog(@"saveData = %@", (isResult ? @"success" : @"error"));
            [self.cacheManager.fmdbManager close];
        }
    }
    else if (1 == indexPath.row)
    {
        // 取数据
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *readData = @"SELECT * FROM CompanyTable WHERE departmentName = ?";
            FMResultSet *result = [self.cacheManager.fmdbManager executeQuery:readData, @"互联网部门"];
            while ([result next])
            {
                NSString *idStr = [result stringForColumn:@"departmentId"];
                NSString *nameStr = [result stringForColumn:@"departmentName"];
                NSString *statusStr = [result stringForColumn:@"departmentStatus"];
                
                NSLog(@"查找数据成功。\nid = %@, name = %@, status = %@", idStr, nameStr, statusStr);
            }
            [self.cacheManager.fmdbManager close];
        }
    }
    else if (2 == indexPath.row)
    {
        // 删除数据
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *deleteData = @"DELETE FROM CompanyTable";
            BOOL isResult = [self.cacheManager.fmdbManager executeUpdate:deleteData];
            NSLog(@"deleteData = %@", (isResult ? @"success" : @"error"));
            [self.cacheManager.fmdbManager close];
        }
    }
    else if (3 == indexPath.row)
    {
        // 修改数据
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *modifyData = @"UPDATE CompanyTable set departmentStatus = ? where departmentName = ?";
            BOOL isResult = [self.cacheManager.fmdbManager executeUpdate:modifyData, @"启用", @"互联网部门"];
            NSLog(@"modifyData = %@", (isResult ? @"success" : @"error"));
            [self.cacheManager.fmdbManager close];
        }
    }
    else if (4 == indexPath.row)
    {
        // 创建表
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *createTabel = @"CREATE TABLE if not exists CompanyTable (departmentId text PRIMARY KEY,departmentName text,departmentStatus text)";
            BOOL isResult = [self.cacheManager.fmdbManager executeUpdate:createTabel];
            NSLog(@"createTabel = %@", (isResult ? @"success" : @"error"));
            [self.cacheManager.fmdbManager close];
        }
    }
    else if (5 == indexPath.row)
    {
        // 删除表
        if ([self.cacheManager.fmdbManager open])
        {
            NSString *deleteTabel = @"DROP TABLE CompanyTable";
            BOOL isResult = [self.cacheManager.fmdbManager executeUpdate:deleteTabel];
            NSLog(@"deleteTabel = %@", (isResult ? @"success" : @"error"));
            [self.cacheManager.fmdbManager close];
        }
    }
}

- (SYCacheManager *)cacheManager
{
    if (_cacheManager == nil)
    {
        _cacheManager = [[SYCacheManager alloc] init];
    }
    return _cacheManager;
}

@end
