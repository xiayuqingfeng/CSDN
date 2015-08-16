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
    NSMutableArray *urlIdArray;
}
@end

@implementation WebViewController
- (IBAction)pop:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:urlIdArray forKey:@"URL"];
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
    urlIdArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *defaultsArray = [defaults arrayForKey:@"URL"];
    if (defaultsArray.count < 1) {
        NSArray *ary = [[NSArray alloc] init];
        [defaults setObject:ary forKey:@"URL"];
    }else{
        urlIdArray = [NSMutableArray arrayWithArray:defaultsArray];
    }
    _aWeb.delegate = self;
    NSURL *aNSURL = [NSURL URLWithString:@"http://blog.csdn.net/u012460084/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
    [_aWeb loadRequest:request];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([requestUrl containsString:@"details/"]) {
        NSString *rangStr = @"details/";
        NSRange rang =  [requestUrl rangeOfString:rangStr];
        NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
        if (idStr.length == 8) {
            if (![urlIdArray containsObject:idStr]) {
                [urlIdArray addObject:idStr];
                NSLog(@"askdbaksjd------%@-------%@",idStr,urlIdArray);
            }
        }
    }
    return YES;
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
