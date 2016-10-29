//
//  ViewController.m
//  BannerDemo
//
//  Created by gyw on 2016/10/29.
//
//

#import "ViewController.h"

#define imgCount 5



@interface ViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic, strong) NSTimer *timer;

@end


@implementation ViewController


- (UIScrollView *) scrollView {
    
    if(_scrollView == nil) {
    
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 20, 300, 140)];
        
//        _scrollView.backgroundColor = [UIColor redColor];
        
        //取消阻尼效果
        _scrollView.bounces = NO;
        
        //取消滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        // 分页效果
        _scrollView.pagingEnabled = YES;

        _scrollView.contentSize = CGSizeMake(imgCount*_scrollView.bounds.size.width, 0) ;
        
        
        [self.view addSubview:_scrollView];
        
        // 设置代理
        _scrollView.delegate = self;
        
    }
    
    return _scrollView;
    
}


- (UIPageControl *)pageControl {

    if(_pageControl == nil) {
    
        _pageControl = [[UIPageControl alloc] init];
        
        //设置总页数
        _pageControl.numberOfPages = imgCount;
        //控制尺寸
        CGSize size = [_pageControl sizeForNumberOfPages:imgCount];
        
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.center.x, self.scrollView.bounds.size.height);
        
        //设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        [self.view addSubview:_pageControl];
        
        [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置图片
    for(int i = 0; i < imgCount; i++) {
    
        NSString *imgName = [NSString stringWithFormat:@"img_%02d", i+1];
        
        UIImage *img = [UIImage imageNamed:imgName];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.scrollView.bounds];
        
        imgView.image = img;
        
        [self.scrollView addSubview:imgView];
        
    }
    
    
    //计算图片的位置
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull imgView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = imgView.frame;
        frame.origin.x = idx * frame.size.width;
        
        imgView.frame = frame;
        
//        NSLog(@"gyw index : %ld", idx);
    }];
    
    self.pageControl.currentPage = 0;
    
    
    [self startTimer];
    
}


#pragma mark - 使用timer, 让图片自动轮播
- (void) startTimer {

//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void) updateTimer {
    
    int index = (int)(self.pageControl.currentPage + 1) % imgCount;
    self.pageControl.currentPage = index;
 
    NSLog(@"gyw currentPage:  %ld", self.pageControl.currentPage);
    
    [self pageChange:self.pageControl];
    
}
     
#pragma mark - scrollview代理方法, 控制滑动开始和结束的timer机制
// 抓住图片停止时钟
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.timer invalidate];
}

// 松开图片开始时钟
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];

}


#pragma mark - 使用代理方法, 将scrollview和pagecontorl关联起来

// UIScrollView 的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    NSLog(@"gyw END %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    int index = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    self.pageControl.currentPage = index;
    
}

- (void)pageChange:(UIPageControl *) pageControl {

    CGFloat x = pageControl.currentPage * self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
