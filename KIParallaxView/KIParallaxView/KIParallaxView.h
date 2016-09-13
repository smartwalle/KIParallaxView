//
//  KIParallaxView.h
//  Kitalker
//
//  Created by Kitalker on 13-12-11.
//
//

#import <UIKit/UIKit.h>

@class KIParallaxView;
@protocol KIParallaxViewDelegate <NSObject>
@optional
- (void)parallaxViewDidBeginDragging:(KIParallaxView *)parallaxView;
- (void)parallaxViewDidReleaseDragging:(KIParallaxView *)parallaxView;
- (void)parallaxViewDidCancelDragging:(KIParallaxView *)parallaxView;
- (void)parallaxView:(KIParallaxView *)parallaxView percentOfDrag:(CGFloat)percent;
@end

@interface KIParallaxView : UIView {
}

@property (nonatomic, weak)     id<KIParallaxViewDelegate>  delegate;
@property (nonatomic, assign)   CGFloat                     defaultHeight;
@property (nonatomic, assign)   CGFloat                     minHeight;

@end


@interface UIScrollView (KIParallaxView)

- (void)setParallaxViewImage:(UIImage *)image
                    delegate:(id<KIParallaxViewDelegate>)delegate
                      height:(CGFloat)height;

- (void)setParallaxViewImage:(UIImage *)image
                    delegate:(id<KIParallaxViewDelegate>)delegate
                      height:(CGFloat)height
                   minHeight:(CGFloat)minHeight;

- (void)setParallaxView:(UIView *)view
               delegate:(id<KIParallaxViewDelegate>)delegate
                 height:(CGFloat)height;

- (void)setParallaxView:(UIView *)view
               delegate:(id<KIParallaxViewDelegate>)delegate
                 height:(CGFloat)height
              minHeight:(CGFloat)minHeight;

- (void)removeParallaxView;

@end
