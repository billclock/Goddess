//
//  HttpProcessEngine.h
//  QuestionBank
//
//  Created by 陈君 on 14-1-24.
//  Copyright (c) 2014年 陈君. All rights reserved.
//
#import "Config.h"
#import <Foundation/Foundation.h>
//#import <AFHTTPRequestOperationManager.h>

typedef enum _HTTPSendMethodType{
    HTTPSendMethodType_GET = 0,
    HTTPSendMethodType_POST = 1
}HTTPSendMethodType;

typedef void (^SuccessJsonRequestBlocks)(NSURLSessionDataTask * task, id responseObject);
typedef void (^FailedJsonRequestBlocks)(NSURLSessionDataTask * task, NSError *error);

@interface HttpProcessEngine : NSObject


/**
 *  封装 http 请求
 *
 *  @param engine        HttpProcessEngine 实例
 *  @param sendUrl       url 地址
 *  @param sendMethod    请求方式 POST OR GET
 *  @param params        请求参数
 *  @param successBlocks 成功 block
 *  @param failedBlocks  失败 block
 */
+(instancetype)shareHttpEngine;


-(void)sendURLString:(NSString*)sendUrlString
            processMethod:(HTTPSendMethodType)sendMethod
            parameters:(NSDictionary *)params
            successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
            failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks;


/**
 *  Multipart  POST 请求
 *
 *  @param sendUrlString URL地址
 *  @param sendMethod    请求方式
 *  @param params        参数
 *  @param successBlocks
 *  @param failedBlocks
 */
- (void)multiPartSendURLString:(NSString *)sendUrlString
                    parameters:(NSDictionary *)params
                    streamData:(NSData *)streamData
                          name:(NSString *)name
      successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
       failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks;
@end

