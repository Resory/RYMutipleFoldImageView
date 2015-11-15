//
//  ViewController.m
//  RYMutipleFoldImage
//
//  Created by billionsfinance-resory on 15/11/15.
//  Copyright © 2015年 Resory. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_PER_HEIGIT 50.0

@interface ViewController ()

@property (nonatomic, strong) UIImageView *one;
@property (nonatomic, strong) UIImageView *two;
@property (nonatomic, strong) UIImageView *three;
@property (nonatomic, strong) UIImageView *four;

@property (nonatomic, strong) UIView *oneShadowView;
@property (nonatomic, strong) UIView *threeShadowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configFourFoldImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Configuration

- (void)configFourFoldImage
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 300, IMAGE_PER_HEIGIT*4)];
    [self.view addSubview:bgView];
    
    // 把kiluya这张图，分成平均分成4个部分的imageview
    _one = [[UIImageView alloc] init];
    _one.image = [UIImage imageNamed:@"Kiluya.jpg"];
    _one.layer.contentsRect = CGRectMake(0, 0, 1, 0.25);
    _one.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _one.frame = CGRectMake(0, 0, 300, IMAGE_PER_HEIGIT);
    
    _two = [[UIImageView alloc] init];
    _two.image = [UIImage imageNamed:@"Kiluya.jpg"];
    _two.layer.contentsRect = CGRectMake(0, 0.25, 1, 0.25);
    _two.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _two.frame = CGRectMake(0, IMAGE_PER_HEIGIT, 300, IMAGE_PER_HEIGIT);
    
    _three = [[UIImageView alloc] init];
    _three.image = [UIImage imageNamed:@"Kiluya.jpg"];
    _three.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.25);
    _three.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _three.frame = CGRectMake(0, IMAGE_PER_HEIGIT*2, 300, IMAGE_PER_HEIGIT);
    
    _four = [[UIImageView alloc] init];
    _four.image = [UIImage imageNamed:@"Kiluya.jpg"];
    _four.layer.contentsRect = CGRectMake(0, 0.75, 1, 0.25);
    _four.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _four.frame = CGRectMake(0, IMAGE_PER_HEIGIT*3, 300, IMAGE_PER_HEIGIT);
    
    [bgView addSubview:_one];
    [bgView addSubview:_two];
    [bgView addSubview:_three];
    [bgView addSubview:_four];
    
    // 给第一张和第三张添加阴影
    _oneShadowView = [[UIView alloc] initWithFrame:_one.bounds];
    _oneShadowView.backgroundColor = [UIColor blackColor];
    _oneShadowView.alpha = 0.0;
    
    _threeShadowView = [[UIView alloc] initWithFrame:_three.bounds];
    _threeShadowView.backgroundColor = [UIColor blackColor];
    _threeShadowView.alpha = 0.0;
    
    [_one addSubview:_oneShadowView];
    [_three addSubview:_threeShadowView];
}

#pragma mark -
#pragma mark - Action

// 动效是否执行中
static bool isFolding = NO;

- (IBAction)fold:(id)sender
{
    if(!isFolding)
    {
        isFolding = YES;
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
            // 阴影显示
            _oneShadowView.alpha = 0.2;
            _threeShadowView.alpha = 0.2;
                             
            // 折叠
            _one.layer.transform = [self config3DTransformWithRotateAngle:-45.0
                                                             andPositionY:0];
            _two.layer.transform = [self config3DTransformWithRotateAngle:45.0
                                                             andPositionY:-100+2*_one.frame.size.height];
            _three.layer.transform = [self config3DTransformWithRotateAngle:-45.0
                                                               andPositionY:-100+2*_one.frame.size.height];
            _four.layer.transform = [self config3DTransformWithRotateAngle:45.0
                                                              andPositionY:-200+4*_one.frame.size.height];
                             
        } completion:^(BOOL finished) {
            
            if(finished)
            {
                isFolding = NO;
            }
        }];
    }
}

- (IBAction)resetLayerTransform
{
    isFolding = NO;
    
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        
        // 阴影隐藏
        _oneShadowView.alpha = 0.0;
        _threeShadowView.alpha = 0.0;
        
        // 图片恢复原样
        _one.layer.transform = CATransform3DIdentity;
        _two.layer.transform = CATransform3DIdentity;
        _three.layer.transform = CATransform3DIdentity;
        _four.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (CATransform3D)config3DTransformWithRotateAngle:(double)angle andPositionY:(double)y
{
    CATransform3D transform = CATransform3DIdentity;
    // 立体
    transform.m34 = -1/1000.0;
    // 旋转
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 1, 0, 0);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    CATransform3D moveTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0, y));
    // 合并
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, moveTransform);
    return concatTransform;
}

@end
