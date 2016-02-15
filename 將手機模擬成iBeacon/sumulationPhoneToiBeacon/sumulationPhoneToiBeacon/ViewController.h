//
//  ViewController.h
//  sumulationPhoneToiBeacon
//
//  Created by Mac on 2015/10/10.
//  Copyright © 2015年 Rothschild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h> // 核心藍芽.
#import <CoreLocation/CoreLocation.h>   // 核心位置.

@interface ViewController : UIViewController <CBPeripheralManagerDelegate,UITextFieldDelegate>
// CBPeripheralManagerDelegate 外圍設備管理代理.
{
    CBPeripheralManager *peripheralManager;
}

@property (weak, nonatomic) IBOutlet UITextField *view1TextFiledDeviceName;
@property (weak, nonatomic) IBOutlet UITextField *view1TextFiledUUID;
@property (weak, nonatomic) IBOutlet UITextField *view1TextFiledMajor;
@property (weak, nonatomic) IBOutlet UITextField *view1TextFiledMinor;
@property (weak, nonatomic) IBOutlet UIButton *view1ButtonStart;
@property (weak, nonatomic) IBOutlet UILabel *view1LabelMessage;
@property (weak, nonatomic) IBOutlet UILabel *view1LabelBackGround;
@property (weak, nonatomic) IBOutlet UILabel *view1LabelShow;

- (IBAction)view1ButtonStart:(UIButton *)sender;

- (IBAction)animationStart:(UIButton *)sender;

- (IBAction)animationEnd:(UIButton *)sender;

@end

