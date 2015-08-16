//
//  ViewController.h
//  CSDN
//
//  Created by xiayupeng on 15/8/16.
//  Copyright (c) 2015年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *Go;

@property (weak, nonatomic) IBOutlet UIWebView *aWeb;
@property (weak, nonatomic) IBOutlet UILabel *idCount;
@property (weak, nonatomic) IBOutlet UITextView *readData;

@end

