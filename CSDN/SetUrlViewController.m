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
- (IBAction)useOneBut:(id)sender {
    
}
- (IBAction)setTowBut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_textViewTow.text forKey:@"containsStr"];
    [defaults synchronize];
}
- (IBAction)useTowBut:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    httpStr = [defaults stringForKey:@"httpStr"];
    containsStr = [defaults stringForKey:@"containsStr"];
    
    if (httpStr.length > 0) {
        _textViewOne.text = httpStr;
    }
    if (containsStr.length > 0) {
        _textViewTow.text = containsStr;
    }
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
