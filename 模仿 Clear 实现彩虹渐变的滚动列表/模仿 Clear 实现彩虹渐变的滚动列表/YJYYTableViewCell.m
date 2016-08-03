//
//  YJYYTableViewCell.m
//  模仿 Clear 实现彩虹渐变的滚动列表
//
//  Created by 远洋 on 16/7/21.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import "YJYYTableViewCell.h"

static NSString * ID = @"YJYYTableViewCell";
@implementation YJYYTableViewCell

+(instancetype)makeTableViewCell {
    YJYYTableViewCell * cell = [[YJYYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    //取消选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    //以下两步是为了添加一个阴影
//    cell.textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
//    cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    
    //实现高光阴影的效果
    CAShapeLayer * topHighlightlayer = [CAShapeLayer layer];
    topHighlightlayer.path = CGPathCreateWithRect(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1), nil);
    topHighlightlayer.fillColor = [UIColor whiteColor].CGColor;
    topHighlightlayer.opacity = 0.1;
    [cell.layer addSublayer:topHighlightlayer];
    
    CAShapeLayer * bottomHighlightlayer = [CAShapeLayer layer];
    bottomHighlightlayer.path = CGPathCreateWithRect(CGRectMake(0, 59, [UIScreen mainScreen].bounds.size.width, 1), nil);
    bottomHighlightlayer.fillColor = [UIColor blackColor].CGColor;
    bottomHighlightlayer.opacity = 0.2;
    [cell.layer addSublayer:bottomHighlightlayer];
    
    return cell;
}
@end
