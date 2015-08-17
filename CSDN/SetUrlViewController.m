//
//  SetUrlViewController.m
//  CSDN
//
//  Created by xiayupeng on 15/8/16.
//  Copyright (c) 2015年 xiayupeng. All rights reserved.
//

#import "SetUrlViewController.h"

@interface SetUrlViewController ()
{
    NSString *httpStr;
    NSString *containsStr;
}
@end

@implementation SetUrlViewController
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setOneBut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_textViewOne.text forKey:@"httpStr"];
    [defaults synchronize];
}

- (IBAction)setTowBut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_textViewTow.text forKey:@"httpList"];
    [defaults synchronize];
}

- (IBAction)setThreeBut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_textViewThree.text forKey:@"containsStr"];
    [defaults synchronize];
}


- (IBAction)useLongIdArray:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *longIdArray = [defaults arrayForKey:@"longIdArray"];
    [defaults setObject:longIdArray forKey:@"UrlArray"];
    [defaults synchronize];
}
- (IBAction)clearLongIdArray:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *longIdArray = [NSArray array];
    [defaults setObject:longIdArray forKey:@"longIdArray"];
    [defaults synchronize];
    
    _longIdArrayTextView.text = @"最长数组为空！！！";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    httpStr = [defaults stringForKey:@"httpStr"];
    containsStr = [defaults stringForKey:@"containsStr"];
    NSArray *longIdArray = [defaults arrayForKey:@"longIdArray"];
    
    if (httpStr.length > 0) {
        _textViewOne.text = httpStr;
    }
    if (containsStr.length > 0) {
        _textViewTow.text = containsStr;
    }
    if (longIdArray.count > 0) {
        _longIdArrayTextView.text = [NSString stringWithFormat:@"最长id数组，有%ld条\n%@",(long)longIdArray.count,longIdArray];
    }
    _longIdArrayTextView.editable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
