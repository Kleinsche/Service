//
//  ViewController.m
//  Service
//
//  Created by Kleinsche on 2017/7/8.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

/* socket服务器
 1.创建socket
 2.绑定地址和端口
 3.监听客户端的连接
 4.接受客户端的连接
 5.通讯(接收消息和发送消息)
 6.关闭scoket
 */

- (IBAction)sendClick:(NSButton *)sender {
    NSString *strInput = self.inputText.stringValue;
    char *buf[1024] = {0};
    char *p1 = (char*)buf;
    p1 = [strInput cStringUsingEncoding:NSUTF8StringEncoding];
    send(self.client_socket, p1, 1024, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //1.创建socket
    int service_socket =  socket(AF_INET, SOCK_STREAM, 0);//SOCK_STREAM有连接
    if (service_socket == -1) {
        NSLog(@"创建TCP服务器失败");
    } else {
        //2.绑定地址和端口号
        struct sockaddr_in server_addr;
        server_addr.sin_len = sizeof(struct sockaddr_in);
        server_addr.sin_family = AF_INET;//Address families AF_INET互联网地址簇
        server_addr.sin_port = htons(1234);//转换成网络字节序 0x12340000高位在前 00003412
        server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        bzero(&(server_addr.sin_zero), 8);
        
        //绑定
        int bind_result = bind(service_socket,(struct sockaddr *)&server_addr, sizeof(server_addr));
        
        if (bind_result == -1) {
            NSLog(@"绑定端口失败");
        }else{
            NSLog(@"绑定端口成功");
            //3.监听客户端的连接
            if (listen(service_socket, 5) == -1) {
                NSLog(@"监听失败");
            }else{
                
                dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue1, ^{
                    
                    while (true) {
                        //4.接受客户端连接
                        struct sockaddr_in client_address;
                        socklen_t address_len;
                        int client_socket = accept(service_socket, (struct sockaddr *)&client_address, &address_len);//accept阻塞函数
                        
                        if (client_socket == -1) {
                            NSLog(@"客户端连接失败");
                        }else{
                            NSLog(@"建立连接");
                            self.client_socket = client_socket;
                            while (true) {
                                //5.接收客户端数据
                                char *buf[1024] = {0};//缓冲区
                                long iReturn = recv(client_socket, buf, 1024, 0);//接收数据放进缓冲区
                                if (iReturn > 0) {
                                    NSLog(@"收到数据");
                                    NSString* string = [NSString stringWithCString:(char*)buf encoding:NSUTF8StringEncoding];
                                    
                                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                                        //显示到界面
                                        self.showText.stringValue = string;
                                    }];
                                }else if (iReturn == -1){
                                    
                                    NSLog(@"与客户端连接断开");
//                                    close(client_socket);
                                    break;
                                    
                                }
                                
                                
                            }
                            
                        }
//                        close(client_socket);
                    }
                    
                    
                });
                
                
            }
            
        }
        
    }
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
