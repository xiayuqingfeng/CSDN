//
//  ViewController.m
//  CSDN
//
//  Created by xiayupeng on 15/8/16.
//  Copyright (c) 2015年 xiayupeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *httpStr;
    NSArray *urlStr;
    NSMutableArray *refreshIdArray;
}
@end

@implementation ViewController
- (IBAction)Go:(id)sender {
    if (urlStr.count > 0) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStr[0]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
        refreshIdArray = [NSMutableArray arrayWithCapacity:0];
    }
}
- (IBAction)clearIdArray:(id)sender {
    NSArray *clearArray = [NSArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clearArray forKey:@"URL"];
    [defaults synchronize];
    _readData.text = @"现有博客ID数组：";
    _idCount.text = @"0";
    urlStr = [NSArray array];
    [refreshIdArray removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    urlStr= [NSMutableArray arrayWithArray:[defaults arrayForKey:@"URL"]];
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStr];
    _readData.editable = NO;
    _idCount.text = [NSString stringWithFormat:@"%ld",urlStr.count];
    
    _aWeb.delegate = self;
    httpStr = @"http://blog.csdn.net/u012460084/article/details/";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    urlStr= [NSMutableArray arrayWithArray:[defaults arrayForKey:@"URL"]];
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStr];
    _idCount.text = [NSString stringWithFormat:@"%ld",urlStr.count];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([requestUrl containsString:@"details/"]) {
        NSString *rangStr = @"details/";
        NSRange rang =  [requestUrl rangeOfString:rangStr];
        NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
        if (idStr.length == 8) {
            if (![refreshIdArray containsObject:idStr]) {
                [refreshIdArray addObject:idStr];
                _readData.text = [NSString stringWithFormat:@"%@",refreshIdArray];
            }
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *requestUrl = [NSString stringWithFormat:@"%@",[webView.request URL]];
    NSString *rangStr = @"details/";
    NSRange rang =  [requestUrl rangeOfString:rangStr];
    NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
    NSInteger index = [urlStr indexOfObject:idStr];
    if (index < urlStr.count-1) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStr[index+1]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSString *requestUrl = [NSString stringWithFormat:@"%@",[webView.request URL]];
//    NSString *rangStr = @"details/";
//    NSRange rang =  [requestUrl rangeOfString:rangStr];
//    NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
//    NSInteger index = [urlStr indexOfObject:idStr];
//    if (index < urlStr.count-1) {
//        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStr[index+1]]]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
//        [_aWeb loadRequest:request];
//    }
}

@end
