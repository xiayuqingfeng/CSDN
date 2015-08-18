//
//  ViewController.h
//  CSDN
//
//  Created by xiayupeng on 15/8/16.
//  Copyright (c) 2015年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *Go;
@property (weak, nonatomic) IBOutlet UIWebView *aWeb;
@property (weak, nonatomic) IBOutlet UILabel *idCount;
@property (strong, nonatomic) IBOutlet UILabel *refreshShow;
@property (weak, nonatomic) IBOutlet UITextView *readData;

@end

