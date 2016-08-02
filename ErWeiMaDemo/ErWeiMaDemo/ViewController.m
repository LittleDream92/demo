//
//  ViewController.m
//  ErWeiMaDemo
//
//  Created by Meng Fan on 16/8/2.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import "SweepViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanningBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UITextField *input;

//show 二维码的imageView
@property (nonatomic, strong) UIImageView *qrCodeImgV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutContain;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化二维码imgV
    self.qrCodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/4, 300, kScreenWidth/2, kScreenWidth/2)];
    [self.view addSubview:self.qrCodeImgV];
    
    NSLog(@"%f------------%f", self.qrCodeImgV.frame.origin.y, self.input.frame.origin.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//扫描二维码
- (IBAction)scanningQR:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查设备相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }else {
        SweepViewController *vc = [[SweepViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//生成二维码
- (IBAction)createQR:(id)sender {
    [self.view endEditing:YES];
    self.layoutContain.constant = 50.f;
    [self createQRCodeAction];
}

//创建二维码的过程
- (void)createQRCodeAction {
    
    if (self.input.text.length != 0) {
        NSLog(@"生成\"%@\"的验证码",self.input.text);
        
        //原生态生成二维码需要导入CoreImage.framework
        //二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        //恢复滤镜的默认属性
        [filter setDefaults];
        
        //*****************************************************************//
        //如果是从外界传递来的字符串这里将外界传递来的字符串转换为data即可.
        //*****************************************************************//
        NSData *data = [self.input.text dataUsingEncoding:NSUTF8StringEncoding];
        //通过KVO设置滤镜input数据
        [filter setValue:data forKey:@"inputMessage"];
        //获得滤镜输出的图片
        CIImage *outPutImg = [filter outputImage];
        //将CIImage转化为image并显示
        self.qrCodeImgV.image = [self createNonInterpolatedUIImageFromCIImage:outPutImg withSize:100.0];
        self.qrCodeImgV.layer.shadowOffset = CGSizeMake(5, 5);
        self.qrCodeImgV.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.qrCodeImgV.layer.shadowOpacity = 2;    //阴影透明度
        
    }else {
        NSLog(@"内容为空，不能生成二维码");
    }
    
}

//将数据转化为二维码图片
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存bitmap位图到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.layoutContain.constant = 50.f;
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.layoutContain.constant = 50.f;
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.layoutContain.constant = -50.f;
    return YES;
}


@end
