//
//  HttpProcessEngine.m
//
//  Created by 陈君 on 14-1-24.
//  Copyright (c) 2014年 lixd. All rights reserved.
//

#import "HttpProcessEngine.h"
#import <AFNetworking.h>
static HttpProcessEngine *httpEngine = nil;

@interface HttpProcessEngine ()
@end

@implementation HttpProcessEngine

#pragma mark - Base Function
#pragma mark -

+(instancetype)shareHttpEngine{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpEngine = [[[self class] alloc] init];
    });
    return httpEngine;
}

-(void)sendURLString:(NSString*)sendUrlString
       processMethod:(HTTPSendMethodType)sendMethod
          parameters:(NSDictionary *)params
        successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
        failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks{
    
    NSLog(@"%@",sendUrlString);
    switch (sendMethod) {
        case HTTPSendMethodType_GET:
            [self httpEngineWithGetMethd:self sendURLString:sendUrlString parameters:params successJsonRequestBlocks:successBlocks failedJsonRequestBlocks:failedBlocks];
            break;
            
        default:
            [self httpEngineWithPostMethd:self sendURLString:sendUrlString parameters:params successJsonRequestBlocks:successBlocks failedJsonRequestBlocks:failedBlocks];
            break;
    }
    
}

- (void)multiPartSendURLString:(NSString *)sendUrlString
                    parameters:(NSDictionary *)parameters
                    streamData:(NSData *)streamData
                          name:(NSString *)name
      successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
       failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =
    ACCEPTABLE_CONTENT_MIMETYPES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *postParams = [self p_transformPostParameters:parameters];
    
    [manager POST:sendUrlString parameters:postParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:streamData name:@"avatr_name" fileName:@"head_img.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlocks(task , responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlocks(task , error);
    }];

}

/**
 *  POST send Method
 *
 */
-(void)httpEngineWithPostMethd:(HttpProcessEngine *)engine
                 sendURLString:(NSString*)sendUrlString
                    parameters:(NSDictionary *)parameters
        successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
       failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =
    ACCEPTABLE_CONTENT_MIMETYPES;
    manager.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *postParams = [self p_transformPostParameters:parameters];
    
    [manager POST:sendUrlString parameters:postParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlocks(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlocks(task,error);
    }];
    
}


/**
 *  Get send Method
 *
 */
-(void)httpEngineWithGetMethd:(HttpProcessEngine *)engine
                       sendURLString:(NSString*)sendUrlString
                    parameters:(NSDictionary *)parameters
      successJsonRequestBlocks:(SuccessJsonRequestBlocks)successBlocks
       failedJsonRequestBlocks:(FailedJsonRequestBlocks)failedBlocks{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =
    ACCEPTABLE_CONTENT_MIMETYPES;
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSMutableDictionary *postParams = [self p_transformPostParameters:parameters];
    [manager GET:sendUrlString parameters:postParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlocks(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlocks(task,error);
    }];

}

- (NSMutableDictionary *)p_transformPostParameters:(NSDictionary *)params
{
    NSMutableDictionary *retParams = [NSMutableDictionary new];
    for(int i=0; i<params.count; i++)
    {
        NSString *key = params.allKeys[i];
        NSString *value = params[key];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]){
            value = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:value options:0 error:NULL] encoding:NSUTF8StringEncoding];
        }

        [retParams setObject:value forKey:key];
    }
    return retParams;
}


@end
