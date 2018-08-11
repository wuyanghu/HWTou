//
//  UINavigationItem+Margin.m
//  HWTou
//
//  Created by PP on 16/7/27.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "UINavigationItem+Margin.h"

@implementation UINavigationItem (Margin)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space
{
    NSArray *items = [self barButtonItems:barItem fixedSpace:space];
    [self setLeftBarButtonItems:items];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
    [items addObjectsFromArray:[self barButtonItems:barItem fixedSpace:space]];
    [self setLeftBarButtonItems:items];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space
{
    NSArray *items = [self barButtonItems:barItem fixedSpace:-space];
    [self setRightBarButtonItems:items];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.rightBarButtonItems];
    [items addObjectsFromArray:[self barButtonItems:barItem fixedSpace:-space]];
    [self setRightBarButtonItems:items];
}

- (NSArray *)barButtonItems:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space
{
    NSMutableArray *items = [NSMutableArray array];
    if (barItem) {
        if (space != 0) {
            UIBarButtonItem *itemSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            itemSeperator.width = space;
            [items addObject:itemSeperator];
        }
        
        [items addObject:barItem];
    }
    return items;
}

@end
