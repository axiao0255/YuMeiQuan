//
//  RYBaiJiaPage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaiJiaPage.h"
#import "RYNewsPageTableViewCell.h"
#import "RYBaiJiaPageTableViewCell.h"

@interface RYBaiJiaPage ()

@property (nonatomic,strong) NSArray *arrayOfCharacters;

@end

@implementation RYBaiJiaPage

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (NSArray *)authorList
{
    if ( _authorList == nil ) {
        _authorList = [NSArray array];
    }
    return _authorList;
}

- (NSArray *)arrayOfCharacters
{
    if ( _arrayOfCharacters== nil ) {
        _arrayOfCharacters = [NSArray array];
    }
    return _arrayOfCharacters;
}

- (NSInteger)baiJiaNumberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.currentType == articleType ) {
        return 2;
    }else{
        return self.authorList.count;
    }
}
- (NSInteger)baiJiaTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.currentType == articleType ) {
        if ( section == 0 ) {
            NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
            if ( ![ShowBox isEmptyString:adverPic] ) {
                return 1;
            }else{
                return 0;
            }
        }else{
            return self.listData.count;
        }
     }else{
         if ( self.authorList.count ) {
             NSDictionary *dict = [self.authorList objectAtIndex:section];
             NSArray *keyArr = [dict allKeys];
             for (NSString *key in keyArr) {
                 NSArray *subArr = [dict objectForKey:key];
                 return subArr.count;
             }
             return 0;
         }
         else{
             return 0;
         }
    }
}
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.currentType == articleType ) {
        if ( indexPath.section == 0 ) {
            NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
            if ( ![ShowBox isEmptyString:adverPic] ) {
                return 180;
            }else{
                return 0;
            }
        }
        else{
            return 75;
        }
    }
    else{
        return 36;
    }
}
- (UITableViewCell *)baiJiaTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.currentType == articleType ) {
        if ( indexPath.section == 0 ) {
            NSString *baiJiaADVCell = @"baiJiaADVCell";
            RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baiJiaADVCell];
            if ( !cell ) {
                cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baiJiaADVCell];
            }
            [cell setValueWithDict:self.adverData];
            return cell;
        }else{
            NSString *baiJiaArticle = @"baiJiaArticle";
            RYBaiJiaPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baiJiaArticle];
            if ( !cell ) {
                cell = [[RYBaiJiaPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baiJiaArticle];
            }
            if ( self.listData.count ) {
                [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
            }
            return cell;
        }
    }
    else{
        NSString *authorCell = @"authorCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:authorCell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:authorCell];
        }
        cell.textLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        if ( self.authorList.count ) {
            
            NSDictionary *dict = [self.authorList objectAtIndex:indexPath.section];
            NSArray *keyArr = [dict allKeys];
            for (NSString *key in keyArr) {
                NSArray *subArr = [dict objectForKey:key];
                 cell.textLabel.text = [subArr objectAtIndex:indexPath.row];
            }
        }
        return cell;
    }
}
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( self.currentType == articleType ) {
        if (section==0) {
            return 8;
        }
        else{
            return 0;
        }
    }
    return 0;
}
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( self.currentType == articleType ) {
        return 0;
    }
    else{
        return 18;
    }
}

- (UIView *)baiJiaTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( self.currentType == articleType ) {
        return nil;
    }
    else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
        sectionView.backgroundColor = [Utils getRGBColor:242.0 g:242.0 b:242.0 a:1.0];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 18)];
        titleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.backgroundColor = [UIColor clearColor];
        [sectionView addSubview:titleLabel];
        
        NSDictionary *dict = [self.authorList objectAtIndex:section];
        NSArray *keyArr = [dict allKeys];
        for (NSString *key in keyArr) {
            titleLabel.text = key;
        }
        return sectionView;
    }
}

- (NSArray *)baiJiaSectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ( self.currentType == articleType ) {
        return nil;
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        for ( NSDictionary *dict in self.authorList ) {
            NSArray *keyArr = [dict allKeys];
            for (NSString *key in keyArr) {
                [arr addObject:key];
            }
        }
        self.arrayOfCharacters = arr;
        return self.arrayOfCharacters;
    }
}

// 右边选择拦 点击选择
- (NSInteger)baiJiaTableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in self.arrayOfCharacters)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return count;
}


@end
