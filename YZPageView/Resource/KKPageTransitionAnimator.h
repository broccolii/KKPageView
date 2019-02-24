//
//  KKPageTransitionAnimator.h
//  KKPageView
//
//  Created by Broccoli on 2017/2/19.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPageContainerViewLayout.h"

@protocol KKPageTransitionAnimator <NSObject>

@optional
- (void)transitionAnimationWithLayoutAttributes:(KKPageContainerViewLayoutAttributes *)layoutAttributes
                                    forPosition:(CGFloat)position;

@end
