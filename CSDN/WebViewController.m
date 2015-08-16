//
//  WebViewController.m
//  CSDN
//
//  Created by xiayupeng on 15/8/16.
//  Copyright (c) 2015年 xiayupeng. All rights reserved.
//

#import "WebViewController.h"
@interface WebViewController ()
{
    NSString *httpStr;
    NSString *containsStr;
    NSMutableArray *urlIdArray;
}
@end

@implementation WebViewController
- (IBAction)pop:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:urlIdArray forKey:@"UrlArray"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)webPageBack:(id)sender {
    [_aWeb goBack];
}

- (void)dealloc{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    void (^printXAndY)( NSString * ) = ^( NSString *title){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    };
  
    urlIdArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    httpStr = [defaults stringForKey:@"httpStr"];
    containsStr = [defaults stringForKey:@"containsStr"];
    NSArray *defaultsArray = [defaults arrayForKey:@"UrlArray"];
    
    NSString *title;
    if (httpStr.length < 1 && containsStr.length < 1) {
        title = @"您还没有设置网址和关键字段";
        printXAndY(title);
    }else if (httpStr.length < 1) {
        title = @"您还没有设置网址";
        printXAndY(title);
    }else if (containsStr.length < 1) {
        title = @"您还没有设置关键字段";
        printXAndY(title);
    }
    
    if (defaultsArray.count < 1) {
        NSArray *ary = [[NSArray alloc] init];
        [defaults setObject:ary forKey:@"UrlArray"];
        [defaults synchronize];
    }else{
        urlIdArray = [NSMutableArray arrayWithArray:defaultsArray];
    }
    _aWeb.delegate = self;
    NSURL *aNSURL = [NSURL URLWithString:httpStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
    [_aWeb loadRequest:request];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (httpStr.length > 0 && containsStr.length > 0) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
        if ([requestUrl containsString:containsStr]) {
            NSRange rang =  [requestUrl rangeOfString:containsStr];
            NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
            if (idStr.length == 8) {
                if (![urlIdArray containsObject:idStr]) {
                    [urlIdArray addObject:idStr];
                    NSLog(@"askdbaksjd------%@-------%@",idStr,urlIdArray);
                }
            }
        }
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
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
