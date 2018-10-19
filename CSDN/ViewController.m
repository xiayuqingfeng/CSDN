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
    NSTimer *aTimer;
    NSInteger aIndex;
}
@end
#define arc_block(x) __block typeof(x) __weak weak_##x = x
#define EQUAL(a, b)	[a isEqual:b]
@implementation ViewController
- (IBAction)beign:(id)sender {
    aIndex = 0;
    
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
}
- (IBAction)stop:(id)sender {
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }else{
        aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
    }
}

- (void)Timered:(NSTimer*)timer {
    if (urlStrArray.count > aIndex) {
        NSURL *aNSURL = [NSURL URLWithString:[httpStr stringByAppendingString:[NSString stringWithFormat:@"%@",urlStrArray[aIndex]]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:aNSURL];
        [_aWeb loadRequest:request];
        
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

@end
