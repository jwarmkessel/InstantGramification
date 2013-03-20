/*
     File: DetailViewController.m
 Abstract: The secondary detailed view controller for this app.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "DetailViewController.h"
#import <ASIHTTPRequest.h>

@interface DetailViewController ()
@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@end

@implementation DetailViewController

- (void)dealloc {
    [self.loadingMask release], self.loadingMask = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"show the loading mask");
//    self.loadingMask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.loadingMask.backgroundColor = [UIColor blackColor];
//    self.loadingMask.alpha = 0.5;
//    UILabel *loadingMaskLbl = [[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
//    loadingMaskLbl.alpha = 1.0;
//    [self.loadingMask addSubview:loadingMaskLbl];
//    loadingMaskLbl.text =@"loading";
//    loadingMaskLbl.textColor = [UIColor whiteColor];
//    loadingMaskLbl.backgroundColor = [UIColor blackColor];
//    [loadingMaskLbl setCenter:self.loadingMask.center];
//    loadingMaskLbl.textAlignment = UITextAlignmentCenter;
//    
//    [self.view addSubview:self.loadingMask];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.detailImage;
//    dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(imageQueue, ^{
//        NSURL *url = [NSURL URLWithString:self.imageURL];
//        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
//        NSError *error = [request error];
//        [request startSynchronous];
//        
//        if (!error) {
//            NSMutableData *response = [request rawResponseData];
//            self.imageView.image = [UIImage imageWithData:response];
//            
//            [UIView animateWithDuration:0.3
//                             animations:^(void){
//                                 self.loadingMask.alpha = 0.0;
//                             }
//                             completion:^(BOOL finished){
//                                 NSLog(@"Loading mask finished");
//                                 [self.loadingMask retain];
//                                 [self.loadingMask removeFromSuperview];
//                             }
//             ];
//        }
//    });
}

@end
