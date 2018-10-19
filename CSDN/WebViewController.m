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
    NSString *httpListStr;
    NSString *containsStr;
    NSMutableArray *urlIdArray;
}
@end

@implementation WebViewController
- (IBAction)pop:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *longIdArray = [defaults arrayForKey:@"longIdArray"];
    if (longIdArray.count < urlIdArray.count) {
        [defaults setObject:urlIdArray forKey:@"longIdArray"];
    }
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
    httpListStr = [defaults stringForKey:@"httpList"];
    containsStr = [defaults stringForKey:@"containsStr"];
    NSArray *defaultsArray = [defaults arrayForKey:@"UrlArray"];
    NSString *title;
    if (httpListStr.length < 1 && containsStr.length < 1) {
        title = @"您还没有设置网址和关键字段";
        printXAndY(title);
    }else if (httpListStr.length < 1) {
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
    NSURL *aNSURL = [NSURL URLWithString:httpListStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
    [_aWeb loadRequest:request];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (httpListStr.length > 0 && containsStr.length > 0) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
        if ([requestUrl containsString:containsStr]) {
            NSRange rang =  [requestUrl rangeOfString:containsStr];
            NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
            if (idStr.length == 8) {
                if (![urlIdArray containsObject:idStr]) {
                    [urlIdArray addObject:idStr];
                }
            }
        }
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    NSString *currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
    //    NSLog(@"打印网页元素：%@",currentHTML);
    //    NSLog(@"打印网页元素：%ld",currentHTML.length);
    NSString *urlStr = [NSString stringWithFormat:@"(?i)(?<=%@)(\\d*)",containsStr];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlStr options:0 error:nil];
    NSArray *array = [regex matchesInString:currentHTML options:0 range:NSMakeRange(0, [currentHTML length])];
    for (NSTextCheckingResult* b in array){
        NSString *str1 = [currentHTML substringWithRange:b.range];
        if (str1.length == 8) {
            if (![urlIdArray containsObject:str1]) {
                [urlIdArray addObject:str1];
            }
        }
    }
//    NSLog(@"输出:%@------%ld",asd,(unsigned long)asd.count);
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
