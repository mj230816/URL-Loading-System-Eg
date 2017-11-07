//
//  ViewController.m
//  Creating a completion handler to receive data-loading results
//
//  Created by 宋千 on 2017/11/7.
//  Copyright © 2017年 宋千. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/NSURLResponse.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
    NSURLSessionTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         
         // error
         if (error) {
             dispatch_queue_t queue = dispatch_get_main_queue();
             dispatch_async(queue, ^{
                 self.textView.text = [NSString stringWithFormat:@"Error:%@", error.localizedDescription];
             });
             
             return;
         }
         
         // data
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode != 200) {
             
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                self.textView.text = @"Server Error";
                            });
             return;
         }
         
         if ([httpResponse.MIMEType isEqualToString:@"text/html"]  ||
             [httpResponse.MIMEType isEqualToString:@"text/plain"]) {
             
             NSString *string = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
             
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                self.textView.text = string;
                            });
         }
     }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
