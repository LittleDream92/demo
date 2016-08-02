//
//  SweepViewController.m
//  ErWeiMaDemo
//
//  Created by Meng Fan on 16/8/2.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "SweepViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ErWeiMaViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIImageView *imgView;     //scan View
@property (nonatomic, assign) BOOL shouldUp;            //up or down
@property (nonatomic, assign) CGFloat minY;             //向上滑动的最小边界
@property (nonatomic, assign) CGFloat maxY;             //向下滑动的最大边界

//摄像设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出流
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
//连接对象
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIView *scanRectView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preView;

@end

@implementation SweepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [self sweepView];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.session stopRunning];
}

- (void)sweepView {
    
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，在主线程里面刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化连接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:(kScreenHeight < 500 ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetHigh)];
    //连接对象添加输入流和输出流
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //AVMetadataMachineReadableCodeObject对象从QR码生成返回这个常数作为他们的类型
    //设置扫码支持的编码格式(设置条码和二维码兼容扫描)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //自定义取景框
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    NSLog(@"%f--%f--%f--%f", scanRect.origin.x, scanRect.origin.y, scanRect.size.width, scanRect.size.height);
    
    
    //横线开始上下滑动
    [self scanningAnimationWith:scanRect];
    
    //创建周围模糊区域
    [self getCGRect:scanRect];
    self.minY = CGRectGetMinY(scanRect);
    self.maxY = CGRectGetMaxY(scanRect);
    
    
    
    //计算rectOfInterest 注意x,y交换位置
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height, scanRect.size.width/windowSize.width);
    self.output.rectOfInterest = scanRect;
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    self.scanRectView.layer.borderWidth = 1;
    
    self.output.rectOfInterest = scanRect;
    
    self.preView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preView atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

//扫描时从上往下跑动的线以及提示语
- (void)scanningAnimationWith:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, 3)];
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"scanLine" ofType:@"png"];
    self.imgView.image = [UIImage imageWithContentsOfFile:imgPath];
    
    self.shouldUp = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
    [self.view addSubview:self.imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y+height, width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"请将扫描区域对准二维码";
    [self.view addSubview:label];
}

- (void)repeatAction {
    CGFloat num = 1;
    if (self.shouldUp) {    //up
        self.imgView.frame = CGRectMake(CGRectGetMinX(self.imgView.frame), CGRectGetMinY(self.imgView.frame)-num, CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
        if (CGRectGetMinY(self.imgView.frame) <= self.minY) {
            self.shouldUp = NO;
        }
        
    }else {     //down
        self.imgView.frame = CGRectMake(CGRectGetMinX(self.imgView.frame), CGRectGetMinY(self.imgView.frame)+num, CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
        
        if (CGRectGetMaxY(self.imgView.frame) >= self.maxY) {
            self.shouldUp = YES;
        }
    }
}


//获取扫描区域坐标
- (void)getCGRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    
    [self createFuzzyViewWith:CGRectMake(0, 0, width, y)];
    [self createFuzzyViewWith:CGRectMake(0, y+h, width, height-h-y)];
    [self createFuzzyViewWith:CGRectMake(0, y, x, h)];
    [self createFuzzyViewWith:CGRectMake(x+w, y, width-x-w, h)];
}

//创建扫描区域之外的模糊效果
- (void)createFuzzyViewWith:(CGRect)rect {
    UIView *view1 = [[UIView alloc] initWithFrame:rect];
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.4;
    [self.view addSubview:view1];
}





//扫描以后的方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    //系统在铃声模式下扫描到结果调用“咔嚓”声音；需要导入<AudioToolbox/AudioToolbox.h>
    AudioServicesPlayAlertSound(1305);
    //系统在震动模式下扫描到结果震动一下;
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    //为0表示没有捕捉到信息，返回重新捕捉
    if ([metadataObjects count] == 0) {
        return;
    }
  
    //不为0则表示捕捉并成功存储了二维码
    if ([metadataObjects count] > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *currentMetadataObject = [metadataObjects firstObject];
        NSLog(@"cu:%@", currentMetadataObject.stringValue);
        
        //输出扫描字符串
        ErWeiMaViewController *erweimaVC = [[ErWeiMaViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:erweimaVC];
        
        erweimaVC.myUrl = currentMetadataObject.stringValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:nav animated:YES completion:^{
            }];
        });
    }
    
    //扫描出来的网址跳转到下一页再做判断处理，不然如果直接在本页面加载网址则会出现以下问题：二维码扫描跳转后,webView界面的界面下方无法全屏,并且返回时无法重新调用相机,卡死..
    
}



@end
