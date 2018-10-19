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
#define arc_block(x) __block typeof(x) __weak weak_##x = x
#define EQUAL(a, b)	[a isEqual:b]
@implementation ViewController
- (IBAction)Go:(id)sender {
    [self requestFirstUrl];
}
- (void)requestFirstUrl{
    [_aWeb stopLoading];
    if (urlStrArray.count > 0) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"id数组为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
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

- (void)dealloc {
    _aWeb.delegate = nil;
    [_aWeb stopLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _aWeb.delegate = self;
    
    refreshIdArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    urlStrArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"UrlArray"]];
    httpStr = @"https://blog.csdn.net/u012460084/article/details/";
    containsStr = @"article/details/";
    
    _readData.editable = NO;
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStrArray];
    _idCount.text = [NSString stringWithFormat:@"%ld条",(unsigned long)urlStrArray.count];
    
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
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
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
        NSString *idStr = [requestUrl substringFromIndex:rang.location+rang.length];
        NSInteger index = [urlStrArray indexOfObject:idStr];
        _refreshShow.text = [NSString stringWithFormat:@"%ld条",(long)index+1];
        
        if (index < urlStrArray.count-1) {
            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
            [_aWeb loadRequest:request];
        }else{
            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
            [_aWeb loadRequest:request];
            refreshIdArray = [NSMutableArray arrayWithCapacity:0];
        }
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    _aWeb.delegate = nil;
//    [_aWeb stopLoading];
//    
//    NSString *requestUrl = [NSString stringWithFormat:@"%@",[webView.request URL]];
//    if (urlStrArray.count > 0 && httpStr.length > 0 && containsStr.length > 0 && [requestUrl containsString:containsStr]) {
//        NSRange rang =  [requestUrl rangeOfString:containsStr];
//        NSString *idStr = [requestUrl substringFromIndex:rang.location+rang.length];
//        NSInteger index = [urlStrArray indexOfObject:idStr];
//        
//        if (index < urlStrArray.count-1) {
//            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
//            _aWeb.delegate = self;
//            [_aWeb loadRequest:request];
//        }else{
//            NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
//            _aWeb.delegate = self;
//            [_aWeb loadRequest:request];
//            refreshIdArray = [NSMutableArray arrayWithCapacity:0];
//        }
//    }
}

@end
