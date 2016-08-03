//
//  ViewController.m
//  模仿 Clear 实现彩虹渐变的滚动列表
//
//  Created by 远洋 on 16/7/21.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import "ViewController.h"
#import "YJYYTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//存放需要渐变的起点和终点颜色的数组
@property (nonatomic,strong)NSArray * colors;

//全局的tableView
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation ViewController
//懒加载颜色数组
- (NSArray *)colors
{
    if (!_colors) {
        //初始化彩红颜色
        _colors = @[[UIColor colorWithRed:0.85 green:0 blue:0.09 alpha:1],[UIColor colorWithRed:0.9 green:0.56 blue:0.11 alpha:1]];
    }
    return _colors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //初始化tableView
    [self initTableView];
    
    //添加状态栏底部模糊特效视图
    [self addVisualEffectView];
}

/**
 *  添加一个放置在状态栏底部的模糊特效视图
 */
- (void)addVisualEffectView{
    UIVisualEffectView * veView = [[UIVisualEffectView alloc]initWithEffect:    [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    veView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [self.view addSubview:veView];
}

/**
 *  初始化tableView
 */
- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    //取消背景颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏列表中多于的分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //避开状态栏
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    //设置数据源和代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

/**
 *  传入位置因数获取过渡颜色
 *
 *  @param progress 位置因数
 *  @param colors   颜色数组
 *
 *  @return 过渡颜色
 */
- (UIColor *)caculateColorWithProgress:(CGFloat)progress usingColors:(NSArray<UIColor *> *)colors {
    //获取起始颜色
    UIColor * firstColor = [colors firstObject];
    
    //获取最后颜色
    UIColor * lastColor = [colors lastObject];
    
    //利用coreGraphics函数来计算RGB对应的过渡颜色 用到的公式：color(progress) = color1 + (color1 - color2)*progress; 这个progress的取值为[0 - 1];
    //获取Red
    CGFloat red = CGColorGetComponents(firstColor.CGColor)[0] + (CGColorGetComponents(lastColor.CGColor)[0] - CGColorGetComponents(firstColor.CGColor)[0])*progress;
    //获取Green
    CGFloat green = CGColorGetComponents(firstColor.CGColor)[1] + (CGColorGetComponents(lastColor.CGColor)[1] - CGColorGetComponents(firstColor.CGColor)[1])*progress;
    //获取Blue
    CGFloat blue = CGColorGetComponents(firstColor.CGColor)[2] + (CGColorGetComponents(lastColor.CGColor)[2] - CGColorGetComponents(firstColor.CGColor)[2])*progress;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

/**
 *  传入一个view转换坐标到self.view 计算progress
 *
 *  @param view 传入的view 这里指的就是每一行的cell
 *
 *  @return 返回progress
 */
- (CGFloat)caculateProgressWithView:(UIView *)view {
    //转换坐标系
    CGRect covertRect = [view convertRect:view.bounds toView:self.view];
    //取出y轴坐标 计算progress
    CGFloat covertY = covertRect.origin.y;
    //返回progress
    return covertY / (self.view.bounds.size.height - 60);
}

#pragma mark - /********数据源方法*******/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYYTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYYTableViewCell"];
    if (!cell) {
        cell = [YJYYTableViewCell makeTableViewCell];
    }
    
    cell.textLabel.text = cell.textLabel.text = [NSString stringWithFormat:@"我是第:%ld个cell",indexPath.row];
    
    return cell;
}

#pragma mark - /********代理方法*******/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat progress = [self caculateProgressWithView:cell];
    cell.backgroundColor = [self caculateColorWithProgress:progress usingColors:self.colors];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //判断是否是tableView
    if ([scrollView isEqual:self.tableView]) {
        [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //计算progress
            CGFloat progress = [self caculateProgressWithView:obj];
            
            //计算过渡颜色
            UIColor * color = [self caculateColorWithProgress:progress usingColors:self.colors];
            //设置cell的背景颜色
            obj.backgroundColor = color;
        }];
    }
}
@end
