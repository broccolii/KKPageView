//
//  KKPageViewItem.m
//  KKPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "KKPageViewItem.h"

@implementation KKPageViewItem

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    [self setupUIComponent];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    [self setupUIComponent];
    return self;
}

- (void)commonInit {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowRadius = 5;
    self.contentView.layer.shadowOpacity = 0.75;
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - setup UI component
- (void)setupUIComponent {
    
}

@end
