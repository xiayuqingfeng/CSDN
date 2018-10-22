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
    NSTimer *aTimer;
    NSInteger aIndex;
}
@end
#define arc_block(x)    __block typeof(x) __weak weak_##x = x
#define EQUAL(a, b)     [a isEqual:b]
#define aInterval       1.5
@implementation ViewController
- (IBAction)beign:(id)sender {
    aIndex = 0;
    
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:aInterval target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
}
- (IBAction)stop:(id)sender {
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }else{
        aTimer = [NSTimer scheduledTimerWithTimeInterval:aInterval target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
    }
    
    if(aTimer){
        [_stop setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [_stop setTitle:@"开始" forState:UIControlStateNormal];
    }
}

- (void)Timered:(NSTimer*)timer {
    if (urlStrArray.count > aIndex) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[aIndex]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
        
        _refreshShow.text = [NSString stringWithFormat:@"%ld条",aIndex+1];

        _readData.text = [NSString stringWithFormat:@"%@",[[[urlStrArray subarrayWithRange:NSMakeRange(0, aIndex+1)] reverseObjectEnumerator] allObjects]];
        [_readData setContentOffset:CGPointMake(0, 0)];
        
        if (aIndex < urlStrArray.count-1) {
            aIndex++;
        }else{
            aIndex = 0;
        }
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
}

- (void)dealloc {
    _aWeb.delegate = nil;
    [_aWeb stopLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aWeb.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    urlStrArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"UrlArray"]];
    httpStr = @"https://blog.csdn.net/u012460084/article/details/";
    containsStr = @"article/details/";
    
    _readData.editable = NO;
    _readData.text = [NSString stringWithFormat:@"现有博客ID数组：\n%@",urlStrArray];
    _idCount.text = [NSString stringWithFormat:@"%ld条",(unsigned long)urlStrArray.count];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
@end
