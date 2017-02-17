//
//  XTMultipartPostRequest.m
//  Forg
//
//  Created by NemoLee on 14/11/17.
//  Copyright (c) 2014年 Nemo. All rights reserved.
//

#import "NSURLSessionTask+MultipartFormData.h"

static NSString * boundary = @"0xKhTmLbOuNdArY";

@interface XTMultipartPostRequestHTTPBody : NSObject<XTMultipartPostBuilder>
@property (nonatomic, strong) NSMutableData * bodyData;
@property (nonatomic, strong) NSMutableString * bodyDescription;
- (void)appendingBreakMark;
- (void)appendingEndMark;
- (void)appendingParameter:(id)parameter forKey:(NSString *)key;
- (void)appendingReturn;
@end

@implementation NSURLSessionTask (XTMultipartPost)
+ (NSURLSessionTask *)asynAtPort:(NSString *)address withParameters:(NSDictionary *)parameters multipartBuilder:(void(^)(id<XTMultipartPostBuilder> fileBody))mutipartBuilder completion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))comlpetion
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    XTMultipartPostRequestHTTPBody * body = [XTMultipartPostRequestHTTPBody new];
    
    for (NSString * key in parameters.allKeys) {
        [body appendingParameter:parameters[key] forKey:key];
    }
    if (mutipartBuilder) {
        mutipartBuilder(body);
    }
    [body appendingEndMark];
    
    NSString * HttpContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:HttpContentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)body.bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body.bodyData];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",body.bodyDescription);
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (comlpetion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                comlpetion(data, response, error);
            });
        }
    }];
    [task resume];
    return task;
}

@end



@implementation XTMultipartPostRequestHTTPBody

+ (instancetype)new
{
    XTMultipartPostRequestHTTPBody * body = [super new];
    body.bodyDescription = [@"" mutableCopy];
    body.bodyData = [NSMutableData data];
    return body;
}

- (void)appendingReturn
{
    [self appendingString:@"\r\n"];
}

- (void)appendingString:(NSString *)string;
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self.bodyData appendData: data];
    [self.bodyDescription appendString:string];
}
- (void)appendingBreakMark
{
    [self appendingString:[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]];
}

- (void)appendingEndMark
{
    [self appendingString:[NSString stringWithFormat:@"\r\n--%@--",boundary]];
}

- (void)appendingParameter:(id)parameter forKey:(NSString *)key
{
    [self appendingBreakMark];
    [self appendingString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key]];
    [self appendingString:[NSString stringWithFormat:@"%@",parameter]];
//    [self appendingString:[NSString stringWithFormat:@"%@\r\n",parameter]];

}

- (void)appendFileData:(NSData *)data fileName:(NSString *)fileName parameterKey:(NSString *)key
{
    [self appendingBreakMark];
    [self appendingString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,fileName]];
    [self appendingString:@"Content-Type: application/octet-stream\r\n\r\n"];
    [self.bodyData appendData:data];
    [self.bodyDescription appendString:@"(fileData)\r\n"];
}

@end
