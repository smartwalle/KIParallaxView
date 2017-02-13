//
//  KIParallaxView.m
//  Kitalker
//
//  Created by Kitalker on 13-12-11.
//
//

#import "KIParallaxView.h"

@interface KIParallaxView() {
}
@property (nonatomic, assign) BOOL  tracking;
@property (nonatomic, assign) BOOL  cancel;
@property (nonatomic, assign) BOOL  dragging;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL needUpdateContentView;
@end

@implementation KIParallaxView

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setTracking:NO];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _needUpdateContentView = YES;
    [self addSubview:_contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_needUpdateContentView) {
        UIScrollView *sv = (UIScrollView *)[self superview];
        CGRect newFrame = CGRectMake(0, 0, CGRectGetWidth(sv.bounds), self.defaultHeight);
        [self setFrame:newFrame];
        [self.contentView setFrame:self.bounds];
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [sv setContentOffset:CGPointMake(0, -1 * self.defaultHeight)];
    }
    _needUpdateContentView = NO;
}

- (void)removeFromSuperview {
    if (self.superview) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [super removeFromSuperview];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [super willMoveToSuperview:newSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollView:object didUpdateContentOffset:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
}

- (void)scrollView:(UIScrollView *)scrollView didUpdateContentOffset:(CGPoint)contentOffset {
    CGFloat offsetY = contentOffset.y * -1 ;
    CGFloat percent = (offsetY-self.defaultHeight)/(self.defaultHeight-self.minHeight);
    percent = MAX(-1, percent);
    if (scrollView.isDragging) {
        if (!self.dragging) {
            [self setDragging:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(parallaxViewDidBeginDragging:)]) {
                [self.delegate parallaxViewDidBeginDragging:self];
            }
        }
        //如果超过50%，则标记为跟踪状态
        if (percent > 0.5) {
            [self setTracking:YES];
            [self setCancel:NO];
        } else {
            [self setTracking:NO];
            [self setCancel:YES];
        }
    } else {
        [self setDragging:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(parallaxView:percentOfDrag:)]) {
        [self.delegate parallaxView:self percentOfDrag:percent];
    }
    
    //刷新view
    
    /*
     * 2014.03.09 修改
     * 功能：如果设置了 minHeight
     */
    CGFloat height = MAX(offsetY, self.minHeight>0?self.minHeight:self.defaultHeight);
    CGFloat y = contentOffset.y;
    if (contentOffset.y > (height * -1)) {
        y = contentOffset.y-(height+contentOffset.y);
    }

    /*
     * 2017.02.13 修改
     * 功能：如果设置了 maxHeight, 则 ParallaxView 不会随着 UIScrollView 下拉而变高
     */
    if (self.maxHeight > 0) {
        height = MIN(height, self.maxHeight);
    }

    /*
     * 2014.03.09 修改
     * 功能：设置一个 minHeight，让 ParallaxView 在顶部保持不动
     */
    if ([self.superview isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.superview;
        if (tableView.tableHeaderView == nil) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
            [headerView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableHeaderView:headerView];
        }
        [tableView insertSubview:self aboveSubview:tableView.tableHeaderView];
    } else {
        [self.superview bringSubviewToFront:self];
    }
    y = MAX(y, contentOffset.y-height+MAX(0, self.minHeight));
    
    [self setFrame:CGRectMake(0,
                              y,
                              CGRectGetWidth(self.bounds),
                              height)];
    
    /*2014.03.07 注释，用上面的方法替换*/
//    [self setFrame:CGRectMake(0,
//                              contentOffset.y,
//                              CGRectGetWidth(self.bounds),
//                              offsetY)];
    
    if (scrollView.decelerating) {
        if (self.tracking) {
            [self setTracking:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(parallaxViewDidReleaseDragging:)]) {
                [self.delegate parallaxViewDidReleaseDragging:self];
            }
        } else if (self.cancel) {
            [self setCancel:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(parallaxViewDidCancelDragging:)]) {
                [self.delegate parallaxViewDidCancelDragging:self];
            }
        }
    }
}

@end

#define kParallaxViewTag    917996694

@implementation UIScrollView (KIParallaxView)

- (KIParallaxView *)parallaxView {
    KIParallaxView *view = (KIParallaxView *)[self viewWithTag:kParallaxViewTag];
    if (view == nil) {
        view = [[KIParallaxView alloc] init];
        [view setTag:kParallaxViewTag];
        [self addSubview:view];
    }
    return view;
}

- (void)setParallaxViewImage:(UIImage *)image
                    delegate:(id<KIParallaxViewDelegate>)delegate
                      height:(CGFloat)height {
    [self setParallaxViewImage:image
                      delegate:delegate
                        height:height
                     minHeight:0];
}

- (void)setParallaxViewImage:(UIImage *)image
                    delegate:(id<KIParallaxViewDelegate>)delegate
                      height:(CGFloat)height
                   minHeight:(CGFloat)minHeight {
    [self setParallaxViewImage:image
                      delegate:delegate
                        height:height
                     minHeight:minHeight
                     maxHeight:0];
}

- (void)setParallaxViewImage:(UIImage *)image
                    delegate:(id<KIParallaxViewDelegate>)delegate
                      height:(CGFloat)height
                   minHeight:(CGFloat)minHeight
                   maxHeight:(CGFloat)maxHeight{
    UIImageView *imageView = (UIImageView *)[[self parallaxView] contentView];
    if (imageView == nil || ![imageView isKindOfClass:[UIImageView class]]) {
        imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [imageView setImage:image];
    
    [self setParallaxView:imageView
                 delegate:delegate
                   height:height
                minHeight:minHeight
                maxHeight:maxHeight];
}

- (void)setParallaxView:(UIView *)view
               delegate:(id<KIParallaxViewDelegate>)delegate
                 height:(CGFloat)height {
    [self setParallaxView:view delegate:delegate height:height minHeight:0];
}

- (void)setParallaxView:(UIView *)view
               delegate:(id<KIParallaxViewDelegate>)delegate
                 height:(CGFloat)height
              minHeight:(CGFloat)minHeight {
    [self setParallaxView:view
                 delegate:delegate
                   height:height
                minHeight:minHeight
                maxHeight:0];
}

- (void)setParallaxView:(UIView *)view
               delegate:(id<KIParallaxViewDelegate>)delegate
                 height:(CGFloat)height
              minHeight:(CGFloat)minHeight
              maxHeight:(CGFloat)maxHeight {
    [self removeParallaxView];
    
    [[self parallaxView] setDelegate:delegate];
    [[self parallaxView] setDefaultHeight:height];
    [[self parallaxView] setMinHeight:minHeight];
    [[self parallaxView] setMaxHeight:maxHeight];
    [[self parallaxView] setContentView:view];
    
    UIEdgeInsets newInset = self.contentInset;
    newInset.top = height;
    [self setContentInset:newInset];
}

- (void)removeParallaxView {
    KIParallaxView *view = (KIParallaxView *)[self viewWithTag:kParallaxViewTag];
    if (view) {
        [view removeFromSuperview];
    }
}

@end
