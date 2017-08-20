//
//  ViewController.h
//  Service
//
//  Created by Kleinsche on 2017/7/8.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>

@interface ViewController : NSViewController

@property(nonatomic,assign) int client_socket;

@property (strong) IBOutlet NSTextField *showText;
@property (strong) IBOutlet NSTextField *inputText;






@end

