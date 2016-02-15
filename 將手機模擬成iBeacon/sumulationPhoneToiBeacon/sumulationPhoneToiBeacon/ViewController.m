//
//  ViewController.m
//  sumulationPhoneToiBeacon
//
//  Created by Mac on 2015/10/10.
//  Copyright © 2015年 Rothschild. All rights reserved.
//

#import "ViewController.h"
//#define UUIDEstimoteBeacon @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define UUIDSUMULATIONIOSToiBEACON @"15F85CEC-60E0-430C-A17F-CB3D7D3AF295"
/* 在終端機上使用UUIDGEN,便能產生一組UUID */
#define UUID_PATTERN    @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
#define BluetoothStatusMessage @"藍芽尚未開啟~ 請開啟藍芽 謝謝~\nPlease Open Bluetooth, Thank you."
#define ColorLightPuprle [UIColor colorWithRed:216.0/255 green:4.0/255 blue:254.0/255 alpha:1.0]
#define ColorLightBlue [UIColor colorWithRed:65.0/255 green:196.0/255 blue:235.0/255 alpha:1.0]

@interface ViewController ()
@property (nonatomic, assign) BOOL animationEnable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.view1LabelMessage.text = [NSString stringWithFormat:BluetoothStatusMessage];   // 設定藍芽狀態提醒訊息.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBackground) name:UIApplicationWillResignActiveNotification object:nil];    // app將進入背景.self
    
    self.view1TextFiledDeviceName.delegate = self;
    self.view1TextFiledUUID.delegate = self;
    self.view1TextFiledMajor.delegate = self;
    self.view1TextFiledMinor.delegate = self;
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    //self.view1ButtonStart.layer.borderWidth=2.0f;// 設定按鈕編框粗細.
    //self.view1ButtonStart.layer.borderColor = [UIColor whiteColor].CGColor; // 設定邊框顏色.
    self.view1ButtonStart.layer.masksToBounds=YES;// 超過邊框的部分做遮罩.
    self.view1ButtonStart.layer.cornerRadius=self.view1ButtonStart.frame.size.width/2.0;// 設定按鈕角度 用邊長的一半.
    
    //self.view1LabelShow.layer.borderWidth=2.0f;// 設定按鈕編框粗細.
    //self.view1LabelShow.layer.borderColor = [UIColor whiteColor].CGColor; // 設定邊框顏色.
    self.view1LabelShow.layer.masksToBounds=YES;// 超過邊框的部分做遮罩.
    self.view1LabelShow.layer.cornerRadius=self.view1LabelShow.frame.size.width/2.0;// 設定按鈕角度 用邊長的一半.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(BOOL)isValidUUID:(NSString *)uuidstring {   // 判斷UUID是否有效.self
    /*
    // 這個方法最快.
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:uuidstring];
    if (uuid) {
        return YES;
    }
    return  NO;
    */
    // lenght = 36
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:UUID_PATTERN options:NSRegularExpressionCaseInsensitive error:nil];
    //int matches = [regex numberOfMatchesInString:uuidstring options:0 range:NSMakeRange(0, [uuidstring length])];
    if ([regex numberOfMatchesInString:uuidstring options:0 range:NSMakeRange(0, [uuidstring length])] == 1) {
        return YES;
    }
    return NO;
}
-(BOOL)isValidMajorOrMinor:(NSString *)majororminor {   // 判斷Major或Minor是否有效.self
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *majororminorString = [NSCharacterSet characterSetWithCharactersInString:majororminor];
    if ([set isSupersetOfSet:majororminorString]) {    // 有效.
        return YES;
    }
    return NO;
}
-(void)startAnimationButtonShow:(BOOL)enable {    // 按鈕動畫效果.self
    self.animationEnable = enable;
    [UIView animateWithDuration:0.7 animations:^{
        self.view1LabelShow.transform = CGAffineTransformMakeScale(1.5, 1.5);  // 縮放框架.
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            self.view1LabelShow.transform = CGAffineTransformIdentity;  // 復原框架.
        } completion:^(BOOL finished){
            if (self.animationEnable) {
                [self startAnimationButtonShow:YES];
            } else {
                [self.view1LabelShow.layer removeAllAnimations];
            }
            
        }];
    }];
}
-(void)appWillBackground {  // app將進入背景.self
    NSLog(@"...appWillBackground");
    if ([peripheralManager isAdvertising]) {    // 正在廣播.
        [self view1ButtonStart:self.view1ButtonStart];
    }    
}

- (IBAction)view1ButtonStart:(UIButton *)sender {
    if ([peripheralManager isAdvertising]) {    // 正在廣播.
        [peripheralManager stopAdvertising];    // 停止廣播.
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        self.view1TextFiledDeviceName.enabled =YES;
        self.view1TextFiledDeviceName.textColor=ColorLightPuprle;
        self.view1TextFiledUUID.enabled =YES;
        self.view1TextFiledUUID.textColor=ColorLightPuprle;
        self.view1TextFiledMajor.enabled =YES;
        self.view1TextFiledMajor.textColor=ColorLightPuprle;
        self.view1TextFiledMinor.enabled =YES;
        self.view1TextFiledMinor.textColor=ColorLightPuprle;
        self.view1LabelBackGround.hidden = YES;
        self.view.backgroundColor = ColorLightBlue;
        [self startAnimationButtonShow:NO];
        
    } else {    // 目前沒有在廣播.
        if (![self.view1TextFiledDeviceName.text isEqual: @""]) {
            NSLog(@".1..Device Name =%@",self.view1TextFiledDeviceName.text);            
        } else {            NSLog(@"...1");            return ;        }
        
        if (![self.view1TextFiledUUID.text isEqual: @""] && [self isValidUUID:self.view1TextFiledUUID.text]) { // 判斷UUID是否有效.
            NSLog(@".2..UUID有效");
        } else {            NSLog(@"...2 UUID 沒有效"); return ;        }
        
        if (![self.view1TextFiledMajor.text isEqual: @""] && [self isValidMajorOrMinor:self.view1TextFiledMajor.text]) {    // 判斷Major或Minor是否有效.
            NSLog(@".3..major= %@",self.view1TextFiledMajor.text);
        } else {            NSLog(@"...3");            return ;        }
        
        if (![self.view1TextFiledMinor.text isEqual: @""] && [self isValidMajorOrMinor:self.view1TextFiledMinor.text]) {    // 判斷Major或Minor是否有效.
            NSLog(@".4..minor= %@",self.view1TextFiledMinor.text);
        } else {            NSLog(@"...4");            return ;        }
        // 以上的判斷都要成立才會執行到這裡.
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:self.view1TextFiledUUID.text];
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[self.view1TextFiledMajor.text integerValue] minor:[self.view1TextFiledMinor.text integerValue] identifier:@"Estimote Beacons"];
        NSMutableDictionary *dict = [region peripheralDataWithMeasuredPower:nil];
        [dict setObject:self.view1TextFiledDeviceName.text forKey:CBAdvertisementDataLocalNameKey];    // 掃描周圍藍芽裝置時所看到的名字.
        [peripheralManager startAdvertising:dict]; // 廣播訊號.
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        self.view1TextFiledDeviceName.enabled =NO;
        self.view1TextFiledDeviceName.textColor=[UIColor blackColor];
        self.view1TextFiledUUID.enabled =NO;
        self.view1TextFiledUUID.textColor=[UIColor blackColor];
        self.view1TextFiledMajor.enabled =NO;
        self.view1TextFiledMajor.textColor=[UIColor blackColor];
        self.view1TextFiledMinor.enabled =NO;
        self.view1TextFiledMinor.textColor=[UIColor blackColor];
        self.view1LabelBackGround.hidden = NO;
        self.view.backgroundColor = [UIColor blackColor];
        [self resignFirstResponder];    // 收起鍵盤.
        [self animationEnd:sender];
        [self startAnimationButtonShow:YES];    // 按鈕動畫效果.
    }
}

- (IBAction)animationStart:(UIButton *)sender { // touch down
    if (![peripheralManager isAdvertising]) {    // 尚未在廣播.
        [UIView animateWithDuration:0.75 animations:^{
            sender.backgroundColor = ColorLightPuprle;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.transform = CGAffineTransformMakeScale(0.9, 0.9);  // 縮放框架.
        } completion:nil];
    }
}

- (IBAction)animationEnd:(UIButton *)sender {
    if (![peripheralManager isAdvertising]) {    // 尚未在廣播.
        [UIView animateWithDuration:0.25 animations:^{
            sender.backgroundColor = [UIColor clearColor];
            [sender setTitleColor:ColorLightPuprle forState:UIControlStateNormal];
            sender.transform = CGAffineTransformIdentity;  // 復原框架.
        } completion:nil];
    }    
}
#pragma CBPeripheralManagerDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    //[textField resignFirstResponder];    // 收起鍵盤.
    [self.view1TextFiledDeviceName resignFirstResponder];
    [self.view1TextFiledUUID resignFirstResponder];
    [self.view1TextFiledMajor resignFirstResponder];
    [self.view1TextFiledMinor resignFirstResponder];
    NSLog(@"...return");
    return  YES;
}

#pragma CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {    // 判斷藍芽是否開啟,或者是不是藍芽4.0.
        NSLog(@"... 電源尚未開啟");
        self.view1LabelMessage.alpha = 0.1;
        self.view1LabelMessage.hidden = NO;
        [UIView animateWithDuration:0.75 animations:^{
            self.view1LabelMessage.alpha = 1.0;
        } completion:^(BOOL finished){
            self.view1ButtonStart.enabled = NO; // 關閉按鈕.
        }];
        return ;
    } else {
        NSLog(@"... 準備啟動");
        peripheral.delegate = self; // 代理人為自己.
        [UIView animateWithDuration:0.75 animations:^{
            self.view1LabelMessage.alpha = 0.1;
        } completion:^(BOOL finished){
            self.view1LabelMessage.hidden = YES;
            self.view1ButtonStart.enabled = YES;    // 啟用按鈕.
        }];
    }
}

@end
