//
//  ViewController.m
//  Using a delegate with a URL session data task
//
//  Created by 宋千 on 2017/11/7.
//  Copyright © 2017年 宋千. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
    self.receivedData = [NSMutableData data];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:nil];
    NSURLSessionTask *task = [self.session dataTaskWithURL:url];

    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential * _Nullable credential))completionHandler {


}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {

}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {



}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
 completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {

    NSHTTPURLResponse *httpRespons = (NSHTTPURLResponse *)response;
    if (!(httpRespons.statusCode == 200 &&
          (
           [httpRespons.MIMEType isEqualToString:@"text/html"] ||
           [httpRespons.MIMEType isEqualToString:@"text/plain"]))) {
              completionHandler(NSURLSessionResponseCancel);
              return;
          }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       if (error) {
                           NSLog(@"Error:%@", error.localizedDescription);
                       }
                       else if (self.receivedData) {
                           NSLog(@"\nreceivedData:\n%@",[[NSString alloc] initWithData:self.receivedData
                                                                          encoding:NSUTF8StringEncoding]);
                       }
                   });
    
}


@end

































