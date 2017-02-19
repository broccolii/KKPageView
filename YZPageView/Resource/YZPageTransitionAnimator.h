//
//  YZPageTransitionAnimator.h
//  YZPageView
//
//  Created by Broccoli on 2017/2/19.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZPageContainerViewLayout.h"

@protocol YZPageTransitionAnimator <NSObject>

- (void)transitionAnimationWithLayoutAttributes:(YZPageContainerViewLayoutAttributes *)layoutAttributes
                                    forPosition:(CGFloat)position;

@end
