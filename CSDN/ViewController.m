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
    
    BOOL refreshTimerBool;
}
@end
#define arc_block(x) __block typeof(x) __weak weak_##x = x
#define EQUAL(a, b)	[a isEqual:b]
@implementation ViewController
- (IBAction)Go:(id)sender {
    refreshTimerBool = NO;

    [self requestFirstUrl];
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
- (IBAction)timeRefresh:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (refreshTimerBool) {
        [but setTitle:@"循环开始" forState:UIControlStateNormal];
        refreshTimerBool = NO;
        [_aWeb stopLoading];
    }else{
        [but setTitle:@"循环新中" forState:UIControlStateNormal];
        refreshTimerBool = YES;
        [self requestFirstUrl];
    }
}
- (void)requestFirstUrl{

    void (^printXAndY)( NSString * ) = ^( NSString *title){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    
    NSString *title;
    if (urlStrArray.count > 0) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
        NSLog(@"asdakjhsd899=-----%@",aNSURL);
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arc_block(self);
    // Do any additional setup after loading the view, typically from a nib.
    refreshTimerBool = NO;
    
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
    
    
#ifdef DEBUG
    NSString *strName = [[UIDevice currentDevice] name];
    if (!EQUAL(strName, @"iPhone Simulator")) {
        [self firTestPackageUpdatePrompt];
    }
#endif
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

#pragma mark <-----fir_测试包更新提示----->
- (void)firTestPackageUpdatePrompt{
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSInteger buildValue = [build integerValue];
    NSURL *url = [NSURL URLWithString:@"http://fir.im/api/v2/app/version/55d1e4f4e75e2d31f9000027"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *firBuild = dict[@"version"];
            NSLog(@"asdasd----%@",firBuild);
            NSInteger firBuildValue = [firBuild integerValue];
            if (firBuildValue > buildValue) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"🌞🌞新包测试🌞🌞\n\n%@年%@月%@号第%@次打包",[firBuild substringWithRange:NSMakeRange(0, 4)],[firBuild substringWithRange:NSMakeRange(4, 2)],[firBuild substringWithRange:NSMakeRange(6, 2)],[firBuild substringFromIndex:8]]  delegate:self cancelButtonTitle:@"更新" destructiveButtonTitle:@"暂不更新" otherButtonTitles:nil];
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            }
        }
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //        exit(0);
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/1c9y"]];
    }
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
        
        if (refreshTimerBool) {
            if (index < urlStrArray.count-1) {
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
            }else{
                [self performSelector:@selector(requestFirstUrl) withObject:nil afterDelay:5.0f];
//                [self requestFirstUrl];
            }
        }else{
            if (index < urlStrArray.count-1) {
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
            }else{
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
                NSLog(@"asdakjhsd899=-----%@",aNSURL);
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
                refreshIdArray = [NSMutableArray arrayWithCapacity:0];
            }
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
        
        if (refreshTimerBool) {
            if (index < urlStrArray.count-1) {
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
            }else{
                [self performSelector:@selector(requestFirstUrl) withObject:nil afterDelay:5.0f];
                
            }
        }else{
            if (index < urlStrArray.count-1) {
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[index+1]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
            }else{
                NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[0]]]];
                NSLog(@"asdakjhsd899=-----%@",aNSURL);
                NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
                [_aWeb loadRequest:request];
                refreshIdArray = [NSMutableArray arrayWithCapacity:0];
            }
        }
        
    }
}

@end
