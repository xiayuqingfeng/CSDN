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
    NSString *containsStr;
    NSArray *urlStrArray;
    NSMutableArray *refreshIdArray;
}
@end

@implementation ViewController
- (IBAction)Go:(id)sender {
    void (^printXAndY)( NSString * ) = ^( NSString *title){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    
    NSString *title;
    if (urlStrArray.count > 0) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
        refreshIdArray = [NSMutableArray arrayWithCapacity:0];
        
        if (httpStr.length < 1) {
            title = @"您还没有设置网址";
            printXAndY(title);
        }
    }else{
        title = @"id数组为空";
        printXAndY(title);
    }
}
- (IBAction)clearIdArray:(id)sender {
    NSArray *clearArray = [NSArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clearArray forKey:@"UrlArray"];
    [defaults synchronize];
    _readData.text = @"现有博客ID数组：";
    _idCount.text = @"0条";
    urlStrArray = [NSArray array];
    [refreshIdArray removeAllObjects];
}
- (IBAction)refresh:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    httpStr = [defaults stringForKey:@"httpStr"];
    NSURL *aNSURL = [NSURL URLWithString:httpStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
    [_aWeb loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    httpStr = [defaults stringForKey:@"httpStr"];
    containsStr = [defaults stringForKey:@"containsStr"];
    urlStrArray= [NSMutableArray arrayWithArray:[defaults arrayForKey:@"UrlArray"]];
    
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStrArray];
    _readData.editable = NO;
    _idCount.text = [NSString stringWithFormat:@"%ld条",(unsigned long)urlStrArray.count];
    
    _aWeb.delegate = self;
    NSURL *aNSURL = [NSURL URLWithString:httpStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
    [_aWeb loadRequest:request];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    urlStrArray= [NSMutableArray arrayWithArray:[defaults arrayForKey:@"UrlArray"]];
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStrArray];
    _idCount.text = [NSString stringWithFormat:@"%ld条",(unsigned long)urlStrArray.count];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        return NO;
    }
    
    if (urlStrArray.count > 0 && httpStr.length > 0 && containsStr.length > 0) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
        if ([requestUrl containsString:containsStr]) {
            NSRange rang =  [requestUrl rangeOfString:containsStr];
            NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
            if (idStr.length == 8) {
                if (![refreshIdArray containsObject:requestUrl]) {
                    [refreshIdArray addObject:requestUrl];
                    _readData.text = [NSString stringWithFormat:@"%@",refreshIdArray];
                }
            }
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *requestUrl = [NSString stringWithFormat:@"%@",[webView.request URL]];
    if (urlStrArray.count > 0 && httpStr.length > 0 && containsStr.length > 0 && [requestUrl containsString:containsStr]) {
        NSRange rang =  [requestUrl rangeOfString:containsStr];
        NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
        NSInteger index = [urlStrArray indexOfObject:idStr];
        _refreshShow.text = [NSString stringWithFormat:@"%ld条",(long)index+1];
        if (index < urlStrArray.count-1) {
            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
            [_aWeb loadRequest:request];
        }
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSString *requestUrl = [NSString stringWithFormat:@"%@",[webView.request URL]];
    if (urlStrArray.count > 0 && httpStr.length > 0 && containsStr.length > 0 && [requestUrl containsString:containsStr]) {
        NSRange rang =  [requestUrl rangeOfString:containsStr];
        NSString *idStr = [requestUrl substringFromIndex:rang.location + rang.length];
        NSInteger index = [urlStrArray indexOfObject:idStr];
        _refreshShow.text = [NSString stringWithFormat:@"%ld条",(long)index+1];
        if (index < urlStrArray.count-1) {
            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
            [_aWeb loadRequest:request];
        }
    }
}

@end
